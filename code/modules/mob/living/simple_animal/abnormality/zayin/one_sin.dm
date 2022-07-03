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
		ABNORMALITY_WORK_INSTINCT = list(
			1 = 45,
			2 = 40,
			3 = 35,
			4 = 30,
			5 = 25
			),
		ABNORMALITY_WORK_INSIGHT = list(
			1 = 80,
			2 = 75,
			3 = 70,
			4 = 65,
			5 = 60
			),
		ABNORMALITY_WORK_ATTACHMENT = list(
			1 = 90,
			2 = 85,
			3 = 80,
			4 = 75,
			5 = 70
			),
		ABNORMALITY_WORK_REPRESSION = list(
			1 = 40,
			2 = 35,
			3 = 30,
			4 = 25,
			5 = 20
			),
		"Confess" = 100
		)
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE

/mob/living/simple_animal/hostile/abnormality/onesin/attempt_work(mob/living/carbon/human/user, work_type)
	if(work_type == "Confess")
		if(isapostle(user))
			var/datum/antagonist/apostle/A = user.mind.has_antag_datum(/datum/antagonist/apostle, FALSE)
			if(!A.betrayed && A.number == 12) // Heretic
				A.betrayed = TRUE // So no spam happens
				for(var/mob/M in GLOB.player_list)
					if(M.client)
						M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_start.ogg', 25, 0)
				return TRUE
			return FALSE
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/onesin/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "Confess")
		for(var/datum/antagonist/A in GLOB.apostles)
			to_chat(A.owner.current, "<span class='colossus'>The twelfth has betrayed us...</span>")
		for(var/mob/living/simple_animal/hostile/abnormality/apostle/WN in GLOB.mob_living_list)
			to_chat(WN, "<span class='colossus'>The twelfth has betrayed us...</span>")
			for(var/i = 1 to 12)
				sleep(1.5 SECONDS)
				playsound(get_turf(WN), 'sound/machines/clockcult/ark_damage.ogg', 75, TRUE, -1)
				WN.adjustBruteLoss(WN.maxHealth/12)
			WN.adjustBruteLoss(666666) // Just in case
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
		return
	return ..()
