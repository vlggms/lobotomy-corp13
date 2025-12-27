/mob/living/Moved()
	. = ..()
	update_turf_movespeed(loc)


/mob/living/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return
	if(mover.throwing)
		return (!density || (body_position == LYING_DOWN) || (mover.throwing.thrower == src && !ismob(mover)))
	if(buckled == mover)
		return TRUE
	if(ismob(mover) && (mover in buckled_mobs))
		return TRUE
	return !mover.density || body_position == LYING_DOWN

/mob/living/toggle_move_intent()
	. = ..()
	update_move_intent_slowdown()

/mob/living/update_config_movespeed()
	update_move_intent_slowdown()
	return ..()

/mob/living/proc/update_move_intent_slowdown()
	add_movespeed_modifier((m_intent == MOVE_INTENT_WALK)? /datum/movespeed_modifier/config_walk_run/walk : /datum/movespeed_modifier/config_walk_run/run)

/mob/living/proc/update_turf_movespeed(turf/open/T)
	if(isopenturf(T))
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/turf_slowdown, multiplicative_slowdown = T.slowdown)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/turf_slowdown)


/mob/living/proc/update_pull_movespeed()
	if(pulling)
		if(isliving(pulling))
			var/mob/living/L = pulling
			if(!slowed_by_drag || L.body_position == STANDING_UP || L.buckled || grab_state >= GRAB_AGGRESSIVE)
				remove_movespeed_modifier(/datum/movespeed_modifier/bulky_drag)
				return
			add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/bulky_drag, multiplicative_slowdown = PULL_PRONE_SLOWDOWN)
			return
		if(isobj(pulling))
			var/obj/structure/S = pulling
			if(!slowed_by_drag || !S.drag_slowdown)
				remove_movespeed_modifier(/datum/movespeed_modifier/bulky_drag)
				return
			add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/bulky_drag, multiplicative_slowdown = S.drag_slowdown)
			return
	remove_movespeed_modifier(/datum/movespeed_modifier/bulky_drag)

/// Signal handler called when first entering an area, default behaviour logs the presence of the mob in the area inside its mob_list.
/mob/living/proc/on_entered_area(mob/living/self, area/entered_area)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	if(!(area_index & FROZEN_INDEX))
		LAZYALISTADDLIST((entered_area.area_living), area_index, self)
		return

/// Signal handler called when first exiting an area, default behaviour removes the presence of the mob from the area's mob_list.
/mob/living/proc/on_exited_area(mob/living/self, area/exited_area)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	if(!(area_index & FROZEN_INDEX))
		LAZYREMOVEASSOC((exited_area.area_living), area_index, self)
		return

/// Called when a mob dies or gets destroyed to delete it from the list of living mobs in the area they are in and prevent them from being present in any other moblists while dead.
/mob/living/proc/cleanup_area_presence()
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/area/our_area = get_area(src)
	if(isarea(our_area) && !(area_index & FROZEN_INDEX))
		area_index |= FROZEN_INDEX // First we freeze the index, immediately (Lets hope this avoids bugs coming from race conditions with the signal handlers).
		UnregisterSignal(src, list(COMSIG_ENTER_AREA, COMSIG_EXIT_AREA)) // We unregister all signals.
		LAZYREMOVEASSOC((our_area.area_living), (area_index ^ FROZEN_INDEX), src) // We clean what we gotta clean.

/// Called when a mob status changes from DEAD to anything else, restoring its present and future presence in the areas moblists.
/mob/living/proc/restore_area_presence()
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/area/our_area = get_area(src)
	if(isarea(our_area) && (area_index & FROZEN_INDEX))
		area_index ^= FROZEN_INDEX // We unfreeze the index.
		RegisterSignal(src, COMSIG_ENTER_AREA, PROC_REF(on_entered_area)) // We register our sweet signals.
		RegisterSignal(src, COMSIG_EXIT_AREA, PROC_REF(on_exited_area))
		LAZYALISTADDLIST((our_area.area_living), area_index, src) // And we make our presence known once again.

/// Use this to change a mob's area index without messing up the area lists. Send the new area_index as the argument.
/mob/living/proc/swap_area_index(new_index)
	if(!new_index)
		return
	cleanup_area_presence()
	area_index = new_index | FROZEN_INDEX
	restore_area_presence()

/mob/living/canZMove(dir, turf/target)
	return can_zTravel(target, dir) && (movement_type & FLYING | FLOATING)

/mob/living/keybind_face_direction(direction)
	if(stat > SOFT_CRIT)
		return
	return ..()
