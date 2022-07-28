/mob/living/simple_animal/hostile/abnormality/red_queen
	name = "Red Queen"
	desc = "A noble red abnormality sitting in her chair."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "redqueen"
	maxHealth = 650
	health = 650
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60
		)
	work_damage_amount = 30			//Unlikely to hurt you but if she ever does she'll fuck you
	work_damage_type = RED_DAMAGE

	ego_list = list(
		)
	var/liked


/mob/living/simple_animal/hostile/abnormality/red_queen/Initialize(mapload)
	. = ..()
	liked = pick(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION)
	//What does she like?
	//Pick it once so people can find out


/mob/living/simple_animal/hostile/abnormality/red_queen/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type != liked)
		if(prob(20))

			//The Red Queen is fickle, if you're unlucky, fuck you.
			user.apply_damage(200, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

			//Fitting sound, I want something crunchy, and also very loud so everyone knows
			playsound(src, 'sound/weapons/guillotine.ogg', 100, FALSE, 28)

			if(user.health < 0)
				var/obj/item/bodypart/head/head = user.get_bodypart("head")
				//OFF WITH HIS HEAD!
				if(!istype(head))
					return FALSE
				head.dismember()

				visible_message("<span class='danger'>\ [user]'s head comes flying off!</span>")
	return


