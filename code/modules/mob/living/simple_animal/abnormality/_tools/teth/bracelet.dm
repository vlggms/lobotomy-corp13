#define STATUS_EFFECT_BRACELET /datum/status_effect/display/bracelet
/obj/structure/toolabnormality/bracelet
	name = "luminous bracelet"
	desc = "A glowing white bracelet."
	icon_state = "bracelet"
	var/list/active_users = list()

	ego_list = list(
		/datum/ego_datum/weapon/luminosity,
		/datum/ego_datum/armor/luminosity,
	)

/obj/structure/toolabnormality/bracelet/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_BRACELET)
		if(user.health != user.maxHealth) // check for oxyloss, because of anemics
			if(user.oxyloss > 0)
				to_chat(user, span_userdanger("You put the bracelet back, feeling as if you body wanted to tear itself apart!"))
				user.deal_damage(user.health * 0.75, BRUTE)
			else
				to_chat(user, span_userdanger("You put the bracelet back, and feel your heart explode!"))
				user.gib()
		else
			to_chat(user, span_userdanger("You put the bracelet back, and take a sigh of relief."))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_BRACELET)
		to_chat(user, span_userdanger("You pick up the bracelet, and feel your wounds mending."))

// Status Effect
/datum/status_effect/display/bracelet
	id = "bracelet"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "bracelet"
	var/healthtracker = 0
	var/warningtracker = 0

/datum/status_effect/display/bracelet/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -40)

/datum/status_effect/display/bracelet/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.is_working) //We don't reward people for using it to spam works
		return
	H.adjustBruteLoss(-2) // Your health heals decently fast
	healthtracker+=1

	//Count down to 5 minutes of wearing
	if(healthtracker>=300)
		if(warningtracker == 0)
			to_chat(H, span_hypnophrase("You have been wearing the luminous bracelet for a long time. Any longer could be dangerous!"))
			H.playsound_local(get_turf(H), 'sound/abnormalities/nothingthere/heartbeat.ogg', 50, 0, 3)
		warningtracker+=1
	if(warningtracker >= 150)
		H.gib()

/datum/status_effect/display/bracelet/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 40)

#undef STATUS_EFFECT_BRACELET
