/mob/living/simple_animal/hostile/abnormality/bald
	name = "you are bald"
	desc = "A helpful sphere, you think."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bald1"
	icon_living = "bald1"
	maxHealth = 50
	health = 50
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 30,
						ABNORMALITY_WORK_INSIGHT = 30,
						ABNORMALITY_WORK_ATTACHMENT = 30,
						ABNORMALITY_WORK_REPRESSION = 30
						)

	var/list/balding_list = list(
							"Bald",
							"Shaved"
							)
	var/bald_counter = 0

/mob/living/simple_animal/hostile/abnormality/bald/work_chance(mob/living/carbon/human/user, chance)
	if(user.hairstyle in balding_list)
		return 95
	return chance

/mob/living/simple_animal/hostile/abnormality/bald/work_complete(mob/living/carbon/human/user, work_type, pe, success_pe)
	..()
	do_bald(user)
	bald_counter += 1
	update_icon()

	switch(bald_counter)
		if(2)
			for(var/mob/living/carbon/human/H in range(14, user))
				if(prob(33))
					do_bald(H)
		if(4)
			for(var/mob/living/carbon/human/H in range(28, user))
				if(prob(66))
					do_bald(H)
		if(6) // Everyone is bald! Awesome!
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.z == z)
					do_bald(H)

/mob/living/simple_animal/hostile/abnormality/bald/proc/do_bald(mob/living/carbon/human/victim)
	if(!(victim.hairstyle in balding_list))
		to_chat(victim, "<span class='notice'>You feel awesome!</span>")
		ADD_TRAIT(victim, TRAIT_BALD, "ABNORMALITY_BALD")
		victim.hairstyle = pick(balding_list)
		victim.update_hair()

/mob/living/simple_animal/hostile/abnormality/bald/update_icon_state()
	icon_state = "bald1"
	switch(bald_counter)
		if(3 to 5)
			icon_state = "bald2"
		if(6 to INFINITY)
			icon_state = "bald3"
