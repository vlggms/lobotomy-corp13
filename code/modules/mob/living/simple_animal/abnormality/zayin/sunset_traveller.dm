/mob/living/simple_animal/hostile/abnormality/sunset_traveller
	name = "Sunset Traveller"
	desc = "A yellow creature with orange butterflies floating around it."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sunset"
	maxHealth = 400
	health = 400
	threat_level = ZAYIN_LEVEL

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 80,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	max_boxes = 8
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	light_color = COLOR_ORANGE
	light_range = 1
	light_power = 1

	ego_list = list(
		/datum/ego_datum/weapon/eclipse,
		/datum/ego_datum/armor/eclipse
	)

//	gift_type =  /datum/ego_gifts/nostalgia
	var/list/saylines = list("Wasn't it tiring coming all the way here?",
		"Really, check out those butterflies.",
		"Just watching them will warm your heart.")
	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7



/mob/living/simple_animal/hostile/abnormality/sunset_traveller/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(pe == 0)
		return
	say("Look at those butterflies! Aren't they just beautiful?")
	SLEEP_CHECK_DEATH(15)
	say("And gander at that sunset, too! Really makes you want to go for a stroll.")
	SLEEP_CHECK_DEATH(15)
	say("Why don't you stop for a moment and take a breather here?")
	while (PlayerCheck(user))
		//Heal 5% for every 3 seconds you're here
		user.adjustBruteLoss(-(maxHealth*0.05))
		user.adjustSanityLoss(-(maxHealth*0.05))
		if(prob(5))
			say(pick(saylines))
		SLEEP_CHECK_DEATH(30)


/mob/living/simple_animal/hostile/abnormality/sunset_traveller/proc/PlayerCheck(mob/living/carbon/human/user)
	if(user in view(5, src))
		return TRUE
	else
		say("You must be very busy then, another time, I suppose!")
		return FALSE

