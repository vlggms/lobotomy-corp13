/**
 * General proc used to expel a holder's contents through src (for bins holder is also the src).
 */
/obj/proc/pipe_eject(obj/holder, direction, throw_em = TRUE, turf/target, throw_range = 5, throw_speed = 1, area/source_area)
	var/turf/src_T = get_turf(src)
	for(var/A in holder)
		var/atom/movable/AM = A
		AM.forceMove(src_T)
		SEND_SIGNAL(AM, COMSIG_MOVABLE_PIPE_EJECTING, direction)
		if(throw_em && !QDELETED(AM))
			var/turf/T = target || get_offset_target_turf(loc, rand(5)-rand(5), rand(5)-rand(5))
			AM.throw_at(T, throw_range, throw_speed)
		if(istype(source_area))
			source_area.Exited(AM)
			var/area/new_area = get_area(src_T)
			new_area.Entered(AM)
