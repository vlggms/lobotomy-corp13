/mob/living/simple_animal/hostile/megafauna/claw
	name = "Claw"
	desc = "A strange humanoid creature with several gadgets attached to it."
	health = 7000
	maxHealth = 7000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.4)
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'ModularTegustation/Tegusounds/claw/attack.ogg'
	icon_state = "claw"
	icon_living = "claw"
	icon_dead = "claw_dead"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	faction = list("Head")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_color = COLOR_LIGHT_GRAYISH_RED
	light_range = 3
	movement_type = GROUND
	speak_emote = list("says")
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 75 // Assuming everyone has at least 0.5 red armor
	melee_damage_upper = 85
	stat_attack = HARD_CRIT
	rapid_melee = 2
	ranged = TRUE
	speed = 2
	move_to_delay = 2
	pixel_x = -8
	base_pixel_x = -8
	blood_volume = BLOOD_VOLUME_NORMAL
	gps_name = "NTAF-V"
	del_on_death = FALSE
	deathmessage = "falls to the ground, decaying into glowing particles."
	deathsound = 'ModularTegustation/Tegusounds/claw/death.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(/datum/action/innate/megafauna_attack/swift_dash,
							   /datum/action/innate/megafauna_attack/swift_dash_long,
							   /datum/action/innate/megafauna_attack/serum_a,
							   /datum/action/innate/megafauna_attack/serum_w,
							   /datum/action/innate/megafauna_attack/tri_serum,
							   )
	var/serumW_cooldown = 0
	var/serumW_cooldown_time = 40 SECONDS
	var/charging = FALSE
	var/dash_num_short = 5
	var/dash_num_long = 18
	var/dash_cooldown = 0
	var/dash_cooldown_time = 5 // cooldown_time * distance:
	// 5 * 5 = 25 (2.5 seconds)
	// 5 * 18 = 90 (9 seconds)
	var/serumA_cooldown = 0
	var/serumA_cooldown_time = 13 SECONDS
	var/triserum_cooldown
	var/triserum_cooldown_time = 70 SECONDS

	var/datum/ordeal/ordeal_reference

/datum/action/innate/megafauna_attack/serum_w
	name = "Serum 'W'"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "static"
	chosen_message = "<span class='colossus'>You will now jump to random targets in the facility.</span>"
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

/datum/action/innate/megafauna_attack/tri_serum
	name = "Tri-Serum Attack"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "static"
	chosen_message = "<span class='colossus'>You will now jump to random targets in the facility, dealing pale damage to anyone on your way.</span>"
	chosen_attack_num = 5

/obj/effect/temp_visual/target_field
	name = "target field"
	desc = "You have a bad feeling about this..."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "target_field"
	duration = 30 SECONDS // In case claw dies in the processs
	randomdir = FALSE

/obj/effect/temp_visual/target_field/blue
	name = "tri-serum target field"
	desc = "Well shit."
	icon_state = "target_field_blue"

/mob/living/simple_animal/hostile/megafauna/claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT) // Imagine floating.
	serumW_cooldown = world.time + 15 SECONDS

/mob/living/simple_animal/hostile/megafauna/claw/death(gibbed)
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
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
				serumW()
			if(2)
				swift_dash(target, dash_num_short, 5)
			if(3)
				swift_dash(target, dash_num_long, 20)
			if(4)
				serumA(target)
			if(4)
				TriSerum()
		return

	Goto(target, move_to_delay, minimum_distance)
	if(serumA_cooldown <= world.time && !charging)
		serumA(target)
	else if(dash_cooldown <= world.time && !charging)
		swift_dash(target, dash_num_short, 5)

/mob/living/simple_animal/hostile/megafauna/claw/Move()
	if(charging)
		return FALSE
	if(stat == DEAD)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/claw/Life()
	. = ..()
	if(.) // Alive and well
		if(!client)
			if(serumW_cooldown <= world.time)
				serumW() // So we don't get stuck
			if(triserum_cooldown <= world.time && (health < maxHealth*0.2))
				TriSerum()

/mob/living/simple_animal/hostile/megafauna/claw/proc/serumW()
	if(serumW_cooldown > world.time)
		return
	serumW_cooldown = world.time + serumW_cooldown_time
	var/list/mob/living/carbon/human/death_candidates = list()
	for(var/mob/living/carbon/human/maybe_victim in GLOB.player_list)
		if((maybe_victim.stat != DEAD) && maybe_victim.z == z)
			death_candidates += maybe_victim
	var/mob/living/carbon/human/H = null
	if(!death_candidates.len) // If there is 0 candidates - stop the spell.
		to_chat(src, "<span class='notice'>There is no more human survivors in the facility.</span>")
		return
	for(var/i in 1 to 5)
		if(!death_candidates.len) // No more candidates left? Let's stop picking through the list.
			break
		H = pick(death_candidates)
		addtimer(CALLBACK(src, .proc/eviscerate, H), i*4)
		death_candidates.Remove(H)

/mob/living/simple_animal/hostile/megafauna/claw/proc/eviscerate(mob/living/carbon/human/target)
	var/obj/effect/temp_visual/target_field/uhoh = new /obj/effect/temp_visual/target_field(target.loc)
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
	for(var/mob/living/L in range(1, get_turf(src))) // Attacks everyone around.
		if(faction_check_mob(L))
			continue
		to_chat(target, "<span class='userdanger'>\The [src] eviscerates you!</span>")
		L.apply_damage(50, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		new /obj/effect/temp_visual/cleave(get_turf(L))

// I hate how it's just a copy-paste of serum W, but oh well
/mob/living/simple_animal/hostile/megafauna/claw/proc/TriSerum()
	if(triserum_cooldown > world.time)
		return
	triserum_cooldown = world.time + triserum_cooldown_time
	var/list/mob/living/carbon/human/death_candidates = list()
	for(var/mob/living/carbon/human/maybe_victim in GLOB.player_list)
		if((maybe_victim.stat != DEAD) && maybe_victim.z == z)
			death_candidates += maybe_victim
	var/mob/living/carbon/human/H = null
	if(!death_candidates.len) // If there is 0 candidates - stop the spell.
		to_chat(src, "<span class='notice'>There is no more human survivors in the facility.</span>")
		return
	for(var/i in 1 to 5)
		if(!death_candidates.len) // No more candidates left? Let's stop picking through the list.
			break
		H = pick(death_candidates)
		addtimer(CALLBACK(src, .proc/triserum_eviscerate, H), i*5)
		death_candidates.Remove(H)

/mob/living/simple_animal/hostile/megafauna/claw/proc/triserum_eviscerate(mob/living/carbon/human/target)
	var/obj/effect/temp_visual/target_field/blue/uhoh = new /obj/effect/temp_visual/target_field/blue(target.loc)
	uhoh.orbit(target, 0)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
	playsound(src, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 1, 1)
	to_chat(target, "<span class='danger'>The [src] is going to hunt you down!</span>")
	addtimer(CALLBACK(src, .proc/triserum_eviscerate2, target, uhoh), 40)

/mob/living/simple_animal/hostile/megafauna/claw/proc/triserum_eviscerate2(mob/living/carbon/human/target, obj/effect/eff)
	if(target.z != z || !target.loc.AllowClick() || !target) // Be happy, mortal. Did you just hide in a locker?
		to_chat(src, "<span class='notice'>Your teleportation device malfunctions!</span>")
		to_chat(target, "<span class='notice'>It seems you are safe. For now...</span>")
		playsound(src.loc, 'ModularTegustation/Tegusounds/claw/error.ogg', 50, 1)
		qdel(eff)
		return
	visible_message("<span class='warning'>[src] blinks away!</span>")
	var/list/been_hit = list()
	var/turf/prev_loc = get_turf(src)
	new /obj/effect/temp_visual/emp/pulse(prev_loc)
	var/turf/tp_loc = get_step(target.loc, pick(0,1,2,4,5,6,8,9,10))
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	forceMove(tp_loc)
	qdel(eff)
	prev_loc.Beam(tp_loc, "bsa_beam", time=25)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1, 7)
	GiveTarget(target)
	for(var/mob/living/L in range(1, get_turf(src))) // Attacks everyone around.
		if(L in been_hit)
			continue
		if(faction_check_mob(L))
			continue
		been_hit |= L
		to_chat(target, "<span class='userdanger'>\The [src] eviscerates you!</span>")
		L.apply_damage(70, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
		new /obj/effect/temp_visual/cleave(get_turf(L))
	for(var/turf/B in getline(prev_loc, tp_loc))
		for(var/mob/living/L in range(1, B)) // Attacks everyone in line
			if(L in been_hit)
				continue
			if(faction_check_mob(L))
				continue
			been_hit |= L
			to_chat(L, "<span class='userdanger'>\The [src] slashes you!</span>")
			L.apply_damage(50, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
			playsound(L, 'ModularTegustation/Tegusounds/claw/attack.ogg', 35, 1)
			new /obj/effect/temp_visual/cleave(get_turf(L))

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
	icon_state = "claw_prepare"
	face_atom(target)

/mob/living/simple_animal/hostile/megafauna/claw/proc/swift_dash2(move_dir, times_ran, distance_run)
	if(times_ran > distance_run)
		charging = FALSE
		icon_state = icon_living
		return
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		icon_state = icon_living
		return
	new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	icon_state = "claw_dash"
	forceMove(T)
	playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
	for(var/mob/living/L in T.contents)
		if(faction_check_mob(L))
			continue
		L.apply_damage(100, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
		new /obj/effect/temp_visual/cleave(L.loc)
	addtimer(CALLBACK(src, .proc/swift_dash2, move_dir, (times_ran + 1), distance_run), 0.5)

/mob/living/simple_animal/hostile/megafauna/claw/proc/serumA(target)
	if(serumA_cooldown > world.time)
		return
	if(!isliving(target))
		return
	var/mob/living/LT = target
	serumA_cooldown = world.time + serumA_cooldown_time
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 100, 1)
	icon_state = "claw_prepare"
	charging = TRUE
	new /obj/effect/temp_visual/dir_setting/cult/phase(get_turf(LT))
	face_atom(target)
	SLEEP_CHECK_DEATH(7)
	icon_state = "claw_dash"
	for(var/i = 1 to 8)
		SLEEP_CHECK_DEATH(2)
		if(!LT)
			break
		addtimer(CALLBACK(src, .proc/blink, LT), 0)
	icon_state = icon_living
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/claw/proc/blink(mob/living/LT)
	var/turf/start_turf = get_turf(src)
	var/turf/target_turf = get_step(get_turf(LT), pick(1,2,4,5,6,8,9,10))
	for(var/i = 1 to 2) // For fancy effect
		target_turf = get_step(target_turf, get_dir(get_turf(start_turf), get_turf(target_turf)))
	for(var/turf/T in getline(start_turf, target_turf))
		new /obj/effect/temp_visual/cult/sparks(T) // Telegraph the attack
	face_atom(LT)
	SLEEP_CHECK_DEATH(2) // Some chance to escape
	forceMove(target_turf)
	playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	for(var/turf/B in getline(start_turf, target_turf))
		new /obj/effect/temp_visual/small_smoke/halfsecond(B)
		for(var/mob/living/victim in B)
			if(faction_check_mob(victim))
				continue
			to_chat(victim, "<span class='userdanger'>\The [src] slashes you!</span>")
			victim.apply_damage(50, RED_DAMAGE, null, victim.run_armor_check(null, RED_DAMAGE))
			new /obj/effect/temp_visual/cleave(victim.loc)
			playsound(victim, 'ModularTegustation/Tegusounds/claw/attack.ogg', 35, 1)
