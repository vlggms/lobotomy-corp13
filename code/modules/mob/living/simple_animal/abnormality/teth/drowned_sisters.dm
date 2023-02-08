//She tells stories, and does sanity damage. What can I say?
/mob/living/simple_animal/hostile/abnormality/drownedsisters
	name = "Drowned Sisters"
	desc = "A pair of girls with masks covering their faces."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "sisters"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 20
	)
	work_damage_amount = 1		//Calculated later
	work_damage_type = WHITE_DAMAGE
	pixel_x = -32
	base_pixel_x = -32

	ego_list = list(
		/datum/ego_datum/weapon/sorority,
		/datum/ego_datum/armor/sorority
	)
	gift_type =  /datum/ego_gifts/sorority

/mob/living/simple_animal/hostile/abnormality/drownedsisters/AttemptWork(mob/living/carbon/human/user, work_type)
	//Deals scaling work damage based off your stats.
	work_damage_amount = (get_attribute_level(user, PRUDENCE_ATTRIBUTE) -60) * -0.5
	work_damage_amount = max(1, work_damage_amount)	//So you don't get healing
	return TRUE

/mob/living/simple_animal/hostile/abnormality/drownedsisters/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
// okay so according to the lore you're not really supposed to remember the stories she says so we're going to make it so your sanity goes back up
	if(!user.sanity_lost && pe != 0)
		user.adjustSanityLoss(get_attribute_level(user, PRUDENCE_ATTRIBUTE))
	..()
