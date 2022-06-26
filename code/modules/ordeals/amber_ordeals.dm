// Dawn
/datum/ordeal/amber_dawn
	name = "Dawn of Amber"
	annonce_text = "A perfect meal, an excellent substitute."
	level = 1
	reward_percent = 0.1
	annonce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	/// How many places are chosen for the spawn
	var/spawn_places = 3
	/// How many mobs to spawn per spot
	var/spawn_amount = 3
	/// What mob to spawn
	var/spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_bug

/datum/ordeal/amber_dawn/Run()
	..()
	for(var/i = 1 to spawn_places)
		var/X = pick(GLOB.xeno_spawn)
		var/turf/T = get_turf(X)
		for(var/y = 1 to spawn_amount)
			var/mob/living/simple_animal/hostile/ordeal/M = new spawn_type(T)
			ordeal_mobs += M
			M.ordeal_reference = src
