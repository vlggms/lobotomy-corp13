/*
	Adjacency proc for determining touch range

	This is mostly to determine if a user can enter a square for the purposes of touching something.
	Examples include reaching a square diagonally or reaching something on the other side of a glass window.

	This is calculated by looking for border items, or in the case of clicking diagonally from yourself, dense items.
	This proc will NOT notice if you are trying to attack a window on the other side of a dense object in its turf.  There is a window helper for that.

	Note that in all cases the neighbor is handled simply; this is usually the user's mob, in which case it is up to you
	to check that the mob is not inside of something
*/
/atom/proc/Adjacent(atom/neighbor) // basic inheritance, unused
	return

// Not a sane use of the function and (for now) indicative of an error elsewhere
/area/Adjacent(atom/neighbor)
	CRASH("Call to /area/Adjacent(), unimplemented proc")


/*
	Adjacency (to turf):
	* If you are in the same turf, always true
	* If you are vertically/horizontally adjacent, ensure there are no border objects
	* If you are diagonally adjacent, ensure you can pass through at least one of the mutually adjacent square.
		* Passing through in this case ignores anything with the LETPASSTHROW pass flag, such as tables, racks, and morgue trays.
*/
/turf/Adjacent(atom/neighbor, atom/target = null, atom/movable/mover = null)
	var/turf/T0 = get_turf(neighbor)

	if(T0 == src) //same turf
		return TRUE

	if(get_dist(src, T0) > 1 || z != T0.z) //too far
		return FALSE

	// Non diagonal case
	if(T0.x == x || T0.y == y)
		// Check for border blockages
		return T0.ClickCross(get_dir(T0,src), border_only = 1, target_atom = target, mover = mover) && src.ClickCross(get_dir(src,T0), border_only = 1, target_atom = target, mover = mover)

	// Diagonal case
	var/in_dir = get_dir(T0,src) // eg. northwest (1+8) = 9 (00001001)
	var/d1 = in_dir&3		     // eg. north	  (1+8)&3 (0000 0011) = 1 (0000 0001)
	var/d2 = in_dir&12			 // eg. west	  (1+8)&12 (0000 1100) = 8 (0000 1000)

	for(var/d in list(d1,d2))
		if(!T0.ClickCross(d, border_only = 1, target_atom = target, mover = mover))
			continue // could not leave T0 in that direction

		var/turf/T1 = get_step(T0,d)
		if(!T1 || T1.density)
			continue
		if(!T1.ClickCross(get_dir(T1,src), border_only = 0, target_atom = target, mover = mover) || !T1.ClickCross(get_dir(T1,T0), border_only = 0, target_atom = target, mover = mover))
			continue // couldn't enter or couldn't leave T1

		if(!src.ClickCross(get_dir(src,T1), border_only = 1, target_atom = target, mover = mover))
			continue // could not enter src

		return TRUE // we don't care about our own density

	return FALSE

#define Y_MAX(THE_MOB) (THE_MOB.y + THE_MOB.occupied_tiles_up_current)
#define Y_MIN(THE_MOB) (THE_MOB.y - THE_MOB.occupied_tiles_down_current)
#define X_MAX(THE_MOB) (THE_MOB.x + THE_MOB.occupied_tiles_right_current)
#define X_MIN(THE_MOB) (THE_MOB.x - THE_MOB.occupied_tiles_left_current)
/*
	Adjacency (to anything else):
	* Must be on a turf
*/
/atom/movable/Adjacent(atom/neighbor)
	if(neighbor == loc)
		return TRUE
	var/turf/T = loc
	if(!istype(T))
		return FALSE
	if(isanimal(neighbor))
		var/mob/living/simple_animal/SA = neighbor
		var/turf/T_neighbor = locate(clamp(x, X_MIN(SA), X_MAX(SA)), clamp(y, Y_MIN(SA), Y_MAX(SA)), z)
		if(T.Adjacent(T_neighbor, target = T_neighbor, mover = src))
			return TRUE
		return FALSE
	if(T.Adjacent(neighbor, target = neighbor, mover = src))
		return TRUE
	return FALSE

/mob/living/simple_animal/Adjacent(atom/neighbor)
	if(neighbor == loc)
		return TRUE
	var/turf/T = loc
	if(!istype(T))
		return FALSE
	if(isanimal(neighbor))
		var/mob/living/simple_animal/SA = neighbor
		var/found_x
		var/found_y
		if(Y_MAX(SA) > Y_MAX(src))
			found_y = Y_MAX(src)
		else if(Y_MIN(SA) < Y_MIN(src))
			found_y = Y_MIN(src)
		else
			found_y = SA.y
		if(X_MAX(SA) > X_MAX(src))
			found_x = X_MAX(src)
		else if(X_MIN(SA) < X_MIN(src))
			found_x = X_MIN(src)
		else
			found_x = SA.x
		var/turf/T_my = locate(found_x, found_y, z)
		var/turf/T_neighbor = locate(clamp(T_my.x, X_MIN(SA), X_MAX(SA)), clamp(T_my.y, Y_MIN(SA), Y_MAX(SA)), SA.z)
		if(T_my.Adjacent(T_neighbor, target = T_neighbor, mover = src))
			return TRUE
		return FALSE
	T = locate(clamp(neighbor.x, X_MIN(src), X_MAX(src)), clamp(neighbor.y, Y_MIN(src), Y_MAX(src)), z)
	if(T.Adjacent(neighbor, target = neighbor, mover = src))
		return TRUE
	return FALSE

#undef Y_MAX
#undef Y_MIN
#undef X_MAX
#undef X_MIN

// This is necessary for storage items not on your person.
/obj/item/Adjacent(atom/neighbor, recurse = 1)
	if(neighbor == loc)
		return TRUE
	if(isitem(loc))
		if(recurse > 0)
			return loc.Adjacent(neighbor,recurse - 1)
		return FALSE
	return ..()

/*
	This checks if you there is uninterrupted airspace between that turf and this one.
	This is defined as any dense ON_BORDER_1 object, or any dense object without LETPASSTHROW.
	The border_only flag allows you to not objects (for source and destination squares)
*/
/turf/proc/ClickCross(target_dir, border_only, target_atom = null, atom/movable/mover = null)
	for(var/obj/O in src)
		if((mover && O.CanPass(mover,get_step(src,target_dir))) || (!mover && !O.density))
			continue
		if(O == target_atom || O == mover || (O.pass_flags_self & LETPASSTHROW)) //check if there's a dense object present on the turf
			continue // LETPASSTHROW is used for anything you can click through (or the firedoor special case, see above)

		if( O.flags_1&ON_BORDER_1) // windows are on border, check them first
			if( O.dir & target_dir || O.dir & (O.dir-1) ) // full tile windows are just diagonals mechanically
				return FALSE								  //O.dir&(O.dir-1) is false for any cardinal direction, but true for diagonal ones
		else if( !border_only ) // dense, not on border, cannot pass over
			return FALSE
	return TRUE
