#define STATUS_EFFECT_CHAMPION /datum/status_effect/champion
//White Lake from wonderlabs, by Kirie saito
//It's very buggy, and I can't test it alone
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
	//Has the weapon been given out?
	var/sword = FALSE
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
		champion = user

/mob/living/simple_animal/hostile/abnormality/whitelake/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/whitelake/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 60)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/whitelake/zero_qliphoth(mob/living/carbon/human/user)
	var/datum/outfit/whitelake = new /datum/outfit/whitelake
	var/mob/living/carbon/human/H = champion
	H.equipOutfit(whitelake)	//Get outfit
	H.apply_status_effect(STATUS_EFFECT_CHAMPION)
	if(!sword)
		waltz(H)
	datum_reference.qliphoth_change(3)
	//Replaces AI with murder one
	H.ai_controller = /datum/ai_controller/insane/murder/whitelake
	H.ghostize()
	H.InitializeAIController()

/mob/living/simple_animal/hostile/abnormality/whitelake/proc/waltz(mob/living/carbon/human/H)
	var/obj/item/held = H.get_active_held_item()
	var/obj/item/wep = new /obj/item/ego_weapon/flower_waltz(H)
	H.dropItemToGround(held) 	//Drop weapon
	H.put_in_hands(wep) 		//Time for pale
	sword = TRUE

//Outfit and Attacker's sword.
/datum/outfit/whitelake
	head = /obj/item/clothing/head/ego_gift/whitelake

/obj/item/clothing/head/ego_gift/whitelake
	name = "waltz of the flowers"
	icon_state = "whitelake"
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

//Slightly different AI lines
/datum/ai_controller/insane/murder/whitelake
	lines_type = /datum/ai_behavior/say_line/insanity_whitelake

/datum/ai_behavior/say_line/insanity_whitelake
	lines = list(
				"I will protect her!!",
				"You're in the way!",
				"I will dance with her forever!"
				)
//CHAMPION
//Sets the defenses of the champion
/datum/status_effect/champion
	id = "champion"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 6000		//Lasts 10 minutes, guaranteed.
	alert_type = /atom/movable/screen/alert/status_effect/champion

/atom/movable/screen/alert/status_effect/champion
	name = "The Champion"
	desc = "You are White Lake's champion, and she has empowered you temporarily."

/datum/status_effect/champion/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		//To avoid bugs, I am instead reducing by a flat amount, so that you can't change it by applying a separate defense mod while it is active
		L.physiology.red_mod -= 0.7
		L.physiology.white_mod -= 0.9
		L.physiology.black_mod -= 0.9
		L.physiology.pale_mod -= 0.8

/datum/status_effect/champion/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod += 0.7
		L.physiology.white_mod += 0.9
		L.physiology.black_mod += 0.9
		L.physiology.pale_mod += 0.8

#undef STATUS_EFFECT_CHAMPION
