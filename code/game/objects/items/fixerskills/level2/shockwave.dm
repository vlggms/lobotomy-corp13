/obj/item/book/granter/action/skill/shockwave
	granted_action = /datum/action/cooldown/shockwave
	actionname = "Shockwave"
	name = "Level 2 Skill: Shockwave"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/shockwave
	icon_icon = 'icons/hud/screen_skills.dmi'
	name = "Shockwave"
	button_icon_state = "shockwave"
	cooldown_time = 150

/datum/action/cooldown/shockwave/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat)
		return FALSE
	goonchem_vortex(get_turf(src), 1, 13)
	StartCooldown()
