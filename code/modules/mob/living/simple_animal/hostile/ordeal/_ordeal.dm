/mob/living/simple_animal/hostile/ordeal
	mob_size = MOB_SIZE_HUGE
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	a_intent = INTENT_HARM
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	var/datum/ordeal/ordeal_reference
	var/ordeal_remove_ondeath = TRUE

/mob/living/simple_animal/hostile/ordeal/death(gibbed)
	if(ordeal_reference && ordeal_remove_ondeath)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

/mob/living/simple_animal/hostile/ordeal/Destroy()
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()
