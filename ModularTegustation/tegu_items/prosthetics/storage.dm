/obj/item/organ/cyberimp/arm/briefcase
	name = "briefcase implant"
	desc = "A retractable briefcase!"
	contents = newlist(/obj/item/storage/briefcase)
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/generic.dmi'
	icon_state = "briefcase"

/obj/item/organ/cyberimp/arm/briefcase/Extend(obj/item/item)
	..()
	//little bit of stam loss
	owner.adjustStaminaLoss(owner.maxHealth*0.5, TRUE, TRUE)

/obj/item/organ/cyberimp/arm/briefcase/l
	zone = BODY_ZONE_L_ARM
