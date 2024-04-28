//Reduce limb damage to increase chances of wounds.
/obj/item/bodypart/chest/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 500

/obj/item/bodypart/r_arm/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

/obj/item/bodypart/l_arm/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

/obj/item/bodypart/r_leg/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

/obj/item/bodypart/l_leg/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		max_damage = 50

//Abnormalities have no name here. And we don't want nonsentient ones to breach
/mob/living/simple_animal/hostile/abnormality/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		name = "Limbus Company Specimen"
		faction = list("neutral")

//To avoid other issues when possessed

/mob/living/simple_animal/hostile/abnormality/Login()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		if(!src == /mob/living/simple_animal/hostile/abnormality/hatred_queen)
			faction = list("hostile")

/mob/living/simple_animal/hostile/abnormality/Logout()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		faction = list("neutral")

//Torso Fabricator is free for this mode, but 100 ahn for an organic body.
/obj/machinery/body_fabricator/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		prosthetic_cost = 0
		organic_cost = 100
