/mob/living/simple_animal/hostile/abnormality/flesh_idol
	name = "Flesh Idol"
	desc = "A cross with flesh stapled in the middle."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "flesh_idol"
	maxHealth = 600
	health = 600
	threat_level = WAW_LEVEL
	pixel_x = -16
	base_pixel_x = -16
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40
			)
	start_qliphoth = 1
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/heart,
		/datum/ego_datum/armor/heart
		)
//	gift_type = /datum/ego_gifts/heart

	var/work_count = 0
	var/reset_time = 1 MINUTES
	var/heal_amount
	var/list/total_abnormalities = list()

/mob/living/simple_animal/hostile/abnormality/flesh_idol/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	work_count += 1
	if(work_count >= 4)
		work_count = 0
		datum_reference.qliphoth_change(-1)

	else if(work_count == 3)
		heal_amount = 100

	else
		heal_amount = 50

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD)
			H.adjustBruteLoss(-heal_amount) // It heals everyone by 50 or 100 points
			H.adjustSanityLoss(heal_amount) // It heals everyone by 50 or 100 points
			new /obj/effect/temp_visual/healing(get_turf(H))


//Meltdown
/mob/living/simple_animal/hostile/abnormality/flesh_idol/zero_qliphoth(mob/living/carbon/human/user)
	addtimer(CALLBACK(src, .proc/Reset), reset_time)
	var/num_breached
	total_abnormalities = list()
	var/run_number		//Randomly pick 2, but try 30 times. Chances are that if we don't catch breachables twice within 30 tries we're in an infinite loop

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.mob_list)
		total_abnormalities += A

	while(num_breached <= 2 && run_number <=30)
		var/mob/living/simple_animal/hostile/abnormality/processing = pick(total_abnormalities)
		total_abnormalities -= processing

		if(processing.can_breach && (processing.status_flags & GODMODE))
			processing.breach_effect()
			num_breached ++
		run_number++


/mob/living/simple_animal/hostile/abnormality/flesh_idol/proc/Reset()
	datum_reference.qliphoth_change(1)
