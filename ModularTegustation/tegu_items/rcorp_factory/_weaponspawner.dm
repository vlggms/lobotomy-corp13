//TODO:
//Refactor this. CBA right now - Kirie
/obj/effect/landmark/rcorp_lowweapon
	name = "rcorp requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
		/obj/item/gun/energy/e_gun/rabbitdash/white,
		/obj/item/gun/energy/e_gun/rabbitdash/black,
		/obj/item/gun/energy/e_gun/rabbitdash/small,
	)


/obj/effect/landmark/rcorp_lowweapon/Initialize()
	. = ..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	qdel(src)

/obj/effect/landmark/rcorp_midweapon
	name = "rcorp requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
		/obj/item/gun/energy/e_gun/rabbitdash/shotgun,
		/obj/item/gun/energy/e_gun/rabbitdash/pale,
		/obj/item/gun/energy/e_gun/rabbitdash/sniper,
	)


/obj/effect/landmark/rcorp_midweapon/Initialize()
	..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	qdel(src)


/obj/effect/landmark/rcorp_highweapon
	name = "rcorp requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
		/obj/item/gun/energy/e_gun/rabbit/minigun,
		/obj/item/gun/energy/e_gun/rabbitdash/heavy,
		/obj/item/gun/energy/e_gun/rabbitdash/heavysniper,
	)


/obj/effect/landmark/rcorp_highweapon/Initialize()
	..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	qdel(src)


/obj/effect/landmark/rcorp_meleeweapons
	name = "rcorp requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
		/obj/item/ego_weapon/city/rabbit,
		/obj/item/ego_weapon/city/rabbit/white,
		/obj/item/ego_weapon/city/rabbit/black,
		/obj/item/ego_weapon/city/rabbit/pale,
	)


/obj/effect/landmark/rcorp_meleeweapons/Initialize()
	..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	qdel(src)


/obj/effect/landmark/rcorp_pistol
	name = "rcorp requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
		/obj/item/gun/energy/e_gun/rabbitdash/small,
		/obj/item/gun/energy/e_gun/rabbitdash/small/white,
		/obj/item/gun/energy/e_gun/rabbitdash/small/black
	)


/obj/effect/landmark/rcorp_pistol/Initialize()
	..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	qdel(src)


