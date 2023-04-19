/obj/item/clothing/suit/armor/ego_gear
	name = "ego gear"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/clothing/ego_gear/suits.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/suit.dmi'
	blood_overlay_type = null
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD 	// We protect all because magic
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	w_class = WEIGHT_CLASS_BULKY								//No more stupid 10 egos in bag
	allowed = list(/obj/item/gun, /obj/item/ego_weapon, /obj/item/melee)
	drag_slowdown = 1
	var/equip_slowdown = 3 SECONDS

	var/list/attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(slot_flags & slot) // Equipped to right slot, not just in hands
		if(!CanUseEgo(H))
			return FALSE
		if(equip_slowdown > 0)
			if(!do_after(H, equip_slowdown, target = H))
				return FALSE
	return ..()


/obj/item/clothing/suit/armor/ego_gear/proc/CanUseEgo(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	if(user.mind)
		if(user.mind.assigned_role == "Sephirah") //This is an RP role
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


/obj/item/clothing/suit/armor/ego_gear/adjustable
	var/list/alternative_styles = list()
	var/index = 0

/obj/item/clothing/suit/armor/ego_gear/adjustable/Initialize()
	. = ..()
	alternative_styles |= icon_state
	index = alternative_styles.len

/obj/item/clothing/suit/armor/ego_gear/adjustable/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It can be adjusted by right-clicking the armor.</span>"

/obj/item/clothing/suit/armor/ego_gear/adjustable/verb/AdjustStyle()
	set name = "Adjust EGO Style"
	set category = null
	set src in usr
	Adjust()

/obj/item/clothing/suit/armor/ego_gear/adjustable/proc/Adjust()
	if(!ishuman(usr))
		return
	if(alternative_styles.len <= 1)
		to_chat(usr, "<span class='notice'>Has no other styles!</span>")
		return
	index++
	if(index > alternative_styles.len)
		index = 1
	icon_state = alternative_styles[index]
	to_chat(usr, "<span class='notice'>You adjust [src] to a new style~!</span>")
	var/mob/living/carbon/human/H = usr
	H.update_inv_wear_suit()
	H.update_body()
