#define STATUS_EFFECT_TEARS /datum/status_effect/tears
/mob/living/simple_animal/hostile/abnormality/bottle
	name = "Bottle of Tears"
	desc = "A bottle filled with water with a cake on top"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bottle1"
	icon_living = "bottle1"
	maxHealth = 400
	health = 400
	threat_level = ZAYIN_LEVEL
	work_chances = list(		//In the comic they work on it. They say you can do any work as long as you don't eat the cake
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),	//How the fuck do you beat up a cake?
		"Dining" = 100,		//You can instead decide to eat the cake.
		"Drink" = 100			//Or Drink the water
		)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/little_alice,
		/datum/ego_datum/armor/little_alice
		)
	gift_type =  /datum/ego_gifts/alice
	max_boxes = 10
	var/cake = 5	//How many cake charges are there

/mob/living/simple_animal/hostile/abnormality/bottle/attempt_work(mob/living/carbon/human/user, work_type)
	if(cake==0)
		if(work_type == "Dining")
			return FALSE
		if(work_type == "Drink")
			return TRUE
	if(work_type == "Drink")
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/bottle/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "Dining")
		cake -= 1		//Eat some cake
		if(cake == 0)
			//Drowns you like Wellcheers does, so I mean the code checks out
			for(var/turf/open/T in view(7, src))
				new /obj/effect/temp_visual/water_waves(T)
			to_chat(user, "<span class='userdanger'>The room is filling with water! You're going to drown!</span>")
			icon_state = "bottle3"	//cake all gone

			var/location = get_turf(user)
			new /obj/item/ego_weapon/eyeball(location)

			user.AdjustSleeping(10 SECONDS)
			animate(user, alpha = 0, time = 2 SECONDS)
			QDEL_IN(user, 3.5 SECONDS)

		if(cake > 0)
			user.adjustBruteLoss(-500) // It heals you to full if you eat it
			icon_state = "bottle2"	//cake looks eaten

	if(work_type == "Drink")
		user.apply_status_effect(STATUS_EFFECT_TEARS)

	return ..()


/datum/status_effect/tears
	id = "tears"
	status_type = STATUS_EFFECT_MULTIPLE	//You should be able to stack this, I hope
	duration = 6000		//Lasts 10 minutes.
	alert_type = /atom/movable/screen/alert/status_effect/tears

/atom/movable/screen/alert/status_effect/tears
	name = "Tearful"
	desc = "You feel weakened, for a short period of time."
	icon_state = "regenerative_core"

/datum/status_effect/tears/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='userdanger'>You feel your strength sapping away...</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -20)

/datum/status_effect/tears/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='nicegreen'>You feel your strength returned to you.</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 20)

#undef STATUS_EFFECT_TEARS

