/mob/living/simple_animal/hostile/abnormality/cherry_blossoms
	name = "Grave of Cherry Blossoms"
	desc = "A beautiful cherry tree."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "graveofcherryblossoms_3"
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -16
	base_pixel_y = -16
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 20
			)
	start_qliphoth = 3
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/blossom,
		/datum/ego_datum/armor/blossom
		)
//	gift_type = /datum/ego_gifts/blossom
	var/numbermarked = 5


/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	if(datum_reference.qliphoth_meter !=3)
		icon_state = "graveofcherryblossoms_[datum_reference.qliphoth_meter]"

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/zero_qliphoth(mob/living/carbon/human/user)
	mark_for_death()
	icon_state = "graveofcherryblossoms_0"
	datum_reference.qliphoth_change(3)
	return

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/proc/mark_for_death()
	var/mob/living/carbon/human/L = pick(GLOB.player_list)
	L.gib()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD)
			H.adjustBruteLoss(-500) // It heals everyone to full
			H.adjustSanityLoss(500) // It heals everyone to full

