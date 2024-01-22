// Stores small boxes to be used in the Refinery.


// Rosespanner gears, 6 per
/obj/item/storage/box/rosespanner
	name = "Rosespanner Gears box"
	desc = "A small box containing 6 RED gears from the Rosespanner workshop."

/obj/item/storage/box/rosespanner/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/rosespanner_gear(src)

/obj/item/storage/box/rosespanner/white
	desc = "A small box containing 6 WHITE gears from the Rosespanner workshop."

/obj/item/storage/box/rosespanner/white/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/rosespanner_gear/white(src)

/obj/item/storage/box/rosespanner/black
	desc = "A small box containing 6 BLACK gears from the Rosespanner workshop."

/obj/item/storage/box/rosespanner/black/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/rosespanner_gear/black(src)

/obj/item/storage/box/rosespanner/pale
	desc = "A small box containing 6 PALE gears from the Rosespanner workshop."

/obj/item/storage/box/rosespanner/pale/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/rosespanner_gear/pale(src)

// N-corp boxes
/obj/item/storage/box/ncorp_seals
	name = "Ncorp Seals box"
	desc = "A small box containing 6 RED seals from Nagel Und Hammer."

/obj/item/storage/box/ncorp_seals/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/ego_weapon/city/ncorp_mark(src)

/obj/item/storage/box/ncorp_seals/white
	desc = "A small box containing 6 WHITE seals from Nagel Und Hammer."

/obj/item/storage/box/ncorp_seals/white/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/ego_weapon/city/ncorp_mark/white(src)

/obj/item/storage/box/ncorp_seals/black
	desc = "A small box containing 6 BLACK seals from Nagel Und Hammer."

/obj/item/storage/box/ncorp_seals/black/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/ego_weapon/city/ncorp_mark/black(src)

/obj/item/storage/box/ncorp_seals/pale
	desc = "A small box containing 6 PALE seals from Nagel Und Hammer."

/obj/item/storage/box/ncorp_seals/pale/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/ego_weapon/city/ncorp_mark/pale(src)

// K-corp uniform boxes
/obj/item/storage/box/kcorp_armor
	name = "K-corp L1 Uniform box"
	desc = "A small box issued to K-corp's L1 employees."

/obj/item/storage/box/kcorp_armor/PopulateContents()
	var/loot_list = list(
		/obj/item/clothing/head/ego_hat/helmet/kcorp,
		/obj/item/clothing/head/ego_hat/helmet/kcorp/visor,
	)
	var/loot = pick(loot_list)
	new /obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1(src)
	new loot(src)
