#define STATUS_EFFECT_SNAKE_OIL /datum/status_effect/snake_oil
/obj/structure/toolabnormality/snake_oil
	name = "all-natural snake oil"
	desc = "A purported panacea that will supposedly treat anything from minor scratches to Alzheimer's."
	icon_state = "snake_oil"
	var/list/users = list()

	ego_list = list(
		/datum/ego_datum/weapon/swindle,
		/datum/ego_datum/armor/swindle,
	)

/obj/structure/toolabnormality/snake_oil/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 6, user))
		return
	if(get_level_buff(user, FORTITUDE_ATTRIBUTE) >= 100)
		to_chat(user, span_notice("You've had enough."))
		return //You don't need any more.

	user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 10)
	if(!(user in users))
		users += user
	else
		user.physiology.red_mod *= 1.15

	user.apply_status_effect(STATUS_EFFECT_SNAKE_OIL)
	to_chat(user, span_userdanger("You take a sip, ugh, it tastes nasty!"))
	playsound(user.loc, 'sound/items/drink.ogg', rand(10,50), TRUE)

// Status Effect
/datum/status_effect/snake_oil
	id = "snake_oil"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/snake_oil/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(DamageCheck))
	return ..()

/datum/status_effect/snake_oil/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	return ..()

/datum/status_effect/snake_oil/proc/DamageCheck()
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(HealthCheck)), 1) //Gives health time to update

/datum/status_effect/snake_oil/proc/HealthCheck()
	var/mob/living/carbon/human/H = owner
	if(H.stat >= HARD_CRIT || H.health < 0) //crit check
		to_chat(H, span_userdanger("You feel like your body can't hold itself together!"))
		H.gib()

#undef STATUS_EFFECT_SNAKE_OIL
