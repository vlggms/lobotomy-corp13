/obj/item/book/granter/action/skill/timestop
	granted_action = /datum/action/cooldown/timestop
	actionname = "Timestop"
	name = "Level 4 Skill: Timestop"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/timestop
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "timestop"
	cooldown_time = 3000
	var/timestop_range = 2
	var/timestop_duration = 20

/datum/action/cooldown/timestop/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (owner.stat)
		return FALSE
	new /obj/effect/timestop(get_turf(owner), timestop_range, timestop_duration, list(owner))
	StartCooldown()
