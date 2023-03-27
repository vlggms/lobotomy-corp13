/mob/living/simple_animal/hostile/abnormality
	var/neutral_mood = 35
	var/happy_mood = 75
	var/start_mood = 50

/mob/living/simple_animal/hostile/abnormality/ZeroQliphoth()
	datum_reference?.qliphoth_meter = 0
	return ..()

/mob/living/simple_animal/hostile/abnormality/proc/OnMoodChange()
	return

////////////////////////////////////////////////////
/* All abnormality overrides for silly Legacy day */
////////////////////////////////////////////////////

// Queen of Hatred
/mob/living/simple_animal/hostile/abnormality/hatred_queen
	happy_mood = 60
	neutral_mood = 40
	start_mood = 80

/mob/living/simple_animal/hostile/abnormality/hatred_queen/OnMoodChange()
	var/old_qlip = datum_reference.qliphoth_meter
	var/datum/abnormality/legacy/legacy_datum = datum_reference
	if(legacy_datum.current_mood >= happy_mood)
		datum_reference.qliphoth_meter = 2
	else if(legacy_datum.current_mood <= happy_mood) // True bipolar experience
		datum_reference.qliphoth_meter = 1
	if(old_qlip == datum_reference.qliphoth_meter)
		return
	return OnQliphothChange()

// The Silent Orchestra
/mob/living/simple_animal/hostile/abnormality/silentorchestra
	happy_mood = 75
	neutral_mood = 25
	start_mood = 50
	/// Upon reaching 5 - we breach
	var/breach_ticks = 0

/mob/living/simple_animal/hostile/abnormality/silentorchestra/OnMoodChange()
	if(!IsContained())
		return

	var/datum/abnormality/legacy/legacy_datum = datum_reference
	if(legacy_datum.current_mood >= happy_mood)
		breach_ticks += 1
	else if(legacy_datum.current_mood <= happy_mood)
		breach_ticks += 1

	if(breach_ticks >= 5)
		ZeroQliphoth()

// White Night
/mob/living/simple_animal/hostile/abnormality/white_night
	happy_mood = 60
	neutral_mood = 30
	start_mood = 90

/mob/living/simple_animal/hostile/abnormality/white_night/OnMoodChange()
	if(!IsContained())
		return

	// Behold, shitcode
	var/old_qlip = datum_reference.qliphoth_meter
	var/datum/abnormality/legacy/legacy_datum = datum_reference
	if(legacy_datum.current_mood >= happy_mood)
		datum_reference.qliphoth_meter = 3
	else if(legacy_datum.current_mood >= neutral_mood)
		datum_reference.qliphoth_meter = 2
	else
		datum_reference.qliphoth_meter = 1

	if(old_qlip == datum_reference.qliphoth_meter)
		return

	var/flashing_color = COLOR_ORANGE
	if(datum_reference.qliphoth_meter == 1)
		flashing_color = COLOR_SOFT_RED
	if(datum_reference.qliphoth_meter == 3)
		flashing_color = COLOR_GREEN
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color = flashing_color, flash_time = 25)
	sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg', (25 * (3 - datum_reference.qliphoth_meter)))
	return
