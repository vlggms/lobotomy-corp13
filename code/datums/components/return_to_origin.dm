/datum/component/return_to_origin
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/simple_animal/hostile/parent_hostile
	var/turf/origin


/datum/component/return_to_origin/Initialize()
	if(!ishostile(parent))
		return COMPONENT_INCOMPATIBLE

	parent_hostile = parent
	origin = get_turf(parent_hostile)
	RegisterSignal(parent, COMSIG_HOSTILE_LOSTTARGET, PROC_REF(ParentLostTarget))

/datum/component/return_to_origin/proc/ParentLostTarget()
	// patrol back
	if (get_turf(parent_hostile) != origin)
		parent_hostile.patrol_to(origin)
