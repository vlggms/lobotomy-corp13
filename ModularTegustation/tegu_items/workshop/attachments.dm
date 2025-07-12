/obj/item/attachment/workshop
	name = "workshop attachment"
	desc = "A blank attachment that can be imbued with skill cores and attached to weapons."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	w_class = WEIGHT_CLASS_SMALL
	color = "#C0C0C0"
	var/obj/item/ego_weapon/attached_to = null
	var/datum/action/granted_action = null
	var/skill_type = null
	var/skill_name = null
	var/datum/weakref/current_user

/obj/item/attachment/workshop/proc/update_name()
	if(skill_name)
		name = "[skill_name] workshop attachment"
	else
		name = initial(name)

/obj/item/attachment/workshop/proc/update_desc()
	if(skill_name)
		desc = "A workshop attachment imbued with the power of [skill_name]. Attach it to a weapon to grant its wielder this ability."
	else
		desc = initial(desc)

/obj/item/attachment/workshop/update_icon_state()
	. = ..()
	add_atom_colour(color, FIXED_COLOUR_PRIORITY)

/obj/item/attachment/workshop/attackby(obj/item/I, mob/user, params)
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

	if(istype(I, /obj/item/ego_weapon))
		var/obj/item/ego_weapon/weapon = I
		if(attached_to)
			to_chat(user, span_warning("[src] is already attached to something!"))
			return

		if(!attach_to_weapon(weapon, user))
			to_chat(user, span_warning("You can't attach [src] to [weapon]!"))
			return

		to_chat(user, span_notice("You attach [src] to [weapon]."))
		playsound(weapon, 'sound/items/sheath.ogg', 25, TRUE)
		return

	return ..()

/obj/item/attachment/workshop/proc/attach_to_weapon(obj/item/ego_weapon/weapon, mob/user)
	if(!weapon || attached_to)
		return FALSE

	if(!weapon.can_attach_attachment(src))
		return FALSE

	forceMove(weapon)
	attached_to = weapon
	weapon.attached_attachment = src

	RegisterSignal(weapon, COMSIG_ITEM_EQUIPPED, PROC_REF(on_weapon_equipped))
	RegisterSignal(weapon, COMSIG_ITEM_DROPPED, PROC_REF(on_weapon_dropped))

	return TRUE

/obj/item/attachment/workshop/proc/detach_from_weapon(mob/user)
	if(!attached_to)
		return FALSE

	UnregisterSignal(attached_to, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	if(granted_action && current_user)
		var/mob/living/old_user = current_user.resolve()
		if(old_user)
			remove_ability(old_user)

	var/obj/item/ego_weapon/weapon = attached_to
	attached_to = null
	weapon.attached_attachment = null

	if(user)
		forceMove(get_turf(user))
		user.put_in_hands(src)
	else
		forceMove(get_turf(weapon))

	return TRUE

/obj/item/attachment/workshop/proc/on_weapon_equipped(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER

	if(!skill_type)
		return

	if(!ishuman(user))
		return

	if(slot != ITEM_SLOT_HANDS && slot != ITEM_SLOT_BELT)
		return


	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		grant_ability(H)

/obj/item/attachment/workshop/proc/on_weapon_dropped(obj/item/source, mob/living/user)
	SIGNAL_HANDLER

	if(granted_action && user)
		remove_ability(user)

/obj/item/attachment/workshop/proc/grant_ability(mob/living/carbon/human/user)
	if(!skill_type || !user)
		return

	if(granted_action)
		remove_ability(current_user?.resolve())

	granted_action = new skill_type()
	granted_action.Grant(user)
	current_user = WEAKREF(user)

	to_chat(user, span_nicegreen("You feel the power of [skill_name] flowing through [attached_to]!"))

/obj/item/attachment/workshop/proc/remove_ability(mob/living/user)
	if(!granted_action || !user)
		return

	granted_action.Remove(user)
	QDEL_NULL(granted_action)
	current_user = null

/obj/item/attachment/workshop/Destroy()
	if(attached_to)
		detach_from_weapon()

	if(granted_action && current_user)
		var/mob/living/user = current_user.resolve()
		if(user)
			remove_ability(user)

	return ..()

/obj/item/ego_weapon/proc/can_attach_attachment(obj/item/attachment/workshop/attachment)
	if(attached_attachment)
		return FALSE
	return TRUE

/obj/item/ego_weapon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/attachment/workshop))
		var/obj/item/attachment/workshop/attachment = I
		if(attached_attachment)
			to_chat(user, span_warning("[src] already has an attachment!"))
			return

		if(!attachment.attach_to_weapon(src, user))
			to_chat(user, span_warning("You can't attach [attachment] to [src]!"))
			return

		to_chat(user, span_notice("You attach [attachment] to [src]."))
		playsound(src, 'sound/items/sheath.ogg', 25, TRUE)
		return

	return ..()

/obj/item/ego_weapon/AltClick(mob/user)
	. = ..()
	if(attached_attachment && user.Adjacent(src))
		if(attached_attachment.detach_from_weapon(user))
			to_chat(user, span_notice("You remove [attached_attachment] from [src]."))
			playsound(src, 'sound/items/unsheath.ogg', 50, TRUE)
		return TRUE

/obj/item/ego_weapon/examine(mob/user)
	. = ..()
	if(attached_attachment)
		. += span_notice("It has \a [attached_attachment] attached to it. Alt-click to remove.")
