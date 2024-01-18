/obj/item/book/granter/action/skill/bulletproof
	granted_action = /datum/action/innate/bulletproof
	actionname = "Bulletproof"
	name = "Level 3 Skill: Bulletproof"
	level = 3
	custom_premium_price = 1800

/datum/action/innate/bulletproof
	name = "Bulletproof"
	icon_icon = 'icons/hud/screen_skills.dmi'
	var/datum/martial_art/bulletproof/MA = new /datum/martial_art/bulletproof

/datum/action/innate/bulletproof/Activate()
	to_chat(owner, "<span class='notice'>You will now block bullets.</span>")
	button_icon_state = "shield_on"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		MA.teach(human, TRUE)
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/bulletproof/Deactivate()
	to_chat(owner, "<span class='notice'>You will no longer block bullets.</span>")
	button_icon_state = "shield_off"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		MA.remove(human)
	active = FALSE
	UpdateButtonIcon()

/datum/martial_art/bulletproof/on_projectile_hit(mob/living/A, obj/projectile/P, def_zone)
	if(prob(40))
		to_chat(A, "<span class='notice'>You blocked a bullet.</span>")
		return BULLET_ACT_BLOCK
