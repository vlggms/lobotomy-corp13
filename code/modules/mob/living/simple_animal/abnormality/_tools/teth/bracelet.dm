#define STATUS_EFFECT_BRACELET /datum/status_effect/display/bracelet
/obj/structure/toolabnormality/bracelet
	name = "luminous bracelet"
	desc = "A glowing white bracelet."
	icon_state = "bracelet"
	var/list/active_users = list()

/obj/structure/toolabnormality/bracelet/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_BRACELET)
		if(user.health != user.maxHealth)
			to_chat(user, "<span class='userdanger'>You put the bracelet back, and feel your heart explode!</span>")
			user.gib()
		else
			to_chat(user, "<span class='userdanger'>You put the bracelet back, and take a sigh of relief.</span>")
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_BRACELET)
		to_chat(user, "<span class='userdanger'>You pick up the bracelet, and feel your wounds mending.</span>")

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
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 15)

/datum/status_effect/display/bracelet/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjustBruteLoss(-5) // Your health heals quite fast

	//Count to 10 if you are at full HP
	if(H.getBruteLoss() == 0)
		if(healthtracker == 0)
			to_chat(H, "<span class='danger'>Your HP is too high! Decrease it or perish!.</span>")

		healthtracker+=1
	else if (healthtracker!=0)
		healthtracker = 0

	//If you are at half HP you get a different warning.
	if(H.health <= H.maxHealth/2)
		if(warningtracker == 0)
			to_chat(H, "<span class='danger'>Your HP is too low! Increase it or perish.</span>")

		warningtracker+=1
	else if (warningtracker!=0)
		warningtracker = 0

	if(healthtracker == 15 || warningtracker == 10)
		H.gib()

/datum/status_effect/display/bracelet/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -15)

#undef STATUS_EFFECT_BRACELET
