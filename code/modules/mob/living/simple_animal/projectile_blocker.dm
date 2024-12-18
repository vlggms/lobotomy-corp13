/mob/living/simple_animal/projectile_blocker_dummy
	name = "projectile blocker dummy"
	desc = "lets projectiles impact multitile mobs"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "training_rabbit"
	status_flags = GODMODE
	invisibility = INVISIBILITY_ABSTRACT
	alpha = 0
	hud_possible = null
	hud_list = null
	a_intent = INTENT_HARM
	move_resist = 10000
	stop_automated_movement = TRUE
	wander = FALSE
	AIStatus = AI_OFF
	density = FALSE
	can_be_z_moved = FALSE
	mob_size = MOB_SIZE_HUGE
	var/mob/living/simple_animal/parent
	var/offset_x
	var/offset_y

/mob/living/simple_animal/projectile_blocker_dummy/New(loc, mob/living/simple_animal/parent)
	. = ..()
	src.parent = parent
	var/turf/T = loc
	if(!istype(T))
		stack_trace("Projectile blocker dummy owned by [parent] created with invalid loc")
		return
	offset_x = T.x - parent.x
	offset_y = T.y - parent.y
	if(parent.density || parent.status_flags & MUST_HIT_PROJECTILE)
		status_flags |= MUST_HIT_PROJECTILE
	pass_flags = parent.pass_flags
	pass_flags_self = parent.pass_flags_self
	faction = parent.faction
	blood_volume = parent.blood_volume
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(OnParentMoved))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(OnParentDeath))
	RegisterSignal(parent, COMSIG_LIVING_REVIVE, PROC_REF(OnParentRevive))

/mob/living/simple_animal/projectile_blocker_dummy/CanPass(atom/movable/mover, turf/target)
	..()
	if(mover.movement_type & PHASING)
		return TRUE
	if(mover == parent)
		return TRUE
	if(!isturf(parent.loc))
		return TRUE
	if(parent.CanPassThroughBlocker(mover, target, get_turf(src)))
		return TRUE
	return parent.CanPass(mover, target)

/mob/living/simple_animal/projectile_blocker_dummy/proc/OnParentMoved()
	SIGNAL_HANDLER
	var/turf/T
	if(parent.should_projectile_blockers_change_orientation)
		switch(parent.dir)
			if(SOUTH)
				T = locate(parent.x + offset_x, parent.y + offset_y, parent.z)
			if(NORTH)
				T = locate(parent.x - offset_x, parent.y - offset_y, parent.z)
			if(WEST)
				T = locate(parent.x + offset_y, parent.y - offset_x, parent.z)
			if(EAST)
				T = locate(parent.x - offset_y, parent.y + offset_x, parent.z)
	else
		T = locate(parent.x + offset_x, parent.y + offset_y, parent.z)
	doMove(T)

/mob/living/simple_animal/projectile_blocker_dummy/proc/OnParentDeath()
	SIGNAL_HANDLER
	status_flags &= ~MUST_HIT_PROJECTILE

/mob/living/simple_animal/projectile_blocker_dummy/proc/OnParentRevive()
	SIGNAL_HANDLER
	if(parent.density || parent.status_flags & MUST_HIT_PROJECTILE)
		status_flags |= MUST_HIT_PROJECTILE

/mob/living/simple_animal/projectile_blocker_dummy/Destroy()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_LIVING_DEATH)
	UnregisterSignal(parent, COMSIG_LIVING_REVIVE)
	parent = null
	return ..()

/mob/living/simple_animal/projectile_blocker_dummy/bullet_act(obj/projectile/P, def_zone, piercing_hit)
	if(!isturf(parent.loc))
		return
	if(P.firer == parent)
		return BULLET_ACT_FORCE_PIERCE
	return parent.bullet_act(P, def_zone, piercing_hit) //parent adds all the projectile blocker dummies into projectile's impacted list to avoid multi hitting

/mob/living/simple_animal/projectile_blocker_dummy/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	return parent.hitby(AM, skipcatch, hitpush, blocked, throwingdatum)

/mob/living/simple_animal/projectile_blocker_dummy/apply_status_effect(effect, ...)
	if(length(args) > 1)
		return parent.apply_status_effect(arglist(args.Copy()))
	return parent.apply_status_effect(effect)

/mob/living/simple_animal/projectile_blocker_dummy/med_hud_set_health()
	return

/mob/living/simple_animal/projectile_blocker_dummy/med_hud_set_status()
	return

/mob/living/simple_animal/projectile_blocker_dummy/death(gibbed)
	return FALSE

/mob/living/simple_animal/projectile_blocker_dummy/forceMove(atom/destination)
	return FALSE

/mob/living/simple_animal/projectile_blocker_dummy/gib(no_brain, no_organs, no_bodyparts)
	return FALSE

/mob/living/simple_animal/projectile_blocker_dummy/Move(atom/newloc, direct, glide_size_override)
	return FALSE

/mob/living/simple_animal/projectile_blocker_dummy/throw_at(atom/target, range, speed, mob/thrower, spin, diagonals_first, datum/callback/callback, force, gentle, quickstart)
	return FALSE

/mob/living/simple_animal/projectile_blocker_dummy/onTransitZ(old_z, new_z)
	. = ..()
	if(new_z > 0 && new_z != parent.z)
		moveToNullspace()

///For letting some mobs walk through the blockers
/mob/living/simple_animal/proc/CanPassThroughBlocker(atom/movable/mover, turf/start, turf/destination)
	return FALSE

/mob/living/simple_animal/hostile/CanPassThroughBlocker(atom/movable/mover, turf/start, turf/destination)
	if(isliving(mover) && faction_check_mob(mover))
		return TRUE
	if(isliving(mover) && get_dist_manhattan(get_turf(src), destination) > get_dist_manhattan(get_turf(src), start))
		return TRUE
	return FALSE
