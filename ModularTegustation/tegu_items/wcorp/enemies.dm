GLOBAL_VAR_INIT(wcorp_boss_spawn, FALSE)

//GCORP
/mob/living/simple_animal/hostile/ordeal/steel_dawn/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

//LOVETOWN
/mob/living/simple_animal/hostile/lovetown/suicidal/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/lovetown/slasher/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/lovetown/stabber/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/lovetown/slammer/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/lovetown/shambler/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/lovetown/slumberer/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/lovetown/abomination/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/obj/effect/landmark/wavespawn
	name = "wave spawner"
	desc = "It spawns an enemy wave. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x3"
	var/spawntype

/obj/effect/landmark/wavespawn/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/tryspawn), 3 MINUTES, TIMER_STOPPABLE)

//Wave increases.
/obj/effect/landmark/wavespawn/proc/tryspawn()
	addtimer(CALLBACK(src, .proc/tryspawn), 1 MINUTES, TIMER_STOPPABLE)
	if(GLOB.combat_counter == 0)
		return
	switch(GLOB.wcorp_enemy_faction) //Each round has a specific faction, decided on code/game/gamemodes/management/event/combat

		if("gcorp")
			spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/patrol
			switch(GLOB.combat_counter)

				//10% Remnant / 90% Corporal
				if(1 to 5)
					if(prob(10))
						spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol

				//50% Remnant / 25% Corporal / 25% Aerial Scout
				if(6 to 14)
					switch(rand(1, 100))
						if(50 to 75)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
						if(75 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/patrol
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/patrol

				//50% Remnant / 25% Corporal / 15% Aerial Scout / 10% Manager
				if(15 to INFINITY)
					switch(rand(1, 100))
						if(50 to 75)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
						if(75 to 90)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/patrol
						if(90 to 100)
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dusk
						else
							spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/patrol

		if("lovetown")
			spawntype = /mob/living/simple_animal/hostile/lovetown/suicidal/patrol
			switch(GLOB.combat_counter)

				//50% Suicidal / 25% Slasher / 25% Stabber
				if(1 to 2)
					switch(rand(1,100))
						if(50 to 75)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher/patrol
						if(75 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber/patrol
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/suicidal/patrol

				//45% Slasher / 45% Stabber / 10% Slammer
				if(3 to 5)
					switch(rand(1,100))
						if(10 to 55)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher/patrol
						if(55 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber/patrol
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/slammer/patrol

				//25% Slasher / 25% Stabber / 20% Slammer / 15% Shambler / 15% Slumberer
				if(6 to 12)
					switch(rand(1, 100))
						if(15 to 40)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher/patrol
						if(40 to 65)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber/patrol
						if(65 to 85)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slammer/patrol
						if(85 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/shambler/patrol
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/slumberer/patrol

				//100% one Abomination, rest 20% Slashers / 20% Stabbers / 60% Suicidals
				if(13 to 14)
					if(!GLOB.wcorp_boss_spawn)
						GLOB.wcorp_boss_spawn = TRUE
							spawntype = /mob/living/simple_animal/hostile/lovetown/abomination/patrol
					else
						switch(rand(1,100))
							if(60 to 80)
								spawntype = /mob/living/simple_animal/hostile/lovetown/slasher/patrol
							if(80 to 100)
								spawntype = /mob/living/simple_animal/hostile/lovetown/stabber/patrol
							else
								spawntype = /mob/living/simple_animal/hostile/lovetown/suicidal/patrol

				//20% Slasher / 20% Stabber / 20% Slammer / 20% Shambler / 20% Slumberer
				if(15 to INFINITY)
					switch(rand(1, 100))
						if(20 to 40)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slasher/patrol
						if(40 to 60)
							spawntype = /mob/living/simple_animal/hostile/lovetown/stabber/patrol
						if(60 to 80)
							spawntype = /mob/living/simple_animal/hostile/lovetown/slammer/patrol
						if(80 to 100)
							spawntype = /mob/living/simple_animal/hostile/lovetown/shambler/patrol
						else
							spawntype = /mob/living/simple_animal/hostile/lovetown/slumberer/patrol

	new spawntype(get_turf(src))
	//If no one is alive, End round
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat != DEAD)
			return
	SSticker.force_ending = 1
	to_chat(world, "<span class='userdanger'>All W-Corp staff is dead! Round automatically ending.</span>")

