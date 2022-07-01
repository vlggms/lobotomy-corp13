/mob/living/simple_animal/hostile/megafauna/claw
	name = "Claw"
	desc = "A strange humanoid creature with several gadgets attached to it."
	health = 4500
	maxHealth = 4500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.2)
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'ModularTegustation/Tegusounds/claw/attack.ogg'
	icon_state = "claw"
	icon_living = "claw"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	faction = list("Head")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_color = COLOR_LIGHT_GRAYISH_RED
	light_range = 3
	movement_type = GROUND
	speak_emote = list("says")
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 50
	melee_damage_upper = 60
	ranged = TRUE
	speed = 2
	move_to_delay = 2
	pixel_x = 0
	base_pixel_x = 0
	del_on_death = TRUE
	blood_volume = BLOOD_VOLUME_NORMAL
	gps_name = "NTAF-V"
	deathmessage = "falls to the ground, decaying into glowing particles."
	deathsound = 'ModularTegustation/Tegusounds/claw/death.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(/datum/action/innate/megafauna_attack/ultimatum,
							   /datum/action/innate/megafauna_attack/swift_dash,
							   /datum/action/innate/megafauna_attack/swift_dash_long,
							   /datum/action/innate/megafauna_attack/serum_a,
							   )
	var/ultimatum_cooldown = 0
	var/ultimatum_cooldown_time = 40 SECONDS
	var/charging = FALSE
	var/dash_num_short = 4
	var/dash_num_long = 18
	var/dash_cooldown = 0
	var/dash_cooldown_time = 6 // cooldown_time * distance:
	// 6 * 4 = 24 (2.4 seconds)
	// 6 * 18 = 108 (10.8 seconds)
	var/serumA_cooldown = 0
	var/serumA_cooldown_time = 20 SECONDS

	var/datum/ordeal/ordeal_reference

/datum/action/innate/megafauna_attack/ultimatum
	name = "Ultimatum"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "static"
	chosen_message = "<span class='colossus'>You will now jump to random targets on the station.</span>"
	chosen_attack_num = 1

/datum/action/innate/megafauna_attack/swift_dash
	name = "Swift Dash"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = "<span class='colossus'>You will now dash forward for a short distance.</span>"
	chosen_attack_num = 2

/datum/action/innate/megafauna_attack/swift_dash_long
	name = "Long Dash"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "plasmasoul"
	chosen_message = "<span class='colossus'>You will now dash forward for a long distance.</span>"
	chosen_attack_num = 3

/datum/action/innate/megafauna_attack/serum_a
	name = "Serum 'A'"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "impact_laser"
	chosen_message = "<span class='colossus'>You will now continously dash towards your target.</span>"
	chosen_attack_num = 4

/obj/effect/target_field
	name = "target field"
	desc = "You have a bad feeling about this..."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "target_field"
	duration = 30 SECONDS // In case claw dies in the processs
	randomdir = FALSE

/mob/living/simple_animal/hostile/megafauna/claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT) // Imagine floating.

/mob/living/simple_animal/hostile/megafauna/claw/death(gibbed)
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

/mob/living/simple_animal/hostile/megafauna/claw/Destroy()
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

/mob/living/simple_animal/hostile/megafauna/claw/OpenFire()
	if(client)
		if(charging)
			return
		switch(chosen_attack)
			if(1)
				ultimatum(target)
			if(2)
				swift_dash(target, dash_num_short, 5)
			if(3)
				swift_dash(target, dash_num_long, 20)
			if(4)
				serumA(target)
		return

	Goto(target, move_to_delay, minimum_distance)
	if(dash_cooldown <= world.time && !charging)
		swift_dash(target, dash_num_short, 5)
	else if(get_dist(src, target) >= 2 && serumA_cooldown <= world.time && !charging)
		serumA(target)
	else if(get_dist(src, target) >= 3 && ultimatum_cooldown <= world.time && !charging)
		ultimatum()

/mob/living/simple_animal/hostile/megafauna/claw/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/claw/proc/ultimatum()
	if(ultimatum_cooldown > world.time)
		return
	ultimatum_cooldown = world.time + ultimatum_cooldown_time
	var/list/mob/living/carbon/human/death_candidates = list()
	for(var/mob/living/carbon/human/maybe_victim in GLOB.player_list)
		if((maybe_victim.stat != DEAD) && maybe_victim.z == z)
			death_candidates += maybe_victim
	var/mob/living/carbon/human/H = null
	if(!death_candidates.len) // If there is 0 candidates - stop the spell.
		to_chat(src, "<span class='notice'>There is no more human survivors on the station. Mission accomplished.</span>")
		return
	for(var/i in 1 to 5)
		if(!death_candidates.len) // No more candidates left? Let's stop picking through the list.
			break
		H = pick(death_candidates)
		addtimer(CALLBACK(src, .proc/eviscerate, H), i*4)
		death_candidates.Remove(H)

/mob/living/simple_animal/hostile/megafauna/claw/proc/eviscerate(mob/living/carbon/human/target)
	var/obj/effect/target_field/uhoh = new /obj/effect/target_field(target.loc)
	uhoh.orbit(target, 0)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
	playsound(src, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 1, 1)
	to_chat(target, "<span class='danger'>The [src] is going to hunt you down!</span>")
	addtimer(CALLBACK(src, .proc/eviscerate2, target, uhoh), 30)

/mob/living/simple_animal/hostile/megafauna/claw/proc/eviscerate2(mob/living/carbon/human/target, obj/effect/eff)
	if(prob(2) || target.z != z || !target.loc.AllowClick() || !target) // Be happy, mortal. Did you just hide in a locker?
		to_chat(src, "<span class='notice'>Your teleportation device malfunctions!</span>")
		to_chat(target, "<span class='notice'>It seems you are safe. For now...</span>")
		playsound(src.loc, 'ModularTegustation/Tegusounds/claw/error.ogg', 50, 1)
		qdel(eff)
		return
	new /obj/effect/temp_visual/emp/pulse(src.loc)
	visible_message("<span class='warning'>[src] blinks away!</span>")
	var/turf/tp_loc = get_step(target.loc, pick(0,1,2,4,5,6,8,9,10))
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	forceMove(tp_loc)
	qdel(eff)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
	GiveTarget(target)
	for(var/turf/b in range(1, src.loc)) // Attacks everyone around.
		for(var/mob/living/H in b)
			H.Knockdown(15)
			H.attack_animal(src)
			new /obj/effect/temp_visual/cleave(H.loc)

/mob/living/simple_animal/hostile/megafauna/claw/proc/swift_dash(target, distance, wait_time)
	if(dash_cooldown > world.time)
		return
	dash_cooldown = world.time + (dash_cooldown_time * distance)
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	var/turf/T = get_step(get_turf(src), dir_to_target)
	for(var/i in 1 to distance)
		new /obj/effect/temp_visual/cult/sparks(T)
		T = get_step(T, dir_to_target)
	addtimer(CALLBACK(src, .proc/swift_dash2, dir_to_target, 0, distance), wait_time)
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 100, 1)

/mob/living/simple_animal/hostile/megafauna/claw/proc/swift_dash2(move_dir, times_ran, distance_run)
	if(times_ran > distance_run)
		charging = FALSE
		return
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		return
	new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	forceMove(T)
	playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
	for(var/mob/living/L in T.contents - src)
		L.Knockdown(15)
		L.attack_animal(src)
		new /obj/effect/temp_visual/cleave(L.loc)
	addtimer(CALLBACK(src, .proc/swift_dash2, move_dir, (times_ran + 1), distance_run), 0.7)

/mob/living/simple_animal/hostile/megafauna/claw/proc/serumA(target)
	if(serumA_cooldown > world.time)
		return
	if(!isliving(target))
		return
	var/mob/living/LT = target
	serumA_cooldown = world.time + serumA_cooldown_time
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 100, 1)
	charging = TRUE
	SLEEP_CHECK_DEATH(8)
	for(var/i = 1 to 8)
		SLEEP_CHECK_DEATH(2)
		if(!LT)
			break
		addtimer(CALLBACK(src, .proc/blink, LT), 0)
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/claw/proc/blink(mob/living/LT)
	var/turf/start_turf = get_turf(src)
	var/turf/target_turf = get_step(get_turf(LT), pick(0,1,2,4,5,6,8,9,10))
	for(var/i = 1 to 2) // For fancy effect
		target_turf = get_step(target_turf, get_dir(get_turf(start_turf), get_turf(target_turf)))
	SLEEP_CHECK_DEATH(1) // Some chance to escape
	forceMove(target_turf)
	playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	for(var/turf/B in getline(start_turf, target_turf))
		new /obj/effect/temp_visual/small_smoke/halfsecond(B)
		for(var/mob/living/victim in B)
			if(!("Head" in victim.faction) && victim != src)
				victim.attack_animal(src)
