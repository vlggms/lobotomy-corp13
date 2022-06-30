/mob/living/simple_animal/hostile/ordeal
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	var/datum/ordeal/ordeal_reference

/mob/living/simple_animal/hostile/ordeal/death(gibbed)
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

/mob/living/simple_animal/hostile/ordeal/Destroy()
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

// Amber ordeals
/mob/living/simple_animal/hostile/ordeal/amber_bug
	name = "complete food"
	desc = "A tiny worm-like creature with tough chitin and a pair of sharp claws."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "amber_bug"
	icon_living = "amber_bug"
	icon_dead = "amber_bug_dead"
	maxHealth = 80
	health = 80
	speed = 2
	density = FALSE
	melee_damage_lower = 7
	melee_damage_upper = 8
	turns_per_move = 2
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)

/mob/living/simple_animal/hostile/ordeal/amber_bug/Initialize()
	..()
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/ordeal/amber_bug/AttackingTarget()
	. = ..()
	if(.)
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		animate(src, pixel_y = (base_pixel_y + 18), time = 2)
		addtimer(CALLBACK(src, .proc/AnimateBack), 2)
		for(var/i = 1 to 2)
			var/turf/T = get_step(get_turf(src), dir_to_target)
			if(T.density)
				return
			if(locate(/obj/structure/window) in T.contents)
				return
			for(var/obj/machinery/door/D in T.contents)
				if(D.density)
					return
			forceMove(T)
			SLEEP_CHECK_DEATH(2)

/mob/living/simple_animal/hostile/ordeal/amber_bug/proc/AnimateBack()
	animate(src, pixel_y = base_pixel_y, time = 2)
	return TRUE

// Violet ordeals
/mob/living/simple_animal/hostile/ordeal/violet_fruit
	name = "fruit of understanding"
	desc = "A round purple creature. It is constantly leaking mind-damaging gas."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "violet_fruit"
	icon_living = "violet_fruit"
	icon_dead = "violet_fruit_dead"
	maxHealth = 180
	health = 180
	speed = 2
	turns_per_move = 4 // Move a lot
	faction = list("neutral")
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/ReleaseDeathGas), 80 SECONDS)

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	for(var/mob/living/carbon/human/H in view(5, src))
		new /obj/effect/temp_visual/revenant(get_turf(H))
		new /obj/effect/temp_visual/revenant/cracks(get_turf(src))
		H.apply_damage(4, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
	return TRUE

/mob/living/simple_animal/hostile/ordeal/violet_fruit/proc/ReleaseDeathGas()
	if(stat == DEAD)
		return
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	turf_list = spiral_range_turfs(24, target_c)
	playsound(target_c, 'sound/effects/ordeals/violet/fruit_suicide.ogg', 50, 1, 10)
	adjustWhiteLoss(maxHealth) // Die
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/carbon/human/H in range(24, src))
		H.apply_damage(75, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), forced = TRUE)
	for(var/obj/machinery/computer/abnormality/A in range(24, src))
		if(prob(88) && A.datum_reference)
			A.datum_reference.qliphoth_change(pick(-2, -3))
