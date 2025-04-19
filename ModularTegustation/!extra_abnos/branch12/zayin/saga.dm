/mob/living/simple_animal/hostile/abnormality/branch12/saga
	name = "Saga Of Man"
	desc = "Contained on this parchment is the hopes and dreams of all of us."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "saga"
	icon_living = "saga"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(70, 70, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	threat_level = ZAYIN_LEVEL
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/branch12/age,
		/datum/ego_datum/armor/branch12/age,
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/current_saga = "Ready"
	var/last_ordeal = 0

	var/industry = 10

/mob/living/simple_animal/hostile/abnormality/branch12/saga/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	..()
	if(current_saga!= "Ready")
		return

	icon_state = "saga_inert"
	current_saga = pick("Ice Age", "Plague", "Famine", "Golden Age", "All Saint's Day", "Industrial Age")
	sound_to_playing_players_on_level('sound/abnormalities/silence/church.ogg', 50, zlevel = z)
	for(var/mob/H in GLOB.player_list)
		to_chat(H, span_spider("The Saga has been read! The new age for humanity is [current_saga]!"))

/mob/living/simple_animal/hostile/abnormality/branch12/saga/Life()
	..()
	if(SSlobotomy_corp.next_ordeal_level != last_ordeal)
		current_saga = "Ready"	//Make it ready
		icon_state = "saga"
		last_ordeal = SSlobotomy_corp.next_ordeal_level

	switch(current_saga)
		if("Ice Age")
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				if(H.z!=z)
					continue
				if(prob(1))
					to_chat(H, span_warning("The air is very cold."))
				H.adjustFireLoss(0.2)

		if("Famine")
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				if(H.z!=z)
					continue
				if(prob(1))
					to_chat(H, span_warning("You are oh so hungry."))
				H.adjust_nutrition(-0.5)

		if("Plague")
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				if(prob(2))
					if(H.z!=z)
						continue
					H.adjustToxLoss(3)
					to_chat(H, span_warning("You feel sick..."))

		if("Golden Age")
			if(prob(5))
				var/turf/T = pick(GLOB.xeno_spawn)
				var/obj/item/holochip/C = new (get_turf(T))
				C.credits = rand(200/4, 200)

		if("All Saint's Day")
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				if(H.z!=z)
					continue
				if(H.stat == DEAD)
					if(prob(30))
						if(H.revive(full_heal = TRUE, admin_revive = TRUE))
							H.revive(full_heal = TRUE, admin_revive = TRUE)
							H.grab_ghost(force = TRUE) // even suicides
							to_chat(H, span_spider("The bells are ringing. It's not your day to die."))
					else
						//Ashes to Ashes.
						H.dust()

		if("Industrial Age")
			if(prob(2)&& industry)
				industry--
				for(var/mob/living/carbon/human/H in GLOB.mob_list)
					if(H.z!=z)
						continue
					H.adjust_all_attribute_levels(2)
					to_chat(H, span_warning("Prosperitas!"))


		//Not
		if("Medical Age")
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				if(prob(5))
					if(H.z!=z)
						continue
					H.adjustBruteLoss(3)
