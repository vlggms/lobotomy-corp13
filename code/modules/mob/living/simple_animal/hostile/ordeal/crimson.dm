// Crimson dawn
/mob/living/simple_animal/hostile/ordeal/crimson_clown
	name = "cheers for the start"
	desc = "A tiny humanoid creature in jester's attire."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "crimson_clown"
	icon_living = "crimson_clown"
	icon_dead = "crimson_clown_dead"
	faction = list("crimson_ordeal")
	maxHealth = 100
	health = 100
	speed = 1
	density = FALSE
	search_objects = 3
	wanted_objects = list(/obj/machinery/computer/abnormality)
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL

	/// When it hits console 12 times - reduce qliphoth and teleport
	var/console_attack_counter = 0
	var/teleporting = FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!target && prob(25))
		TeleportAway()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/CanAttack(atom/the_target)
	if(istype(the_target, /obj/machinery/computer/abnormality))
		var/obj/machinery/computer/abnormality/CA = the_target
		if(CA.meltdown || !CA.datum_reference || !CA.datum_reference.current || !CA.datum_reference.qliphoth_meter)
			return FALSE
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/AttackingTarget()
	if(istype(target, /obj/machinery/computer/abnormality))
		var/obj/machinery/computer/abnormality/CA = target
		if(console_attack_counter < 12)
			console_attack_counter += 1
			visible_message(span_warning("[src] hits [CA]'s buttons at random!"))
			playsound(get_turf(CA), "sound/machines/terminal_button0[rand(1,8)].ogg", 50, 1)
			changeNext_move(CLICK_CD_MELEE * 2)
		else
			console_attack_counter = 0
			visible_message(span_warning("[CA]'s screen produces an error!"))
			playsound(get_turf(CA), 'sound/machines/terminal_error.ogg', 50, 1)
			CA.datum_reference.qliphoth_change(-1, src)
			TeleportAway()
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/death(gibbed)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion), ordeal_reference), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/TeleportAway()
	if(teleporting)
		return
	teleporting = TRUE
	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/CA in GLOB.lobotomy_devices)
		if(!CanTeleportTo(CA))
			continue
		potential_computers += CA
	if(LAZYLEN(potential_computers))
		var/obj/machinery/computer/abnormality/teleport_computer = pick(potential_computers)
		var/turf/T = get_step(get_turf(teleport_computer), SOUTH)
		var/matrix/init_transform = transform
		animate(src, transform = transform*0.01, time = 5, easing = BACK_EASING)
		SLEEP_CHECK_DEATH(5)
		console_attack_counter = 0
		forceMove(T)
		target = teleport_computer
		animate(src, transform = init_transform, time = 5, easing = BACK_EASING)
	teleporting = FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/CanTeleportTo(obj/machinery/computer/abnormality/CA)
	if(!CA.can_meltdown || CA.meltdown || !CA.datum_reference || !CA.datum_reference.current || !CA.datum_reference.qliphoth_meter)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	for(var/mob/living/L in view(5, src))
		if(!faction_check_mob(L))
			L.apply_damage(35, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	new /obj/item/food/meat/slab/crimson (get_turf(src))
	gib()

// Crimson noon
/mob/living/simple_animal/hostile/ordeal/crimson_noon
	name = "harmony of skin"
	desc = "A large clown-like creature with 3 heads full of red tumors."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "crimson_noon"
	icon_living = "crimson_noon"
	icon_dead = "crimson_noon_dead"
	faction = list("crimson_ordeal")
	maxHealth = 1000
	health = 1000
	pixel_x = -8
	base_pixel_x = -8
	melee_damage_lower = 18
	melee_damage_upper = 20
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/crimson/noon_bite.ogg'
	death_sound = 'sound/effects/ordeals/crimson/noon_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	blood_volume = BLOOD_VOLUME_NORMAL
	ordeal_remove_ondeath = FALSE

	/// How many mobs we spawn on death
	var/mob_spawn_amount = 3

/mob/living/simple_animal/hostile/ordeal/crimson_noon/death(gibbed)
	animate(src, transform = matrix()*1.25, color = "#FF0000", time = 5)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 5)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	for(var/i = 1 to mob_spawn_amount)
		var/turf/T = get_step(get_turf(src), pick(valid_directions))
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/nc = new(T)
		addtimer(CALLBACK(nc, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ordeal/crimson_clown, TeleportAway)), 1)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	gib()

// Crimson dusk
/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk
	name = "struggle of the peak"
	desc = "A round clown amalgamation holding a hammer and an axe."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "crimson_dusk"
	icon_living = "crimson_dusk"
	icon_dead = "crimson_dusk_dead"
	faction = list("crimson_ordeal")
	maxHealth = 2000
	health = 2000
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_lower = 32
	melee_damage_upper = 36
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

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/DeathExplosion()
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
			L.apply_damage(50, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			if(!(L in been_hit))
				been_hit += L
	addtimer(CALLBACK(src, PROC_REF(do_roll), move_dir, (times_ran + 1)), 1.5)

// Crimson midnight
// Tent
/mob/living/simple_animal/hostile/ordeal/crimson_tent
	name = "chorus of saliva"
	desc = "A circus tent stitched together with sinew. It has a giant, gaping maw."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "crimson_midnight"
	icon_dead = "crimson_midnight"
	faction = list("crimson_ordeal")
	maxHealth = 10000
	health = 10000
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_lower = 15
	melee_damage_upper = 30
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/amber/dusk_attack.ogg'
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/crimson = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/crimson = 2)

	var/spawn_time
	var/spawn_time_cooldown = 20 SECONDS
	var/list/spawned_mobs = list()
	var/can_act = TRUE
	var/bite_width = 1
	var/bite_length = 3
	var/bite_damage = 30

/mob/living/simple_animal/hostile/ordeal/crimson_tent/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/midnight_appear.ogg', 50, FALSE)

/mob/living/simple_animal/hostile/ordeal/crimson_tent/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_tent/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	update_icon()
	if(length(spawned_mobs) >= 8)
		return
	if((spawn_time > world.time))
		return
	spawn_time = world.time + spawn_time_cooldown
	visible_message(span_danger("\The [src] opens wide and more clowns appear from inside!"))
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/midnight_spawn.ogg', 75, FALSE)
	var/spawnchance = pick(1,2)
	for(var/i = 1 to spawnchance)
		var/turf/T = get_step(get_turf(src), pick(0, EAST))
		var/picked_mob = pick(/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/spawned, /mob/living/simple_animal/hostile/ordeal/crimson_noon/spawned)
		var/mob/living/simple_animal/hostile/ordeal/nb = new picked_mob(T)
		spawned_mobs += nb
		if(ordeal_reference)
			nb.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nb

/mob/living/simple_animal/hostile/ordeal/crimson_tent/death(gibbed)
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/midnight_dead.ogg', 30, 0)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 2.8 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion), ordeal_reference), 2.8 SECONDS)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_tent/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	for(var/turf/L in view(4, src))
		if(prob(25) && !(L.density))
			new /obj/item/food/meat/slab/crimson (get_turf(L))
		var/obj/effect/decal/cleanable/blood/B = new /obj/effect/decal/cleanable/blood(get_turf(L))
		B.bloodiness = 100
	for(var/mob/living/L in view(5, src))
		if(!faction_check_mob(L))
			L.apply_damage(700, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	gib()

/mob/living/simple_animal/hostile/ordeal/crimson_tent/AttackingTarget()
	if(!can_act)
		return FALSE
	return Bite(target)

/mob/living/simple_animal/hostile/ordeal/crimson_tent/proc/Bite(target)
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, EAST, bite_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, bite_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, bite_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, WEST, bite_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, bite_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, bite_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, SOUTH, bite_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, bite_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, bite_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, NORTH, bite_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, bite_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, bite_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/ball.ogg', 75, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(0.8 SECONDS)
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/noon_bite.ogg', 100, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if (L == src)
				continue
			L.apply_damage(bite_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

// Crimson Midnight
// Clown
/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_midnight //oh god why
	name = "pinnacle of thew"
	desc = "A gargantuan clown with gigantic muscles."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "crimson_midnight"
	icon_living = "crimson_midnight"
	icon_dead = "crimson_midnight"
	faction = list("crimson_ordeal")
	maxHealth = 3000
	health = 3000
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_lower = 48
	melee_damage_upper = 56
	move_to_delay = 4
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/effects/ordeals/crimson/midnight_slam.ogg'
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	mob_spawn_amount = 2

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_midnight/Initialize()
	..()
	animate(src, transform = matrix()*1.3, time = 0 SECONDS)
	AddComponent(/datum/component/knockback, 3, FALSE, TRUE) //1 is distance thrown, False is if it can throw anchored objects, True if doesnt apply damage or stun when hits a wall.

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_midnight/DeathExplosion()
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
		var/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/nc = new(T)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	gib()

// Tent spawned variants
// Dawn
/mob/living/simple_animal/hostile/ordeal/crimson_clown/spawned //Weaker variant that dies in 60 seconds
	name = "a cacophony of smiles"
	maxHealth = 50
	health = 50

/mob/living/simple_animal/hostile/ordeal/crimson_clown/spawned/Initialize() //this should effectively limit how many are active at a time
	. = ..()
	animate(src, transform = matrix()*1.2, color = "#FF0000", time = 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion), ordeal_reference), 60 SECONDS)

/mob/living/simple_animal/hostile/ordeal/crimson_clown/spawned/TeleportAway()
	if(console_attack_counter >= 10)
		death()
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/spawned/DeathExplosion()
	if(QDELETED(src))
		return
	gib()

// Noon
/mob/living/simple_animal/hostile/ordeal/crimson_noon/spawned //weaker variant that explodes into clowns if ignored
	name = "moment of indulgence"
	maxHealth = 650
	health = 650
	mob_spawn_amount = 1

/mob/living/simple_animal/hostile/ordeal/crimson_noon/spawned/Initialize()
	. = ..()
	animate(src, transform = matrix()*1.2, color = "#FF0000", time = 45 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion), ordeal_reference), 45 SECONDS)

/mob/living/simple_animal/hostile/ordeal/crimson_noon/spawned/death(gibbed)
	. = ..()
	if(!gibbed)
		gib()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/spawned/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	for(var/i = 1 to mob_spawn_amount)
		var/turf/T = get_step(get_turf(src), pick(valid_directions))
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/spawned/nc = new(T)
		addtimer(CALLBACK(nc, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ordeal/crimson_clown/spawned, TeleportAway)), 1)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	gib()

// Dusk
/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/spawned //weaker variant that explodes into clowns if ignored
	name = "summit of trepidation"
	maxHealth = 500
	health = 500

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/spawned/Initialize()
	. = ..()
	animate(src, transform = matrix()*1.2, color = "#FF0000", time = 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion), ordeal_reference), 60 SECONDS)

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/spawned/death(gibbed)
	. = ..()
	if(!gibbed)
		gib()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/spawned/DeathExplosion()
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
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/spawned/nc = new(T)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	gib()
