//Rcorp garbo
/obj/item/clothing/suit/armor/ego_gear/rabbit
	name = "\improper rabbit team command suit"
	desc = "An armored combat suit worn by R-Corporation 4th pack infantry commanders. The orange cloak denotes the rank of 'Captain', as a beacon for the infantry to follow."
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
	name = "\improper rabbit suppressive suit"
	desc = "An armored combat suit worn by R-Corporation light infantry shocktroopers. It's cape is long, but the material catches shrapnel well."
	icon_state = "rabbit_grunt"

/obj/item/clothing/suit/armor/ego_gear/rabbit/assault
	name = "\improper rabbit assault suit"
	desc = "An armored combat suit worn by R-Corporation light infantry units. Mostly used by the junior and expendable swift assault units, but rarely seen elsewhere."
	icon_state = "rabbit_ass"

//Ravens
/obj/item/clothing/suit/armor/ego_gear/rabbit/raven
	name = "\improper raven scout suit"
	desc = "An armored combat suit worn by R-Corporation forwards reconnaissance units. The large cloak helps break up the human form among the dark environments."
	icon_state = "raven_scout"

/obj/item/clothing/suit/armor/ego_gear/rabbit/ravensup
	name = "\improper raven support suit"
	desc = "An armored combat suit worn by R-Corporation intelligence support units. It's many pockets hold various intelligence gathering equipment."
	icon_state = "raven_support"

/obj/item/clothing/suit/armor/ego_gear/rabbit/ravencap
	name = "\improper raven team command suit"
	desc = "An armored combat suit worn by R-Corporation intelligence division captains. The orange armband and shoulder pad denote the rank of 'Captain'."
	icon_state = "raven_captain"

//Reindeer
/obj/item/clothing/suit/armor/ego_gear/rabbit/reindeermed
	name = "\improper reindeer medical suit"
	desc = "An armored combat suit worn by R-Corporation medical reindeer. \
		Extremely rarely seen as a relic of a previous time, the handful of medical reindeer units remaining are reserved for long range missions where sending fresh units is infeasable. \
		The medical reindeer divisons were mostly phased out due to their mental and physical ineptitude, often ending in explosive results minutes after an operation begins."
	icon_state = "reindeer_medic"

/obj/item/clothing/suit/armor/ego_gear/rabbit/reindeerberserk
	name = "\improper reindeer berserker suit"
	desc = "An armored combat suit worn by R-Corporation offensive support units. Well armored, as berserker reindeer are often mentally unstable. \
		This suit was designed to protect the user from others as well as themselves"
	icon_state = "reindeer_berserk"

/obj/item/clothing/suit/armor/ego_gear/rabbit/reindeercap
	name = "\improper reindeer team command suit"
	desc = "An armored combat suit worn by the R-Corporation support divison captain. The orange shoulderpad denotes the rank of 'Captain' "
	icon_state = "reindeer_captain"


