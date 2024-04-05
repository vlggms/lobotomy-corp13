// Green dawn
/mob/living/simple_animal/hostile/ordeal/green_bot/syringe
	name = "doubt B"
	desc = "A slim robot with a syringe in place of its hand."
	icon_state = "green_bot_b"
	icon_living = "green_bot_b"
	move_to_delay = 4
	melee_damage_lower = 14
	melee_damage_upper = 16

/mob/living/simple_animal/hostile/ordeal/green_bot/syringe/AttackingTarget()
	. = ..()
	if(.)
		if(!istype(target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = target
		H.add_movespeed_modifier(/datum/movespeed_modifier/clowned)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/grab_slowdown/aggressive), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/simple_animal/hostile/ordeal/green_bot/fast
	name = "doubt C"
	desc = "A slim robot with two spears."
	icon_state = "green_bot_c"
	icon_living = "green_bot_c"
	move_to_delay = 4
	rapid_melee = 3

/mob/living/simple_animal/hostile/ordeal/green_bot/factory/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

