// Note: teleport_away variable and death handling moved to base clan mob in lc13_resurgence_clan_mobs.dm

//////////////
// DEMOLISHER
//////////////
// Heavy siege unit with drills that deals massive damage to structures
// Builds up charge to perform explosive demolish attacks
// Drops a bomb on death that explodes after countdown
/mob/living/simple_animal/hostile/clan/demolisher
	name = "Demolisher"
	desc = "A humanoid looking machine with two drills... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_48x48.dmi'
	icon_state = "demolisher"
	icon_living = "demolisher"
	icon_dead = "demolisher_dead"
	pixel_x = -8
	base_pixel_x = -8
	attack_verb_continuous = "drills"
	attack_verb_simple = "drill"
	health = 1500
	maxHealth = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1.6)
	attack_sound = 'sound/weapons/drill.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 2,
						/obj/item/stack/sheet/silk/azure_advanced = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 3, /obj/item/food/meat/slab/sweeper = 2)
	melee_damage_lower = 5
	melee_damage_upper = 8
	charge = 10
	max_charge = 20
	clan_charge_cooldown = 1 SECONDS
	var/normal_attack_speed = 2
	var/max_attack_speed = 6
	var/demolish_damage = 30
	var/demolish_obj_damage = 600
	search_objects = 3
	search_objects_regain_time = 5
	wanted_objects = list(/obj/structure/barricade, /obj/machinery/manned_turret/rcorp)
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	teleport_away = TRUE
	var/shield = FALSE
	var/shield_counter = 0
	var/shield_time = 0
	var/max_shield_counter = 15

/mob/living/simple_animal/hostile/clan/demolisher/ChargeUpdated()
	rapid_melee = normal_attack_speed + (max_attack_speed - normal_attack_speed) * charge / max_charge

/mob/living/simple_animal/hostile/clan/demolisher/AttackingTarget()
	if (charge >= max_charge && (isliving(target) || istype(target, /obj)))
		say("Co-mmen-cing Pr-otoco-l: De-emoli-ish")
		demolish(target)
	. = ..()
	if (!target)
		FindTarget()

// Override TryAttack to ensure objects are only attacked when adjacent
/mob/living/simple_animal/hostile/clan/demolisher/TryAttack()
	if(QDELETED(src))
		return
	if(client || stat != CONSCIOUS || AIStatus != AI_ON || incapacitated() || !targets_from || !isturf(targets_from.loc))
		attack_is_on_cooldown = FALSE
		return

	var/atom/attacked_target
	var/should_gain_patience = FALSE

	// For objects, only attack if truly adjacent (distance 1)
	if(!QDELETED(target))
		if(isobj(target))
			// Strict adjacency check for objects
			if(get_dist(targets_from, target) == 1)
				attacked_target = target
				should_gain_patience = TRUE
		else
			// Normal check for living targets
			if(target.Adjacent(targets_from))
				attacked_target = target
				should_gain_patience = TRUE

	if(!attacked_target)
		// Look for other targets in melee range
		in_melee = FALSE
		var/list/targets_in_range = list()
		for(var/atom/A in view(1, targets_from))
			if(A == src || A == targets_from)
				continue
			if(CanAttack(A))
				// Extra check for objects
				if(isobj(A) && get_dist(targets_from, A) != 1)
					continue
				targets_in_range += A

		if(targets_in_range.len > 0)
			attacked_target = pick(targets_in_range)

	if(attacked_target)
		if(!AttackCondition(attacked_target))
			face_atom(attacked_target)
			attack_is_on_cooldown = FALSE
			if(delayed_attack_instances < 1)
				DelayedTryAttack(attack_cooldown)
			return
		attack_is_on_cooldown = TRUE
		AttackingTarget(attacked_target)
		if(QDELETED(src) || stat != CONSCIOUS)
			return
		ResetAttackCooldown(attack_cooldown)
		if(should_gain_patience)
			GainPatience()
	else
		attack_is_on_cooldown = FALSE
		if(delayed_attack_instances < 1)
			DelayedTryAttack(attack_cooldown)

// Override to only destroy when path is actually blocked
/mob/living/simple_animal/hostile/clan/demolisher/DestroyPathToTarget()
	if(!environment_smash || !target)
		return

	// Check if we can actually move towards our target
	var/turf/next_step = get_step_towards(src, target)
	if(!next_step || next_step == loc)
		return

	// Check if the path is blocked
	if(next_step.density)
		return ..() // Call parent to destroy blocking wall

	// Check for dense objects blocking our path
	for(var/obj/O in next_step)
		if(O.density && !O.CanPass(src, next_step))
			return ..() // Call parent to destroy blocking object

	// Path is clear, don't destroy anything
	return

/mob/living/simple_animal/hostile/clan/demolisher/DestroyObjectsInDirection(direction)
	// Only run when we have environment smash enabled
	if(!environment_smash)
		return

	var/turf/T = get_step(targets_from, direction)
	if(QDELETED(T))
		return

	// Check if the turf is actually adjacent (not the same turf we're on)
	if(T == get_turf(targets_from))
		return

	// Use Adjacent check instead of get_dist
	if(!T.Adjacent(targets_from))
		return

	if(CanSmashTurfs(T))
		T.attack_animal(src)
		return

	for(var/obj/O in T.contents)
		// Make sure the object is actually in the adjacent turf we're checking
		if(O.loc != T)
			continue
		if(IsSmashable(O))
			if (charge >= max_charge)
				say("Co-mmen-cing Pr-otoco-l: De-emoli-ish")
				demolish(O)
			O.attack_animal(src)
			return

/mob/living/simple_animal/hostile/clan/demolisher/proc/CheckListForWanted(listObjects)
	var/found = FALSE
	for(var/obj/O in listObjects)
		if (O.type in wanted_objects)
			found = TRUE
			break
	return found


/mob/living/simple_animal/hostile/clan/demolisher/ListTargets()
	var/list/objectsInView = oview(vision_range, targets_from)
	var/list/hearersInView = hearers(vision_range, targets_from) - src //Remove self, so we don't suicide
	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/vehicle/sealed/mecha))
	for(var/HM in typecache_filter_list(range(vision_range, targets_from), hostile_machines))
		if(can_see(targets_from, HM, vision_range))
			hearersInView += HM

	if(!search_objects)
		if (CheckListForWanted(objectsInView))
			search_objects = 3
			return objectsInView
		return hearersInView
	else
		if (!CheckListForWanted(objectsInView))
			search_objects = 0
			return hearersInView
		return objectsInView

/mob/living/simple_animal/hostile/clan/demolisher/Life()
	. = ..()
	if (shield && (shield_time < world.time - 5))
		shield = FALSE
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1.6))

/mob/living/simple_animal/hostile/clan/demolisher/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	..()
	if (shield)
		shield_counter += 1
		if (shield_counter > max_shield_counter && charge > 1)
			shield_counter = 0
			charge--

		var/obj/effect/temp_visual/shock_shield/AT = new /obj/effect/temp_visual/shock_shield(loc, src)
		var/random_x = rand(-16, 16)
		AT.pixel_x += random_x

		var/random_y = rand(5, 32)
		AT.pixel_y += random_y
	else
		if(charge >= 4)
			shield = TRUE
			ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5))
			shield_time = world.time

/mob/living/simple_animal/hostile/clan/demolisher/proc/demolish(atom/fool)
	playsound(fool, 'sound/effects/explosion2.ogg', 60, TRUE)
	new /obj/effect/temp_visual/explosion(get_turf(fool))
	if(isliving(fool))
		var/mob/living/T = fool
		T.deal_damage(demolish_damage, RED_DAMAGE)
	if(istype(fool, /obj))
		var/obj/O = fool
		if(IsSmashable(O))
			O.take_damage(demolish_obj_damage, RED_DAMAGE)
	for(var/turf/T in range(1, fool))
		HurtInTurf(T, list(), (demolish_damage), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE)
		for(var/obj/S in T)
			if(IsSmashable(S))
				S.take_damage(demolish_obj_damage*0.8, RED_DAMAGE)
	for(var/turf/T in range(3, fool))
		for(var/mob/living/L in T)
			L.Knockdown(20)
			shake_camera(L, 5, 5)
	charge = 0
	rapid_melee = normal_attack_speed

/mob/living/simple_animal/hostile/clan/demolisher/death(gibbed)
	var/obj/structure/demolisher_bomb/b = new /obj/structure/demolisher_bomb(loc)
	b.faction = faction
	. = ..()

//////////////
// DEMOLISHER BOMB
//////////////
// Dropped by demolisher on death - explodes after 12 second countdown
// Deals exponential damage based on distance (up to 4000 damage at point blank)
/obj/structure/demolisher_bomb
	name = "Resurgence Clan Bomb"
	icon = 'ModularTegustation/Teguicons/resurgence_48x48.dmi'
	desc = "There is a sign that says, 'If you can read this, You are in range.'"
	icon_state = "demolisher_bomb"
	max_integrity = 500
	pixel_x = -8
	base_pixel_x = -8
	density = FALSE
	layer = BELOW_OBJ_LAYER
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 100, BLACK_DAMAGE = 25, PALE_DAMAGE = 100)
	var/detonate_time = 120
	var/beep_time = 10
	var/beep_counter = 0
	var/detonate_max_damage = 4000
	var/detonate_min_damage = 15
	var/detonate_object_max_damage = 4000
	var/detonate_object_min_damage = 400
	var/list/faction = list("hostile")

/obj/structure/demolisher_bomb/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(detonate)), detonate_time)
	addtimer(CALLBACK(src, PROC_REF(beep)), beep_time)

/obj/structure/demolisher_bomb/proc/beep()
	playsound(loc, 'sound/items/timer.ogg', 40, 3, 3)
	if (beep_counter == 0)
		say("T-10 Seconds before detonation...")
	else if (beep_counter == 5)
		say("T-5 Seconds before detonation...")
	else if (beep_counter == 7)
		say("3...")
	else if (beep_counter == 8)
		say("2...")
	else if (beep_counter == 9)
		say("1...")
	else if (beep_counter == 10)
		say("Goodbye, ;)")

	beep_counter++
	addtimer(CALLBACK(src, PROC_REF(beep)), beep_time)

/obj/structure/demolisher_bomb/proc/detonate()
	var/mob/living/carbon/human/dummy/D = new /mob/living/carbon/human/dummy(get_turf(src))
	D.faction = faction
	new /obj/effect/temp_visual/explosion/fast(get_turf(src))
	playsound(src, 'sound/effects/explosion1.ogg', 75, TRUE)
	for(var/mob/living/L in view(8, src))
		if(D.faction_check_mob(L, FALSE))
			continue
		var/dist = get_dist(D, L)
		if(ishuman(L)) //Different damage formulae for humans vs mobs
			L.deal_damage(clamp((15 * (2 ** (8 - dist))), detonate_min_damage, detonate_max_damage), RED_DAMAGE) //15-3840 damage scaling exponentially with distance
		else
			L.deal_damage(600 - ((dist > 2 ? dist : 0 )* 75), RED_DAMAGE) //0-600 damage scaling on distance, we don't want it oneshotting mobs
	for(var/turf/T in view(8, src))
		var/obj_dist = get_dist(src, T)
		for(var/obj/S in T)
			S.take_damage(clamp((15 * (2 ** (8 - obj_dist))), detonate_object_min_damage, detonate_object_max_damage), RED_DAMAGE)
	explosion(loc, 0, 0, 1)
	qdel(D)
	qdel(src)

// Visual effect for teleporting units
/obj/effect/temp_visual/beam_out
	name = "teleport beam"
	desc = "A beam of light"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "beamout"
	pixel_x = -32
	base_pixel_x = -32
	color = "#FF5050"
	randomdir = FALSE
	duration = 4.2
	layer = POINT_LAYER

//////////////
// ASSASSIN
//////////////
// Stealth unit that builds charge to enter invisibility
// Performs devastating backstabs on isolated targets
// Can hunt specific targets across the entire z-level
/mob/living/simple_animal/hostile/clan/assassin
	name = "Assassin"
	desc = "A sleek humanoid machine with blade-like appendages... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_assassin"
	icon_living = "clan_assassin"
	icon_dead = "clan_assassin_dead"
	health = 800
	maxHealth = 800
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	attack_sound = 'sound/weapons/bladeslice.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1,
						/obj/item/stack/sheet/silk/azure_advanced = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	melee_damage_lower = 10
	melee_damage_upper = 15
	robust_searching = TRUE
	vision_range = 12
	aggro_vision_range = 12
	move_to_delay = 2.5
	charge = 0
	max_charge = 10
	clan_charge_cooldown = 3 SECONDS
	teleport_away = TRUE

	// Stealth system variables
	var/stealth_mode = FALSE
	var/stealth_alpha = 25
	var/stealth_speed_modifier = 0.7
	var/backstab_damage = 150
	var/backstab_damage_type = RED_DAMAGE
	var/charge_cost_stealth_hit = 5
	var/charge_cost_backstab = 10
	var/stun_duration_on_hit = 1.5 SECONDS
	var/isolation_check_range = 3
	var/z_level_hunt_mode = FALSE
	var/mob/living/carbon/human/hunt_target = null

/mob/living/simple_animal/hostile/clan/assassin/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_SHOE, 1, -6)

/mob/living/simple_animal/hostile/clan/assassin/Life()
	. = ..()
	if(!.)
		return

	// Charge management for stealth
	if(charge >= max_charge && !stealth_mode && !client)
		EnterStealth()
	else if(stealth_mode && charge <= 0)
		ExitStealth()

	// Update charge
	ChargeGain()

	// Activate hunt mode if in stealth with no nearby targets
	if(stealth_mode && !target && !z_level_hunt_mode && prob(10))
		ActivateHuntMode()

/mob/living/simple_animal/hostile/clan/assassin/proc/ChargeGain()
	if(last_charge_update < world.time - clan_charge_cooldown)
		if(stealth_mode)
			// No charge gain in stealth
			return
		else
			// Faster charge gain when not in stealth
			charge = min(charge + 2, max_charge)
			last_charge_update = world.time

/mob/living/simple_animal/hostile/clan/assassin/proc/EnterStealth()
	if(stealth_mode)
		return

	stealth_mode = TRUE
	alpha = stealth_alpha
	add_movespeed_modifier(/datum/movespeed_modifier/assassin_stealth)
	visible_message(span_warning("[src] fades into the shadows!"))
	playsound(src, 'sound/effects/curse5.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/assassin/proc/ExitStealth()
	if(!stealth_mode)
		return

	stealth_mode = FALSE
	alpha = 255
	remove_movespeed_modifier(/datum/movespeed_modifier/assassin_stealth)
	visible_message(span_danger("[src] emerges from the shadows!"))
	playsound(src, 'sound/effects/curse2.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/assassin/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stealth_mode) // Took damage while in stealth
		charge = max(0, charge - charge_cost_stealth_hit)
		Stun(stun_duration_on_hit)
		ExitStealth()

/mob/living/simple_animal/hostile/clan/assassin/AttackingTarget(atom/attacked_target)
	if(!attacked_target)
		attacked_target = target

	// Assassins cannot damage objects
	if(isobj(attacked_target))
		// Handle object climbing while in stealth
		if(stealth_mode && (istype(attacked_target, /obj/structure/table) || istype(attacked_target, /obj/structure/barricade)))
			ClimbOver(attacked_target)
		return

	// In stealth mode, only attack the hunt target
	if(stealth_mode)
		if(z_level_hunt_mode && hunt_target && attacked_target != hunt_target)
			return // Don't attack anyone except hunt target
		if(isliving(attacked_target))
			var/mob/living/L = attacked_target
			PerformBackstab(L)
		return

	return ..()

/mob/living/simple_animal/hostile/clan/assassin/proc/ClimbOver(obj/structure/S)
	if(!stealth_mode || !S || !isturf(S.loc))
		return

	var/turf/destination = get_step(S, get_dir(src, S))
	if(destination && !destination.density)
		forceMove(destination)
		playsound(src, 'sound/effects/footstep/hardbarefoot1.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/assassin/proc/PerformBackstab(mob/living/L)
	if(!stealth_mode || !L || charge < charge_cost_backstab)
		return

	// Announce the backstab
	say("Behind you.")
	SLEEP_CHECK_DEATH(7)

	// Exit stealth dramatically
	ExitStealth()
	SLEEP_CHECK_DEATH(3)

	// Perform the backstab if still in range
	if(L in range(1, src))
		visible_message(span_userdanger("[src] rips out [L]'s guts!"))
		playsound(L, 'sound/weapons/bladeslice.ogg', 100, TRUE)
		new /obj/effect/gibspawner/generic(get_turf(L))
		L.deal_damage(backstab_damage, backstab_damage_type)
		charge -= charge_cost_backstab

		// Re-enter stealth after a delay
		SLEEP_CHECK_DEATH(20)
		if(charge >= 2) // Need some charge to re-stealth
			EnterStealth()

		// Find new target
		LoseTarget()
		FindTarget()
	else
		// Target moved away, regular attack
		return

/mob/living/simple_animal/hostile/clan/assassin/PickTarget(list/Targets)
	if(!length(Targets))
		return null

	// Find the most isolated target
	var/mob/living/best_target = null
	var/best_isolation_score = -1

	for(var/mob/living/L in Targets)
		if(!isliving(L))
			continue

		var/isolation_score = GetIsolationScore(L)
		if(isolation_score > best_isolation_score)
			best_isolation_score = isolation_score
			best_target = L

	return best_target

/mob/living/simple_animal/hostile/clan/assassin/proc/GetIsolationScore(mob/living/L)
	if(!L)
		return 0

	var/nearby_allies = 0
	for(var/mob/living/potential_ally in view(isolation_check_range, L))
		if(potential_ally == L)
			continue
		if(L.faction_check_mob(potential_ally))
			nearby_allies++

	// Higher score = more isolated
	return 10 - nearby_allies

/mob/living/simple_animal/hostile/clan/assassin/MoveToTarget(list/possible_targets)
	// Handle z-level hunt target
	if(z_level_hunt_mode && hunt_target)
		if(hunt_target.stat == DEAD || hunt_target.z != z)
			z_level_hunt_mode = FALSE
			hunt_target = null
			target = null
		else if(!target || target != hunt_target)
			target = hunt_target

	if(stealth_mode && !target)
		// Don't break stealth just to acquire a target
		return TRUE

	if(!stealth_mode && target && get_dist(src, target) > 3)
		// Run away when not in stealth and target is close
		walk_away(src, target, 7, move_to_delay)
		return TRUE

	return ..()

// Z-level hunting - finds most isolated target on map
/mob/living/simple_animal/hostile/clan/assassin/proc/ActivateHuntMode()
	if(z_level_hunt_mode)
		return

	z_level_hunt_mode = TRUE
	var/mob/living/carbon/human/most_isolated = null
	var/best_isolation = -1

	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
		if(H.z != z || H.stat == DEAD)
			continue

		// Check if we can path to them
		var/list/path = get_path_to(src, H, /turf/proc/Distance_cardinal, 0, 200)
		if(!length(path))
			continue

		var/isolation = GetIsolationScore(H)
		if(isolation > best_isolation)
			best_isolation = isolation
			most_isolated = H

	if(most_isolated)
		hunt_target = most_isolated
		target = hunt_target
		visible_message(span_warning("[src]'s eyes glow as it locks onto a distant target!"))

// Movement speed modifier for stealth mode
/datum/movespeed_modifier/assassin_stealth
	multiplicative_slowdown = 2.5


//////////////
// BOMBER SPIDER
//////////////
// Suicide unit that targets structures
// 5 second countdown before massive explosion
/mob/living/simple_animal/hostile/clan/bomber_spider
	name = "bomber spider"
	desc = "A tiny mechanical spider packed with explosives. It seems to be targeting structures..."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_repair_hacked"
	icon_living = "drone_repair_hacked"
	icon_dead = "drone_repair_hacked_dead"
	maxHealth = 100
	health = 100
	melee_damage_lower = 5
	melee_damage_upper = 10
	move_to_delay = 5
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	guaranteed_butcher_results = list()
	search_objects = 2
	wanted_objects = list(/obj/structure/barricade, /obj/machinery/manned_turret/rcorp)
	del_on_death = TRUE
	teleport_away = TRUE
	var/primed = FALSE
	var/explosion_damage = 500
	var/explosion_range = 1

/mob/living/simple_animal/hostile/clan/bomber_spider/Life()
	. = ..()
	if(!.)
		return

	// Try to hide under other mobs
	if(!primed)
		for(var/mob/living/L in loc)
			if(L != src && L.density)
				layer = L.layer - 0.1
				return

/mob/living/simple_animal/hostile/clan/bomber_spider/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!. || primed)
		return

	if(isstructure(attacked_target) || ismachinery(attacked_target))
		Prime()

/mob/living/simple_animal/hostile/clan/bomber_spider/proc/Prime()
	if(primed)
		return

	primed = TRUE
	visible_message(span_userdanger("[src] begins to swell and glow!"))

	walk_to(src, 0)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 50)

	// Start rapid beeping
	RapidBeep()

	// Explode after delay
	addtimer(CALLBACK(src, PROC_REF(Detonate)), 5 SECONDS)

/mob/living/simple_animal/hostile/clan/bomber_spider/proc/RapidBeep()
	if(stat == DEAD || !primed)
		return

	playsound(loc, 'sound/items/timer.ogg', 50, 3, 3)

	// Continue beeping every 0.2 seconds
	addtimer(CALLBACK(src, PROC_REF(RapidBeep)), 2)

/mob/living/simple_animal/hostile/clan/bomber_spider/proc/Detonate()
	visible_message(span_userdanger("[src] detonates!"))

	// Deal massive damage to structures in range
	for(var/turf/T in view(explosion_range, src))
		for(var/atom/A in T)
			if(isstructure(A) || ismachinery(A))
				if(istype(A, /obj/structure))
					var/obj/structure/S = A
					S.take_damage(explosion_damage, RED_DAMAGE, "bomb", 0)
				else if(istype(A, /obj/machinery))
					var/obj/machinery/M = A
					M.take_damage(explosion_damage, RED_DAMAGE, "bomb", 0)

	// Visual explosion
	playsound(loc, 'sound/effects/explosion1.ogg', 50, TRUE)
	new /obj/effect/temp_visual/explosion(loc)

	// Die
	death()

//////////////
// ARTILLERY
//////////////
// Mobile drop pod launcher that collects and deploys mobs
// Stores up to 4 units and launches them at targets
/mob/living/simple_animal/hostile/artillery
	name = "cannon gondola?!"
	desc = "A massive, slow-moving artillery unit... Wait, are you sure this is the right way to call this thing?"
	icon = 'icons/obj/supplypods.dmi'
	icon_state = "gondola"
	icon_living = "gondola"
	pixel_x = -16//2x2 sprite
	maxHealth = 2000
	health = 2000
	move_to_delay = 10
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	melee_damage_lower = 0
	melee_damage_upper = 0
	retreat_distance = 8
	minimum_distance = 8
	ranged = TRUE // This makes it retreat without attacking
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	ranged_message = null
	vision_range = 10
	aggro_vision_range = 10
	mob_size = MOB_SIZE_LARGE
	var/list/stored_mobs = list()
	var/max_stored_mobs = 4
	var/collection_range = 8
	var/launch_range = 12
	var/last_collection_time = 0
	var/collection_cooldown = 5 SECONDS
	var/mutable_appearance/gondola_overlay
	var/list/stored_mob_data = list() // Stores original values for restoration

/mob/living/simple_animal/hostile/artillery/Initialize()
	. = ..()
	SetOccupiedTiles(1, 1, 1, 1)
	START_PROCESSING(SSobj, src)
	// Add the gondola_open overlay
	gondola_overlay = mutable_appearance('icons/obj/supplypods.dmi', "gondola_open")
	gondola_overlay.pixel_x = pixel_x
	gondola_overlay.pixel_y = pixel_y
	add_overlay(gondola_overlay)

/mob/living/simple_animal/hostile/artillery/Destroy()
	// Release all stored mobs
	for(var/mob/living/L in stored_mobs)
		// Re-enable the mob before releasing
		L.SetStun(0)
		L.SetImmobilized(0)
		REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, "artillery_stored")
		// Re-enable AI
		if(istype(L, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = L
			SA.AIStatus = AI_ON
			REMOVE_TRAIT(SA, TRAIT_IMMOBILIZED, "artillery_stored")
			// Restore original values
			if(stored_mob_data[SA])
				SA.melee_damage_lower = stored_mob_data[SA]["melee_damage_lower"]
				SA.melee_damage_upper = stored_mob_data[SA]["melee_damage_upper"]
				SA.faction = stored_mob_data[SA]["original_faction"]
				stored_mob_data -= SA
		L.forceMove(loc)
	stored_mobs.Cut()
	stored_mob_data.Cut()
	STOP_PROCESSING(SSobj, src)
	return ..()

/mob/living/simple_animal/hostile/artillery/process()
	if(stat == DEAD)
		return

	// Try to collect mobs
	if(world.time > last_collection_time + collection_cooldown && length(stored_mobs) < max_stored_mobs)
		CollectMob()

	// Launch when we have exactly 4 mobs AND can find a target
	if(length(stored_mobs) == 4)
		CheckForLaunchTarget()

/mob/living/simple_animal/hostile/artillery/proc/CollectMob()
	var/list/potential_targets = list()

	for(var/mob/living/L in range(collection_range, src))
		if(L == src || L.stat == DEAD)
			continue
		if(!faction_check_mob(L))
			continue
		if(L in stored_mobs)
			continue
		// Check line of sight
		if(!can_see(src, L, collection_range))
			continue
		potential_targets += L

	if(!length(potential_targets))
		return

	var/mob/living/target = pick(potential_targets)

	// Teleport effect
	playsound(src, 'sound/effects/cartoon_pop.ogg', 50, TRUE)
	new /obj/effect/temp_visual/dir_setting/ninja/phase/out(get_turf(target))

	// Store the mob
	target.forceMove(src)
	stored_mobs += target
	last_collection_time = world.time

	// Disable the mob while stored
	if(isliving(target))
		var/mob/living/L = target
		L.SetStun(INFINITY)
		L.SetImmobilized(INFINITY)
		ADD_TRAIT(L, TRAIT_HANDS_BLOCKED, "artillery_stored")
		// Disable AI to prevent attacking from inside
		if(istype(L, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = L
			SA.AIStatus = AI_OFF
			// Store original damage values for later restoration
			stored_mob_data[SA] = list(
				"melee_damage_lower" = SA.melee_damage_lower,
				"melee_damage_upper" = SA.melee_damage_upper,
				"original_faction" = SA.faction.Copy()
			)
			// Set damage to 0
			SA.melee_damage_lower = 0
			SA.melee_damage_upper = 0
			// Add neutral faction to prevent targeting
			SA.faction |= "neutral"
			if(istype(SA, /mob/living/simple_animal/hostile))
				var/mob/living/simple_animal/hostile/H = SA
				H.target = null
				H.LoseTarget()
			// Add trait to prevent movement
			ADD_TRAIT(SA, TRAIT_IMMOBILIZED, "artillery_stored")
			// Force stop all actions
			SA.stop_pulling()
			walk(SA, 0)

	visible_message(span_warning("[src] absorbs [target]!"))

/mob/living/simple_animal/hostile/artillery/proc/CheckForLaunchTarget()
	if(length(stored_mobs) < 4)
		return

	// Look for enemy targets (can fire through walls)
	var/list/potential_targets = list()
	for(var/mob/living/carbon/C in range(launch_range, src))
		if(faction_check_mob(C))
			continue
		potential_targets += C

	// Only launch if we have targets
	if(length(potential_targets))
		LaunchMobs(pick(potential_targets))

/mob/living/simple_animal/hostile/artillery/proc/LaunchMobs(mob/living/launch_target)
	if(!length(stored_mobs) || !launch_target)
		return

	var/turf/target_turf = get_turf(launch_target)

	visible_message(span_userdanger("[src] aims at [launch_target] and fires!"))
	playsound(src, 'sound/vehicles/carcannon1.ogg', 100, TRUE)

	// Firing animation - shake and flash
	var/old_x = pixel_x
	var/old_y = pixel_y
	animate(src, pixel_x = old_x + 2, pixel_y = old_y + 2, time = 1)
	animate(pixel_x = old_x - 2, pixel_y = old_y - 2, time = 1)
	animate(pixel_x = old_x + 2, pixel_y = old_y - 2, time = 1)
	animate(pixel_x = old_x - 2, pixel_y = old_y + 2, time = 1)
	animate(pixel_x = old_x, pixel_y = old_y, time = 2)

	// Visual feedback when firing - remove and re-add overlay for flicker effect
	cut_overlay(gondola_overlay)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, add_overlay), gondola_overlay), 2)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, cut_overlay), gondola_overlay), 4)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, add_overlay), gondola_overlay), 6)

	// Reset collection cooldown to prevent immediate re-collection
	last_collection_time = world.time

	// Launch all mobs in a burst pattern
	var/list/turfs_near_target = list()
	for(var/turf/T in view(2, target_turf))
		if(!T.density)
			turfs_near_target += T

	for(var/mob/living/L in stored_mobs)
		var/turf/landing_turf = length(turfs_near_target) ? pick(turfs_near_target) : target_turf

		// Re-enable the mob before launching
		L.SetStun(0)
		L.SetImmobilized(0)
		REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, "artillery_stored")
		// Re-enable AI
		if(istype(L, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = L
			SA.AIStatus = AI_ON
			REMOVE_TRAIT(SA, TRAIT_IMMOBILIZED, "artillery_stored")
			// Restore original values
			if(stored_mob_data[SA])
				SA.melee_damage_lower = stored_mob_data[SA]["melee_damage_lower"]
				SA.melee_damage_upper = stored_mob_data[SA]["melee_damage_upper"]
				SA.faction = stored_mob_data[SA]["original_faction"]
				stored_mob_data -= SA

		// Create drop pod with mob inside
		var/obj/structure/closet/supplypod/extractionpod/pod = new()
		pod.explosionSize = list(0,0,0,0)
		pod.icon_state = "orange"
		pod.door = "orange_door"
		pod.decal = "none"
		L.forceMove(pod)

		// Create landing zone
		new /obj/effect/pod_landingzone(landing_turf, pod)

		// Stun on landing
		addtimer(CALLBACK(src, PROC_REF(StunOnLanding), L), 2 SECONDS)

	stored_mobs.Cut()
	stored_mob_data.Cut()

/mob/living/simple_animal/hostile/artillery/proc/StunOnLanding(mob/living/L)
	if(!L || L.stat == DEAD)
		return
	L.Paralyze(10)
	playsound(L, 'sound/effects/meteorimpact.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/artillery/examine(mob/user)
	. = ..()
	. += span_notice("Stored mobs: [length(stored_mobs)]/[max_stored_mobs]")
	if(length(stored_mobs) >= max_stored_mobs)
		. += span_warning("Artillery is fully loaded and searching for targets!")

