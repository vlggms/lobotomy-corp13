/mob/living/simple_animal/hostile/abnormality/Move(turf/newloc, dir, step_x, step_y)
	. = ..()
	if(!isopenturf(newloc) || target)
		return

	var/turf/open/our_floor = newloc
	if(our_floor.possible_hiding_players.len < 1)
		return

	if(prob(our_floor.noise))
		var/possible_target = pick(our_floor.possible_hiding_players)
		if(get_dist(src, possible_target) > 10)
			for(var/turf/open/turf in range(10, src))
				turf.possible_hiding_players -= possible_target

			CRASH("[possible_target] was in a floor's \"possible_hiding_players\" list whilst being out of range!")

		GiveTarget(possible_target)
		FindHidden()
