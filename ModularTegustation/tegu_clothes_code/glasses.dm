/**
 * Manager glasses, should probably be deleted as they are not used anymore but not my job
 * They have the medical, security and diagnostics hud
 */

/obj/item/clothing/glasses/manager
	name = "Manager monocle MKII"
	desc = "A monocle with built-in Medical, security and diagnostic hud."
	icon_state = "thermoncle"
	inhand_icon_state = "thermoncle"
	flags_cover = GLASSESCOVERSEYES
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_WELDER
	glass_colour_type = FALSE
	clothing_flags = SCAN_REAGENTS
	var/list/hudlist = list(DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED, DATA_HUD_SECURITY_ADVANCED)

/obj/item/clothing/glasses/manager/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_EYES)
		return
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.add_hud_to(user)
		ADD_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
		ADD_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)

/obj/item/clothing/glasses/manager/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
	REMOVE_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.remove_hud_from(user)
