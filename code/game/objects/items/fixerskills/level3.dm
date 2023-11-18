// /obj/item/book/granter/action/skill/nightvision
// 	granted_action = /datum/action/innate/nightvision
// 	actionname = "Nightvision"
// 	name = "Nightvision"
// 	level = 3

// /datum/action/innate/nightvision
// 	name = "Nightvision"
// 	icon_icon = 'icons/hud/screen_skills.dmi'

// /datum/action/innate/nightvision/Activate()
// 	to_chat(owner, "<span class='notice'>You will now see in the dark.</span>")
// 	button_icon_state = "night_eye_on"
// 	if (ishuman(owner))
// 		var/mob/living/carbon/human/human = owner
// 		var/obj/item/organ/eyes/E = human.getorganslot(ORGAN_SLOT_EYES)
// 		if(E)
// 			E.see_in_dark = 8
// 		human.update_sight()

// 	active = TRUE
// 	UpdateButtonIcon()

// /datum/action/innate/nightvision/Deactivate()
// 	to_chat(owner, "<span class='notice'>You will no longer see in the dark.</span>")
// 	button_icon_state = "night_eye_off"
// 	if (ishuman(owner))
// 		var/mob/living/carbon/human/human = owner
// 		var/obj/item/organ/eyes/E = human.getorganslot(ORGAN_SLOT_EYES)
// 		if(E)
// 			E.see_in_dark = 2
// 		human.update_sight()

// 	active = FALSE
// 	UpdateButtonIcon()


/obj/item/book/granter/action/skill/bulletproof
	granted_action = /datum/action/innate/bulletproof
	actionname = "Bulletproof"
	name = "Bulletproof"
	level = 3

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



/datum/martial_art/bulletproof

/datum/martial_art/bulletproof/on_projectile_hit(mob/living/A, obj/projectile/P, def_zone)
	to_chat(A, "<span class='notice'>You blocked a bullet.</span>")
	return BULLET_ACT_BLOCK
