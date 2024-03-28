#define STATUS_EFFECT_ROLECALL /datum/status_effect/stacking/rolecall
/obj/structure/toolabnormality/vivavoce
	name = "viva voce"
	desc = "A very old-fashioned communication device."
	icon_state = "vivavoce"
	var/list/users = list()

	ego_list = list(
		/datum/ego_datum/weapon/ringing,
		/datum/ego_datum/armor/ringing,
	)

/obj/structure/toolabnormality/vivavoce/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 6, user))
		return
	if(get_level_buff(user, TEMPERANCE_ATTRIBUTE) >= 50)
		to_chat(user, span_notice("It's silent."))
		return //You don't need any more.

	user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 5)
	var/datum/status_effect/stacking/rolecall/R = user.has_status_effect(/datum/status_effect/stacking/rolecall)
	if(!(user in users))
		users += user
		if(prob(50))
			playsound(user, 'sound/abnormalities/vivavoce/doorknock.ogg', 100, FALSE, -5)
	else
		user.physiology.black_mod *= 1.15
		if(R)
			R.add_stacks(1)

	user.apply_status_effect(STATUS_EFFECT_ROLECALL)
	to_chat(user, span_userdanger("You pick up the phone and hear nothing, but you feel as if someone is behind you."))

// Status Effect
/datum/status_effect/stacking/rolecall
	id = "call"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	stack_decay = 0
	stacks = 1
	max_stacks = 10
	consumed_on_threshold = FALSE
	var/damage_mod

/datum/status_effect/stacking/rolecall/on_apply()
	RegisterSignal(owner, COMSIG_WORK_STARTED, PROC_REF(UserDebuff))
	RegisterSignal(owner, COMSIG_WORK_COMPLETED, PROC_REF(UserBuff))
	return ..()

/datum/status_effect/stacking/rolecall/on_remove()
	UnregisterSignal(owner, COMSIG_WORK_STARTED)
	UnregisterSignal(owner, COMSIG_WORK_COMPLETED)
	return ..()

/datum/status_effect/stacking/rolecall/proc/UserDebuff()
	SIGNAL_HANDLER
	damage_mod = 1.5 + (stacks / 20)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	to_chat(H, span_userdanger("What if I'm attacked? I can't focus!"))
	if(prob(5))
		playsound(H, 'sound/abnormalities/vivavoce/doorknock.ogg', 100, FALSE, -5)
		to_chat(H, span_userdanger("What was that?"))
	H.physiology.red_mod *= damage_mod
	H.physiology.white_mod *= damage_mod
	H.physiology.black_mod *= damage_mod
	H.physiology.pale_mod *= damage_mod

/datum/status_effect/stacking/rolecall/proc/UserBuff()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	H.physiology.red_mod /= damage_mod
	H.physiology.white_mod /= damage_mod
	H.physiology.black_mod /= damage_mod
	H.physiology.pale_mod /= damage_mod


#undef STATUS_EFFECT_ROLECALL
