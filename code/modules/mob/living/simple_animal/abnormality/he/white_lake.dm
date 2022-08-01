/mob/living/simple_animal/hostile/abnormality/whitelake
	name = "White Lake"
	desc = "A ballet dancer, absorbed in her work."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "white_lake"
	icon_living = "white_lake"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 10,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 30
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	/// Grab her champion
	var/list/champion = list()
	//She gets mad if you work on her too much as high fortitude
	var/killcounter = 0
	start_qliphoth = 3

	ego_list = list(
		/datum/ego_datum/weapon/wings,
		/datum/ego_datum/armor/wings
		)


/mob/living/simple_animal/hostile/abnormality/whitelake/work_chance(mob/living/carbon/human/user, chance)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 60)
		var/newchance = chance-30 //You suck, die. I hate you
		return newchance
	return chance

/mob/living/simple_animal/hostile/abnormality/whitelake/success_effect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 60)		//Doesn't like these people
		champion += user

/mob/living/simple_animal/hostile/abnormality/whitelake/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 60)
		if(prob(30))
			killcounter +=1
		datum_reference.qliphoth_change(-1)

		if(killcounter == 2)
			killcounter =0
			user.adjustBruteLoss(500) //Die.

/mob/living/simple_animal/hostile/abnormality/whitelake/zero_qliphoth(mob/living/carbon/human/user)
	var/datum/outfit/whitelake = new /datum/outfit/whitelake
	var/mob/living/carbon/human/H = pick(champion)

	var/obj/item/held = H.get_active_held_item()
	var/obj/item/wep = new /obj/item/ego_weapon/flower_waltz(H)
	H.dropItemToGround(held) 	//Drop weapon
	H.equipOutfit(whitelake)	//Get outfit
	H.put_in_hands(wep) 		//Time for pale

	//They need to be hard to kill and unable to go sane again.
	H.physiology.red_mod *= 0.3
	H.physiology.white_mod *= 0
	H.physiology.black_mod *= 0
	H.physiology.pale_mod *= 0.1

	//Replaces AI with murder one
	QDEL_NULL(ai_controller)
	H.ai_controller = /datum/ai_controller/insane/murder/whitelake
	ghostize(1)
	H.InitializeAIController()

	return

//Outfit and Attacker's sword.
/datum/outfit/whitelake
	head = /obj/item/clothing/head/ego_gift/whitelake
	glasses = /obj/item/clothing/glasses/whitelake

/obj/item/clothing/head/ego_gift/whitelake
	name = "waltz of the flowers"
	icon_state = "whitelake"
	icon = 'icons/obj/clothing/ego_gear/head.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/head.dmi'

/obj/item/clothing/glasses/whitelake
	name = "waltz of the flowers"
	desc = "contacts and blush seen on those driven insane by whitelake"
	icon_state = "flower_waltz"
	icon = 'icons/obj/clothing/ego_gear/head.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/head.dmi'

//WAW Class, you have to sacrifice someone for it
/obj/item/ego_weapon/flower_waltz
	name = "waltz of the flowers"
	desc = "It's awfully fun to write a march for tin soldiers, a waltz of the flowers."
	icon_state = "flower_waltz"
	force = 18
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("slices", "cuts")
	attack_verb_simple = list("slices", "cuts")
	hitsound = 'sound/weapons/bladeslice.ogg'
	//No requirements because who knows who will use it.
	//The tradeoff is that you have to kill someone

//Slightly different AI lines
/datum/ai_controller/insane/murder/whitelake
	lines_type = /datum/ai_behavior/say_line/insanity_whitelake

/datum/ai_behavior/say_line/insanity_whitelake
	lines = list(
				"I will protect her!!",
				"You're in the way!",
				"I will dance with her forever!"
				)
