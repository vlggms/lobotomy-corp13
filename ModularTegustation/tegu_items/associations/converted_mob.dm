/mob/living/simple_animal/hostile/corroded_human
	name = "Converted Follower"
	desc = "A former human, their body now a fusion of flesh and machinery. They serve the Elder One with unwavering devotion."
	icon = 'icons/mob/eldritch_mobs.dmi'
	icon_state = "rust_walker_s" // Placeholder - should be replaced with proper sprite
	icon_living = "rust_walker_s"
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_ROBOTIC
	speak_emote = list("intones", "drones", "states")
	emote_hear = list("whirs", "buzzes", "clicks")
	maxHealth = 1500
	health = 1500
	see_in_dark = 8
	melee_damage_lower = 15
	melee_damage_upper = 20
	melee_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "strikes"
	attack_verb_simple = "strike"
	attack_sound = 'sound/weapons/pierce_slow.ogg'
	faction = list("resurgence_clan")
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	del_on_death = TRUE
	loot = list(/obj/effect/gibspawner/robot)

	// Special abilities
	var/next_voice = 0
	var/voice_cooldown = 300 // 30 seconds
	var/next_repair = 0
	var/repair_cooldown = 600 // 60 seconds

	// Player-controlled specific vars
	var/player_controlled = FALSE

	// Storage system
	var/list/stored_items = list()
	var/max_storage = 50

	// Weapon integration
	var/obj/item/ego_weapon/integrated_weapon
	var/original_damage_lower
	var/original_damage_upper
	var/original_damage_type
	var/original_attack_sound

/mob/living/simple_animal/hostile/corroded_human/Initialize()
	. = ..()
	// Store original damage values
	original_damage_lower = melee_damage_lower
	original_damage_upper = melee_damage_upper
	original_damage_type = melee_damage_type
	original_attack_sound = attack_sound

/mob/living/simple_animal/hostile/corroded_human/Life()
	. = ..()
	if(!.)
		return

	// Self-repair over time when not in combat
	if(health < maxHealth && world.time > next_repair && !target)
		adjustBruteLoss(-250, 0)
		visible_message(span_notice("[src]'s mechanisms whir as damage is repaired."))
		next_repair = world.time + repair_cooldown

/mob/living/simple_animal/hostile/corroded_human/setDir(newdir)
	. = ..()
	if(newdir == NORTH)
		icon_state = "rust_walker_n"
	else if(newdir == SOUTH)
		icon_state = "rust_walker_s"
	update_icon()

/mob/living/simple_animal/hostile/corroded_human/Moved()
	. = ..()
	playsound(src, 'sound/effects/footstep/rustystep1.ogg', 100, TRUE)

/mob/living/simple_animal/hostile/corroded_human/examine(mob/user)
	. = ..()
	
	// Show integrated weapon
	if(integrated_weapon)
		. += span_notice("It has [integrated_weapon.name] integrated into its combat systems.")
		. += span_notice("Current damage output: [melee_damage_lower]-[melee_damage_upper] [melee_damage_type].")
	
	// Show storage status
	if(length(stored_items) > 0)
		. += span_notice("Storage compartment: [length(stored_items)]/[max_storage] items.")
	else
		. += span_notice("Storage compartment is empty.")

/mob/living/simple_animal/hostile/corroded_human/death(gibbed)
	// Drop all stored items
	if(length(stored_items))
		var/turf/T = get_turf(src)
		visible_message(span_notice("[src]'s storage compartment bursts open!"))
		for(var/obj/item/I in stored_items)
			I.forceMove(T)
		stored_items.Cut()
	
	// Drop integrated weapon
	if(integrated_weapon)
		integrated_weapon.forceMove(get_turf(src))
		integrated_weapon = null
	
	return ..() // Call parent death proc

// Special player-controlled variant with more abilities
/mob/living/simple_animal/hostile/corroded_human/player
	player_controlled = TRUE
	faction = list("resurgence_clan", "neutral")
	city_faction = FALSE

/mob/living/simple_animal/hostile/corroded_human/player/Initialize()
	. = ..()
	AddComponent(/datum/component/player_tool_component)

	// Grant machine abilities
	var/datum/action/cooldown/converted_ability/overclock/overclock = new()
	overclock.Grant(src)

	var/datum/action/cooldown/converted_ability/emergency_repair/repair = new()
	repair.Grant(src)

	var/datum/action/cooldown/converted_ability/static_discharge/discharge = new()
	discharge.Grant(src)

	var/datum/action/innate/converted_ability/commune/commune = new()
	commune.Grant(src)

	// Storage abilities
	var/datum/action/cooldown/converted_ability/magnetic_collection/collect = new()
	collect.Grant(src)

	var/datum/action/innate/converted_ability/expel_storage/expel = new()
	expel.Grant(src)

	// Weapon abilities
	var/datum/action/cooldown/converted_ability/integrate_weapon/integrate = new()
	integrate.Grant(src)

	var/datum/action/innate/converted_ability/eject_weapon/eject = new()
	eject.Grant(src)

/mob/living/simple_animal/hostile/corroded_human/player/Login()
	. = ..()
	to_chat(src, span_purple("You have been reborn as a servant of the Tinkerer!"))
	to_chat(src, span_notice("You can:"))
	to_chat(src, span_notice("- Slowly regenerate health when not in combat"))
	to_chat(src, span_notice("- Use various machine abilities (check your action buttons)"))
	to_chat(src, span_notice("- Commune with other converted beings"))

// Component to give player-controlled converts some basic interaction abilities
/datum/component/player_tool_component
	var/mob/living/owner

/datum/component/player_tool_component/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))

/datum/component/player_tool_component/proc/on_click(mob/source, atom/A, params)
	SIGNAL_HANDLER

	// Allow basic interactions
	if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(get_dist(source, D) <= 1)
			if(D.density)
				INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open))
			else
				INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, close))
			return COMSIG_MOB_CANCEL_CLICKON

// Special abilities that can be added later
/datum/action/innate/converted_ability
	background_icon_state = "bg_ecult"

/datum/action/innate/converted_ability/commune
	name = "Commune with Machinery"
	desc = "Send a message through the mechanical network to other converted beings."
	icon_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "transmit"

/datum/action/innate/converted_ability/commune/Activate()
	var/message = stripped_input(owner, "What message do you wish to transmit?", "Mechanical Communion")
	if(!message)
		return

	for(var/mob/living/simple_animal/hostile/corroded_human/C in GLOB.mob_living_list)
		to_chat(C, span_purple("<b>Mechanical Communion:</b> [owner.name] transmits, \"[message]\""))

	to_chat(owner, span_purple("You transmit your message through the mechanical network."))

// Cooldown-based abilities
/datum/action/cooldown/converted_ability
	background_icon_state = "bg_ecult"
	icon_icon = 'icons/mob/actions/actions_ecult.dmi'
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE

// Overclock Systems - Speed and damage boost
/datum/action/cooldown/converted_ability/overclock
	name = "Overclock Systems"
	desc = "Push your mechanical components beyond their limits, gaining speed and damage at the cost of self-damage."
	button_icon_state = "mansus_link"
	cooldown_time = 60 SECONDS

/datum/action/cooldown/converted_ability/overclock/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	to_chat(C, span_userdanger("WARNING: SYSTEM OVERCLOCK INITIATED"))
	C.visible_message(span_warning("[C]'s form crackles with energy as their systems overclock!"), \
		span_notice("You feel your systems surge with power!"))

	playsound(C, 'sound/magic/lightningshock.ogg', 100, TRUE)

	// Apply buffs
	C.melee_damage_lower *= 1.5
	C.melee_damage_upper *= 1.5
	C.move_to_delay *= 0.5

	C.UpdateSpeed()

	// Visual effect
	C.add_overlay(mutable_appearance('icons/effects/effects.dmi', "electricity", -MUTATIONS_LAYER))

	// Duration and self-damage
	addtimer(CALLBACK(src, PROC_REF(end_overclock)), 100) // 10 seconds

	// Self damage over time
	for(var/i in 1 to 10)
		addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living, adjustBruteLoss), 10), i * 10)

	StartCooldown()
	return TRUE

/datum/action/cooldown/converted_ability/overclock/proc/end_overclock()
	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	// Remove buffs
	C.melee_damage_lower /= 1.5
	C.melee_damage_upper /= 1.5
	C.move_to_delay /= 0.5

	C.UpdateSpeed()

	// Remove visual
	C.cut_overlay(mutable_appearance('icons/effects/effects.dmi', "electricity", -MUTATIONS_LAYER))

	to_chat(C, span_warning("Overclock systems shutting down..."))

// Emergency Repair - Instant heal
/datum/action/cooldown/converted_ability/emergency_repair
	name = "Emergency Repair"
	desc = "Activate emergency repair protocols to instantly restore a portion of your health."
	button_icon_state = "rust_wave"
	cooldown_time = 120 SECONDS

/datum/action/cooldown/converted_ability/emergency_repair/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	C.visible_message(span_notice("[C]'s damaged components rapidly repair themselves!"), \
		span_notice("Emergency repair protocols activated!"))

	playsound(C, 'sound/items/welder2.ogg', 50, TRUE)

	// Heal amount based on max health
	var/heal_amount = C.maxHealth * 0.4
	C.adjustBruteLoss(-heal_amount)

	// Visual effect
	new /obj/effect/temp_visual/heal(get_turf(C), "#FF0000")

	StartCooldown()
	return TRUE

// Static Discharge - AoE stun attack
/datum/action/cooldown/converted_ability/static_discharge
	name = "Static Discharge"
	desc = "Release built-up electrical energy in a burst, stunning nearby organic beings."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "emp"
	cooldown_time = 45 SECONDS

/datum/action/cooldown/converted_ability/static_discharge/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	C.visible_message(span_danger("[C] releases a massive electrical discharge!"), \
		span_notice("You discharge accumulated static energy!"))

	playsound(C, 'sound/magic/lightningbolt.ogg', 100, TRUE)

	// Visual effect
	for(var/turf/T in view(2, C))
		new /obj/effect/temp_visual/electricity(T)

	// Affect nearby mobs
	for(var/mob/living/L in view(2, C))
		if(L == C)
			continue
		if(L.mob_biotypes & MOB_ROBOTIC)
			continue // Don't affect other machines

		to_chat(L, span_userdanger("You're shocked by the electrical discharge!"))
		L.Knockdown(30)
		L.adjustBlackLoss(15)

	StartCooldown()
	return TRUE

// Visual effects
/obj/effect/temp_visual/electricity
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 5

// Magnetic Collection - Collect items in area
/datum/action/cooldown/converted_ability/magnetic_collection
	name = "Magnetic Collection"
	desc = "Activate magnetic systems to pull all nearby items into your storage compartment. Maximum 50 items."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "transmute"
	cooldown_time = 5 SECONDS

/datum/action/cooldown/converted_ability/magnetic_collection/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	if(length(C.stored_items) >= C.max_storage)
		to_chat(C, span_warning("Storage compartment full! Cannot collect more items."))
		return FALSE

	C.visible_message(span_notice("[C]'s form hums with magnetic energy!"), \
		span_notice("Activating magnetic collection systems..."))

	playsound(C, 'sound/effects/EMPulse.ogg', 50, TRUE)

	// Visual effect - magnetic pull
	var/datum/effect_system/spark_spread/S = new
	S.set_up(10,0,C.loc)
	S.start()

	// Delay before collection
	if(do_after(C, 2 SECONDS, C))
		perform_collection()
		StartCooldown()
	else
		to_chat(C, span_warning("Canceled magnetic collection systems..."))

	return TRUE


/datum/action/cooldown/converted_ability/magnetic_collection/proc/perform_collection()
	var/mob/living/simple_animal/hostile/corroded_human/C = owner
	var/collected = 0

	for(var/obj/item/I in view(1, C))
		if(length(C.stored_items) >= C.max_storage)
			break
		if(I.anchored)
			continue
		if(istype(I, /obj/item/organ)) // Don't collect organs
			continue

		I.forceMove(C)
		C.stored_items += I
		collected++

	if(collected)
		to_chat(C, span_notice("Collected [collected] item\s. Storage: [length(C.stored_items)]/[C.max_storage]"))
		playsound(C, 'sound/machines/ping.ogg', 50, TRUE)
	else
		to_chat(C, span_warning("No items found to collect."))

// Expel Storage - Drop all stored items
/datum/action/innate/converted_ability/expel_storage
	name = "Expel Storage"
	desc = "Open storage compartment and drop all collected items."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "manip"

/datum/action/innate/converted_ability/expel_storage/Activate()
	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	if(!length(C.stored_items))
		to_chat(C, span_warning("Storage compartment is empty."))
		return

	var/turf/T = get_turf(C)
	var/expelled = 0

	C.visible_message(span_notice("[C]'s storage compartment opens with a hiss!"), \
		span_notice("Expelling all stored items..."))

	playsound(C, 'sound/mecha/mech_shield_drop.ogg', 50, TRUE)

	for(var/obj/item/I in C.stored_items)
		I.forceMove(T)
		expelled++

	C.stored_items.Cut()
	to_chat(C, span_notice("Expelled [expelled] item\s from storage."))

// Integrate Weapon - Absorb ego weapon
/datum/action/cooldown/converted_ability/integrate_weapon
	name = "Integrate Weapon"
	desc = "Integrate an EGO weapon into your combat systems, copying its damage properties."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	cooldown_time = 10 SECONDS

/datum/action/cooldown/converted_ability/integrate_weapon/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	if(C.integrated_weapon)
		to_chat(C, span_warning("Weapon already integrated! Eject current weapon first."))
		return FALSE

	var/list/nearby_weapons = list()

	for(var/obj/item/ego_weapon/W in view(1, C))
		nearby_weapons += W

	if(!length(nearby_weapons))
		to_chat(C, span_warning("No EGO weapons detected nearby."))
		return FALSE

	var/obj/item/ego_weapon/chosen = input(C, "Select weapon to integrate", "Weapon Integration") as null|anything in nearby_weapons
	if(!chosen || get_dist(C, chosen) > 1)
		return FALSE

	// Integrate the weapon
	chosen.forceMove(C)
	C.integrated_weapon = chosen

	// Copy weapon stats
	C.melee_damage_lower = chosen.force
	C.melee_damage_upper = chosen.force

	// Check for attack_speed variable
	if(chosen.vars.Find("attack_speed"))
		var/attack_speed = chosen.vars["attack_speed"]
		if(attack_speed && isnum(attack_speed))
			C.melee_damage_lower = round(C.melee_damage_lower / attack_speed)
			C.melee_damage_upper = round(C.melee_damage_upper / attack_speed)

	C.melee_damage_type = chosen.damtype

	// Copy the weapon's hitsound
	if(chosen.hitsound)
		C.attack_sound = chosen.hitsound

	C.visible_message(span_warning("[C] integrates [chosen] into their combat systems!"), \
		span_notice("Weapon integrated. New combat parameters loaded."))

	playsound(C, 'sound/mecha/mech_shield_raise.ogg', 50, TRUE)

	StartCooldown()
	return TRUE

// Eject Weapon - Drop integrated weapon
/datum/action/innate/converted_ability/eject_weapon
	name = "Eject Weapon"
	desc = "Eject the integrated weapon and revert to original combat parameters."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "manip"

/datum/action/innate/converted_ability/eject_weapon/Activate()
	var/mob/living/simple_animal/hostile/corroded_human/C = owner

	if(!C.integrated_weapon)
		to_chat(C, span_warning("No weapon integrated."))
		return

	var/turf/T = get_turf(C)

	C.visible_message(span_notice("[C] ejects [C.integrated_weapon] from their systems."), \
		span_notice("Weapon ejected. Reverting to original combat parameters."))

	playsound(C, 'sound/mecha/mech_shield_drop.ogg', 50, TRUE)

	// Drop the weapon
	C.integrated_weapon.forceMove(T)
	C.integrated_weapon = null

	// Revert to original stats
	C.melee_damage_lower = C.original_damage_lower
	C.melee_damage_upper = C.original_damage_upper
	C.melee_damage_type = C.original_damage_type
	C.attack_sound = C.original_attack_sound
