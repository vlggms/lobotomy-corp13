/mob/living/simple_animal/hostile/abnormality/bottle
	name = "Bottle of Tears"
	desc = "A bottle filled with water with a cake on top"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bottle1"
	icon_living = "bottle1"
	maxHealth = 400
	health = 400
	threat_level = ZAYIN_LEVEL
	work_chances = list(		//In the comic they work on it. They say you can do any work as long as you don't eat the cake
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),	//How the fuck do you beat up a cake?
		"Consume" = 100			//You can instead decide to eat the cake.
		)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/little_alice,
		/datum/ego_datum/armor/little_alice
		)
	max_boxes = 10
	var/cake = 5	//How many cake charges are there

/mob/living/simple_animal/hostile/abnormality/bottle/attempt_work(mob/living/carbon/human/user, work_type)
	if(cake==0)
		if(work_type == "Consume")
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/bottle/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "Consume")
		cake -= 1		//Eat some cake
		if(cake == 0)
			//Drowns you like Wellcheers does, so I mean the code checks out
			for(var/turf/open/T in view(7, src))
				new /obj/effect/temp_visual/water_waves(T)
			to_chat(user, "<span class='userdanger'>The room is filling with water! You're going to drown!</span>")
			icon_state = "bottle3"	//cake all gone

			var/location = get_turf(user)
			new /obj/item/ego_weapon/eyeball(location)

			user.AdjustSleeping(10 SECONDS)
			animate(user, alpha = 0, time = 2 SECONDS)
			QDEL_IN(user, 3.5 SECONDS)

		if(cake > 0)
			user.adjustBruteLoss(-500) // It heals you to full if you eat it
			icon_state = "bottle2"	//cake looks eaten

	return ..()

