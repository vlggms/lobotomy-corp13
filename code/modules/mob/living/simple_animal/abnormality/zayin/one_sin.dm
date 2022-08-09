/mob/living/simple_animal/hostile/abnormality/onesin
	name = "One Sin and Hundreds of Good Deeds"
	desc = "A levitating crucifix melded to a human skull, bound tightly by a mocking crown of thorns, instrument of the passion."
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

/mob/living/simple_animal/hostile/abnormality/onesin/attempt_work(mob/living/carbon/human/user, work_type)
	if(work_type == "Confess")
		if(isapostle(user))
			for(var/mob/living/simple_animal/hostile/abnormality/white_night/WN in GLOB.mob_living_list)
				if(WN.apostle_num != 666)
					return FALSE
			var/datum/antagonist/apostle/A = user.mind.has_antag_datum(/datum/antagonist/apostle, FALSE)
			if(!A.betrayed && A.number == 12) // Heretic
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
			if(WN.apostle_num != 666)
				return FALSE
			to_chat(WN, "<span class='colossus'>The twelfth has betrayed us!</span>")
			WN.loot = list() // No loot for you!
			for(var/i = 1 to 12)
				sleep(1.5 SECONDS)
				playsound(get_turf(WN), 'sound/machines/clockcult/ark_damage.ogg', 75, TRUE, -1)
				WN.adjustBruteLoss(WN.maxHealth/12)
			WN.adjustBruteLoss(666666)
		sleep(5 SECONDS)
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/success_effect(mob/living/carbon/human/user, work_type, pe)
	user.adjustSanityLoss(10) // It's healing
	if(pe >= datum_reference.max_boxes)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			H.adjustSanityLoss(10)
	..()

/mob/living/simple_animal/hostile/abnormality/onesin/attackby(obj/item/I, mob/living/user, params)
	..()
	if(status_flags & GODMODE && prob(10))
	var/turf/lightning_source = get_step(get_step(target, NORTH), NORTH)
	lightning_source.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
	target.adjustBruteLoss(LIGHTNING_BOLT_DAMAGE)
	playsound(get_turf(user), 'sound/magic/lightningbolt.ogg', 50, TRUE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.electrocution_animation(LIGHTNING_BOLT_ELECTROCUTION_ANIMATION_LENGTH)
		to_chat(target, "<span class='userdanger'>Father, forgive them, for they know not what they do!</span>",
	confidential = TRUE)
