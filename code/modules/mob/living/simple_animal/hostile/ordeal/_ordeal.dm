/mob/living/simple_animal/hostile/ordeal
	mob_size = MOB_SIZE_HUGE
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	a_intent = INTENT_HARM
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20

/mob/living/simple_animal/hostile/ordeal/death(gibbed)
	..()
	mob_size = MOB_SIZE_HUMAN //let body bags carry dead ordeals


//You should let these gib on Citymap
/mob/living/simple_animal/hostile/ordeal/Initialize()
	..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		stat_attack = HARD_CRIT	//Guarantee this


//Ordeal stuff here
/mob/living/simple_animal/hostile
	var/datum/ordeal/ordeal_reference
	var/ordeal_remove_ondeath = TRUE

/mob/living/simple_animal/hostile/proc/add_to_ordeal_list()
	GLOB.ordeal_list += src

/mob/living/simple_animal/hostile/proc/remove_from_ordeal_list()
	GLOB.ordeal_list -= src

/mob/living/simple_animal/hostile/death(gibbed)
	if(ordeal_reference && ordeal_remove_ondeath)
		remove_from_ordeal_list()
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	return ..()

/mob/living/simple_animal/hostile/Destroy()
	if(ordeal_reference)
		remove_from_ordeal_list()
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	return ..()
