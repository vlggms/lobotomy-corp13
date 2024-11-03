//Re-Raise
/obj/item/book/granter/action/skill/reraise
	granted_action = /datum/action/cooldown/reraise
	actionname = "Re-Raise"
	name = "Level 4 Skill: Re-Raise"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/reraise
	name = "Re-Raise"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "reraise"
	cooldown_time = 10 MINUTES

/datum/action/cooldown/reraise/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat != DEAD)
		return FALSE

	var/mob/living/carbon/human/human = owner
	if(human.revive(full_heal = TRUE, admin_revive = TRUE))
		human.grab_ghost(force = TRUE) // even suicides
		to_chat(target, span_notice("You refuse to die."))
	StartCooldown()

