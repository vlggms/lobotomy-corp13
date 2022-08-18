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
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL

	suppression_attribute_bonus = FORTITUDE_ATTRIBUTE
	exp_value = 10
	max_stat = 60

	/// When it hits console 15 times - reduce qliphoth and teleport
	var/console_attack_counter = 0

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
		if(console_attack_counter < 15)
			console_attack_counter += 1
			visible_message("<span class='warning'>[src] hits [CA]'s buttons at random!</span>")
			playsound(get_turf(CA), "sound/machines/terminal_button0[rand(1,8)].ogg", 50, 1)
		else
			console_attack_counter = 0
			visible_message("<span class='warning'>[CA]'s screen produces an error!</span>")
			playsound(get_turf(CA), 'sound/machines/terminal_error.ogg', 50, 1)
			CA.datum_reference.qliphoth_change(-1, src)
			TeleportAway()
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/death(gibbed)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
	addtimer(CALLBACK(src, .proc/DeathExplosion, ordeal_reference), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/TeleportAway()
	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/CA in GLOB.abnormality_consoles)
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

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/CanTeleportTo(obj/machinery/computer/abnormality/CA)
	if(CA.meltdown || !CA.datum_reference || !CA.datum_reference.current || !CA.datum_reference.qliphoth_meter)
		return FALSE
	if(type in view(5, get_turf(CA))) // There's already a similar clown nearby
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message("<span class='danger'>[src] suddenly explodes!</span>")
	for(var/mob/living/L in view(5, src))
		if(!faction_check_mob(L))
			L.apply_damage(15, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
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
	deathsound = 'sound/effects/ordeals/crimson/noon_dead.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	blood_volume = BLOOD_VOLUME_NORMAL
	ordeal_remove_ondeath = FALSE

	suppression_attribute_bonus = FORTITUDE_ATTRIBUTE
	exp_value = 15 // HE?
	max_stat = 80 // Yeah, HE.

	/// How many mobs we spawn on death
	var/mob_spawn_amount = 3

/mob/living/simple_animal/hostile/ordeal/crimson_noon/death(gibbed)
	animate(src, transform = matrix()*1.25, color = "#FF0000", time = 5)
	addtimer(CALLBACK(src, .proc/DeathExplosion), 5)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message("<span class='danger'>[src] suddenly explodes!</span>")
	for(var/i = 1 to mob_spawn_amount)
		var/turf/T = get_step(get_turf(src), pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/nc = new(T)
		addtimer(CALLBACK(nc, /mob/living/simple_animal/hostile/ordeal/crimson_clown/.proc/TeleportAway), 1)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	gib()

// Crimson noon
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
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	mob_spawn_amount = 2

	suppression_attribute_bonus = FORTITUDE_ATTRIBUTE
	exp_value = 20 // Politically Accurate WAW
	max_stat = 100

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
	visible_message("<span class='danger'>[src] suddenly explodes!</span>")
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/dusk_dead.ogg', 50, 1)
	for(var/i = 1 to mob_spawn_amount)
		var/turf/T = get_step(get_turf(src), pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
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
			visible_message("<span class='boldwarning'>[src] rolls past [L]!</span>")
			to_chat(L, "<span class='userdanger'>[src] rolls past you!</span>")
			var/turf/LT = get_turf(L)
			new /obj/effect/temp_visual/kinetic_blast(LT)
			L.apply_damage(40, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			if(!(L in been_hit))
				been_hit += L
	addtimer(CALLBACK(src, .proc/do_roll, move_dir, (times_ran + 1)), 1.5)
