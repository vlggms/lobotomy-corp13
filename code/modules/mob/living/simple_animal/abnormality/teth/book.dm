/mob/living/simple_animal/hostile/abnormality/book
	name = "Book Without Pictures or Dialogue"
	desc = "An old, dusty tome. There is a pen within the folded pages."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "book_0"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 45, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(60, 55, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 30)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/page,
		/datum/ego_datum/armor/page
		)
	gift_type = /datum/ego_gifts/page
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	var/wordcount = 0

/mob/living/simple_animal/hostile/abnormality/book/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(wordcount)
			if(Approach(user))
				visible_message(span_warning("[user] starts ripping pages out of [src]!"))
				playsound(get_turf(src), 'sound/items/poster_ripped.ogg', 50, 1, FALSE)
				wordcount = 0
				icon_state = "book_[wordcount]"
	else
		if(wordcount < 3)
			if(Approach(user))
				visible_message(span_warning("[user] begins writing in [src]!"))
				playsound(get_turf(src), 'sound/abnormalities/book/scribble.ogg', 90, 1, FALSE)
				SLEEP_CHECK_DEATH(3 SECONDS)
				if(wordcount < 3)
					wordcount ++
				icon_state = "book_[wordcount]"

/mob/living/simple_animal/hostile/abnormality/book/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_amount = 6 + (wordcount * 2)
	return ..()

/mob/living/simple_animal/hostile/abnormality/book/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		chance = chance * wordcount
	return chance

/mob/living/simple_animal/hostile/abnormality/book/proc/Approach(mob/living/carbon/human/user)
	if(user.sanity_lost || user.stat >= SOFT_CRIT)
		return FALSE
	icon_state = "book_[wordcount]"
	user.Stun(5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	return TRUE
