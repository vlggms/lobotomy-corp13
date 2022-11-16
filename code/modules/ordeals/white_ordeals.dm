// Dawn
/datum/ordeal/white_dawn
	name = "Dawn of White"
	annonce_text = "From meaningless errands, to exploration, to contract killing; they will do whatever you wish, \
	so long as you pay them sufficiently."
	level = 6
	delay = 1
	reward_percent = 0.1
	annonce_sound = 'sound/effects/ordeals/white_start.ogg'
	end_sound = 'sound/effects/ordeals/white_end.ogg'
	var/mobs_amount = 1
	var/list/potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/black_fixer,
		/mob/living/simple_animal/hostile/ordeal/white_fixer,
		/mob/living/simple_animal/hostile/ordeal/red_fixer
		)

/datum/ordeal/white_dawn/Run()
	..()
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to mobs_amount)
		if(!potential_types.len)
			break
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		var/chosen_type = pick(potential_types)
		potential_types -= chosen_type
		var/mob/living/simple_animal/hostile/ordeal/C = new chosen_type(T)
		ordeal_mobs += C
		C.ordeal_reference = src

/datum/ordeal/white_dawn/white_noon
	name = "Noon of White"
	annonce_text = "They search constantly, be it for the Backers of the Wings, the Inventions of the Backstreets, \
	the Reliques of the Outskirts, the Artefacts of the Ruins…"
	level = 7
	reward_percent = 0.15
	mobs_amount = 2

/datum/ordeal/white_dawn/white_dusk
	name = "Dusk of White"
	annonce_text = "The colossal tower of light was titled The Library. It is only natural for the Fixers \
	to be drawn to such a mystic place of life and death."
	level = 8
	reward_percent = 0.2
	mobs_amount = 4

// Midnight
/datum/ordeal/white_midnight
	name = "Midnight of White"
	annonce_text = "To know and manipulate all the secrets of the world; that is the \
	privilege of the Head, the Eye, and the Claws. It is their honor and absolute power."
	level = 9
	delay = 1
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

/datum/ordeal/white_midnight/End()
	if(istype(SSlobotomy_corp.core_suppression)) // If it all was a part of core suppression
		SSlobotomy_corp.core_suppression_state = 3
	return ..()
