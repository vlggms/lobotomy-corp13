//Lower force mod but big Bonus, and higher XP requirements
/obj/item/tresmetal/steel
	name = "ingot of steel"
	desc = "A simple steel ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_GRAY
	heated_type = /obj/item/hot_tresmetal/steel

/obj/item/hot_tresmetal/steel
	matname = "steel"
	force_bonus = 8
	xp_requirements = 70
	original_mat = /obj/item/tresmetal/steel


//Faster, but with less force.
/obj/item/tresmetal/cobalt
	name = "ingot of cobalt"
	desc = "A simple cobalt ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_BLUE
	heated_type = /obj/item/hot_tresmetal/cobalt

/obj/item/hot_tresmetal/cobalt
	matname = "cobalt"
	force_mod = 0.88
	attack_mult = 0.7
	original_mat = /obj/item/tresmetal/cobalt


//Gives you a damage bonus for a slower attack.
/obj/item/tresmetal/bloodiron
	name = "ingot of bloodiron"
	desc = "A simple bloodiron ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_RED
	heated_type = /obj/item/hot_tresmetal/bloodiron

/obj/item/hot_tresmetal/bloodiron
	matname = "bloodiron"
	force_bonus = 10
	attack_mult = 1.2
	original_mat = /obj/item/tresmetal/bloodiron



//Slower XP gain and lower level cap but higher stats
/obj/item/tresmetal/darksteel
	name = "ingot of darksteel"
	desc = "A simple darksteel ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_ALMOST_BLACK
	heated_type = /obj/item/hot_tresmetal/darksteel

/obj/item/hot_tresmetal/darksteel
	matname = "darksteel"
	force_mod = 1.2
	xp_requirements = 60
	max_lv = 3
	original_mat = /obj/item/tresmetal/darksteel
