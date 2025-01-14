/mob/living/simple_animal/hostile/abnormality/wall_gazer
	name = "Lady Facing the Wall"
	desc = "An abnormality that is a pale, naked woman with long, black hair that completely obscures her face"
	icon = 'ModularTegustation/Teguicons/96x48.dmi'
	icon_state = "ladyfacingthewall"
	portrait = "lady_facing_the_wall"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 55, 55, 55),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 30, 30, 0),
		ABNORMALITY_WORK_ATTACHMENT = list(100, 100, 100, 100, 100),
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 30, 30, 30),
	)
	pixel_x = -32
	base_pixel_x = -8

	work_damage_amount = 7
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/woe
	start_qliphoth = 2
	var/scream_range = 10
	var/scream_damage = 45
	ego_list = list(
		/datum/ego_datum/weapon/wedge,
		/datum/ego_datum/armor/wedge,
	)
	gift_type =  /datum/ego_gifts/wedge
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "A woman is crying. \
		You cannot see her face as you are turned back to her. But you know who she is. \
		Her muttering is unintelligible, and it gives you goosebumps. You don't like being in the same space with her. \
		You want to get out. The woman seems to be sobbing. You feel as though her crying is insisting you to turn towards her. \
		And you also feel, that you should not."
	observation_choices = list(
		"Turn back" = list(TRUE, "You face the fear, and turn to face the woman."),
		"Do not turn back" = list(FALSE, "Something terrible could happen if you turn back. You exit the room, without looking back."),
	)

/mob/living/simple_animal/hostile/abnormality/wall_gazer/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(70))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/ZeroQliphoth(mob/living/carbon/human/user)
	scream()
	datum_reference.qliphoth_change(start_qliphoth)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/proc/scream()
	for(var/mob/living/L in range(scream_range, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		playsound(get_turf(src), 'sound/spookoween/girlscream.ogg', 400)
		L.deal_damage(scream_damage, WHITE_DAMAGE)

/mob/living/simple_animal/hostile/abnormality/wall_gazer/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// If you do work while having low Temperance, fuck you and you go insane for turning your back to face her
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		datum_reference.qliphoth_change(-1)

	if((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40) && !(GODMODE in user.status_flags))
		flick("ladyfacingthewall_active", src)
		user.adjustSanityLoss(user.maxSanity)
		user.apply_status_effect(/datum/status_effect/panicked_lvl_4)
	return
