/obj/item/book/granter/action/skill/battleready
	granted_action = /datum/action/innate/battleready
	actionname = "Veteran"
	name = "Level 3 Skill: Veteran"
	level = 3
	custom_premium_price = 1800

/datum/action/innate/battleready
	name = "Battle Ready"
	icon_icon = 'icons/hud/screen_skills.dmi'

/datum/action/innate/battleready/Activate()
	to_chat(owner, span_notice("You can now take more hits."))
	button_icon_state = "battleready_on"
	active = TRUE
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod *= 0.8
	human.physiology.white_mod *= 0.8
	human.physiology.black_mod *= 0.8
	human.physiology.pale_mod *= 0.8
	UpdateButtonIcon()

/datum/action/innate/battleready/Deactivate()
	to_chat(owner, span_notice("You now take more damage."))
	button_icon_state = "battleready_off"
	active = FALSE
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.8
	human.physiology.white_mod /= 0.8
	human.physiology.black_mod /= 0.8
	human.physiology.pale_mod /= 0.8
	UpdateButtonIcon()



/obj/item/book/granter/action/skill/fleetfoot
	granted_action = /datum/action/innate/fleetfoot
	actionname = "Fleetfoot"
	name = "Level 3 Skill: Fleetfoot"
	level = 3
	custom_premium_price = 1800

/datum/action/innate/fleetfoot
	name = "Fleet Foot"
	icon_icon = 'icons/hud/screen_skills.dmi'

/datum/action/innate/fleetfoot/Activate()
	to_chat(owner, span_notice("You now move faster."))
	button_icon_state = "fleetfoot_on"
	active = TRUE
	var/mob/living/carbon/human/human = owner
	human.add_movespeed_modifier(/datum/movespeed_modifier/fleetfoot)
	UpdateButtonIcon()

/datum/action/innate/fleetfoot/Deactivate()
	to_chat(owner, span_notice("You now move slower."))
	button_icon_state = "fleetfoot_off"
	active = FALSE
	var/mob/living/carbon/human/human = owner
	human.remove_movespeed_modifier(/datum/movespeed_modifier/fleetfoot)
	UpdateButtonIcon()

/datum/movespeed_modifier/fleetfoot
	variable = TRUE
	multiplicative_slowdown = -0.1
