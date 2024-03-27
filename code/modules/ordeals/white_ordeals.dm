/datum/ordeal/fixers
	name = "Fixers"
	announce_text = "This isn't supposed to happen, but they have come for you. Might want to report this to central command."
	can_run = FALSE
	delay = 1 // Goes back-to-back
	random_delay = FALSE
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/white_start.ogg'
	end_sound = 'sound/effects/ordeals/white_end.ogg'
	var/mobs_amount = 1
	var/list/potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/black_fixer,
		/mob/living/simple_animal/hostile/ordeal/white_fixer,
		/mob/living/simple_animal/hostile/ordeal/red_fixer
		)

/datum/ordeal/fixers/Run()
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

// Dawn
/datum/ordeal/fixers/white_dawn
	name = "The Dawn of White"
	flavor_name = "A Request"
	announce_text = "From meaningless errands, to exploration, to contract killing; they will do whatever you wish, \
	so long as you pay them sufficiently."
	can_run = TRUE
	level = 6
	reward_percent = 0.1

/datum/ordeal/fixers/white_dawn/Run()
	..()
	var/mob/living/dawn_mob = ordeal_mobs[1]
	var/dawn_type = null
	if(istype(dawn_mob))
		dawn_type = dawn_mob.type
	var/datum/ordeal/fixers/white_noon/N = locate() in SSlobotomy_corp.all_ordeals[7]
	if(N)
		N.potential_types -= dawn_type

/datum/ordeal/fixers/white_noon
	name = "The Noon of White"
	flavor_name = "Armaments"
	announce_text = "They search constantly, be it for the Backers of the Wings, the Inventions of the Backstreets, \
	the Reliques of the Outskirts, the Artefacts of the Ruins..."
	can_run = TRUE
	level = 7
	reward_percent = 0.15
	mobs_amount = 2

/datum/ordeal/fixers/white_dusk
	name = "The Dusk of White"
	flavor_name = "The Fixers"
	announce_text = "The colossal tower of light was titled The Library. It is only natural for the Fixers \
	to be drawn to such a mystic place of life and death."
	can_run = TRUE
	level = 8
	reward_percent = 0.2
	mobs_amount = 4
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/black_fixer,
		/mob/living/simple_animal/hostile/ordeal/white_fixer,
		/mob/living/simple_animal/hostile/ordeal/red_fixer,
		/mob/living/simple_animal/hostile/ordeal/pale_fixer
		)

// Midnight
/datum/ordeal/white_midnight
	name = "The Midnight of White"
	flavor_name = "The Claw"
	announce_text = "To know and manipulate all the secrets of the world; that is the \
	privilege of the Head, the Eye, and the Claws. It is their honor and absolute power."
	level = 9
	delay = 1
	random_delay = FALSE
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/white_start.ogg'
	end_sound = 'sound/effects/ordeals/white_end.ogg'

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
		SSticker.news_report = max(SSticker.news_report, CORE_SUPPRESSED_CLAW_DEAD)
		addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, End)), 10 SECONDS)
	return ..()
