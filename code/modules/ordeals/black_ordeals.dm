// Dawn
/*/datum/ordeal/fixers/echoes
	name = "Echoes"
	flavor_name = "A Mirror"
	announce_text = "This isn't supposed to happen, but they have come for you. Might want to report this to central command."
	can_run = FALSE
	reward_percent = 0.1
	color = "#444444"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/echo/star,
	)

/datum/ordeal/fixers/echoes/black_dawn
	name = "The Dawn of Black"
	flavor_name = "A Mirror"
	announce_text = "The unexamined life is not worth living."
	end_announce_text = "After it's all said and done, it's still you."
	can_run = TRUE
	level = 6
	reward_percent = 0.1
	mobs_amount = 4
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/echo/replica,
		/mob/living/simple_animal/hostile/ordeal/echo/oppression,
		/mob/living/simple_animal/hostile/ordeal/echo/giant,
		/mob/living/simple_animal/hostile/ordeal/echo/totalitarianism,
	)

/datum/ordeal/fixers/echoes/black_noon
	name = "The Noon of Black"
	flavor_name = "The Parallel of Disaster"
	announce_text = "For such a calamity would happen..."
	end_announce_text = "We would get back up from ruin and continue the climb."
	can_run = TRUE
	level = 7
	reward_percent = 0.15
	mobs_amount = 6
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/echo/insane/wolf,
		/mob/living/simple_animal/hostile/ordeal/echo/insane/screen,
		/mob/living/simple_animal/hostile/ordeal/echo/belltoles,
		/mob/living/simple_animal/hostile/ordeal/echo/smile,
		/mob/living/simple_animal/hostile/ordeal/echo/littlered,
		/mob/living/simple_animal/hostile/ordeal/echo/pink,
	)

/datum/ordeal/fixers/echoes/black_dusk
	name = "The Dusk of Black"
	flavor_name = "A Mirror"
	announce_text = "To thine own self be true..."
	end_announce_text = "And to thine own self be patient."
	can_run = TRUE
	level = 8
	reward_percent = 0.2
	mobs_amount = 8
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/echo/star,
		/mob/living/simple_animal/hostile/ordeal/echo/ability/laughter,
		/mob/living/simple_animal/hostile/ordeal/echo/ability/headofgod,
		/mob/living/simple_animal/hostile/ordeal/echo/blooming,
		/mob/living/simple_animal/hostile/ordeal/echo/capo,
		/mob/living/simple_animal/hostile/ordeal/echo/realized/shell,
		/mob/living/simple_animal/hostile/ordeal/echo/adoration,
		/mob/living/simple_animal/hostile/ordeal/echo/repentance,
	)
*/
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

/datum/ordeal/boss/black_midnight/End()//Kirie forgot about this
	if(istype(SSlobotomy_corp.core_suppression)) // If it all was a part of core suppression
		SSlobotomy_corp.core_suppression_state = 3
		SSticker.news_report = max(SSticker.news_report, CORE_SUPPRESSED_CLAW_DEAD)
		addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, End)), 10 SECONDS)
	return ..()