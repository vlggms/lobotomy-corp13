// Midnight of gold
/datum/ordeal/gold_midnight
	name = "Midnight of Gold"
	annonce_text = "He wants to make a DEAL, but don't give him your MONEY!"
	level = 4
	reward_percent = 0.25
	annonce_sound = 'sound/effects/ordeals/gold_start.ogg'
	end_sound = 'sound/effects/ordeals/gold_end.ogg'
	color = COLOR_LIME

/datum/ordeal/gold_midnight/Run()
	..()
	var/X = pick(GLOB.department_centers)
	var/turf/T = get_turf(X)
	var/mob/living/simple_animal/hostile/ordeal/gold_midnight/C = new(T)
	ordeal_mobs += C
	C.ordeal_reference = src
