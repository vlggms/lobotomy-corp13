/mob/living/simple_animal/hostile/ordeal
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	move_resist = MOVE_FORCE_STRONG
	a_intent = INTENT_HARM
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
