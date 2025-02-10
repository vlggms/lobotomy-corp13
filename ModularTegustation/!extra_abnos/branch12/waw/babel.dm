//Hand of Babel
/mob/living/simple_animal/hostile/abnormality/branch12/babel
	name = "Hand of Babel"
	desc = "They reached for the stars, only for them to be pulled beyond their reach."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "babel"
	icon_living = "babel"
	blood_volume = 0
	threat_level = WAW_LEVEL
	start_qliphoth = 0
	can_breach = FALSE
	max_boxes = 20
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_amount = 7
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
	//	/datum/ego_datum/weapon/rumor,
	//	/datum/ego_datum/armor/rumor,
	)
	//gift_type =  /datum/ego_gifts/rumor
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


	//Who is affected by rumor
	var/list/rumors = list()

/mob/living/simple_animal/hostile/abnormality/branch12/babel/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

// Rumor Effect
/datum/status_effect/display/rumor
	id = "rumor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "rumor"

/datum/status_effect/display/rumor/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale) in GLOB.abnormality_mob_list
		connected_abno.rumors += H


/datum/status_effect/display/rumor/tick()
	. = ..()
	for(var/mob/living/carbon/human/H in view(4, src))

/datum/status_effect/display/rumor/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale) in GLOB.abnormality_mob_list
		connected_abno.rumors -= H
