// Gold Midnight
/mob/living/simple_animal/hostile/ordeal/gold_midnight
	name = "Kromer"
	desc = "You're gonna be a big shot!"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "kromer"
	icon_living = "kromer"
	icon_dead = "kromer_dead"
	faction = list("gold_ordeal")
	maxHealth = 5000
	health = 5000
	stat_attack = DEAD
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	move_to_delay = 3
	speed = 3
	rapid_melee = 2
	melee_damage_lower = 60
	melee_damage_upper = 60
	ranged = TRUE
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 4)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 3)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.5)
	blood_volume = BLOOD_VOLUME_NORMAL
	move_resist = MOVE_FORCE_OVERPOWERING

	//How many people has she eaten
	var/belly = 0
	//How mad is she?
	var/phase = 1

	//How often does she slam?
	var/slam_cooldown = 3
	var/slam_current = 3
	var/slam_damage = 100
	var/slamming = FALSE

	var/pulse_cooldown
	var/pulse_cooldown_time = 10 SECONDS
	var/pulse_damage = 10 // More over time

	//Spawning sweepers
	var/pissed_count
	var/pissed_threshold = 16

	//phase speedchange
	var/phase2speed = 2.4
	var/phase3speed = 1.8


/mob/living/simple_animal/hostile/ordeal/gold_midnight/Move()
	if(slamming)
		return FALSE
	..()

/mob/living/simple_animal/hostile/ordeal/gold_midnight/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

	slam_current-=1
	if(slam_current == 0)
		slamming = TRUE
		slam_current = slam_cooldown
		aoe(2, 1)

/mob/living/simple_animal/hostile/ordeal/gold_midnight/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		"<span class='danger'>[src] devours [L]!</span>",
		"<span class='userdanger'>You feast on [L], restoring your health!</span>")
	adjustBruteLoss(-(maxHealth*0.3))
	L.gib()
	//Increase the Vore counter by 1
	belly += 1
	pulse_damage += 2
	//She gets faster but not as protected or as strong
	if(belly == 5 && phase == 1)
		phase2()
	if(belly == 10 && phase == 2)
		phase3()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/gold_midnight/bullet_act(obj/projectile/P)
	..()
	pissed_count += 1
	if(pissed_count >= pissed_threshold)
		pissed_count = 0
		for(var/turf/T in orange(1, src))
			if(T.density)
				continue
			if(prob(20))
				new /obj/effect/sweeperspawn(T)

/mob/living/simple_animal/hostile/ordeal/gold_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(pulse_cooldown < world.time)
		BlackPulse()
		//Putting this here so that it doesn't look weird
		if(health == maxHealth/2 && phase == 1)
			phase2()
		if(health == maxHealth/4 && phase == 2)
			phase3()

/mob/living/simple_animal/hostile/ordeal/gold_midnight/proc/BlackPulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/weapons/resonator_blast.ogg', 100, FALSE, 90)
	for(var/mob/living/L in urange(90, src))
		if(faction_check_mob(L))
			continue
		//don't kill if you're too close.
		var/distance = round(get_dist(src, L))
		if(distance <= 10)
			continue
		L.apply_damage(((pulse_damage + distance - 10)*0.5), BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/ordeal/gold_midnight/proc/phase2()
	icon_state = "kromer_phasechange"
	SLEEP_CHECK_DEATH(5)

	maxHealth = 4000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.25, PALE_DAMAGE = 0.8)
	move_to_delay = phase2speed
	speed = phase2speed
	rapid_melee +=1
	melee_damage_lower -= 10
	melee_damage_upper -= 10

	pulse_cooldown_time = 6 SECONDS
	slam_cooldown = 5
	icon_state = "kromer_slim"
	icon_living = "kromer_slim"
	phase = 2


/mob/living/simple_animal/hostile/ordeal/gold_midnight/proc/phase3()
	icon_state = "kromer_mode"
	SLEEP_CHECK_DEATH(5)

	maxHealth = 3000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1)
	move_to_delay = phase3speed
	speed = phase3speed
	rapid_melee += 2
	melee_damage_lower -= 15
	melee_damage_upper -= 15

	pulse_cooldown_time = 4 SECONDS
	slam_cooldown = 10
	icon_state = "kromer_fast"
	icon_living = "kromer_fast"
	phase = 3


/// cannibalized from wendigo
/mob/living/simple_animal/hostile/ordeal/gold_midnight/proc/aoe(range, delay)
	for(var/turf/W in range(range, src))
		new /obj/effect/temp_visual/guardian/phase(W)
	sleep(10)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(range, orgin)
	for(var/i = 0 to range)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			playsound(T,'sound/effects/bamf.ogg', 60, TRUE, 10)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/carbon/human/L in T)
				if(L == src || L.throwing)
					continue
				to_chat(L, "<span class='userdanger'>[src]'s ground slam shockwave sends you flying!</span>")
				var/turf/thrownat = get_ranged_target_turf_direct(src, L, 8, rand(-10, 10))
				L.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
				L.apply_damage(slam_damage, RED_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				shake_camera(L, 2, 1)
			all_turfs -= T
		sleep(delay)
	slamming = FALSE

/obj/effect/sinspawn
	name = "bloodpool"
	desc = "A target warning you of incoming pain"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "bloodin"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/sinspawn/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/spawnscout), 6)

/obj/effect/sinspawn/proc/spawnscout()
	new /mob/living/simple_animal/hostile/ordeal/gold_spawn(get_turf(src))
	qdel(src)

/mob/living/simple_animal/hostile/ordeal/gold_spawn
	name = "sweeper scout"
	desc = "It looks a bit off."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "gold_dawn"
	icon_living = "gold_dawn"
	icon_dead = "gold_dawn_dead"
	faction = list("gold_ordeal")
	maxHealth = 110
	health = 110
	move_to_delay = 1.3	//Super fast, but squishy and weak.
	stat_attack = HARD_CRIT
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	melee_damage_lower = 21
	melee_damage_upper = 24
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)
	blood_volume = BLOOD_VOLUME_NORMAL
