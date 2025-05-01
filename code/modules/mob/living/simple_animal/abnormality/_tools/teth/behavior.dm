#define STATUS_EFFECT_BEHAVIOR /datum/status_effect/display/behavior
/obj/structure/toolabnormality/behavior
	name = "behavior adjustment"
	desc = "A floating disk."
	icon_state = "behavior"
	var/list/active_users = list()

	ego_list = list(
		/datum/ego_datum/weapon/adjustment,
		/datum/ego_datum/armor/adjustment,
	)

/obj/structure/toolabnormality/behavior/attack_hand(mob/living/carbon/human/user)
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
	var/stat_bonus = 0
	var/stat_penalty = 0

/datum/status_effect/display/behavior/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		stat_bonus = (0.15 * get_attribute_level(owner, JUSTICE_ATTRIBUTE)) //15 + 15% of the user's justice is added as a bonus
		stat_penalty = (0.1 * get_attribute_level(owner, PRUDENCE_ATTRIBUTE)) //10 + 10% of the user's temperance is removed as a penalty
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 15 + stat_bonus)
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10 - stat_penalty)
		RegisterSignal(H, COMSIG_HUMAN_INSANE, PROC_REF(UserInsane))

/datum/status_effect/display/behavior/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -15 - stat_bonus)
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10 + stat_penalty)
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
		H.adjustBruteLoss(50)
	H.remove_status_effect(src)

#undef STATUS_EFFECT_BEHAVIOR
