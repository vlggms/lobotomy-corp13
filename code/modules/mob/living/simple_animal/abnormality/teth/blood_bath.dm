/mob/living/simple_animal/hostile/abnormality/bloodbath
	name = "Bloodbath"
	desc = "A constantly dripping bath of blood"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "bloodbath"
	portrait = "blood_bath"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0),
	)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/woe
	max_boxes = 14

	ego_list = list(
		/datum/ego_datum/weapon/wrist,
		/datum/ego_datum/armor/wrist,
	)

	gift_type =  /datum/ego_gifts/wrist

	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "The Enkephalin cure affected not only mind, but also body. <br>\
		The problem is, the supply of cure became tremendously huge to control when we realized the problem. <br>\
		One of problems, one of them was numbing. <br>People believed they could live happy life. <br>\
		People believed they could buy sadness and sell happiness with money. <br>When the first suicide happened, we should have known that these beliefs had been shattered. <br>\
		Many hands float in the bath. <br>Hands that wanted to grab something but could not. <br>You......"
	observation_choices = list(
		"Grabbed a hand" = list(TRUE, "I feel coldness and stiffness. <br>I know these hands. <br>These are the hands of people I once loved."),
		"Did not grab a hand" = list(FALSE, "You looked away. <br>This is not the first time you ignore them. <br>It will be the same afterwards."),
	)

	var/hands = 0

/mob/living/simple_animal/hostile/abnormality/bloodbath/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
// any work performed with level 1 Fort and Temperance makes you panic and die
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40 || (hands == 3 && prob(50)))
		icon = 'ModularTegustation/Teguicons/48x64.dmi'
		icon_state = "bloodbath_a[hands]"
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		user.dust()
		visible_message(span_warning("[src] drags [user] into itself!"))
		playsound(get_turf(src),'sound/effects/wounds/blood2.ogg')
		playsound(get_turf(src),'sound/effects/footstep/water1.ogg')
		SLEEP_CHECK_DEATH(3 SECONDS)
		hands ++
		if(hands < 4)
			datum_reference.max_boxes += 4
			icon_state = "bloodbath[hands]"
		else
			hands = 0
			datum_reference.max_boxes = max_boxes
			icon_state = "bloodbath"
		return
