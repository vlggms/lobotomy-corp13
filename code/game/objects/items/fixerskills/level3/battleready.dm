/obj/item/book/granter/action/skill/battleready
	granted_action = /datum/action/innate/battleready
	actionname = "Battle Ready"
	name = "Level 3 Skill: Battle Ready"
	level = 3
	custom_premium_price = 1800

/datum/action/innate/battleready
	name = "Battle Ready"
	icon_icon = 'icons/hud/screen_skills.dmi'

/datum/action/innate/battleready/Activate()
	to_chat(owner, "<span class='notice'>You can now take more hits and move faster.</span>")
	button_icon_state = "battleready_on"
	active = TRUE
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod *= 0.8
	human.physiology.white_mod *= 0.8
	human.physiology.black_mod *= 0.8
	human.physiology.pale_mod *= 0.8
	human.add_movespeed_modifier(/datum/movespeed_modifier/assault)
	UpdateButtonIcon()

/datum/action/innate/battleready/Deactivate()
	to_chat(owner, "<span class='notice'>You now take more damage and move slower.</span>")
	button_icon_state = "battleready_off"
	active = FALSE
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.8
	human.physiology.white_mod /= 0.8
	human.physiology.black_mod /= 0.8
	human.physiology.pale_mod /= 0.8
	human.remove_movespeed_modifier(/datum/movespeed_modifier/assault)
	UpdateButtonIcon()

/datum/movespeed_modifier/battleready
	variable = TRUE
	multiplicative_slowdown = -0.2
