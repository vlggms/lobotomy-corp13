/mob/living/simple_animal/hostile/abnormality/red_queen
	name = "Red Queen"
	desc = "A noble red abnormality sitting in her chair."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "redqueen"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 650
	health = 650
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 65,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 65,
		ABNORMALITY_WORK_REPRESSION = 65,
	)
	work_damage_amount = 20			//Unlikely to hurt you but if she ever does she'll fuck you
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/fury,
		/datum/ego_datum/armor/fury,
	)
	gift_type = /datum/ego_gifts/fury
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/liked

/mob/living/simple_animal/hostile/abnormality/red_queen/Initialize(mapload)
	. = ..()
	//What does she like?
	//Pick it once so people can find out
	liked = pick(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION)

/mob/living/simple_animal/hostile/abnormality/red_queen/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type != liked)
		if(prob(20))
			//The Red Queen is fickle, if you're unlucky, fuck you.
			user.visible_message(span_warning("An invisible blade slices through [user]'s neck!"))
			user.apply_damage(200, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/slice(get_turf(user))

			//Fitting sound, I want something crunchy, and also very loud so everyone knows
			playsound(src, 'sound/weapons/guillotine.ogg', 75, FALSE, 4)

			if(user.health < 0)
				var/obj/item/bodypart/head/head = user.get_bodypart("head")
				//OFF WITH HIS HEAD!
				if(!istype(head))
					return FALSE
				head.dismember()
	return
