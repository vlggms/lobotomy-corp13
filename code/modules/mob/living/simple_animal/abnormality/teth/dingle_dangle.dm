/mob/living/simple_animal/hostile/abnormality/dingledangle
	name = "Dingle-Dangle"
	desc = "A giant, disgusting creature."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "dangle"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 60, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(30, 40, 70, 70, 70),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40
			)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/lutemia,
		/datum/ego_datum/armor/lutemia
		)
	gift_type = /datum/ego_gifts/lutemis
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/injured = FALSE
	var/dead = FALSE


/mob/living/simple_animal/hostile/abnormality/dingledangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 60)
		//I mean it does this in wonderlabs
		user.dust()

		//But here's the twist: You get a better ego.
		var/location = get_turf(user)
		new /obj/item/clothing/suit/armor/ego_gear/lutemis(location)

/mob/living/simple_animal/hostile/abnormality/dingledangle/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(50))
		//Yeah dust them too. No ego this time tho
		user.dust()


