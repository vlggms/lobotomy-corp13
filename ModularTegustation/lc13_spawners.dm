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
		/obj/item/reagent_containers/medigel/sterilizine = 1,
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
		/obj/item/reagent_containers/glass/beaker/jar/pudding = 1,
		/obj/item/reagent_containers/glass/beaker/jar/syrup_random = 1,
		)

/obj/effect/spawner/lootdrop/medical_random
	name = "medical random"
	lootcount = 3
	lootdoubles = TRUE
	loot = list(
		/obj/item/stack/medical/aloe = 1,
		/obj/item/stack/medical/suture/emergency = 1,
		/obj/item/stack/medical/suture = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		)

/obj/effect/spawner/lootdrop/misc_random
	name = "misc random"
	lootcount = 1
	lootdoubles = TRUE
	loot = list(
		/obj/item/organ/liver/fly = 1,
		/obj/item/storage/book = 1,
		/obj/item/lipstick/random = 1,
		/obj/item/kitchen/knife/shiv = 1,
		/obj/item/toy/plush/lizardplushie = 1,
		/obj/item/toy/plush/blank = 1,
		/obj/item/bedsheet/dorms = 1,
		)

/obj/effect/spawner/lootdrop/food_random
	name = "food random"
	lootcount = 3
	lootdoubles = TRUE
	loot = list(
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
		/obj/item/reagent_containers/glass/beaker/jar/pudding = 1,
		/obj/item/reagent_containers/glass/beaker/jar/syrup_random = 1,
		)

/obj/effect/spawner/lootdrop/workshop_random
	name = "chaotic random"
	lootcount = 3
	lootdoubles = TRUE
	loot = list(
		// 1 out of 5 chance of weird ingots
		/obj/item/tresmetal = 30,
		/obj/item/tresmetal/human = 1,
		/obj/item/tresmetal/amber = 1,
		/obj/item/tresmetal/crimson = 1,
		/obj/item/tresmetal/green = 1,
		/obj/item/tresmetal/violet = 1,
		/obj/item/tresmetal/indigo = 1
		)

///This spawner scatters the spawned stuff around where it is placed.
/obj/effect/spawner/mobspawner
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "xeno_spawn"
	///determines how many things to scatter
	var/max_spawns = 3
	///determines how big of a range we should scatter things in.
	var/radius = 1
	///This weighted list acts as the loot table for the spawner
	var/list/mobspawn_table


/obj/effect/spawner/mobspawner/Initialize()
	..()
	if(!length(mobspawn_table))
		return INITIALIZE_HINT_QDEL

	var/list/candidate_locations = ReturnPlacementTurfs()

	if(!length(candidate_locations))
		return INITIALIZE_HINT_QDEL

	PlaceMobs(candidate_locations)

	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/mobspawner/proc/ReturnPlacementTurfs()
	. = list()
	for(var/turf/turf_in_view in view(radius, get_turf(src)))
		if(turf_in_view.density)
			continue
		if(locate(/obj/machinery/door) in turf_in_view)
			continue
		var/bad_turf = FALSE
		for(var/obj/O in turf_in_view)
			if(O.density)
				bad_turf = TRUE
				break
		if(!bad_turf)
			. += turf_in_view

/obj/effect/spawner/mobspawner/proc/PlaceMobs(list/places_to_place)
	for(var/i = 1 to max_spawns)
		if(!places_to_place.len)
			break
		var/turf/place_to_spawn = pick_n_take(places_to_place)
		var/spawned_thing = pickweight(mobspawn_table)
		SpawnMob(spawned_thing, place_to_spawn)

/obj/effect/spawner/mobspawner/proc/SpawnMob(type, turf/spawn_turf)
	var/mob/living/L = new type(spawn_turf)
	if(ishostile(L))
		var/mob/living/simple_animal/hostile/H = L
		H.wander = FALSE

//Pseudo Group Spawners
	//Amber Worms
/obj/effect/spawner/mobspawner/amber_dawn
	name = "amber swarm spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/amber_bug = 1)

	//Green Bots
/obj/effect/spawner/mobspawner/green_dawn
	name = "bot package spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/green_bot = 1)

/obj/effect/spawner/mobspawner/green_noon
	name = "big bot package spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/green_bot_big = 1)

	//Indigo Sweepers
/obj/effect/spawner/mobspawner/indigo_dawn
	name = "sweeper scout pack spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/indigo_dawn = 1)

/obj/effect/spawner/mobspawner/indigo_noon
	name = "sweeper pack spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon = 1)

	//Steel Roaches
/obj/effect/spawner/mobspawner/steel_dawn
	name = "g corp squad spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn = 1)

/obj/effect/spawner/mobspawner/steel_noon
	name = "g corp assault squad spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon = 1)

/obj/effect/spawner/mobspawner/steel_noon_fly
	name = "g corp air assault squad spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 1)

/obj/effect/spawner/mobspawner/steel_dusk_squad
	name = "g corp squad spawn"
	max_spawns = 5
	mobspawn_table = list(
		/mob/living/simple_animal/hostile/ordeal/steel_dawn = 7,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon = 2,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 1,
		)

	//Shrimp
/obj/effect/spawner/mobspawner/shrimp
	name = "shrimp squad spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/shrimp = 4,
					/mob/living/simple_animal/hostile/shrimp_soldier = 1)

/obj/effect/spawner/mobspawner/shrimp_melee
	name = "fishin shrimp squad spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/shrimp = 1)

/obj/effect/spawner/mobspawner/shrimp_ranged
	name = "shrimp soldier squad spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/shrimp_soldier = 1)

	//Backstreet Humanoids
/obj/effect/spawner/mobspawner/rat
	name = "rat syndicate spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/humanoid/rat = 1)

/obj/effect/spawner/mobspawner/rat_elite
	name = "rat elite spawn"
	max_spawns = 1
	mobspawn_table = list(
		/mob/living/simple_animal/hostile/humanoid/rat/knife = 3,
		/mob/living/simple_animal/hostile/humanoid/rat/pipe = 3,
		/mob/living/simple_animal/hostile/humanoid/rat/hammer = 3,
		/mob/living/simple_animal/hostile/humanoid/rat/zippy = 1)

/obj/effect/spawner/mobspawner/rat_random
	name = "rat gang spawn"
	max_spawns = 5
	mobspawn_table = list(/mob/living/simple_animal/hostile/humanoid/rat = 6,
		/mob/living/simple_animal/hostile/humanoid/rat/knife = 1,
		/mob/living/simple_animal/hostile/humanoid/rat/pipe = 2,
		/mob/living/simple_animal/hostile/humanoid/rat/hammer = 2,
		/mob/living/simple_animal/hostile/humanoid/rat/zippy = 1)

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
