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
	var/list/attribute_requirements = list()
	var/special
	var/autofire	//In Rounds per second

/obj/item/gun/ego_gun/Initialize()
	. = ..()
	chambered = new ammo_type(src)
	if(autofire)
		AddComponent(/datum/component/automatic_fire, autofire)

/obj/item/gun/ego_gun/examine(mob/user)
	. = ..()
	. += EgoAttackInfo(user)
	if(special)
		. += "<span class='notice'>[special]</span>"
	if(weapon_weight != WEAPON_HEAVY)
		. += "<span class='notice'>This weapon can be fired with one hand.</span>"
	if(!autofire)
		switch(fire_delay)
			if(0 to 3)
				. += "<span class='notice'>This weapon fires very fast.</span>"
			if(4 to 8)
				. += "<span class='notice'>This weapon fires fast.</span>"
			if(9 to 13)
				. += "<span class='notice'>This weapon fires slow.</span>"
			else
				. += "<span class='notice'>This weapon fires extremely slowly.</span>"

	else
		//Give it to 'em in true rounds per minute, accurate to the 5s
		var/rpm = (1/autofire*10)*60
		rpm = round(rpm,5)
		. += "<span class='notice'>This weapon is automatic.</span>"
		. += "<span class='notice'>This weapon fires at [rpm] rounds per minute.</span>"

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
	if(chambered)
		chambered.newshot()

/obj/item/gun/ego_gun/before_firing(atom/target,mob/user)
	if(QDELETED(chambered))
		chambered = new ammo_type(src)
	return

/obj/item/gun/ego_gun/shoot_with_empty_chamber(mob/living/user)
	before_firing(user = user)
	return ..()

//Examine text for pistols.
/obj/item/gun/ego_gun/pistol/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This weapon fits in an ego weapon belt.</span>"
