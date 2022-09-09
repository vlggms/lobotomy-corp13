/mob/living/simple_animal/hostile/abnormality
	name = "Abnormality"
	desc = "An abnormality..? You should report this to the Head!"
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = DEAD
	layer = LARGE_MOB_LAYER
	a_intent = INTENT_HARM
	del_on_death = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	move_resist = MOVE_FORCE_STRONG // They kept stealing my abnormalities
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	blood_volume = BLOOD_VOLUME_NORMAL // THERE WILL BE BLOOD. SHED.
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	/// Can this abnormality spawn normally during the round?
	var/can_spawn = TRUE
	/// Reference to the datum we use
	var/datum/abnormality/datum_reference = null
	/// The threat level of the abnormality. It is passed to the datum on spawn
	var/threat_level = ZAYIN_LEVEL
	/// Separate level of fear. If null - will use threat level.
	var/fear_level = null
	/// Maximum qliphoth level, passed to datum
	var/start_qliphoth = 0
	/// Can it breach? If TRUE - zero_qliphoth() calls breach_effect()
	var/can_breach = FALSE
	/// List of humans that witnessed the abnormality breaching
	var/list/breach_affected = list()
	/// Copy-pasted from megafauna.dm: This allows player controlled mobs to use abilities
	var/chosen_attack = 1
	/// Attack actions, sets chosen_attack to the number in the action
	var/list/attack_action_types = list()
	/// If there is a small sprite icon for players controlling the mob to use
	var/small_sprite_type
	/// Work types and chances
	var/list/work_chances = list(
							ABNORMALITY_WORK_INSTINCT = list(50, 55, 60, 65, 70),
							ABNORMALITY_WORK_INSIGHT = list(50, 55, 60, 65, 70),
							ABNORMALITY_WORK_ATTACHMENT = list(50, 55, 60, 65, 70),
							ABNORMALITY_WORK_REPRESSION = list(50, 55, 60, 65, 70)
							)
	/// How much damage is dealt to user on each work failure
	var/work_damage_amount = 2
	/// What damage type is used for work failures
	var/work_damage_type = RED_DAMAGE
	/// Maximum amount of PE someone can obtain per work procedure, if not null or 0.
	var/max_boxes = null
	/// List of ego equipment datums
	var/list/ego_list = list()
	/// EGO Gifts
	var/datum/ego_gifts/gift_type = null
	var/gift_chance = null

/mob/living/simple_animal/hostile/abnormality/Initialize(mapload)
	. = ..()
	for(var/action_type in attack_action_types)
		var/datum/action/innate/abnormality_attack/attack_action = new action_type()
		attack_action.Grant(src)
	if(small_sprite_type)
		var/datum/action/small_sprite/small_action = new small_sprite_type()
		small_action.Grant(src)
	if(fear_level == null)
		fear_level = threat_level
	if (isnull(gift_chance))
		switch(threat_level)
			if(ZAYIN_LEVEL)
				gift_chance = 5
			if(TETH_LEVEL)
				gift_chance = 4
			if(HE_LEVEL)
				gift_chance = 3
			if(WAW_LEVEL)
				gift_chance = 2
			if(ALEPH_LEVEL)
				gift_chance = 1
			else
				gift_chance = 0

/mob/living/simple_animal/hostile/abnormality/Destroy()
	if(istype(datum_reference)) // Respawn the mob on death
		datum_reference.current = null
		addtimer(CALLBACK (datum_reference, .datum/abnormality/proc/RespawnAbno), 30 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/Move()
	if(status_flags & GODMODE) // STOP STEALING MY FREAKING ABNORMALITIES
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	FearEffect()
	return

// Applies fear damage to everyone in range
/mob/living/simple_animal/hostile/abnormality/proc/FearEffect()
	if(fear_level <= 0)
		return
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in breach_affected)
			continue
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			continue
		breach_affected += H
		var/sanity_result = round(fear_level - get_user_level(H))
		var/sanity_damage = -(max(((H.maxSanity * 0.26) * (sanity_result)), 0))
		H.adjustSanityLoss(sanity_damage)
		if(H.sanity_lost)
			continue
		switch(sanity_result)
			if(1)
				to_chat(H, "<span class='warning'>Here it comes!")
			if(2)
				to_chat(H, "<span class='danger'>Not that thing...")
			if(3 to INFINITY)
				to_chat(H, "<span class='userdanger'>I'm not ready for this!")
	return

// Called by datum_reference when the abnormality has been fully spawned
/mob/living/simple_animal/hostile/abnormality/proc/PostSpawn()
	return

// transfers a var to the datum to be used later
/mob/living/simple_animal/hostile/abnormality/proc/TransferVar(index, value)
	if(isnull(datum_reference))
		return
	LAZYSET(datum_reference.transferable_var, value, index)

// Access an item in the "transferable_var" list of the abnormality's datum
/mob/living/simple_animal/hostile/abnormality/proc/RememberVar(index)
	if(isnull(datum_reference))
		return
	return LAZYACCESS(datum_reference.transferable_var, index)


// Modifiers for work chance
/mob/living/simple_animal/hostile/abnormality/proc/work_chance(mob/living/carbon/human/user, chance)
	return chance

// Called by datum_reference when work is done
/mob/living/simple_animal/hostile/abnormality/proc/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if (prob(gift_chance) && !isnull(gift_type))
		user.Apply_Gift(new gift_type)
	if(pe >= datum_reference.success_boxes)
		success_effect(user, work_type, pe)
		return
	if(pe >= datum_reference.neutral_boxes)
		neutral_effect(user, work_type, pe)
		return
	failure_effect(user, work_type, pe)
	return

// Additional effects on good work result, if any
/mob/living/simple_animal/hostile/abnormality/proc/success_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Additional effects on neutral work result, if any
/mob/living/simple_animal/hostile/abnormality/proc/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Additional effects on work failure
/mob/living/simple_animal/hostile/abnormality/proc/failure_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Additional effect on each individual work tick failure
/mob/living/simple_animal/hostile/abnormality/proc/worktick_failure(mob/living/carbon/human/user)
	user.apply_damage(work_damage_amount, work_damage_type, null, user.run_armor_check(null, work_damage_type), spread_damage = TRUE)
	return

// Dictates whereas this type of work can be performed at the moment or not
/mob/living/simple_animal/hostile/abnormality/proc/attempt_work(mob/living/carbon/human/user, work_type)
	return TRUE

// Effects when qliphoth reaches 0
/mob/living/simple_animal/hostile/abnormality/proc/zero_qliphoth(mob/living/carbon/human/user)
	if(can_breach)
		breach_effect(user)
	return

// Special breach effect for abnormalities with can_breach set to TRUE
/mob/living/simple_animal/hostile/abnormality/proc/breach_effect(mob/living/carbon/human/user)
	toggle_ai(AI_ON) // Run.
	status_flags &= ~GODMODE

// On lobotomy_corp subsystem qliphoth event
/mob/living/simple_animal/hostile/abnormality/proc/OnQliphothEvent()
	if(istype(datum_reference)) // Reset chance debuff
		datum_reference.overload_chance = 0
	return

// When qliphoth meltdown begins
/mob/living/simple_animal/hostile/abnormality/proc/meltdown_start()
	return

/mob/living/simple_animal/hostile/abnormality/proc/OnQliphothChange(mob/living/carbon/human/user)
	return

// Actions
/datum/action/innate/abnormality_attack
	name = "Megafauna Attack"
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = ""
	var/mob/living/simple_animal/hostile/abnormality/A
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/abnormality_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/abnormality))
		A = L
		return ..()
	return FALSE

/datum/action/innate/abnormality_attack/Activate()
	A.chosen_attack = chosen_attack_num
	to_chat(A, chosen_message)
