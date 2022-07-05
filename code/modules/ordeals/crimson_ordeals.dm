// Dawn
/datum/ordeal/crimson_dawn
	name = "Dawn of Crimson"
	annonce_text = "A perfect meal, an excellent substitute."
	level = 1
	reward_percent = 0.1
	annonce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	/// How many mobs to spawn
	var/spawn_amount = 3

/datum/ordeal/crimson_dawn/Run()
	..()
	var/abno_amount = length(SSlobotomy_corp.all_abnormality_datums)
	spawn_amount = clamp((abno_amount * 0.5), 1, 7)
	for(var/y = 1 to spawn_amount) // They get spawned and then instantly teleport
		var/X = pick(GLOB.xeno_spawn)
		var/turf/T = get_turf(X)
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		M.TeleportAway()
		sleep(7) // That's so the clowns don't instantly teleport to the same console
