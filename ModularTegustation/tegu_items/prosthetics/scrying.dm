/obj/item/organ/cyberimp/arm/observation
	name = "obvservation implant"
	desc = "A device that lets you oversee the surrounding area."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/generic.dmi'
	icon_state = "investigation"
	contents = newlist(/obj/item/scrying/observation)
	custom_premium_price = 3600

/obj/item/organ/cyberimp/arm/observation/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/observation/Extend(obj/item/item)
	..()
	//little bit of stam loss
	owner.adjustStaminaLoss(owner.maxHealth*0.5, TRUE, TRUE)


/obj/item/scrying/observation
	name = "observation system"
	desc = "A way to see what cannot be seen."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/generic.dmi'
	icon_state = "investigation"
