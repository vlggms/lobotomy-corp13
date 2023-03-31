/obj/item/ego_weapon
	name = "ego weapon"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/ego_weapons.dmi'
	worn_icon_state = "nothing" //I HATE PURPLE SPRITES, I HATE PURPLE SPRITES
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
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
		. += "<span class='notice'>[special]</span>"
	if(LAZYLEN(attribute_requirements))
		. += "<span class='notice'>It has <a href='?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.</span>"

	if(reach>1)
		. += "<span class='notice'>This weapon has a reach of [reach].</span>"

	if(throwforce>force)
		. += "<span class='notice'>This weapon deals [throwforce] [damtype] damage when thrown.</span>"

	if(!attack_speed)
		return

	//Can't switch for less than for some reason
	if(attack_speed<0.4)
		. += "<span class='notice'>This weapon has a very fast attack speed.</span>"
	else if(attack_speed<0.7)
		. += "<span class='notice'>This weapon has a fast attack speed.</span>"
	else if(attack_speed<1)
		. += "<span class='notice'>This weapon attacks slightly faster than normal.</span>"
	else if(attack_speed<1.5)
		. += "<span class='notice'>This weapon attacks slightly slower than normal.</span>"
	else if(attack_speed<2)
		. += "<span class='notice'>This weapon has a slow attack speed.</span>"
	else if(attack_speed>=2)
		. += "<span class='notice'>This weapon attacks extremely slow.</span>"


/obj/item/ego_weapon/Topic(href, href_list)
	. = ..()
	if(href_list["list_attributes"])
		var/display_text = "<span class='warning'><b>It requires the following attributes:</b></span>"
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
			to_chat(H, "<span class='notice'>You cannot use [src]!</span>")
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
		return "<span class='notice'>It deals [round(force * force_multiplier, 0.1)] [damtype] damage. (+ [(force_multiplier - 1) * 100]%)</span>"
	return "<span class='notice'>It deals [force] [damtype] damage.</span>"

/*
* Used to clean up any remaining variables or timers in an ego weapon.
*/
/obj/item/ego_weapon/proc/CleanUp()
	cleaning = TRUE
	return

/obj/item/ego_weapon/Destroy()
	CleanUp()
	return ..()

//Examine text for mini weapons.
/obj/item/ego_weapon/mini/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This weapon fits in an ego weapon belt.</span>"
