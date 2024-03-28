/mob/living/simple_animal/hostile/abnormality/sunset_traveller
	name = "Sunset Traveller"
	desc = "A yellow creature with orange butterflies floating around it."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sunset"
	portrait = "sunset_traveller"
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
	environment_smash = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/eclipse,
		/datum/ego_datum/armor/eclipse,
	)

	gift_type =  /datum/ego_gifts/eclipse
	var/list/saylines = list(
		"Wasn't it tiring coming all the way here?",
		"Really, check out those butterflies.",
		"Just watching them will warm your heart.",
	)
	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7
	var/healing = FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/AttemptWork(mob/living/carbon/human/user, work_type)
	if(healing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(pe == 0)
		return
	if(healing)
		return
	Heal(user)

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/proc/Heal(mob/living/carbon/human/user)
	set waitfor = FALSE
	healing = TRUE
	say("Look at those butterflies! Aren't they just beautiful?")
	SLEEP_CHECK_DEATH(15)
	say("And gander at that sunset, too! Really makes you want to go for a stroll.")
	SLEEP_CHECK_DEATH(15)
	say("Why don't you stop for a moment and take a breather here?")
	while (PlayerCheck(user))
		for(var/mob/living/carbon/human/H in view(3, src))
			//Heal 5% for every 3 seconds you're here
			H.adjustBruteLoss(-(H.maxHealth*0.05))
			H.adjustSanityLoss(-(H.maxSanity*0.05))
		if(prob(5))
			say(pick(saylines))
		SLEEP_CHECK_DEATH(30)
	healing = FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/proc/PlayerCheck(mob/living/carbon/human/user)
	if(user in view(5, src))
		return TRUE
	else
		say("You must be very busy then, another time, I suppose!")
		return FALSE

// Pink Midnight

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		can_breach = TRUE
		for(var/mob/living/simple_animal/hostile/ordeal/pink_midnight/pm in GLOB.ordeal_list)
			var/count = 1
			for(var/turf/target_turf in view(4, pm))
				if(DT_PROB(10, count))
					forceMove(target_turf)
					break
				count++
			break
		. = ..()
		HealAlt()
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/CanBeAttacked()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_traveller/proc/HealAlt()
	set waitfor = FALSE
	while (stat != DEAD)
		for(var/mob/living/L in view(5, src))
			L.adjustBruteLoss(-L.maxHealth*0.02)
		if(prob(5))
			say(pick(saylines))
		SLEEP_CHECK_DEATH(10)

