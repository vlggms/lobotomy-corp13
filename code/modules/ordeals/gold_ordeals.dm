// Dawn
/datum/ordeal/gold_dawn
	name = "The Dawn of Gold"
	flavor_name = "The First Trumpet" //Temporary as can be, but an interesting allusion to the original game
	announce_text = "Our choice could be hope or despair as the sun comes."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/gold_start.ogg'
	end_sound = 'sound/effects/ordeals/gold_end.ogg'
	color = "#FFD700"

	//Sort of a combination of specific commanders and random spawns
	var/list/boss_type = list(/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion)
	//Randomly picked from these.
	var/list/grunt_type = list(/mob/living/simple_animal/hostile/ordeal/sin_gluttony)
	var/list/roamer_type = list(/mob/living/simple_animal/hostile/ordeal/sin_sloth) //Randomly spawned around the map
	var/boss_amount = 2
	var/grunt_amount = 3
	var/roamer_amount = 3
	var/boss_player_multiplicator = 0.05
	var/grunt_player_multiplicator = 0.1

/datum/ordeal/gold_dawn/Run() //We want our own variant that spawns both groups of mobs and roamers
	..()
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/boss_player_mod = round(GLOB.clients.len * boss_player_multiplicator)
	var/grunt_player_mod = round(GLOB.clients.len * grunt_player_multiplicator)
	var/list/available_locs = GLOB.xeno_spawn.Copy()

	for(var/i = 1 to round(boss_amount + boss_player_mod)) //Run the usual simplecommander code
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		for(var/Y in boss_type)
			var/mob/living/simple_animal/hostile/ordeal/C = new Y(T)
			ordeal_mobs += C
			C.ordeal_reference = src
		spawngrunts(T, grunt_type, (grunt_amount + grunt_player_mod))

	for(var/i = 1 to round(roamer_amount + boss_player_mod)) //we spawn groups of roamers using boss slots as a base
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		for(var/Y in roamer_type)
			var/mob/living/simple_animal/hostile/ordeal/C = new Y(T)
			ordeal_mobs += C
			C.ordeal_reference = src

//Noon
/datum/ordeal/boss/gold_noon
	name = "The Noon of Gold"
	flavor_name = "The Second Trumpet"
	announce_text = "Our light blazed brightly in the sky, the stars that marked our starting fell away."
	level = 2
	reward_percent = 0.15
	announce_sound = 'sound/effects/ordeals/gold_start.ogg'
	end_sound = 'sound/effects/ordeals/gold_end.ogg'
	color = "#FFD700"
	bosstype = /mob/living/simple_animal/hostile/ordeal/white_lake_corrosion
	var/roamer_type = list(/mob/living/simple_animal/hostile/ordeal/sin_gloom)
	var/roamer_amount = 4
	var/boss_player_multiplicator = 0.05
	var/grunt_player_multiplicator = 0.1

/datum/ordeal/boss/gold_noon/Run() //We need to spawn roamers, still.
	..()
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/boss_player_mod = round(GLOB.clients.len * boss_player_multiplicator)
	var/grunt_player_mod = round(GLOB.clients.len * grunt_player_multiplicator)
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to round(roamer_amount + boss_player_mod)) //we spawn groups of roamers using boss slots as a base
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		spawngrunts(T, roamer_type, (roamer_amount + grunt_player_mod))


//Dusk
/datum/ordeal/gold_dawn/gold_dusk
	name = "The Dusk of Gold"
	flavor_name = "The Third Trumpet"
	announce_text = "Stay vigilant, stay resolved. Let our minds be strong when dusk falls."
	level = 3
	reward_percent = 0.2
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/KHz_corrosion)
	grunt_type  = list(/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion)
	roamer_type = list(/mob/living/simple_animal/hostile/ordeal/sin_pride)
	boss_amount = 1
	grunt_amount = 2
	roamer_amount = 4

//Midnight
/*
/datum/ordeal/simplecommander/gold_dawn/gold_midnight
	name = "The Midnight of Gold"
	flavor_name = "The Fourth Trumpet"
	announce_text = "The night has come. Our ignorance as its origin. No one shall be redeemed at its end."
	level = 4
	reward_percent = 0.25

*/
