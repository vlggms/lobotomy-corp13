/datum/component/return_to_origin
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/simple_animal/hostile/parent_hostile
	var/turf/origin
	var/original_dir = 1


/datum/component/return_to_origin/Initialize()
	if(!ishostile(parent))
		return COMPONENT_INCOMPATIBLE

	parent_hostile = parent
	original_dir = parent_hostile.dir
	origin = get_turf(parent_hostile)
	RegisterSignal(parent, COMSIG_HOSTILE_LOSTTARGET, PROC_REF(ParentLostTarget))
	addtimer(CALLBACK(src, PROC_REF(ParentLostTarget)), 50)

/datum/component/return_to_origin/proc/ParentLostTarget()
	// patrol back
	if (!parent_hostile.target)
		if (get_turf(parent_hostile) != origin)
			parent_hostile.patrol_to(origin)
		else
			parent_hostile.dir = original_dir
	addtimer(CALLBACK(src, PROC_REF(ParentLostTarget)), 50)
