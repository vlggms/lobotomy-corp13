//Nuke
/obj/item/book/granter/action/skill/nuke
	granted_action = /datum/action/cooldown/nuke
	actionname = "Nuke"
	name = "Level 4 Skill: Nuke"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/nuke
	name = "Nuke"
	desc = "Blow up, damaging all humans in radius."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "nuke"
	cooldown_time = 20 MINUTES

/datum/action/cooldown/nuke/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Blow up
	explosion(owner,0,0,10,18)

	StartCooldown()

