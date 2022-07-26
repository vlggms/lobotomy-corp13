/obj/item/clothing/suit/armor/ego_gear
	name = "ego gear"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/clothing/ego_gear/suits.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/suit.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD 	// We protect all because magic
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	w_class = WEIGHT_CLASS_BULKY								//No more stupid 10 egos in bag
	allowed = list(/obj/item/gun/ego_gun, /obj/item/ego_weapon)

	var/list/attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(slot_flags & slot) // Equipped to right slot, not just in hands
		if(!CanUseEgo(H))
			return FALSE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/proc/CanUseEgo(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > get_attribute_level(H, atr))
			to_chat(H, "<span class='notice'>You cannot use [src]!</span>")
			return FALSE
	if(!SpecialEgoCheck(H))
		return FALSE
	return TRUE

/obj/item/clothing/suit/armor/ego_gear/proc/SpecialEgoCheck(mob/living/carbon/human/H)
	return TRUE

/obj/item/clothing/suit/armor/ego_gear/proc/SpecialGearRequirements()
	return

/obj/item/clothing/suit/armor/ego_gear/examine(mob/user)
	. = ..()
	if(LAZYLEN(attribute_requirements))
		. += "<span class='notice'>It has <a href='?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.</span>"

/obj/item/clothing/suit/armor/ego_gear/Topic(href, href_list)
	. = ..()
	if(href_list["list_attributes"])
		var/display_text = "<span class='warning'><b>It requires the following attributes:</b></span>"
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 0)
				display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
		display_text += SpecialGearRequirements()
		to_chat(usr, display_text)
