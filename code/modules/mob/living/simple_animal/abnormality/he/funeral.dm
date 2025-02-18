/mob/living/simple_animal/hostile/abnormality/funeral
	name = "Funeral of the Dead Butterflies"
	desc = "An towering abnormality possessing a white butterfly for a head and a coffin on its back."
	icon = 'ModularTegustation/Teguicons/64x96.dmi' //HOW DO I TURN A PNG INTO THE DMI SPRITES AAAAAAAAAAAAAAA
	icon_state = "funeral"
	icon_living = "funeral"
	icon_dead = "funeral_dead"
	portrait = "funeral"
	del_on_death = FALSE
	maxHealth = 1350 //I am a menace to society.
	health = 1350
	blood_volume = 0

	ranged = TRUE
	minimum_distance = 2
	retreat_distance = 1

	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 2)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	can_buckle = FALSE
	vision_range = 14
	aggro_vision_range = 20
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 45, 40, 0, 0),
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 60, 60, 60),
	)
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	max_boxes = 16
	death_message = "gently descends into its own coffin."
	base_pixel_x = -16
	pixel_x = -16

	ego_list = list(
		/datum/ego_datum/weapon/solemnvow,
		/datum/ego_datum/weapon/solemnlament,
		/datum/ego_datum/armor/solemnlament,
	)
	gift_type =  /datum/ego_gifts/solemnlament
	gift_message = "The butterflies are waiting for the end of the world."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "A tall butterfly-faced man stands before, clad in an undertakers's garment. <br>\
		Between the two of you is a coffin and he gestures you towards it with all 3 of his hands."
	observation_choices = list(
		"Enter the coffin" = list(TRUE, "You lie down in the coffin as the butterfly-faced man stands by, his head angled and all 3 hands crossed together over his waist in a solemn gesture. <br>\
			It's a perfect fit for you. <br>\
			You feel the weight of innumerable lifetimes and the weariness that came with them. <br>\
			The butterflies lift you and the coffin as pallbearers, they lament for you in place of the people who cannot."),
		"Don't enter the coffin" = list(TRUE, "You don't enter because it's not your coffin. <br>\
			The undertaker reaches out his middle hand to his waiting, insectile audience and one of the butterflies lands upon his fingers. <br>\
			He offers you the butterfly and you place it into the coffin, gently. <br>\
			The butterflies are the souls of the dead, waiting to be put to rest, but are still mourning for the living. <br>\
			You and the butterfly-faced man stand in silent vigil. You both now share a vow; to grieve for the living and dead. <br>\
			A kaledioscope of butterflies follows you as you leave the containment unit."),
	)

	var/gun_cooldown
	var/gun_cooldown_time = 4 SECONDS
	var/gun_damage = 60
	var/swarm_cooldown
	var/swarm_cooldown_time = 20 SECONDS
	var/swarm_damage = 13 // 10 seconds, 13 damage 40 times = 520 total
	var/swarm_length = 24
	var/swarm_width = 3
	var/list/swarm_killed = list()
	var/can_act = TRUE

	//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/funeral_butterfly_toggle)

/datum/action/innate/abnormality_attack/toggle/funeral_butterfly_toggle
	name = "Toggle Casket Swarm"
	button_icon_state = "funeral_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You will now unleash a swarm of butterflies.")
	button_icon_toggle_activated = "funeral_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now fire butterflies from your hands.")
	button_icon_toggle_deactivated = "funeral_toggle0"

/mob/living/simple_animal/hostile/abnormality/funeral/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/funeral/OpenFire()
	if(!can_act)
		return
	if(client)
		switch(chosen_attack)
			if(1)
				SpiritGun(target)
			if(2)
				ButterflySwarm(target)
		return
	if(gun_cooldown <= world.time && prob(85))
		SpiritGun(target)
	else if(swarm_cooldown <= world.time && prob(50))
		ButterflySwarm(target)
	return

/mob/living/simple_animal/hostile/abnormality/funeral/proc/DensityCheck(turf/T) //TRUE if dense or airlocks closed
	if(T.density)
		return TRUE
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/funeral/proc/SpiritGun(atom/target)
	if(!isliving(target)||gun_cooldown > world.time)
		return
	var/mob/living/cooler_target = target
	if(cooler_target.stat == DEAD)
		return
	can_act = FALSE
	icon_state = "funeral_gun"
	visible_message(span_danger("[src] levels one of its arms at [cooler_target]!"))
	cooler_target.apply_status_effect(/datum/status_effect/spirit_gun_target) // Re-used for visual indicator
	dir = get_cardinal_dir(src, target)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/funeral/spiritgun.ogg', 75, 1, 3)
	cooler_target.remove_status_effect(/datum/status_effect/spirit_gun_target)
	can_act = TRUE
	gun_cooldown = world.time + gun_cooldown_time
	icon_state = icon_living
	var/line_of_sight = getline(get_turf(src), get_turf(target)) //better simulates a projectile attack
	for(var/turf/T in line_of_sight)
		if(DensityCheck(T))
			return
	cooler_target.deal_damage(gun_damage, WHITE_DAMAGE)
	visible_message(span_danger("[cooler_target] is hit by butterflies!"))
	//No longer because fuck you.
	if(ishuman(target))
		var/mob/living/carbon/human/kickass_grade1_target = target
		if(kickass_grade1_target.sanity_lost)
			kickass_grade1_target.death()
			KillAnimation(kickass_grade1_target)

/mob/living/simple_animal/hostile/abnormality/funeral/proc/ButterflySwarm(target)
	if(swarm_cooldown > world.time)
		return
	if (get_dist(src, target) < 4)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	//This check is to ensure funeral doesn't fire casket into a wall right next to them
	var/turf/adjacent_turf = get_step(src,dir_to_target)
	if(adjacent_turf.density)
		return
	var/list/middle_line = list()
	var/turf/source_turf = get_turf(src)
	middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, swarm_length))
	for(var/i = 1, i<=middle_line.len, i++) //middle turf must be clear for swarm to "flow"
		if(isturf(middle_line[i]))
			var/turf/T = middle_line[i]
			if(T.density)
				middle_line.Cut(i)
				break
	if(!LAZYLEN(middle_line))
		return
	can_act = FALSE
	dir = dir_to_target
	visible_message(span_danger("[src] prepares to open its coffin!"))
	icon_state = "funeral_coffin_butterfly_less"
	SLEEP_CHECK_DEATH(1.75 SECONDS)
	icon_state = "funeral_coffin"
	playsound(get_turf(src), 'sound/abnormalities/funeral/coffin.ogg', 40, extrarange = 10, ignore_walls = TRUE) // bwiiiiiiinng >flapping
	var/i = 0
	for(var/turf/T in middle_line)
		addtimer(CALLBACK(src, PROC_REF(SwarmTurf), T, dir_to_target), i*1.4) //swarm travel speed
		i++
	SLEEP_CHECK_DEATH(10 SECONDS)
	icon_state = icon_living
	swarm_killed = list()
	can_act = TRUE
	swarm_cooldown = world.time + swarm_cooldown_time

/mob/living/simple_animal/hostile/abnormality/funeral/proc/SwarmTurf(turf/T, direction)
	var/turf/hit_turfs = list()
	switch(direction)
		if(EAST)
			if(!T.density) //lets middle line to go through airlocks
				hit_turfs |= T
			for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, swarm_width)))
				if(DensityCheck(Y)) //prevents swarm width from going through airlocks
					break
				hit_turfs |= Y
			for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, swarm_width)))
				if(DensityCheck(U))
					break
				hit_turfs |= U
		if(WEST)
			if(!T.density)
				hit_turfs |= T
			for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, swarm_width)))
				if(DensityCheck(Y))
					break
				hit_turfs |= Y
			for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, swarm_width)))
				if(DensityCheck(U))
					break
				hit_turfs |= U
		if(SOUTH)
			if(!T.density)
				hit_turfs |= T
			for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, swarm_width)))
				if(DensityCheck(Y))
					break
				hit_turfs |= Y
			for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, swarm_width)))
				if(DensityCheck(U))
					break
				hit_turfs |= U
		if(NORTH)
			if(!T.density)
				hit_turfs |= T
			for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, swarm_width)))
				if(DensityCheck(Y))
					break
				hit_turfs |= Y
			for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, swarm_width)))
				if(DensityCheck(U))
					break
				hit_turfs |= U
		else
			return
	for(var/turf/TT in hit_turfs)
		if(locate(/obj/effect/temp_visual/funeral_swarm) in TT)
			continue
		new /obj/effect/temp_visual/funeral_swarm(TT)
		addtimer(CALLBACK(src, PROC_REF(SwarmTurfLinger), TT))

/mob/living/simple_animal/hostile/abnormality/funeral/proc/SwarmTurfLinger(turf/T)
	for(var/i = 1 to 40) //40 times
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), swarm_damage, WHITE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			if(H.stat == DEAD)
				continue
			if(H.sanity_lost)
				H.death()
				KillAnimation(H)
		SLEEP_CHECK_DEATH(0.25 SECONDS) //10 seconds

/mob/living/simple_animal/hostile/abnormality/funeral/proc/KillAnimation(mob/living/carbon/human/killed)
	var/pixel_y_before = killed.pixel_y
	animate(killed, pixel_y = 10, time = 10, easing = BACK_EASING | EASE_OUT)
	sleep(10)
	animate(killed, pixel_y = pixel_y_before, time = 10, , easing = CUBIC_EASING | EASE_OUT, flags = ANIMATION_END_NOW)
	var/obj/funeral_overlay = new
	funeral_overlay.icon = 'ModularTegustation/Teguicons/32x32.dmi'
	funeral_overlay.icon_state = "funeral_kill"
	funeral_overlay.layer = -BODY_FRONT_LAYER
	funeral_overlay.plane = FLOAT_PLANE
	funeral_overlay.mouse_opacity = 0
	funeral_overlay.vis_flags = VIS_INHERIT_ID
	var/matrix/M = matrix()
	M.Turn(90)
	funeral_overlay.transform = M
	funeral_overlay.alpha = 0
	animate(funeral_overlay, alpha = 255, time = 3 SECONDS)
	killed.vis_contents += funeral_overlay

/mob/living/simple_animal/hostile/abnormality/funeral/Move()
	if(!can_act)
		return FALSE
	return ..()
//he walk

/mob/living/simple_animal/hostile/abnormality/funeral/death(gibbed)
	density = FALSE
	var/matrix/M = matrix()
	M.Turn(-90) //horizontal coffin
	src.transform = M
	pixel_y -= 32
	pixel_x -= 16
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()
//he die

/mob/living/simple_animal/hostile/abnormality/funeral/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/funeral/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80)
		datum_reference.qliphoth_change(-1)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
	return

/datum/status_effect/spirit_gun_target
	id = "butterfly_target"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 2 SECONDS

/datum/status_effect/spirit_gun_target/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "funeral_swarm", -MUTATIONS_LAYER))

/datum/status_effect/spirit_gun_target/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "funeral_swarm", -MUTATIONS_LAYER))

/obj/effect/temp_visual/funeral_swarm
	name = "funeral swarm"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "funeral_swarm"
	layer = BELOW_MOB_LAYER
	duration = 10 SECONDS
