// Green dawn
/mob/living/simple_animal/hostile/ordeal/green_bot
	name = "doubt"
	desc = "A slim robot with a spear in place of its hand."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "green_bot"
	icon_living = "green_bot"
	icon_dead = "green_bot_dead"
	faction = list("green_ordeal")
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 400
	health = 400
	speed = 2
	move_to_delay = 4
	melee_damage_lower = 22
	melee_damage_upper = 26
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/green/stab.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)

	/// Can't move/attack when it's TRUE
	var/finishing = FALSE

/mob/living/simple_animal/hostile/ordeal/green_bot/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot/AttackingTarget()
	. = ..()
	if(.)
		if(!istype(target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/TH = target
		if(TH.health < 0)
			finishing = TRUE
			TH.Stun(4 SECONDS)
			forceMove(get_turf(TH))
			for(var/i = 1 to 7)
				if(!targets_from.Adjacent(TH) || QDELETED(TH)) // They can still be saved if you move them away
					finishing = FALSE
					return
				TH.attack_animal(src)
				for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
					H.apply_damage(3, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				SLEEP_CHECK_DEATH(2)
			if(!targets_from.Adjacent(TH) || QDELETED(TH))
				finishing = FALSE
				return
			playsound(get_turf(src), 'sound/effects/ordeals/green/final_stab.ogg', 50, 1)
			TH.gib()
			for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
				H.apply_damage(20, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			finishing = FALSE

/mob/living/simple_animal/hostile/ordeal/green_bot/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/green_bot/spawn_dust()
	return

//Green dawn factory spawn
/mob/living/simple_animal/hostile/ordeal/green_bot/factory
	butcher_results = list()
	guaranteed_butcher_results = list()

/mob/living/simple_animal/hostile/ordeal/green_bot/factory/death(gibbed)
		density = FALSE
		animate(src, alpha = 0, time = 5 SECONDS)
		QDEL_IN(src, 5 SECONDS)
		..()

// Green noon
/mob/living/simple_animal/hostile/ordeal/green_bot_big
	name = "process of understanding"
	desc = "A big robot with a saw and a machinegun in place of its hands."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "green_bot"
	icon_living = "green_bot"
	icon_dead = "green_bot_dead"
	faction = list("green_ordeal")
	pixel_x = -8
	base_pixel_x = -8
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 900
	health = 900
	speed = 3
	move_to_delay = 6
	melee_damage_lower = 22 // Full damage is done on the entire turf of target
	melee_damage_upper = 26
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/effects/ordeals/green/saw.ogg'
	ranged = 1
	rapid = 8
	rapid_fire_delay = 3
	projectiletype = /obj/projectile/bullet/c9x19mm
	projectilesound = 'sound/effects/ordeals/green/fire.ogg'
	deathsound = 'sound/effects/ordeals/green/noon_dead.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)

	/// Can't move/attack when it's TRUE
	var/reloading = FALSE
	/// When at 10 - it will start "reloading"
	var/fire_count = 0

/mob/living/simple_animal/hostile/ordeal/green_bot_big/CanAttack(atom/the_target)
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/Move()
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/OpenFire(atom/A)
	if(reloading)
		return FALSE
	fire_count += 1
	if(fire_count >= 6)
		StartReloading()
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/AttackingTarget()
	. = ..()
	if(.)
		if(!istype(target, /mob/living))
			return
		var/turf/T = get_turf(target)
		for(var/i = 1 to 4)
			if(!T)
				return
			new /obj/effect/temp_visual/saw_effect(T)
			for(var/mob/living/L in T.contents)
				if(faction_check_mob(L))
					continue
				L.apply_damage(8, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/ordeal/green_bot_big/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/green_bot_big/spawn_dust()
	return

/mob/living/simple_animal/hostile/ordeal/green_bot_big/proc/StartReloading()
	reloading = TRUE
	icon_state = "green_bot_reload"
	playsound(get_turf(src), 'sound/effects/ordeals/green/cooldown.ogg', 50, FALSE)
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/green_noon_reload(get_turf(src))
		SLEEP_CHECK_DEATH(8)
	fire_count = 0
	reloading = FALSE
	icon_state = icon_living

//Green noon factory spawn
/mob/living/simple_animal/hostile/ordeal/green_bot_big/factory
	butcher_results = list()
	guaranteed_butcher_results = list()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/factory/death(gibbed)
		density = FALSE
		animate(src, alpha = 0, time = 5 SECONDS)
		QDEL_IN(src, 5 SECONDS)
		..()

// Green dusk
/mob/living/simple_animal/hostile/ordeal/green_dusk
	name = "where we must reach"
	desc = "A factory-like structure, constantly producing ancient robots."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "green_dusk"
	icon_living = "green_dusk"
	icon_dead = "green_dusk_dead"
	bound_width = 64 // 2x1
	faction = list("green_ordeal")
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 2500
	health = 2500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 2)

	var/spawn_progress = 18
	var/list/spawned_mobs = list()

/mob/living/simple_animal/hostile/ordeal/green_dusk/Initialize()
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/ordeal/green_dusk/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_dusk/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_dusk/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	update_icon()
	if(length(spawned_mobs) >= 9)
		return
	if(spawn_progress < 20)
		spawn_progress += 1
		return
	flick("green_dusk_create", src)
	spawn_progress = -5 // Basically, puts us on a tiny cooldown
	visible_message("<span class='danger'>\The [src] produces a new set of robots!</span>")
	for(var/i = 1 to 3)
		var/turf/T = get_step(get_turf(src), pick(0, EAST))
		var/picked_mob = pick(/mob/living/simple_animal/hostile/ordeal/green_bot/factory, /mob/living/simple_animal/hostile/ordeal/green_bot_big/factory)
		var/mob/living/simple_animal/hostile/ordeal/nb = new picked_mob(T)
		spawned_mobs += nb
		if(ordeal_reference)
			nb.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nb

/mob/living/simple_animal/hostile/ordeal/green_dusk/update_overlays()
	. = ..()
	if(spawn_progress <= 0 || stat == DEAD)
		cut_overlays()
		return

	var/mutable_appearance/progress_overlay = mutable_appearance(icon, "progress_1")
	switch(spawn_progress)
		if(1 to 4)
			progress_overlay.icon_state = "progress_1"
		if(5 to 8)
			progress_overlay.icon_state = "progress_2"
		if(9 to 12)
			progress_overlay.icon_state = "progress_3"
		if(13 to INFINITY)
			progress_overlay.icon_state = "progress_4"

	. += progress_overlay

/mob/living/simple_animal/hostile/ordeal/green_dusk/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/green_dusk/spawn_dust()
	return

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
	faction = list("green_ordeal")
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 50000
	health = 50000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 22)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 16)
	deathsound = 'sound/effects/ordeals/green/midnight_dead.ogg'

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
	addtimer(CALLBACK(src, .proc/OpenShell), 5 SECONDS)

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
		INVOKE_ASYNC(src, .proc/SetupLaser)

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
		addtimer(CALLBACK(src, .proc/PrepareLaser, L, new_angle), 0.5 SECONDS)
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
	INVOKE_ASYNC(src, .proc/LaserEffect)

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
