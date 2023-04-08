/mob/living/simple_animal/hostile/abnormality/bald
	name = "You’re Bald..."
	desc = "A helpful sphere, you think."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bald1"
	icon_living = "bald1"
	maxHealth = 50
	health = 50
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = 0,
						ABNORMALITY_WORK_ATTACHMENT = 0,
						ABNORMALITY_WORK_REPRESSION = 0
						)
	work_damage_amount = 4
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/tough,
		/datum/ego_datum/armor/tough
		)
	gift_type =  /datum/ego_gifts/tough
	gift_chance = 10
	gift_message = "Now we're feeling awesome!"
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	var/bald_users = list()

/mob/living/simple_animal/hostile/abnormality/bald/WorkChance(mob/living/carbon/human/user, chance)
	if(HAS_TRAIT(user, TRAIT_BALD))
		return 95
	return chance

/mob/living/simple_animal/hostile/abnormality/bald/WorktickSuccess(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_BALD))
		user.adjustSanityLoss(-user.maxSanity * 0.05) // Half of sanity restored for bald people
	return ..()

/mob/living/simple_animal/hostile/abnormality/bald/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(!do_bald(user)) // Already bald
		return
	bald_users |= user.ckey
	update_icon()
	switch(length(bald_users))
		if(2)
			for(var/mob/living/carbon/human/H in livinginrange(18, user))
				if(prob(35))
					do_bald(H)
		if(4)
			for(var/mob/living/carbon/human/H in livinginrange(36, user))
				if(prob(35))
					do_bald(H)
		if(6) // Everyone is bald! Awesome!
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.z == z)
					do_bald(H)

/mob/living/simple_animal/hostile/abnormality/bald/proc/do_bald(mob/living/carbon/human/victim)
	if(!HAS_TRAIT(victim, TRAIT_BALD))
		to_chat(victim, "<span class='notice'>You feel awesome!</span>")
		ADD_TRAIT(victim, TRAIT_BALD, "ABNORMALITY_BALD")
		victim.hairstyle = "Bald"
		victim.update_hair()
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bald/update_icon_state()
	switch(length(bald_users))
		if(3 to 5)
			icon_state = "bald2"
		if(6 to INFINITY)
			icon_state = "bald3"
		else
			icon_state = "bald1"

