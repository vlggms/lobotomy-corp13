//Split into weapons and not weapons.
/obj/effect/landmark/rcorpitemspawn
	name = "spawner for rcrop"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
	/obj/item/storage/firstaid/revival,
	/obj/item/powered_gadget/handheld_taser,
	/obj/item/reagent_containers/hypospray/medipen/salacid,
	/obj/item/reagent_containers/hypospray/medipen/mental,
	/obj/item/stack/sheet/mineral/sandbags,
	)
	var/list/possible_weapons = list(
	/obj/item/gun/energy/e_gun/rabbitdash,
	/obj/item/gun/energy/e_gun/rabbitdash/small,
	/obj/item/gun/energy/e_gun/rabbitdash/sniper,
	/obj/item/gun/energy/e_gun/rabbitdash/white,)


/obj/effect/landmark/rcorpitemspawn/Initialize()
	..()
	var/spawning = pick(possible_items)
	if(prob(30))
		spawning = pick(possible_weapons)
	new spawning(get_turf(src))
	var/timeradd = rand(1200, 3000)
	addtimer(CALLBACK(src, .proc/spawnagain), timeradd)

/obj/effect/landmark/rcorpitemspawn/proc/spawnagain()
	var/timeradd = rand(1200, 3000)
	addtimer(CALLBACK(src, .proc/spawnagain), timeradd)

	if(prob(80))	//20% to spawn
		return

	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
