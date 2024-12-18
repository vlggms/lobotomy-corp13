/obj/item/organ/cyberimp/arm/fixertools
	name = "fixer tools implant"
	desc = "A variety of important fixer tools is stored here. A flashlight, crowbar and hunting knife is included."
	contents = newlist(/obj/item/flashlight/seclite, /obj/item/crowbar, /obj/item/kitchen/knife/combat/survival, /obj/item/pda)

/obj/item/organ/cyberimp/arm/fixertools/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/fixertools/Extend(obj/item/item)
	..()
	//little bit of stam loss
	owner.adjustStaminaLoss(owner.maxHealth*0.3, TRUE, TRUE)

