//Nuke
/obj/item/book/granter/action/skill/nuke
	granted_action = /datum/action/cooldown/nuke
	actionname = "Nuke"
	name = "Level 4 Skill: Nuke"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/nuke
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "nuke"
	name = "Nuke"
	cooldown_time = 12000

/datum/action/cooldown/nuke/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Blow up
	explosion(owner,0,0,10,18)

	StartCooldown()

