/mob/living/simple_animal/hostile/abnormality/dingledangle
	name = "Dingle-Dangle"
	desc = "A giant, disgusting creature."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "dangle"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 50, 30, 30, 20),
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 70, 70, 70),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 30, 10, 10, 10),
		ABNORMALITY_WORK_REPRESSION = list(40, 30, 20, 10, 10)
			)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/lutemia,
		/datum/ego_datum/armor/lutemia
		)

	var/injured = FALSE
	var/dead = FALSE


/mob/living/simple_animal/hostile/abnormality/dingledangle/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 60)
		//I mean it does this in wonderlabs
		user.dust()

		//But here's the twist: You get a better ego.
		var/location = get_turf(user)
		new /obj/item/clothing/suit/armor/ego_gear/lutemis(location)

/mob/living/simple_animal/hostile/abnormality/dingledangle/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(50))
		//Yeah dust them too. No ego this time tho
		user.dust()


