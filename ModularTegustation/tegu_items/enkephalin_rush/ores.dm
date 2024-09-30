//refer to ores_coins.dm for the base type
//use mining.dmi for icons
/obj/item/stack/ore/ironscrap
	name = "scrap"
	icon_state = "ironscrap"
	inhand_icon_state = "Iron ore"
	singular_name = "iron ore chunk"
	points = 1
	mats_per_unit = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/metal
	mine_experience = 0
	scan_state = "rock_Iron"
	spreadChance = 20
	merge_type = /obj/item/stack/ore/ironscrap

/obj/item/stack/ore/glassrubble
	name = "broken glass"
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	inhand_icon_state = "Glass ore"//TODO: find these
	points = 1
	mats_per_unit = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/glass
	mine_experience = 0
	spreadChance = 20
	merge_type = /obj/item/stack/ore/glassrubble

/obj/item/stack/ore/plastic
	name = "plastic waste"
	icon_state = "plasticscrap"
	inhand_icon_state = "Bananium ore"
	points = 1
	mats_per_unit = list(/datum/material/plastic=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/plastic
	mine_experience = 0
	spreadChance = 20
	merge_type = /obj/item/stack/ore/plastic

/obj/item/stack/ore/plasteel
	name = "X corp scrap alloy"
	icon_state = "Adamantine ore"
	inhand_icon_state = "Adamantine ore"
	points = 15
	mats_per_unit = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT, /datum/material/iron=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/plasteel
	mine_experience = 0
	scan_state = "rock_Plasma"
	spreadChance = 8
	merge_type = /obj/item/stack/ore/plasteel
