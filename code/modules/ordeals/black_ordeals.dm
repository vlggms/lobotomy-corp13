/datum/ordeal/black_midnight
	name = "The Midnight of Black"
	flavor_name = "A Reflection of the Zenith"
	announce_text = "To reach the peak to only fall back into the pits of hell once more..."
	end_announce_text = "Oh how utter fools we were as we start again anew."
	can_run = TRUE
	level = 9
	reward_percent = 0.25
	color = "#444444"
	var/bosstype = /mob/living/simple_animal/hostile/megafauna/black_midnight
	var/bossspawnloc = /area/department_main/command

/datum/ordeal/black_midnight/Run()
	..()
	var/turf/T
	if(bossspawnloc)
		for(var/turf/D in GLOB.department_centers)
			if(istype(get_area(D), bossspawnloc))
				T = D
				break
		if(!T)
			var/X = pick(GLOB.department_centers)
			T = get_turf(X)
			log_game("Failed to spawn [src] in [bossspawnloc]")
	else
		var/X = pick(GLOB.department_centers)
		T = get_turf(X)
	var/mob/living/simple_animal/hostile/ordeal/C = new bosstype(T)
	ordeal_mobs += C
	C.ordeal_reference = src

/datum/ordeal/black_midnight/End()//Kirie forgot about this
	if(istype(SSlobotomy_corp.core_suppression)) // If it all was a part of core suppression
		SSlobotomy_corp.core_suppression_state = 3
		SSticker.news_report = max(SSticker.news_report, CORE_SUPPRESSED_CLAW_DEAD)
		addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, End)), 10 SECONDS)
	return ..()