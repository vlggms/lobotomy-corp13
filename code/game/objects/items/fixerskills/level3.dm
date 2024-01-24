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
