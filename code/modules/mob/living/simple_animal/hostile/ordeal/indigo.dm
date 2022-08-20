/mob/living/simple_animal/hostile/ordeal/indigo_noon
	name = "sweeper"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "sweeper_1"
	icon_living = "sweeper_1"
	icon_dead = "sweeper_dead"
	faction = list("indigo_ordeal")
	maxHealth = 500
	health = 500
	move_to_delay = 4
	stat_attack = DEAD
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 24
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/sweeper = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/sweeper = 1)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)
	blood_volume = BLOOD_VOLUME_NORMAL

/mob/living/simple_animal/hostile/ordeal/indigo_noon/Initialize()
	..()
	attack_sound = "sound/effects/ordeals/indigo/stab_[pick(1,2)].ogg"
	icon_living = "sweeper_[pick(1,2)]"
	icon_state = icon_living

/mob/living/simple_animal/hostile/ordeal/indigo_noon/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		"<span class='danger'>[src] devours [L]!</span>",
		"<span class='userdanger'>You feast on [L], restoring your health!</span>")
	adjustBruteLoss(-(maxHealth/2))
	L.gib()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_noon/PickTarget(list/Targets)
	if(health <= maxHealth * 0.6) // If we're damaged enough
		for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/sweeper in view(7, src)) // And there is no sweepers even more damaged than us
			if(sweeper.stat != DEAD && (health > sweeper.health))
				sweeper.PickTarget(Targets) // Let this sweeper see the same targets as we do
				return ..()
		var/list/highest_priority = list()
		for(var/mob/living/L in Targets)
			if(!CanAttack(L))
				continue
			if(L.health < 0 || L.stat == DEAD)
				highest_priority += L
		if(LAZYLEN(highest_priority))
			return pick(highest_priority)
	var/list/lower_priority = list() // We aren't exactly damaged, but it'd be a good idea to finish the wounded first
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(L.health < L.maxHealth*0.5 && (L.stat < UNCONSCIOUS))
			lower_priority += L
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/ordeal/indigo_midnight
	name = "Matriarch"
	desc = "A humanoid creature wearing metallic armor. The Queen of sweepers."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "matriarch"
	icon_living = "matriarch"
	icon_dead = "matriarch_dead"
	faction = list("indigo_ordeal")
	maxHealth = 5000
	health = 5000
	stat_attack = DEAD
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 60
	melee_damage_upper = 60
	ranged = TRUE
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/sweeper = 4)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/sweeper = 3)
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

	var/pulse_cooldown
	var/pulse_cooldown_time = 10 SECONDS
	var/pulse_damage = 10 // More over time


/mob/living/simple_animal/hostile/ordeal/indigo_midnight/AttackingTarget()
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
		slam_current = slam_cooldown
		aoe(2, 2)



/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/devour(mob/living/L)
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


/mob/living/simple_animal/hostile/ordeal/indigo_midnight/Life()
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

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/BlackPulse()
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


/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/phase2()
	icon_state = "phasechange"
	SLEEP_CHECK_DEATH(5)

	maxHealth = 4000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.25, PALE_DAMAGE = 0.8)
	move_to_delay -= move_to_delay*0.3
	speed -= speed*0.3
	rapid_melee +=1
	melee_damage_lower -= 10
	melee_damage_upper -= 10

	pulse_cooldown_time = 6 SECONDS
	slam_cooldown = 5
	icon_state = "matriarch_slim"
	icon_living = "matriarch_slim"
	phase = 2


/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/phase3()
	icon_state = "sicko_mode"
	SLEEP_CHECK_DEATH(5)

	maxHealth = 3000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1)
	move_to_delay -= move_to_delay*0.3
	speed -= speed*0.3
	rapid_melee += 2
	melee_damage_lower -= 15
	melee_damage_upper -= 15

	pulse_cooldown_time = 4 SECONDS
	slam_cooldown = 10
	icon_state = "matriarch_fast"
	icon_living = "matriarch_fast"
	phase = 3


/// cannibalized from wendigo
/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/aoe(range, delay)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(range, orgin)
	for(var/i = 0 to range)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			playsound(T,'sound/effects/bamf.ogg', 60, TRUE, 10)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/L in T)
				if(L == src || L.throwing)
					continue
				to_chat(L, "<span class='userdanger'>[src]'s ground slam shockwave sends you flying!</span>")
				var/turf/thrownat = get_ranged_target_turf_direct(src, L, 8, rand(-10, 10))
				L.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
				L.apply_damage(40, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				shake_camera(L, 2, 1)
			all_turfs -= T
		sleep(delay)

