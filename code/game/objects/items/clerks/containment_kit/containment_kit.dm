//Containment Kit!
//Works simular to the Safty Kits but for containment units.
//If a meltdown is accouring, will give more time.
//Otherwise completely unuseable!

/obj/item/containment_kit
	name = "Qliphoth Unitily Abnormality Containment Kit"
	desc = "Q.U.A.C.K for short, this one time use kit allows a containment unit to meltdown for longer or restore a qliphoth!"
	icon = 'icons/obj/tools.dmi'
	icon_state = "quack"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/crowbar.ogg'
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("attacks", "bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("attack", "bash", "batter", "bludgeon", "whack")
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	var/meltdowntimer_increase = 20

//Better verson gives another 60 seconds to rush over and deal with this
/obj/item/containment_kit/long_increase
	meltdowntimer_increase = 60

/obj/item/containment_kit/attack_self(mob/user)
	if(!clerk_check(user))
		to_chat(user,"<span class='warning'>You don't know how to use this.</span>")
		return
	return

/obj/item/containment_kit/examine(mob/user)
	. = ..()
	. += "Is currently set to increase a containment units meltdown timer by [meltdowntimer_increase]."

/obj/item/containment_kit/proc/clerk_check(mob/living/carbon/human/H)
	if(istype(H) && (H?.mind?.assigned_role == "Clerk"))
		return TRUE
	return FALSE


