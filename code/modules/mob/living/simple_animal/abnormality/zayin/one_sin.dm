/mob/living/simple_animal/hostile/abnormality/onesin
	name = "One sin and hundreds of good deeds"
	desc = "A giant skull that is attached to a cross, it wears a crown of thorns."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "onesin"
	icon_living = "onesin"
	maxHealth = 777
	health = 777
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(70, 70, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),
		"Confess" = 100
		)
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/penitence,
		/datum/ego_datum/armor/penitence
		)
	max_boxes = 10
	gift_type =  /datum/ego_gifts/penitence
	gift_message = "From this day forth, you shall never forget his words."

/mob/living/simple_animal/hostile/abnormality/onesin/work_chance(mob/living/carbon/human/user, chance)
	. = ..()
	if (istype(user.ego_gift_list[HAT], /datum/ego_gifts/penitence))
		return chance + 10

/mob/living/simple_animal/hostile/abnormality/onesin/attempt_work(mob/living/carbon/human/user, work_type)
	if(work_type == "Confess")
		if(isapostle(user))
			for(var/mob/living/simple_animal/hostile/abnormality/white_night/WN in GLOB.mob_living_list)
				if(WN.status_flags & GODMODE) // Contained
					return FALSE
			var/datum/antagonist/apostle/A = user.mind.has_antag_datum(/datum/antagonist/apostle, FALSE)
			if(!A.betrayed)
				A.betrayed = TRUE // So no spam happens
				for(var/mob/M in GLOB.player_list)
					if(M.client)
						M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_start.ogg', 25, 0)
				return TRUE
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/onesin/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "Confess")
		for(var/mob/living/simple_animal/hostile/abnormality/white_night/WN in GLOB.mob_living_list)
			if(WN.status_flags & GODMODE)
				return FALSE
			WN.heretics = list()
			to_chat(WN, "<span class='colossus'>The twelfth has betrayed us...</span>")
			WN.loot = list() // No loot for you!
			var/curr_health = WN.health
			for(var/i = 1 to 12)
				sleep(1.5 SECONDS)
				playsound(get_turf(WN), 'sound/machines/clockcult/ark_damage.ogg', 75, TRUE, -1)
				WN.adjustBruteLoss(curr_health/12)
			WN.adjustBruteLoss(666666)
		sleep(5 SECONDS)
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
		return
	if (prob(5)) // Will be 5%
		user.Apply_Gift(new /datum/ego_gifts/penitence)
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/success_effect(mob/living/carbon/human/user, work_type, pe)
	user.adjustSanityLoss(10) // It's healing
	if(pe >= datum_reference.max_boxes)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			H.adjustSanityLoss(10)
	..()

