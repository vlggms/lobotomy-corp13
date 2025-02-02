/mob/living/simple_animal/hostile/abnormality/branch12/madness
	name = "Heart Of Madness"
	desc = "A statue with a pulsating inner heart."
	health = 4000
	maxHealth = 4000
	icon = 'ModularTegustation/Teguicons/branch12/32x64.dmi'
	icon_state = "madness"
	icon_living = "madness"

	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 2.5, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(60, 60, 45, 30, 20),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 40, 40, 30),
		ABNORMALITY_WORK_REPRESSION = list(60, 40, 15, 0, 0),
	)
	max_boxes = 22

	light_color = COLOR_BUBBLEGUM_RED
	light_range = 30
	light_power = 7

	work_damage_amount = 10
	work_damage_type = PALE_DAMAGE
	can_patrol = FALSE
	wander = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/insanity,
		//datum/ego_datum/armor/branch12/insanity,
	)
	//gift_type =  /datum/ego_gifts/insanity
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/mob/living/linked_human

	//This shit is a blatany copypasta of Blue Star becuase the doc I was given is ALSO just bluestar in breach. I'm saving time.
	var/pulse_cooldown
	var/pulse_cooldown_time = 15 SECONDS
	var/pulse_damage = 80
	var/pulse_bleed = 20

	//This is for the server which is on life, and more constant
	var/sever_damage = 10
	var/sever_bleed = 3

/mob/living/simple_animal/hostile/abnormality/branch12/madness/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/madness/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/madness/Life()
	. = ..()
	if(!.) // Dead
		return FALSE


	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		MadnessPulse()

	if(health<=maxHealth/0.2)
		SplicePulse()

	if(!linked_human)
		return
	if(linked_human.stat == DEAD)
		datum_reference.qliphoth_change(-99)


/mob/living/simple_animal/hostile/abnormality/branch12/madness/proc/MadnessPulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color =  COLOR_BUBBLEGUM_RED, flash_time = 70)

	for(var/mob/living/L in GLOB.mob_list)
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		L.deal_damage((pulse_damage), WHITE_DAMAGE)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		H.apply_lc_bleed(pulse_bleed)
		if(H.sanity_lost)
			H.apply_lc_bleed(pulse_bleed*2) // Apply more bleed if you're insane, we're trying to kill you.

	SLEEP_CHECK_DEATH(3)

/mob/living/simple_animal/hostile/abnormality/branch12/madness/proc/SplicePulse()
	for(var/mob/living/L in view(7,src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		new /obj/effect/temp_visual/revenant(get_turf(L))
		L.deal_damage((sever_damage), BLACK_DAMAGE)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		H.apply_lc_bleed(sever_bleed)
		if(H.sanity_lost)
			H.apply_lc_bleed(sever_bleed*2) // Apply more bleed if you're insane, we're trying to kill you.


/mob/living/simple_animal/hostile/abnormality/branch12/madness/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	MadnessPulse()
	return

/mob/living/simple_animal/hostile/abnormality/branch12/madness/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()

	//Increase the counter of all Abnos HE and above. Includes this one.
	for(var/mob/living/simple_animal/hostile/abnormality/branch12/V in GLOB.mob_list)
		if(V.threat_level >= HE_LEVEL)
			V.datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/madness/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		if(prob(40))
			user.adjustBruteLoss(-500)
			user.adjustSanityLoss(-500)

	//If work type is attachment, heal all agents with low HP, lower counter by 1 for each.
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.health<H.maxHealth*0.3)
				H.adjustBruteLoss(-500)
				datum_reference.qliphoth_change(-1)

	//Set a random human to be chosen by Heart of Madness to be it's chosen.
	var/list/possible_links = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		possible_links += L
	if(!length(possible_links))
		return
	linked_human = pick(possible_links)
	to_chat(user, span_notice("The Heart of Madness has chosen [linked_human]."))
