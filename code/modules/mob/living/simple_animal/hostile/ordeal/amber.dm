// Amber dawn
/mob/living/simple_animal/hostile/ordeal/amber_bug
	name = "complete food"
	desc = "A tiny worm-like creature with tough chitin and a pair of sharp claws."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "amber_bug"
	icon_living = "amber_bug"
	icon_dead = "amber_bug_dead"
	faction = list("amber_ordeal")
	maxHealth = 80
	health = 80
	speed = 2
	rapid_melee = 2
	density = FALSE
	melee_damage_lower = 4
	melee_damage_upper = 6
	turns_per_move = 2
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL
	butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	silk_results = list(/obj/item/stack/sheet/silk/amber_simple = 1)

/mob/living/simple_animal/hostile/ordeal/amber_bug/Initialize()
	. = ..()
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/ordeal/amber_bug/AttackingTarget()
	. = ..()
	if(.)
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		animate(src, pixel_y = (base_pixel_y + 18), time = 2)
		addtimer(CALLBACK(src, PROC_REF(AnimateBack)), 2)
		for(var/i = 1 to 2)
			var/turf/T = get_step(get_turf(src), dir_to_target)
			if(T.density)
				return
			if(locate(/obj/structure/window) in T.contents)
				return
			for(var/obj/machinery/door/D in T.contents)
				if(D.density)
					return
			forceMove(T)
			SLEEP_CHECK_DEATH(2)

/mob/living/simple_animal/hostile/ordeal/amber_bug/proc/AnimateBack()
	animate(src, pixel_y = base_pixel_y, time = 2)
	return TRUE

//Amber dawn spawned from dusk
/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned
	butcher_results = list()
	guaranteed_butcher_results = list()

/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

// Amber dusk
/mob/living/simple_animal/hostile/ordeal/amber_dusk
	name = "food chain"
	desc = "A big worm-like creature with giant teeth at the front."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "amber_dusk"
	icon_living = "amber_dusk"
	icon_dead = "amber_dusk_dead"
	faction = list("amber_ordeal")
	maxHealth = 2200
	health = 2200
	speed = 4
	move_to_delay = 7
	density = FALSE
	melee_damage_lower = 100
	melee_damage_upper = 115 // If you get hit by them it's a major skill issue
	pixel_x = -16
	base_pixel_x = -16
	butcher_results = list(/obj/item/food/meat/slab/worm = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 2)
	attack_verb_continuous = "eviscerates"
	attack_verb_simple = "eviscerate"
	attack_sound = 'sound/effects/ordeals/amber/dusk_attack.ogg'
	death_sound = 'sound/effects/ordeals/amber/dusk_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL

	alpha = 0 // It burrows in on spawn
	density = FALSE

	/// This cooldown responds for both the burrowing and spawning in the dawns
	var/burrow_cooldown
	var/burrow_cooldown_time = 18 SECONDS

	/// If TRUE - cannot move nor attack
	var/burrowing = TRUE
	/// List of currently spawned dawns, so we don't create too many
	var/list/spawned_mobs = list()

	var/datum/looping_sound/amberdusk/soundloop

/mob/living/simple_animal/hostile/ordeal/amber_dusk/CanAttack(atom/the_target)
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Move()
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(BurrowOut), get_turf(src)))
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(world.time > burrow_cooldown)
		burrow_cooldown = world.time + burrow_cooldown_time
		AttemptBirth()
		BurrowIn()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/death(gibbed)
	if(LAZYLEN(butcher_results))
		alpha = 255
	soundloop.stop()
	..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/AttemptBirth()
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD)
			spawned_mobs -= L
	var/max_spawn = clamp(GLOB.clients.len * 5, 5, 25)
	if(length(spawned_mobs) >= max_spawn)
		return
	visible_message(span_danger("Five smaller bugs appear out of [src]!"))
	for(var/i = 1 to 5)
		var/turf/T = get_step(get_turf(src), pick(0, NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		if(T.density) // Retry
			i -= 1
			continue
		var/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/nb = new(T)
		spawned_mobs += nb
		if(ordeal_reference)
			nb.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nb

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/BurrowIn()
	burrowing = TRUE
	density = FALSE
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_dig_in.ogg', 50, 1)
	animate(src, alpha = 0, time = 5)
	for(var/turf/open/OT in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(OT)
	SLEEP_CHECK_DEATH(5)
	var/turf/T = pick(GLOB.xeno_spawn)
	BurrowOut(T)

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/BurrowOut(turf/T)
	forceMove(T)
	for(var/turf/open/OT in range(1, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(OT)
	animate(src, alpha = 255, time = 5)
	SLEEP_CHECK_DEATH(5)
	density = TRUE
	visible_message(span_danger("[src] burrows out from the ground!"))
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_dig_out.ogg', 50, 1)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, src)
	animate(D, alpha = 0, transform = matrix()*1.5, time = 5)
	for(var/mob/living/L in view(1, src))
		if(!faction_check_mob(L))
			L.apply_damage(75, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	burrowing = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned
	butcher_results = list()
	guaranteed_butcher_results = list()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

// Amber midnight
/mob/living/simple_animal/hostile/ordeal/amber_midnight
	name = "eternal meal"
	desc = "A giant insect-like creature with a ton of sharp rocky teeth."
	health = 15000
	maxHealth = 15000
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "ambermidnight"
	icon_living = "ambermidnight"
	icon_dead = "ambermidnight_dead"
	faction = list("amber_ordeal")

	light_color = COLOR_YELLOW
	light_range = 4
	light_power = 1

	density = FALSE
	alpha = 0
	pixel_x = -96
	base_pixel_x = -96
	pixel_y = -16
	base_pixel_y = -16

	blood_volume = BLOOD_VOLUME_NORMAL
	death_sound = 'sound/effects/ordeals/amber/midnight_dead.ogg'

	var/burrowing = FALSE
	var/burrow_cooldown
	var/burrow_cooldown_time = 20 SECONDS
	var/list/spawned_mobs = list()

	var/datum/looping_sound/ambermidnight/soundloop

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Initialize()
	. = ..()
	burrow_cooldown = world.time + 20 SECONDS
	soundloop = new(list(src), TRUE)
	addtimer(CALLBACK(src, PROC_REF(BurrowOut)))

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/death(gibbed)
	alpha = 255
	soundloop.stop()
	..()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!burrowing && world.time > burrow_cooldown)
		BurrowIn()
		return

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/AttemptBirth()
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD)
			spawned_mobs -= L
	var/max_spawn = clamp(GLOB.clients.len * 0.6, 2, 8)
	if(length(spawned_mobs) >= max_spawn)
		return FALSE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_create.ogg', 50, FALSE)
	visible_message(span_danger("Two large bugs appear out of [src]!"))
	for(var/i = 1 to 2)
		var/turf/T = get_step(get_turf(src), pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/nb = new(T)
		spawned_mobs += nb
		if(ordeal_reference)
			nb.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nb
	return TRUE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/BurrowIn()
	if(AttemptBirth())
		SLEEP_CHECK_DEATH(2 SECONDS)
	burrowing = TRUE
	density = FALSE
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(src, 'sound/effects/ordeals/amber/midnight_in.ogg', 50, FALSE, 7)
	animate(src, alpha = 0, time = 7)
	for(var/turf/open/OT in range(2, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(OT)
	icon_state = "ambermidnight_leave"
	new /obj/effect/temp_visual/ambermidnight_hole(get_turf(src))
	var/list/centers = GLOB.department_centers.Copy()
	centers -= get_turf(src)
	for(var/turf/T in centers)
		if(locate(type) in T) // Found another amber midnight there
			centers -= T
	SLEEP_CHECK_DEATH(7)
	for(var/turf/T in centers) // We do it twice in case something changed in that time
		if(locate(type) in T)
			centers -= T
	if(!LAZYLEN(centers))
		return
	var/turf/T = pick(centers)
	forceMove(T)
	BurrowOut()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/BurrowOut()
	alpha = 0
	density = FALSE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out_far.ogg', 50, TRUE, 4)
	for(var/i = 1 to 2)
		for(var/turf/open/T in view(3, get_turf(src)))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		SLEEP_CHECK_DEATH(2)
	animate(src, pixel_z = 0, alpha = 255, time = 6)
	icon_state = "ambermidnight_bite"
	SLEEP_CHECK_DEATH(4)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out.ogg', 75, FALSE, 7)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out_far.ogg', 25, FALSE, 24, 2, falloff_distance = 9)
	SLEEP_CHECK_DEATH(2)
	density = TRUE
	visible_message(span_danger("[src] burrows out from the ground!"))
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*1.25, time = 3)
	SLEEP_CHECK_DEATH(2)
	for(var/turf/open/T in view(7, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in view(7, src))
		if(faction_check_mob(L))
			continue
		var/distance_decrease = get_dist(src, L) * 75
		L.apply_damage((1000 - distance_decrease), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
		if(L.health < 0)
			L.gib()
	SLEEP_CHECK_DEATH(5)
	burrow_cooldown = world.time + burrow_cooldown_time
	burrowing = FALSE
	icon_state = icon_living
