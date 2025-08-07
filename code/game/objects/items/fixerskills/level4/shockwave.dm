/obj/item/book/granter/action/skill/shockwave
	granted_action = /datum/action/cooldown/shockwave
	actionname = "Shockwave"
	name = "Level 4 Skill: Shockwave"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/shockwave
	name = "Shockwave"
	desc = "Throw everything in a 4 meter radious away from you."
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

	goonchem_vortex(get_turf(owner), 1, 4)
	owner.visible_message(span_userdanger("[owner] throws away everything around them!"), span_warning("You throw everything away from you!"))
	StartCooldown()
