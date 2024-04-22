#define STATUS_EFFECT_ASPIRATION /datum/status_effect/display/aspiration
/obj/structure/toolabnormality/aspiration
	name = "heart of aspiration"
	desc = "A giant red heart."
	icon_state = "heart"
	var/list/active_users = list()

	ego_list = list(
		/datum/ego_datum/weapon/aspiration,
		/datum/ego_datum/armor/aspiration,
	)

/obj/structure/toolabnormality/aspiration/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_ASPIRATION)
		to_chat(user, span_userdanger("You feel your heart slow again."))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_ASPIRATION)
		to_chat(user, span_userdanger("You feel your blood pumping faster."))

// Status Effect
/datum/status_effect/display/aspiration
	id = "heart_aspiration"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "heart"
	var/panic_override = FALSE

/datum/status_effect/display/aspiration/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 15)

/datum/status_effect/display/aspiration/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.is_working)
		playsound(get_turf(src), 'sound/abnormalities/nothingthere/heartbeat.ogg', 50, 0, 3)
		H.adjustSanityLoss(10)
	if(H.sanityhealth <= H.maxSanity * 0.2 && !H.sanity_lost)
		H.adjustSanityLoss(999)
	if(H.sanity_lost)
		H.adjustBruteLoss(-4)
	SanityCheck()

/datum/status_effect/display/aspiration/proc/SanityCheck()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		if(panic_override)
			return
		QDEL_NULL(status_holder.ai_controller)
		status_holder.ai_controller = /datum/ai_controller/insane/murder
		status_holder.InitializeAIController()
		status_holder.apply_status_effect(/datum/status_effect/panicked_type/murder)
		panic_override = TRUE
		return
	panic_override = FALSE

/datum/status_effect/display/aspiration/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -15)

#undef STATUS_EFFECT_ASPIRATION
