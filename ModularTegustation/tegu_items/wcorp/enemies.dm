/mob/living/simple_animal/hostile/ordeal/steel_dawn/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/patrol
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
	spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/patrol
	switch(GLOB.combat_counter)
		if(1 to 4)
			if(prob(10))
				spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
		if(10 to INFINITY)
			switch(rand(1, 100))
				if(50 to 75)
					spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
				if(75 to 90)
					spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/patrol
				if(90 to 100)
					spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dusk

	new spawntype(get_turf(src))
	//If no one is alive, End round
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z != z)
			continue
		if(H.stat != DEAD)
			return
	SSticker.force_ending = 1
	to_chat(world, "<span class='userdanger'>All W-Corp staff is dead! Round automatically ending.</span>")

