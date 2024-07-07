/// When placed it will try to recover an abnormality cell thats completelly broken
/// MUST be placed on top of an abnormality, with a computer present and an abnormality landmark present
/obj/effect/abnormality_helper
	name = "Abnormality link helper"
	var/mob/living/simple_animal/hostile/abnormality/stored_abnormality = null
	var/stored_boxes = 0
	var/understanding = 0
	var/observation_ready = FALSE

/obj/effect/abnormality_helper/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/abnormality_helper/LateInitialize()
	. = ..()
	var/mob/living/simple_animal/hostile/abnormality/desired_abnormality = stored_abnormality
	if(isnull(desired_abnormality))
		desired_abnormality = locate(/mob/living/simple_animal/hostile/abnormality) in get_turf(src)

	if(!desired_abnormality)
		message_admins("[src] MAJOR FAILURE: has failed to find an abnormality for linking!")
		return

	var/datum/abnormality/datum_reference = link_landmark(desired_abnormality)
	if(!datum_reference)
		message_admins("[src] MAJOR FAILURE: has failed to find an abnormality landmark for linking!")
		return

	var/obj/machinery/computer/abnormality/computer = link_computer(datum_reference, desired_abnormality)
	if(!computer)
		message_admins("[src] MINOR FAILURE: has failed to find an abnormality computer for linking!")
		message_admins("[src]: attempting to find valid computer...")

		find_direction()
		computer = link_computer(datum_reference)
		if(!computer)
			message_admins("[src] MAJOR FAILURE: has failed to find an abnormality computer despite resetting its direction!")
			return


	if(!link_panel(computer))
		message_admins("[src] MINOR FAILURE: has failed to find an abnormality panel for linking!")
		return

	SSlobotomy_corp.NewAbnormality(datum_reference)
	qdel(src)

/// If admins previously had rotated a cell, things are all wack and we need to re-configure our direction
/obj/effect/abnormality_helper/proc/find_direction()
	var/list/directions = list(NORTH, SOUTH, EAST, WEST)
	for(var/i in 1 to length(directions))
		var/turf/target_turf = get_turf(src)
		var/possible_direction = pick_n_take(directions)
		for(var/I in 1 to 2)
			target_turf = get_step(target_turf, turn(possible_direction, 180))
			target_turf = get_step(target_turf, turn(possible_direction, 270))

		if(locate(/obj/machinery/containment_panel) in target_turf)
			dir = possible_direction
			break

/obj/effect/abnormality_helper/proc/link_landmark(mob/desired_abnormality)
	var/obj/effect/landmark/abnormality_spawn/landmark = locate(/obj/effect/landmark/abnormality_spawn) in get_turf(src)
	if(!landmark)
		return FALSE

	var/datum/abnormality/datum_reference = new /datum/abnormality(landmark, desired_abnormality.type)
	landmark.datum_reference = datum_reference

	datum_reference.stored_boxes = stored_boxes
	datum_reference.understanding = understanding

	return datum_reference

/obj/effect/abnormality_helper/proc/link_computer(datum/abnormality/datum_reference, mob/desired_abnormality)
	var/turf/target_turf = get_turf(src)

	target_turf = get_step(target_turf, desired_abnormality == /mob/living/simple_animal/hostile/abnormality/training_rabbit ? turn(dir, 180) : dir)
	for(var/i in 1 to 3)
		target_turf = get_step(target_turf, turn(dir, 270))

	var/obj/machinery/computer/abnormality/computer = locate(/obj/machinery/computer/abnormality) in target_turf
	if(computer)
		computer.datum_reference = datum_reference
		computer.datum_reference.console = computer
		return computer

	return FALSE

/obj/effect/abnormality_helper/proc/link_panel(var/obj/machinery/computer/abnormality/computer)
	var/turf/target_turf = get_turf(src)
	for(var/I in 1 to 2)
		target_turf = get_step(target_turf, turn(dir, 180))
		target_turf = get_step(target_turf, turn(dir, 270))

	var/obj/machinery/containment_panel/panel = locate(/obj/machinery/containment_panel) in target_turf
	if(panel)
		panel.linked_console = computer
		computer.LinkPanel(panel)
		panel.console_status(computer)
		panel.name = "\proper [computer.datum_reference.name]'s containment panel"
		return TRUE

	return FALSE
