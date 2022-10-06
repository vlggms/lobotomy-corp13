// A Party Everlasting
/datum/ordeal/pink_midnight
	name = "Midnight of Pink"
	annonce_text = "Let's have one big jambouree, a party everlasting."
	level = 4
	reward_percent = 0.25
	annonce_sound = 'sound/effects/ordeals/pink_start.ogg'
	end_sound = 'sound/effects/ordeals/pink_end.ogg'
	color = COLOR_PINK

/datum/ordeal/pink_midnight/Run()
	..()
	var/X = pick(GLOB.department_centers)
	var/turf/T = get_turf(X)
	var/mob/living/simple_animal/hostile/ordeal/pink_midnight/C = new(T)
	ordeal_mobs += C
	C.ordeal_reference = src
	addtimer(CALLBACK(src, .proc/Add_Mobs), 10 SECONDS)

/datum/ordeal/pink_midnight/proc/Add_Mobs()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.mob_list)
		if("pink_midnight" in A.faction)
			ordeal_mobs += A
