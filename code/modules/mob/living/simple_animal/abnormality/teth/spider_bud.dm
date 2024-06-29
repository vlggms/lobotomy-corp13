/mob/living/simple_animal/hostile/abnormality/spider
	name = "Spider Bud"
	desc = "An abnormality that resembles a massive spider. Tread carefully"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "spider_closed"
	portrait = "spider_bud"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(60, 60, 65, 65, 65),
		ABNORMALITY_WORK_INSIGHT = list(-50, -50, -50, -50, -50),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 55),
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 45, 45, 45),
	)
	success_boxes = 99 //Should be impossible
	pixel_x = -8
	base_pixel_x = -8

	work_damage_amount = 7
	work_damage_type = RED_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/eyes,
		/datum/ego_datum/armor/eyes,
	)
	gift_type =  /datum/ego_gifts/redeyes
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "I am a spider. I eat anything my web catches. I am starving. \
I haven't eaten anything for days. There is a big prey hanging on my web. \
My starvation could kill me if I don't eat something."
	observation_choices = list("Eat the prey.", "Do not eat the prey.")
	correct_choices = list("Do not eat the prey.")
	observation_success_message = "I could not eat the prey in front of me. \
This starvation is slowly tiring me. The prey struggles to get out, to survive. \
The struggle did nothing but shaking my web a little bit. And I watch the prey."
	observation_fail_message = "I devoured the prey. \
My body reacted faster than my thoughts. ... I am a spider. I eat anything my web catches."


/mob/living/simple_animal/hostile/abnormality/spider/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// If you do insight or have low prudence, fuck you and die for stepping on a spider
	if((get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40 || work_type == ABNORMALITY_WORK_INSIGHT) && !(GODMODE in user.status_flags))
		icon_state = "spider_open"
		var/obj/structure/spider/cocoon/casing = SpawnConnectedStructure(/obj/structure/spider/cocoon, pick(-1,0,1), pick(-1,0,1))
		user.death()
		user.forceMove(casing)
		casing.icon_state = pick(
			"cocoon_large1",
			"cocoon_large2",
			"cocoon_large3",
		)
		casing.density = FALSE
		SLEEP_CHECK_DEATH(50)
		icon_state = "spider_closed"
		datum_reference.max_boxes+=2
	return
