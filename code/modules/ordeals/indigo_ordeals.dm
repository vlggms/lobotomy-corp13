// Dawn
/datum/ordeal/simplespawn/indigo_dawn
	name = "The Dawn of Indigo"
	flavor_name = "The Scouts"
	announce_text = "They come searching for what they so desperately need."
	end_announce_text = "And they search in the dark."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	reward_percent = 0.1
	level = 1
	spawn_places = 5
	spawn_amount = 2
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn/invis,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn/skirmisher,
		)
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = "#3F00FF"

// Noon
/// Had to override some stuff and make it its own type because of inheritance issues (it was spawning packs twice).
/datum/ordeal/indigo_specials/indigo_noon
	name = "The Noon of Indigo"
	flavor_name = "The Sweepers"
	announce_text = "When night falls in the Backstreets, they will come."
	end_announce_text = "When the sun rises anew, not a scrap will remain."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 2
	reward_percent = 0.15
	var/grunt_type = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)
	var/pack_amount = 4
	var/grunt_amount = 3
	var/pack_player_multiplicator = 0.25
	var/grunt_player_multiplicator = 0.34
	color = "#3F00FF"
	/// Maximum special sweepers per pack spawned, on top of the guaranteed one from pack spawn.
	var/special_type = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky, /mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky)
	var/max_specials = 1
	/// This results in a 25% special chance for 1 Agent, 40% for 2, 55% for 3, etc.
	var/special_chance = 10
	var/special_chance_per_agent = 15

/datum/ordeal/indigo_specials/indigo_noon/Run()
	. = ..()

	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return

	var/meaningful_threats = length(AllLivingAgents(TRUE))
	/// Budget scaling system, you get more specials per pack per living agents.
	switch(meaningful_threats)
		if(3 to 6)
			max_specials = 2
		if(7 to 9)
			max_specials = 3
		if(10 to INFINITY)
			max_specials = 4

	/// There should be a PR up to change GLOB.clients.len (abysmal) into AllLivingAgents(TRUE) scaling, but while I'm overriding the proc I might as well...
	var/pack_player_mod = floor(meaningful_threats * pack_player_multiplicator)
	var/grunt_player_mod = floor(meaningful_threats * grunt_player_multiplicator)
	special_chance = meaningful_threats > 0 ? min(100, special_chance + (special_chance_per_agent * meaningful_threats)) : special_chance
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to floor(pack_amount + pack_player_mod))
		var/turf/T = pick(available_locs)
		if(length(available_locs) > 1)
			available_locs -= T

		var/mob/living/simple_animal/hostile/ordeal/guaranteed_to_spawn = pick(special_type)
		var/mob/living/simple_animal/hostile/ordeal/guaranteed_special_sweeper = new guaranteed_to_spawn(T)
		ordeal_mobs += guaranteed_special_sweeper
		guaranteed_special_sweeper.ordeal_reference = src
		spawngrunts(T, grunt_type, (grunt_amount + grunt_player_mod))

/datum/ordeal/indigo_specials/indigo_noon/spawngrunts(turf/T, list/grunttype, spawn_amount)
	var/list/deployment_area = DeploymentZone(T, TRUE)
	var/specials_spawned = 0
	for(var/i = 1 to spawn_amount)
		var/spawntype = pick(grunttype)
		var/turf/deploy_spot = T
		if(LAZYLEN(deployment_area))
			deploy_spot = pick_n_take(deployment_area)
		if(LAZYLEN(special_type) && prob(special_chance))
			if(specials_spawned < max_specials)
				spawntype = pick(special_type)
				specials_spawned++
		var/mob/living/simple_animal/hostile/ordeal/M = new spawntype(deploy_spot)
		ordeal_mobs += M
		M.ordeal_reference = src

// Dusk
/datum/ordeal/specificcommanders/indigo_dusk
	name = "The Dusk of Indigo"
	flavor_name = "Night in the Backstreets"
	announce_text = "We still have some more fuel. The power of family is not a bad thing."
	end_announce_text = "Dear neighbors, we could not finish the sweeping."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 3
	reward_percent = 0.20
	color = "#3F00FF"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white
		)
	grunttype = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)

// Midnight
/datum/ordeal/boss/indigo_midnight
	name = "The Midnight of Indigo"
	flavor_name = "Mother"
	announce_text = "Mother will give you all the assistance you need. We all could safely become a family thanks to her."
	end_announce_text = "For the sake of our families in our village, we cannot stop."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#3F00FF"
	bosstype = /mob/living/simple_animal/hostile/ordeal/indigo_midnight
