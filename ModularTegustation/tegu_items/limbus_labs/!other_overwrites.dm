//Reduce limb damage to increase chances of wounds.
/obj/item/bodypart/chest/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 500

/obj/item/bodypart/r_arm/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

/obj/item/bodypart/l_arm/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

/obj/item/bodypart/r_leg/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

/obj/item/bodypart/l_leg/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

//Abnormalities have no name here.
/mob/living/simple_animal/hostile/abnormality/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		name = "Limbus Company Specimen"

