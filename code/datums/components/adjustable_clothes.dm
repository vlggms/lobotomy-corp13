/**
 * Adjustable clothing;
 * Takes a list of styles and a generic adjustment text.
 * If one is not provided, it automates to my awful one you have to cope with.
 * Updates the Examine Text and does all its actions through a radial menu.
 */

/datum/component/adjustable_gear
	var/list/alternative_styles = list()
	var/icon
	var/obj/item/clothing/parent_clothes
	var/adjust_text

/datum/component/adjustable_gear/Initialize(list/_alternative_styles, _adjust_text)
	if(!isclothing(parent))
		return COMPONENT_INCOMPATIBLE
	parent_clothes = parent
	if(!islist(_alternative_styles))
		if(isnull(_alternative_styles))
			return COMPONENT_INCOMPATIBLE
		_alternative_styles = list(_alternative_styles)
	alternative_styles = _alternative_styles
	icon = parent_clothes.icon
	adjust_text = _adjust_text ? _adjust_text : "You adjust [parent_clothes] to a new style~!"

/datum/component/adjustable_gear/RegisterWithParent()
	parent_clothes.verbs += /obj/item/clothing/proc/AdjustStyle
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(ExamineMessage))

/datum/component/adjustable_gear/UnregisterFromParent()
	parent_clothes.verbs -= /obj/item/clothing/proc/AdjustStyle
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)

/datum/component/adjustable_gear/proc/ExamineMessage(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("It is able to be adjusted.")

/datum/component/adjustable_gear/proc/Adjust()
	if(!ishuman(usr))
		return
	var/list/choice_list = list()
	for(var/styles in alternative_styles)
		choice_list[styles] = image(icon = icon, icon_state = styles)

	var/choice = show_radial_menu(usr, parent_clothes, choice_list, custom_check = CALLBACK(src, PROC_REF(check_menu), usr), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(usr))
		return
	parent_clothes.icon_state = choice
	to_chat(usr, span_notice(adjust_text))
	var/mob/living/carbon/human/H = usr
	H.regenerate_icons()

/datum/component/adjustable_gear/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src) || QDELETED(parent))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/proc/AdjustStyle()
	set name = "Adjust Style"
	set category = "Object"
	set src in view(1)
	var/datum/component/adjustable_gear/adj_comp = GetComponent(/datum/component/adjustable_gear)
	if(adj_comp)
		adj_comp.Adjust()
