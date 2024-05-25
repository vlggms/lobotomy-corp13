/datum/ai_behavior/say_line/insanity_lines
	var/line_type = "murder"

/datum/ai_behavior/say_line/insanity_lines/New()
	. = ..()
	lines = strings("insanity.json", line_type)

/datum/ai_behavior/say_line/insanity_lines/insanity_suicide
	line_type = "suicide"

/datum/ai_behavior/say_line/insanity_lines/insanity_wander
	line_type = "wander"

/datum/ai_behavior/say_line/insanity_lines/insanity_wander/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	var/sanity_damage = get_user_level(living_pawn) * 10
	for(var/mob/living/carbon/human/H in view(9, living_pawn))
		if(H == living_pawn)
			continue
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			continue
		H.apply_damage(sanity_damage, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))

/datum/ai_behavior/say_line/insanity_lines/insanity_release
	line_type = "release"

/datum/ai_behavior/insanity_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/insanity_attack_mob/perform(delta_time, datum/ai_controller/insane/murder/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn

	var/atom/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(IS_DEAD_OR_INCAP(living_pawn) || !target || living_pawn.see_invisible < target.invisibility)
		finish_action(controller, TRUE)
		return
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat == DEAD || (living_target.status_flags & GODMODE))
			finish_action(controller, TRUE)
			return
	else if(ismecha(target))
		var/obj/vehicle/sealed/mecha/mech_target = target
		if(!mech_target.occupants || mech_target.occupants.len < 1)
			finish_action(controller, TRUE)
			return
	else
		finish_action(controller, TRUE)
		return

	var/mob/living/carbon/C = living_pawn
	if(istype(C) && C.handcuffed)
		C.resist_restraints()
		controller.current_movement_target = null
		return
	if(living_pawn.pulledby)
		if(living_pawn.pulledby != target)
			controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = living_pawn.pulledby
			target = living_pawn.pulledby
			controller.current_movement_target = living_pawn.pulledby
		living_pawn.resist_grab()
	if(living_pawn.buckled)
		living_pawn.resist_buckle()
		if(living_pawn.buckled)
			attack(controller, living_pawn.buckled, delta_time)
			return
	if(living_pawn.loc && !isturf(living_pawn.loc))
		living_pawn.loc.container_resist_act(living_pawn)
		if(!isturf(living_pawn.loc))
			attack(controller, living_pawn.loc, delta_time)
			return

	var/list/item_blacklist = controller.blackboard[BB_INSANE_BLACKLISTITEMS]
	var/has_weapon = FALSE
	var/has_non_white_weapon = FALSE
	for(var/obj/item/I in living_pawn.held_items)
		if(istype(I, /obj/item/offhand))
			continue
		if(GetEffectiveItemForce(I) <= INSANE_MINIMUM_WEAPON_FORCE)
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
			has_weapon = TRUE
			var/obj/item/ammo_casing/casing = initial(EG.ammo_type)
			var/obj/projectile/boolet = initial(casing.projectile_type)
			if(initial(boolet.damage_type) != WHITE_DAMAGE)
				has_non_white_weapon = TRUE
			continue
		has_weapon = TRUE
		if(I.damtype != WHITE_DAMAGE)
			has_non_white_weapon = TRUE

	var/found_new_weapon = FALSE
	var/mob/living/carbon/human/human_target = target
	var/need_non_white_weapon = FALSE
	if(istype(human_target) && human_target.sanity_lost && !has_non_white_weapon)
		need_non_white_weapon = TRUE
	if(!has_weapon || need_non_white_weapon)
		var/list/temp_blacklist = controller.blackboard[BB_INSANE_TEMPORARY_BLACKLISTITEMS]
		temp_blacklist.Cut()
		var/list/weapon_list = controller.TryFindWeapon(!need_non_white_weapon)
		if(weapon_list)
			for(var/obj/item/weapon in weapon_list)
				var/list/path = get_path_to(living_pawn, weapon, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))
				if(path.len == 0 && weapon.loc != living_pawn.loc && weapon.loc != living_pawn)
					temp_blacklist[weapon] = TRUE
					continue
				found_new_weapon = TRUE
	if(found_new_weapon)
		finish_action(controller, FALSE)
		return

	var/atom/thing_to_target
	if(isturf(target.loc))
		thing_to_target = target
	else if(isobj(target.loc))
		thing_to_target = target.loc
	if(thing_to_target)
		controller.current_movement_target = thing_to_target
		if(!living_pawn.Adjacent(target))
			var/obj/item/gun/ego_gun/banger = locate() in living_pawn.held_items
			if(banger)
				ranged_attack(controller, thing_to_target, delta_time)
			else
				DestroyPathToTarget(controller, thing_to_target, delta_time)
			return
		attack(controller, thing_to_target, delta_time)
	else
		finish_action(controller, TRUE)
		return

/datum/ai_behavior/insanity_attack_mob/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	walk(living_pawn, 0)
	if(succeeded)
		controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

/// attack using a held weapon otherwise bite the enemy, then if we are angry there is a chance we might calm down a little
/datum/ai_behavior/insanity_attack_mob/proc/attack(datum/ai_controller/insane/murder/controller, atom/target, delta_time)
	var/mob/living/living_pawn = controller.pawn
	if(!living_pawn)
		return

	if(!living_pawn.Adjacent(target))
		return

	if(living_pawn.next_move > world.time)
		return

	var/obj/item/weapon = null
	var/highest_force = INSANE_MINIMUM_WEAPON_FORCE
	for(var/obj/item/I in living_pawn.held_items)
		if(I.damtype == WHITE_DAMAGE && ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.sanity_lost) // So we don't restore sanity of insane
				continue
		var/weapon_power = GetEffectiveItemForce(I, FALSE)
		if(weapon_power > highest_force)
			weapon = I
			highest_force = weapon_power

	living_pawn.face_atom(target)

	// attack with weapon if we have one
	if(weapon)
		if(living_pawn.held_items.len == 2 && living_pawn.held_items[1] != weapon)
			living_pawn.held_items[2] = living_pawn.held_items[1]
			living_pawn.held_items[1] = weapon
		weapon.melee_attack_chain(living_pawn, target)
		if(istype(weapon, /obj/item/ego_weapon))
			var/obj/item/ego_weapon/EW = weapon
			var/cooldown = EW.attack_speed ? CLICK_CD_MELEE * EW.attack_speed : CLICK_CD_MELEE
			var/hit_count = max(floor(10 * delta_time / cooldown), 1)
			if(hit_count >= 2)
				for(var/i in 2 to hit_count)
					addtimer(CALLBACK(src, PROC_REF(DelayedMeleeAttack), living_pawn, weapon, target), cooldown * (i - 1))
	else if(isliving(target))
		var/mob/living/L = target
		// check if target has a weapon
		var/obj/item/W
		for(var/obj/item/I in L.held_items)
			if(!(I.item_flags & ABSTRACT) && GetEffectiveItemForce(I) > INSANE_MINIMUM_WEAPON_FORCE)
				W = I
				break
		// if the target has a weapon, chance to disarm them
		if(W && DT_PROB(25, delta_time))
			living_pawn.a_intent = INTENT_DISARM
		living_pawn.UnarmedAttack(target)
		living_pawn.changeNext_move(CLICK_CD_MELEE)
		living_pawn.a_intent = INTENT_HARM

/datum/ai_behavior/insanity_attack_mob/proc/DelayedMeleeAttack(mob/living/user, obj/item/weapon, atom/target)
	if(weapon && !IS_DEAD_OR_INCAP(user) && user.Adjacent(target) && (weapon in user.held_items))
		weapon.melee_attack_chain(user, target)

/// attack using this GUN we found.
/datum/ai_behavior/insanity_attack_mob/proc/ranged_attack(datum/ai_controller/insane/murder/controller, atom/target, delta_time)
	var/mob/living/living_pawn = controller.pawn
	if(!living_pawn)
		return

	if(living_pawn.next_move > world.time)
		return

	if(living_pawn.held_items[1] && living_pawn.held_items[2])
		for(var/obj/item/gun/ego_gun/G in living_pawn.held_items)
			if(G.weapon_weight == WEAPON_HEAVY)
				var/obj/item/I = living_pawn.held_items[1]
				if(GetEffectiveItemForce(living_pawn.held_items[1]) > GetEffectiveItemForce(living_pawn.held_items[2]))
					I = living_pawn.held_items[2]
				if(!I.equip_to_best_slot(living_pawn, FALSE))
					living_pawn.dropItemToGround(I, force = TRUE)
				break

	var/obj/item/gun/ego_gun/banger = null
	for(var/obj/item/gun/ego_gun/G in living_pawn.held_items)
		var/obj/item/ammo_casing/casing = initial(G.ammo_type)
		var/obj/projectile/boolet = initial(casing.projectile_type)
		if(initial(boolet.damage_type) == WHITE_DAMAGE && ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.sanity_lost) // So we don't restore sanity of insane
				continue
		if(living_pawn.held_items.len == 2 && living_pawn.held_items[1] != G)
			living_pawn.held_items[2] = living_pawn.held_items[1]
			living_pawn.held_items[1] = G
		banger = G
		break

	if(!banger)
		return

	living_pawn.face_atom(target)

	var/delay
	if(banger.autofire)
		delay = banger.autofire
	else
		delay = banger.fire_delay > CLICK_CD_RANGE ? banger.fire_delay : CLICK_CD_RANGE
	living_pawn.changeNext_move(CLICK_CD_RANGE)
	var/shots = max(floor(10 * delta_time / delay), 1)
	delay = 10 * delta_time / shots
	banger.afterattack(target, living_pawn, FALSE)
	for(var/i in 2 to shots)
		addtimer(CALLBACK(src, PROC_REF(DelayedGunAttack), living_pawn, banger, target, living_pawn.next_move), delay * (i - 1))

/datum/ai_behavior/insanity_attack_mob/proc/DelayedGunAttack(mob/living/user, obj/item/gun/weapon, atom/target, next_move)
	if(weapon && !IS_DEAD_OR_INCAP(user) && (weapon in user.held_items))
		weapon.spread += 20
		weapon.afterattack(target, user, FALSE)
		weapon.spread -= 20
		user.next_move = next_move

/datum/ai_behavior/insanity_attack_mob/proc/DestroyPathToTarget(datum/ai_controller/insane/murder/controller, atom/target, delta_time)
	var/dir_to_target = get_dir(controller.pawn, target)
	var/dir_list = list()
	if(ISDIAGONALDIR(dir_to_target))
		for(var/direction in GLOB.cardinals)
			if(direction & dir_to_target)
				dir_list += direction
	else
		dir_list += dir_to_target
	var/turf/pawn_turf = get_turf(controller.pawn)
	for(var/obj/structure/window/W in pawn_turf)
		if(!W.CanAStarPass(null, dir_to_target))
			attack(controller, W, delta_time)
			return
	for(var/obj/structure/railing/R in pawn_turf)
		if(!R.CanAStarPass(null, dir_to_target, controller.pawn))
			attack(controller, R, delta_time)
			return
	for(var/direction in dir_list)
		var/turf/T = get_step(controller.pawn, direction)
		if(QDELETED(T))
			return
		for(var/obj/O in T.contents)
			if(!O.Adjacent(controller.pawn))
				continue
			if(ismecha(O) || ismachinery(O) || isstructure(O))
				if(O.resistance_flags & INDESTRUCTIBLE)
					continue
				if(!O.density)
					continue
				if(O.IsObscured())
					continue
				attack(controller, O, delta_time)
				return

/datum/ai_behavior/insane_equip
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/insane_equip/finish_action(datum/ai_controller/controller, success)
	. = ..()

	if(!success) //Don't try again on this item if we failed
		var/list/item_blacklist = controller.blackboard[BB_INSANE_BLACKLISTITEMS]
		var/obj/item/target = controller.blackboard[BB_INSANE_PICKUPTARGET]

		item_blacklist[target] = TRUE

	controller.blackboard[BB_INSANE_PICKUPTARGET] = null

/datum/ai_behavior/insane_equip/proc/equip_item(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn

	var/obj/item/target = controller.blackboard[BB_INSANE_PICKUPTARGET]

	if(!isturf(living_pawn.loc))
		finish_action(controller, TRUE)
		return

	if(!target)
		finish_action(controller, TRUE)
		return

	if(target.anchored) //Can't pick it up, so stop trying.
		finish_action(controller, FALSE)
		return

	// If we can't move towards the item
	if(!get_path_to(living_pawn, get_turf(target), TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs)) && living_pawn.loc != target.loc && target.loc != living_pawn && !(target.loc in living_pawn.contents))
		finish_action(controller, TRUE)
		return

	if(isturf(target.loc) || (target in living_pawn.contents) || (target.loc in living_pawn.contents))
		var/obj/item/left_item = living_pawn.get_item_for_held_index(LEFT_HANDS)
		var/obj/item/right_item = living_pawn.get_item_for_held_index(RIGHT_HANDS)
		if(target.datum_components && (locate(/datum/component/two_handed) in target.datum_components))
			for(var/obj/item/I in living_pawn.held_items)
				if(!I.equip_to_best_slot(living_pawn, FALSE))
					living_pawn.dropItemToGround(I, force = TRUE)
		else if((left_item != null) && (right_item != null))
			var/obj/item/I = right_item
			if(GetEffectiveItemForce(left_item) < GetEffectiveItemForce(right_item)) // Drop the old one, man...
				I = left_item
			if(!I.equip_to_best_slot(living_pawn, FALSE))
				living_pawn.dropItemToGround(I, force = TRUE)

		living_pawn.put_in_hands(target)
		controller.blackboard[BB_INSANE_BEST_FORCE_FOUND] = GetEffectiveItemForce(target)
		finish_action(controller, TRUE)
		return
	finish_action(controller, TRUE)

/datum/ai_behavior/insane_equip/inventory/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	equip_item(controller)

/datum/ai_behavior/insane_equip/inventory/equip_item(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/obj/item/target = controller.blackboard[BB_INSANE_PICKUPTARGET]

	if(!living_pawn.temporarilyRemoveItemFromInventory(target))
		finish_action(controller, FALSE)
		return

	return ..()

/datum/ai_behavior/insane_equip/ground
	required_distance = 1

/datum/ai_behavior/insane_equip/ground/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	equip_item(controller)

/datum/ai_behavior/insanity_wander
	var/movement_mod = 0.002
	/*
	* Unique data can NOT be stored here.
	* These behaviors are non-individual and are shared between all people with this behavior.
	* Meaning if two people have "insanity_wander" and it stores its path in it, then they will both attempt to walk that same path.
	* Appropriate data to store here are stuff such as behavior tags, like `behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT`
	*/

/datum/ai_behavior/insanity_wander/perform(delta_time, datum/ai_controller/insane/controller)
	. = ..()

	var/mob/living/living_pawn = controller.pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	var/turf/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(living_pawn.Adjacent(target))
		controller.pathing_attempts = 0
		controller.current_path.Cut()
		finish_action(controller, FALSE)
		return
	if(!LAZYLEN(controller.current_path))
		controller.current_path = get_path_to(living_pawn, target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 120)
		if(!LAZYLEN(controller.current_path)) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
		controller.current_path.Remove(controller.current_path[1])
		MoveInPath(controller)
		return
	if(!controller.timerid)
		MoveInPath(controller)
		return

/datum/ai_behavior/insanity_wander/proc/MoveInPath(datum/ai_controller/insane/controller)
	controller.timerid = null
	var/mob/living/living_pawn = controller.pawn
	if(!living_pawn || IS_DEAD_OR_INCAP(living_pawn))
		controller.pathing_attempts = 0
		controller.current_path = list() // Reset the path and stop
		finish_action(controller, TRUE)
		return FALSE
	if(!PreMoveCheck(controller, living_pawn))
		if(!QDELETED(controller))
			controller.pathing_attempts = 0
			controller.current_path.Cut()
			finish_action(controller, TRUE)
		return FALSE
	// Movement
	if(LAZYLEN(controller.current_path))
		var/target_turf = controller.current_path[1]
		if(target_turf && get_dist(living_pawn, target_turf) < 2)
			if(!step_towards(living_pawn, target_turf)) //If it fails to move
				controller.pathing_attempts++
				if(controller.pathing_attempts >= MAX_PATHING_ATTEMPTS)
					controller.pathing_attempts = 0
					controller.current_path = list()
					finish_action(controller, TRUE)
					return FALSE
			else // Don't reset the attempts and remove the next if they didn't move there.
				if(get_turf(living_pawn) == target_turf)
					controller.current_path.Remove(target_turf)
					controller.pathing_attempts = 0
				else
					controller.pathing_attempts++
			var/move_delay = max(0.8, 0.2 + living_pawn.cached_multiplicative_slowdown - (get_modified_attribute_level(living_pawn, JUSTICE_ATTRIBUTE) * movement_mod))
			controller.timerid = addtimer(CALLBACK(src, PROC_REF(MoveInPath), controller), move_delay)
			return TRUE
	controller.pathing_attempts = 0
	controller.current_path = list() // Reset the path and stop
	finish_action(controller, TRUE)
	return FALSE

/datum/ai_behavior/insanity_wander/proc/PreMoveCheck(datum/ai_controller/insane/controller, mob/living/living_pawn)
	if(!controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET])
		return FALSE
	return TRUE

/datum/ai_behavior/insanity_wander/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.blackboard[BB_INSANE_BLACKLISTITEMS][BB_INSANE_CURRENT_ATTACK_TARGET] = world.time + 10 SECONDS
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

/datum/ai_behavior/insanity_wander/suicide_wander
	movement_mod = 0.004
	// Same as the above insanity, however it assumers wander controller and that the user will eventually attempt to off themselves

/datum/ai_behavior/insanity_wander/suicide_wander/PreMoveCheck(datum/ai_controller/insane/wander/controller, mob/living/living_pawn)
	. = ..()
	if(!.)
		return
	// Insanity lines
	if(world.time > controller.last_message + 4 SECONDS)
		controller.last_message = world.time
		controller.current_behaviors += GET_AI_BEHAVIOR(controller.lines_type)
	// Suicide replacement
	if(world.time > controller.suicide_enter)
		if(prob(10))
			living_pawn.visible_message("<span class='danger'>[living_pawn] freezes with an expression of despair on their face!</span>")
			QDEL_NULL(living_pawn.ai_controller)
			living_pawn.ai_controller = /datum/ai_controller/insane/suicide
			living_pawn.InitializeAIController()
			return FALSE
		controller.suicide_enter = world.time + 30 SECONDS

/datum/ai_behavior/insanity_wander/murder_wander
	movement_mod = 0.001
	// Same as the above insanity, but they look for a target between moves.

/datum/ai_behavior/insanity_wander/murder_wander/PreMoveCheck(datum/ai_controller/insane/murder/controller, mob/living/living_pawn)
	if(controller.FindEnemies())
		return FALSE
	return ..()

/datum/ai_behavior/insanity_smash_console
	/*
	* Unique data can NOT be stored here.
	* These behaviors are non-individual and are shared between all people with this behavior.
	* Meaning if two people have "insanity_wander" and it stores it's path in it, then they will both attempt to walk that same path.
	* Appropriate data to store here are stuff such as behavior tags, like `behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT`
	*/

/datum/ai_behavior/insanity_smash_console/perform(delta_time, datum/ai_controller/insane/controller)
	. = ..()

	var/mob/living/living_pawn = controller.pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	var/obj/machinery/computer/abnormality/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!LAZYLEN(controller.current_path) && !living_pawn.Adjacent(target))
		controller.current_path = get_path_to(living_pawn, get_step(target, SOUTH), TYPE_PROC_REF(/turf, Distance_cardinal), 0, 50)
		if(!LAZYLEN(controller.current_path)) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
		controller.current_path.Remove(controller.current_path[1]) // Remove the first tile as it tends to be directly under the pawn, meaning they can't move.
		MoveInPath(living_pawn)

	if(!istype(target) || !istype(target.datum_reference))
		finish_action(controller, FALSE)
		return
	if(world.time > controller.next_smash && living_pawn.Adjacent(target) && isturf(target.loc))
		living_pawn.visible_message("<span class='danger'>[living_pawn] smashes the panel on \the [target]!</span>")
		playsound(living_pawn.loc, 'sound/effects/hit_on_shattered_glass.ogg', 75, TRUE, -1)
		controller.next_smash = world.time + (10 - (get_user_level(living_pawn) * 0.75)) SECONDS
		controller.current_behaviors += GET_AI_BEHAVIOR(controller.lines_type)
		if(prob(60 - (get_user_level(living_pawn) * 10))) // Low level agents won't reduce qliphoth so often
			return
		if(target.datum_reference.qliphoth_meter == 1)
			target.datum_reference.qliphoth_change(-1)
			finish_action(controller, TRUE)
			return
		target.datum_reference.qliphoth_change(-1)

/datum/ai_behavior/insanity_smash_console/finish_action(datum/ai_controller/insane/controller, succeeded)
	. = ..()
	var/obj/machinery/computer/abnormality/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	controller.blackboard[BB_INSANE_BLACKLISTITEMS][target] = world.time + 60 SECONDS
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
	if(succeeded)
		var/turf/T = get_closest_atom(/turf/open, GLOB.xeno_spawn, controller.pawn)
		if(T)
			controller.current_path = get_path_to(controller.pawn, T, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 50)
			if(!LAZYLEN(controller.current_path))
				finish_action(controller, FALSE)
				return
			controller.current_path.Remove(controller.current_path[1]) // Remove the first tile as it tends to be directly under the pawn, meaning they can't move.
			MoveInPath(controller.pawn)

/datum/ai_behavior/insanity_smash_console/proc/MoveInPath(mob/living/living_pawn)
	var/datum/ai_controller/insane/release/controller = living_pawn.ai_controller
	if(LAZYLEN(controller.current_path) && !IS_DEAD_OR_INCAP(living_pawn))
		var/target_turf = controller.current_path[1]
		if(target_turf && get_dist(living_pawn, target_turf) < 3)
			for(var/mob/living/carbon/human/H in orange(1, living_pawn))
				if(!H.sanity_lost)
					continue
				if(H.stat == DEAD || H.stat == HARD_CRIT)
					continue
				if(!HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/release))
					continue
				var/datum/ai_controller/insane/release/R = H.ai_controller
				if(!R)
					continue
				if(isnull(R.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]))
					continue
				if(R.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] == living_pawn.ai_controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]) // Are we both going after the same console?
					if(prob(50)) // Chance to give up so they may not always both give up, just like Cleanbots do.
						controller.pathing_attempts = 0
						controller.current_path = list()
						finish_action(living_pawn.ai_controller, FALSE)
						return FALSE
			if(!step_towards(living_pawn, target_turf)) //If it fails to move
				controller.pathing_attempts++
				if(controller.pathing_attempts >= MAX_PATHING_ATTEMPTS)
					controller.pathing_attempts = 0
					controller.current_path = list()
					finish_action(living_pawn.ai_controller, FALSE)
					return FALSE
			else // Don't reset the attempts and remove the next if they didn't move there.
				if(get_turf(living_pawn) == target_turf)
					controller.current_path.Remove(target_turf)
					controller.pathing_attempts = 0
				else
					controller.pathing_attempts++
			var/move_delay = max(0.8, 0.2 + living_pawn.cached_multiplicative_slowdown - (get_modified_attribute_level(living_pawn, JUSTICE_ATTRIBUTE) * 0.002))
			addtimer(CALLBACK(src, PROC_REF(MoveInPath), living_pawn), move_delay)
			return TRUE
	controller.pathing_attempts = 0
	controller.current_path = list() // Reset the path and stop
	return FALSE
