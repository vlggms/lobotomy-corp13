/obj/item/clothing/suit/armor/ego_gear
	name = "ego gear"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/clothing/ego_gear/suits.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/suit.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|HEAD // We protect all because magic
	cold_protection = CHEST|GROIN|LEGS|ARMS|HEAD
	heat_protection = CHEST|GROIN|LEGS|ARMS|HEAD
	var/list/attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 0,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)

/obj/item/clothing/suit/armor/ego_gear/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(slot_flags & slot) // Equipped to right slot, not just in hands
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > get_attribute_level(H, atr))
				to_chat(H, "<span class='notice'>You cannot equip [src]!</span>")
				return FALSE
	if(!special_ego_check(H))
		return FALSE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/proc/special_ego_check(mob/living/carbon/human/H)
	return TRUE

/obj/item/clothing/suit/armor/ego_gear/examine(mob/user)
	. = ..()
	var/display_text = null
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > 0)
			display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
	if(display_text)
		. += "<span class='warning'><b>It requires the following attributes:</b></span> [display_text]"
