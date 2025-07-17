/obj/item/clothing/suit/armor/ego_gear/city
	icon = 'icons/obj/clothing/ego_gear/lc13_armor.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lc13_armor.dmi'


//City armor have extremely high requirements. These people will be able to use them a little earlier.
/obj/item/clothing/suit/armor/ego_gear/city/examine(mob/user)
	. = ..()
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Combat Research Agent")) //These guys get a bonus to equipping gacha.
			. += span_notice("Due to your abilities, you get a -20 reduction to stat requirements when equipping this armor.")

/obj/item/clothing/suit/armor/ego_gear/city/CanUseEgo(mob/living/user)
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Combat Research Agent")) //These guys get a bonus to equipping gacha.
			equip_bonus = 20
		else
			equip_bonus = 0
	. = ..()
