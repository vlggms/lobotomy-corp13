/obj/item/organ/cyberimp/arm/overdrive
	name = "overdrive implant"
	desc = "An implant that deals toxin damage on extention and retraction, but increases your movement speed."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/generic.dmi'
	icon_state = "overdrive"
	contents = newlist(/obj/item/overdrive)

/obj/item/organ/cyberimp/arm/overdrive/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/overdrive/Extend(obj/item/item)
	..()
	//little bit of stam loss
	owner.adjustToxLoss(owner.maxHealth*0.25, TRUE, TRUE)

	owner.add_movespeed_modifier(/datum/movespeed_modifier/overdrive)
	addtimer(CALLBACK(src, PROC_REF(Retract)), 10 SECONDS)

/datum/movespeed_modifier/overdrive
	variable = TRUE
	multiplicative_slowdown = -0.5

/obj/item/organ/cyberimp/arm/overdrive/Retract()
	..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/overdrive)


//Just a dummy item.
/obj/item/overdrive
	name = "overdrive system"
	desc = "A core that increases your movement speed."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/generic.dmi'
	icon_state = "overdrive"

