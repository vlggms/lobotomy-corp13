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

/// Thumb East's propellant ammo box for Thumb Crate. 9x basic propellant and 6x tigermark. These should be the /facility versions so they don't get status effects.
/obj/item/storage/box/thumb_east_ammo
	name = "thumb east surplus ammo box"
	desc = "A small, worn box of propellant ammunition that can be loaded into Thumb East weaponry. Judging by its condition... not a very high quality batch of rounds - probably used for training."
	icon = 'ModularTegustation/Teguicons/thumb_east_obj.dmi'
	icon_state = "thumb_east_box_surplus"
	/// You can't put these boxes in your backpack.
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/box/thumb_east_ammo/PopulateContents()
	// I could put these both in the same for loop but I want them to be in order.
	for(var/i = 1 to 9)
		new /obj/item/stack/thumb_east_ammo/facility(src)
	for(var/i = 1 to 6)
		new /obj/item/stack/thumb_east_ammo/tigermark/facility(src)

/// This override is so we can make the boxes look emptied when they're... empty. This proc gets called on the box by the storage component when we take stuff out of it.
/obj/item/storage/box/thumb_east_ammo/update_icon()
	if(!length(contents))
		icon_state = initial(icon_state) + "_empty"
	. = ..()

/// One of the two boxes Thumb East has access to in CoL. 6x Scorch Propellant. Can be used in any Thumb East weapon.
/obj/item/storage/box/thumb_east_ammo/scorch
	name = "scorch propellant ammo box (x6)"
	desc = "A small box containing six scorch propellant rounds. These can be loaded into Thumb East weaponry, enabling their special techniques and allowing them to inflict Burn and Tremor."
	icon_state = "thumb_east_box_scorch"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/box/thumb_east_ammo/scorch/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/stack/thumb_east_ammo(src)

/// One of the two boxes Thumb East has access to in CoL. 6x Tigermark. More expensive, only fits in Podaos.
/obj/item/storage/box/thumb_east_ammo/tigermark
	name = "tigermark ammo box (x6)"
	desc = "A small, fancy box containing six tigermark rounds. These can be loaded into a Thumb East Podao, enabling its special techniques and allowing it to inflict Burn and Tremor.\n"+\
	"But do you really need to? Isn't it overkill? There's so much gunpowder loaded into these that they also expand the area-of-effect on its attacks. Try to keep open flames away from these...?"
	icon_state = "thumb_east_box_tigermark"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/box/thumb_east_ammo/tigermark/PopulateContents()
	for(var/i = 1 to 6)
		new /obj/item/stack/thumb_east_ammo/tigermark(src)
