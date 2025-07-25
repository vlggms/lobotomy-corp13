//TODO:
//Refactor this. CBA right now - Kirie
/obj/effect/landmark/rcorp
	name = "rcorp requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
		/obj/item/gun/energy/e_gun/rabbitdash/white,
		/obj/item/gun/energy/e_gun/rabbitdash/black,
		/obj/item/gun/energy/e_gun/rabbitdash/small,
	)


/obj/effect/landmark/rcorp/Initialize()
	. = ..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	qdel(src)

/obj/effect/landmark/rcorp/midweapon
	possible_items = list(
		/obj/item/gun/energy/e_gun/rabbitdash/shotgun,
		/obj/item/gun/energy/e_gun/rabbitdash/pale,
		/obj/item/gun/energy/e_gun/rabbitdash/sniper,
	)

/obj/effect/landmark/rcorp/highweapon
	possible_items = list(
		/obj/item/gun/energy/e_gun/rabbit/minigun,
		/obj/item/gun/energy/e_gun/rabbitdash/heavy,
		/obj/item/gun/energy/e_gun/rabbitdash/heavysniper,
	)


/obj/effect/landmark/rcorp/melee
	possible_items = list(
		/obj/item/ego_weapon/city/rabbit,
		/obj/item/ego_weapon/city/rabbit/white,
		/obj/item/ego_weapon/city/rabbit/black,
		/obj/item/ego_weapon/city/rabbit/pale,
	)

/obj/effect/landmark/rcorp/pistol
	possible_items = list(
		/obj/item/gun/energy/e_gun/rabbitdash/small,
		/obj/item/gun/energy/e_gun/rabbitdash/small/white,
		/obj/item/gun/energy/e_gun/rabbitdash/small/black
	)


/obj/effect/landmark/rcorp/grenade
	possible_items = list(
		/obj/item/grenade/r_corp,
		/obj/item/grenade/r_corp/white,
		/obj/item/grenade/r_corp/black,
		/obj/item/grenade/r_corp/pale,
	)


