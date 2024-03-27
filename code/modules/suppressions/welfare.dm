#define STATUS_EFFECT_WELFARE_SUPPRESSION /datum/status_effect/welfare_damage_resist
#define STATUS_EFFECT_WELFARE_REWARD /datum/status_effect/welfare_reward

// Right now the only core suppression with a proper reward, which is higher spawning stats.
/datum/suppression/welfare
	name = WELFARE_CORE_SUPPRESSION
	desc = "All employees will suffer from decreased resistance to randomly chosen damage types, which change on each meltdown."
	reward_text = "All personnel will be able to avoid death/insanity by instantly healing to certain percentage \
		of either health or sanity each time they reach that point. \
		Amount of health/sanity restored decreases with each activation: 60% - 45% - 30% - 15%."
	run_text = "The core suppression of Welfare department has begun. All personnel will be suffering from decreased damage resistances."
	/// By how much a chosen damage type modifier will be multiplied exactly
	var/damage_mod = 2
	/// How many damage types will be changed
	var/mod_count = 1
	var/list/affected_statuses = list()
	// Multipliers
	var/list/current_resist = list(
		RED_DAMAGE = 1,
		WHITE_DAMAGE = 1,
		BLACK_DAMAGE = 1,
		PALE_DAMAGE = 1,
		)

/datum/suppression/welfare/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(OnJoin))
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		if(H.stat == DEAD)
			continue
		ApplyEffect(H)
	OnMeltdown()

/datum/suppression/welfare/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/datum/status_effect/welfare_damage_resist/S in affected_statuses)
		var/mob/living/carbon/human/H = S.owner
		if(istype(H))
			H.apply_status_effect(STATUS_EFFECT_WELFARE_REWARD)
		QDEL_NULL(S)
	affected_statuses = null
	new /datum/welfare_reward_tracker() // Gives the reward to late-joiners after it ends
	return ..()

// When a new employee spawns in
/datum/suppression/welfare/proc/OnJoin(datum/source, mob/living/L, rank)
	SIGNAL_HANDLER
	if(!ishuman(L))
		return FALSE
	ApplyEffect(L)
	return TRUE

// Choose damage(s) that will be increased and update the status effects
/datum/suppression/welfare/proc/OnMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	var/current_damage_mod = damage_mod
	if(ordeal)
		current_damage_mod = 1.5 // Don't kill everyone too hard during ordeals(Pale Fixer with x3 damage be like...)
		damage_mod = min(4, damage_mod + 0.5) // With each ordeal passing, normal meltdowns will be more difficult
		mod_count = min(3, mod_count + 1) // More damage types get rolled
	var/list/temp_list = current_resist.Copy()
	for(var/R in current_resist) // Reset values
		current_resist[R] = 1
	for(var/i = 1 to mod_count) // Choose random damage types to lower resistances
		var/R = pick(temp_list)
		temp_list -= R
		current_resist[R] = current_damage_mod // Let there be blood
	for(var/datum/status_effect/welfare_damage_resist/S in affected_statuses)
		S.UpdateResist()

// Adds or updates the status effect on a certain mob
/datum/suppression/welfare/proc/ApplyEffect(mob/living/carbon/human/H)
	var/datum/status_effect/welfare_damage_resist/S = H.has_status_effect(STATUS_EFFECT_WELFARE_SUPPRESSION)
	if(istype(S))
		S.UpdateResist()
		return
	S = H.apply_status_effect(STATUS_EFFECT_WELFARE_SUPPRESSION)
	S.linked_suppression = src
	S.UpdateResist()
	affected_statuses |= S

/* Status Effects */
// The damage resistance reduction
/atom/movable/screen/alert/status_effect/welfare_damage_resist
	name = "Qliphoth Deterrence Malfunction"
	desc = "Damage resistances remotely modified."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "welfare_suppression"

/atom/movable/screen/alert/status_effect/welfare_damage_resist/update_overlays()
	. = ..()
	var/datum/status_effect/welfare_damage_resist/W = attached_effect
	if(!istype(W))
		return
	for(var/R in W.reset_resist) // Current resistance values
		if(W.reset_resist[R] <= 1)
			continue
		. += "[icon_state]_[R]"

/datum/status_effect/welfare_damage_resist
	id = "welfare_damage_resist"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1 // Lasts until core ends
	alert_type = /atom/movable/screen/alert/status_effect/welfare_damage_resist
	var/datum/suppression/welfare/linked_suppression
	var/list/text_to_var = list(
		RED_DAMAGE = "red_mod",
		WHITE_DAMAGE = "white_mod",
		BLACK_DAMAGE = "black_mod",
		PALE_DAMAGE = "pale_mod",
		)
	/// Used to reset resistances to normal values later
	var/list/reset_resist = list(
		"red_mod" = 1,
		"white_mod" = 1,
		"black_mod" = 1,
		"pale_mod" = 1,
		)

/datum/status_effect/welfare_damage_resist/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	ResetResist()

// Only remove what we did
/datum/status_effect/welfare_damage_resist/proc/ResetResist()
	var/mob/living/carbon/human/H = owner
	for(var/resist in reset_resist)
		H.physiology.vars[resist] /= reset_resist[resist]
		reset_resist[resist] = 1

// Remove what we did and update it to current value
/datum/status_effect/welfare_damage_resist/proc/UpdateResist()
	if(!ishuman(owner))
		return
	ResetResist()
	var/mob/living/carbon/human/H = owner
	for(var/resist in linked_suppression.current_resist)
		var/var_name = text_to_var[resist]
		H.physiology.vars[var_name] *= linked_suppression.current_resist[resist]
		reset_resist[var_name] = linked_suppression.current_resist[resist]
	linked_alert.update_icon() // Updating overlays


// Heals you when you approach death or insanity
/datum/status_effect/welfare_reward
	id = "welfare_reward"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	/// How much health/sanity is restored in percentage of max health
	var/restore_percentage = 0.6
	/// How much is reduced from restore_percentage on each activation
	var/percentage_decrease = 0.15
	/// If restore_percentage reaches this or below - the status effect will be deleted
	var/minimum_restore_percentage = 0.1

/datum/status_effect/welfare_reward/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(OnDamage))
	to_chat(owner, "<span class='notice'>Welfare Department modification has been applied to you!</span>")
	return ..()

/datum/status_effect/welfare_reward/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	return ..()

// Called before damage applies, so we must check whereas situation WOULD kill the user
// This comes with an issue, however, as damage will still be applied afterwards
/datum/status_effect/welfare_reward/proc/OnDamage(datum_source, amount, damagetype, def_zone)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/H = owner
	var/armor = H.getarmor(null, damagetype) / 100
	var/damage_taken = amount * (1 - armor)
	if(damage_taken <= 0)
		return

	var/block_damage = FALSE
	switch(damagetype)
		if(RED_DAMAGE)
			if(H.health - damage_taken <= 0)
				ActivateHealth()
				block_damage = TRUE
		if(WHITE_DAMAGE)
			if(H.sanityhealth - damage_taken <= 0)
				ActivateSanity()
				block_damage = TRUE
		if(BLACK_DAMAGE)
			if(H.health - damage_taken <= 0)
				ActivateHealth()
				block_damage = TRUE
			if(H.sanityhealth - damage_taken <= 0)
				ActivateSanity()
				block_damage = TRUE
		if(PALE_DAMAGE)
			damage_taken = H.maxHealth * (damage_taken / 100)
			if(H.health - damage_taken <= 0)
				ActivateHealth()
				block_damage = TRUE

	// ALWAYS blocks damage so you don't die
	if(block_damage)
		return COMPONENT_MOB_DENY_DAMAGE
	return

/datum/status_effect/welfare_reward/proc/ActivateHealth()
	var/mob/living/carbon/human/H = owner
	H.adjustBruteLoss(-H.maxHealth * restore_percentage)
	PostActivation()

/datum/status_effect/welfare_reward/proc/ActivateSanity()
	var/mob/living/carbon/human/H = owner
	H.adjustSanityLoss(-H.maxSanity * restore_percentage)
	PostActivation()

/datum/status_effect/welfare_reward/proc/PostActivation()
	restore_percentage -= percentage_decrease
	if(restore_percentage <= minimum_restore_percentage)
		to_chat(owner, "<span class='danger'>The welfare effect has expired!</span>")
		qdel(src)
		return
	to_chat(owner, "<span class='warning'>The welfare effect percentage decreased to [restore_percentage * 100]%!</span>")

// Created when welfare suppression ends; Used to track new spawns to apply the reward

/datum/welfare_reward_tracker/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(OnJoin))

/datum/welfare_reward_tracker/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	return ..()

// When a new employee spawns in
/datum/welfare_reward_tracker/proc/OnJoin(datum/source, mob/living/L, rank)
	SIGNAL_HANDLER
	if(!ishuman(L))
		return FALSE
	L.apply_status_effect(STATUS_EFFECT_WELFARE_REWARD)
	return TRUE
