/datum/ai_controller/insane
	continue_processing_when_client = TRUE
	blackboard = list(BB_INSANE_BEST_FORCE_FOUND = 10,\
	BB_INSANE_BLACKLISTITEMS = list(),\
	BB_INSANE_PICKUPTARGET = null,\
	BB_INSANE_CURRENT_ATTACK_TARGET = null)
	max_target_distance = 20
	var/resist_chance = 60
	var/datum/ai_behavior/say_line/insanity_lines/lines_type = /datum/ai_behavior/say_line/insanity_lines

	// De-elevated from Wander so that ANY insanity can roam and smash consoles, if given the behaviour.
	var/list/locations_visited = list()
	var/list/total_locations = list() // Primarily here so admins/maintainers can see where they can actually go.
	var/list/current_path = list()
	var/next_smash = 0

/datum/ai_controller/insane/TryPossessPawn(atom/new_pawn)
	if(!ishuman(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(on_attackby_animal))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, PROC_REF(on_hitby))
	RegisterSignal(new_pawn, COMSIG_MOVABLE_CROSSED, PROC_REF(on_Crossed))
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, PROC_REF(on_startpulling))
	return ..() //Run parent at end

/datum/ai_controller/insane/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(
		COMSIG_PARENT_ATTACKBY,
		COMSIG_ATOM_ATTACK_ANIMAL,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_BULLET_ACT,
		COMSIG_ATOM_HITBY,
		COMSIG_MOVABLE_CROSSED,
		COMSIG_LIVING_START_PULL
		))
	return ..()

/datum/ai_controller/insane/able_to_run()
	var/mob/living/carbon/human/human_pawn = pawn

	if(IS_DEAD_OR_INCAP(human_pawn))
		return FALSE
	return ..()

/datum/ai_controller/insane/SelectBehaviors(delta_time)
	current_behaviors = list()
	if(ResistCheck() && DT_PROB(resist_chance, delta_time))
		current_behaviors |= GET_AI_BEHAVIOR(/datum/ai_behavior/resist)
	return

/datum/ai_controller/insane/proc/retaliate(mob/living/L)
	if(L != pawn)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = L
		current_movement_target = L
	return

/datum/ai_controller/insane/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_attackby_animal(datum/source, mob/living/simple_animal/animal)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_attack_hand(datum/source, mob/living/L)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_attack_paw(datum/source, mob/living/L)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_bullet_act(datum/source, obj/projectile/Proj)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_Crossed(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_startpulling(datum/source, atom/movable/puller, state, force)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/ResistCheck()
	var/mob/living/living_pawn = pawn
	if(living_pawn.pulledby || SHOULD_RESIST(living_pawn))
		return TRUE
	return FALSE

/datum/ai_controller/insane/murder
	lines_type = /datum/ai_behavior/say_line/insanity_lines
	resist_chance = 80 // Anger powered break out attempts
	var/list/currently_scared = list()
	var/timerid = null
	var/interest = 3
	var/asshole = FALSE

/datum/ai_controller/insane/murder/PossessPawn(atom/new_pawn)
	. = ..()
	if(SSmaptype.maptype == "city")
		total_locations |= SScityevents.spawners
		return
	total_locations |= GLOB.xeno_spawn // Avoids Department centers, unlike Wander Panic

/datum/ai_controller/insane/murder/PerformMovement(delta_time)
	if(!isnull(timerid))
		return FALSE
	return ..()

/datum/ai_controller/insane/murder/MoveTo(delta_time)
	var/mob/living/living_pawn = pawn
	if(!able_to_run() || !current_movement_target || QDELETED(current_movement_target) || current_movement_target.z != living_pawn.z || get_dist(living_pawn, current_movement_target) > max_target_distance)
		timerid = null
		return FALSE
	var/mob/living/selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	var/move_mod = living_pawn.cached_multiplicative_slowdown
	var/obj/item/gun/ego_gun/banger = locate() in living_pawn.held_items
	if(banger)
		move_mod *= 1.4
	else
		move_mod *= 1.2


	timerid = addtimer(CALLBACK(src, PROC_REF(MoveTo), delta_time), move_mod) // SLIGHTLY slower than what they should be *BUT* takes corners better.

	var/turf/our_turf = get_turf(living_pawn)
	var/turf/target_turf
	var/current_dist = get_dist(living_pawn, selected_enemy)
	if((current_dist < 2) && banger && asshole)
		target_turf = get_step_away(living_pawn, current_movement_target)
	else if (current_dist == 2)
		return
	else
		target_turf = get_step_towards(living_pawn, current_movement_target)
	if(!is_type_in_typecache(target_turf, GLOB.dangerous_turfs))
		living_pawn.Move(target_turf, get_dir(our_turf, target_turf))
	if(!(selected_enemy in viewers(7, living_pawn))) // If you can't see the target enough
		interest--
		if(interest <= 0) // Give up
			interest = 3
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			CancelActions()
			return
	else
		interest = 3
	if(get_dist(living_pawn, current_movement_target) > max_target_distance)
		CancelActions()
		pathing_attempts = 0
	if(our_turf == get_turf(living_pawn) && !isliving(current_movement_target))
		if(++pathing_attempts >= MAX_PATHING_ATTEMPTS)
			CancelActions()
			pathing_attempts = 0

	return TRUE

/datum/ai_controller/insane/murder/SelectBehaviors(delta_time)
	..()
	var/mob/living/living_pawn = pawn
	var/mob/living/selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	// Ah ha! We'll fight our current enemy.
	if(selected_enemy && istype(selected_enemy))
		if(selected_enemy.status_flags & GODMODE)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(!(selected_enemy in livinginrange(10, living_pawn)))
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(selected_enemy.stat != DEAD)
			current_movement_target = selected_enemy
			if(DT_PROB(50, delta_time))
				current_behaviors += GET_AI_BEHAVIOR(lines_type)
			current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_attack_mob)
			return
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
		return

	// No current enemy? We'll arm ourselves!
	if(TryFindWeapon()) // Find a weapon before a new enemy.
		return

	// Armed enough..? Well we'll find a new person to fight!
	if(FindEnemies())
		return


/datum/ai_controller/insane/murder/PerformIdleBehavior(delta_time)
	// No current enemy? We'll arm ourselves!
	if(TryFindWeapon()) // Find a weapon before a new enemy.
		return
	// Armed enough..? Well we'll find a new person to fight!
	if(FindEnemies())
		return
	// No one to fight!? Well we'll go find someone to fight!
	var/list/possible_locs = list()
	for(var/turf/T in total_locations)
		if(get_dist(pawn, T) < 5)
			continue
		if(blackboard[BB_INSANE_BLACKLISTITEMS][T] > world.time)
			continue
		if(T in locations_visited)
			continue
		possible_locs += T
	var/turf/open/T = pick(possible_locs)
	if(T)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_wander/murder_wander)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = T
		locations_visited |= T
		if(locations_visited.len > (total_locations.len*0.75)) // Should encourage diversity
			locations_visited.Cut(1, 2)
	else
		locations_visited.Cut(1, 2) // Maybe we're too limited somehow...

/datum/ai_controller/insane/murder/ResistCheck()
	var/mob/living/living_pawn = pawn
	if(living_pawn.pulledby && living_pawn.pulledby?.grab_state < GRAB_AGGRESSIVE)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = living_pawn.pulledby
	else
		return SHOULD_RESIST(living_pawn)
	return FALSE

/datum/ai_controller/insane/murder/proc/TryFindWeapon()
	var/mob/living/living_pawn = pawn

	if(!locate(/obj/item) in living_pawn.held_items)
		blackboard[BB_INSANE_BEST_FORCE_FOUND] = 10

	var/obj/item/W
	for(var/obj/item/i in living_pawn.get_equipped_items())
		if(!istype(i))
			continue
		if(blackboard[BB_INSANE_BLACKLISTITEMS][i])
			continue
		if(!IsBetterWeapon(living_pawn, i, blackboard[BB_INSANE_BEST_FORCE_FOUND]))
			continue
		blackboard[BB_INSANE_PICKUPTARGET] = i
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/inventory)
		return TRUE

	for(var/obj/item/i in view(7, living_pawn))
		if(!istype(i))
			continue
		if(blackboard[BB_INSANE_BLACKLISTITEMS][i])
			continue
		if(!IsBetterWeapon(living_pawn, i, blackboard[BB_INSANE_BEST_FORCE_FOUND]))
			continue
		W = i
		break

	if(W)
		blackboard[BB_INSANE_PICKUPTARGET] = W
		current_movement_target = W
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/ground)
		return TRUE
	return FALSE

/proc/IsBetterWeapon(mob/living/L, obj/item/I, current_highest_force)
	var/weapon_power = I.force
	weapon_power *= 1 + (get_attribute_level(L, JUSTICE_ATTRIBUTE)/100)
	if(istype(I, /obj/item/ego_weapon))
		var/obj/item/ego_weapon/ego_i = I
		weapon_power /= ego_i.attack_speed ? ego_i.attack_speed : 1
	else if(istype(I, /obj/item/gun/ego_gun))
		var/obj/item/gun/ego_gun/gun_i = I
		var/obj/item/ammo_casing/casing = initial(gun_i.ammo_type)
		var/obj/projectile/boolet = initial(casing.projectile_type)
		weapon_power = initial(boolet.damage) * gun_i.burst_size * initial(casing.pellets)
		if(gun_i.autofire)
			weapon_power *= gun_i.autofire
		else
			weapon_power /= (gun_i.fire_delay ? gun_i.fire_delay : 10)/10
	return weapon_power > current_highest_force

/datum/ai_controller/insane/murder/proc/FindEnemies()
	. = FALSE
	var/mob/living/living_pawn = pawn
	var/list/potential_enemies = viewers(9, living_pawn)

	if(!LAZYLEN(potential_enemies)) // We aint see shit!
		return

	var/attempt_count = 0
	for(var/mob/living/L in potential_enemies) // Oh the CHOICES!
		if(L == living_pawn)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		attempt_count++
		if(DT_PROB(33, attempt_count) || potential_enemies.len == 1) // Target spotted (bold)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = L
			return TRUE

// We stop trying to pick up a weapon if we're suddenly attacked
/datum/ai_controller/insane/murder/retaliate(mob/living/L)
	for(var/datum/ai_behavior/insane_equip/I in current_behaviors)
		I.finish_action(src, TRUE)
	return ..()

/datum/ai_controller/insane/murder/on_attackby(datum/source, obj/item/I, mob/user)
	..()
	retaliate(user)
	return

/datum/ai_controller/insane/murder/on_attackby_animal(datum/source, mob/living/simple_animal/animal)
	..()
	retaliate(animal)
	return

/datum/ai_controller/insane/murder/on_attack_hand(datum/source, mob/living/L)
	..()
	retaliate(L)
	return

/datum/ai_controller/insane/murder/on_attack_paw(datum/source, mob/living/L)
	..()
	retaliate(L)
	return

/datum/ai_controller/insane/murder/on_bullet_act(datum/source, obj/projectile/Proj)
	..()
	if(isliving(Proj.firer))
		retaliate(Proj.firer)
	return

/datum/ai_controller/insane/murder/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	..()
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		if(I.throwforce < living_pawn.health && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			retaliate(H)
	return

/datum/ai_controller/insane/murder/on_Crossed(datum/source, atom/movable/AM)
	..()
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && ismob(AM))
		retaliate(AM)
		return
	return

/datum/ai_controller/insane/murder/on_startpulling(datum/source, atom/movable/puller, state, force)
	..()
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn))
		retaliate(living_pawn.pulledby)
		return TRUE
	return FALSE

/datum/ai_controller/insane/suicide
	resist_chance = 0 // We'll die anyway
	lines_type = /datum/ai_behavior/say_line/insanity_lines/insanity_suicide
	var/suicide_timer = 0

/datum/ai_controller/insane/suicide/PerformIdleBehavior(delta_time)
	var/mob/living/carbon/human/human_pawn = pawn
	var/suicide_target = 6 + round(get_attribute_level(human_pawn, PRUDENCE_ATTRIBUTE) / 8)
	if(DT_PROB(10, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)
		human_pawn.jitteriness += 10
		human_pawn.do_jitter_animation(human_pawn.jitteriness)
		suicide_timer += 1
	if((suicide_timer >= suicide_target) && (human_pawn.mobility_flags & MOBILITY_MOVE))
		human_pawn.visible_message("<span class='danger'>[human_pawn] is twisting their neck, they are trying to commit suicide!</span>")
		human_pawn.adjustBruteLoss(400)
		human_pawn.jitteriness = 0
		var/sanity_damage = get_user_level(human_pawn) * 70
		for(var/mob/living/carbon/human/H in view(7, human_pawn))
			if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
				continue
			H.apply_damage(sanity_damage, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))

/datum/ai_controller/insane/wander
	lines_type = /datum/ai_behavior/say_line/insanity_lines/insanity_wander
	var/last_message = 0
	var/suicide_enter = 0

/datum/ai_controller/insane/wander/PossessPawn(atom/new_pawn)
	. = ..()
	suicide_enter = world.time + 60 SECONDS
	if(SSmaptype.maptype == "city")
		total_locations |= SScityevents.spawners
		return
	total_locations |= GLOB.department_centers
	total_locations |= GLOB.xeno_spawn

/datum/ai_controller/insane/wander/SelectBehaviors(delta_time)
	..()
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return

	var/list/possible_locs = list()
	for(var/turf/T in total_locations)
		if(get_dist(pawn, T) < 5)
			continue
		if(blackboard[BB_INSANE_BLACKLISTITEMS][T] > world.time)
			continue
		if(T in locations_visited)
			continue
		possible_locs += T
	var/turf/open/T = pick(possible_locs)
	if(T)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_wander/suicide_wander)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = T
		locations_visited |= T
		if(locations_visited.len > (total_locations.len*0.75)) // Should encourage diversity
			locations_visited.Cut(1, 2)
	else
		locations_visited.Cut(1, 2) // Maybe we're too limited somehow...

/datum/ai_controller/insane/wander/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if((living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	if(world.time > last_message + 6 SECONDS)
		last_message = world.time
		current_behaviors += GET_AI_BEHAVIOR(lines_type)
	if(world.time > suicide_enter)
		if(DT_PROB(10, delta_time))
			living_pawn.visible_message("<span class='danger'>[living_pawn] freezes with an expression of despair on their face!</span>")
			QDEL_NULL(living_pawn.ai_controller)
			living_pawn.ai_controller = /datum/ai_controller/insane/suicide
			living_pawn.InitializeAIController()
		else
			suicide_enter = world.time + 30 SECONDS

/datum/ai_controller/insane/release
	lines_type = /datum/ai_behavior/say_line/insanity_lines/insanity_release

/datum/ai_controller/insane/release/PossessPawn(atom/new_pawn)
	. = ..()
	next_smash = world.time + 10 SECONDS

/datum/ai_controller/insane/release/SelectBehaviors(delta_time)
	..()
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null || (GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_smash_console) in current_behaviors))
		return

	if(DT_PROB(5, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/AC in GLOB.lobotomy_devices)
		if(!AC.can_meltdown)
			continue
		if(!AC.datum_reference)
			continue
		if(!(AC.datum_reference.current.status_flags & GODMODE))
			continue
		if(blackboard[BB_INSANE_BLACKLISTITEMS][AC] > world.time)
			continue
		if((AC.datum_reference.qliphoth_meter_max > 0) && (AC.datum_reference.qliphoth_meter > 0))
			if(get_dist(pawn, AC) < 50)
				potential_computers += AC
	if(LAZYLEN(potential_computers))
		var/obj/machinery/computer/abnormality/chosen = get_closest_atom(/obj/machinery/computer/abnormality, potential_computers, pawn)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_smash_console)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = chosen

/datum/ai_controller/insane/release/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(DT_PROB(25, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
