/obj/item/book/granter/action/skill/bulletproof
	granted_action = /datum/action/innate/bulletproof
	actionname = "Bulletproof"
	name = "Level 3 Skill: Bulletproof"
	level = 3
	custom_premium_price = 1800

/datum/action/innate/bulletproof
	name = "Bulletproof"
	desc = "Make yourself immune to most bullets, but take more physical damage."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "shield_off"
	var/datum/martial_art/bulletproof/MA = new /datum/martial_art/bulletproof

/datum/action/innate/bulletproof/Activate()
	to_chat(owner, span_notice("You will now block bullets, but take increased melee damage."))
	button_icon_state = "shield_on"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		MA.teach(human, TRUE)
		human.physiology.red_mod *= 1.3
		human.physiology.white_mod *= 1.3
		human.physiology.black_mod *= 1.3
		human.physiology.pale_mod *= 1.3
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/bulletproof/Deactivate()
	to_chat(owner, span_notice("You will no longer block bullets, and no longer take increased melee damage"))
	button_icon_state = "shield_off"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		MA.remove(human)
		human.physiology.red_mod /= 1.3
		human.physiology.white_mod /= 1.3
		human.physiology.black_mod /= 1.3
		human.physiology.pale_mod /= 1.3
	active = FALSE
	UpdateButtonIcon()

/datum/martial_art/bulletproof/on_projectile_hit(mob/living/A, obj/projectile/P, def_zone)
	to_chat(A, span_notice("You blocked a bullet."))
	if(!P.ignore_bulletproof)
		return BULLET_ACT_BLOCK
	to_chat(A, span_userdanger("Your armor has been pierced!"))
	..()
