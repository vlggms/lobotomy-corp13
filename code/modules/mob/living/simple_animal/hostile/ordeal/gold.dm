// Gold Dawn - Commander that heals its minions
/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion
	name = "Fallen Nepenthes"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "amurdad_corrosion"
	icon_living = "amurdad_corrosion"
	icon_dead = "sin_dead"
	faction = list("gold_ordeal")
	maxHealth = 400
	health = 400
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 14
	pixel_x = -8
	base_pixel_x = -8
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/abnormalities/ebonyqueen/attack.ogg'
	death_sound = 'sound/creatures/venus_trap_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1)
	speed = 1 //slow as balls
	move_to_delay = 20
	ranged = TRUE
	rapid = 2
	rapid_fire_delay = 10
	projectiletype = /obj/projectile/ego_bullet/ego_nightshade/healing //no friendly fire, baby!
	projectilesound = 'sound/weapons/bowfire.ogg'

/mob/living/simple_animal/hostile/ordeal/sin_sloth
	name = "Peccatulum Acediae"
	desc = "It resembles a rock."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sinrock"
	icon_living = "sinrock"
	icon_dead = "sin_dead"
	faction = list("gold_ordeal")
	maxHealth = 100
	health = 100
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 24
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/gold/rock_attack.ogg'
	death_sound = 'sound/effects/ordeals/gold/rock_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/golem = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/golem = 1)
	ranged = TRUE
	var/list/movement_path = list()
	var/list/been_hit = list()
	var/charging = FALSE
	var/charging_cooldown
	var/charging_cooldown_time = 8 SECONDS //apparantly charge is already used in /hostile.dm
	var/charge_damage = 20
	/// Delay between each subsequent move when charging
	var/charge_speed = 1
	/// How many paths do we create between several landmarks?
	var/charge_nodes = 3
	/// Maximum AStar pathfinding distances from one point to another
	var/charge_max_distance = 40
	var/dash_cooldown_time = 15 SECONDS //will dash at people if they get out of range but not too often
	var/dash_cooldown

/mob/living/simple_animal/hostile/ordeal/sin_sloth/Life()
	. = ..()
	if(.)
		if((charging_cooldown <= world.time) && prob(15))
			ChargeStart()

/mob/living/simple_animal/hostile/ordeal/sin_sloth/OpenFire()
	if(!target || charging)
		return
	Dash(target)

/mob/living/simple_animal/hostile/ordeal/sin_sloth/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/Dash(mob/living/target)
	if(!istype(target))
		return
	var/dist = get_dist(target, src)
	if(dist > 2 && dash_cooldown < world.time)
		var/list/dash_line = getline(src, target)
		for(var/turf/line_turf in dash_line) //checks if there's a valid path between the turf and the target
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				break
			forceMove(line_turf)
			SLEEP_CHECK_DEATH(0.8)
		playsound(src, 'sound/effects/ordeals/gold/rock_runover.ogg', 50, FALSE, 4)
		dash_cooldown = world.time + dash_cooldown_time

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/ChargeStart(target)
	if(charging || charging_cooldown > world.time)
		return
	charging = TRUE
	movement_path = list()
	var/list/initial_turfs = GLOB.xeno_spawn.Copy() + GLOB.department_centers.Copy()
	var/list/potential_turfs = list()
	for(var/turf/open/T in initial_turfs)
		if(get_dist(src, T) > 3)
			potential_turfs += T
	for(var/mob/living/L in livinginrange(32, src))
		if(prob(50))
			continue
		if((L.status_flags & GODMODE) || faction_check_mob(L))
			continue
		if(L.stat == DEAD)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.is_working)
				continue
		potential_turfs += get_turf(L)
	var/turf/picking_from = get_turf(src)
	var/turf/path_start = get_turf(src)
	if(target)
		var/turf/open/target_turf = get_turf(target)
		if(istype(target_turf))
			picking_from = target_turf
			potential_turfs |= target_turf
		face_atom(target)
	for(var/i = 1 to charge_nodes)
		if(!LAZYLEN(potential_turfs))
			break
		var/turf/T = get_closest_atom(/turf/open, potential_turfs, picking_from)
		if(!T)
			break
		var/list/our_path = list()
		for(var/o = 1 to 3) // Grand total of 3 retries
			our_path = get_path_to(path_start, T, TYPE_PROC_REF(/turf, Distance_cardinal), charge_max_distance)
			if(islist(our_path) && LAZYLEN(our_path))
				break
			potential_turfs -= T // Couldn't find path to it, don't try again
			if(!LAZYLEN(potential_turfs))
				break
			T = get_closest_atom(/turf/open, potential_turfs, picking_from)
		if(!islist(our_path) || !LAZYLEN(our_path))
			continue
		movement_path += our_path
		picking_from = T
		path_start = T
		potential_turfs -= T
	if(!LAZYLEN(movement_path))
		return FALSE
	playsound(src, 'sound/effects/ordeals/gold/rock_runover.ogg', 50, TRUE, 7)
	for(var/turf/T in movement_path) // Warning before charging
		new /obj/effect/temp_visual/mustardgas(T)
	SLEEP_CHECK_DEATH(18)
	been_hit = list()
	SpinAnimation(3, 10)
	for(var/turf/T in movement_path)
		if(QDELETED(T))
			break
		if(!Adjacent(T))
			break
		ChargeAt(T)
		SLEEP_CHECK_DEATH(charge_speed)
	charging = FALSE
	icon_state = icon_living
	charging_cooldown = world.time + charging_cooldown_time

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/ChargeAt(turf/T)
	face_atom(T)
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("teeth")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK (D, TYPE_PROC_REF(/obj/machinery/door, open)))
	forceMove(T)
	if(prob(33))
		playsound(T, 'sound/effects/ordeals/gold/rock_attack.ogg', 10, TRUE, 3)
	for(var/turf/TF in view(1, T))
		new /obj/effect/temp_visual/mustardgas(TF)
		for(var/mob/living/L in TF)
			if(!faction_check_mob(L))
				if(L in been_hit)
					continue
				L.visible_message(span_warning("[src] rams [L]!"), span_boldwarning("[src] rams into you!"))
				L.apply_damage(charge_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				new /obj/effect/temp_visual/cleave(get_turf(L))
				playsound(L, 'sound/effects/ordeals/gold/rock_kill.ogg', 50, TRUE)
				if(L.health < 0)
					L.gib()
				if(!QDELETED(L))
					been_hit += L
					if(ishuman(L))
						var/mob/living/carbon/human/H = L
						H.Knockdown(4)

/mob/living/simple_animal/hostile/ordeal/sin_gluttony
	name = "Peccatulum Gulae"
	desc = "These \"plants\" are like a rabid beast!"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sinflower"
	icon_living = "sinflower"
	icon_dead = "sin_dead"
	faction = list("gold_ordeal")
	maxHealth = 250
	health = 250
	melee_damage_type = RED_DAMAGE
	rapid_melee = 3
	melee_damage_lower = 4
	melee_damage_upper = 6
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/gold/flower_attack.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1)
	stat_attack = DEAD

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/proc/devour(mob/living/L)
	if(!L)
		return
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	adjustBruteLoss(-(maxHealth/2))
	playsound(get_turf(L), 'sound/effects/ordeals/gold/flower_kill.ogg', 50, 4)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		for(var/obj/item/bodypart/part in C.bodyparts)
			if(part.dismemberable && prob(20) && part.body_part != CHEST && C.stat == DEAD)
				part.dismember()
				QDEL_NULL(part)
				new /obj/effect/gibspawner/generic/silent(get_turf(C))
			if(C.bodyparts.len <= 1)
				C.gib()
				return
	return

// Gold Noon - Boss with minions
/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion
	name = "Lady of the Lake"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "lake_corrosion"
	icon_living = "lake_corrosion"
	icon_dead = "sin_dead"
	faction = list("gold_ordeal")
	maxHealth = 2500 //it's a boss, more or less
	health = 2500
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 18
	ranged = TRUE
	attack_verb_continuous = "bisects"
	attack_verb_simple = "bisects"
	attack_sound = 'sound/weapons/fixer/generic/blade3.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/chicken = 1)
	speed = 3
	move_to_delay = 3

	var/can_act = TRUE
	var/slash_width = 1
	var/slash_length = 3
	var/sweep_cooldown
	var/sweep_cooldown_time = 10 SECONDS
	var/sweep_damage = 50

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/face_atom() //VERY important; prevents spinning while slashing
	if(!can_act)
		return
	..()

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/OpenFire()
	if(!can_act)
		return
	if((sweep_cooldown < world.time) && (get_dist(src, target) < 3))
		AreaAttack()
		return

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/AttackingTarget()
	if(!can_act)
		return FALSE
	return Slash(target)

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/proc/Slash(target)
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, EAST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, WEST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, SOUTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, NORTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
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
	playsound(get_turf(src), 'sound/weapons/fixer/generic/sheath2.ogg', 75, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(0.8 SECONDS)
	var/slash_damage = 35
	playsound(get_turf(src), 'sound/weapons/fixer/generic/blade3.ogg', 100, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if (L == src)
				continue
			HurtInTurf(T, list(), slash_damage, PALE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/bullet_act(obj/projectile/P)
	new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
	visible_message(span_userdanger("[P] is easily deflected by [src]!"))
	P.Destroy()
	return

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/attacked_by(obj/item/I, mob/living/user)
	var/checkdir = check_target_facings(user, src)
	if((get_dist(user, src) > 1) || checkdir == FACING_EACHOTHER)
		new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
		user.visible_message(span_danger("[user]'s attack is easily deflected by [src]!"), span_userdanger("Your attack is easily deflected by [src]!"))
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/proc/AreaAttack()
	if(sweep_cooldown > world.time)
		return
	sweep_cooldown = world.time + sweep_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/weapons/fixer/generic/dodge2.ogg', 100, 0, 5)
	for(var/turf/L in view(2, src))
		new /obj/effect/temp_visual/cult/sparks(L)
	SLEEP_CHECK_DEATH(12)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in HurtInTurf(T, list(), sweep_damage, PALE_DAMAGE, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE))
			if(L.health < 0)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H)) //The other way, someday.
					H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
				L.gib()
	playsound(get_turf(src), 'sound/weapons/fixer/generic/finisher1.ogg', 100, 0, 5)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/sin_gloom
	name = "Peccatulum Morositatis"
	desc = "An insect-like entity with a transparant body."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "sinflea"
	icon_living = "sinflea"
	icon_dead = "flea_dead"
	faction = list("gold_ordeal")
	maxHealth = 300
	health = 300
	melee_damage_type = WHITE_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 14
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/gold/flea_attack.ogg'
	death_sound = 'sound/effects/ordeals/gold/flea_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/slime = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/slime = 1)
	is_flying_animal = TRUE
	ranged = TRUE
	minimum_distance = 2 // Don't move all the way to melee
	projectiletype = /obj/projectile/beam/water_jet
	projectilesound = 'sound/effects/ordeals/gold/flea_attack.ogg'

/mob/living/simple_animal/hostile/ordeal/sin_gloom/MeleeAction()
	if(health <= maxHealth*0.5 && stat != DEAD)
		walk_to(src, 0)
		animate(src, transform = matrix()*1.8, time = 15)
		addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/sin_gloom/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	playsound(loc, 'sound/effects/ordeals/gold/tentacle_explode.ogg', 60, TRUE)
	new /obj/effect/temp_visual/explosion(get_turf(src))
	for(var/mob/living/L in viewers(2, src))
		L.apply_damage(40, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	animate(src, transform = matrix(), time = 0)
	death()


// Gold Dusk - Commander that buffs its minion's attacks
/mob/living/simple_animal/hostile/ordeal/sin_pride
	name = "Peccatulum Superbiae"
	desc = "Those spikes look sharp!"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "sinwheel"
	icon_living = "sinwheel"
	icon_dead = "sin_dead"
	faction = list("gold_ordeal")
	maxHealth = 400
	health = 400
	melee_damage_type = RED_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 14
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/ego/sword1.ogg'
	death_sound = 'sound/effects/ordeals/gold/dead_generic.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/rawcrab = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/rawcrab = 1)
	ranged = TRUE
	var/charging = FALSE
	var/dash_num = 25
	var/dash_cooldown = 0
	var/dash_cooldown_time = 6 SECONDS
	var/list/been_hit = list() // Don't get hit twice.

/mob/living/simple_animal/hostile/ordeal/sin_pride/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_pride/AttackingTarget()
	if(charging)
		return
	if(dash_cooldown <= world.time && prob(10) && !client)
		PrepCharge(target)
		return
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.health < 0)
		H.gib()
		playsound(src, 'sound/weapons/fixer/generic/blade4.ogg', 75, 1)
	return

/mob/living/simple_animal/hostile/ordeal/sin_pride/OpenFire()
	if(dash_cooldown <= world.time)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			PrepCharge(target)

//Dash Code
/mob/living/simple_animal/hostile/ordeal/sin_pride/proc/PrepCharge(target)
	if(charging || dash_cooldown > world.time)
		return
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	SpinAnimation(3, 10)
	dash_num = (get_dist(src, target) + 3)
	addtimer(CALLBACK(src, PROC_REF(Charge), dir_to_target, 0), 2 SECONDS)
	playsound(src, 'sound/effects/ordeals/gold/pridespin.ogg', 125, FALSE)

/mob/living/simple_animal/hostile/ordeal/sin_pride/proc/Charge(move_dir, times_ran)
	if(health <= 0)
		return
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
	for(var/obj/machinery/door/poddoor/P in T.contents)//FIXME: Still opens the "poddoor" secure shutters
		stop_charge = TRUE
		continue
	if(stop_charge)
		charging = FALSE
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			D.open(2)
	forceMove(T)
	playsound(src, 'sound/weapons/fixer/generic/blade1.ogg', 100, 1)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		L.visible_message(span_warning("[src] shreds [L] as it passes by!"), span_boldwarning("[src] shreds you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		L.apply_damage(150, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		been_hit += L
		playsound(L, 'sound/weapons/fixer/generic/sword4.ogg', 75, 1)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.health < 0)
			H.gib()
			playsound(src, 'sound/weapons/fixer/generic/blade4.ogg', 75, 1)
	addtimer(CALLBACK(src, PROC_REF(Charge), move_dir, (times_ran + 1)), 1)


/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion
	name = "Thunder Warrior"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "thunder_warrior"
	icon_living = "thunder_warrior"
	icon_dead = "thunder_warrior_dead"
	faction = list("gold_ordeal")
	maxHealth = 900
	health = 900
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 26
	melee_damage_upper = 36
	attack_verb_continuous = "chops"
	attack_verb_simple = "chop"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_zombieattack.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.7)
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 3
	ranged = TRUE
	projectiletype = /obj/projectile/thunder_tomahawk
	projectilesound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	var/charged = FALSE
	var/list/spawned_mobs = list()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/AttackingTarget()
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	if(charged)
		L.apply_damage(15, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		playsound(get_turf(src), 'sound/weapons/fixer/generic/energyfinisher1.ogg', 75, 1)
		to_chat(L,span_danger("The [src] unleashes its charge!"))
		charged = FALSE
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		Convert(H)

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	playsound(src, 'sound/abnormalities/thunderbird/tbird_zombify.ogg', 45, FALSE, 5)
	var/mob/living/simple_animal/hostile/thunder_zombie/C = new(get_turf(src))
	if(!QDELETED(H))
		C.name = "[H.real_name]"//applies the target's name and adds the name to its description
		C.icon_state = "human_thunderbolt"
		C.icon_living = "human_thunderbolt"
		C.desc = "What appears to be [H.real_name], only charred and screaming incoherently..."
		C.gender = H.gender
		C.faction = src.faction
		C.master = src
		spawned_mobs += C
		H.gib()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/death(gibbed)
	for(var/mob/living/A in spawned_mobs)
		A.gib()
	..()

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion
	name = "680 Ham Actor"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "680_ham_actor"
	icon_living = "680_ham_actor"
	icon_dead = "ham_actor_dead"
	faction = list("gold_ordeal")
	maxHealth = 1500
	health = 1500
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 10 //they're support, so they deal low damage
	melee_damage_upper = 15
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.7)
	butcher_results = list(/obj/item/food/meat/slab/robot = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 4
	var/pulse_cooldown
	var/pulse_cooldown_time = 4 SECONDS

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/Life()
	. = ..()
	if(health <= 0)
		return
	if((pulse_cooldown <= world.time) && prob(35))
		return Pulse()

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/proc/Pulse()//Periodic weak AOE attack
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(get_turf(src), 'sound/weapons/fixer/generic/energy2.ogg', 75, FALSE, 3)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(2, orgin)
	for(var/i = 0 to 2)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) != i)
				continue
			if(T.density)
				continue
			addtimer(CALLBACK(src, PROC_REF(PulseWarn), T), (3 * (i+1)) + 0.1 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(PulseHit), T), (3 * (i+1)) + 0.5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/proc/PulseWarn(turf/T)
	new /obj/effect/temp_visual/cult/sparks(T)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/proc/PulseHit(turf/T)
	new /obj/effect/temp_visual/smash_effect(T)
	HurtInTurf(T, list(), 5, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	for(var/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/TB in T)
		if(TB.charged)
			continue
		TB.charged = TRUE
		playsound(get_turf(TB), 'sound/weapons/fixer/generic/energy3.ogg', 75, FALSE, 3)
		TB.visible_message(span_warning("[TB] absorbs the arcing electricity!"))
		new /obj/effect/temp_visual/healing/no_dam(get_turf(TB))


//Gold Midnight
/mob/living/simple_animal/hostile/ordeal/NT_corrosion
	name = "everything there of an inquisitor"
	desc = "A humanoid in a suit of armor that is covered in flesh and eyeballs."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "everything_there"
	icon_living = "everything_there"
	icon_dead = "dead_generic"
	faction = list("gold_ordeal")
	maxHealth = 3000
	health = 3000
	pixel_x = -8
	base_pixel_x = -8
	melee_damage_lower = 24
	melee_damage_upper = 30
	rapid_melee = 2
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.3)
	butcher_results = list(/obj/item/food/meat/slab/human = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 5
	ranged = TRUE
	var/can_act = TRUE
	/// When this reaches 400 - begins reflecting damage
	var/damage_taken = 0
	var/damage_reflection = FALSE
	var/hello_cooldown
	var/hello_cooldown_time = 6 SECONDS
	var/hello_damage = 120

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	var/turf/jump_turf = get_step(attacker, pick(GLOB.alldirs))
	if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
		jump_turf = get_turf(attacker)
	forceMove(jump_turf)
	playsound(src, 'sound/weapons/ego/sword1.ogg', min(15 + damage, 100), TRUE, 4)
	attacker.visible_message(span_danger("[src] counters [attacker] with a massive blade!"), span_userdanger("[src] counters your attack!"))
	do_attack_animation(attacker)
	attacker.apply_damage(damage, attack_type, null, attacker.getarmor(null, attack_type))
	new /obj/effect/temp_visual/revenant(get_turf(attacker))

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/death(gibbed)
	if(damage_reflection)
		damage_reflection = FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attack_hand(mob/living/carbon/human/M)
	..()
	if(!.)
		return
	if(damage_reflection && M.a_intent == INTENT_HARM)
		ReflectDamage(M, M?.dna?.species?.attack_type, M?.dna?.species?.punchdamagehigh)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attack_paw(mob/living/carbon/human/M)
	..()
	if(damage_reflection && M.a_intent != INTENT_HELP)
		ReflectDamage(M, M?.dna?.species?.attack_type, 5)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!damage_reflection)
		return
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			ReflectDamage(M, M.melee_damage_type, damage)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(damage_reflection && Proj.firer)
		if(get_dist(Proj.firer, src) < 5)
			ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!damage_reflection)
		return
	var/damage = I.force
	if(ishuman(user))
		damage *= 1 + (get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
	ReflectDamage(user, I.damtype, damage)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(QDELETED(src) || stat == DEAD)
		damage_reflection = FALSE
		return
	if(!can_act)
		return
	if(damage_taken > 400 && !damage_reflection)
		StartReflecting()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/proc/StartReflecting()
	can_act = FALSE
	damage_reflection = TRUE
	damage_taken = 0
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/breach.ogg', 25, 0, 5)
	visible_message(span_warning("[src] assumes a stance!"))
	icon_state = "everything_there_guard"
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	sleep(2 SECONDS)
	if(QDELETED(src) || stat == DEAD)
		return
	icon_state = icon_living
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.3))
	damage_reflection = FALSE
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/proc/Hello(target)
	if(hello_cooldown > world.time)
		return
	hello_cooldown = world.time + hello_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_cast.ogg', 75, 0, 3)
//	icon_state = "everything_there_ranged"
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/hello_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(hello_delay)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, hello_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if((hello_cooldown <= world.time) && prob(35))
		var/turf/target_turf = get_turf(target)
		for(var/i = 1 to 3)
			target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
		return Hello(target_turf)
	return ..()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/OpenFire()
	if(!can_act)
		return
	if(hello_cooldown <= world.time)
		Hello(target)
	return

/mob/living/simple_animal/hostile/ordeal/snake_corrosion
	name = "wriggling beast"
	desc = "A humanoid in a suit of armor that is covered in snakes."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wriggling_beast"
	icon_living = "wriggling_beast"
	icon_dead = "dead_generic"
	faction = list("gold_ordeal")
	maxHealth = 2500
	health = 2500
	melee_damage_lower = 30
	melee_damage_upper = 35
	melee_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	attack_sound = 'sound/effects/ordeals/gold/cromer_slam.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/human = 1, /obj/item/food/meat/slab/human/mutant/lizard = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 4
	var/poison_releasing = FALSE
	var/poison_damage = 20
	var/applied_venom = 3
	var/poison_range = 3
	var/can_act = TRUE
	var/guntimer

	ranged = TRUE
	rapid = 1
	rapid_fire_delay = 1
	ranged_cooldown_time = 50
	projectiletype = /obj/projectile/poisonglob
	projectilesound = 'sound/effects/fish_splash.ogg' //TODO: change


/mob/living/simple_animal/hostile/ordeal/snake_corrosion/Life()
	. = ..()
	if(!.)
		return
	if(status_flags & GODMODE)
		return
	if(!poison_releasing)
		return
	SpawnPoison() //Periodically spews out damaging poison while breaching

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/proc/SpawnPoison()
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(poison_range, target_turf))
		if(prob(30))
			continue
		new /obj/effect/temp_visual/mustardgas(T)
		for(var/mob/living/H in T)
			if(faction_check_mob(H))
				continue
			H.apply_damage(poison_damage, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			H.apply_venom(2)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(poison_releasing)
		return
	if(health <= (maxHealth * 0.5))
		poison_releasing = TRUE
		visible_message(span_warning("[src]'s body breaks, releasing toxic fumes!"), span_boldwarning("Your poison gland breaks!"))
		playsound(src, 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 40, 0, FALSE)
		rapid += 1

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/AttackingTarget()
	if(!can_act)
		return FALSE
	..()
	if(isliving(target))
		var/mob/living/H = target
		H.apply_venom(applied_venom)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/OpenFire()
	if(get_dist(src, target) > 4)
		return
	. = ..()
	can_act = FALSE
	guntimer = addtimer(CALLBACK(src, PROC_REF(StartMoving)), (5), TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/proc/StartMoving()
	can_act = TRUE
	deltimer(guntimer)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/death(gibbed)
	. = ..()
	if(guntimer)
		deltimer(guntimer)
	poison_releasing = FALSE

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/bullet_act(obj/projectile/P)
	if(!P.firer)
		return ..()
	if((get_dist(P.firer, src) > 4))
		new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
		visible_message(span_userdanger("[src] blocks \the [P]!"))
		P.Destroy()
	return ..()

#define STATUS_EFFECT_VENOM /datum/status_effect/stacking/venom
/datum/status_effect/stacking/venom
	id = "stacking_venom"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/venom
	max_stacks = 10
	tick_interval = 5 SECONDS
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/venom
	name = "Venom"
	desc = "Your veins feel like they are on fire!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "venom"

/datum/status_effect/stacking/venom/can_have_status()
	return (owner.stat != DEAD || !(owner.status_flags & GODMODE))

/datum/status_effect/stacking/venom/on_apply()
	. = ..()
	owner.playsound_local(owner, 'sound/effects/venom_apply.ogg', 50, TRUE)
	to_chat(owner, "<span class='warning'>You have been envenomed!</span>")

//Deals brute damage, maybe one day we can make it deal toxin instead
/datum/status_effect/stacking/venom/tick()
	if(!can_have_status())
		qdel(src)
	owner.playsound_local(owner, 'sound/effects/venom.ogg', 50, TRUE)
	if(ishuman(owner))
		owner.adjustBruteLoss(max(0, stacks))
	else
		owner.adjustBruteLoss(stacks*4) // x4 on non humans

	//Halves stacks after every tick
	stacks = round(stacks/2)
	if(stacks <= 1)
		qdel(src)

//Mob Proc
/mob/living/proc/apply_venom(stacks)
	var/datum/status_effect/stacking/venom/V = src.has_status_effect(/datum/status_effect/stacking/venom)
	if(!V)
		src.apply_status_effect(/datum/status_effect/stacking/venom, stacks)
	else
		V.add_stacks(stacks)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/strong
	name = "slithering inquisitor"
	desc = "A humanoid in a suit of armor that is covered in snakes... A lot of snakes!"
	icon_state = "slithering_beast"
	icon_living = "slithering_beast"
	icon_dead = "dead_generic"
	maxHealth = 4000
	health = 4000
	melee_damage_lower = 40
	melee_damage_upper = 50
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.3)
	poison_range = 6
	poison_damage = 25
	rapid = 2
	applied_venom = 5

/mob/living/simple_animal/hostile/ordeal/dog_corrosion
	name = "crawling inquisitor"
	desc = "A four-legged creature in what looks like a set of armor for humans."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "crawling_beast"
	icon_living = "crawling_beast"
	icon_dead = "dead_generic"
	var/icon_aggro = "crawling_beast"
	faction = list("gold_ordeal")
	maxHealth = 2000
	health = 2000
	pixel_x = -8
	base_pixel_x = -8
	melee_damage_lower = 16
	melee_damage_upper = 18
	rapid_melee = 3
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/human = 1, /obj/item/food/meat/slab/pug = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 3
	ranged = TRUE
	var/charging = FALSE
	var/charge_ready = FALSE
	var/dash_num = 25
	var/dash_cooldown = 0
	var/dash_cooldown_time = 4 SECONDS
	var/dash_count = 2
	var/current_dash = 1
	var/list/been_hit = list() // Don't get hit twice.
	var/heal_amount = 250
	var/damage_taken
	var/damage_threshold = 450
	var/dash_damage = 80
	var/charge_sound = 'sound/effects/ordeals/gold/growl1.ogg'

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= damage_threshold && !charge_ready)
		charge_ready = TRUE
		new /obj/effect/temp_visual/cult/sparks(get_turf(src))
		damage_taken = 0

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/Life()
	. = ..()
	if(.) //Builds up the ability to charge over time even if ignored
		damage_taken += 20

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/bullet_act(obj/projectile/P)
	if(charging || charge_ready)
		new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
		visible_message(span_userdanger("[src] swiftly avoids \the [P]!"))
		P.Destroy()
		return
	..()

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/AttackingTarget()
	if(charging)
		return
	if(dash_cooldown <= world.time && !client && charge_ready)
		PrepCharge(target)
		return
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.health < 0)
		H.gib()
		playsound(src, "sound/abnormalities/clouded_monk/eat.ogg", 75, 1)
		adjustBruteLoss(-heal_amount)
	return

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/OpenFire()
	if(dash_cooldown <= world.time && charge_ready)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			PrepCharge(target)

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/proc/PrepCharge(target, forced)
	if(charging || dash_cooldown > world.time && (!forced))
		return
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	dash_num = (get_dist(src, target) + 3)
	addtimer(CALLBACK(src, PROC_REF(Charge), dir_to_target, 0), 8)
	charge_ready = FALSE
	playsound(src, charge_sound, 100, 1)

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/proc/Charge(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T || stat == DEAD)
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
	for(var/obj/machinery/door/poddoor/P in T.contents)//FIXME: Still opens the "poddoor" secure shutters
		stop_charge = TRUE
		continue
	if(stop_charge)
		if((current_dash < dash_count) && target)
			current_dash += 1
			addtimer(CALLBACK(src, PROC_REF(PrepCharge), target, TRUE), 2)
		else
			current_dash = 1
		charging = FALSE
		icon_state = icon_aggro
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			D.open(2)
	forceMove(T)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		visible_message(span_boldwarning("[src] bites [L]!"))
		to_chat(L, span_userdanger("[src] takes a bite out of you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		L.apply_damage(dash_damage,RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		been_hit += L
		playsound(L, 'sound/effects/ordeals/gold/cromer_stab.ogg', 75, 1)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.health < 0)
			H.gib()
			playsound(src, "sound/abnormalities/clouded_monk/eat.ogg", 75, 1)
			adjustBruteLoss(-heal_amount)
			times_ran = dash_num //stop the charge, we got them!
	addtimer(CALLBACK(src, PROC_REF(Charge), move_dir, (times_ran + 1)), 0.5)

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/strong
	name = "four-legged beast"
	desc = "A massive four-legged creature in what looks like a set of armor for humans."
	icon_state = "ravenous_beast"
	icon_living = "ravenous_beast"
	faction = list("gold_ordeal")
	maxHealth = 3000
	health = 3000
	melee_damage_lower = 18
	melee_damage_upper = 20
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.3)
	butcher_results = list(/obj/item/food/meat/slab/human = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	dash_num = 30
	dash_cooldown_time = 3 SECONDS
	dash_damage = 100
	dash_count = 3
	charge_sound = 'sound/effects/ordeals/gold/growl2.ogg'

#define STATUS_EFFECT_FUMING /datum/status_effect/stacking/fuming
/mob/living/simple_animal/hostile/ordeal/sin_wrath //High damage dealer capable of blowing up humans
	name = "Peccatulum Irae"
	desc = "Looks like some sort of dried tentacle with bits of red liquid inside."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "sintentacle"
	icon_living = "sintentacle"
	icon_dead = "sin_dead"
	pixel_x = -8
	base_pixel_x = -8
	faction = list("gold_ordeal")
	maxHealth = 800
	health = 800
	melee_damage_type = RED_DAMAGE
	rapid_melee = 3
	melee_damage_lower = 14
	melee_damage_upper = 16
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/gold/tentacle_attack.ogg'
	death_sound = 'sound/effects/ordeals/gold/dead_generic.ogg'
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/carpmeat/icantbeliveitsnotcarp = 1)
	guaranteed_butcher_results = list(/obj/item/food/carpmeat/icantbeliveitsnotcarp = 1) //should make its own kind of meat when I get around to it

/mob/living/simple_animal/hostile/ordeal/sin_wrath/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	var/datum/status_effect/stacking/fuming/F = H.has_status_effect(/datum/status_effect/stacking/fuming)
	if(!F)
		to_chat(H, span_userdanger("You start to feel overcome with rage!"))
		H.apply_status_effect(STATUS_EFFECT_FUMING)
	else
		to_chat(H, span_userdanger("You feel angrier!!"))
		F.add_stacks(1)
		F.refresh()
	return

/datum/status_effect/stacking/fuming
	id = "stacking_fuming"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/fuming
	duration = 30 SECONDS
	stack_decay = 0
	stacks = 1
	stack_threshold = 20
	max_stacks = 21
	consumed_on_threshold = TRUE
	var/exploding

/atom/movable/screen/alert/status_effect/fuming
	name = "Fuming Wrath"
	desc = "You feel so angry that your head might explode!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "sin_wrath"

/datum/status_effect/stacking/fuming/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.stat == DEAD)
		on_threshold_cross()

/datum/status_effect/stacking/fuming/on_threshold_cross()
	if(exploding)
		return
	exploding = TRUE
	playsound(get_turf(owner), 'sound/effects/ordeals/gold/tentacle_before_explode.ogg', 50, 0, 2)
	to_chat(owner, span_userdanger("You feel like something popped in your head!"))
	playsound(get_turf(owner), 'sound/effects/ordeals/gold/tentacle_explode.ogg', 100, 0, 4)
	for(var/mob/living/carbon/human/H in oview(3, src))
		H.apply_damage(250, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(H.health < 0)
			H.gib()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(7, get_turf(src))
	S.start()
	owner.apply_damage(500, RED_DAMAGE, null, owner.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	if(owner.health <= 0)
		owner.gib()

/mob/living/simple_animal/hostile/ordeal/sin_lust //Tank that is immune to bullets
	name = "Peccatulum Luxuriae"
	desc = "It looks like a creature made of lumps of flesh. It looks eagar to devour human flesh."
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	icon_state = "sincromer"
	icon_living = "sincromer"
	icon_dead = "sincromer_dead"
	pixel_x = -16
	base_pixel_x = -16
	faction = list("gold_ordeal")
	maxHealth = 1400
	health = 1400
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 30
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/gold/cromer_slam.ogg'
	death_sound = 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg'
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/lizard = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/lizard = 1)
	var/can_act = TRUE
	var/smash_damage = 45

/mob/living/simple_animal/hostile/ordeal/sin_lust/Initialize()
	..()
	AddComponent(/datum/component/knockback, 2, FALSE, TRUE)

/mob/living/simple_animal/hostile/ordeal/sin_lust/bullet_act(obj/projectile/P)
	visible_message(span_userdanger("[P] is blocked by [src]!"))
	P.Destroy()
	return

/mob/living/simple_animal/hostile/ordeal/sin_lust/attacked_by(obj/item/I, mob/living/user)
	var/checkdir = check_target_facings(user, src)
	if((get_dist(user, src) > 1) || checkdir == FACING_EACHOTHER)
		if(prob(25))
			user.visible_message(span_danger("[user]'s attack is easily deflected by [src]!"), span_userdanger("Your attack is easily deflected by [src]!"))
			return
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_lust/face_atom() //VERY important; prevents spinning while attacking
	if(!can_act)
		return
	..()

/mob/living/simple_animal/hostile/ordeal/sin_lust/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_lust/AttackingTarget()// AOE attacks only
	if(!can_act)
		return FALSE
	if(prob(50))
		return Smash(target, wide = pick(TRUE, FALSE))
	return ..()

//AoE attack taken from golden apple
/mob/living/simple_animal/hostile/ordeal/sin_lust/proc/Smash(target, wide = TRUE)
	if (!client && (get_dist(src, target) > 4))
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	var/upline = NORTH
	var/downline = SOUTH
	var/smash_length = 2
	var/smash_width = 2
	if(wide)
		playsound(get_turf(src), 'sound/effects/ordeals/gold/cromer_slam.ogg', 50, 0, 5)
	else
		playsound(get_turf(src), 'sound/effects/ordeals/gold/cromer_stab.ogg', 50, 0, 5)
		smash_length = 4
		smash_width = 1
	middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
	if(dir_to_target == NORTH || dir_to_target == SOUTH)
		upline = EAST
		downline = WEST
	for(var/turf/T in middle_line)
		if(T.density)
			break
		for(var/turf/Y in getline(T, get_ranged_target_turf(T, upline, smash_width)))
			if (Y.density)
				break
			if (Y in area_of_effect)
				continue
			area_of_effect += Y
		for(var/turf/U in getline(T, get_ranged_target_turf(T, downline, smash_width)))
			if (U.density)
				break
			if (U in area_of_effect)
				continue
			area_of_effect += U
	if(!dir_to_target)
		for(var/turf/TT in view(1, src))
			if (TT.density)
				break
			if (TT in area_of_effect)
				continue
			area_of_effect |= TT
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), smash_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

#undef STATUS_EFFECT_FUMING
#undef STATUS_EFFECT_VENOM

/obj/projectile/poisonglob
	name = "poison glob"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	hitsound = 'sound/abnormalities/ichthys/jump.ogg'
	damage = 20
	speed = 0.7
	damage_type = BLACK_DAMAGE
	color = "#218a18"

/obj/projectile/poisonglob/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/H = target
		H.apply_venom(3)
