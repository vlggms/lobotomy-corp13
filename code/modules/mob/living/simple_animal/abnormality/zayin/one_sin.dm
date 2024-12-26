/mob/living/simple_animal/hostile/abnormality/onesin
	name = "One Sin and Hundreds of Good Deeds"
	desc = "A giant skull that is attached to a cross, it wears a crown of thorns."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "onesin_halo_normal"
	icon_living = "onesin_halo_normal"
	portrait = "one_sin"
	maxHealth = 777
	health = 777
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(70, 70, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),
		"Confess" = 50,
	)
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/penitence,
		/datum/ego_datum/armor/penitence
	)
	max_boxes = 10
	gift_type = /datum/ego_gifts/penitence
	gift_message = "From this day forth, you shall never forget his words."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/white_night = 5,
	)

	chem_type = /datum/reagent/abnormality/onesin
	harvest_phrase = span_notice("As you hold it up before %ABNO, holy light fills %VESSEL.")
	harvest_phrase_third = "%PERSON holds up %VESSEL, letting it be filled with holy light."

	observation_prompt = "It has great power. It is savior that will judge you, and executioner that will put you in your demise. <br>\
		In its eyes, you find... <br>(Technically, it has no eyes, so in its pitch-black holes you find...)"
	observation_choices = list(
		"Nothing" = list(TRUE, "Darkness. <br>\
			Nothing is there. Have you found the answers you were looking for?"),
		"You find yourself" = list(FALSE, "You are found. <br>\
			You have great power. <br>You willingly lift the axe for the greater good."),
	)

	var/halo_status = "onesin_halo_normal" //used for changing the halo overlays

//Overlay stuff
/mob/living/simple_animal/hostile/abnormality/onesin/PostSpawn()
	..()
	update_icon()

/mob/living/simple_animal/hostile/abnormality/onesin/update_overlays()
	. = ..()
	. += "onesin" //by the nine this is too cursed

/mob/living/simple_animal/hostile/abnormality/onesin/WorkChance(mob/living/carbon/human/user, chance)
	if(istype(user.ego_gift_list[HAT], gift_type))
		return chance + 10
	return chance

/mob/living/simple_animal/hostile/abnormality/onesin/AttemptWork(mob/living/carbon/human/user, work_type)
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

/mob/living/simple_animal/hostile/abnormality/onesin/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "Confess")
		if(isapostle(user))
			for(var/mob/living/simple_animal/hostile/abnormality/white_night/WN in GLOB.mob_living_list)
				if(WN.status_flags & GODMODE)
					return FALSE
				WN.heretics = list()
				to_chat(WN, span_colossus("The twelfth has betrayed us..."))
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

		else
			var/heal_chance = rand(2,pe)

			if(heal_chance > 1)
				flick("onesin_halo_good", src)
				new /obj/effect/temp_visual/onesin_blessing(get_turf(user))
				user.adjustBruteLoss(-user.maxHealth)
				user.adjustSanityLoss(-user.maxSanity)
			else
				flick("onesin_halo_bad", src)
				new /obj/effect/temp_visual/onesin_punishment(get_turf(user))
				user.adjustSanityLoss(66)
				playsound(get_turf(user), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 33, 1)

			playsound(get_turf(user), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type != "Confess")
		new /obj/effect/temp_visual/onesin_blessing(get_turf(user))
		user.adjustSanityLoss(-user.maxSanity * 0.5) // It's healing
	if(pe >= datum_reference.max_boxes)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.z != z)
				continue
			if(H == user)
				continue
			new /obj/effect/temp_visual/onesin_blessing(get_turf(H))
			var/heal_factor = 0.5
			if(H.sanity_lost)
				heal_factor = 0.25
			H.adjustSanityLoss(-H.maxSanity * heal_factor)

/mob/living/simple_animal/hostile/abnormality/onesin/BreachEffect(mob/living/carbon/human/user, breach_type)
	return FALSE // If someone wants him to breach for SOME REASON in the future, then exclude breach_type == BREACH_PINK

/datum/reagent/abnormality/onesin
	name = "Holy Light"
	description = "It's calming, even if you can't quite look at it straight."
	color = "#eff16d"
	sanity_restore = -2
	special_properties = list("may alter sanity of those near the subject")

/datum/reagent/abnormality/onesin/on_mob_life(mob/living/L)
	for(var/mob/living/carbon/human/nearby in livinginview(9, get_turf(L)))
		nearby.adjustSanityLoss(-1)
	return ..()
