#define STATUS_EFFECT_PENITENCE /datum/status_effect/penitence
//Sorry Lads, not much I can do here - Kirie
/mob/living/simple_animal/hostile/abnormality/penitentgirl
	name = "Penitent Girl"
	desc = "A girl with hair flowing over her eyes."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "penitent"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = list(80, 60, 50, 50, 50),
		ABNORMALITY_WORK_REPRESSION = 50
	)
	is_flying_animal = TRUE
	work_damage_amount = 7
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/sorrow,
		/datum/ego_datum/armor/sorrow
	)
	gift_type =  /datum/ego_gifts/sorrow
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB


/mob/living/simple_animal/hostile/abnormality/penitentgirl/AttemptWork(mob/living/carbon/human/user, work_type)
	//Temp too high, random damage type time.
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 40)
		work_damage_type = pick(WHITE_DAMAGE, RED_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/penitentgirl/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// you are going to cut your own leg off
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40)
		user.apply_status_effect(STATUS_EFFECT_PENITENCE)
		to_chat(user, "<span class='danger'>Something feels strange.</span>") //I have to write something here
		work_damage_type = initial(work_damage_type)


/datum/status_effect/penitence
	id = "penitence"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 600		//You will die 60 seconds from now
	alert_type = null

/datum/status_effect/penitence/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/user = owner
		if(HAS_TRAIT(user, TRAIT_NODISMEMBER))
			return
		var/obj/item/bodypart/l_leg = user.get_bodypart(BODY_ZONE_L_LEG)
		var/obj/item/bodypart/r_leg = user.get_bodypart(BODY_ZONE_R_LEG)
		var/did_the_thing = (l_leg?.dismember() && r_leg?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
		if(!did_the_thing)
			return
		to_chat(user, "<span class='userdanger'>You need to rip them off NOW!</span>") //I have to write something here

#undef STATUS_EFFECT_PENITENCE
