// Mechanical Cassowary - Corroded Human Variant
// A player-controlled mob created by the Tinkerer, based on corrupted cassowary traits
// Focuses on obsessive protection and forced isolation of "imprinted" humans

/mob/living/simple_animal/hostile/corroded_human/cassowary
	name = "Strider Sentinel"
	desc = "A towering mechanical horror, its form a grotesque fusion of human anatomy and cassowary structure. Hydraulic legs support a hunched frame covered in rattling metal plumes."
	icon = 'icons/mob/32x64.dmi' // TODO: Replace with proper cassowary sprite
	icon_state = "armored_brute" // Placeholder - needs cassowary sprite
	icon_living = "armored_brute"
	maxHealth = 1800
	health = 1800
	melee_damage_lower = 30
	melee_damage_upper = 40
	melee_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	attack_sound = 'sound/effects/footstep/heavy1.ogg' // TODO: Replace with hydraulic kick sound
	speak_emote = list("whirrs", "clicks", "booms")
	emote_hear = list("rattles its metal plumes", "emits a low mechanical boom", "clicks anxiously")
	damage_coeff = list(RED_DAMAGE = 1.0, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.2)
	move_to_delay = 3

	// Cassowary-specific variables
	var/list/imprinted_humans = list() // List of humans marked for "protection"
	var/max_imprints = 2
	var/guardian_fury_active = FALSE // Passive ability tracker
	var/list/recent_attackers = list() // Track who hurt our imprinted humans
	var/list/safe_zones = list() // Designated safe areas

	// Ability cooldown trackers
	var/next_imprint = 0
	var/imprint_cooldown = 300 // 30 seconds

/mob/living/simple_animal/hostile/corroded_human/cassowary/Initialize()
	. = ..()
	// Grant cassowary-specific abilities
	grant_cassowary_abilities()

	// Start checking for guardian fury conditions
	START_PROCESSING(SSobj, src)

/mob/living/simple_animal/hostile/corroded_human/cassowary/Destroy()
	STOP_PROCESSING(SSobj, src)
	// Clean up imprint references
	for(var/mob/living/carbon/human/H in imprinted_humans)
		remove_imprint(H)
	return ..()

/mob/living/simple_animal/hostile/corroded_human/cassowary/proc/grant_cassowary_abilities()
	// Roleplay abilities
	var/datum/action/cooldown/cassowary_ability/imprint/imprint = new()
	imprint.Grant(src)

	var/datum/action/cooldown/cassowary_ability/isolation_enforcement/isolation = new()
	isolation.Grant(src)

	var/datum/action/innate/cassowary_ability/subsonic_commune/subsonic = new()
	subsonic.Grant(src)

	var/datum/action/cooldown/cassowary_ability/protective_delusion/delusion = new()
	delusion.Grant(src)

	var/datum/action/cooldown/cassowary_ability/herding_instinct/herding = new()
	herding.Grant(src)

	// Combat abilities
	var/datum/action/cooldown/cassowary_ability/cassowary_kick/kick = new()
	kick.Grant(src)

	var/datum/action/cooldown/cassowary_ability/casque_ram/ram = new()
	ram.Grant(src)

	var/datum/action/cooldown/cassowary_ability/razor_plume/plume = new()
	plume.Grant(src)

	var/datum/action/cooldown/cassowary_ability/territorial_shriek/shriek = new()
	shriek.Grant(src)

/mob/living/simple_animal/hostile/corroded_human/cassowary/Life()
	. = ..()
	if(!.)
		return

	// Check if we're near imprinted humans for damage reduction
	update_imprint_protection()

/mob/living/simple_animal/hostile/corroded_human/cassowary/process()
	// Check for guardian fury activation
	update_guardian_fury()

	// Clean up old attacker entries
	for(var/mob/M in recent_attackers)
		if(recent_attackers[M] < world.time - 300) // 30 seconds
			recent_attackers -= M

/mob/living/simple_animal/hostile/corroded_human/cassowary/examine(mob/user)
	. = ..()

	if(length(imprinted_humans))
		. += span_notice("It seems fixated on protecting [length(imprinted_humans)] individual\s.")

	if(guardian_fury_active)
		. += span_danger("Its sensor array glows with protective fury!")

/mob/living/simple_animal/hostile/corroded_human/cassowary/Login()
	. = ..()
	to_chat(src, span_purple("You are a Strider Sentinel, forever cursed to 'protect' through isolation."))
	to_chat(src, span_notice("Your abilities:"))
	to_chat(src, span_notice("- Imprint on humans to mark them as your 'chicks'"))
	to_chat(src, span_notice("- Create isolation zones to 'protect' them from others"))
	to_chat(src, span_notice("- Use your mechanical cassowary abilities in combat"))
	to_chat(src, span_warning("Remember: Your protection is a curse. Your love is isolation."))

// Imprinting system functions
/mob/living/simple_animal/hostile/corroded_human/cassowary/proc/add_imprint(mob/living/carbon/human/H)
	if(length(imprinted_humans) >= max_imprints)
		to_chat(src, span_warning("Cannot imprint more humans. Remove existing imprints first."))
		return FALSE

	if(H in imprinted_humans)
		to_chat(src, span_warning("[H] is already imprinted."))
		return FALSE

	imprinted_humans += H
	RegisterSignal(H, COMSIG_PARENT_QDELETING, PROC_REF(remove_imprint_signal))
	RegisterSignal(H, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_imprinted_damaged))

	// Visual feedback
	H.add_overlay(mutable_appearance('icons/effects/effects.dmi', "shield", -MUTATIONS_LAYER))
	to_chat(src, span_notice("You have imprinted on [H]. They are now under your protection."))
	to_chat(H, span_warning("You feel an unsettling mechanical presence focusing on you..."))

	return TRUE

/mob/living/simple_animal/hostile/corroded_human/cassowary/proc/remove_imprint(mob/living/carbon/human/H)
	if(!(H in imprinted_humans))
		return

	imprinted_humans -= H
	UnregisterSignal(H, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_APPLY_DAMAGE))

	// Remove visual
	H.cut_overlay(mutable_appearance('icons/effects/effects.dmi', "shield", -MUTATIONS_LAYER))

	to_chat(src, span_notice("Imprint on [H] has been removed."))
	to_chat(H, span_notice("The mechanical presence withdraws its attention from you."))

/mob/living/simple_animal/hostile/corroded_human/cassowary/proc/remove_imprint_signal(mob/living/carbon/human/H)
	SIGNAL_HANDLER
	remove_imprint(H)

/mob/living/simple_animal/hostile/corroded_human/cassowary/proc/on_imprinted_damaged(mob/living/carbon/human/H, damage, damagetype, def_zone)
	SIGNAL_HANDLER

	// Track the attacker for guardian fury
	var/mob/attacker = H.last_damage_source
	if(attacker && attacker != src)
		recent_attackers[attacker] = world.time
		visible_message(span_danger("[src]'s sensors flare with protective rage!"))

/mob/living/simple_animal/hostile/corroded_human/cassowary/proc/update_imprint_protection()
	var/near_imprinted = FALSE
	for(var/mob/living/carbon/human/H in imprinted_humans)
		if(get_dist(src, H) <= 3)
			near_imprinted = TRUE
			break

	// Apply or remove damage reduction
	if(near_imprinted)
		if(!HAS_TRAIT(src, TRAIT_IMPRINT_PROTECTION))
			ADD_TRAIT(src, TRAIT_IMPRINT_PROTECTION, "cassowary_imprint")
			to_chat(src, span_notice("Your protective instincts strengthen near your charge."))
	else
		REMOVE_TRAIT(src, TRAIT_IMPRINT_PROTECTION, "cassowary_imprint")

/mob/living/simple_animal/hostile/corroded_human/cassowary/proc/update_guardian_fury()
	var/should_be_furious = FALSE

	// Check if any recent attackers are nearby
	for(var/mob/M in recent_attackers)
		if(get_dist(src, M) <= 7)
			should_be_furious = TRUE
			break

	if(should_be_furious && !guardian_fury_active)
		guardian_fury_active = TRUE
		melee_damage_lower *= 1.5
		melee_damage_upper *= 1.5
		add_overlay(mutable_appearance('icons/effects/effects.dmi', "empower", -MUTATIONS_LAYER))
		visible_message(span_danger("[src] enters a protective fury!"))
	else if(!should_be_furious && guardian_fury_active)
		guardian_fury_active = FALSE
		melee_damage_lower /= 1.5
		melee_damage_upper /= 1.5
		cut_overlay(mutable_appearance('icons/effects/effects.dmi', "empower", -MUTATIONS_LAYER))

/mob/living/simple_animal/hostile/corroded_human/cassowary/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	// 25% damage reduction when near imprinted humans
	if(amount > 0 && HAS_TRAIT(src, TRAIT_IMPRINT_PROTECTION))
		amount *= 0.75
	return ..()

// Movement speed adjustment when moving toward threatened imprinted
/mob/living/simple_animal/hostile/corroded_human/cassowary/Move(NewLoc, direct)
	var/speed_boost = FALSE

	// Check if we're moving toward a threatened imprinted human
	for(var/mob/living/carbon/human/H in imprinted_humans)
		if(H.last_damage_source && H.last_damage_source != src)
			if(get_dist(NewLoc, H) < get_dist(src, H))
				speed_boost = TRUE
				break

	if(speed_boost)
		move_to_delay = initial(move_to_delay) * 0.5
	else
		move_to_delay = initial(move_to_delay)

	return ..()

// Base class for cassowary abilities
/datum/action/cooldown/cassowary_ability
	background_icon_state = "bg_ecult"
	icon_icon = 'icons/mob/actions/actions_ecult.dmi'
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE

/datum/action/innate/cassowary_ability
	background_icon_state = "bg_ecult"

// ROLEPLAY ABILITIES

// Imprint Protocol
/datum/action/cooldown/cassowary_ability/imprint
	name = "Imprint Protocol"
	desc = "Mark a human as your 'chick' to protect. You can maintain up to 2 imprints."
	button_icon_state = "transmit"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/cassowary_ability/imprint/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	// Get nearby humans
	var/list/nearby_humans = list()
	for(var/mob/living/carbon/human/H in view(1, C))
		if(H.stat != DEAD)
			nearby_humans += H

	if(!length(nearby_humans))
		to_chat(C, span_warning("No humans nearby to imprint."))
		return FALSE

	var/mob/living/carbon/human/target = input(C, "Select human to imprint", "Imprint Protocol") as null|anything in nearby_humans
	if(!target || get_dist(C, target) > 1 || target.stat == DEAD)
		return FALSE

	if(C.add_imprint(target))
		StartCooldown()
		return TRUE

	return FALSE

// Isolation Enforcement
/datum/action/cooldown/cassowary_ability/isolation_enforcement
	name = "Isolation Enforcement"
	desc = "Create a protective barrier that pushes others away from your imprinted human."
	button_icon_state = "shield"
	cooldown_time = 45 SECONDS

/datum/action/cooldown/cassowary_ability/isolation_enforcement/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	if(!length(C.imprinted_humans))
		to_chat(C, span_warning("No imprinted humans to protect."))
		return FALSE

	// TODO: Implement isolation zone creation
	to_chat(C, span_notice("Isolation Enforcement - Not yet implemented"))
	StartCooldown()
	return TRUE

// Subsonic Communication
/datum/action/innate/cassowary_ability/subsonic_commune
	name = "Subsonic Communication"
	desc = "Send messages through low-frequency mechanical sounds. Only corroded beings and imprinted humans understand the words."
	icon_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "vortex_hop"

/datum/action/innate/cassowary_ability/subsonic_commune/Activate()
	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	var/message = stripped_input(C, "What subsonic message do you wish to transmit?", "Subsonic Communication")
	if(!message)
		return

	// Send to all corroded beings
	for(var/mob/living/simple_animal/hostile/corroded_human/CH in GLOB.mob_living_list)
		to_chat(CH, span_purple("<b>Subsonic Network:</b> [C.name] transmits, \"[message]\""))

	// Send to imprinted humans (they understand it)
	for(var/mob/living/carbon/human/H in C.imprinted_humans)
		to_chat(H, span_purple("<b>Mechanical Voice:</b> [C.name] booms, \"[message]\""))

	// Nearby non-imprinted humans feel uneasy
	for(var/mob/living/carbon/human/H in hearers(7, C))
		if(!(H in C.imprinted_humans))
			to_chat(H, span_warning("You feel uneasy as low-frequency vibrations pass through you..."))
			H.dizziness += 5

	C.visible_message(span_notice("[C] emits a deep, mechanical boom."))
	playsound(C, 'sound/effects/tendril_destroyed.ogg', 50, TRUE, frequency = 0.5)

// Protective Delusion
/datum/action/cooldown/cassowary_ability/protective_delusion
	name = "Protective Delusion"
	desc = "Force-feed mechanical oil to an imprinted human, granting damage resistance but causing nausea."
	button_icon_state = "absorbcharge"
	cooldown_time = 60 SECONDS

/datum/action/cooldown/cassowary_ability/protective_delusion/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	// TODO: Implement oil feeding mechanic
	to_chat(C, span_notice("Protective Delusion - Not yet implemented"))
	StartCooldown()
	return TRUE

// Herding Instinct
/datum/action/cooldown/cassowary_ability/herding_instinct
	name = "Herding Instinct"
	desc = "Grab and carry a human to 'safety'. They can resist by moving repeatedly."
	button_icon_state = "pull"
	cooldown_time = 20 SECONDS

/datum/action/cooldown/cassowary_ability/herding_instinct/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	// TODO: Implement grabbing and carrying mechanic
	to_chat(C, span_notice("Herding Instinct - Not yet implemented"))
	StartCooldown()
	return TRUE

// COMBAT ABILITIES

// Cassowary Kick
/datum/action/cooldown/cassowary_ability/cassowary_kick
	name = "Cassowary Kick"
	desc = "Deliver a powerful hydraulic-assisted kick that knocks targets back."
	button_icon_state = "blood_siphon"
	cooldown_time = 10 SECONDS

/datum/action/cooldown/cassowary_ability/cassowary_kick/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	// TODO: Implement kick attack
	to_chat(C, span_notice("Cassowary Kick - Not yet implemented"))
	StartCooldown()
	return TRUE

// Casque Ram
/datum/action/cooldown/cassowary_ability/casque_ram
	name = "Casque Battering Ram"
	desc = "Charge forward with your reinforced sensor array, stunning the first target hit."
	button_icon_state = "charge"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/cassowary_ability/casque_ram/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	// TODO: Implement charge attack
	to_chat(C, span_notice("Casque Ram - Not yet implemented"))
	StartCooldown()
	return TRUE

// Razor Plume Defense
/datum/action/cooldown/cassowary_ability/razor_plume
	name = "Razor Plume Defense"
	desc = "Release metallic feather shards in all directions when defending your imprinted humans."
	button_icon_state = "furious_steel"
	cooldown_time = 45 SECONDS

/datum/action/cooldown/cassowary_ability/razor_plume/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	// TODO: Implement feather shard attack
	to_chat(C, span_notice("Razor Plume Defense - Not yet implemented"))
	StartCooldown()
	return TRUE

// Territorial Shriek
/datum/action/cooldown/cassowary_ability/territorial_shriek
	name = "Territorial Shriek"
	desc = "Emit a cassowary-inspired subsonic boom that disorients nearby enemies."
	button_icon_state = "abyssal_gaze"
	cooldown_time = 60 SECONDS

/datum/action/cooldown/cassowary_ability/territorial_shriek/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/cassowary/C = owner

	// TODO: Implement shriek attack
	to_chat(C, span_notice("Territorial Shriek - Not yet implemented"))
	StartCooldown()
	return TRUE

// Define the trait for imprint protection
#define TRAIT_IMPRINT_PROTECTION "imprint_protection"
