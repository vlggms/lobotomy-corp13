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
	var/champion

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
		champion = user

/mob/living/simple_animal/hostile/abnormality/whitelake/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 60)
		if(prob(30))
			var/datum/outfit/whitelake = new /datum/outfit/whitelake
			var/mob/living/carbon/human/H = champion

			var/obj/item/held = H.get_active_held_item()
			var/obj/item/wep = new /obj/item/ego_weapon/flower_waltz(H)
			H.dropItemToGround(held) 	//Drop weapon
			H.equipOutfit(whitelake)	//Get outfit
			H.put_in_hands(wep) 		//Time for pale

			//They need to be hard to kill and really hard to get sane again
			//To avoid gettting infinite ego
			H.physiology.red_mod *= 0.3
			H.physiology.white_mod *= 0.05
			H.physiology.black_mod *= 0.1
			H.physiology.pale_mod *= 0.1

			//Replaces AI with murder one
			QDEL_NULL(ai_controller)
			H.ai_controller = /datum/ai_controller/insane/murder/whitelake
			H.ghostize(1)
			H.InitializeAIController()

	return
