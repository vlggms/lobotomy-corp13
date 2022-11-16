// Can someone see the turf indicated? //
//
/proc/check_location_seen(atom/subject, turf/T)
	if (!isturf(T)) // Only check if I wasn't given a locker or something
		return FALSE
	// A) Check for Darkness
	if(T && T.lighting_object && T.get_lumcount()>= 0.1)
		// B) Check for Viewers
		for(var/mob/living/M in viewers(T))
			if(M != subject && isliving(M) && M.mind && !M.has_unlimited_silicon_privilege && !M.eye_blind) // M.client <--- add this in after testing!
				return TRUE
	return FALSE



/proc/return_valid_floor_in_range(atom/A, checkRange = 8, minRange = 0, checkFloor = TRUE)
	// FAIL: Atom doesn't exist. Aren't you real?
	if (!istype(A))
		return null

	var/deltaX = rand(minRange,checkRange)*pick(-1,1)
	var/deltaY = rand(minRange,checkRange)*pick(-1,1)
	var/turf/center = get_turf(A)

	var/target = locate((center.x + deltaX),(center.y + deltaY),center.z)

	if (check_turf_is_valid(target, checkFloor))
		return target
	return null


/proc/check_turf_is_valid(turf/T, checkFloor = TRUE)
	// Checking for Floor...
	if (checkFloor && !istype(T, /turf/open/floor))
		return FALSE
	// Checking for Density...
	if(T.density)
		return FALSE
	// Checking for Objects...
	for(var/obj/O in T)
		if(O.density)
			return FALSE
	return TRUE

// Called for round-end music
/client/proc/playcreditsmusic(vol = 85)
	set waitfor = FALSE
	if(prefs && (prefs.toggles & SOUND_LOBBY))
		SEND_SOUND(src, sound(returncreditsmusic(), repeat = 0, wait = 0, volume = vol, channel = CHANNEL_LOBBYMUSIC))

GLOBAL_VAR(roundend_music)
/client/proc/returncreditsmusic()
	if(isfile(GLOB.roundend_music)) // If there's a file corresponding to global var path
		return GLOB.roundend_music

	// If nothing overwrote the music we go deep into the calculations of how well you did
	var/core_suppression_state = SSlobotomy_corp.core_suppression_state // 0 = Never did; 1 = Initiated; 2 = Completed.
	var/players = GLOB.joined_player_list.len
	var/survivors = 0
	for(var/mob/M in GLOB.mob_list)
		if(isnewplayer(M))
			continue
		if(!M.mind)
			continue
		if(ishuman(M) && M.stat != DEAD)
			survivors++
	var/survival_rate = survivors / players
	if(GLOB.player_list.len >= 8) // Lowpop doesn't count for epic music
		if(core_suppression_state == 3) // Claw killed during core suppression
			switch(survival_rate)
				if(-INFINITY to 0.2) // Dead agents, you will be remembered...
					return 'ModularTegustation/tegusounds/roundend/Intricate.ogg'
				if(0.2 to 0.45) // Normal
					return 'ModularTegustation/tegusounds/roundend/Recollected.ogg'
				if(0.45 to 0.7) // Impressive!
					return 'ModularTegustation/tegusounds/roundend/NightSky.ogg'
				if(0.7 to 0.9) // Perfect!
					return 'ModularTegustation/tegusounds/roundend/AGiant.ogg'
				if(0.9 to INFINITY) // Something that will never happen
					return 'ModularTegustation/tegusounds/roundend/SunAndMoon.ogg'

		if(core_suppression_state == 2) // Core suppressed, Claw wasn't killed
			switch(survival_rate)
				if(-INFINITY to 0.2)
					return 'ModularTegustation/tegusounds/roundend/CityOfLight.ogg'
				if(0.2 to 0.6)
					return 'ModularTegustation/tegusounds/roundend/VastLandscape.ogg'
				if(0.6 to INFINITY)
					return 'ModularTegustation/tegusounds/roundend/StrangeDream.ogg'

		switch(survival_rate)
			if(-INFINITY to 0.02) // How..?
				return 'ModularTegustation/tegusounds/roundend/EndTitle.ogg'
			if(0.02 to 0.1) // Complete annihilation
				return 'ModularTegustation/tegusounds/roundend/WakeUp.ogg'
			if(0.1 to 0.3) // Quite bad
				return pick('ModularTegustation/tegusounds/roundend/TrustMe.ogg', 'ModularTegustation/tegusounds/roundend/Story4.ogg')
			if(0.3 to 0.5) // Meh
				return pick('ModularTegustation/tegusounds/roundend/WhenItRains.ogg', 'ModularTegustation/tegusounds/roundend/DearLorenne.ogg')
			if(0.5 to 0.7) // Getting better
				return pick('ModularTegustation/tegusounds/roundend/BluesMan.ogg', 'ModularTegustation/tegusounds/roundend/Alone.ogg')
			if(0.7 to 0.85) // Great!
				return 'ModularTegustation/tegusounds/roundend/CrimeLord.ogg'
			if(0.85 to 0.95) // Wonderful!
				return 'ModularTegustation/tegusounds/roundend/LoR_Theme2.ogg'
			if(0.95 to INFINITY) // Perfect!
				// ~ Note from Egor:
				// If you somehow get 0-5% casualties above 10 pop, you will get to request one feature of any kind(but not against the rules).
				return 'ModularTegustation/tegusounds/roundend/Success.ogg'

	return 'ModularTegustation/tegusounds/roundend/Flow.ogg'

/mob/living/carbon/proc/getBruteLoss_nonProsthetic()
	var/amount = 0
	for(var/obj/item/bodypart/BP in bodyparts)
		if (BP.status < 2)
			amount += BP.brute_dam
	return amount
/mob/living/carbon/proc/getFireLoss_nonProsthetic()
	var/amount = 0
	for(var/obj/item/bodypart/BP in bodyparts)
		if (BP.status < 2)
			amount += BP.burn_dam
	return amount
