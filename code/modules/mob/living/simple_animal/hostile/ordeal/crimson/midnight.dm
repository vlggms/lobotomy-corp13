/mob/living/simple_animal/hostile/ordeal/crimson_tent
	name = "chorus of saliva"
	desc = "A circus tent stitched together with sinew. It has a giant, gaping maw."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "crimson_midnight"
	icon_dead = "crimson_midnight"
	faction = list("crimson_ordeal")
	maxHealth = 2400
	health = 2400
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_lower = 12
	melee_damage_upper = 16
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/amber/dusk_attack.ogg'
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.2)
	butcher_results = list(/obj/item/food/meat/slab/crimson = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/crimson = 2)

	var/initial_spawn = FALSE
	var/spawn_time
	var/spawn_time_cooldown = 20 SECONDS
	var/list/spawned_mobs = list()
	var/list/weaker_spawned_mobs = list()
	var/can_act = TRUE
	var/bite_width = 1
	var/bite_length = 3
	var/bite_damage = 20

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
	listclearnulls(weaker_spawned_mobs)
	for(var/mob/living/L in weaker_spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	update_icon()

	if(!initial_spawn)
		initial_spawn = TRUE
		spawn_time = world.time + spawn_time_cooldown
		visible_message(span_danger("\The [src] opens wide and clowns appear from inside!"))
		playsound(get_turf(src), 'sound/effects/ordeals/crimson/midnight_spawn.ogg', 75, FALSE)
		for(var/i = 1 to 2)
			var/turf/T = get_step(get_turf(src), pick(0, EAST))
			var/mob/living/simple_animal/hostile/ordeal/crimson_midnight/nb = new(T)
			nb.tent = src
			spawned_mobs += nb
			if(ordeal_reference)
				nb.ordeal_reference = ordeal_reference
				ordeal_reference.ordeal_mobs += nb
		return

	if(length(spawned_mobs) >= 4)
		return
	if(length(weaker_spawned_mobs) >= 12)
		return
	if((spawn_time > world.time))
		return
	spawn_time = world.time + spawn_time_cooldown
	visible_message(span_danger("\The [src] opens wide and another clown appears from inside!"))
	adjustBruteLoss(-50)
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/midnight_spawn.ogg', 75, FALSE)
	var/turf/T = get_step(get_turf(src), pick(0, EAST))
	var/mob/living/simple_animal/hostile/ordeal/crimson_midnight/nb = new(T)
	nb.tent = src
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
			L.deal_damage(200, RED_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
	gib()

/mob/living/simple_animal/hostile/ordeal/crimson_tent/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	return Bite(attacked_target)

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
			L.deal_damage(bite_damage, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE))
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

// Crimson Midnight
// Clown
/mob/living/simple_animal/hostile/ordeal/crimson_midnight //oh god why
	name = "pinnacle of thew"
	desc = "A massive clown with gigantic muscles."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "crimson_midnight"
	icon_living = "crimson_midnight"
	icon_dead = "crimson_midnight"
	faction = list("crimson_ordeal")
	maxHealth = 650
	health = 650
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_lower = 10
	melee_damage_upper = 12
	move_to_delay = 4
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/effects/ordeals/crimson/midnight_slam.ogg'
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
	blood_volume = BLOOD_VOLUME_NORMAL
	ordeal_remove_ondeath = FALSE
	can_patrol = TRUE
	ranged = TRUE
	var/mob/living/simple_animal/hostile/ordeal/crimson_tent/tent
	/// How many mobs we spawn if we exist for too long
	var/mob_spawn_amount = 4

	var/can_be_gibbed = TRUE
	var/exploding = FALSE
	var/is_trampling = FALSE
	var/trample_cooldown
	var/trample_cooldown_time = 10 SECONDS
	var/trample_duration
	var/trample_time = 6 SECONDS
	var/trample_damage = 10

/mob/living/simple_animal/hostile/ordeal/crimson_midnight/OpenFire(atom/A)
	if(get_dist(src, target) >= 3 && trample_cooldown <= world.time && !is_trampling)
		is_trampling = TRUE
		trample_cooldown = world.time + trample_cooldown_time
		trample_duration = world.time + trample_time
		ChangeMoveToDelay(2)
		visible_message(span_danger("[src] starts to move wildly!"))

/mob/living/simple_animal/hostile/ordeal/crimson_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(trample_duration <= world.time && is_trampling)
		is_trampling = FALSE
		trample_cooldown = world.time + trample_cooldown_time
		ChangeMoveToDelay(4)

//The creature can walk over entities that are the same type or while its trampling.
/mob/living/simple_animal/hostile/ordeal/crimson_midnight/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(isliving(blocker))
		var/mob/living/M = blocker
		if(is_trampling || (patrol_path.len && faction_check_mob(M)))
			return TRUE
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_midnight/Moved()
	. = ..()
	if(!.)
		return
	if(is_trampling)
		playsound(get_turf(src), 'sound/abnormalities/bigbird/step.ogg', 50, 1)
		for(var/turf/T in view(src, 1))
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in T)
				if(faction_check_mob(L))
					continue
				if (L == src)
					continue
				if(L == target) // Ends the trample since we reached our guy already
					TryAttack(L)
					is_trampling = FALSE
					trample_cooldown = world.time + trample_cooldown_time
					ChangeMoveToDelay(4)
				playsound(src, 'sound/effects/ordeals/crimson/dusk_move.ogg', 50, 1)
				L.deal_damage(trample_damage, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
				L.visible_message(span_userdanger("\The [src] tramples [L]!"), \
						span_userdanger("\The [src] tramples you!"), null, COMBAT_MESSAGE_RANGE, src)
				to_chat(src, span_danger("You trample [L]!"))

/mob/living/simple_animal/hostile/ordeal/crimson_midnight/death(gibbed)
	exploding = TRUE
	is_trampling = FALSE
	if(gibbed)
		DeathExplosion(TRUE, TRUE)
	else
		can_be_gibbed = FALSE
		animate(src, transform = matrix()*1.4, color = "#FF0000", time = 25, flags=ANIMATION_PARALLEL | ANIMATION_RELATIVE)
		addtimer(CALLBACK(src, PROC_REF(DeathExplosion), FALSE, TRUE), 25)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_midnight/gib()
	if(!can_be_gibbed)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_midnight/Initialize()
	. = ..()
	AddComponent(/datum/component/knockback, 3, FALSE, TRUE) //1 is distance thrown, False is if it can throw anchored objects, True if doesnt apply damage or stun when hits a wall.
	animate(src, transform = matrix()*1.2, color = "#FF0000", time = 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 60 SECONDS)

/mob/living/simple_animal/hostile/ordeal/crimson_midnight/proc/DeathExplosion(gibbed = FALSE, safe = FALSE)
	if(QDELETED(src))
		return
	if(!safe && exploding) // We dont want it to go boom with clowns if it trying to go boom already
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	for(var/mob/living/L in view(3, src))
		if(!faction_check_mob(L))
			L.deal_damage(25, RED_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
	for(var/turf/L in view(2, src))
		if(prob(20) && !(L.density) && safe)
			new /obj/item/food/meat/slab/crimson (get_turf(L))
		var/obj/effect/decal/cleanable/blood/B = new /obj/effect/decal/cleanable/blood(get_turf(L))
		B.bloodiness = 100
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	if(!safe)
		for(var/i = 1 to mob_spawn_amount)
			var/turf/T = get_step(get_turf(src), pick(valid_directions))
			var/mob/living/simple_animal/hostile/ordeal/crimson_clown/nc = new(T)
			if(tent)
				tent.weaker_spawned_mobs += nc
			addtimer(CALLBACK(nc, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ordeal/crimson_clown, TeleportAway)), 1)
			if(ordeal_reference)
				nc.ordeal_reference = ordeal_reference
				ordeal_reference.ordeal_mobs += nc
		if(ordeal_reference)
			ordeal_reference.OnMobDeath(src)
			ordeal_reference = null
	if(!gibbed)
		can_be_gibbed = TRUE
		gib()
