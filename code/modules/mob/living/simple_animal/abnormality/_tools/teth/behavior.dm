#define STATUS_EFFECT_BEHAVIOR /datum/status_effect/display/behavior
/obj/structure/toolabnormality/behaviour
	name = "behavior adjustment"
	desc = "A floating disk."
	icon_state = "behavior"
	var/list/active_users = list()

/obj/structure/toolabnormality/behaviour/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_BEHAVIOR)
		to_chat(user, span_userdanger("You feel your intellect returning."))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_BEHAVIOR)
		to_chat(user, span_userdanger("You feel as though you've been adjusted to become righteous."))

// Status Effect
/datum/status_effect/display/behavior
	id = "behavior_adjustment"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "behavior"

/datum/status_effect/display/behavior/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 15)
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10)
		RegisterSignal(H, COMSIG_HUMAN_INSANE, PROC_REF(UserInsane))

/datum/status_effect/display/behavior/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -15)
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
		UnregisterSignal(H, COMSIG_HUMAN_INSANE)

/datum/status_effect/display/behavior/proc/UserInsane()
	var/mob/living/carbon/human/H = owner
	H.emote("laugh")
	var/obj/item/organ/eyes/O = H.getorgan(/obj/item/organ/eyes)
	if(istype(O))
		H.visible_message(span_danger("[H] tears [H.p_their(FALSE)] eyes out!"))
		playsound(get_turf(H), 'sound/abnormalities/behavior/eyes_out.ogg', 35, TRUE)
		O.Remove(H)
		O.forceMove(get_turf(H))
	H.death()

#undef STATUS_EFFECT_BEHAVIOR
