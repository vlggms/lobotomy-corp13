#define STATUS_EFFECT_BEHAVIOR /datum/status_effect/behavior
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
		to_chat(user, "<span class='userdanger'>You feel your intellect returning.</span>")
		user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "behavior", -MUTATIONS_LAYER))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_BEHAVIOR)
		to_chat(user, "<span class='userdanger'>You feel as though you've been adjusted to become righteous.</span>")
		user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "behavior", -MUTATIONS_LAYER))

// Status Effect
/datum/status_effect/behavior
	id = "behavior_adjustment"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/behavior/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 15)
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10)
		RegisterSignal(H, COMSIG_HUMAN_INSANE, .proc/UserInsane)

/datum/status_effect/behavior/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -15)
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
		UnregisterSignal(H, COMSIG_HUMAN_INSANE)

/datum/status_effect/behavior/proc/UserInsane()
	var/mob/living/carbon/human/H = owner
	H.emote("laugh")
	var/obj/item/organ/eyes/O = H.getorgan(/obj/item/organ/eyes)
	if(istype(O))
		H.visible_message("<span class='danger'>[H] tears [H.p_their(FALSE)] eyes out!</span>")
		playsound(get_turf(H), 'sound/abnormalities/behavior/eyes_out.ogg', 35, TRUE)
		O.Remove(H)
		O.forceMove(get_turf(H))
	H.death()

#undef STATUS_EFFECT_BEHAVIOR
