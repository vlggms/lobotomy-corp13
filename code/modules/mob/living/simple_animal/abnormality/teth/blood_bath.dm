/mob/living/simple_animal/hostile/abnormality/bloodbath
	name = "bloodbath"
	desc = "A constantly dripping bath of blood"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "bloodbath"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0)
	)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	max_boxes = 14
	ego_list = list(
		//datum/ego_datum/weapon/bloodbath,
		//datum/ego_datum/armor/bloodbath
	)
	//gift_type =  /datum/ego_gifts/bloodbath
	var/hands = 0
/mob/living/simple_animal/hostile/abnormality/bloodbath/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
// any work performed with level 1 Fort or Temperance makes you panic and die
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 || get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40 || (hands == 3 && prob(50)))
		icon = 'ModularTegustation/Teguicons/48x64.dmi'
		icon_state = "bloodbath_a[hands]"
		user.dust()
		src.visible_message("<span class='warning'>[src] drags [user] into themself!</span>")
		playsound(get_turf(src),'sound/effects/wounds/blood2.ogg')
		playsound(get_turf(src),'sound/effects/footstep/water1.ogg')
		SLEEP_CHECK_DEATH(3 SECONDS)
		hands ++
		if(hands < 4)
			max_boxes += 4
			icon_state = "bloodbath[hands]"
		else
			hands = 0
			max_boxes = 14
			icon_state = "bloodbath"
		return




