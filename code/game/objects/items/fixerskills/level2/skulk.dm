
//Skulk
/obj/item/book/granter/action/skill/skulk
	granted_action = /datum/action/cooldown/skulk
	actionname = "Skulk"
	name = "Level 2 Skill: Skulk"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skulk
	name = "Skulk"
	desc = "Make yourself nearly invisible for 10 seconds."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "skulk"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/skulk/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//become invisible
	owner.alpha = 35
	addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	StartCooldown()

/datum/action/cooldown/skulk/proc/Recall()
	owner.alpha = 255
