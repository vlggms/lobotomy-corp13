//A bastardized Events system for city maps only. If it's not a city map it stops.

SUBSYSTEM_DEF(cityevents)
	name = "City Events"
	flags = SS_NO_TICK_CHECK | SS_NO_FIRE
	var/list/spawners = list()
	var/list/itemdrops = list()
	var/list/lights = list()
	var/daystatus = TRUE	//True to darken lights, false to lighten them
	var/globalillumination = 20
	var/list/total_events = list()
	var/helpful_events = list("chickens", "money", "tresmetal", "hppens", "sppens")
	var/harmful_events = list("sweepers", "scouts", "bots")
	var/neutral_events = list("swag")

/datum/controller/subsystem/cityevents/Initialize(timeofday)

	..()
	InitializeLandmarks()
	InitializeEvents()
	if(!can_fire)
		return
	addtimer(CALLBACK(src, .proc/Event), 15 MINUTES)	//Start doing events in 15 minutes

///Ran on initialize, slap these puppies in a new list.
/datum/controller/subsystem/cityevents/proc/InitializeLandmarks()
	for(var/obj/effect/landmark/cityspawner/landmark in GLOB.landmarks_list)
		spawners+= landmark
	if(!LAZYLEN(spawners))
		can_fire = 0

	for(var/obj/effect/landmark/cityloot/landmark in GLOB.landmarks_list)
		itemdrops+= landmark

///Ran on initialize, Initialize the cuustom event systems.
//Pretty Much we want a small amount of Good, bad and neutral events.

//Also I'm like 90% sure this is less processor intensive than iterating a loop, Even if it is REALLY messy
//Duplicates are intended.
/datum/controller/subsystem/cityevents/proc/InitializeEvents()
	total_events += pick(helpful_events)
	total_events += pick(helpful_events)
	total_events += pick(helpful_events)
	total_events += pick(harmful_events)
	total_events += pick(harmful_events)
	total_events += pick(harmful_events)
	total_events += pick(neutral_events)
	total_events += pick(neutral_events)
	total_events += pick("money")			//Always get money

//Events
/datum/controller/subsystem/cityevents/proc/Event()
	addtimer(CALLBACK(src, .proc/Event), 5 MINUTES)
	if(prob(70))	//70% of the time to not fire. Fires roughtly every 15 minutes This just adds some RNG
		return
	var/chosen_event = pick(total_events)
	switch (chosen_event)
		if("sweepers")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/indigo_noon, 40)
		if("scouts")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/indigo_dawn, 60)
		if("bots")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/green_bot, 30)
		if("shrimp")
			spawnatlandmark(/mob/living/simple_animal/hostile/shrimp, 20)
		if("chickens")
			spawnatlandmark(/mob/living/simple_animal/chick, 20)
		if("money")
			spawnitem(/obj/item/stack/spacecash/c50, 50)
		if("tresmetal")
			spawnitem(/obj/item/tresmetal, 10)	//very rare, could fetch you a good price.
		if("swag")
			spawnitem(/obj/item/clothing/shoes/swagshoes, 2)	// Swag out, man
		if("hppens")
			spawnitem(/obj/item/reagent_containers/hypospray/medipen/salacid, 50)
		if("sppens")
			spawnitem(/obj/item/reagent_containers/hypospray/medipen/mental, 50)

//Spawning Mobs, always spawns 3.
/datum/controller/subsystem/cityevents/proc/spawnatlandmark(mob/living/L, chance)
	for(var/J in spawners)
		if(!prob(chance))
			continue
		new /obj/effect/bloodpool(get_turf(J))
		sleep(10)
		//This is less intensive than a loop
		new L (get_turf(J))
		new L (get_turf(J))
		new L (get_turf(J))

//Spawning items
/datum/controller/subsystem/cityevents/proc/spawnitem(obj/item/I, chance)
	for(var/J in itemdrops)
		if(prob(chance))
			new I (get_turf(J))

