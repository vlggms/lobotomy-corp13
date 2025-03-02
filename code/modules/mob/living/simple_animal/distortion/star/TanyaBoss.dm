//I mean, Red Mist would struggle to beat her, what makes you think a grade 1 fixer could?
/mob/living/simple_animal/hostile/distortion/Tanya
	name = "L'Heure du Loup"
	desc = "You are about to be beaten to death."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "Tanya"
	icon_living = "Tanya"
	icon_dead = "Tanya"
	maxHealth = 15000
	health = 15000
	del_on_death = TRUE
	pixel_x = 0
	base_pixel_x = 0
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.8)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 95
	melee_damage_upper = 100
	rapid_melee = 2
	pixel_x = -10
	move_to_delay = 2
	ranged = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/distortions/TanyaPunch.ogg'
	stat_attack = HARD_CRIT
	faction = list("hostile", "crimsonOrdeal", "bongy")
	attack_action_types = list(
		/datum/action/innate/abnormality_attack/rudolta_buff_onrush,
	)
	var/list/fire_list = list()
	var/can_act = TRUE
	// Onrush vars
	var/onrush_cooldown
	var/onrush_cooldown_time = 10 SECONDS
	var/onrush_damage = 150
	var/onrush_max_iterations = 10
	var/onrush_min_delay = 1
	var/onrush_max_delay = 2
	var/onrush_double_hit = FALSE
	var/list/onrush_hit = list()
	var/list/onrush_sounds = list(
		'sound/distortions/TanyaBeatdown.ogg',
		'sound/distortions/TanyaBeatdown2.ogg',
	)
	can_patrol = TRUE
/datum/action/innate/abnormality_attack/rudolta_buff_onrush
	name = "Onrush"
	button_icon_state = "generic_toggle0"
	chosen_attack_num = 1
	chosen_message = span_colossus("You will beat down everyone at once.")

/mob/living/simple_animal/hostile/distortion/Tanya/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/Tanya/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE

	if(onrush_cooldown <= world.time)
		OnRush(target)
		return

	return ..()

/mob/living/simple_animal/hostile/distortion/Tanya/OpenFire()
	if(!can_act)
		return FALSE

	if(client)
		switch(chosen_attack)
			if(1)
				OnRush(target)
		return

	if(onrush_cooldown <= world.time)
		OnRush(target)
		return


	return

/mob/living/simple_animal/hostile/distortion/Tanya/death()
	animate(src, alpha = 0, time = (10 SECONDS))
	QDEL_IN(src, (10 SECONDS))
	return ..()

// Copy and paste Red Mist
/mob/living/simple_animal/hostile/distortion/Tanya/proc/OnRush(mob/living/target, iteration = 0)
	if(!can_act && !iteration)
		return

	if(!iteration && onrush_cooldown > world.time)
		return

	if(iteration >= onrush_max_iterations)
		can_act = TRUE
		return

	can_act = FALSE
	onrush_cooldown = world.time + onrush_cooldown_time
	face_atom(target)
	if(!iteration)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 3)
		visible_message(span_danger("[src] prepares to beat everyone to a pulp!"))
		onrush_hit = list()
		SLEEP_CHECK_DEATH(5)

	if(!istype(target))
		can_act = TRUE
		return

	var/turf/target_turf = get_step(target, get_dir(target, src))
	var/list/line_list = getline(src, target_turf)
	for(var/i = 1 to length(line_list))
		var/turf/TT = line_list[i]
		var/obj/effect/temp_visual/decoy/D = new (TT, src)
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 4 + i*2)

	forceMove(target_turf)
	// PUNCH!!!!
	playsound(src, pick(onrush_sounds), rand(50, 100), TRUE, 7)
	to_chat(target, span_userdanger("[src] punches you hard!"))
	if(!onrush_double_hit)
		onrush_hit |= target
	var/turf/thrownat = get_ranged_target_turf_direct(src, target, 15, rand(-30, 30))
	target.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = FALSE)
	target.deal_damage(onrush_damage, RED_DAMAGE)
	new /obj/effect/temp_visual/smash_effect(get_turf(target))
	shake_camera(target, 2, 5)

	if(iteration >= onrush_max_iterations)
		can_act = TRUE
		onrush_hit = list()
		return

	// Pick new target
	var/list/valid_targets = list()
	for(var/mob/living/L in view(9, src))
		if(L.stat == DEAD)
			continue
		if(faction_check_mob(L))
			continue
		if((L in onrush_hit) && !onrush_double_hit)
			continue
		if(L == target)
			continue
		valid_targets += L

	if(!LAZYLEN(valid_targets))
		can_act = TRUE
		onrush_hit = list()
		return

	var/mob/living/L = pick(valid_targets)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(L), L)
	animate(D, alpha = 0, transform = matrix()*1.2, time = 3)
	face_atom(L)
	addtimer(CALLBACK(src, PROC_REF(OnRush), L, iteration + 1), rand(onrush_min_delay, onrush_max_delay))
	return

/mob/living/simple_animal/hostile/distortion/Tanya/death()
	for(var/V in fire_list)
		fire_list-=V
		qdel(V)
	..()

/mob/living/simple_animal/hostile/distortion/Tanya/Move()
	..()
	for(var/obj/structure/spreading/Tanya_sand/Y in get_turf(src))
		return TRUE
	new /obj/structure/spreading/Tanya_sand (get_turf(src))
	return TRUE
//sandstorm, this one is so damn funny
/obj/structure/spreading/Tanya_sand
	gender = PLURAL
	name = "Fierce Sands"
	desc = "A raging sandstorm"
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "ash_storm"
	alpha = 200
	anchored = TRUE
	density = FALSE
	layer = SPACEVINE_LAYER
	plane = 4
	max_integrity = 100000
	base_icon_state = "ash_storm"
	//expand_cooldown = 20 SECONDS
	can_expand = TRUE
	bypass_density = TRUE
	var/mob/living/simple_animal/hostile/distortion/Tanya/connected_abno

/obj/structure/spreading/Tanya_sand/Initialize()
	. = ..()
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/distortion/Tanya) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.fire_list += src
	expand()


/obj/structure/spreading/Tanya_sand/expand()
	addtimer(CALLBACK(src, PROC_REF(expand)), 60 SECONDS)
	..()

/obj/structure/spreading/Tanya_sand/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(3, FIRE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

