/mob/living/simple_animal/hostile/ordeal/amber_dusk
	name = "food chain"
	desc = "A big worm-like creature with jagged teeth at its front."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "amber_dusk"
	icon_living = "amber_dusk"
	icon_dead = "amber_dusk_dead"
	faction = list("amber_ordeal")
	maxHealth = 600
	health = 600
	speed = 4
	move_to_delay = 7
	density = FALSE
	status_flags = CANPUSH | MUST_HIT_PROJECTILE
	melee_damage_lower = 40
	melee_damage_upper = 45 // If you get hit by them it's a major skill issue
	pixel_x = -16
	base_pixel_x = -16
	butcher_results = list(/obj/item/food/meat/slab/worm = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 2)
	silk_results = list(/obj/item/stack/sheet/silk/amber_simple = 2, /obj/item/stack/sheet/silk/amber_advanced = 1)
	attack_verb_continuous = "eviscerates"
	attack_verb_simple = "eviscerate"
	attack_sound = 'sound/effects/ordeals/amber/dusk_attack.ogg'
	death_sound = 'sound/effects/ordeals/amber/dusk_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL
	should_projectile_blockers_change_orientation = TRUE
	occupied_tiles_up = 1
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = 0, "east" = -32)
	offsets_pixel_y = list("south" = 9, "north" = -20, "west" = 0, "east" = 0)

	/// This cooldown responds for both the burrowing and spawning in the dawns
	var/burrow_cooldown
	var/burrow_cooldown_time = 20 SECONDS

	/// If TRUE - cannot move nor attack
	var/burrowing = FALSE
	/// List of currently spawned dawns, so we don't create too many
	var/list/spawned_mobs = list()
	//If they can burrow or not.
	var/can_burrow = TRUE

	var/datum/looping_sound/amberdusk/soundloop

/mob/living/simple_animal/hostile/ordeal/amber_dusk/CanAttack(atom/the_target)
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Move()
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Goto(target, delay, minimum_distance)
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/DestroySurroundings()
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Initialize()
	. = ..()
	setDir(WEST)
	soundloop = new(list(src), TRUE)
	if(LAZYLEN(butcher_results))
		addtimer(CALLBACK(src, PROC_REF(BurrowOut), get_turf(src)))
	if(SSmaptype == "lcorp_city")
		can_burrow = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/OnDirChange(atom/thing, dir, newdir)
	. = ..()
	if(stat == DEAD)
		return
	var/static/matrix/add_vertical_transform = matrix(0.8, 1.4, MATRIX_SCALE)
	var/static/south_north = SOUTH | NORTH
	var/static/east_west = EAST | WEST
	var/combined = dir | newdir
	if((combined & south_north) && (combined & east_west))
		if(newdir & south_north)
			transform = add_vertical_transform
		else
			transform = matrix()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Destroy()
	QDEL_NULL(soundloop)
	for(var/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/bug as anything in spawned_mobs)
		bug.bug_mommy = null
	spawned_mobs = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(can_burrow)
		if(!burrowing && world.time > burrow_cooldown)
			AttemptBirth()
			BurrowIn()

//Can only attack near the mouth
/mob/living/simple_animal/hostile/ordeal/amber_dusk/AttackCondition(atom/attack_target)
	var/relative_angle = abs(dir2angle(dir) - dir2angle(get_dir(src, attack_target)))
	relative_angle = relative_angle > 180 ? 360 - relative_angle : relative_angle
	if(relative_angle > 90)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/death(gibbed)
	if(LAZYLEN(butcher_results))
		alpha = 255
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	offsets_pixel_y = list("south" = 0, "north" = 0, "west" = 0, "east" = 0)
	transform = matrix()
	soundloop.stop()
	for(var/mob/living/simple_animal/hostile/ordeal/amber_bug/bug in spawned_mobs)
		bug.can_burrow_solo = TRUE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/revive(full_heal, admin_revive)
	. = ..()
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = 0, "east" = -32)
	offsets_pixel_y = list("south" = 9, "north" = -20, "west" = 0, "east" = 0)
	density = TRUE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/AttemptBirth()
	var/max_spawn = clamp(length(GLOB.clients) * 2, 4, 8)
	if(length(spawned_mobs) >= max_spawn)
		return FALSE

	burrowing = TRUE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_create.ogg', 50, FALSE)
	SLEEP_CHECK_DEATH(5)
	visible_message(span_danger("Four smaller bugs emerge from [src]!"))
	for(var/i = 1 to 4)
		var/turf/Turf = get_step(get_turf(src), pick(0, NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		if(Turf.density) // Retry
			i -= 1
			continue

		var/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/bug = new(Turf)
		spawned_mobs += bug
		bug.bug_mommy = src
		if(ordeal_reference)
			bug.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += bug

	SLEEP_CHECK_DEATH(5)
	burrowing = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/BurrowIn()
	burrowing = TRUE
	var/turf/T = pick(GLOB.xeno_spawn)
	if(!T)
		T = get_turf(src)
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_dig_in.ogg', 50, 1)
	animate(src, alpha = 0, time = 10)
	SLEEP_CHECK_DEATH(5)
	for(var/mob/living/simple_animal/hostile/ordeal/amber_bug/bug as anything in spawned_mobs)
		addtimer(CALLBACK(bug, PROC_REF(BurrowIn), T))
	SLEEP_CHECK_DEATH(5)
	density = FALSE
	forceMove(T)
	BurrowOut(T)

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/BurrowOut(turf/T)
	burrowing = TRUE
	alpha = 0
	density = FALSE
	for(var/turf/open/OT in range(1, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(OT)

	animate(src, alpha = 255, time = 5)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_dig_out.ogg', 50, 1)
	visible_message(span_bolddanger("[src] burrows out from the ground!"))
	SLEEP_CHECK_DEATH(5)
	density = TRUE
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, src)
	animate(D, alpha = 0, transform = matrix()*1.5, time = 5)
	for(var/mob/living/L in view(1, src))
		if(!faction_check_mob(L))
			L.apply_damage(25, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))

	burrow_cooldown = world.time + burrow_cooldown_time
	burrowing = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned
	butcher_results = list()
	guaranteed_butcher_results = list()
	var/mob/living/simple_animal/hostile/ordeal/amber_midnight/bug_daddy

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/Initialize()
	burrow_cooldown = world.time + burrow_cooldown_time
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/Destroy()
	if(bug_daddy)
		bug_daddy.spawned_mobs -= src
	bug_daddy = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	return ..()
