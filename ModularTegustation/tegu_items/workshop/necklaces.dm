/obj/item/clothing/neck/skill_necklace
	name = "skill necklace"
	desc = "A blank necklace that can be imbued with skill cores to grant abilities."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "beads"
	w_class = WEIGHT_CLASS_SMALL
	color = "#C0C0C0"
	var/datum/action/granted_action = null
	var/skill_type = null
	var/skill_name = null

/obj/item/clothing/neck/skill_necklace/Initialize()
	. = ..()
	update_name()
	update_desc()

/obj/item/clothing/neck/skill_necklace/proc/update_name()
	if(skill_name)
		name = "[skill_name] necklace"
	else
		name = initial(name)

/obj/item/clothing/neck/skill_necklace/proc/update_desc()
	if(skill_name)
		desc = "A necklace imbued with the power of [skill_name]. Wear it to gain this ability."
	else
		desc = initial(desc)

/obj/item/clothing/neck/skill_necklace/update_icon_state()
	. = ..()
	add_atom_colour(color, FIXED_COLOUR_PRIORITY)

/obj/item/clothing/neck/skill_necklace/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/skill_core))
		var/obj/item/skill_core/core = I
		if(skill_type)
			to_chat(user, span_warning("[src] has already been imbued with a skill!"))
			return
		if(!core.skill_type)
			to_chat(user, span_warning("[core] doesn't contain a valid skill!"))
			return

		skill_type = core.skill_type
		skill_name = core.skill_name
		color = core.color
		update_name()
		update_desc()

		to_chat(user, span_notice("You imbue [src] with the power of [skill_name]."))
		playsound(src, 'sound/magic/charge.ogg', 25, TRUE)
		qdel(core)
		return

	return ..()

/obj/item/clothing/neck/skill_necklace/equipped(mob/living/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_NECK)
		return

	if(!skill_type)
		return

	if(!ishuman(user))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		grant_ability(H)

/obj/item/clothing/neck/skill_necklace/dropped(mob/living/user)
	. = ..()
	if(granted_action && user)
		remove_ability(user)

/obj/item/clothing/neck/skill_necklace/proc/grant_ability(mob/living/carbon/human/user)
	if(!skill_type || !user)
		return

	if(granted_action)
		remove_ability(user)

	granted_action = new skill_type()
	granted_action.Grant(user)

	to_chat(user, span_nicegreen("You feel the power of [skill_name] flowing through the necklace!"))

/obj/item/clothing/neck/skill_necklace/proc/remove_ability(mob/living/user)
	if(!granted_action || !user)
		return

	granted_action.Remove(user)
	QDEL_NULL(granted_action)

/obj/item/clothing/neck/skill_necklace/Destroy()
	if(granted_action)
		var/mob/living/wearer = loc
		if(istype(wearer))
			remove_ability(wearer)

	return ..()

/obj/item/clothing/neck/skill_necklace/examine(mob/user)
	. = ..()
	if(skill_name)
		. += span_notice("It is imbued with the power of [skill_name].")
	else
		. += span_notice("It can be imbued with a skill core.")
