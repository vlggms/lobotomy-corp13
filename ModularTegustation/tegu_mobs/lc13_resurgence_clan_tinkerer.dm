//////////////
// TINKERER
//////////////
// Commander unit that controls other clan units via RTS-style interface
// Can build factories and barricades, produce units, and issue orders
// Has viewing mode for scouting and charge system for abilities
/mob/living/simple_animal/hostile/clan/tinkerer
	name = "Tinkerer"
	desc = "A mechanical engineer with multiple manipulator arms... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_64x96.dmi'
	icon_state = "tinker"
	icon_living = "tinker"
	icon_dead = "tinker_d"
	pixel_x = -16
	base_pixel_x = -16
	health = 9999
	maxHealth = 9999
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	attack_sound = 'sound/weapons/tap.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 2,
						/obj/item/stack/sheet/silk/azure_advanced = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	melee_damage_lower = 5
	melee_damage_upper = 10
	robust_searching = TRUE
	stat_attack = CONSCIOUS
	vision_range = 14
	aggro_vision_range = 14
	move_to_delay = 4
	charge = 5
	max_charge = 20
	var/base_max_charge = 20
	var/charge_per_factory = 5
	clan_charge_cooldown = 2 SECONDS
	teleport_away = TRUE
	retreat_distance = 8
	minimum_distance = 6
	melee_damage_lower = 0
	melee_damage_upper = 0

	// Command and control variables
	var/viewing_mode = FALSE
	var/list/selected_units = list()
	var/max_selected_units = 5
	var/list/owned_factories = list()
	var/list/controlled_units = list()
	var/order_move_cost = 2
	var/order_attack_cost = 3
	var/order_overclock_cost = 5
	var/viewing_alpha = 0
	var/viewing_speed_modifier = 0.3
	var/hard_lock_mode = FALSE // Toggle between passive and hard lock on for attack orders
	// Construction point types for factory placement
	var/list/construction_point_types = list(
		/obj/structure/table,
		/obj/structure/rack,
		/obj/machinery/computer,
		/obj/machinery/vending,
		/obj/structure/closet
	)
	// Barricade construction variables
	var/turf/barricade_start_point = null
	var/barricade_cost = 3
	// Unit selection variables
	var/turf/selection_start_point = null
	// Factory construction variables
	var/factory_blueprint_cost = 10

/mob/living/simple_animal/hostile/clan/tinkerer/Initialize()
	. = ..()
	// Create initial factory
	addtimer(CALLBACK(src, PROC_REF(CreateInitialFactory)), 2 SECONDS)
	// Add abilities
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_scout(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_engineer(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_assassin(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_demolisher(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_defender(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_drone(null, src))
	AddAbility(new /obj/effect/proc_holder/spell/aimed/tinkerer_select_unit(null, src))
	AddAbility(new /obj/effect/proc_holder/spell/aimed/tinkerer_move_order(null, src))
	AddAbility(new /obj/effect/proc_holder/spell/aimed/tinkerer_attack_order(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/overclock_order(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/toggle_lock_mode(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/release_locks(null, src))
	AddAbility(new /obj/effect/proc_holder/spell/aimed/tinkerer_build_barricade(null, src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/build_order(null, src))

/mob/living/simple_animal/hostile/clan/tinkerer/examine(mob/user)
	. = ..()
	. += span_notice("Charge: [charge]/[max_charge]")
	. += span_notice("Selected units: [length(selected_units)]/[max_selected_units]")
	. += span_notice("Controlled units: [length(controlled_units)]")
	. += span_notice("Factories owned: [length(owned_factories)]")
	if(viewing_mode)
		. += span_boldnotice("Currently in viewing mode (invulnerable).")
	. += span_notice("Attack mode: [hard_lock_mode ? "Hard Lock" : "Passive"]")

/mob/living/simple_animal/hostile/clan/tinkerer/Life()
	. = ..()
	if(!.)
		return

	// Update charge
	ChargeGain()

	// Clean up dead units
	CleanupDeadUnits()
	
	// Update max charge based on factories
	UpdateMaxCharge()

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ChargeGain()
	if(last_charge_update < world.time - clan_charge_cooldown)
		charge = min(charge + 1, max_charge)
		last_charge_update = world.time

/mob/living/simple_animal/hostile/clan/tinkerer/proc/UpdateMaxCharge()
	var/new_max_charge = base_max_charge + (length(owned_factories) * charge_per_factory)
	if(new_max_charge != max_charge)
		max_charge = new_max_charge
		// If current charge exceeds new max, cap it
		if(charge > max_charge)
			charge = max_charge

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ToggleViewingMode()
	if(viewing_mode)
		ExitViewingMode()
	else
		EnterViewingMode()

/mob/living/simple_animal/hostile/clan/tinkerer/proc/EnterViewingMode()
	if(viewing_mode)
		return

	viewing_mode = TRUE
	alpha = viewing_alpha
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	add_movespeed_modifier(/datum/movespeed_modifier/tinkerer_viewing)
	density = FALSE
	status_flags |= GODMODE // Invulnerable in viewing mode
	is_flying_animal = TRUE // Can pass over tables and other obstacles
	visible_message(span_notice("[src] activates surveillance mode!"))
	playsound(src, 'sound/mecha/mechmove01.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ExitViewingMode()
	if(!viewing_mode)
		return

	viewing_mode = FALSE
	alpha = 255
	mouse_opacity = initial(mouse_opacity)
	remove_movespeed_modifier(/datum/movespeed_modifier/tinkerer_viewing)
	density = initial(density)
	status_flags &= ~GODMODE // Remove invulnerability
	is_flying_animal = FALSE // Back to normal movement
	visible_message(span_notice("[src] returns to command mode!"))
	playsound(src, 'sound/mecha/mechmove04.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/CreateInitialFactory()
	var/turf/T = get_turf(src)
	if(!T)
		return

	var/obj/structure/clan_factory/F = new(T)
	F.owner = src
	owned_factories += F
	visible_message(span_notice("[src] deploys a production facility!"))

/mob/living/simple_animal/hostile/clan/tinkerer/proc/SelectUnit(mob/living/simple_animal/hostile/clan/unit)
	if(!unit || unit.stat == DEAD || !(unit in controlled_units))
		return FALSE

	if(unit in selected_units)
		selected_units -= unit
		unit.RemoveSelectedVisual()
	else if(length(selected_units) < max_selected_units)
		selected_units += unit
		unit.AddSelectedVisual()
		return TRUE

	return FALSE

/mob/living/simple_animal/hostile/clan/tinkerer/proc/BoxSelectUnits(turf/start_point, turf/end_point)
	if(!start_point || !end_point)
		return
	
	// Get bounds of selection box
	var/min_x = min(start_point.x, end_point.x)
	var/max_x = max(start_point.x, end_point.x)
	var/min_y = min(start_point.y, end_point.y)
	var/max_y = max(start_point.y, end_point.y)
	
	// Clear current selection
	for(var/mob/living/simple_animal/hostile/clan/unit in selected_units)
		unit.RemoveSelectedVisual()
	selected_units.Cut()
	
	// Find all units in box
	var/list/units_in_box = list()
	for(var/mob/living/simple_animal/hostile/clan/unit in controlled_units)
		if(unit.stat == DEAD)
			continue
		var/turf/unit_turf = get_turf(unit)
		if(!unit_turf || unit_turf.z != start_point.z)
			continue
		if(unit_turf.x >= min_x && unit_turf.x <= max_x && unit_turf.y >= min_y && unit_turf.y <= max_y)
			units_in_box += unit
	
	// Select up to max_selected_units
	var/selected_count = 0
	for(var/mob/living/simple_animal/hostile/clan/unit in units_in_box)
		if(selected_count >= max_selected_units)
			break
		selected_units += unit
		unit.AddSelectedVisual()
		selected_count++
	
	if(selected_count)
		visible_message(span_notice("[src] selects [selected_count] unit\s!"))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	else
		to_chat(src, span_warning("No controlled units found in selection area!"))

/mob/living/simple_animal/hostile/clan/tinkerer/proc/IssueMovementOrder(turf/destination, rush_mode = FALSE)
	if(viewing_mode || !length(selected_units) || charge < order_move_cost)
		return

	charge -= order_move_cost
	for(var/mob/living/simple_animal/hostile/clan/unit in selected_units)
		if(unit.stat == DEAD)
			continue
		unit.ReceiveMovementOrder(destination, rush_mode)

	visible_message(span_notice("[src] issues movement orders!"))
	playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/IssueAttackOrder(atom/target)
	if(viewing_mode || !length(selected_units) || !target)
		return
	
	var/cost = hard_lock_mode ? order_attack_cost * 2 : order_attack_cost
	if(charge < cost)
		to_chat(src, span_warning("Not enough charge! Need [cost] charge."))
		return

	charge -= cost
	for(var/mob/living/simple_animal/hostile/clan/unit in selected_units)
		if(unit.stat == DEAD)
			continue
		unit.ReceiveAttackOrder(target, hard_lock_mode)

	visible_message(span_danger("[src] issues [hard_lock_mode ? "hard lock" : "passive"] attack orders!"))
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/IssueOverclockOrder()
	if(viewing_mode || !length(selected_units) || charge < order_overclock_cost)
		return

	charge -= order_overclock_cost
	for(var/mob/living/simple_animal/hostile/clan/unit in selected_units)
		if(unit.stat == DEAD)
			continue
		unit.ReceiveOverclockOrder()

	visible_message(span_userdanger("[src] overclocks the selected units!"))
	playsound(src, 'sound/machines/warning-buzzer.ogg', 75, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/CleanupDeadUnits()
	for(var/mob/living/simple_animal/hostile/clan/unit in controlled_units)
		if(unit.stat == DEAD || QDELETED(unit))
			controlled_units -= unit
			selected_units -= unit
			unit.RemoveSelectedVisual()

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ReleaseAllLocks()
	for(var/mob/living/simple_animal/hostile/clan/unit in controlled_units)
		if(unit.stat == DEAD)
			continue
		unit.ReleaseHardLock()
	visible_message(span_notice("[src] releases all hard locks!"))
	playsound(src, 'sound/machines/terminal_off.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/IsConstructionPoint(obj/O)
	if(!O)
		return FALSE
	for(var/type in construction_point_types)
		if(istype(O, type))
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/clan/tinkerer/proc/BuildBarricadeLine(turf/start_point, turf/end_point)
	if(!start_point || !end_point)
		return
	
	// Check line of sight
	if(!CheckLineOfSight(start_point, end_point))
		to_chat(src, span_warning("No line of sight between points!"))
		return
	
	// Get all turfs in line
	var/list/line_turfs = getline(start_point, end_point)
	var/list/valid_turfs = list()
	
	// Check each turf for validity
	for(var/turf/T in line_turfs)
		if(T.density)
			continue
		
		// Check for adjacent barricades
		var/adjacent_barricade = FALSE
		for(var/turf/adjacent in get_adjacent_open_turfs(T))
			if(locate(/obj/structure/barricade/clan) in adjacent)
				adjacent_barricade = TRUE
				break
			if(locate(/obj/structure/barricade/clan/blueprint) in adjacent)
				adjacent_barricade = TRUE
				break
		
		if(adjacent_barricade)
			continue
			
		// Check if already has barricade
		if(locate(/obj/structure/barricade/clan) in T)
			continue
		if(locate(/obj/structure/barricade/clan/blueprint) in T)
			continue
			
		valid_turfs += T
	
	// Check charge
	var/total_cost = length(valid_turfs) * barricade_cost
	if(charge < total_cost)
		to_chat(src, span_warning("Not enough charge! Need [total_cost] charge for [length(valid_turfs)] barricades."))
		return
	
	if(!length(valid_turfs))
		to_chat(src, span_warning("No valid positions for barricades!"))
		return
	
	// Build blueprints
	charge -= total_cost
	for(var/turf/T in valid_turfs)
		new /obj/structure/barricade/clan/blueprint(T)
	
	visible_message(span_notice("[src] deploys barricade blueprints!"))
	playsound(src, 'sound/effects/phasein.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/CheckLineOfSight(turf/start_point, turf/end_point)
	for(var/turf/T in getline(start_point, end_point))
		if(T.opacity)
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/clan/tinkerer/proc/BuildFactoryBlueprint()
	// Check charge
	if(charge < factory_blueprint_cost)
		to_chat(src, span_warning("Not enough charge! Need [factory_blueprint_cost] charge."))
		return FALSE
	
	// Check for adjacent construction points
	var/list/valid_construction_points = list()
	for(var/turf/T in get_adjacent_open_turfs(src))
		for(var/obj/O in T)
			if(IsConstructionPoint(O))
				// Check if there's already a blueprint here
				if(locate(/obj/structure/clan_factory/blueprint) in T)
					continue
				valid_construction_points[T] = O
	
	if(!length(valid_construction_points))
		to_chat(src, span_warning("No valid construction points found adjacent to you!"))
		return FALSE
	
	// If multiple valid points, use the first one
	var/turf/chosen_turf
	var/obj/construction_obj
	for(var/turf/T in valid_construction_points)
		chosen_turf = T
		construction_obj = valid_construction_points[T]
		break
	
	// Deduct charge and create blueprint
	charge -= factory_blueprint_cost
	new /obj/structure/clan_factory/blueprint(chosen_turf)
	visible_message(span_notice("[src] deploys a factory blueprint on [construction_obj]!"))
	playsound(src, 'sound/effects/phasein.ogg', 50, TRUE)
	return TRUE

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ProduceUnitAtFactory(unit_type)
	// Find nearest factory with capacity
	var/obj/structure/clan_factory/best_factory = null
	var/min_distance = INFINITY
	
	to_chat(src, span_notice("Attempting to produce [unit_type]..."))
	to_chat(src, span_notice("Owned factories: [length(owned_factories)]"))
	
	for(var/obj/structure/clan_factory/F in owned_factories)
		if(F.CanProduce(unit_type))
			var/dist = get_dist(src, F)
			if(dist < min_distance)
				min_distance = dist
				best_factory = F
	
	if(!best_factory)
		to_chat(src, span_warning("No available factory with sufficient capacity!"))
		return FALSE
	
	to_chat(src, span_notice("Factory found, starting production..."))
	best_factory.ProduceUnit(unit_type)
	return TRUE

// Tinkerer cannot attack directly
/mob/living/simple_animal/hostile/clan/tinkerer/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/clan/tinkerer/AttackingTarget(atom/attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/clan/tinkerer/death(gibbed)
	// Destroy all factories and units
	for(var/obj/structure/clan_factory/F in owned_factories)
		F.Destroy()
	for(var/mob/living/simple_animal/hostile/clan/unit in controlled_units)
		unit.commander_died()
	. = ..()

//////////////
// FACTORY STRUCTURE
//////////////
// Production facility that creates clan units
// Each factory has limited capacity based on unit costs
/obj/structure/clan_factory
	name = "Resurgence Clan Factory"
	desc = "A compact automated production facility."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "green_dusk_1"
	density = TRUE
	anchored = TRUE
	max_integrity = 1500
	pixel_x = -16
	base_pixel_x = -16
	var/mob/living/simple_animal/hostile/clan/tinkerer/owner
	var/production_capacity = 10
	var/used_capacity = 0
	var/list/produced_units = list()
	var/producing = FALSE
	var/production_time = 10 SECONDS

/obj/structure/clan_factory/examine(mob/user)
	. = ..()
	. += span_notice("Capacity: [used_capacity]/[production_capacity]")
	if(producing)
		. += span_boldnotice("Currently producing a unit...")
	if(owner)
		. += span_notice("Controlled by [owner].")

/obj/structure/clan_factory/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/clan_factory/Destroy()
	STOP_PROCESSING(SSobj, src)
	// Destroy all units from this factory
	for(var/mob/living/simple_animal/hostile/clan/unit in produced_units)
		unit.factory_destroyed()
	if(owner)
		owner.owned_factories -= src
		owner.UpdateMaxCharge()
	. = ..()

/obj/structure/clan_factory/process()
	if(!owner || owner.stat == DEAD)
		Destroy()
		return
	
	// Clean up dead units
	for(var/mob/living/simple_animal/hostile/clan/unit in produced_units)
		if(unit.stat == DEAD || QDELETED(unit))
			produced_units -= unit
			used_capacity -= GetUnitCost(unit.type)
			used_capacity = max(0, used_capacity) // Ensure it doesn't go negative

/obj/structure/clan_factory/proc/CanProduce(unit_type)
	if(!owner || producing)
		return FALSE

	var/cost = GetUnitCost(unit_type)
	if(used_capacity + cost > production_capacity)
		return FALSE

	return TRUE

/obj/structure/clan_factory/proc/GetUnitCost(unit_type)
	// Define costs for different unit types
	switch(unit_type)
		if(/mob/living/simple_animal/hostile/clan/scout)
			return 2
		if(/mob/living/simple_animal/hostile/clan/engineer)
			return 4
		if(/mob/living/simple_animal/hostile/clan/assassin)
			return 6
		if(/mob/living/simple_animal/hostile/clan/demolisher)
			return 7
		if(/mob/living/simple_animal/hostile/clan/defender)
			return 5
		if(/mob/living/simple_animal/hostile/clan/drone)
			return 3
		else
			return 5

/obj/structure/clan_factory/proc/ProduceUnit(unit_type)
	if(!CanProduce(unit_type))
		return

	producing = TRUE
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	visible_message(span_notice("[src] begins production..."))
	
	// Add visual effect during production
	add_overlay(mutable_appearance('icons/effects/effects.dmi', "shield-old", layer + 0.1))
	color = "#00FF00"
	animate(src, color = "#FFFFFF", time = production_time, loop = 1)

	addtimer(CALLBACK(src, PROC_REF(FinishProduction), unit_type), production_time)

/obj/structure/clan_factory/proc/FinishProduction(unit_type)
	producing = FALSE
	
	// Remove visual effects
	cut_overlays()
	color = initial(color)

	var/turf/T = get_step(src, pick(NORTH, SOUTH, EAST, WEST))
	if(!T || T.density)
		T = get_turf(src)

	var/mob/living/simple_animal/hostile/clan/unit = new unit_type(T)
	unit.faction = owner.faction
	unit.factory = src
	unit.commander = owner
	produced_units += unit
	used_capacity += GetUnitCost(unit_type)

	if(owner)
		owner.controlled_units += unit

	playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	visible_message(span_notice("[src] completes production of [unit]!"))

//////////////
// FACTORY BLUEPRINT
//////////////
// Holographic blueprint that engineers can build into real factory
/obj/structure/clan_factory/blueprint
	name = "factory blueprint"
	desc = "A holographic blueprint for a factory. Engineers can construct the actual factory here."
	icon_state = "green_dusk_1"
	color = "#0066ff"
	alpha = 150
	density = FALSE
	anchored = TRUE
	max_integrity = 1
	var/build_time = 5 SECONDS

/obj/structure/clan_factory/blueprint/Initialize()
	. = ..()
	// Stop processing since blueprints don't process
	STOP_PROCESSING(SSobj, src)
	// Flicker effect
	animate(src, alpha = 100, time = 10, loop = -1)
	animate(alpha = 200, time = 10)

/obj/structure/clan_factory/blueprint/attack_hand(mob/user)
	return

/obj/structure/clan_factory/blueprint/attackby(obj/item/I, mob/user, params)
	return

/obj/structure/clan_factory/blueprint/examine(mob/user)
	. = ..()
	. += span_notice("An engineer can build this into a real factory.")

//////////////
// COMMANDER SYSTEM EXTENSIONS
//////////////
// Extensions to base clan mobs for commander control
/mob/living/simple_animal/hostile/clan
	var/mob/living/simple_animal/hostile/clan/tinkerer/commander
	var/obj/structure/clan_factory/factory
	var/order_target = null
	var/rush_movement = FALSE
	var/overclocked = FALSE
	var/obj/effect/overlay/selected_visual
	var/hard_lock = FALSE
	var/atom/hard_lock_target = null
	var/atom/faction_attack_target = null // Specific same-faction target we're allowed to attack
	var/door_bump_cooldown = 0

/mob/living/simple_animal/hostile/clan/proc/AddSelectedVisual()
	if(selected_visual)
		return
	selected_visual = new /obj/effect/overlay/selected_indicator(loc)
	vis_contents += selected_visual

/mob/living/simple_animal/hostile/clan/proc/RemoveSelectedVisual()
	if(selected_visual)
		vis_contents -= selected_visual
		QDEL_NULL(selected_visual)

/mob/living/simple_animal/hostile/clan/proc/ReceiveMovementOrder(turf/destination, rush_mode = FALSE)
	order_target = destination
	rush_movement = rush_mode
	// Clear attack settings when given movement order
	faction_attack_target = null
	attack_same = initial(attack_same)
	LoseTarget()
	// Use Goto instead of walk_to to handle doors properly
	Goto(destination, move_to_delay, 0)

/mob/living/simple_animal/hostile/clan/proc/ReceiveAttackOrder(atom/target, is_hard_lock = FALSE)
	order_target = target
	
	// Handle hard lock
	if(is_hard_lock)
		hard_lock = TRUE
		hard_lock_target = target
		if(!isobj(target)) // Only disable object searching if we're not targeting an object
			search_objects = 0 // Don't search for other targets
		stat_attack = DEAD // Attack even dead targets if ordered
	else
		hard_lock = FALSE
		hard_lock_target = null
	
	// Handle same-faction targets
	if(isliving(target))
		var/mob/living/L = target
		if(faction_check_mob(L))
			faction_attack_target = L
			attack_same = TRUE
		else
			faction_attack_target = null
	
	// If targeting an object, enable object searching and add to wanted_objects
	if(isobj(target))
		search_objects = 3 // Enable object searching
		if(!wanted_objects)
			wanted_objects = list()
		wanted_objects += target.type
		addtimer(CALLBACK(src, PROC_REF(RemoveWantedObject), target.type), 30 SECONDS)
	
	GiveTarget(target)

/mob/living/simple_animal/hostile/clan/proc/ReceiveOverclockOrder()
	if(overclocked)
		return

	overclocked = TRUE
	charge = max_charge * 2
	health = min(health + 200, maxHealth)
	color = "#FF4444"
	add_movespeed_modifier(/datum/movespeed_modifier/overclock)

	addtimer(CALLBACK(src, PROC_REF(OverclockDeath)), 10 SECONDS)

/mob/living/simple_animal/hostile/clan/proc/OverclockDeath()
	visible_message(span_userdanger("[src] overheats and explodes!"))
	playsound(src, 'sound/effects/explosion1.ogg', 50, TRUE)
	new /obj/effect/temp_visual/explosion(get_turf(src))
	death()

/mob/living/simple_animal/hostile/clan/proc/factory_destroyed()
	visible_message(span_warning("[src] shuts down as its factory is destroyed!"))
	death()

/mob/living/simple_animal/hostile/clan/proc/commander_died()
	commander = null
	RemoveSelectedVisual()

/mob/living/simple_animal/hostile/clan/death(gibbed)
	RemoveSelectedVisual()
	if(commander)
		commander.controlled_units -= src
		commander.selected_units -= src
	return ..()

/mob/living/simple_animal/hostile/clan/Destroy()
	RemoveSelectedVisual()
	if(commander)
		commander.controlled_units -= src
		commander.selected_units -= src
	return ..()

/mob/living/simple_animal/hostile/clan/proc/RestoreFaction(list/old_faction)
	faction = old_faction

/mob/living/simple_animal/hostile/clan/proc/RemoveWantedObject(obj_type)
	if(wanted_objects)
		wanted_objects -= obj_type
		if(!length(wanted_objects))
			wanted_objects = null

/mob/living/simple_animal/hostile/clan/proc/ReleaseHardLock()
	hard_lock = FALSE
	hard_lock_target = null
	faction_attack_target = null
	attack_same = initial(attack_same)
	search_objects = initial(search_objects)
	stat_attack = initial(stat_attack)
	LoseTarget()

// Door handling for ordered units
/mob/living/simple_animal/hostile/clan/Bump(atom/A)
	// Handle doors if we have an order
	if(order_target && door_bump_cooldown < world.time)
		if(istype(A, /obj/machinery/door))
			var/obj/machinery/door/D = A
			if(!D.density) // Door is already open
				return ..()
			door_bump_cooldown = world.time + 10 // 1 second cooldown
			if(D.open())
				return
			// If we can't open it normally, try to attack it
			if(environment_smash >= ENVIRONMENT_SMASH_STRUCTURES)
				A.attack_animal(src)
				return
	return ..()

// Movement order pathfinding
/mob/living/simple_animal/hostile/clan/Move(atom/newloc, dir, step_x, step_y)
	. = ..()
	// If we have a movement order and we're stuck, try a different path
	if(order_target && !. && door_bump_cooldown < world.time)
		var/turf/T = get_turf(order_target)
		if(T && get_dist(src, T) > 1)
			// Try to find an alternate path
			var/list/possible_dirs = list()
			for(var/direction in GLOB.cardinals)
				var/turf/step_turf = get_step(src, direction)
				if(step_turf && !step_turf.density)
					var/blocked = FALSE
					for(var/obj/O in step_turf)
						if(O.density && !istype(O, /obj/machinery/door))
							blocked = TRUE
							break
					if(!blocked)
						possible_dirs += direction
			
			if(possible_dirs.len)
				var/new_dir = pick(possible_dirs)
				return Move(get_step(src, new_dir), new_dir)

// Hard lock targeting override
/mob/living/simple_animal/hostile/clan/ListTargets()
	if(hard_lock && hard_lock_target && !QDELETED(hard_lock_target))
		return list(hard_lock_target)
	return ..()

// Target persistence for hard lock
/mob/living/simple_animal/hostile/clan/PickTarget(list/Targets)
	if(hard_lock && hard_lock_target && (hard_lock_target in Targets))
		return hard_lock_target
	return ..()

// Faction attack target filtering
/mob/living/simple_animal/hostile/clan/CanAttack(atom/the_target)
	// If we have a faction attack target, only allow attacking that specific target
	if(faction_attack_target && isliving(the_target))
		var/mob/living/L = the_target
		if(faction_check_mob(L) && L != faction_attack_target)
			return FALSE
	return ..()

//////////////
// VISUAL EFFECTS
//////////////
/obj/effect/overlay/selected_indicator
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	color = "#00FF00"
	alpha = 100

//////////////
// SPEED MODIFIERS
//////////////
/datum/movespeed_modifier/tinkerer_viewing
	multiplicative_slowdown = 0.3

/datum/movespeed_modifier/overclock
	multiplicative_slowdown = -0.5

//////////////
// TINKERER ABILITIES
//////////////
// All ability procs for the tinkerer commander unit
/obj/effect/proc_holder/ability/tinkerer
	name = "Tinkerer Ability"
	desc = "You shouldn't see this"
	action_icon = 'ModularTegustation/Teguicons/resurgence_actions.dmi'
	action_icon_state = "summoner2"
	cooldown_time = 2 SECONDS
	var/mob/living/simple_animal/hostile/clan/tinkerer/linked_tinkerer

/obj/effect/proc_holder/ability/tinkerer/Initialize(mapload, mob/living/simple_animal/hostile/clan/tinkerer/T)
	. = ..()
	if(T)
		linked_tinkerer = T

// Remove the aimed parent - we'll just use the base ability type instead

/obj/effect/proc_holder/ability/tinkerer/produce_scout
	name = "Produce Scout"
	desc = "Order a factory to produce a scout unit. Costs 2 capacity."
	action_icon_state = "produce_scout"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_scout/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		to_chat(user, span_warning("No linked tinkerer! User: [user]"))
		return
	to_chat(user, span_notice("Producing scout via [linked_tinkerer]..."))
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/scout)

/obj/effect/proc_holder/ability/tinkerer/produce_assassin
	name = "Produce Assassin"
	desc = "Order a factory to produce an assassin unit. Costs 6 capacity."
	action_icon_state = "produce_assassin"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_assassin/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/assassin)

/obj/effect/proc_holder/ability/tinkerer/produce_demolisher
	name = "Produce Demolisher"
	desc = "Order a factory to produce a demolisher unit. Costs 7 capacity."
	action_icon_state = "produce_demolisher"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_demolisher/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/demolisher)

/obj/effect/proc_holder/ability/tinkerer/produce_defender
	name = "Produce Defender"
	desc = "Order a factory to produce a defender unit. Costs 5 capacity."
	action_icon_state = "produce_defender"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_defender/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/defender)

/obj/effect/proc_holder/ability/tinkerer/produce_drone
	name = "Produce Drone"
	desc = "Order a factory to produce a drone unit. Costs 3 capacity."
	action_icon_state = "produce_drone"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_drone/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/drone)

/obj/effect/proc_holder/ability/tinkerer/produce_engineer
	name = "Produce Engineer"
	desc = "Order a factory to produce an engineer unit. Costs 4 capacity."
	action_icon_state = "produce_engineer"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_engineer/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/engineer)

/obj/effect/proc_holder/spell/aimed/tinkerer_select_unit
	name = "Select/Deselect Unit"
	desc = "Click a unit to select/deselect it, or click two points to box select units."
	action_icon = 'ModularTegustation/Teguicons/resurgence_actions.dmi'
	action_icon_state = "select_units"
	base_icon_state = "select_units"
	active_icon_state = "select_units_on"
	base_action = /datum/action/spell_action/spell
	deactive_msg = "You stop selecting units."
	active_msg = "Click units to select them!"
	charge_max = 0.5 SECONDS
	projectile_amount = 9999 // Don't run out
	var/mob/living/simple_animal/hostile/clan/tinkerer/linked_tinkerer

/obj/effect/proc_holder/spell/aimed/tinkerer_select_unit/Initialize(mapload, mob/living/simple_animal/hostile/clan/tinkerer/T)
	. = ..()
	if(T)
		linked_tinkerer = T

/obj/effect/proc_holder/spell/aimed/tinkerer_select_unit/can_cast(mob/user = usr)
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_select_unit/update_icon()
	if(!action)
		return
	action.button_icon_state = active ? "select_units_on" : "select_units"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/aimed/tinkerer_select_unit/cast(list/targets, mob/living/user)
	// Override cast to prevent projectile firing
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_select_unit/InterceptClickOn(mob/living/caller, params, atom/target)
	..()  // Call parent but don't check return value
	if(!linked_tinkerer)
		return TRUE
	
	var/turf/T = get_turf(target)
	if(!T)
		return TRUE
	
	// Check if clicking on a unit directly
	if(isliving(target))
		var/mob/living/simple_animal/hostile/clan/unit = target
		if(istype(unit))
			linked_tinkerer.SelectUnit(unit)
			// Keep ability active
			return FALSE
	
	// Box selection logic
	if(!linked_tinkerer.selection_start_point)
		// First click - set start point
		linked_tinkerer.selection_start_point = T
		to_chat(linked_tinkerer, span_notice("Selection start point set. Click another location to box select units."))
		new /obj/effect/temp_visual/cult/sparks(T)
		// Keep ability active
		return FALSE
	else
		// Second click - box select
		linked_tinkerer.BoxSelectUnits(linked_tinkerer.selection_start_point, T)
		linked_tinkerer.selection_start_point = null
		// Keep ability active
		return FALSE

/obj/effect/proc_holder/spell/aimed/tinkerer_move_order
	name = "Movement Order"
	desc = "Order selected units to move to a location. Costs 2 charge."
	action_icon = 'ModularTegustation/Teguicons/resurgence_actions.dmi'
	action_icon_state = "move_order"
	base_icon_state = "move_order"
	active_icon_state = "move_order_on"
	base_action = /datum/action/spell_action/spell
	deactive_msg = "You cancel the movement order."
	active_msg = "Click where you want your units to move!"
	charge_max = 1 SECONDS
	projectile_amount = 9999
	var/mob/living/simple_animal/hostile/clan/tinkerer/linked_tinkerer

/obj/effect/proc_holder/spell/aimed/tinkerer_move_order/Initialize(mapload, mob/living/simple_animal/hostile/clan/tinkerer/T)
	. = ..()
	if(T)
		linked_tinkerer = T

/obj/effect/proc_holder/spell/aimed/tinkerer_move_order/can_cast(mob/user = usr)
	if(!linked_tinkerer)
		return FALSE
	if(linked_tinkerer.viewing_mode)
		return FALSE
	if(!length(linked_tinkerer.selected_units))
		return FALSE
	if(linked_tinkerer.charge < linked_tinkerer.order_move_cost)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_move_order/update_icon()
	if(!action)
		return
	action.button_icon_state = active ? "move_order_on" : "move_order"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/aimed/tinkerer_move_order/cast(list/targets, mob/living/user)
	// Override cast to prevent projectile firing
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_move_order/InterceptClickOn(mob/living/caller, params, atom/target)
	..()  // Call parent but don't check return value
	if(!linked_tinkerer || !isturf(target))
		return TRUE
	linked_tinkerer.IssueMovementOrder(target)
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_attack_order
	name = "Attack Order"
	desc = "Order selected units to attack a target. Costs 3 charge."
	action_icon = 'ModularTegustation/Teguicons/resurgence_actions.dmi'
	action_icon_state = "attack_order"
	base_icon_state = "attack_order"
	active_icon_state = "attack_order_on"
	base_action = /datum/action/spell_action/spell
	deactive_msg = "You cancel the attack order."
	active_msg = "Click what you want your units to attack!"
	charge_max = 2 SECONDS
	projectile_amount = 9999
	var/mob/living/simple_animal/hostile/clan/tinkerer/linked_tinkerer

/obj/effect/proc_holder/spell/aimed/tinkerer_attack_order/Initialize(mapload, mob/living/simple_animal/hostile/clan/tinkerer/T)
	. = ..()
	if(T)
		linked_tinkerer = T

/obj/effect/proc_holder/spell/aimed/tinkerer_attack_order/can_cast(mob/user = usr)
	if(!linked_tinkerer)
		return FALSE
	if(linked_tinkerer.viewing_mode)
		return FALSE
	if(!length(linked_tinkerer.selected_units))
		return FALSE
	var/cost = linked_tinkerer.hard_lock_mode ? linked_tinkerer.order_attack_cost * 2 : linked_tinkerer.order_attack_cost
	if(linked_tinkerer.charge < cost)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_attack_order/update_icon()
	if(!action)
		return
	action.button_icon_state = active ? "attack_order_on" : "attack_order"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/aimed/tinkerer_attack_order/cast(list/targets, mob/living/user)
	// Override cast to prevent projectile firing
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_attack_order/InterceptClickOn(mob/living/caller, params, atom/target)
	..()  // Call parent but don't check return value
	if(!linked_tinkerer || !target)
		return TRUE
	linked_tinkerer.IssueAttackOrder(target)
	return TRUE

/obj/effect/proc_holder/ability/tinkerer/overclock_order
	name = "Overclock Order"
	desc = "Overclock selected units, boosting them before destruction. Costs 5 charge."
	action_icon_state = "overclock_order"
	cooldown_time = 5 SECONDS

/obj/effect/proc_holder/ability/tinkerer/overclock_order/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.IssueOverclockOrder()

/obj/effect/proc_holder/ability/tinkerer/toggle_lock_mode
	name = "Toggle Lock Mode"
	desc = "Toggle between passive and hard lock modes for attack orders."
	action_icon_state = "toggle_attack"
	cooldown_time = 0.5 SECONDS

/obj/effect/proc_holder/ability/tinkerer/toggle_lock_mode/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.hard_lock_mode = !linked_tinkerer.hard_lock_mode
	to_chat(linked_tinkerer, span_notice("Attack mode set to: [linked_tinkerer.hard_lock_mode ? "Hard Lock" : "Passive"]"))
	playsound(linked_tinkerer, 'sound/machines/click.ogg', 50, TRUE)

/obj/effect/proc_holder/ability/tinkerer/release_locks
	name = "Release All Locks"
	desc = "Release all hard locks on controlled units."
	action_icon_state = "release_locks"
	cooldown_time = 1 SECONDS

/obj/effect/proc_holder/ability/tinkerer/release_locks/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.ReleaseAllLocks()

/obj/effect/proc_holder/spell/aimed/tinkerer_build_barricade
	name = "Build Barricade Line"
	desc = "Click two points to build a barricade line. Costs 3 charge per barricade."
	action_icon = 'ModularTegustation/Teguicons/resurgence_actions.dmi'
	action_icon_state = "build_barricade"
	base_icon_state = "build_barricade"
	active_icon_state = "build_barricade"
	base_action = /datum/action/spell_action/spell
	deactive_msg = "You cancel barricade construction."
	active_msg = "Click two points to build a barricade line!"
	charge_max = 1 SECONDS
	projectile_amount = 9999
	var/mob/living/simple_animal/hostile/clan/tinkerer/linked_tinkerer

/obj/effect/proc_holder/spell/aimed/tinkerer_build_barricade/Initialize(mapload, mob/living/simple_animal/hostile/clan/tinkerer/T)
	. = ..()
	if(T)
		linked_tinkerer = T

/obj/effect/proc_holder/spell/aimed/tinkerer_build_barricade/can_cast(mob/user = usr)
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_build_barricade/update_icon()
	if(!action)
		return
	action.button_icon_state = "build_barricade"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/aimed/tinkerer_build_barricade/cast(list/targets, mob/living/user)
	// Override cast to prevent projectile firing
	return TRUE

/obj/effect/proc_holder/spell/aimed/tinkerer_build_barricade/InterceptClickOn(mob/living/caller, params, atom/target)
	..()  // Call parent but don't check return value
	if(!linked_tinkerer)
		return TRUE
	
	var/turf/T = get_turf(target)
	if(!T)
		return TRUE
	
	if(!linked_tinkerer.barricade_start_point)
		// First click - set start point
		linked_tinkerer.barricade_start_point = T
		to_chat(linked_tinkerer, span_notice("Barricade start point set. Click another location to complete the line."))
		new /obj/effect/temp_visual/cult/sparks(T)
		// Don't deactivate the ability
		return FALSE
	else
		// Second click - draw line
		linked_tinkerer.BuildBarricadeLine(linked_tinkerer.barricade_start_point, T)
		linked_tinkerer.barricade_start_point = null
		// Keep ability active for more barricade lines
		return FALSE

/obj/effect/proc_holder/ability/tinkerer/build_order
	name = "Build Order"
	desc = "Deploy a factory blueprint on an adjacent construction point. Costs 10 charge."
	action_icon_state = "build_factory"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/build_order/Perform(target, mob/user)
	..()  // Call parent to handle cooldown
	if(!linked_tinkerer && istype(user, /mob/living/simple_animal/hostile/clan/tinkerer))
		linked_tinkerer = user
	if(!linked_tinkerer)
		return
	linked_tinkerer.BuildFactoryBlueprint()

//////////////
// BARRICADE STRUCTURES
//////////////
// Defensive structures that block enemies but allow clan units through
/obj/structure/barricade/clan
	name = "clan barricade"
	desc = "A sturdy mechanical barricade constructed by the Resurgence Clan."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	density = TRUE
	anchored = TRUE
	max_integrity = 300
	proj_pass_rate = 50
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 25, BIO = 100, RAD = 100, FIRE = 50, ACID = 0)

/obj/structure/barricade/clan/CanAllowThrough(atom/movable/mover, turf/target)
	// Allow clan mobs to pass through
	if(istype(mover, /mob/living/simple_animal/hostile/clan))
		return TRUE
	// Otherwise use parent behavior
	return ..()

/obj/structure/barricade/clan/blueprint
	name = "barricade blueprint"
	desc = "A holographic blueprint for a barricade. Engineers can construct the actual barricade here."
	icon_state = "barricade"
	color = "#0066ff"
	alpha = 150
	density = FALSE
	max_integrity = 1
	var/build_time = 2 SECONDS

/obj/structure/barricade/clan/blueprint/Initialize()
	. = ..()
	// Flicker effect
	animate(src, alpha = 100, time = 10, loop = -1)
	animate(alpha = 200, time = 10)

/obj/structure/barricade/clan/blueprint/attack_hand(mob/user)
	return

/obj/structure/barricade/clan/blueprint/attackby(obj/item/I, mob/user, params)
	return

//////////////
// ENGINEER
//////////////
// Support unit that builds barricades and factories from blueprints
// Repairs damaged structures and has slow but steady combat capability
// Essential for establishing defensive positions
/mob/living/simple_animal/hostile/clan/engineer
	name = "Clan Engineer"
	desc = "A construction-specialized machine with building tools... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_citzen_1"
	icon_living = "clan_citzen_1"
	icon_dead = "clan_citzen_dead"
	health = 400
	maxHealth = 400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	attack_sound = 'sound/items/welder.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	melee_damage_lower = 5
	melee_damage_upper = 10
	robust_searching = TRUE
	stat_attack = CONSCIOUS
	vision_range = 8
	aggro_vision_range = 8
	move_to_delay = 3.5
	charge = 0
	max_charge = 5
	clan_charge_cooldown = 4 SECONDS
	teleport_away = TRUE
	search_objects = 3
	wanted_objects = list(/obj/structure/barricade/clan/blueprint, /obj/structure/clan_factory/blueprint)

	// Building and repair variables
	var/can_build_factory = TRUE
	var/building = FALSE
	var/build_time = 5 SECONDS
	var/barricade_build_time = 2 SECONDS

/mob/living/simple_animal/hostile/clan/engineer/examine(mob/user)
	. = ..()
	if(commander)
		. += span_notice("Controlled by [commander].")
	if(can_build_factory)
		. += span_notice("Ready to construct a factory at a resource point.")

/mob/living/simple_animal/hostile/clan/engineer/AttackingTarget(atom/attacked_target)
	if(!attacked_target)
		attacked_target = target

	// Check if targeting a resource point to build factory
	if(istype(attacked_target, /obj/structure/resource_point) && can_build_factory && commander)
		StartFactoryConstruction(attacked_target)
		return
	
	// Check if targeting a construction point object
	if(can_build_factory && commander && isobj(attacked_target))
		var/obj/O = attacked_target
		// Check if our commander (who must be a tinkerer) recognizes this as a construction point
		if(istype(commander, /mob/living/simple_animal/hostile/clan/tinkerer))
			var/mob/living/simple_animal/hostile/clan/tinkerer/T = commander
			if(T.IsConstructionPoint(O))
				StartFactoryConstructionOnObject(O)
				return
	
	// Check if targeting a barricade blueprint
	if(istype(attacked_target, /obj/structure/barricade/clan/blueprint) && !building)
		BuildBarricade(attacked_target)
		return
	
	// Check if targeting a factory blueprint
	if(istype(attacked_target, /obj/structure/clan_factory/blueprint) && !building && commander)
		BuildFactoryFromBlueprint(attacked_target)
		return

	return ..()

// Resource point factory construction
/mob/living/simple_animal/hostile/clan/engineer/proc/StartFactoryConstruction(obj/structure/resource_point/R)
	if(!R || !can_build_factory || building || !commander)
		return

	// Check if there's already a factory here
	for(var/obj/structure/clan_factory/F in R.loc)
		to_chat(commander, span_warning("There is already a factory at this location!"))
		return

	building = TRUE
	can_build_factory = FALSE
	visible_message(span_notice("[src] begins constructing a factory..."))
	playsound(src, 'sound/items/welder2.ogg', 50, TRUE)

	if(do_after(src, build_time, target = R))
		var/obj/structure/clan_factory/F = new(R.loc)
		F.owner = commander
		commander.owned_factories += F
		visible_message(span_notice("[src] completes the factory construction!"))
		playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	else
		visible_message(span_warning("[src] fails to complete the construction."))
		can_build_factory = TRUE

	building = FALSE

/mob/living/simple_animal/hostile/clan/engineer/proc/StartFactoryConstructionOnObject(obj/O)
	if(!O || !can_build_factory || building || !commander)
		return

	var/turf/T = get_turf(O)
	if(!T)
		return

	// Check if there's already a factory here
	for(var/obj/structure/clan_factory/F in T)
		to_chat(commander, span_warning("There is already a factory at this location!"))
		return

	building = TRUE
	can_build_factory = FALSE
	visible_message(span_notice("[src] begins constructing a factory on [O]..."))
	playsound(src, 'sound/items/welder2.ogg', 50, TRUE)

	if(do_after(src, build_time, target = O))
		var/obj/structure/clan_factory/F = new(T)
		F.owner = commander
		commander.owned_factories += F
		visible_message(span_notice("[src] completes the factory construction on [O]!"))
		playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
		// Delete the construction point object
		qdel(O)
	else
		visible_message(span_warning("[src] fails to complete the construction."))
		can_build_factory = TRUE

	building = FALSE

// Construction system - builds blueprints into structures
/mob/living/simple_animal/hostile/clan/engineer/proc/BuildBarricade(obj/structure/barricade/clan/blueprint/B)
	if(!B || building || B.loc == null)
		return
	
	building = TRUE
	visible_message(span_notice("[src] begins constructing a barricade..."))
	playsound(src, 'sound/items/welder.ogg', 50, TRUE)
	
	if(do_after(src, barricade_build_time, target = B))
		if(!QDELETED(B) && B.loc)
			new /obj/structure/barricade/clan(B.loc)
			qdel(B)
			visible_message(span_notice("[src] completes the barricade construction!"))
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	else
		visible_message(span_warning("[src] fails to complete the barricade construction."))
	
	building = FALSE

// Factory construction from blueprint
/mob/living/simple_animal/hostile/clan/engineer/proc/BuildFactoryFromBlueprint(obj/structure/clan_factory/blueprint/B)
	if(!B || building || B.loc == null || !commander)
		return
	
	// Check if this engineer can build factories
	if(!can_build_factory)
		visible_message(span_warning("[src] has already built a factory and cannot build another!"))
		return
	
	building = TRUE
	can_build_factory = FALSE
	visible_message(span_notice("[src] begins constructing a factory from the blueprint..."))
	playsound(src, 'sound/items/welder2.ogg', 50, TRUE)
	
	if(do_after(src, B.build_time, target = B))
		if(!QDELETED(B) && B.loc)
			var/obj/structure/clan_factory/F = new(B.loc)
			F.owner = commander
			if(istype(commander, /mob/living/simple_animal/hostile/clan/tinkerer))
				var/mob/living/simple_animal/hostile/clan/tinkerer/T = commander
				T.owned_factories += F
			qdel(B)
			visible_message(span_notice("[src] completes the factory construction!"))
			playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	else
		visible_message(span_warning("[src] fails to complete the factory construction."))
		can_build_factory = TRUE
	
	building = FALSE

// Override to handle attack orders on construction points
/mob/living/simple_animal/hostile/clan/engineer/ReceiveAttackOrder(atom/target, is_hard_lock = FALSE)
	// Check if we're ordered to attack a construction point
	if(can_build_factory && commander && isobj(target))
		var/obj/O = target
		// Check if our commander recognizes this as a construction point
		if(istype(commander, /mob/living/simple_animal/hostile/clan/tinkerer))
			var/mob/living/simple_animal/hostile/clan/tinkerer/T = commander
			if(T.IsConstructionPoint(O))
				// Add it to our wanted objects temporarily
				if(!wanted_objects)
					wanted_objects = list()
				wanted_objects += O.type
				addtimer(CALLBACK(src, PROC_REF(RemoveWantedObject), O.type), 30 SECONDS)
				// Enable object searching
				search_objects = 3
	
	// Call parent to handle the rest
	return ..()

// Resource point structure
/obj/structure/resource_point
	name = "Resource Point"
	desc = "A strategic location suitable for construction."
	icon = 'icons/obj/structures.dmi'
	icon_state = "x4"
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	alpha = 128
