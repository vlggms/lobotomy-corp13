/obj/effect/landmark/factory_enemy
	name = "wave spawner"
	desc = "It spawns an enemy wave. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x3"
	var/difficulty

/obj/effect/landmark/factory_enemy/Initialize()
	addtimer(CALLBACK(src, PROC_REF(tryspawn)), 7 MINUTES, TIMER_STOPPABLE)
	return ..()

/obj/effect/landmark/factory_enemy/proc/tryspawn()
	addtimer(CALLBACK(src, PROC_REF(tryspawn)), 7 MINUTES, TIMER_STOPPABLE)
	var/mob_counter = 0
	for(var/mob/living/simple_animal/hostile/H in GLOB.mob_list)
		mob_counter++
	if(mob_counter > GLOB.rcorp_factorymax)
		return
	var/mob/living/simple_animal/hostile/to_spawn

	switch(difficulty)
		if(1 to 3)
			to_spawn = pick(
				/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
				/mob/living/simple_animal/hostile/ordeal/indigo_dawn/invis,
				/mob/living/simple_animal/hostile/ordeal/indigo_dawn/skirmisher,)
		if(4 to 6)
			to_spawn = /mob/living/simple_animal/hostile/ordeal/indigo_noon

		if(7 to INFINITY)
			if(prob(70))
				to_spawn = /mob/living/simple_animal/hostile/ordeal/indigo_noon

			else
				to_spawn = pick(
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red,
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white,
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black,
					/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale,)

	difficulty++
	var/mob/living/simple_animal/hostile/spawned_enemy = new to_spawn(get_turf(src))
	spawned_enemy.can_patrol = TRUE
	spawned_enemy.del_on_death = TRUE
