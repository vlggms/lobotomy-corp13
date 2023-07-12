/obj/effect/proc_holder/ability/aimed/vile_burst
	name = "Vile Burst"
	desc = "Unleash the energy of your weapon by dispersing it into the surrounding area."
	action_icon_state = "general_shadow0"
	action_background_icon_state = "bg_cult"
	base_icon_state = "general_shadow"
	base_action = /datum/action/spell_action/ability/item
	cooldown = 10 SECONDS
	var/obj/item/workshop_mod/vile/fuel_source
	var/cone_levels = 3
	///This value determines if the cone penetrates walls.
	var/respect_density = TRUE
	///Determines if we are currently casting
	var/casting = FALSE

/obj/effect/proc_holder/ability/aimed/vile_burst/Perform(target, mob/user)
	var/balance_stat = fuel_source.balance_stat
	switch(balance_stat)
		if("PARTIAL DARK")
			cone_levels = 3
			CastCorruption(target, user)
		if("HEAVY DARK")
			cone_levels = 5
			CastCorruption(target, user)
	return ..()

//Links ability to its fuel_souce value.
/obj/effect/proc_holder/ability/aimed/vile_burst/proc/linkItems(component)
	fuel_source = component

	/*Corruption Attack code stolen from cone_spells.dm
	This proc creates a list of turfs that are hit by the cone */
/obj/effect/proc_holder/ability/aimed/vile_burst/proc/ConeHelper(turf/starter_turf, dir_to_use, cone_levels = 3)
	var/list/turfs_to_return = list()
	var/turf/turf_to_use = starter_turf
	var/turf/left_turf
	var/turf/right_turf
	var/right_dir
	var/left_dir
	switch(dir_to_use)
		if(NORTH)
			left_dir = WEST
			right_dir = EAST
		if(SOUTH)
			left_dir = EAST
			right_dir = WEST
		if(EAST)
			left_dir = NORTH
			right_dir = SOUTH
		if(WEST)
			left_dir = SOUTH
			right_dir = NORTH

	for(var/i in 1 to cone_levels)
		var/list/level_turfs = list()
		turf_to_use = get_step(turf_to_use, dir_to_use)
		level_turfs += turf_to_use
		if(i != 1)
			left_turf = get_step(turf_to_use, left_dir)
			level_turfs += left_turf
			right_turf = get_step(turf_to_use, right_dir)
			level_turfs += right_turf
			for(var/left_i in 1 to i -CalculateConeShape(i))
				if(left_turf.density && respect_density)
					break
				left_turf = get_step(left_turf, left_dir)
				level_turfs += left_turf
			for(var/right_i in 1 to i -CalculateConeShape(i))
				if(right_turf.density && respect_density)
					break
				right_turf = get_step(right_turf, right_dir)
				level_turfs += right_turf
		turfs_to_return += list(level_turfs)
		if(i == cone_levels)
			continue
		if(turf_to_use.density && respect_density)
			break
	return turfs_to_return

/obj/effect/proc_holder/ability/aimed/vile_burst/proc/CastCorruption(list/targets, mob/living/user = usr)
	if(casting)
		return
	casting = TRUE
	fuel_source.ResetCesspool(usr)
	var/list/cone_turfs = ConeHelper(get_turf(user), user.dir, cone_levels)
	for(var/list/turf_list in cone_turfs)
		DoConeEffects(turf_list, cone_levels, user, TRUE)
	user.visible_message("<span class='warning'>[user] holds out their weapon and a dark mist starts to form!</span>")
	if(do_after(user, 1 SECONDS, target = user))
		for(var/list/turf_list in cone_turfs)
			DoConeEffects(turf_list, cone_levels, user, FALSE)
	else
		user.visible_message("<span class='warning'>The mist swirls and starts consuming [user]!</span>")
		user.adjustBlackLoss(50)
	casting = FALSE
	playsound(user, 'sound/weapons/resonator_blast.ogg', 20, TRUE)

///This proc does obj, mob and turf cone effects on all targets in a list
/obj/effect/proc_holder/ability/aimed/vile_burst/proc/DoConeEffects(list/target_turf_list, level, mob/user, telegraph)
	for(var/target_turf in target_turf_list)
		//if turf is no longer there
		if(!target_turf)
			continue
		if(telegraph)
			DoConeTurfEffects(target_turf, level, 1)
		if(!telegraph)
			DoConeTurfEffects(target_turf, level, 2)
			if(isopenturf(target_turf))
				var/turf/open/open_turf = target_turf
				for(var/mob/living/movable_content in open_turf)
					if(isliving(movable_content))
						DoConeMobEffect(movable_content, level)

///This proc deterimines how the spell will affect turfs.
/obj/effect/proc_holder/ability/aimed/vile_burst/proc/DoConeTurfEffects(turf/target_turf, level, type)
	switch(type)
		if(1)
			new /obj/effect/temp_visual/telegraphing(target_turf)
		if(2)
			new /obj/effect/temp_visual/revenant/cracks(target_turf)
			if(!locate(/obj/effect/decal/cleanable/dirt/dust) in target_turf)
				new /obj/effect/decal/cleanable/dirt/dust(target_turf)
	return

///This proc deterimines how the spell will affect mobs.
/obj/effect/proc_holder/ability/aimed/vile_burst/proc/DoConeMobEffect(mob/living/target_mob, level)
	target_mob.adjustBlackLoss(rand(40,60) * cone_levels)

///This proc adjusts the cones width depending on the level.
/obj/effect/proc_holder/ability/aimed/vile_burst/proc/CalculateConeShape(current_level)
	var/end_taper_start = round(cone_levels * 0.8)
	if(current_level > end_taper_start)
		//someone more talented and probably come up with a better formula.
		return (current_level % end_taper_start) * 2
	else
		return 2
