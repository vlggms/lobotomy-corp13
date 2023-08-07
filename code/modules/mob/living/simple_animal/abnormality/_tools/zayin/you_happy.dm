#define STATUS_EFFECT_YMBH /datum/status_effect/display/YMBH
/obj/structure/toolabnormality/you_happy
	name = "you must be happy"
	desc = "An abnormality in the form of a big capsule-like machine."
	icon_state = "YMBH"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -8
	can_buckle = TRUE
	max_buckled_mobs = 1
	layer = ABOVE_MOB_LAYER //so you cant cover it up with items
	var/running
	var/state
	var/bonus
	var/switch_time = 3

/obj/structure/toolabnormality/you_happy/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, "<span class='warning'>It doesn't look like I can't quite fit in.</span>")
		return FALSE // Only usable on humans.

	if(M != user)
		to_chat(user, "<span class='warning'>You cannot force [M] to use [src]!</span>")
		return FALSE

	to_chat(user, "<span class='warning'>You start climbing onto [src].</span>")
	if(!do_after(user, 7 SECONDS))
		to_chat(user, "<span class='notice'>You decide that might be a bad idea.</span>")
		return FALSE

	return ..(M, user, check_loc = FALSE) //it just works

/obj/structure/toolabnormality/you_happy/post_buckle_mob(mob/living/carbon/human/M)
	if(!ishuman(M))
		return
	animate(M, alpha = 255,pixel_x = 0, pixel_z = 10, time = 0.5 SECONDS)
	M.pixel_z = 10
	var/datum/status_effect/display/YMBH/Y = M.has_status_effect(/datum/status_effect/display/YMBH)
	if(Y)
		to_chat(M, "<span class='userdanger'>Do you love your city?</span>")
		M.gib()
		return
	icon_state = "YMBH_NO"
	say("Do you love your city?")
	playsound(src, 'sound/abnormalities/you_happy/change.ogg', 80, TRUE, -3)
	running = TRUE
	state = "NO"
	bonus = initial(bonus)
	switch_time = initial(switch_time)
	Change()

/obj/structure/toolabnormality/you_happy/proc/Change()
	set waitfor = FALSE
	if(!running)
		icon_state = "YMBH"
		return
	switch_time = clamp(switch_time - 0.02, 1, 5)
	sleep(switch_time)
	if(bonus > 49)
		state = "NO"
		icon_state = "YMBH_NO"
		playsound(src, 'sound/effects/ordeals/green_end.ogg', 70, TRUE, -3)
		return
	playsound(src, 'sound/abnormalities/you_happy/change.ogg', 40, TRUE, -3)
	switch(state)
		if("YES")
			state = "NO"
			icon_state = "YMBH_NO"
		if("NO")
			state = "YES"
			icon_state = "YMBH_YES"
			bonus = clamp(bonus + 1, 1, 50)
	Change()

/obj/structure/toolabnormality/you_happy/post_unbuckle_mob(mob/living/carbon/human/user)
	. = ..()
	icon_state = "YMBH"
	running = FALSE
	animate(user, alpha = 255,pixel_x = 0, pixel_z = -10, time = 0.5 SECONDS)
	user.pixel_z = 0
	switch(state)
		if("YES")
			playsound(src, 'sound/abnormalities/you_happy/success.ogg', 130, TRUE, -3)
			var/datum/status_effect/display/YMBH/buff = user.apply_status_effect(/datum/status_effect/display/YMBH)
			buff.bonus = bonus
			buff.apply_buffs()
		if("NO")
			playsound(src, 'sound/abnormalities/you_happy/fail.ogg', 80, TRUE, -3)
			var/datum/status_effect/display/YMBH/debuff = user.apply_status_effect(/datum/status_effect/display/YMBH)
			debuff.bonus = -bonus
			debuff.display_name = "NO"
			debuff.apply_buffs()


// Status Effect
/datum/status_effect/display/YMBH
	id = "YMBH"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 300 SECONDS
	alert_type = null
	display_name = "YES"
	var/bonus

/datum/status_effect/display/YMBH/proc/apply_buffs()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, bonus)
		H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, bonus)
		H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, bonus)
		H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, bonus)
		owner.cut_overlay(icon_overlay)
		UpdateStatusDisplay()

/datum/status_effect/display/YMBH/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -bonus)
		H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -bonus)
		H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -bonus)
		H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -bonus)

#undef STATUS_EFFECT_YMBH
