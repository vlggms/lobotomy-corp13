/obj/item/armorplate
	name = "Armor plate"
	desc = "An armor plate, attach to a plain fixer suit to increase it's power. Upgrades are at 3, 8 and 15 armor plates."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "plate"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/suit/armor/ego_gear/city/misc
	name = "fixer suit"
	desc = "A standard suit tailed for the city."
	icon_state = "uniqueoffice"
	icon = 'icons/obj/clothing/ego_gear/custom_fixer.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/custom_fixer.dmi'
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 0)
	var/upgrade_level
	var/plates

/obj/item/clothing/suit/armor/ego_gear/city/misc/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/armorplate))
		if(plates>=15)
			to_chat(user, "<span class='notice'>Your armor is full on plates.</span>")
			return
		plates++
		to_chat(user, "<span class='notice'>You attach an armor plate to your armor.</span>")
		switch(plates)
			if(3)
				armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 0)
				to_chat(user, "<span class='danger'>Your armor is now stronger.</span>")
			if(8)
				armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 10)
				to_chat(user, "<span class='danger'>Your armor is now stronger.</span>")
			if(15)
				armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 10)
				to_chat(user, "<span class='danger'>Your armor is now stronger.</span>")
		qdel(I)


/obj/item/clothing/suit/armor/ego_gear/city/misc/second
	name = "fixer black suit"
	icon_state = "uniqueoffice2"

/obj/item/clothing/suit/armor/ego_gear/city/misc/third
	name = "fixer plate armor"
	icon_state = "uniqueoffice3"

/obj/item/clothing/suit/armor/ego_gear/city/misc/fourth
	name = "fixer kimono"
	icon_state = "uniqueoffice4"

/obj/item/clothing/suit/armor/ego_gear/city/misc/fifth
	name = "fixer long jacket"
	icon_state = "uniqueoffice5"

/obj/item/clothing/suit/armor/ego_gear/city/misc/sixth
	name = "fixer armored turtleneck"
	icon_state = "uniqueoffice6"

/obj/item/clothing/suit/armor/ego_gear/city/misc/lone
	name = "fixer armored jacket"
	icon_state = "fixerlone"
