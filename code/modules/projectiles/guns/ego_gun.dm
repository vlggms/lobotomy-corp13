/obj/item/gun/ego_gun
	name = "ego gun"
	desc = "Some sort of weapon..?"
	icon = 'icons/obj/ego_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
	fire_sound = 'sound/weapons/emitter.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	pin = /obj/item/firing_pin/magic
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
	var/display_text = null
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > 0)
			display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
	if(display_text)
		. += "<span class='warning'><b>It requires the following attributes:</b></span> [display_text]"

/obj/item/gun/ego_gun/proc/EgoAttackInfo(mob/user)
	if(chambered && chambered.BB)
		return "<span class='notice'>Its bullets deal [chambered.BB.damage] [chambered.BB.damage_type] damage.</span>"
	return

/obj/item/gun/ego_gun/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > get_attribute_level(H, atr))
			to_chat(H, "<span class='notice'>You cannot use [src]!</span>")
			return FALSE
	if(!special_ego_check(H))
		return FALSE
	return ..()

/obj/item/gun/ego_gun/proc/special_ego_check(mob/living/carbon/human/H)
	return TRUE

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
