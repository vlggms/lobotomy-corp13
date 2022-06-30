/obj/item/ego_weapon
	name = "ego weapon"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/ego_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
	var/list/attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 0,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)

/obj/item/ego_weapon/attack(mob/living/target, mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > get_attribute_level(H, atr))
			to_chat(H, "<span class='notice'>You cannot use [src]!</span>")
			return FALSE
	return ..()

/obj/item/ego_weapon/examine(mob/user)
	. = ..()
	. += EgoAttackInfo(user)
	var/display_text = null
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > 0)
			display_text += "\n <span class='warning'>[atr]: [attribute_requirements[atr]].</span>"
	if(display_text)
		. += "<span class='warning'><b>It requires the following attributes:</b></span> [display_text]"

/obj/item/ego_weapon/proc/EgoAttackInfo(mob/user)
	return "<span class='notice'>It deals [force] [damtype] damage.</span>"
