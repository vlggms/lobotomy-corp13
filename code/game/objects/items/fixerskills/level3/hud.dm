/obj/item/book/granter/action/skill/healthhud
	granted_action = /datum/action/innate/healthhud
	actionname = "Healthsight"
	name = "Level 3 Skill: Healthsight"
	level = 3
	custom_premium_price = 1800

/datum/action/innate/healthhud
	name = "Healthsight"
	icon_icon = 'icons/hud/screen_skills.dmi'

/datum/action/innate/healthhud/Activate()
	to_chat(owner, "<span class='notice'>You will now see the health of all living beings.</span>")
	button_icon_state = "healthhud_on"
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medsensor.add_hud_to(owner)
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/healthhud/Deactivate()
	to_chat(owner, "<span class='notice'>You will no longer see the health of all living beings.</span>")
	button_icon_state = "healthhud_off"
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medsensor.remove_hud_from(owner)
	active = FALSE
	UpdateButtonIcon()

