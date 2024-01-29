/* LoR13 Lootspawners
	Dependant on the spawners lootdrop.dm and any file the contents may belong in. */
/obj/effect/spawner/lootdrop/chaotic_random
	name = "chaotic random"
	lootcount = 3
	lootdoubles = TRUE
	/* Uses pickweight chances. Higher is more likely. May change this later on
		because due to the nature of pickweight. If you had one item that had 1000 chance
		and one item with 100 chance you would have a 1/11 chance of getting the rarer item.
		if you had 3 of the 1000 chance items that would then become a 1/31 chance since the
		total is the max amount of chances... */
	loot = list(
			//Medical
		/obj/item/stack/medical/aloe = 1,
		/obj/item/stack/medical/suture/emergency = 1,
		/obj/item/stack/medical/suture = 1,
			//Money
		/obj/item/storage/wallet/random = 1,
		/obj/item/stack/spacecash/c1 = 1,
			//Misc
		/obj/item/organ/liver/fly = 1,
		/obj/item/storage/book = 1,
		/obj/item/lipstick/random = 1,
		/obj/item/kitchen/knife/shiv = 1,
		/obj/item/toy/plush/lizardplushie = 1,
		/obj/item/toy/plush/blank = 1,
		/obj/item/bedsheet/dorms = 1,
			//Food
		/obj/item/food/deadmouse = 1,
		/obj/item/food/egg = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/honeybar = 1,
		/obj/item/food/soup/stew = 1,
		/obj/item/food/chewable/gumball = 1,
		/obj/item/food/branrequests = 1,
		/obj/item/food/tinychocolate = 1,
		/obj/item/food/canned/peaches = 1,
		/obj/item/food/canned/beans = 1,
		/obj/item/storage/cans/sixsoda = 1,
		/obj/item/storage/cans/sixbeer = 1,
		/obj/item/food/candy = 1,
		)

//Pseudo Group Spawners
/obj/effect/spawner/scatter/shrimp
	name = "shrimp squad spawn"
	max_spawns = 5
	loot_table = list(/mob/living/simple_animal/hostile/shrimp = 1,
					/mob/living/simple_animal/hostile/shrimp_soldier = 1)

// Dependant on step_triggers.dm
/obj/effect/step_trigger/place_atom
	mobs_only = TRUE
	//If we only trigger on creatures that have a C.key
	var/ckey_only = FALSE
	/* In the map editor just copy paste the type path of the thing.
		If you edit the atom_path variable in the map editor then
		If anything happens to that mob code you will need to change it
		in the map editor.*/
	var/atom_path
	var/atom_rename
	var/spawn_flavor_text
	var/happens_once = TRUE
	//Cords are offset from current position.
	var/spawn_dist_x = 0
	var/spawn_dist_y = 0

/obj/effect/step_trigger/place_atom/Trigger(atom/movable/A)
	//This code might be a bit sloppy. -IP
	if(ismob(A))
		var/mob/M = A
		if(ckey_only && !M.client)
			return

	//Remotely finds the turf where we spawn the thing.
	var/checkturf = get_turf(locate(x + spawn_dist_x, y + spawn_dist_y, z))
	if(checkturf)
		CreateThing(checkturf)
		if(happens_once)
			qdel(src)

/obj/effect/step_trigger/place_atom/proc/CreateThing(turf/T)
	if(atom_path)
		var/atom/movable/M = new atom_path(T)
		//The thing has somehow failed to spawn.
		if(!M)
			return
		//TECHNICALLY you could spawn a single turf with this? -IP
		if(atom_rename && !iseffect(M))
			M.name = atom_rename
		if(spawn_flavor_text)
			M.visible_message(span_danger("[M] [spawn_flavor_text]."))
		return M
