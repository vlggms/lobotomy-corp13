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
	RegisterSignal(new_pawn, COMSIG_LIVING_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, PROC_REF(on_hitby))
	RegisterSignal(new_pawn, COMSIG_MOVABLE_CROSSED, PROC_REF(on_Crossed))
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, PROC_REF(on_startpulling))
	return ..() //Run parent at end

/datum/ai_controller/insane/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(
		COMSIG_PARENT_ATTACKBY,
		COMSIG_ATOM_ATTACK_ANIMAL,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_LIVING_BULLET_ACT,
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
	var/is_mech_attack_on_cooldown = FALSE
	var/mech_attack_timer_id = null
	var/is_melee_attack_on_cooldown = FALSE
	var/melee_attack_timer_id = null
	var/lose_patience_timer_id = null
	var/lose_patience_time = 7 SECONDS
	var/aggro_range = 10
	var/list/target_memory = list()
	var/last_known_location = null
	var/target_lost = FALSE
	var/stat_attack = HARD_CRIT
	var/list/blacklist = list()	//You DON'T want to attack these

/datum/ai_controller/insane/murder/Destroy()
	if(mech_attack_timer_id)
		deltimer(mech_attack_timer_id)
		mech_attack_timer_id = null
	if(melee_attack_timer_id)
		deltimer(melee_attack_timer_id)
		melee_attack_timer_id = null
	if(lose_patience_timer_id)
		deltimer(lose_patience_timer_id)
		lose_patience_timer_id = null
	target_memory.Cut()
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
	timerid = null
	var/mob/living/living_pawn = pawn
	if(IS_DEAD_OR_INCAP(living_pawn))
		CancelActions()
		return FALSE

	if(QDELETED(current_movement_target) || current_movement_target.z == living_pawn.z && get_dist(living_pawn, current_movement_target) > max_target_distance)
		CancelActions()
		return FALSE

	var/obj/vehicle/sealed/mecha/the_mecha = null
	if(ismecha(living_pawn.loc))
		the_mecha = living_pawn.loc

	var/move_mod = living_pawn.cached_multiplicative_slowdown
	var/atom/selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	var/atom/selected_item = blackboard[BB_INSANE_PICKUPTARGET]
	var/isGunHealingTargetSanity = FALSE
	var/obj/item/ego_weapon/ranged/banger = null
	if(the_mecha)
		move_mod = the_mecha.movedelay + 0.1 //just a little bit more to guarantee that we can always move when mecha is ready to move
	else if(living_pawn.held_items && living_pawn.held_items.len == 2 && istype(living_pawn.held_items[1], /obj/item/ego_weapon/ranged))
		banger = living_pawn.held_items[1]
		var/obj/item/ammo_casing/casing = initial(banger.projectile_path)
		var/obj/projectile/boolet = initial(casing.projectile_type)
		if(initial(boolet.damage_type) == WHITE_DAMAGE && ishuman(selected_enemy))
			var/mob/living/carbon/human/H = selected_enemy
			if(H.sanity_lost)
				isGunHealingTargetSanity = TRUE
		move_mod *= 1.1
	else
		move_mod *= 0.9

	timerid = addtimer(CALLBACK(src, PROC_REF(MoveTo), delta_time), move_mod, TIMER_STOPPABLE)

	var/atom/movable/thing_to_move = the_mecha ? the_mecha : living_pawn
	var/turf/our_turf = get_turf(thing_to_move)
	var/turf/moves_to = get_turf(current_movement_target)
	var/turf/target_at = get_turf(selected_enemy)
	var/can_see_target = (!QDELETED(selected_enemy) && ((selected_enemy in ohearers(aggro_range, thing_to_move)) || ismecha(selected_enemy.loc))) ? TRUE : FALSE

	if(!selected_item)
		if(moves_to == target_at)
			if(can_see_target)
				target_lost = FALSE
				last_known_location = target_at
			else if(target_lost || !(target_at in oview(8, thing_to_move)))
				target_lost = TRUE
				if(FindEnemies())
					return
				current_movement_target = last_known_location
				moves_to = last_known_location
		else if(target_lost)
			if(can_see_target)
				target_lost = FALSE
				current_movement_target = selected_enemy
				moves_to = target_at
				last_known_location = target_at
			else if(FindEnemies())
				return
/* 			else
				//can put code for walking around the area looking for target here
*/

	var/turf/target_turf
	var/current_dist = get_dist(thing_to_move, moves_to)
	if(the_mecha)
		var/is_mech_ranged = FALSE
		for(var/equip in the_mecha.equipment)
			var/obj/item/mecha_parts/mecha_equipment/ME = equip
			if(ME.range & MECHA_RANGED)
				is_mech_ranged = TRUE
				break
		if(is_mech_ranged && (current_dist < 4))
			the_mecha.strafe = TRUE
			target_turf = get_step_away(thing_to_move, moves_to)
		else if (current_dist >= 2 && !is_mech_ranged || current_dist >= 5)
			var/list/path = get_path_to(thing_to_move, moves_to, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))
			if(path.len > 1)
				target_turf = path[2]
			else
				target_turf = get_step_towards(thing_to_move, moves_to)

		if(target_turf)
			the_mecha.relaymove(living_pawn, get_dir(our_turf, target_turf))
		else
			var/direction = get_cardinal_dir_no_random(the_mecha, moves_to)
			if(the_mecha.dir != direction)
				if(!(the_mecha.mecha_flags & QUIET_TURNS) && !the_mecha.step_silent)
					playsound(the_mecha, the_mecha.turnsound, 40, TRUE)
				the_mecha.setDir(direction)
		the_mecha.strafe = FALSE
	else if(selected_item)
		var/list/path = get_path_to(thing_to_move, moves_to, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))
		if(path.len > 1)
			target_turf = path[2]
		else
			target_turf = get_step_towards(thing_to_move, moves_to)

		if(target_turf && (living_pawn.mobility_flags & MOBILITY_MOVE))
			thing_to_move.Move(target_turf, get_dir(our_turf, target_turf))
	else
		if(banger && banger.is_reloading)
			target_turf = null
		else if((current_dist < 2) && banger && !isGunHealingTargetSanity && !target_lost)
			target_turf = get_step_away(thing_to_move, moves_to)
		else if ((!banger || isGunHealingTargetSanity || target_lost) && current_dist >= 2 || current_dist >= 5 || banger && !isGunHealingTargetSanity && !target_lost && !CanShoot(thing_to_move, moves_to, 6))
			var/list/path = get_path_to(thing_to_move, moves_to, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))
			if(path.len > 1)
				target_turf = path[2]
			else
				target_turf = get_step_towards(thing_to_move, moves_to)

		if(target_turf && (living_pawn.mobility_flags & MOBILITY_MOVE))
			thing_to_move.Move(target_turf, get_dir(our_turf, target_turf))
	return TRUE

/proc/CanShoot(atom/A, atom/B, max_distance)
	var/turf/start = get_turf(A)
	var/turf/end = get_turf(B)
	if(start.z != end.z)
		return FALSE
	if(start.density)
		return FALSE
	for(var/obj/O in start)
		if(O.density)
			return FALSE
	var/distance = abs(start.x - end.x) + abs(start.y - end.y)
	if(!max_distance)
		max_distance = distance
	var/step_x = (end.x - start.x) / distance
	var/step_y = (end.y - start.y) / distance
	for(var/i in 1 to max_distance)
		var/current_x = start.x + step_x * i
		var/current_y = start.y + step_y * i
		var/list/turfs_to_check = list()
		if(abs((current_x - floor(current_x)) - 0.5) < 0.05)
			turfs_to_check |= locate(round(current_x - 0.5, 1), round(current_y, 1), start.z)
			turfs_to_check |= locate(round(current_x + 0.5, 1), round(current_y, 1), start.z)
		if(abs((current_y - floor(current_y)) - 0.5) < 0.05)
			turfs_to_check |= locate(round(current_x, 1), round(current_y - 0.5, 1), start.z)
			turfs_to_check |= locate(round(current_x, 1), round(current_y + 0.5, 1), start.z)
		turfs_to_check |= locate(round(current_x, 1), round(current_y, 1), start.z)
		for(var/turf/T in turfs_to_check)
			if(T.density)
				return FALSE
			for(var/obj/O in T)
				if(istype(O, /obj/structure/table) || istype(O, /obj/structure/railing))
					continue
				if(O.density)
					return FALSE
		if(end in turfs_to_check)
			return TRUE
	return FALSE

/turf/proc/reachableTurftestWithMobs(requester, turf/T, ID, simulated_only)
	if(T && !T.density && !(simulated_only && SSpathfinder.space_type_cache[T.type]) && !LinkBlockedWithAccess(T,requester, ID))
		if(is_type_in_typecache(T, GLOB.dangerous_turfs) && !(locate(/obj/structure/lattice) in T))
			return FALSE
		for(var/mob/living/L in T)
			if(!L.CanPass(requester, T))
				return FALSE
		if(locate(/obj/item/soap) in T)
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
			if(istype(I, /obj/item/ego_weapon/ranged))
				var/obj/item/ego_weapon/ranged/G = I
				var/obj/item/ammo_casing/casing = initial(G.projectile_path)
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
		if(weapon_list)
			INVOKE_ASYNC(src, PROC_REF(TryEquipWeapon), weapon_list)
			return

	if(!selected_enemy)
		if(!FindEnemies())
			return
		selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	// Ah ha! We'll fight our current enemy.
	if(selected_enemy && is_mecha)
		GiveTarget(selected_enemy)
		if(DT_PROB(50, delta_time))
			current_behaviors += GET_AI_BEHAVIOR(lines_type)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_mecha_attack)
		return
	else if(selected_enemy && isliving(selected_enemy))
		var/mob/living/living_enemy = selected_enemy
		if(living_enemy.status_flags & GODMODE)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(!(living_enemy in range(10, living_pawn)))
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(living_enemy.stat != DEAD)
			GiveTarget(selected_enemy)
			if(DT_PROB(50, delta_time))
				current_behaviors += GET_AI_BEHAVIOR(lines_type)
			current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_attack_mob)
			return
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
		return

	if(!is_mecha)
		var/list/weapon_list = TryFindWeapon()
		if(weapon_list)
			INVOKE_ASYNC(src, PROC_REF(TryEquipWeapon), weapon_list)
			return

	if(FindEnemies())
		return

///Checks a list of weapons and if any of them are reachable will add the equip behavior.
/datum/ai_controller/insane/murder/proc/TryEquipWeapon(list/potential_weapons)
	if(potential_weapons && potential_weapons.len > 0)
		var/list/temp_blacklist = blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS]
		temp_blacklist.Cut()
		for(var/obj/item/weapon in potential_weapons)
			var/list/path = get_path_to(pawn, weapon, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))
			if(path.len == 0 && weapon.loc != pawn.loc && weapon.loc != pawn)
				temp_blacklist[weapon] = TRUE
				continue
			blackboard[BB_INSANE_PICKUPTARGET] = weapon
			if(isturf(weapon.loc))
				current_movement_target = weapon
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/ground)
				return
			return
	return

/datum/ai_controller/insane/murder/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(IS_DEAD_OR_INCAP(living_pawn))
		return
	// No current enemy? We'll arm ourselves!
	if(!ismecha(living_pawn.loc))
		var/list/weapon_list = TryFindWeapon()
		if(weapon_list)
			INVOKE_ASYNC(src, PROC_REF(TryEquipWeapon), weapon_list)
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

	//clear hands of trash and unusable items
	var/list/item_blacklist = blackboard[BB_INSANE_BLACKLISTITEMS]
	for(var/obj/item/I in living_pawn.held_items)
		if(blackboard[BB_INSANE_BLACKLISTITEMS][I])
			living_pawn.dropItemToGround(I, force = TRUE)
			continue
		if(blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS][I])
			living_pawn.dropItemToGround(I, force = TRUE)
			continue
		if(istype(I, /obj/item/offhand))
			continue
		var/item_force = GetEffectiveItemForce(I)
		if(item_force <= INSANE_MINIMUM_WEAPON_FORCE)
			living_pawn.dropItemToGround(I, force = TRUE)
			item_blacklist[I] = TRUE
			continue
		var/obj/item/ego_weapon/EW = I
		var/obj/item/ego_weapon/ranged/EG = I
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
				var/obj/item/ammo_casing/casing = initial(EG.projectile_path)
				var/obj/projectile/boolet = initial(casing.projectile_type)
				if(initial(boolet.damage_type) == WHITE_DAMAGE)
					continue
		if(!is_white_allowed && I.damtype == WHITE_DAMAGE)
			continue
		if(item_force > blackboard[BB_INSANE_BEST_FORCE_FOUND])
			blackboard[BB_INSANE_BEST_FORCE_FOUND] = item_force

	//check inventory for weapons
	var/list/items_to_check = living_pawn.get_equipped_items(include_pockets = TRUE)
	for(var/obj/item/storage/B in items_to_check)
		items_to_check += B.contents
	for(var/obj/item/i in items_to_check)
		if(blackboard[BB_INSANE_BLACKLISTITEMS][i])
			continue
		if(blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS][i])
			continue
		var/obj/item/ego_weapon/EW = i
		var/obj/item/ego_weapon/ranged/EG = i
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
				var/obj/item/ammo_casing/casing = initial(EG.projectile_path)
				var/obj/projectile/boolet = initial(casing.projectile_type)
				if(initial(boolet.damage_type) == WHITE_DAMAGE)
					continue
		if(!is_white_allowed && i.damtype == WHITE_DAMAGE)
			continue
		var/force = GetEffectiveItemForce(i)
		if(force < blackboard[BB_INSANE_BEST_FORCE_FOUND])
			continue
		blackboard[BB_INSANE_BEST_FORCE_FOUND] = force
	//check in view for weapons
	for(var/obj/item/i in oview(7, living_pawn))
		if(blackboard[BB_INSANE_BLACKLISTITEMS][i])
			continue
		if(blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS][i])
			continue
		if(i.anchored)
			continue
		var/obj/item/ego_weapon/EW = i
		var/obj/item/ego_weapon/ranged/EG = i
		if(istype(EW) && !EW.CanUseEgo(living_pawn))
			item_blacklist[i] = TRUE
			continue
		if(istype(EG))
			if(!EG.CanUseEgo(living_pawn))
				item_blacklist[i] = TRUE
				continue
			if(!is_white_allowed)
				var/obj/item/ammo_casing/casing = initial(EG.projectile_path)
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
		switch(I.type)
			if(/obj/item/ego_weapon/twilight, /obj/item/ego_weapon/shield/distortion)
				power *= 4
			if(/obj/item/ego_weapon/space)
				power *= 2
			if(/obj/item/ego_weapon/blind_rage)
				power *= 3 //not sure how accurate but will make them love using it
	else if(considerRangedAttack && istype(I, /obj/item/ego_weapon/ranged))
		var/obj/item/ego_weapon/ranged/gun_i = I
		var/obj/item/ammo_casing/casing = initial(gun_i.projectile_path)
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

///Gets a list of all living in view and inside containers then checks whether they are an allowed target and returns a list.
/datum/ai_controller/insane/murder/proc/PossibleEnemies(range = aggro_range)
	var/mob/living/living_pawn = pawn
	var/atom/movable/sees_from = pawn
	if(!isturf(living_pawn.loc))
		sees_from = pawn.loc
	var/list/potential_enemies = livinginview(range, sees_from)
	. = list()

	if(!LAZYLEN(potential_enemies))
		return

	for(var/L in potential_enemies)
		if(!CanTarget(L))
			continue
		. += L
	return

///Return TRUE if you want thing to be attackable
/datum/ai_controller/insane/murder/proc/CanTarget(atom/movable/thing)
	var/mob/living/living_pawn = pawn
	if(living_pawn.see_invisible < thing.invisibility)
		return FALSE
	if(isliving(thing))
		var/mob/living/living_thing = thing
		if(living_thing == living_pawn)
			return FALSE
		if(living_thing.status_flags & GODMODE)
			return FALSE
		if(living_thing.stat > stat_attack)
			return FALSE
		if(!isturf(living_thing.loc) && !ismecha(living_thing.loc))
			return FALSE
		if(living_thing.type in blacklist)
			return FALSE
		return TRUE
	return FALSE

///Checks for potential enemies in view with range, and sets the attack target for the ai; returns TRUE if target was set.
/datum/ai_controller/insane/murder/proc/FindEnemies(range = aggro_range)
	var/list/weighted_list = PossibleEnemies(range)
	for(var/atom/movable/i in weighted_list)
		//target type weight
		if(istype(i, /mob/living/simple_animal/hostile))
			weighted_list[i] = 4
		else if(ishuman(i))
			var/mob/living/carbon/human/H = i
			if(H.sanity_lost)
				weighted_list[i] = 3
			else if(ismecha(H.loc))
				weighted_list[i] = 4
			else
				weighted_list[i] = 7
		else
			weighted_list[i] = 1
		//target distance weight
		weighted_list[i] += 10 - min(get_dist(get_turf(pawn), get_turf(i)), 10)
		//previous target weight
		if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] == i)
			weighted_list[i] = max(weighted_list[i] - 10, 1)
	if(weighted_list.len > 0)
		GiveTarget(pickweight(weighted_list))
		return TRUE
	return FALSE

/datum/ai_controller/insane/murder/proc/GiveTarget(atom/movable/target)
	blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = target
	GainPatience()
	current_movement_target = target
	last_known_location = get_turf(target)
	target_memory.Cut()
	target_lost = FALSE

/datum/ai_controller/insane/murder/proc/GainPatience()
	if(lose_patience_timer_id)
		deltimer(lose_patience_timer_id)
		lose_patience_timer_id = null
	lose_patience_timer_id = addtimer(CALLBACK(src, PROC_REF(TryChangeTarget)), lose_patience_time, TIMER_STOPPABLE)

/datum/ai_controller/insane/murder/proc/TryChangeTarget()
	lose_patience_timer_id = null
	if(!FindEnemies())
		for(var/datum/ai_behavior/insanity_attack_mob/i in current_behaviors)
			i.finish_action(src, TRUE)

/datum/ai_controller/insane/murder/proc/RegisterAggroValue(atom/movable/source, amount, damage_type)
	if(QDELETED(source) || !damage_type)
		return FALSE
	if(!isnum(target_memory[source]))
		target_memory += source

//aggro damage and the way its supposed to be applied are not implemented yet
/* 	if(damage_type == AGGRO_DAMAGE)
		if(istype(source, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = source
			var/aggro_stat_modifier = 1 + (get_attribute_level(H, FORTITUDE_ATTRIBUTE) + get_attribute_level(H, PRUDENCE_ATTRIBUTE)) / 200
			amount *= aggro_stat_modifier
	else
		var/mob/living/living_pawn = pawn
		var/hit_percent = (100 - living_pawn.getarmor(null, damage_type)) * 0.01
		amount *= hit_percent */
	var/mob/living/living_pawn = pawn
	var/hit_percent = (100 - living_pawn.getarmor(null, damage_type)) * 0.01
	amount *= hit_percent

	target_memory[source] += amount

	var/atom/movable/current_target = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!QDELETED(current_target) && source != current_target && target_memory[source] > target_memory[current_target] + GetTargetSwitchThreshold() && CanTarget(source))
		GiveTarget(source)
		target_memory[source] += amount
	return TRUE

/datum/ai_controller/insane/murder/proc/GetTargetSwitchThreshold()
	var/mob/living/living_pawn = pawn
	return living_pawn.maxHealth * 0.1

// We stop trying to pick up a weapon if we're suddenly attacked
/datum/ai_controller/insane/murder/retaliate(mob/living/L)
	if(!CanTarget(L))
		return
	if(!(locate(/datum/ai_behavior/insanity_attack_mob) in current_behaviors))
		for(var/datum/ai_behavior/I in current_behaviors)
			I.finish_action(src, TRUE)
		GiveTarget(L)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_attack_mob)
	else if(L == blackboard[BB_INSANE_CURRENT_ATTACK_TARGET])
		GainPatience()
	else if(target_lost)
		GiveTarget(L)
	return

/datum/ai_controller/insane/murder/on_attackby(datum/source, obj/item/I, mob/user)
	..()
	retaliate(user)
	var/aggro = I.force
	aggro *= I.force_multiplier
	if(ishuman(user))
		aggro *= 1 + get_modified_attribute_level(user, JUSTICE_ATTRIBUTE) * 0.01
	RegisterAggroValue(user, aggro, I.damtype)
	return

/datum/ai_controller/insane/murder/on_attackby_animal(datum/source, mob/living/simple_animal/animal)
	..()
	retaliate(animal)
	RegisterAggroValue(animal, animal.melee_damage_upper, animal.melee_damage_type)
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
		RegisterAggroValue(Proj.firer, Proj.damage, Proj.damage_type)
		return
	if(ismecha(Proj.firer))
		var/obj/vehicle/sealed/mecha/M = Proj.firer
		if(M.occupants && M.occupants.len > 0)
			retaliate(M.occupants[1])
			RegisterAggroValue(M.occupants[1], Proj.damage, Proj.damage_type)
	return

/datum/ai_controller/insane/murder/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	..()
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		if(I.throwforce > 0 && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			retaliate(H)
			var/aggro = I.throwforce * (1 + get_modified_attribute_level(H, JUSTICE_ATTRIBUTE) * 0.01)
			aggro *= I.force_multiplier
			RegisterAggroValue(H, aggro, I.damtype)
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
