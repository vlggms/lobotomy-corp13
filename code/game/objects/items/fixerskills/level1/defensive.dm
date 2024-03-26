//Hunker Down
/obj/item/book/granter/action/skill/hunkerdown
	granted_action = /datum/action/cooldown/hunkerdown
	name = "Level 1 Skill: Hunker Down"
	actionname = "Hunker Down"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/hunkerdown
	cooldown_time = 300
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "hunkerdown"


/datum/action/cooldown/hunkerdown/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/hunkerdown)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/hunkerdown), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.physiology.red_mod *= 0.6
		human.physiology.white_mod *= 0.6
		human.physiology.black_mod *= 0.6
		human.physiology.pale_mod *= 0.6
		addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/hunkerdown/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.6
	human.physiology.white_mod /= 0.6
	human.physiology.black_mod /= 0.6
	human.physiology.pale_mod /= 0.6


/datum/movespeed_modifier/hunkerdown
	variable = TRUE
	multiplicative_slowdown = 1.5
