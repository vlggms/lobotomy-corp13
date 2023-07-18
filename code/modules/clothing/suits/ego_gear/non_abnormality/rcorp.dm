//Rcorp garbo
/obj/item/clothing/suit/armor/ego_gear/rabbit
	name = "\improper rabbit team command suit"
	desc = "An armored combat suit worn by R-Corporation mercenaries in the field, interestingly"
	icon_state = "rabbit"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 50)
	equip_slowdown = 0
	var/list/banned_roles = list("Ground Commander", "Lieutenant Commander")

/obj/item/clothing/suit/armor/ego_gear/rabbit/CanUseEgo(mob/living/carbon/human/user)
	if(user.mind)
		if(user.mind.assigned_role in banned_roles) //So command stays drippin out of control.
			to_chat(user, "<span class='notice'>This is for the masses. You are better than this.</span>")
			return FALSE
	return TRUE

/obj/item/clothing/suit/armor/ego_gear/rabbit/grunts
	name = "\improper rabbit team suit"
	desc = "An armored combat suit worn by R-Corporation mercenaries in the field"
	icon_state = "rabbit_grunt"

/obj/item/clothing/suit/armor/ego_gear/rabbit/assault
	name = "\improper rabbit assault suit"
	desc = "An armored combat suit worn by R-Corporation mercenaries in the field"
	icon_state = "rabbit_grunt"

/obj/item/clothing/suit/armor/ego_gear/rabbit/raven
	name = "\improper raven scout suit"
	desc = "An armored combat suit worn by R-Corporation mercenaries in the field"
	icon_state = "raven_scout"

/obj/item/clothing/suit/armor/ego_gear/rabbit/ravencap
	name = "\improper raven team command suit"
	desc = "An armored combat suit worn by R-Corporation mercenaries in the field, interestingly"
	icon_state = "raven_captain"
