/datum/action/innate/analyze
	name = "Analysis"
	icon_icon = 'icons/hud/screen_skills.dmi'

/datum/action/innate/analyze/Activate()
	to_chat(owner, span_notice("You will now see the health of all living beings."))
	button_icon_state = "healthhud_on"
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medsensor.add_hud_to(owner)
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/analyze/Deactivate()
	to_chat(owner, span_notice("You will no longer see the health of all living beings."))
	button_icon_state = "healthhud_off"
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medsensor.remove_hud_from(owner)
	active = FALSE
	UpdateButtonIcon()

/datum/action/cooldown/thirdeye
	name = "Third Eye"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "night_eye_on"
	cooldown_time = 60 SECONDS
	var/thermal = TRAIT_THERMAL_VISION
	var/xray = TRAIT_XRAY_VISION

/datum/action/cooldown/thirdeye/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if(ishuman(owner) && owner.mind)
		ADD_TRAIT(owner, thermal, src)
		ADD_TRAIT(owner, xray, src)
		owner.update_sight()
		addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/thirdeye/proc/Recall()
	REMOVE_TRAIT(owner, thermal, src)
	REMOVE_TRAIT(owner, xray, src)
	owner.update_sight()

/datum/action/cooldown/quickgetaway
	name = "Quick Getaway"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "smokedash"
	cooldown_time = 20 SECONDS

/datum/action/cooldown/quickgetaway/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//increase speed
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/retreat)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/retreat), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.physiology.red_mod *= 1.5
		human.physiology.white_mod *= 1.5
		human.physiology.black_mod *= 1.5
		human.physiology.pale_mod *= 1.5

		//drop a bit of smoke
		var/datum/effect_system/smoke_spread/S = new
		S.set_up(4, get_turf(human))	//Make the smoke bigger
		S.start()
		qdel(S)
		addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/quickgetaway/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 1.5
	human.physiology.white_mod /= 1.5
	human.physiology.black_mod /= 1.5
	human.physiology.pale_mod /= 1.5
