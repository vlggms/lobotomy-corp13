/obj/item/ego_weapon
	name = "ego weapon"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/ego_weapons.dmi'
	worn_icon_state = "nothing" //I HATE PURPLE SPRITES, I HATE PURPLE SPRITES
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY			//No more stupid 10 egos in bag
	slot_flags = ITEM_SLOT_BELT
	drag_slowdown = 1
	var/list/attribute_requirements = list()
	var/attack_speed
	var/special
	var/force_multiplier = 1

	/// Is CleanUp proc running?
	var/cleaning = FALSE

/obj/item/ego_weapon/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return FALSE
	. = ..()
	if(attack_speed)
		user.changeNext_move(CLICK_CD_MELEE * attack_speed)
	return TRUE // If we want to do "if(!.)" checks, this has to exist.

/obj/item/ego_weapon/examine(mob/user)
	. = ..()
	. += EgoAttackInfo(user)
	if(special)
		. += span_notice("[special]")
	if(LAZYLEN(attribute_requirements))
		. += span_notice("It has <a href='?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.")

	if(type in GLOB.small_ego)
		. += span_notice("This weapon fits in an EGO belt.")

	if(reach>1)
		. += span_notice("This weapon has a reach of [reach].")

	if(throwforce>force)
		. += span_notice("This weapon deals [throwforce] [damtype] damage when thrown.")

	if(!attack_speed)
		return

	//Can't switch for less than for some reason
	if(attack_speed<0.4)
		. += span_notice("This weapon has a very fast attack speed.")
	else if(attack_speed<0.7)
		. += span_notice("This weapon has a fast attack speed.")
	else if(attack_speed<1)
		. += span_notice("This weapon attacks slightly faster than normal.")
	else if(attack_speed<1.5)
		. += span_notice("This weapon attacks slightly slower than normal.")
	else if(attack_speed<2)
		. += span_notice("This weapon has a slow attack speed.")
	else if(attack_speed>=2)
		. += span_notice("This weapon attacks extremely slow.")


/obj/item/ego_weapon/Topic(href, href_list)
	. = ..()
	if(href_list["list_attributes"])
		var/display_text = span_warning("<b>It requires the following attributes:</b>")
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 0)
				display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
		display_text += SpecialGearRequirements()
		to_chat(usr, display_text)

/obj/item/ego_weapon/proc/CanUseEgo(mob/living/user)
	if(istype(user, /mob/living/simple_animal/bot/cleanbot))
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 40)
				return FALSE
		return TRUE
	if(!ishuman(user))
		return FALSE

	if(user.mind)
		if(user.mind.assigned_role == "Sephirah") //This is an RP role
			return FALSE

	var/mob/living/carbon/human/H = user
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > get_attribute_level(H, atr))
			to_chat(H, span_notice("You cannot use [src]!"))
			return FALSE
	if(!SpecialEgoCheck(H))
		return FALSE
	return TRUE

/obj/item/ego_weapon/proc/SpecialEgoCheck(mob/living/carbon/human/H)
	return TRUE

/obj/item/ego_weapon/proc/SpecialGearRequirements()
	return

/obj/item/ego_weapon/proc/EgoAttackInfo(mob/user)
	if(force_multiplier != 1)
		return span_notice("It deals [round(force * force_multiplier, 0.1)] [damtype] damage. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [force] [damtype] damage.")

/*
* Used to clean up any remaining variables or timers in an ego weapon.
*/
/obj/item/ego_weapon/proc/CleanUp()
	cleaning = TRUE
	return

/obj/item/ego_weapon/Destroy()
	CleanUp()
	return ..()
