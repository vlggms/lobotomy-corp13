/datum/ai_controller/insane
	continue_processing_when_client = TRUE
	blackboard = list(BB_INSANE_BEST_FORCE_FOUND = 10,\
	BB_INSANE_BLACKLISTITEMS = list(),\
	BB_INSANE_TEMPORARY_BLACKLISTITEMS = list(),\
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

	var/timerid = null
	var/timerid_wander = null

/datum/ai_controller/insane/Destroy(force, ...)
	if(timerid)
		deltimer(timerid)
		timerid = null
	if(timerid_wander)
		deltimer(timerid_wander)
		timerid_wander = null
	return ..()

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
	var/interest = 3
	var/is_mech_attack_on_cooldown = FALSE
	var/mech_attack_timer_id = null

/datum/ai_controller/insane/murder/Destroy()
	if(mech_attack_timer_id)
		deltimer(mech_attack_timer_id)
		mech_attack_timer_id = null
	return ..()

/datum/ai_controller/insane/murder/PossessPawn(atom/new_pawn)
	. = ..()
	if(SSmaptype.maptype == "city")
		total_locations |= SScityevents.spawners
		return
	total_locations |= GLOB.xeno_spawn // Avoids Department centers, unlike Wander Panic
	var/mob/living/L = pawn
	L.a_intent = INTENT_HARM
	L.active_hand_index = 1

/datum/ai_controller/insane/murder/PerformMovement(delta_time)
	if(!isnull(timerid))
		return FALSE
	return ..()

/datum/ai_controller/insane/murder/MoveTo(delta_time)
	var/mob/living/living_pawn = pawn
	if(IS_DEAD_OR_INCAP(living_pawn))
		if(timerid)
			deltimer(timerid)
			timerid = null
		return
	var/atom/selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!current_movement_target || QDELETED(current_movement_target) || current_movement_target.z == living_pawn.z && get_dist(living_pawn, current_movement_target) > max_target_distance)
		if(selected_enemy && !QDELETED(selected_enemy) && (selected_enemy.z == living_pawn.z && get_dist(living_pawn, selected_enemy) <= max_target_distance || living_pawn.z == 0))
			current_movement_target = selected_enemy
		else
			if(timerid)
				deltimer(timerid)
				timerid = null
			return FALSE

	var/obj/vehicle/sealed/mecha/the_mecha = null
	if(ismecha(living_pawn.loc))
		the_mecha = living_pawn.loc

	var/move_mod = living_pawn.cached_multiplicative_slowdown
	var/isGunHealingTargetSanity = FALSE
	var/obj/item/gun/ego_gun/banger
	if(the_mecha)
		move_mod = the_mecha.movedelay + 0.1
	else if(living_pawn.held_items && living_pawn.held_items.len == 2 && istype(living_pawn.held_items[1], /obj/item/gun/ego_gun))
		banger = living_pawn.held_items[1]
		var/obj/item/ammo_casing/casing = initial(banger.ammo_type)
		var/obj/projectile/boolet = initial(casing.projectile_type)
		if(initial(boolet.damage_type) == WHITE_DAMAGE && ishuman(selected_enemy))
			var/mob/living/carbon/human/H = selected_enemy
			if(H.sanity_lost)
				isGunHealingTargetSanity = TRUE
		move_mod *= 1.2
	var/is_mech_ranged = FALSE
	if(the_mecha)
		for(var/equip in the_mecha.equipment)
			var/obj/item/mecha_parts/mecha_equipment/ME = equip
			if(ME.range & MECHA_RANGED)
				is_mech_ranged = TRUE
				break

	timerid = addtimer(CALLBACK(src, PROC_REF(MoveTo), delta_time), move_mod, TIMER_STOPPABLE)

	var/atom/movable/thing_to_move = the_mecha ? the_mecha : living_pawn
	var/turf/our_turf = get_turf(thing_to_move)
	var/turf/target_turf
	var/current_dist = get_dist(thing_to_move, current_movement_target)
	if((current_dist < 2) && banger && !isGunHealingTargetSanity || is_mech_ranged && (current_dist < 4))
		if(the_mecha)
			the_mecha.strafe = TRUE
		target_turf = get_step_away(thing_to_move, current_movement_target)
	else if ((!banger || isGunHealingTargetSanity) && current_dist >= 2 && !is_mech_ranged || current_dist >= 5)
		var/list/path = get_path_to(thing_to_move, current_movement_target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))
		if(path.len > 1)
			target_turf = path[2]
		else
			target_turf = get_step_towards(thing_to_move, current_movement_target)
	if(target_turf)
		if(the_mecha)
			the_mecha.relaymove(living_pawn, get_dir(our_turf, target_turf))
		else
			thing_to_move.Move(target_turf, get_dir(our_turf, target_turf))
	else if(the_mecha)
		var/direction = get_cardinal_dir(the_mecha, current_movement_target)
		if(the_mecha.dir != direction)
			if(!(the_mecha.mecha_flags & QUIET_TURNS) && !the_mecha.step_silent)
				playsound(the_mecha, the_mecha.turnsound, 40, TRUE)
			the_mecha.setDir(direction)
	if(the_mecha)
		the_mecha.strafe = FALSE
	if(!(current_movement_target in oview(7, thing_to_move))) // If you can't see the target enough
		interest--
		if(interest <= 0) // Give up
			interest = 3
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			CancelActions()
			return
	else
		interest = 3
	if(get_dist(thing_to_move, current_movement_target) > max_target_distance)
		CancelActions()
		pathing_attempts = 0
		return
	if(our_turf == get_turf(thing_to_move) && !isliving(current_movement_target) && !ismecha(current_movement_target))
		if(++pathing_attempts >= MAX_PATHING_ATTEMPTS)
			CancelActions()
			pathing_attempts = 0
			return
	return TRUE

/turf/proc/reachableTurftestWithMobs(caller, turf/T, ID, simulated_only)
	if(T && !T.density && !(simulated_only && SSpathfinder.space_type_cache[T.type]) && !LinkBlockedWithAccess(T,caller, ID))
		if(is_type_in_typecache(T, GLOB.dangerous_turfs) && !(locate(/obj/structure/lattice) in T))
			return FALSE
		for(var/mob/living/L in T)
			if(!L.CanPass(caller, T))
				return FALSE
		return TRUE

/datum/ai_controller/insane/murder/SelectBehaviors(delta_time)
	var/mob/living/living_pawn = pawn
	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	..()
	var/atom/selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	var/is_mecha = FALSE
	if(ismecha(living_pawn.loc))
		is_mecha = TRUE
	var/has_weapon = FALSE
	var/has_non_white_weapon = FALSE
	if(!is_mecha)
		for(var/obj/item/I in living_pawn.held_items)
			if(istype(I, /obj/item/offhand))
				continue
			if(GetEffectiveItemForce(I) <= INSANE_MINIMUM_WEAPON_FORCE)
				living_pawn.dropItemToGround(I, force = TRUE)
				continue
			has_weapon = TRUE
			if(istype(I, /obj/item/gun/ego_gun))
				var/obj/item/gun/ego_gun/G = I
				var/obj/item/ammo_casing/casing = initial(G.ammo_type)
				var/obj/projectile/boolet = initial(casing.projectile_type)
				if(initial(boolet.damage_type) != WHITE_DAMAGE)
					has_non_white_weapon = TRUE
			else if(I.damtype != WHITE_DAMAGE)
				has_non_white_weapon = TRUE

		//if no item try to find something before fighting if already have item then it will do until the fight ends
		var/mob/living/carbon/human/human_target = selected_enemy
		var/list/weapon_list
		if(istype(human_target) && human_target.sanity_lost && !has_non_white_weapon)
			weapon_list = TryFindWeapon(FALSE)
		else if(!has_weapon)
			weapon_list = TryFindWeapon()
		if(weapon_list && weapon_list.len > 0)
			var/obj/item/weapon = weapon_list[1]
			blackboard[BB_INSANE_PICKUPTARGET] = weapon
			if(isturf(weapon.loc))
				current_movement_target = weapon
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/ground)
			else
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/inventory)
			return

	if(!selected_enemy)
		if(!FindEnemies())
			return
		selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	// Ah ha! We'll fight our current enemy.
	if(selected_enemy && is_mecha)
		current_movement_target = selected_enemy
		if(DT_PROB(50, delta_time))
			current_behaviors += GET_AI_BEHAVIOR(lines_type)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_mecha_attack)
		return
	else if(selected_enemy && isliving(selected_enemy))
		var/mob/living/living_enemy = selected_enemy
		if(living_enemy.status_flags & GODMODE)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(!(living_enemy in livinginrange(10, living_pawn)))
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(living_enemy.stat != DEAD)
			current_movement_target = living_enemy
			if(DT_PROB(50, delta_time))
				current_behaviors += GET_AI_BEHAVIOR(lines_type)
			current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_attack_mob)
			return
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
		return
	else if(selected_enemy && ismecha(selected_enemy))
		var/obj/vehicle/sealed/mecha/mecha_enemy = selected_enemy
		if(get_dist(living_pawn, mecha_enemy) > 10 || living_pawn.z != mecha_enemy.z)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(!mecha_enemy.occupants || mecha_enemy.occupants.len < 1)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		current_movement_target = mecha_enemy
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = mecha_enemy.occupants[1]
		if(DT_PROB(50, delta_time))
			current_behaviors += GET_AI_BEHAVIOR(lines_type)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_attack_mob)
		return

	if(!is_mecha)
		var/list/weapon_list = TryFindWeapon()
		if(weapon_list && weapon_list.len > 0)
			var/obj/item/weapon = weapon_list[1]
			blackboard[BB_INSANE_PICKUPTARGET] = weapon
			if(isturf(weapon.loc))
				current_movement_target = weapon
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/ground)
			else
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/inventory)
			return

	if(FindEnemies())
		return

/datum/ai_controller/insane/murder/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(IS_DEAD_OR_INCAP(living_pawn))
		return
	// No current enemy? We'll arm ourselves!
	if(!ismecha(living_pawn.loc))
		var/list/weapon_list = TryFindWeapon()
		if(weapon_list)
			for(var/obj/item/weapon in weapon_list)
				var/list/path = get_path_to(living_pawn, weapon, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))
				if(path.len == 0 && weapon.loc != living_pawn.loc && weapon.loc != living_pawn)
					continue
				blackboard[BB_INSANE_PICKUPTARGET] = weapon
				if(isturf(weapon.loc))
					current_movement_target = weapon
					current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/ground)
				else
					current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/inventory)
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
		if(timerid)
			deltimer(timerid)
			timerid = null
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

/proc/ComparatorItemForceGreater(obj/item/left, obj/item/right)
	return GetEffectiveItemForce(left) > GetEffectiveItemForce(right)

/datum/ai_controller/insane/murder/proc/TryFindWeapon(is_white_allowed = TRUE)
	var/mob/living/living_pawn = pawn
	var/list/weapons = list()

	blackboard[BB_INSANE_BEST_FORCE_FOUND] = INSANE_MINIMUM_WEAPON_FORCE

	var/list/item_blacklist = blackboard[BB_INSANE_BLACKLISTITEMS]
	for(var/obj/item/I in living_pawn.held_items)
		if(blackboard[BB_INSANE_BLACKLISTITEMS][I])
			continue
		if(blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS][I])
			continue
		if(istype(I, /obj/item/offhand))
			continue
		var/item_force = GetEffectiveItemForce(I)
		if(item_force <= INSANE_MINIMUM_WEAPON_FORCE)
			living_pawn.dropItemToGround(I, force = TRUE)
			item_blacklist[I] = TRUE
			continue
		var/obj/item/ego_weapon/EW = I
		var/obj/item/gun/ego_gun/EG = I
		if(istype(EW) && !EW.CanUseEgo(living_pawn))
			living_pawn.dropItemToGround(I, force = TRUE)
			item_blacklist[I] = TRUE
			continue
		if(istype(EG))
			if(!EG.CanUseEgo(living_pawn))
				living_pawn.dropItemToGround(I, force = TRUE)
				item_blacklist[I] = TRUE
				continue
			if(!is_white_allowed)
				var/obj/item/ammo_casing/casing = initial(EG.ammo_type)
				var/obj/projectile/boolet = initial(casing.projectile_type)
				if(initial(boolet.damage_type) == WHITE_DAMAGE)
					continue
		if(!is_white_allowed && I.damtype == WHITE_DAMAGE)
			continue
		if(item_force > blackboard[BB_INSANE_BEST_FORCE_FOUND])
			blackboard[BB_INSANE_BEST_FORCE_FOUND] = item_force

	var/list/items_to_check = living_pawn.get_equipped_items(include_pockets = TRUE)
	for(var/obj/item/storage/B in items_to_check)
		items_to_check += B.contents
	for(var/obj/item/i in items_to_check)
		if(blackboard[BB_INSANE_BLACKLISTITEMS][i])
			continue
		if(blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS][i])
			continue
		var/obj/item/ego_weapon/EW = i
		var/obj/item/gun/ego_gun/EG = i
		if(istype(EW) && !EW.CanUseEgo(living_pawn))
			living_pawn.dropItemToGround(i, force = TRUE)
			item_blacklist[i] = TRUE
			continue
		if(istype(EG))
			if(!EG.CanUseEgo(living_pawn))
				living_pawn.dropItemToGround(i, force = TRUE)
				item_blacklist[i] = TRUE
				continue
			if(!is_white_allowed)
				var/obj/item/ammo_casing/casing = initial(EG.ammo_type)
				var/obj/projectile/boolet = initial(casing.projectile_type)
				if(initial(boolet.damage_type) == WHITE_DAMAGE)
					continue
		if(!is_white_allowed && i.damtype == WHITE_DAMAGE)
			continue
		if(!IsBetterWeapon(living_pawn, i, blackboard[BB_INSANE_BEST_FORCE_FOUND]))
			continue
		sorted_insert(weapons, i, GLOBAL_PROC_REF(ComparatorItemForceGreater))
	for(var/obj/item/i in oview(7, living_pawn))
		if(blackboard[BB_INSANE_BLACKLISTITEMS][i])
			continue
		if(blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS][i])
			continue
		var/obj/item/ego_weapon/EW = i
		var/obj/item/gun/ego_gun/EG = i
		if(istype(EW) && !EW.CanUseEgo(living_pawn))
			item_blacklist[i] = TRUE
			continue
		if(istype(EG))
			if(!EG.CanUseEgo(living_pawn))
				item_blacklist[i] = TRUE
				continue
			if(!is_white_allowed)
				var/obj/item/ammo_casing/casing = initial(EG.ammo_type)
				var/obj/projectile/boolet = initial(casing.projectile_type)
				if(initial(boolet.damage_type) == WHITE_DAMAGE)
					continue
		if(!is_white_allowed && i.damtype == WHITE_DAMAGE)
			continue
		if(!IsBetterWeapon(living_pawn, i, blackboard[BB_INSANE_BEST_FORCE_FOUND]))
			continue
		sorted_insert(weapons, i, GLOBAL_PROC_REF(ComparatorItemForceGreater))
	if(weapons.len)
		return weapons
	return null

/proc/GetEffectiveItemForce(obj/item/I, considerRangedAttack = TRUE, justice = 0)
	var/power = I.force * (1 + justice / 100)
	if(istype(I, /obj/item/ego_weapon))
		var/obj/item/ego_weapon/EW = I
		power *= EW.force_multiplier
		power /= EW.attack_speed ? CLICK_CD_MELEE * EW.attack_speed / 10 : CLICK_CD_MELEE / 10 //damage per second
	else if(considerRangedAttack && istype(I, /obj/item/gun/ego_gun))
		var/obj/item/gun/ego_gun/gun_i = I
		var/obj/item/ammo_casing/casing = initial(gun_i.ammo_type)
		var/obj/projectile/boolet = initial(casing.projectile_type)
		var/gun_power = initial(boolet.damage) * gun_i.burst_size * initial(casing.pellets)
		if(gun_i.autofire)
			gun_power /= gun_i.autofire / 10
		else
			gun_power /= gun_i.fire_delay > CLICK_CD_RANGE ? gun_i.fire_delay / 10 : CLICK_CD_RANGE / 10
		if(gun_power > power)
			power = gun_power
	else
		power /= CLICK_CD_MELEE / 10
	return power

/proc/IsBetterWeapon(mob/living/carbon/human/H, obj/item/I, current_highest_force, considerRangedAttack = TRUE, applyJustice = FALSE)
	var/justice = applyJustice ? get_modified_attribute_level(H, JUSTICE_ATTRIBUTE) : 0
	return GetEffectiveItemForce(I, considerRangedAttack, justice) > current_highest_force

/datum/ai_controller/insane/murder/proc/FindEnemies()
	. = FALSE
	var/mob/living/living_pawn = pawn
	var/atom/movable/sees_from = pawn
	if(!isturf(living_pawn.loc))
		sees_from = pawn.loc
	var/list/potential_enemies = livinginview(9, sees_from)

	if(!LAZYLEN(potential_enemies)) // We aint see shit!
		return

	var/list/weighted_list = list()
	for(var/mob/living/L in potential_enemies) // Oh the CHOICES!
		if(L == living_pawn)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		if(living_pawn.see_invisible < L.invisibility)
			continue
		if(!isturf(L.loc) && !ismecha(L.loc))
			continue
		weighted_list += L
	for(var/i in weighted_list)
		if(istype(i, /mob/living/simple_animal/hostile))
			weighted_list[i] = 3
		else if(ishuman(i))
			var/mob/living/carbon/human/H = i
			if(H.sanity_lost)
				weighted_list[i] = 2
			else if(ismecha(H.loc))
				weighted_list[i] = 3
			else
				weighted_list[i] = 5
		else
			weighted_list[i] = 1
	if(weighted_list.len > 0)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = pickweight(weighted_list)
		return TRUE
	return FALSE

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

//Does not work /mob/living/bullet_act does not call parent and does not send any signals
/datum/ai_controller/insane/murder/on_bullet_act(datum/source, obj/projectile/Proj)
	..()
	if(isliving(Proj.firer))
		retaliate(Proj.firer)
		return
	if(ismecha(Proj.firer))
		var/obj/vehicle/sealed/mecha/M = Proj.firer
		if(M.occupants && M.occupants.len > 0)
			retaliate(M.occupants[1])
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
	if(IS_DEAD_OR_INCAP(living_pawn) || living_pawn.see_invisible < AM.invisibility)
		return
	var/mob/living/living_thing = AM
	if(istype(living_thing) && !(living_thing.status_flags & GODMODE) && living_thing.stat != DEAD)
		retaliate(living_thing)
		return
	var/obj/vehicle/sealed/mecha/mech = AM
	if(istype(mech) && mech.occupants && mech.occupants.len > 0)
		retaliate(mech.occupants[1])
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
