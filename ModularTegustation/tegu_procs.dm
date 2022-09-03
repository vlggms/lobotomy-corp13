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
		SEND_SOUND(src, sound(returncreditsmusic(), repeat = 0, wait = 0, volume = vol, channel = CHANNEL_LOBBYMUSIC)) // TEGUSTATION: Play end music! SO SAD!

// Called from sound.dm to find a track to play
/client/proc/returncreditsmusic() // TEGUSTATION
	if (prob(15))
		return 'ModularTegustation/tegusounds/Uhoh_Stinky.ogg'
	if (prob(5))
		return 'ModularTegustation/tegusounds/Tegu_Piano_Old.ogg'
	return 'ModularTegustation/tegusounds/Tegu_Piano.ogg'

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
