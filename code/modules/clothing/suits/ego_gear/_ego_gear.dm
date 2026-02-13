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
	var/equip_slowdown = 6 SECONDS

	var/obj/item/clothing/head/ego_hat/hat = null // Hat type, see clothing/head/_ego_head.dm
	var/obj/item/clothing/neck/ego_neck/neck = null // Neckwear, see clothing/neck/_neck.dm
	var/list/attribute_requirements = list()
	var/equip_bonus
	var/is_city_gear = FALSE //Used for City Gear

/obj/item/clothing/suit/armor/ego_gear/Initialize()
	. = ..()
	if(hat)
		var/obj/effect/proc_holder/ability/hat_ability/HA = new(null, hat)
		var/datum/action/spell_action/ability/item/H = HA.action
		H.SetItem(src)
	if(neck)
		var/obj/effect/proc_holder/ability/neck_ability/NA = new(null, neck)
		var/datum/action/spell_action/ability/item/N = NA.action
		N.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(slot_flags & slot) // Equipped to right slot, not just in hands
		if(!CanUseEgo(H))
			return FALSE
		if(equip_slowdown > 0 && (M == equipper || !equipper))
			if(!do_after(H, equip_slowdown, target = H))
				return FALSE
	return ..()

/obj/item/clothing/suit/armor/ego_gear/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_OCLOTHING) // Abilities are only granted when worn properly
		return TRUE

/obj/item/clothing/suit/armor/ego_gear/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		return
	if(hat)
		var/obj/item/clothing/head/headgear = user.get_item_by_slot(ITEM_SLOT_HEAD)
		if(!istype(headgear, hat))
			return
		headgear.Destroy()
	if(neck)
		var/obj/item/clothing/neck/neckwear = user.get_item_by_slot(ITEM_SLOT_NECK)
		if(!istype(neckwear, neck))
			return
		neckwear.Destroy()

/obj/item/clothing/suit/armor/ego_gear/dropped(mob/user)
	. = ..()
	if(hat)
		var/obj/item/clothing/head/headgear = user.get_item_by_slot(ITEM_SLOT_HEAD)
		if(!istype(headgear, hat))
			return
		headgear.Destroy()
	if(neck)
		var/obj/item/clothing/neck/neckwear = user.get_item_by_slot(ITEM_SLOT_NECK)
		if(!istype(neckwear, neck))
			return
		neckwear.Destroy()

/obj/item/clothing/suit/armor/ego_gear/proc/CanUseEgo(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	if(user.mind)
		if(user.mind.assigned_role == "Sephirah") //This is an RP role
			return FALSE

	var/mob/living/carbon/human/H = user
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > get_attribute_level(H, atr) + equip_bonus)
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
		if(!ishuman(user))	//You get a notice if you are a ghost or otherwise
			. += span_notice("It has <a href='byond://?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.")
		else if(CanUseEgo(user))	//It's green if you can use it
			. += span_nicegreen("It has <a href='byond://?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.")
		else				//and red if you cannot use it
			. += span_danger("It has <a href='byond://?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.")

/obj/item/clothing/suit/armor/ego_gear/Topic(href, href_list)
	. = ..()
	if(href_list["list_attributes"])
		var/display_text = "<span class='warning'><b>It requires the following attributes:</b></span>"
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 0)
				display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
		display_text += SpecialGearRequirements()
		to_chat(usr, display_text)
