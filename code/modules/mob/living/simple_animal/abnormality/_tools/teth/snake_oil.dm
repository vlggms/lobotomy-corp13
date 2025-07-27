#define STATUS_EFFECT_SNAKE_OIL /datum/status_effect/snake_oil

/obj/structure/toolabnormality/attribute_giver/snake_oil
	given_status_effect = STATUS_EFFECT_SNAKE_OIL

	ego_list = list(
		/datum/ego_datum/weapon/swindle,
		/datum/ego_datum/armor/swindle,
	)

/obj/structure/toolabnormality/attribute_giver/snake_oil/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	playsound(user.loc, 'sound/items/drink.ogg', rand(10,50), TRUE)

	if(used_by[user] != 1) // Not their first use
		user.physiology.red_mod *= 1.10

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
