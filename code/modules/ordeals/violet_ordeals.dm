// Dawn
// So, it works practically the same as amber dawn, so here we go
/datum/ordeal/amber_dawn/violet_dawn
	name = "Dawn of Violet"
	annonce_text = "To gain an understanding of what is incomprehensible, they dream, staring."
	annonce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/violet_fruit

// Noon
/datum/ordeal/violet_noon
	name = "Noon of Violet"
	annonce_text = "We could only hear the weakest and faintest of their acts. We sought for love and compassion from them."
	annonce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 2
	reward_percent = 0.15

/datum/ordeal/violet_noon/Run()
	..()
	for(var/turf/T in GLOB.department_centers)
		var/mob/living/simple_animal/hostile/ordeal/violet_monolith/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
