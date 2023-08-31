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
	var/waveno
	var/spawntype

/obj/effect/landmark/wavespawn/Initialize()
	..()
//	addtimer(CALLBACK(src, .proc/tryspawn), 3 MINUTES, TIMER_STOPPABLE)
	addtimer(CALLBACK(src, .proc/tryspawn), 3 MINUTES, TIMER_STOPPABLE)

//Wave increases.
/obj/effect/landmark/wavespawn/proc/tryspawn()
	addtimer(CALLBACK(src, .proc/tryspawn), 1 MINUTES, TIMER_STOPPABLE)
	waveno += 1
	spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/patrol
	switch(waveno)
		if(5 to 20)
			if(prob(30))
				spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
		if(10 to 20)
			if(prob(15))
				spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/patrol
		if(15 to 20)
			if(prob(3))
				spawntype = /mob/living/simple_animal/hostile/ordeal/steel_dusk
	new spawntype(get_turf(src))
	//If no one is alive, End round
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD)
			return
	SSticker.force_ending = 1
	to_chat(world, "<span class='userdanger'>All W-Corp staff is dead! Round automatically ending.</span>")

