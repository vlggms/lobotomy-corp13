/obj/item/clothing/suit/armor/ego_gear/city/index
	flags_inv = HIDEJUMPSUIT | HIDEGLOVES
	name = "index proselyte armor"
	desc = "Armor worn by index proselytes."
	icon_state = "index_proselyte"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 30)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/index_proxy //Choose your Drip babey
	name = "index proxy armor"
	desc = "Armor worn by index proxies."
	icon_state = "index_proxy_open"
	icon = 'icons/obj/clothing/ego_gear/lc13_armor.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lc13_armor.dmi'
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 40)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/index_proxy/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_gear, list("index_proxy_open", "index_proxy_closed"))

/obj/item/clothing/suit/armor/ego_gear/index_proxy/examine(mob/user)
	. = ..()
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Combat Research Agent")) //These guys get a bonus to equipping gacha.
			. += span_notice("Due to your abilities, you get a -20 reduction to stat requirements when equipping this armor.")

/obj/item/clothing/suit/armor/ego_gear/index_proxy/CanUseEgo(mob/living/user)
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Combat Research Agent")) //These guys get a bonus to equipping gacha.
			equip_bonus = 20
		else
			equip_bonus = 0
	. = ..()


/obj/item/clothing/suit/armor/ego_gear/city/index_mess
	name = "index messenger armor"
	desc = "Armor worn by index messengers."
	icon_state = "yan_cloak"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 60)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
