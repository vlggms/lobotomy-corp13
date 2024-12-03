/obj/item/book/granter/action/skill/shockwave
	granted_action = /datum/action/cooldown/shockwave
	actionname = "Shockwave"
	name = "Level 2 Skill: Shockwave"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/shockwave
	name = "Shockwave"
	desc = "Throw everything in a 13 meter radious away from you."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "shockwave"
	cooldown_time = 15 SECONDS

/datum/action/cooldown/shockwave/Trigger()
	. = ..()
	if(!.)
		return
	if(owner.stat != CONSCIOUS)
		to_chat(owner, span_warning("Throwing everything away from you would be difficult in this state."))
		return

	goonchem_vortex(get_turf(owner), 1, 13)
	owner.visible_message(span_userdanger("[owner] throws away everything around them!"), span_warning("You throw everything away from you!"))
	StartCooldown()
