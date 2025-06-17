#define STATUS_EFFECT_SKIN /datum/status_effect/skin
/obj/structure/toolabnormality/attribute_giver/skin
	name = "skin prophecy"
	desc = "A book that seems to be made out of skin. Something is written on it."
	icon_state = "skin_prophecy"
	given_attribute = PRUDENCE_ATTRIBUTE
	given_status_effect = STATUS_EFFECT_SKIN
	feedback_message = "You read the book, and take the time to burn these passages into your brain."
	full_boost_message = "You've learned all that you could."

	ego_list = list(
		/datum/ego_datum/weapon/visions,
		/datum/ego_datum/armor/visions,
	)

/obj/structure/toolabnormality/attribute_giver/skin/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	if(used_by[user] != 1) // Not their first use
		user.physiology.white_mod *= 1.10

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
