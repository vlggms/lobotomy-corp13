/mob/payload
	name = "Payload"
	desc = "It's a payload"
	icon = 'icons/obj/machines/nuke.dmi'
	icon_state = "nuclearbomb_base"
	density = TRUE
	move_force = INFINITY
	move_resist = INFINITY
	status_flags = GODMODE
	see_in_dark = 7
	move_on_shuttle = FALSE
	a_intent = "harm"
	light_range = 5
	faction = list("neutral", "hostile")
	var/list/path
	var/list/pusher_factions
	var/team
	var/turf/target
	var/current_index = 1
	var/base_delay_amount = 14
	var/minimum_delay_amount = 6
	var/delay_reduction = 3
	var/last_friendly_interaction = 0
	var/time_to_start_moving_back = 15 SECONDS

	var/datum/reusable_visual_pool/RVP = new(20)
	var/telegraph_cooldown = 0
	var/telegraph_cooldown_time = 7 SECONDS

	var/pathing_attempts = 0
	var/max_pathing_attempts = 30

	var/ready_to_move = FALSE
	var/prepare_message_time = 0
	var/prepare_message_cooldown = 25 SECONDS

	var/start_delay = 0

/mob/payload/New(loc, team)
	. = ..()
	src.team = team
	GLOB.rcorp_payload = src
	switch(team)
		if("rcorp")
			pusher_factions = list("neutral")
		if("abno")
			pusher_factions = list("hostile")
			icon = 'ModularTegustation/Teguicons/64x64.dmi'
			icon_state = "armyinblack"
			pixel_x = -16
			base_pixel_x = -16

			//Moves at 1/3rd speed to give R-Corp a fighting chance; Abnos can play significantly more agressively
			base_delay_amount = 28
			minimum_delay_amount = 12

/mob/payload/proc/GetPath()
	if(!target)
		switch(team)
			if("rcorp")
				target = GLOB.rcorp_objective_location
			if("abno")
				target = GLOB.rcorp_abno_objective_location
	if(!target)
		CRASH("There is no destination landmark on the map")
	path = get_path_to(loc, target, TYPE_PROC_REF(/turf, PayloadTurfMoveCost), 0, 0, adjacent = TYPE_PROC_REF(/turf, PayloadTurfTest))
	if(!path || !path.len)
		++pathing_attempts
		if(pathing_attempts > max_pathing_attempts)
			CRASH("payload failed to find a path")
		GetPath()
		return
	start_delay += world.time
	MoveLoop()

/mob/payload/proc/MoveLoop()
	if(world.time > telegraph_cooldown)
		telegraph_cooldown = world.time + telegraph_cooldown_time
		INVOKE_ASYNC(src, PROC_REF(PathTelegraphLoop))
	var/delay_amount = base_delay_amount
	if(ready_to_move)
		var/is_moving_forward = FALSE
		var/is_blocked_by_enemy = FALSE
		for(var/mob/living/L in ohearers(2, src))
			if(L.stat == DEAD)
				continue
			if(faction_check(L.faction, pusher_factions))
				delay_amount -= delay_reduction
				is_moving_forward = TRUE
			else
				is_blocked_by_enemy = TRUE
		if(is_moving_forward)
			last_friendly_interaction = world.time
		delay_amount = max(delay_amount, minimum_delay_amount)
		if(is_moving_forward && !is_blocked_by_enemy && current_index < path.len)
			//var/obj/machinery/door/poddoor/P = path.len - current_index > 3 ? locate(/obj/machinery/door/poddoor) in path[current_index + 4] : null
			if(/*(!P || P && !P.density) && */Move(path[current_index + 1], get_dir(src, path[current_index + 1]), DELAY_TO_GLIDE_SIZE(delay_amount)))
				++current_index
				if(loc != path[current_index])
					loc = path[current_index]
					stack_trace("payload got moved incorrectly")
		else if(!is_moving_forward && world.time - last_friendly_interaction > time_to_start_moving_back && current_index > 1)
			if(Move(path[current_index - 1], get_dir(path[current_index - 1], src), DELAY_TO_GLIDE_SIZE(delay_amount)))
				--current_index
				if(loc != path[current_index])
					loc = path[current_index]
					stack_trace("payload got moved incorrectly")
		if(current_index == path.len)
			DeliverPayload()
			return
	else if(prepare_message_time < world.time)
		prepare_message_time = world.time + prepare_message_cooldown
		var/time = round((start_delay - world.time) / 600, 0.5)
		visible_message("preparing to move in [time] minutes...", visible_message_flags = EMOTE_MESSAGE)
	addtimer(CALLBACK(src, PROC_REF(MoveLoop)), delay_amount)

/mob/payload/Move(atom/newloc, direct, glide_size_override)
	if(!isturf(newloc))
		return
	var/turf/T = newloc
	for(var/obj/structure/barricade/B in T)
		qdel(B)
		playsound(get_turf(src), 'sound/effects/break_stone.ogg', 100, TRUE, 3)
	for(var/obj/machinery/door/airlock/A in T)
		qdel(A)
	return ..()

/mob/payload/proc/DeliverPayload()
	var/win_text
	switch(team)
		if("rcorp")
			win_text = "R-CORP MAJOR VICTORY."
			new /obj/effect/temp_visual/explosion(get_turf(src))
		if("abno")
			win_text = "Abnormality Major Victory."
			playsound(get_turf(src), 'sound/abnormalities/armyinblack/black_explosion.ogg', 125, 0, 8)
			new /obj/effect/temp_visual/black_explosion(get_turf(src))
	explosion(get_turf(src), 13, 14, 15, flash_range = 0, smoke = FALSE)
	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("THE PAYLOAD HAS REACHED ITS DESTINATION."))
		to_chat(M, span_userdanger(win_text))
	SSticker.force_ending = 1
	qdel(src)

/mob/payload/proc/PathTelegraphLoop()
	for(var/i in (current_index + 1) to path.len)
		RVP.NewSparkles(path[i], 3, "#e7f712")
		sleep(1)

/turf/proc/PayloadTurfMoveCost(turf/T)
	if(!T)
		return FALSE
	var/extra_cost = 0
	for(var/turf/TT in RANGE_TURFS(2, T))
		if(TT.density && abs(TT.x - T.x) + abs(TT.y - T.y) <= 2)
			++extra_cost
	return abs(x - T.x) + abs(y - T.y) + extra_cost

/turf/proc/PayloadTurfTest(caller, turf/T, ID)
	if(!T || T.density)
		return FALSE
	var/adir = get_dir(src, T)
	var/rdir = ((adir & MASK_ODD)<<1)|((adir & MASK_EVEN)>>1)
	for(var/obj/structure/window/W in src)
		if(!W.CanAStarPass(ID, adir))
			return FALSE
	for(var/obj/structure/railing/R in src)
		if(!R.CanAStarPass(ID, adir, caller))
			return FALSE
	for(var/obj/machinery/door/D in T)
		return TRUE
	for(var/obj/structure/barricade/B in T)
		return TRUE
	for(var/obj/O in T)
		if(!O.CanAStarPass(ID, rdir, caller))
			return FALSE
	return TRUE

/mob/payload/Moved()
	. = ..()
	for(var/turf/T in RANGE_TURFS(2, src))
		if(T.density && !istype(T, /turf/open/chasm))
			T.ChangeTurf(/turf/open/floor/plating/asteroid)
			playsound(get_turf(src), 'sound/effects/break_stone.ogg', 100, TRUE, 3)
		//will have to delete em if no automatic shutters
		for(var/obj/machinery/door/poddoor/P in T)
			qdel(P)
			playsound(get_turf(src), 'sound/effects/break_stone.ogg', 100, TRUE, 3)

/mob/payload/forceMove()
	return

/mob/payload/throw_at(atom/target, range, speed, mob/thrower, spin, diagonals_first, datum/callback/callback, force, gentle, quickstart)
	return FALSE
