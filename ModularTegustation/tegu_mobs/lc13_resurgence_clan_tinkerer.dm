/mob/living/simple_animal/hostile/clan/tinkerer
	name = "Tinkerer"
	desc = "A mechanical engineer with multiple manipulator arms... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_64x96.dmi'
	icon_state = "tinker"
	icon_living = "tinker"
	icon_dead = "tinker_d"
	pixel_x = -16
	base_pixel_x = -16
	health = 600
	maxHealth = 600
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
	clan_charge_cooldown = 2 SECONDS
	teleport_away = TRUE
	retreat_distance = 8
	minimum_distance = 6
	melee_damage_lower = 0
	melee_damage_upper = 0

	// Tinkerer specific vars
	var/viewing_mode = FALSE
	var/list/selected_units = list()
	var/max_selected_units = 5
	var/list/owned_factories = list()
	var/list/controlled_units = list()
	var/order_move_cost = 2
	var/order_attack_cost = 3
	var/order_overclock_cost = 5
	var/viewing_alpha = 30
	var/viewing_speed_modifier = 0.3

/mob/living/simple_animal/hostile/clan/tinkerer/Initialize()
	. = ..()
	// Create initial factory
	addtimer(CALLBACK(src, PROC_REF(CreateInitialFactory)), 2 SECONDS)
	// Add abilities
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/toggle_view(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_scout(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_engineer(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_assassin(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_demolisher(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_defender(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/produce_drone(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/select_unit(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/move_order(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/attack_order(src))
	AddAbility(new /obj/effect/proc_holder/ability/tinkerer/overclock_order(src))

/mob/living/simple_animal/hostile/clan/tinkerer/examine(mob/user)
	. = ..()
	. += span_notice("Charge: [charge]/[max_charge]")
	. += span_notice("Selected units: [length(selected_units)]/[max_selected_units]")
	. += span_notice("Controlled units: [length(controlled_units)]")
	. += span_notice("Factories owned: [length(owned_factories)]")
	if(viewing_mode)
		. += span_boldnotice("Currently in viewing mode (invulnerable).")

/mob/living/simple_animal/hostile/clan/tinkerer/Life()
	. = ..()
	if(!.)
		return

	// Update charge
	ChargeGain()

	// Clean up dead units
	CleanupDeadUnits()

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ChargeGain()
	if(last_charge_update < world.time - clan_charge_cooldown)
		charge = min(charge + 1, max_charge)
		last_charge_update = world.time

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
	add_movespeed_modifier(/datum/movespeed_modifier/tinkerer_viewing)
	density = FALSE
	status_flags |= GODMODE // Invulnerable in viewing mode
	visible_message(span_notice("[src] activates surveillance mode!"))
	playsound(src, 'sound/mecha/mechmove01.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ExitViewingMode()
	if(!viewing_mode)
		return

	viewing_mode = FALSE
	alpha = 255
	remove_movespeed_modifier(/datum/movespeed_modifier/tinkerer_viewing)
	density = initial(density)
	status_flags &= ~GODMODE // Remove invulnerability
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
	if(viewing_mode || !length(selected_units) || charge < order_attack_cost || !target)
		return

	charge -= order_attack_cost
	for(var/mob/living/simple_animal/hostile/clan/unit in selected_units)
		if(unit.stat == DEAD)
			continue
		unit.ReceiveAttackOrder(target)

	visible_message(span_danger("[src] issues attack orders!"))
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

/mob/living/simple_animal/hostile/clan/tinkerer/proc/ProduceUnitAtFactory(unit_type)
	// Find nearest factory with capacity
	var/obj/structure/clan_factory/best_factory = null
	var/min_distance = INFINITY
	
	for(var/obj/structure/clan_factory/F in owned_factories)
		if(F.CanProduce(unit_type))
			var/dist = get_dist(src, F)
			if(dist < min_distance)
				min_distance = dist
				best_factory = F
	
	if(!best_factory)
		to_chat(src, span_warning("No available factory with sufficient capacity!"))
		return FALSE
	
	best_factory.ProduceUnit(unit_type)
	return TRUE

// Override to prevent attacking
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

// Factory structure
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
	. = ..()

/obj/structure/clan_factory/process()
	if(!owner || owner.stat == DEAD)
		Destroy()
		return

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

	addtimer(CALLBACK(src, PROC_REF(FinishProduction), unit_type), production_time)

/obj/structure/clan_factory/proc/FinishProduction(unit_type)
	producing = FALSE

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

// Extensions for clan mobs to support commander orders
/mob/living/simple_animal/hostile/clan
	var/mob/living/simple_animal/hostile/clan/tinkerer/commander
	var/obj/structure/clan_factory/factory
	var/order_target = null
	var/rush_movement = FALSE
	var/overclocked = FALSE
	var/obj/effect/overlay/selected_visual

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
	LoseTarget()
	walk_to(src, destination, 0, move_to_delay)

/mob/living/simple_animal/hostile/clan/proc/ReceiveAttackOrder(atom/target)
	order_target = target
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

// Visual indicator for selected units
/obj/effect/overlay/selected_indicator
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	color = "#00FF00"
	alpha = 100

// Movement speed modifiers
/datum/movespeed_modifier/tinkerer_viewing
	multiplicative_slowdown = 0.3

/datum/movespeed_modifier/overclock
	multiplicative_slowdown = -0.5

// Tinkerer abilities
/obj/effect/proc_holder/ability/tinkerer
	name = "Tinkerer Ability"
	desc = "You shouldn't see this"
	action_icon = 'icons/mob/actions/actions_abnormality.dmi'
	action_icon_state = "summoner2"
	cooldown_time = 2 SECONDS
	var/mob/living/simple_animal/hostile/clan/tinkerer/linked_tinkerer

/obj/effect/proc_holder/ability/tinkerer/Initialize(mapload, mob/living/simple_animal/hostile/clan/tinkerer/T)
	. = ..()
	if(T)
		linked_tinkerer = T

/obj/effect/proc_holder/ability/tinkerer/toggle_view
	name = "Toggle View Mode"
	desc = "Switch between viewing and command modes."
	action_icon_state = "qoh_white"
	cooldown_time = 1 SECONDS

/obj/effect/proc_holder/ability/tinkerer/toggle_view/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.ToggleViewingMode()

/obj/effect/proc_holder/ability/tinkerer/produce_scout
	name = "Produce Scout"
	desc = "Order a factory to produce a scout unit. Costs 2 capacity."
	action_icon_state = "cultist"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_scout/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/scout)

/obj/effect/proc_holder/ability/tinkerer/produce_assassin
	name = "Produce Assassin"
	desc = "Order a factory to produce an assassin unit. Costs 6 capacity."
	action_icon_state = "cultist2"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_assassin/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/assassin)

/obj/effect/proc_holder/ability/tinkerer/produce_demolisher
	name = "Produce Demolisher"
	desc = "Order a factory to produce a demolisher unit. Costs 7 capacity."
	action_icon_state = "cultist2"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_demolisher/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/demolisher)

/obj/effect/proc_holder/ability/tinkerer/produce_defender
	name = "Produce Defender"
	desc = "Order a factory to produce a defender unit. Costs 5 capacity."
	action_icon_state = "cultist"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_defender/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/defender)

/obj/effect/proc_holder/ability/tinkerer/produce_drone
	name = "Produce Drone"
	desc = "Order a factory to produce a drone unit. Costs 3 capacity."
	action_icon_state = "cultist"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_drone/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/drone)

/obj/effect/proc_holder/ability/tinkerer/produce_engineer
	name = "Produce Engineer"
	desc = "Order a factory to produce an engineer unit. Costs 4 capacity."
	action_icon_state = "summoner1"
	cooldown_time = 3 SECONDS

/obj/effect/proc_holder/ability/tinkerer/produce_engineer/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.ProduceUnitAtFactory(/mob/living/simple_animal/hostile/clan/engineer)

/obj/effect/proc_holder/ability/tinkerer/select_unit
	name = "Select/Deselect Unit"
	desc = "Select or deselect a clan unit for orders."
	action_icon_state = "qoh_white"
	cooldown_time = 0.5 SECONDS

/obj/effect/proc_holder/ability/tinkerer/select_unit/Perform(target, mob/user)
	if(!linked_tinkerer || !isliving(target))
		return
	var/mob/living/simple_animal/hostile/clan/unit = target
	if(istype(unit))
		linked_tinkerer.SelectUnit(unit)

/obj/effect/proc_holder/ability/tinkerer/move_order
	name = "Movement Order"
	desc = "Order selected units to move to a location. Costs 2 charge."
	action_icon_state = "qoh_black"
	cooldown_time = 1 SECONDS

/obj/effect/proc_holder/ability/tinkerer/move_order/Perform(target, mob/user)
	if(!linked_tinkerer || !isturf(target))
		return
	linked_tinkerer.IssueMovementOrder(target)

/obj/effect/proc_holder/ability/tinkerer/attack_order
	name = "Attack Order"
	desc = "Order selected units to attack a target. Costs 3 charge."
	action_icon_state = "qoh_pale"
	cooldown_time = 2 SECONDS

/obj/effect/proc_holder/ability/tinkerer/attack_order/Perform(target, mob/user)
	if(!linked_tinkerer || !target)
		return
	linked_tinkerer.IssueAttackOrder(target)

/obj/effect/proc_holder/ability/tinkerer/overclock_order
	name = "Overclock Order"
	desc = "Overclock selected units, boosting them before destruction. Costs 5 charge."
	action_icon_state = "qoh_red"
	cooldown_time = 5 SECONDS

/obj/effect/proc_holder/ability/tinkerer/overclock_order/Perform(target, mob/user)
	if(!linked_tinkerer)
		return
	linked_tinkerer.IssueOverclockOrder()
