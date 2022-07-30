// Midnight
/datum/ordeal/white_midnight
	name = "Midnight of White"
	annonce_text = "To know and manipulate all the secrets of the world; that is the \
	privilege of the Head, the Eye, and the Claws. It is their honor and absolute power."
	level = 4
	reward_percent = 0.25
	annonce_sound = 'sound/effects/ordeals/white_start.ogg'
	end_sound = 'sound/effects/ordeals/white_end.ogg'
	var/spawn_type = /mob/living/simple_animal/hostile/megafauna/claw

/datum/ordeal/white_midnight/Run()
	..()
	var/X = pick(GLOB.xeno_spawn)
	var/turf/T = get_turf(X)
	var/mob/living/simple_animal/hostile/megafauna/claw/C = new(T)
	ordeal_mobs += C
	C.ordeal_reference = src
