/obj/item/gun/ego_gun
	name = "ego gun"
	desc = "Some sort of weapon..?"
	icon = 'icons/obj/ego_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
	fire_sound = 'sound/weapons/emitter.ogg'
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	pin = /obj/item/firing_pin/magic
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_BULKY			//No more stupid 10 egos in bag
	var/obj/item/ammo_casing/ammo_type
	var/list/attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 0,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)

/obj/item/gun/ego_gun/Initialize()
	. = ..()
	chambered = new ammo_type(src)

/obj/item/gun/ego_gun/examine(mob/user)
	. = ..()
	. += EgoAttackInfo(user)
	if(LAZYLEN(attribute_requirements))
		. += "<span class='notice'>It has <a href='?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.</span>"

/obj/item/gun/ego_gun/Topic(href, href_list)
	. = ..()
	if(href_list["list_attributes"])
		var/display_text = "<span class='warning'><b>It requires the following attributes:</b></span>"
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 0)
				display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
		display_text += SpecialGearRequirements()
		to_chat(usr, display_text)

/obj/item/gun/ego_gun/proc/EgoAttackInfo(mob/user)
	if(chambered && chambered.BB)
		return "<span class='notice'>Its bullets deal [chambered.BB.damage] [chambered.BB.damage_type] damage.</span>"
	return

/obj/item/gun/ego_gun/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(!CanUseEgo(user))
		return FALSE
	return ..()

/obj/item/gun/ego_gun/proc/CanUseEgo(mob/living/carbon/human/user)
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

/obj/item/gun/ego_gun/proc/SpecialEgoCheck(mob/living/carbon/human/H)
	return TRUE

/obj/item/gun/ego_gun/proc/SpecialGearRequirements()
	return

/obj/item/gun/ego_gun/can_shoot()
	return TRUE

/obj/item/gun/ego_gun/process_chamber()
	if(chambered && !chambered.BB)
		recharge_newshot()

/obj/item/gun/ego_gun/recharge_newshot()
	if(chambered && !chambered.BB)
		chambered.newshot()

/obj/item/gun/ego_gun/shoot_with_empty_chamber(mob/living/user)
	if(!chambered)
		chambered = new ammo_type(src)
		return
	return ..()
