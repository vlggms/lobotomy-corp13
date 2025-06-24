//Lower force mod but big Bonus, and higher XP requirements
/obj/item/tresmetal/steel
	name = "ingot of steel"
	desc = "A simple steel ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_GREY
	heated_type = /obj/item/hot_tresmetal/steel

/obj/item/hot_tresmetal/steel
	matname = "steel"
	force_bonus = 10
	xp_requirements = 70
	original_mat = /obj/item/tresmetal/steel


//Faster, but with less force.
/obj/item/tresmetal/cobalt
	name = "ingot of cobalt"
	desc = "A simple cobalt ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_BLUE
	heated_type = /obj/item/hot_tresmetal/cobalt

/obj/item/hot_tresmetal/cobalt
	matname = "cobalt"
	force_mod = 0.88
	attack_mult = 0.7
	original_mat = /obj/item/tresmetal/cobalt


//Lower stats but a bit more XP
/obj/item/tresmetal/copper
	name = "ingot of copper"
	desc = "A simple copper ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_GREEN
	heated_type = /obj/item/hot_tresmetal/copper

/obj/item/hot_tresmetal/copper
	matname = "copper"
	force_mod = 0.9
	xp_requirements = 35
	original_mat = /obj/item/tresmetal/copper


//Worse all around, but much faster XP gain and a higher level
/obj/item/tresmetal/gold
	name = "ingot of gold"
	desc = "A simple gold ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_YELLOW
	heated_type = /obj/item/hot_tresmetal/gold

/obj/item/hot_tresmetal/gold
	matname = "gold"
	force_mod = 0.75
	xp_requirements = 25
	max_lv = 7
	original_mat = /obj/item/tresmetal/gold


//Slower XP gain and lower level cap but higher stats
/obj/item/tresmetal/darksteel
	name = "ingot of darksteel"
	desc = "A simple darksteel ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_ALMOST_BLACK
	heated_type = /obj/item/hot_tresmetal/darksteel

/obj/item/hot_tresmetal/darksteel
	matname = "darksteel"
	force_mod = 1.2
	xp_requirements = 80
	max_lv = 4
	original_mat = /obj/item/tresmetal/darksteel


//No XP gain, but gains a massive mult.
/obj/item/tresmetal/puremetal
	name = "ingot of puremetal"
	desc = "A simple puremetal ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_VERY_LIGHT_GRAY
	heated_type = /obj/item/hot_tresmetal/puremetal

/obj/item/hot_tresmetal/puremetal
	matname = "darksteel"
	force_mod = 1.4
	xp_requirements = 999
	max_lv = 1
	original_mat = /obj/item/tresmetal/puremetal


//Slower weapons but a higher max level.
/obj/item/tresmetal/silver
	name = "ingot of silver"
	desc = "A simple slver ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_SILVER
	heated_type = /obj/item/hot_tresmetal/silver

/obj/item/hot_tresmetal/silver
	matname = "silver"
	attack_mult = 1.1
	max_lv = 7
	original_mat = /obj/item/tresmetal/silver


//Less XP and a higher max level.
/obj/item/tresmetal/electrum
	name = "ingot of electrum"
	desc = "A simple electrum ingot."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_VERY_SOFT_YELLOW
	heated_type = /obj/item/hot_tresmetal/electrum

/obj/item/hot_tresmetal/electrum
	matname = "silver"
	xp_requirements = 80
	max_lv = 7
	original_mat = /obj/item/tresmetal/electrum
