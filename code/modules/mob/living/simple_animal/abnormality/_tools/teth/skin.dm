#define STATUS_EFFECT_SKIN /datum/status_effect/skin
/obj/structure/toolabnormality/skin
	name = "skin prophecy"
	desc = "A book that seems to be made out of skin. Something is written on it."
	icon_state = "skin_prophecy"
	var/list/readers = list()

/obj/structure/toolabnormality/skin/attack_hand(mob/living/carbon/human/user)
	..()
	if(do_after(user, 6))
		if(get_level_buff(user, PRUDENCE_ATTRIBUTE) >= 100)
			to_chat(user, "<span class='userdanger'>You've learned all that you could.</span>")
			return	//You don't need any more.
		user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)

		if(!(user in readers))
			readers+= user
		else
			user.physiology.white_mod *= 1.15

		user.apply_status_effect(STATUS_EFFECT_SKIN)
		to_chat(user, "<span class='userdanger'>You read the book, and take the time to burn these passages into your brain.</span>")

//SKIN
//this keeps track of dying
/datum/status_effect/skin
	id = "skin"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/skin/tick()
	var/mob/living/carbon/human/H = owner
	if(H.sanity_lost)
		new /obj/effect/temp_visual/dir_setting/cult/phase/out(get_turf(H))
		QDEL_IN(H, 5)

#undef STATUS_EFFECT_SKIN
