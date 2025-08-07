
//Just faster XP
/obj/item/tresmetal/copper
	name = "ingot of copper"
	desc = "A simple copper ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_GREEN
	heated_type = /obj/item/hot_tresmetal/copper

/obj/item/hot_tresmetal/copper
	matname = "copper"
	force_bonus = -2
	max_lv = 7
	xp_requirements = 40
	original_mat = /obj/item/tresmetal/copper


//Worse all around, but much faster XP gain and a higher level
/obj/item/tresmetal/goldsteel
	name = "ingot of goldsteel"
	desc = "A simple goldsteel ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_YELLOW
	heated_type = /obj/item/hot_tresmetal/goldsteel

/obj/item/hot_tresmetal/goldsteel
	matname = "goldsteel"
	force_mod = 0.9
	xp_requirements = 25
	max_lv = 10
	original_mat = /obj/item/tresmetal/goldsteel


//Slower weapons but a higher max level.
/obj/item/tresmetal/silversteel
	name = "ingot of silversteel"
	desc = "A simple silversteel ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_SILVER
	heated_type = /obj/item/hot_tresmetal/silversteel

/obj/item/hot_tresmetal/silversteel
	matname = "silversteel"
	xp_requirements = 35
	original_mat = /obj/item/tresmetal/silversteel


//Less XP and a higher max level.
/obj/item/tresmetal/electrum
	name = "ingot of electrum"
	desc = "A simple electrum ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_VERY_SOFT_YELLOW
	heated_type = /obj/item/hot_tresmetal/electrum

/obj/item/hot_tresmetal/electrum
	matname = "electrum"
	xp_requirements = 60
	max_lv = 7
	original_mat = /obj/item/tresmetal/electrum
