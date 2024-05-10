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

/mob/living/simple_animal/hostile/ordeal/add_to_mob_list()
	. = ..()
	GLOB.ordeal_list += src

/mob/living/simple_animal/hostile/ordeal/remove_from_mob_list()
	. = ..()
	GLOB.ordeal_list -= src

/mob/living/simple_animal/hostile/ordeal/death(gibbed)
	mob_size = MOB_SIZE_HUMAN //let body bags carry dead ordeals
	if(ordeal_reference && ordeal_remove_ondeath)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

/mob/living/simple_animal/hostile/ordeal/Destroy()
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

//You should let these gib on Citymap
/mob/living/simple_animal/hostile/ordeal/Initialize()
	..()
	if(SSmaptype.maptype == "city")
		stat_attack = HARD_CRIT	//Guarantee this
