/obj/effect/landmark/cityspawner
	name = "cityspawner landmark"
	icon_state = "x3"

/obj/effect/landmark/cityloot
	name = "cityloot landmark"
	icon_state = "x2"


/obj/effect/bloodpool
	name = "bloodpool"
	desc = "A pool of blood"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "bloodin"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/bloodpool/Initialize()
	. = ..()
	QDEL_IN(src, 10)

/obj/effect/landmark/fixerbase
	name = "fixer base landmark"
	icon_state = "x"

/obj/effect/landmark/syndicatebase
	name = "syndicate base landmark"
	icon_state = "x"

/obj/effect/landmark/distortion
	name = "distortion landmark"
	icon_state = "x"

//Cratespawners
/obj/effect/landmark/cratespawn
	name = "noncorpo cratespawn landmark"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "randomcrate"
	var/list/rngcrates = list(
		/obj/structure/lootcrate/limbus,
		/obj/structure/lootcrate/workshopleaf,
		/obj/structure/lootcrate/workshopallas,
		/obj/structure/lootcrate/workshoprosespanner,
		/obj/structure/lootcrate/backstreets,
		/obj/structure/lootcrate/jcorp,
	)

/obj/effect/landmark/cratespawn/Initialize()
	. = ..()
	var/selected_crate = pick(rngcrates)
	new selected_crate (get_turf(src))

/obj/effect/landmark/cratespawn/corpo
	name = "corporate cratespawn landmark"
	rngcrates = list(
		/obj/structure/lootcrate/k_corp,
		/obj/structure/lootcrate/s_corp,
		/obj/structure/lootcrate/r_corp,
		/obj/structure/lootcrate/w_corp,
	)


//City enemy spawners
//Everything below this is shitcode.
//To-Do: Deshit this
GLOBAL_VAR_INIT(city_west_enemies, FALSE)
GLOBAL_VAR_INIT(city_center_enemies, FALSE)
GLOBAL_VAR_INIT(city_east_enemies, FALSE)

/obj/effect/landmark/backstreetspawn
	name = "cityspawn landmark"
	icon_state = "x"
	var/list/enemytypes = list(
		"gcorp",
		"sweeper",
		"bots",
	)

/obj/effect/landmark/backstreetspawn/Initialize()
	. = ..()
	if(!GLOB.city_center_enemies)
		GLOB.city_center_enemies = pick(enemytypes)
	var/spawning
	switch(GLOB.city_center_enemies)
		if("gcorp")
			spawning = /mob/living/simple_animal/hostile/ordeal/steel_dawn
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon

		if("sweeper")
			spawning = /mob/living/simple_animal/hostile/ordeal/indigo_noon
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/indigo_dawn

		if("bots")
			spawning = /mob/living/simple_animal/hostile/ordeal/green_bot
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/green_bot_big
	new spawning(get_turf(src))




/obj/effect/landmark/backstreetspawnwest
	name = "cityspawn landmark"
	icon_state = "x2"
	var/list/enemytypes = list(
		"gcorp",
		"sweeper",
		"bots",
	)

/obj/effect/landmark/backstreetspawnwest/Initialize()
	. = ..()
	if(!GLOB.city_west_enemies)
		GLOB.city_west_enemies = pick(enemytypes)

	var/spawning
	switch(GLOB.city_west_enemies)
		if("gcorp")
			spawning = /mob/living/simple_animal/hostile/ordeal/steel_dawn
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon

		if("sweeper")
			spawning = /mob/living/simple_animal/hostile/ordeal/indigo_noon
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/indigo_dawn

		if("bots")
			spawning = /mob/living/simple_animal/hostile/ordeal/green_bot
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/green_bot_big
	new spawning(get_turf(src))


/obj/effect/landmark/backstreetspawneast
	name = "cityspawn landmark"
	icon_state = "x3"
	var/list/enemytypes = list(
		"gcorp",
		"sweeper",
		"bots",
	)

/obj/effect/landmark/backstreetspawneast/Initialize()
	. = ..()
	if(!GLOB.city_east_enemies)
		GLOB.city_east_enemies = pick(enemytypes)
	var/spawning
	switch(GLOB.city_east_enemies)
		if("gcorp")
			spawning = /mob/living/simple_animal/hostile/ordeal/steel_dawn
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon

		if("sweeper")
			spawning = /mob/living/simple_animal/hostile/ordeal/indigo_noon
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/indigo_dawn

		if("bots")
			spawning = /mob/living/simple_animal/hostile/ordeal/green_bot
			if(prob(30))
				spawning = /mob/living/simple_animal/hostile/ordeal/green_bot_big
	new spawning(get_turf(src))

