/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk
	name = "struggle of the peak"
	desc = "A round clown amalgamation holding a hammer and an axe."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "crimson_dusk"
	icon_living = "crimson_dusk"
	icon_dead = "crimson_dusk_dead"
	faction = list("crimson_ordeal")
	maxHealth = 800
	health = 800
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_lower = 12
	melee_damage_upper = 14
	move_to_delay = 5
	ranged = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/effects/ordeals/crimson/dusk_attack.ogg'
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	mob_spawn_amount = 2

	var/roll_num = 36
	var/roll_cooldown
	var/roll_cooldown_time = 10 SECONDS
	var/charging = FALSE
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/CanAttack(atom/the_target)
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/DeathExplosion(gibbed = FALSE)
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/dusk_dead.ogg', 50, 1)
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	for(var/i = 1 to mob_spawn_amount)
		var/turf/T = get_step(get_turf(src), pick(valid_directions))
		var/mob/living/simple_animal/hostile/ordeal/crimson_noon/nc = new(T)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	if(!gibbed)
		can_be_gibbed = TRUE
		gib()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/OpenFire()
	if(client)
		clown_roll(target)
		return

	if(roll_cooldown <= world.time)
		var/chance_to_roll = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_roll = 100
		if(prob(chance_to_roll))
			clown_roll(target)

// Godless copy-paste from all-around helper
/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/proc/clown_roll(target)
	if(charging || roll_cooldown > world.time)
		return
	icon_state = "crimson_dusk_roll"
	roll_cooldown = world.time + roll_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	animate(src, pixel_y = -16, time = 3)
	do_roll(dir_to_target, 0)

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/proc/do_roll(move_dir, times_ran)
	var/stop_charge = FALSE
	if(stat == DEAD)
		icon_state = icon_dead
		charging = FALSE
		animate(src, pixel_y = base_pixel_y, time = 3)
		return
	if(times_ran >= roll_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		animate(src, pixel_y = base_pixel_y, time = 3)
		return
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("spinning clown")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			stop_charge = TRUE
	if(stop_charge)
		SLEEP_CHECK_DEATH(2 SECONDS)
		icon_state = icon_living
		charging = FALSE
		animate(src, pixel_y = base_pixel_y, time = 3)
		return
	forceMove(T)
	var/para = TRUE
	if(move_dir in list(WEST, NORTHWEST, SOUTHWEST))
		para = FALSE
	SpinAnimation(2, 1, para)
	playsound(src, 'sound/effects/ordeals/crimson/dusk_move.ogg', 50, 1)
	for(var/mob/living/L in range(1, T))
		if(!faction_check_mob(L))
			if(L in been_hit)
				continue
			visible_message(span_boldwarning("[src] rolls past [L]!"))
			to_chat(L, span_userdanger("[src] rolls past you!"))
			var/turf/LT = get_turf(L)
			new /obj/effect/temp_visual/kinetic_blast(LT)
			L.apply_damage(20, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			if(!(L in been_hit))
				been_hit += L
	addtimer(CALLBACK(src, PROC_REF(do_roll), move_dir, (times_ran + 1)), 1.5)
