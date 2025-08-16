/mob/living/simple_animal/hostile/ordeal/green_dusk
	name = "where we must reach"
	desc = "A factory-like structure, constantly producing ancient robots."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "green_dusk_1"
	icon_living = "green_dusk_1"
	icon_dead = "green_dusk_dead"
	layer = LYING_MOB_LAYER
	occupied_tiles_right = 1
	faction = list("green_ordeal")
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 3000
	health = 3000
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	silk_results = list(/obj/item/stack/sheet/silk/green_elegant = 1,
						/obj/item/stack/sheet/silk/green_advanced = 2,
						/obj/item/stack/sheet/silk/green_simple = 4)
	death_sound = 'sound/effects/ordeals/green/dusk_dead.ogg'
	var/spawn_progress = 18 //spawn ready to produce robots
	var/list/spawned_mobs = list()
	var/producing = FALSE

/mob/living/simple_animal/hostile/ordeal/green_dusk/Initialize(mapload)
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/head_trophy/green_datachip = 1)

/mob/living/simple_animal/hostile/ordeal/green_dusk/Initialize()
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/ordeal/green_dusk/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_dusk/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_dusk/death(gibbed)
	icon = initial(icon)
	..()

/mob/living/simple_animal/hostile/ordeal/green_dusk/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	if(producing)
		return
	update_icon()
	if(length(spawned_mobs) >= 9)
		return
	if(spawn_progress < 20)
		spawn_progress += 1
		return
	Produce()

/mob/living/simple_animal/hostile/ordeal/green_dusk/proc/Produce()
	if(producing || stat == DEAD)
		return
	producing = TRUE
	icon = 'ModularTegustation/Teguicons/96x48.dmi'
	icon_state = "green_dusk_create"
	SLEEP_CHECK_DEATH(6)
	visible_message(span_danger("\The [src] produces a new set of robots!"))
	for(var/i = 1 to 3)
		var/turf/T = get_step(get_turf(src), pick(0, EAST))
		var/picked_mob = /mob/living/simple_animal/hostile/ordeal/green_bot_big/factory

		// 50% for a little shitter
		if(prob(50))
			picked_mob = pick(
				/mob/living/simple_animal/hostile/ordeal/green_bot/factory,
				/mob/living/simple_animal/hostile/ordeal/green_bot/syringe/factory,
				/mob/living/simple_animal/hostile/ordeal/green_bot/fast/factory,)

		var/mob/living/simple_animal/hostile/ordeal/nb = new picked_mob(T)
		spawned_mobs += nb
		if(ordeal_reference)
			nb.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nb
		SLEEP_CHECK_DEATH(1)
	SLEEP_CHECK_DEATH(2)
	icon = initial(icon)
	producing = FALSE
	spawn_progress = -5 // Basically, puts us on a tiny cooldown
	update_icon()

/mob/living/simple_animal/hostile/ordeal/green_dusk/update_icon_state()
	if(stat == DEAD)
		return
	switch(spawn_progress)
		if(-INFINITY to 4)
			icon_state = "green_dusk_1"
		if(5 to 9)
			icon_state = "green_dusk_2"
		if(10 to 14)
			icon_state = "green_dusk_3"
		if(15 to INFINITY)
			icon_state = "green_dusk_4"

/mob/living/simple_animal/hostile/ordeal/green_dusk/update_overlays()
	. = ..()
	if(spawn_progress <= 0 || stat == DEAD)
		cut_overlays()
		return

	var/mutable_appearance/progress_overlay = mutable_appearance(icon, "progress_1")
	switch(spawn_progress)
		if(1 to 4)
			progress_overlay.icon_state = "progress_1"
		if(5 to 9)
			progress_overlay.icon_state = "progress_2"
		if(10 to 14)
			progress_overlay.icon_state = "progress_3"
		if(15 to INFINITY)
			progress_overlay.icon_state = "progress_4"

	. += progress_overlay

/mob/living/simple_animal/hostile/ordeal/green_dusk/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/green_dusk/spawn_dust()
	return

//Green noon factory spawn
/mob/living/simple_animal/hostile/ordeal/green_bot_big/factory
	butcher_results = list()
	guaranteed_butcher_results = list()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/factory/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()
