//These materials have no XP gain.
/obj/item/tresmetal/puremetal
	name = "ingot of puremetal"
	desc = "A simple puremetal ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_VERY_LIGHT_GRAY
	heated_type = /obj/item/hot_tresmetal/puremetal

/obj/item/hot_tresmetal/puremetal
	matname = "puremetal"
	force_mod = 1.7
	xp_requirements = 999
	max_lv = 1
	original_mat = /obj/item/tresmetal/puremetal


//No XP gain, but gains a massive damage bonus
/obj/item/tresmetal/pinksteel
	name = "ingot of pinksteel"
	desc = "A simple pinksteel ingot, usable in a forge."
	icon_state = "ingot_grayscale"
	quality = 1
	color = COLOR_PINK
	heated_type = /obj/item/hot_tresmetal/pinksteel

/obj/item/hot_tresmetal/pinksteel
	matname = "pinksteel"
	force_bonus = 20
	xp_requirements = 999
	max_lv = 1
	original_mat = /obj/item/tresmetal/pinksteel
