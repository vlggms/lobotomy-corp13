// Dawn
/datum/ordeal/crimson_dawn
	name = "The Dawn of Crimson"
	flavor_name = "Cheers for the Beginning"
	announce_text = "Let us light a flame yet more radiant in our lives; for life is a candlelight, \
	destined to snuff out one day."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	color = "#DC143C"

/datum/ordeal/crimson_dawn/Run()
	..()
	var/abno_amount = length(SSlobotomy_corp.all_abnormality_datums)
	var/spawn_amount = clamp((abno_amount * 0.5), 1, 7)
	for(var/y = 1 to spawn_amount) // They get spawned and then instantly teleport
		var/X = pick(GLOB.xeno_spawn)
		var/turf/T = get_turf(X)
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		M.TeleportAway()
		sleep(7) // That's so the clowns don't instantly teleport to the same console

/datum/ordeal/simplespawn/crimson_noon
	name = "The Noon of Crimson"
	flavor_name = "The Harmony of Skin"
	announce_text = "We marched from time to time, and we would share our pleasure."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	level = 2
	reward_percent = 0.15
	spawn_places = 4
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/crimson_noon
	place_player_multiplicator = 0.07
	spawn_player_multiplicator = 0.02
	color = "#DC143C"

/datum/ordeal/simplespawn/crimson_dusk
	name = "The Dusk of Crimson"
	flavor_name = "The Struggle at the Climax"
	announce_text = "Throwing away our old bodies, we all become one, infinitely continuing the red march."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	level = 3
	reward_percent = 0.2
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0
	color = "#DC143C"

/datum/ordeal/simplecommander/crimson_midnight
	name = "The Midnight of Crimson"
	flavor_name = "A Chorus of Saliva"
	announce_text = "Let us make a performance about what has already come true, and march further on from whence we came."
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	color = "#DC143C"
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/crimson_tent)
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_midnight)
	boss_amount = 2
	grunt_amount = 1
