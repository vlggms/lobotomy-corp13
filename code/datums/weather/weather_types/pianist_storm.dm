// Aesthetic thunderstorm for Pianist Phase 2
/datum/weather/pianist_storm
	name = "melodic tempest"
	desc = "A dramatic thunderstorm that accompanies the Pianist's performance. Purely aesthetic."

	// Never occurs randomly - only triggered by Pianist
	probability = 0

	// Telegraph stage
	telegraph_message = span_boldwarning("The air grows heavy with musical tension...")
	telegraph_duration = 100 // 10 seconds
	telegraph_overlay = "light_rain" // Dark clouds gathering
	telegraph_sound = 'sound/ambience/acidrain_start.ogg'

	// Main weather stage
	weather_message = span_userdanger("<i>Thunder crashes as the storm breaks! The Pianist's performance reaches its crescendo!</i>")
	weather_overlay = "rain_storm" // Heavy rain effect
	weather_duration_lower = 9999999 // Lasts until Pianist dies
	weather_duration_upper = 9999999
	weather_sound = 'sound/ambience/acidrain_mid.ogg' // Rain ambience

	// End stage
	end_duration = 100
	end_message = span_boldannounce("The storm fades with the Pianist's final note...")
	end_overlay = "light_rain"
	end_sound = 'sound/ambience/acidrain_end.ogg'

	// Area targeting
	area_type = /area
	protect_indoors = FALSE // Storm affects all areas during performance
	target_trait = ZTRAIT_STATION

	// IMPORTANT: This makes it aesthetic only with no gameplay effects
	aesthetic = TRUE
	perpetual = TRUE // Weather lasts until manually ended

	// Other properties
	barometer_predictable = FALSE // Can't be predicted
	immunity_type = "storm" // Not that it matters for aesthetic weather

	// Thunder sound list for random selection
	var/list/thunder_sounds = list(
		'sound/effects/ordeals/gold/weather_thunder_0.ogg',
		'sound/effects/ordeals/gold/weather_thunder_1.ogg',
		'sound/effects/ordeals/gold/weather_thunder_2.ogg',
		'sound/effects/ordeals/gold/weather_thunder_3.ogg'
	)
	var/next_thunder_time = 0

// Override weather_act to add periodic thunder even though it's aesthetic
/datum/weather/pianist_storm/weather_act(mob/living/L)
	// Don't call parent since we're aesthetic
	// But we can still do visual/audio effects

	// Periodic thunder
	if(world.time >= next_thunder_time)
		next_thunder_time = world.time + rand(100, 300) // 10-30 seconds between thunder

		// Play thunder for everyone in the area
		var/thunder_sound = pick(thunder_sounds)
		for(var/mob/M in GLOB.player_list)
			if(M.z == L.z)
				M.playsound_local(get_turf(M), thunder_sound, rand(70, 100), FALSE)

				// Chance for lightning flash
				if(prob(60))
					M.overlay_fullscreen("flash", /atom/movable/screen/fullscreen/flash)
					M.clear_fullscreen("flash", 5)

	return

// Custom start proc to ensure it covers the whole z-level
/datum/weather/pianist_storm/start()
	// Get all areas on the Pianist's z-level
	var/list/affected_areas = list()
	for(var/area/A in world)
		if(A.z == impacted_z_levels[1]) // Assuming single z-level
			affected_areas += A

	// Update impacted_areas to include everything
	impacted_areas = affected_areas

	return ..()

// Make the weather less intense indoors
/datum/weather/pianist_storm/update_areas()
	// Override to apply different overlays for indoor/outdoor
	for(var/V in impacted_areas)
		var/area/N = V
		N.layer = overlay_layer
		N.plane = overlay_plane
		N.icon = 'icons/effects/weather_effects.dmi'
		N.color = weather_color

		// Use lighter effect indoors during main stage
		if(stage == MAIN_STAGE && protect_indoors && !N.outdoors)
			N.icon_state = telegraph_overlay // Lighter effect indoors
		else
			switch(stage)
				if(STARTUP_STAGE)
					N.icon_state = telegraph_overlay
				if(MAIN_STAGE)
					N.icon_state = weather_overlay
				if(WIND_DOWN_STAGE)
					N.icon_state = end_overlay
				if(END_STAGE)
					N.color = null
					N.icon_state = ""
					N.icon = 'icons/turf/areas.dmi'
					N.layer = initial(N.layer)
					N.plane = initial(N.plane)
					N.set_opacity(FALSE)
