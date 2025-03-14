/mob/living/simple_animal/hostile/abnormality/skub
	name = "Skub"
	desc = "It's skub."
	health = 500
	maxHealth = 500
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	icon_living = "skub"
	portrait = "skub"
	can_breach = FALSE
	threat_level = WAW_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = 25,
		ABNORMALITY_WORK_ATTACHMENT = 25,
		ABNORMALITY_WORK_REPRESSION = list(10, 40, 50, 55, 60),
	)

	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	can_patrol = FALSE
	wander = FALSE

	ego_list = list(
		//datum/ego_datum/weapon/pro-skub,
		//datum/ego_datum/weapon/anti-skub,
		//datum/ego_datum/armor/pro-skub,
		//datum/ego_datum/armor/anti-skub,
	)
	//gift_type =  /datum/ego_gifts/insanity
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE
	var/list/currently_insane = list()
	var/insanity_counter

/*
/mob/living/simple_animal/hostile/abnormality/skub/Life()
	. = ..()
	if(!.) // Dead
		return FALSE

	//Count up insane people, add them to the insane list
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H in currently_insane)
			continue

		if(H.sanity_lost)
			insanity_counter++
			currently_insane|=H

	//Remove sane people from the insanity list so we can re-count them.
	for(var/mob/living/carbon/human/H in currently_insane)
		if(!H.sanity_lost)
			currently_insane -= H
*/
