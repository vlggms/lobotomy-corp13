/obj/item/book/granter/action/skill/assault
	granted_action = /datum/action/cooldown/assault
	name = "Office Skill: Assault"
	actionname = "Assault"
	level = -1

/datum/action/cooldown/assault
	cooldown_time = 30
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "assault"


/datum/action/cooldown/assault/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/assault)
		addtimer(CALLBACK(human, .mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/assault), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/movespeed_modifier/assault
	variable = TRUE
	multiplicative_slowdown = -0.1
