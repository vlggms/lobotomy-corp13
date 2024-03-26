//A bastardized Events system for city maps only. If it's not a city map it stops.

SUBSYSTEM_DEF(cityevents)
	name = "City Events"
	flags = SS_NO_TICK_CHECK | SS_NO_FIRE
	var/list/spawners = list()
	var/list/itemdrops = list()
	var/list/distortion = list()
	var/list/lights = list()
	var/daystatus = TRUE	//True to darken lights, false to lighten them
	var/globalillumination = 1
	var/list/total_events = list()
	var/list/distortions_available = list()
	var/helpful_events = list("chickens", "money", "tresmetal", "hppens", "sppens")
	var/harmful_events = list("drones", "beaks", "shrimps", "lovetowneasy", "lovetownhard")
	var/ordeal_events = list("sweepers", "scouts", "bots", "gbugs", "gcorporals")
	var/neutral_events = list("swag")
	var/boss_events = list("sweeper", "lovetown", "factory", "gcorp")
	var/list/generated = list()	//Which ckeys have generated stats
	var/wavetime 		//How many waves have spawned? each wave increases the # of enemies by about 5%. One wave is every 5 minutes

/datum/controller/subsystem/cityevents/Initialize(timeofday)

	..()
	InitializeLandmarks()
	InitializeEvents()
	if(!can_fire)
		return
	addtimer(CALLBACK(src, PROC_REF(Event)), 15 MINUTES)	//Start doing events in 15 minutes
	addtimer(CALLBACK(src, PROC_REF(Distort)), 20 MINUTES)		//Distortions start in 20
	addtimer(CALLBACK(src, PROC_REF(Daynight)), 10 SECONDS)

///Ran on initialize, slap these puppies in a new list.
/datum/controller/subsystem/cityevents/proc/InitializeLandmarks()
	for(var/obj/effect/landmark/cityspawner/landmark in GLOB.landmarks_list)
		spawners+= landmark
	if(!LAZYLEN(spawners))
		can_fire = 0

	for(var/obj/effect/landmark/cityloot/landmark in GLOB.landmarks_list)
		itemdrops+= landmark

	for(var/obj/effect/landmark/distortion/landmark in GLOB.landmarks_list)
		distortion+= landmark

///Ran on initialize, Initialize the cuustom event systems.
//Pretty Much we want a small amount of Good, bad and neutral events.

//Also I'm like 90% sure this is less processor intensive than iterating a loop, Even if it is REALLY messy
//Duplicates are intended.
/datum/controller/subsystem/cityevents/proc/InitializeEvents()
	total_events += pick(helpful_events)
	total_events += pick(helpful_events)
	total_events += pick(helpful_events)
	total_events += pick(harmful_events)
	total_events += pick(ordeal_events)
	total_events += pick(ordeal_events)
	total_events += pick(ordeal_events)
	total_events += pick(neutral_events)
	total_events += pick(neutral_events)
	total_events += pick("money")			//Always get money

	//Set available distortion
	var/list/processing = subtypesof(/mob/living/simple_animal/hostile/distortion)
	for(var/mob/living/simple_animal/hostile/distortion/A in processing)
		if(A.can_spawn == 0)
			return
		distortions_available += A

//Events
/datum/controller/subsystem/cityevents/proc/Event()
	addtimer(CALLBACK(src, PROC_REF(Event)), 5 MINUTES)
	var/chosen_event
	if(wavetime == 10 && wavetime !=0)	//after 50 minutes
		chosen_event = Boss()
	else
		chosen_event = pick(total_events)

	switch (chosen_event)
		if("sweepers")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/indigo_noon, 20)
		if("scouts")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/indigo_dawn, 40)
		if("bots")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/green_bot, 10)
		if("gbugs")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/steel_dawn, 30)
		if("gcorporals")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon, 10)

		//Harmful events
		if("shrimps")
			spawnatlandmark(/mob/living/simple_animal/hostile/shrimp, 20)
		if("beaks")
			spawnatlandmark(/mob/living/simple_animal/hostile/ordeal/bigBirdEye, 10)
		if("drones")
			spawnatlandmark(/mob/living/simple_animal/hostile/kcorp/drone, -10)//extremely low chance
		if("lovetowneasy")
			spawnatlandmark(pick(/mob/living/simple_animal/hostile/lovetown/slasher,
			/mob/living/simple_animal/hostile/lovetown/stabber), 25)
		if("lovetownhard")
			spawnatlandmark(pick(/mob/living/simple_animal/hostile/lovetown/shambler,
			/mob/living/simple_animal/hostile/lovetown/slumberer), 5)

		//Good events
		if("chickens")
			spawnatlandmark(/mob/living/simple_animal/chick, 20)
		if("money")
			spawnitem(/obj/item/stack/spacecash/c50, 50)
		if("tresmetal")
			spawnitem(/obj/item/tresmetal, 10)	//very rare, could fetch you a good price.
		if("hppens")
			spawnitem(/obj/item/reagent_containers/hypospray/medipen/salacid, 50)
		if("sppens")
			spawnitem(/obj/item/reagent_containers/hypospray/medipen/mental, 50)

		//Neutral events
		if("swag")
			spawnitem(/obj/item/clothing/shoes/swagshoes, 2)	// Swag out, man
	wavetime+=1

//Spawning Mobs, always spawns 3.
/datum/controller/subsystem/cityevents/proc/spawnatlandmark(mob/living/L, chance)
	chance += wavetime*5
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

/datum/controller/subsystem/cityevents/proc/Boss()
	minor_announce("Warning, large hostile detected. Suppression required.", "Local Activity Alert:", TRUE)
	var/T = pick(spawners)
	var/chosen_boss = pick(boss_events)
	var/chosen_event
	new /obj/effect/bloodpool(get_turf(T))
	sleep(10)
	switch(chosen_boss)
		if ("lovetown")
			new	/mob/living/simple_animal/hostile/lovetown/abomination (get_turf(T))
			chosen_event = "lovetowneasy"
		if ("sweeper")
			new /mob/living/simple_animal/hostile/ordeal/indigo_dusk/red (get_turf(T))
			chosen_event = "scouts"
		if ("factory")
			new /mob/living/simple_animal/hostile/ordeal/green_dusk (get_turf(T))
			chosen_event = "bots"
		if ("gcorp")
			new /mob/living/simple_animal/hostile/ordeal/steel_dusk (get_turf(T))
			chosen_event = "gbugs"
	return chosen_event

//Distortions
/datum/controller/subsystem/cityevents/proc/Distort()
	minor_announce("DANGER: Distortion located in the backstreets. Hana has issued a suppression order.", "Local Activity Alert:", TRUE)
	var/T = pick(distortion)
	new /obj/effect/bloodpool(get_turf(T))
	sleep(10)
	var/spawning = pick(distortions_available)
	new spawning (get_turf(T))
	addtimer(CALLBACK(src, PROC_REF(Distort)), 20 MINUTES)

//Daynight stuff
/datum/controller/subsystem/cityevents/proc/Daynight()
	for(var/obj/effect/light_emitter/L in lights)
		L.set_light(25, globalillumination)

	if(globalillumination <= -0.2)	//Go back up
		addtimer(CALLBACK(src, PROC_REF(Daynight)), 5 MINUTES)
		daystatus = FALSE
		globalillumination = -0.18	//Ship it back up
		return

	if(globalillumination >= 1.1)	//Go back down.
		addtimer(CALLBACK(src, PROC_REF(Daynight)), 5 MINUTES)
		daystatus = TRUE
		globalillumination = 1.08	//Ship it back down
		return

	if(daystatus)	//After noon
		globalillumination -= 0.02
		addtimer(CALLBACK(src, PROC_REF(Daynight)), 10 SECONDS)
	else		//before noon
		globalillumination += 0.02
		addtimer(CALLBACK(src, PROC_REF(Daynight)), 10 SECONDS)
