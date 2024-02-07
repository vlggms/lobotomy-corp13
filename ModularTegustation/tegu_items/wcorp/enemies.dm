GLOBAL_VAR_INIT(wcorp_boss_spawn, FALSE)


/obj/effect/landmark/wavespawn
	name = "wave spawner"
	desc = "It spawns an enemy wave. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x3"
	var/spawntype

/obj/effect/landmark/wavespawn/Initialize()
	..()
	addtimer(CALLBACK(src, PROC_REF(tryspawn)), 3 MINUTES, TIMER_STOPPABLE)

//Wave increases.
/obj/effect/landmark/wavespawn/proc/tryspawn()
	addtimer(CALLBACK(src, PROC_REF(tryspawn)), 45 SECONDS, TIMER_STOPPABLE)
	if(GLOB.combat_counter == 0)
		return
	switch(GLOB.wcorp_enemy_faction) //Each round has a specific faction, decided on code/game/gamemodes/management/event/combat

		if("gcorp")
			spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn
			switch(GLOB.combat_counter)

				//10% Remnant / 90% Corporal
				if(1 to 5)
					if(prob(10))
						spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon

				//50% Remnant / 25% Corporal / 25% Aerial Scout
				if(6 to 14)
					switch(rand(1, 100))
						if(50 to 75)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon
						if(75 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn

				//50% Remnant / 25% Corporal / 15% Aerial Scout / 10% Manager
				if(15 to INFINITY)
					switch(rand(1, 100))
						if(50 to 75)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon
						if(75 to 90)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying
						if(90 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dusk
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn

		if("lovetown")
			spawntype = /mob/living/simple_animal/hostile/lovetown/suicidal
			switch(GLOB.combat_counter)

				//50% Suicidal / 25% Slasher / 25% Stabber
				if(1 to 2)
					switch(rand(1,100))
						if(50 to 75)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher
						if(75 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/suicidal

				//45% Slasher / 45% Stabber / 10% Slammer
				if(3 to 5)
					switch(rand(1,100))
						if(10 to 55)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher
						if(55 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/slammer

				//25% Slasher / 25% Stabber / 20% Slammer / 15% Shambler / 15% Slumberer
				if(6 to 12)
					switch(rand(1, 100))
						if(15 to 40)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher
						if(40 to 65)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber
						if(65 to 85)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slammer
						if(85 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/shambler
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/slumberer

				//100% one Abomination, rest 20% Slashers / 20% Stabbers / 60% Suicidals
				if(13 to 14)
					if(!GLOB.wcorp_boss_spawn)
						GLOB.wcorp_boss_spawn = TRUE
						spawntype = /mob/living/simple_animal/hostile/lovetown/abomination
					else
						switch(rand(1,100))
							if(60 to 80)
								spawntype = /mob/living/simple_animal/hostile/lovetown/slasher
							if(80 to 100)
								spawntype = /mob/living/simple_animal/hostile/lovetown/stabber
							else
								spawntype = /mob/living/simple_animal/hostile/lovetown/suicidal

				//20% Slasher / 20% Stabber / 20% Slammer / 20% Shambler / 20% Slumberer
				if(15 to INFINITY)
					switch(rand(1, 100))
						if(20 to 40)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher
						if(40 to 60)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber
						if(60 to 80)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slammer
						if(80 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/shambler
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/slumberer

		if("peccatulum")
			spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gluttony
			switch(GLOB.combat_counter)

				//Mostly gluttony, with a lil sloth
				if(1 to 2)
					switch(rand(1,100))

						if(85 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_sloth
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gluttony

				//i dont know what the fuck im doing
				if(3 to 5)
					switch(rand(1,100))
						if(10 to 55)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_sloth
						if(55 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gloom
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gluttony


				//25% Slasher / 25% Stabber / 20% Slammer / 15% Shambler / 15% Slumberer but for peccs I guess???
				if(6 to 12)
					switch(rand(1, 100))
						if(40 to 65)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_sloth
						if(65 to 85)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gloom
						if(85 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_pride
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gluttony


				//100% one Abomination, rest 20% Slashers / 20% Stabbers / 60% Suicidals
				if(13 to 14)
					if(!GLOB.wcorp_boss_spawn)
						GLOB.wcorp_boss_spawn = TRUE
						spawntype = /mob/living/simple_animal/hostile/ordeal/white_lake_corrosion
					else
						switch(rand(1,100))
							if(60 to 80)
								spawntype = /mob/living/simple_animal/hostile/ordeal/sin_pride
							if(80 to 100)
								spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gloom
							else
								spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gluttony

				//20% Slasher / 20% Stabber / 20% Slammer / 20% Shambler / 20% Slumberer
				if(15 to INFINITY)
					switch(rand(1, 100))
						if(20 to 30)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_lust
						if(30 to 60)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gloom
						if(60 to 80)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_wrath
						if(80 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_pride
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/sin_gluttony




		if("shrimp")
			spawntype = /mob/living/simple_animal/hostile/shrimp_rifleman
			switch(GLOB.combat_counter)

				//10% Remnant / 90% Corporal
				if(1 to 3)
					if(prob(10))
						spawntype = /mob/living/simple_animal/hostile/shrimp


				if(4 to 7)
					switch(rand(1, 100))
						if(50 to 55)
							spawntype = /mob/living/simple_animal/hostile/senior_shrimp
						if(55 to 100)
							spawntype = /mob/living/simple_animal/hostile/shrimp_rifleman
						else
							spawntype = /mob/living/simple_animal/hostile/shrimp


				if(8 to 11)
					switch(rand(1, 100))
						if(45 to 65)
							spawntype = /mob/living/simple_animal/hostile/senior_shrimp
						if(65 to 100)
							spawntype = /mob/living/simple_animal/hostile/shrimp_rifleman
						else
							spawntype = /mob/living/simple_animal/hostile/shrimp



				if(11 to 13)
					switch(rand(1, 100))
						if(45 to 55)
							spawntype = /mob/living/simple_animal/hostile/senior_shrimp
						if(55 to 75)
							spawntype = /mob/living/simple_animal/hostile/shrimp_soldier
						if(75 to 100)
							spawntype = /mob/living/simple_animal/hostile/shrimp_rifleman
						else
							spawntype = /mob/living/simple_animal/hostile/shrimp





				if(14 to INFINITY)
					switch(rand(1, 100))
						if(35 to 55)
							spawntype = /mob/living/simple_animal/hostile/senior_shrimp
						if(55 to 90)
							spawntype = /mob/living/simple_animal/hostile/shrimp_rifleman
						if(90 to 100)
							spawntype = /mob/living/simple_animal/hostile/shrimp_soldier
						else
							spawntype = /mob/living/simple_animal/hostile/shrimp


	var/mob/living/simple_animal/hostile/H = new spawntype(get_turf(src))
	H.can_patrol = TRUE
	H.patrol_cooldown_time = 10 SECONDS
	//If no one is alive, End round
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.z != z)
			continue
		if(L.stat != DEAD)
			return
	SSticker.force_ending = 1
	to_chat(world, span_userdanger("All W-Corp staff is dead! Round automatically ending."))

