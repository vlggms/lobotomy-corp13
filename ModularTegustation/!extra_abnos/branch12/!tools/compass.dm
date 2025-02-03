#define STATUS_EFFECT_COMPASS /datum/status_effect/display/compass
/obj/structure/toolabnormality/compass
	name = "Predestined Compass"
	desc = "A bronze compass with 8 needles."
	icon_state = "compass"
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	var/list/active_users = list()

/obj/structure/toolabnormality/compass/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_COMPASS)
		to_chat(user, span_userdanger("You put the compass back. You feel a lot more composed"))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_COMPASS)
		to_chat(user, span_userdanger("You pick up the compass, and feel a like you can't sit still"))

// Status Effect
/datum/status_effect/display/compass
	id = "compass"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "compass"

	var/timer = 0	//How many seconds of buff do you get
	var/debuffed = TRUE		//Are you currently debuffed

/datum/status_effect/display/compass/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -80)


/datum/status_effect/display/compass/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(timer > 0)
		timer--
	//At timer 0, take away all the stats you've gotten
	if(timer == 0 && !debuffed)
		H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -160)
		debuffed = TRUE

	for(var/obj/machinery/computer/abnormality/V in range(2, owner))
		if(V.meltdown)
			//If you're debuffed you get a free 80 Temp. As a treat.
			if(debuffed)
				H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 160)

			//You get 60 seconds of buff after working on a meltdown console
			timer = 60
			debuffed = FALSE

/datum/status_effect/display/compass/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!debuffed)
			H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -160)
		H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 80)

#undef STATUS_EFFECT_COMPASS
