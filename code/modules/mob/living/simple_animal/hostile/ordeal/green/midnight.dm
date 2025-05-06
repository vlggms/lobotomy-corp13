// Green midnight
/mob/living/simple_animal/hostile/ordeal/green_midnight
	name = "helix of the end"
	desc = "A colossal metallic structure with a large amount of laser weaponry beneath its shell."
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "greenmidnight"
	icon_living = "greenmidnight"
	icon_dead = "greenmidnight_dead"
	layer = LYING_MOB_LAYER
	pixel_x = -96
	base_pixel_x = -96
	occupied_tiles_left = 2
	occupied_tiles_right = 2
	occupied_tiles_up = 2
	faction = list("green_ordeal")
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 50000
	health = 50000
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 22)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 16)
	death_sound = 'sound/effects/ordeals/green/midnight_dead.ogg'
	offsets_pixel_x = list("south" = -96, "north" = -96, "west" = -96, "east" = -96)
	damage_effect_scale = 1.25

	var/laser_cooldown
	var/laser_cooldown_time = 20 SECONDS
	var/obj/effect/greenmidnight_shell/left_shell
	var/obj/effect/greenmidnight_shell/right/right_shell
	/// Assoc list. Effect = Target turf
	var/list/lasers = list()
	var/list/beams = list()
	var/list/hit_line = list()
	/// Amount of black damage per damage tick dealt to all living enemies
	var/laser_damage = 75
	var/max_lasers = 6
	/// Amount of damage ticks laser will do
	var/max_laser_repeats = 40
	var/firing = FALSE
	var/datum/looping_sound/greenmidnight_laser/laserloop
	var/laser_spawn_delay = 1 SECONDS
	var/laser_rotation_time = 2 SECONDS
	/// Below that health the green midnight speeds up
	var/next_health_mark = 0 // Initialize below

/mob/living/simple_animal/hostile/ordeal/green_midnight/Initialize()
	. = ..()
	left_shell = new(get_turf(src))
	right_shell = new(get_turf(src))
	laser_cooldown = world.time + 6 SECONDS
	next_health_mark = maxHealth * 0.9
	laserloop = new(list(src), FALSE)
	addtimer(CALLBACK(src, PROC_REF(OpenShell)), 5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/green_midnight/Destroy()
	QDEL_NULL(left_shell)
	QDEL_NULL(right_shell)
	QDEL_NULL(laserloop)
	for(var/atom/A in lasers)
		QDEL_NULL(A)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_midnight/death()
	QDEL_NULL(left_shell)
	QDEL_NULL(right_shell)
	QDEL_NULL(laserloop)
	for(var/atom/A in lasers)
		QDEL_NULL(A)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_midnight/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(stat == DEAD)
		return
	if(health <= next_health_mark)
		next_health_mark -= maxHealth * 0.1
		max_lasers += 2
		laser_spawn_delay = max(0.3 SECONDS, laser_spawn_delay - 0.1 SECONDS)
		laser_rotation_time = max(0.5 SECONDS, laser_rotation_time - 0.2 SECONDS)
		laser_cooldown_time = max(10 SECONDS, laser_cooldown_time - 1 SECONDS)

/mob/living/simple_animal/hostile/ordeal/green_midnight/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_midnight/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(firing)
		return FALSE
	if(world.time > laser_cooldown)
		INVOKE_ASYNC(src, PROC_REF(SetupLaser))

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/OpenShell()
	animate(left_shell, pixel_x = base_pixel_x - 24, time = 4 SECONDS, easing = QUAD_EASING)
	animate(right_shell, pixel_x = base_pixel_x + 24, time = 4 SECONDS, easing = QUAD_EASING)
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_gears.ogg', 50, FALSE, 7)

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/CloseShell()
	animate(left_shell, pixel_x = base_pixel_x, time = 2 SECONDS, easing = QUAD_EASING)
	animate(right_shell, pixel_x = base_pixel_x, time = 2 SECONDS, easing = QUAD_EASING)
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_gears_fast.ogg', 50, FALSE, 7)

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/SetupLaser()
	firing = TRUE
	OpenShell()
	SLEEP_CHECK_DEATH(2 SECONDS)
	var/new_angle = rand(0, 360)
	for(var/i = 1 to max_lasers)
		var/obj/effect/greenmidnight_laser/L = new(get_turf(src))
		lasers[L] = get_turf_in_angle(new_angle, get_turf(src), 64)
		playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_laser_new.ogg', 50 + 5 * (i - max_lasers), FALSE)
		addtimer(CALLBACK(src, PROC_REF(PrepareLaser), L, new_angle), 0.5 SECONDS)
		var/old_angle = new_angle
		for(var/attempt = 1 to 3) // Just so that we don't get ourselves absolutely the same angle twice in a row
			new_angle = rand(0, 360)
			if((new_angle > old_angle + 15) || (new_angle < old_angle - 15))
				break
		SLEEP_CHECK_DEATH(laser_spawn_delay)
	SLEEP_CHECK_DEATH(laser_rotation_time)
	FireLaser()

// Rotate the laser and creates a warning beam
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/PrepareLaser(obj/effect/greenmidnight_laser/L, l_angle)
	if(stat == DEAD || QDELETED(L))
		return
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_gears_fast.ogg', 15, TRUE)
	animate(L, transform = turn(matrix(), l_angle), time = laser_rotation_time)
	SLEEP_CHECK_DEATH(laser_rotation_time * 0.75)
	var/turf/T = get_turf(src)
	var/datum/beam/B = T.Beam(lasers[L], "n_beam")
	beams += B
	B.visuals.alpha = 0
	animate(B.visuals, alpha = 255, time = 3)

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/FireLaser()
	if(stat == DEAD)
		return
	for(var/datum/beam/B in beams)
		B.visuals.icon_state = "sat_beam" // WARNING, YOU ARE ABOUT TO DIE!!!
		var/matrix/M = matrix()
		M.Scale(9, 1)
		animate(B.visuals, transform = M, time = 15)
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_laser_prepare.ogg', 75, FALSE, 14)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	sound_to_playing_players_on_level('sound/effects/ordeals/green/midnight_laser_warning.ogg', 75, zlevel = z)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	sound_to_playing_players_on_level('sound/effects/ordeals/green/midnight_laser_fire.ogg', 100, zlevel = z)
	var/turf/T = get_turf(src)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	hit_line = list()
	for(var/obj/effect/greenmidnight_laser/L in lasers)
		L.icon_state = "greenmidnight_laser_firing"
		var/datum/beam/B = T.Beam(lasers[L], "green_beam")
		var/matrix/M = matrix()
		M.Scale(3, 1)
		B.visuals.transform = M
		beams += B
		hit_line |= getline(T, lasers[L])
	INVOKE_ASYNC(src, PROC_REF(LaserEffect))

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/LaserEffect()
	if(stat == DEAD)
		return
	laserloop.start()
	for(var/i = 1 to max_laser_repeats)
		var/list/already_hit = list()
		for(var/turf/T in hit_line)
			for(var/mob/living/L in range(1, T))
				if(L.status_flags & GODMODE)
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				if(faction_check_mob(L))
					continue
				already_hit += L
				L.apply_damage(laser_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		SLEEP_CHECK_DEATH(0.25 SECONDS)
	StopLaser()

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/StopLaser()
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_laser_end.ogg', 75, FALSE, 24)
	laserloop.stop()
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	for(var/atom/A in lasers)
		animate(A, alpha = 0, time = 1 SECONDS)
		QDEL_IN(A, (1 SECONDS))
	lasers = list()
	SLEEP_CHECK_DEATH(2 SECONDS)
	CloseShell()
	laser_cooldown = world.time + laser_cooldown_time
	firing = FALSE

/mob/living/simple_animal/hostile/ordeal/green_midnight/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/green_midnight/spawn_dust()
	return
