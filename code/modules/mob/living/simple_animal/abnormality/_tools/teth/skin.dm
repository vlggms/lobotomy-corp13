#define STATUS_EFFECT_SKIN /datum/status_effect/skin
/obj/structure/toolabnormality/skin
	name = "skin prophecy"
	desc = "A book that seems to be made out of skin. Something is written on it."
	icon_state = "skin_prophecy"
	var/list/readers = list()

/obj/structure/toolabnormality/skin/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 6, user))
		return
	if(get_level_buff(user, PRUDENCE_ATTRIBUTE) >= 100)
		to_chat(user, span_notice("You've learned all that you could."))
		return //You don't need any more.

	user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
	if(!(user in readers))
		readers += user
	else
		user.physiology.white_mod *= 1.15

	user.apply_status_effect(STATUS_EFFECT_SKIN)
	to_chat(user, span_userdanger("You read the book, and take the time to burn these passages into your brain."))

// Status Effect
/datum/status_effect/skin
	id = "skin"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/skin/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_HUMAN_INSANE, PROC_REF(UserInsane))

/datum/status_effect/skin/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_HUMAN_INSANE)

/datum/status_effect/skin/proc/UserInsane()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	new /obj/effect/temp_visual/dir_setting/cult/phase/out(get_turf(H))
	H.emote("scream")
	H.death()
	animate(H, alpha = 0, time = 5)
	QDEL_IN(H, 5)

#undef STATUS_EFFECT_SKIN
