//Wcorp
/obj/item/clothing/suit/armor/ego_gear/wcorp
	name = "w corp armor vest"
	desc = "A light armor vest worn by W corp. It's light as a feather."
	icon_state = "w_corp"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 30)
	slowdown = -0.1
	flags_inv = null
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 55,
							PRUDENCE_ATTRIBUTE = 55,
							TEMPERANCE_ATTRIBUTE = 55,
							JUSTICE_ATTRIBUTE = 55
							)

/obj/item/clothing/suit/armor/ego_gear/wcorp/examine(mob/user)
	. = ..()
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Combat Research Agent")) //These guys get a bonus to equipping gacha.
			. += span_notice("Due to your abilities, you get a -20 reduction to stat requirements when equipping this armor.")

/obj/item/clothing/suit/armor/ego_gear/wcorp/CanUseEgo(mob/living/user)
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Combat Research Agent")) //These guys get a bonus to equipping gacha.
			equip_bonus = 20
		else
			equip_bonus = 0
	. = ..()


/obj/item/clothing/head/ego_hat/wcorp
	name = "w-corp cap"
	desc = "A ball cap worn by w-corp."
	icon_state = "what"
	perma = TRUE

/obj/item/clothing/suit/armor/ego_gear/wcorp/noreq
	attribute_requirements = list()
	equip_slowdown = 0
