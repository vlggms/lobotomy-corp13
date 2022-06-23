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
	name = "perfect food"
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
		animate(src, pixel_y = (base_pixel_y + 12), time = 2)
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
