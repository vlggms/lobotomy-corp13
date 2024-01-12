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

//Officer stuff
/obj/item/clothing/suit/armor/ego_gear/rabbit/officer
	name = "\improper r corp officer vest"
	desc = "A light armor vest worn by r corp officers."
	icon_state = "rcorp_officer"
	flags_inv = null

/obj/item/clothing/suit/armor/ego_gear/rabbit/assaultofficer
	name = "\improper lcdr's officer vest"
	desc = "A light armor vest worn by r corp senior officers."
	icon_state = "lcdr_armor"
	flags_inv = null

//non-armor
/obj/item/clothing/suit/armor/ego_gear/rcorp_officer
	name = "\improper r corp lcdr's dress outfit"
	desc = "A jacket worn by senior r-corp officers."
	icon_state = "rcorp_lcdrdress"
	flags_inv = null

/obj/item/clothing/suit/armor/ego_gear/rcorp_officer/cdr
	name = "\improper r corp cdr's dress outfit"
	desc = "A jacket worn by senior r-corp officers."
	icon_state = "rcorp_cdrdress"

//Fifth Pack
/obj/item/clothing/suit/armor/ego_gear/rabbit/raccoon
	name = "\improper raccoon suit"
	desc = "An armored combat suit worn by R-Corporation forwards reconnaissance units."
	icon_state = "raccoon_armor"

/obj/item/clothing/suit/armor/ego_gear/rabbit/raccooncap
	name = "\improper raccoon leader suit"
	desc = "An armored combat suit worn by R-Corporation forwards reconnaissance units. The large cloak helps break up the human form among the dark environments."
	icon_state = "raccoon_captain"

/obj/item/clothing/suit/armor/ego_gear/rabbit/roadrunner
	name = "\improper roadrunner suit"
	desc = "An armored combat suit worn by R-Corporation skirmishers."
	icon_state = "roadrunner"
	slowdown = -0.25

/obj/item/clothing/suit/armor/ego_gear/rabbit/roadrunnercap
	name = "\improper roadrunner captain suit"
	desc = "An armored combat suit worn by R-Corporation skirmishers."
	icon_state = "roadrunner_captain"
	slowdown = -0.25

/obj/item/clothing/suit/armor/ego_gear/rabbit/rat
	name = "\improper rat suit"
	desc = "An armored combat suit worn by R-Corporation skirmishers."
	icon_state = "rat"

//Rabbit specific NVs that break on removal
/obj/item/clothing/glasses/night/rabbit
	desc = "These goggles let you see in the dark perfectly. Sadly they're quite delicate, trying to remove them now will break them for sure."

/obj/item/clothing/glasses/night/rabbit/Destroy()
	dropped()
	return ..()

/obj/item/clothing/glasses/night/rabbit/equipped(mob/user, slot)
	if(slot != ITEM_SLOT_EYES)
		Destroy()
		to_chat(user, span_warning("The goggles crack and break apart as you take it off. You feel very stupid now."))
		return
	. = ..()

/obj/item/clothing/glasses/hud/health/night/rabbit
	desc = "An advanced medical heads up display that comes with night vision. Sadly they're quite delicate, trying to remove them now will break them for sure."

/obj/item/clothing/glasses/hud/health/night/rabbit/Destroy()
	dropped()
	return ..()

/obj/item/clothing/glasses/hud/health/night/rabbit/equipped(mob/user, slot)
	if(slot != ITEM_SLOT_EYES)
		Destroy()
		to_chat(user, span_warning("The goggles crack and break apart as you take it off. You feel very stupid now."))
		return
	. = ..()
