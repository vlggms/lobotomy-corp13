//Coded by Coxswain, sprite by Mel
/mob/living/simple_animal/hostile/abnormality/beanstalk
	name = "Beanstalk without Jack"
	desc = "A gigantic stem that reaches higher than the eye can see."
	icon = 'ModularTegustation/Teguicons/64x98.dmi'
	icon_state = "beanstalk"
	portrait = "beanstalk"
	maxHealth = 500
	health = 500
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(35, 45, 55, 0, 10),
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 7
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/bean,
		/datum/ego_datum/weapon/giant,
		/datum/ego_datum/armor/bean,
	)
	gift_type = /datum/ego_gifts/bean
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK
	var/climbing = FALSE

//Performing instinct work at >4 fortitude starts a special work
/mob/living/simple_animal/hostile/abnormality/beanstalk/AttemptWork(mob/living/carbon/human/user, work_type)
	if((get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80) && (work_type == ABNORMALITY_WORK_INSTINCT))
		work_damage_amount = 25 //hope you put on some armor
		climbing = TRUE
	return TRUE

//When working at <2 Temperance and Prudence, or when panicking it is an instant death.
/mob/living/simple_animal/hostile/abnormality/beanstalk/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 && get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40 || user.sanity_lost)
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		animate(user, alpha = 0,pixel_x = 0, pixel_z = 16, time = 3 SECONDS)
		to_chat(user, span_userdanger("You will make it to the top, no matter what!"))
		QDEL_IN(user, 3.5 SECONDS)

//The special work, if you survive you get a powerful EGO gift.
	if(climbing)
		if(user.sanity_lost || user.stat >= SOFT_CRIT || user.stat == DEAD)
			work_damage_amount = 7
			climbing = FALSE
			return

		user.Stun(3 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		to_chat(user, span_userdanger("You start to climb!"))
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 3 SECONDS)
		user.pixel_z = 16
		user.Stun(10 SECONDS)
		sleep(6 SECONDS)
		var/datum/ego_gifts/giant/BWJEG = new
		BWJEG.datum_reference = datum_reference
		user.Apply_Gift(BWJEG)
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 3 SECONDS)
		user.pixel_z = 0
		to_chat(user, span_userdanger("You return with the giant's treasure!"))

	work_damage_amount = 7
	climbing = FALSE

/datum/ego_gifts/giant
	name = "Giant"
	icon_state = "giant"
	fortitude_bonus = 8
	slot = LEFTBACK
