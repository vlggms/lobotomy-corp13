#define STATUS_EFFECT_ROLECALL /datum/status_effect/rolecall
/obj/structure/toolabnormality/vivavoce
	name = "viva voce"
	desc = "A very old-fashioned communication device."
	icon_state = "vivavoce"
	var/list/users = list()

/obj/structure/toolabnormality/vivavoce/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 6, user))
		return
	if(get_level_buff(user, TEMPERANCE_ATTRIBUTE) >= 50)
		to_chat(user, "<span class='notice'>It's silent.</span>")
		return //You don't need any more.

	user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 5)
	if(!(user in users))
		users += user
		if(prob(50))
			playsound(user, 'sound/abnormalities/vivavoce/doorknock.ogg', 75, FALSE, -5)
	else
		user.physiology.black_mod *= 1.15

	user.apply_status_effect(STATUS_EFFECT_ROLECALL)
	to_chat(user, "<span class='userdanger'>You pick up the phone and hear nothing, but you feel as if someone is behind you.</span>")

// Status Effect
/datum/status_effect/rolecall
	id = "call"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/rolecall/on_apply()
	RegisterSignal(owner, COMSIG_WORK_STARTED, .proc/UserDebuff)
	RegisterSignal(owner, COMSIG_WORK_COMPLETED, .proc/UserBuff)
	return ..()

/datum/status_effect/rolecall/on_remove()
	UnregisterSignal(owner, COMSIG_WORK_STARTED)
	UnregisterSignal(owner, COMSIG_WORK_COMPLETED)
	return ..()

/datum/status_effect/rolecall/proc/UserDebuff()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	to_chat(H, "<span class='userdanger'>What if I'm attacked? I can't focus!</span>")
	if(prob(5))
		playsound(H, 'sound/abnormalities/vivavoce/doorknock.ogg', 75, FALSE, -5)
		to_chat(H, "<span class='userdanger'>What was that?</span>")
	H.physiology.red_mod *= 2.0
	H.physiology.white_mod *= 2.0
	H.physiology.black_mod *= 2.0
	H.physiology.pale_mod *= 2.0

/datum/status_effect/rolecall/proc/UserBuff()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	H.physiology.red_mod /= 2.0
	H.physiology.white_mod /= 2.0
	H.physiology.black_mod /= 2.0
	H.physiology.pale_mod /= 2.0


#undef STATUS_EFFECT_ROLECALL
