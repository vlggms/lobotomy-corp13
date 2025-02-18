//Even when I die, my soul and dreams live on in this Subsystem. - Kitsunemitsu

SUBSYSTEM_DEF(fishing)
	name = "Fishing"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT
	var/moonphase = 1 //Four phases, Waning, New, Waxing, and Full
	var/stopnext = FALSE //Do we want to stop the planets until the moon is next full?

	/// Gets filled on Initialize() with created datums of planets
	var/list/planets = list()
	/// When a planet is destroyed, its god goes into this list.
	var/list/sleeping_gods = list()

/datum/controller/subsystem/fishing/Initialize(start_timeofday)
	if(!(SSmaptype.maptype in SSmaptype.citymaps)) // Don't start if it's not a city map.
		moonphase = 3	// 3 should be average
		return ..()

	moonphase = rand(1, 4) // First set a moon phase

	var/list/planet_datums = subtypesof(/datum/planet)
	for(var/datum/planet/big_rock as anything in planet_datums) //then set planets and random alignments
		big_rock = new big_rock()
		big_rock.phase = rand(1, big_rock.orbit_time)
		planets += big_rock

	addtimer(CALLBACK(src, PROC_REF(Moveplanets)), 7 MINUTES)
	return ..()

/datum/controller/subsystem/fishing/proc/Moveplanets()
	addtimer(CALLBACK(src, PROC_REF(Moveplanets)), 7 MINUTES)
	moonphase++
	if(moonphase == 5)
		moonphase = 1

	if(stopnext && moonphase != 4)
		for(var/mob/M in GLOB.player_list)
			to_chat(M, span_userdanger("The planets begin to move again."))
		return

	for(var/datum/planet/big_rock as anything in planets)
		big_rock.phase++
		if(big_rock.phase == big_rock.orbit_time + 1)
			big_rock.phase = 1

/// Takes a planet datum path, If a planet exists and is aligned, returns TRUE. Else returns FALSE
/datum/controller/subsystem/fishing/proc/IsAligned(datum/planet/planet)
	if(!ispath(planet))
		return FALSE

	var/datum/planet/found_planet = locate(planet) in planets
	if(found_planet)
		if(found_planet.phase == 1)
			return TRUE

	return FALSE

/// Takes a fish god as argument, if a planet with that god is aligned returns TRUE, FALSE otherwise
/proc/CheckPlanetAligned(godcheck)
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(godcheck != planet.god)
			continue

		if(planet.phase == 1)
			return TRUE

	return FALSE

/// The buffs only take into effect if it is in alignment, and you are devoted to the god
/datum/planet
	/// The name of the planet displayed to players
	var/name = "Funky planet"
	/**
	 * orbit_time Controls how long it takes for a planet to get into its alignement with earth, NOT how long it stays in alignement
	 * Examples:
	 * - 1 would mean its always aligned
	 * - 2 would mean it takes 7 minutes to get into orbit, and 7 minutes to get out of alignement
	 * - 3 would mean it takes 14 minutes to get into orbit, and 7 minutes to get out of alignement
	 */
	var/orbit_time = 1
	/// What place in the orbit are we currently in
	var/phase = 1
	/// What god commands this planet
	var/god = FISHGOD_NONE
	/// A general description of what the god's buffs are, showed in the altar
	var/god_desc = "oh my god!"

/datum/planet/Destroy(force, ...)
	if(god != FISHGOD_NONE)
		SSfishing.sleeping_gods[god] = god_desc
	SSfishing.planets -= src
	return ..()

/// God is Lir. Buffs the minimum and maximum size of fish.
/datum/planet/mercury
	name = "Mercury"
	orbit_time = 2
	god = FISHGOD_MERCURY
	god_desc = "Lir is the God of The Sea, and represents Mercury. Devoting yourself to Lir will give you better fortune with the sizes of fish."

/// God is Tefnut. Small chance to fish up a tamed enemy.
/datum/planet/venus
	name = "Venus"
	orbit_time = 3
	god = FISHGOD_VENUS
	god_desc = "Tefnut is the Goddess of moisture, fertility and water, and represents Venus. Devoting yourself to Tefnut will make it less likely for enemies to spawn while catching with nets."

/// God is Arnapkapfaaluk. Buffs the damage of fishing based weapons.
/// (Please don't laugh at the god's name, he was born with it.)
/datum/planet/mars
	name = "Mars"
	orbit_time = 4
	god = FISHGOD_MARS
	god_desc = "Arnapkapfaaluk is the Goddess of aquatic combat, and represents Mars. Devoting yourself to Arnapkapfaaluk will give you strength with fishing weapons."

/// God is Susanoo. Heals everyone around you, as well as AOE feeds people
/datum/planet/jupiter
	name = "Jupiter"
	orbit_time = 5
	god = FISHGOD_JUPITER
	god_desc = "Susanoo is the God of harvest and storms, and represents Jupiter. Devoting yourself to Susanoo will make fishing weapons heal on kill."

/// God is Kukulkan. Buffs aquarium stuff, not only will you heal to full SP on examining fish aquariums.
/// If your aligned god is the same, You feed the fish for significantly longer
/datum/planet/saturn
	name = "Saturn"
	orbit_time = 6
	god = FISHGOD_SATURN
	god_desc = "Kukulkan is the Serpent Deity, and represents Saturn. Devoting yourself to Kukulkan will decrease the cost of all spells by 1 devotion."

/// God is Abena Mansa. Fishing gives you a wallet with ahn in it.
/datum/planet/uranus
	name = "Uranus"
	orbit_time = 7
	god = FISHGOD_URANUS
	god_desc = "Abena Mansa is a sea Goddess of gold, and represents Uranus. Devoting yourself to Abena Mansa will make fishing up ahn possible, scaling with your devotion."

/// God is Glaucus. Gives massive buffs to all things fishing related when aligned.
/datum/planet/neptune
	name = "Neptune"
	orbit_time = 8
	god = FISHGOD_NEPTUNE
	god_desc = "Glaucus is the God of fishing, and represents Neptune. Devoting yourself to Glaucus will enhance all of your fishing skills."
