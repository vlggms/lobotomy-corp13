/obj/effect/proc_holder/ability/aimed/corruptionpurity_release
	name = "Balance Corruption"
	desc = "Balance the energy of your weapon by dispersing it into the surrounding area."
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	base_icon_state = "balanced"
	base_action = /datum/action/spell_action/ability/item
	cooldown_time = 10 SECONDS
	var/datum/component/corruption_balance/fuel_source
	var/cone_levels = 3
	///This value determines if the cone penetrates walls.
	var/respect_density = TRUE

/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/Perform(target, mob/user)
	var/balance_stat = fuel_source.balance_stat
	switch(balance_stat)
		if("HEAVY LIGHT")
			action_icon_state = "purified_heavy"
			cast_smite(target, user)
			cone_levels = 5
		if("PARTIAL LIGHT")
			action_icon_state = "purified"
			cast_smite(target, user)
			cone_levels = 3
		if("NEUTRAL")
			action_icon_state = "balanced"
		if("PARTIAL DARK")
			action_icon_state = "corruption"
			cast_cone(target, user)
			cone_levels = 3
		if("HEAVY DARK")
			action_icon_state = "corruption_heavy"
			cast_cone(target, user)
			cone_levels = 5

/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/component_link(component)
	fuel_source = component

	//Corruption Attack code stolen from cone_spells.dm
///This proc creates a list of turfs that are hit by the cone
/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/cone_helper(turf/starter_turf, dir_to_use, cone_levels = 3)
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
			for(var/left_i in 1 to i -calculate_cone_shape(i))
				if(left_turf.density && respect_density)
					break
				left_turf = get_step(left_turf, left_dir)
				level_turfs += left_turf
			for(var/right_i in 1 to i -calculate_cone_shape(i))
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

/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/cast_cone(list/targets, mob/user = usr)
	var/list/cone_turfs = cone_helper(get_turf(user), user.dir, cone_levels)
	for(var/list/turf_list in cone_turfs)
		do_cone_effects(turf_list, cone_levels, user, TRUE)
	if(do_after(user, 3 SECONDS, target = user))
		playsound(user, 'sound/weapons/resonator_blast.ogg', 20, TRUE)
		for(var/list/turf_list in cone_turfs)
			do_cone_effects(turf_list, cone_levels, user, FALSE)

///This proc does obj, mob and turf cone effects on all targets in a list
/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/do_cone_effects(list/target_turf_list, level, mob/user, telegraph)
	for(var/target_turf in target_turf_list)
		if(!target_turf) //if turf is no longer there
			continue
		if(telegraph)
			do_turf_cone_effect(target_turf, level, 1)
		if(!telegraph)
			do_turf_cone_effect(target_turf, level, 2)
			if(isopenturf(target_turf))
				var/turf/open/open_turf = target_turf
				for(var/movable_content in open_turf)
					if(isliving(movable_content))
						do_mob_cone_effect(movable_content, level)

///This proc deterimines how the spell will affect turfs.
/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/do_turf_cone_effect(turf/target_turf, level, type)
	switch(type)
		if(1)
			new /obj/effect/temp_visual/telegraphing(target_turf)
		if(2)
			new /obj/effect/temp_visual/revenant/cracks(target_turf)
			new /obj/effect/decal/cleanable/dirt/dust(target_turf)
	return

///This proc deterimines how the spell will affect mobs.
/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/do_mob_cone_effect(mob/living/target_mob, level)
	switch(action_icon_state)
		if("corruption")
			target_mob.adjustBlackLoss(rand(10,20))
			fuel_source.reset_cesspool()
		if("corruption_heavy")
			target_mob.adjustBlackLoss(rand(20,30))
			fuel_source.reset_cesspool()
	return

///This proc adjusts the cones width depending on the level.
/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/calculate_cone_shape(current_level)
	var/end_taper_start = round(cone_levels * 0.8)
	if(current_level > end_taper_start)
		return (current_level % end_taper_start) * 2 //someone more talented and probably come up with a better formula.
	else
		return 2

	//Purity Attack single target
/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/proc/cast_smite(mob/living/target, mob/user = usr)
	if(do_after(user, 3 SECONDS, target = user))
		playsound(user, 'sound/weapons/resonator_blast.ogg', 20, TRUE)
		target.adjustWhiteLoss(rand(5,10) * cone_levels) //15 or 30 damange at lower level, 25 or 50 at higher level
		var/obj/effect/temp_visual/revenant/cracks/f = new(get_turf(target))
		f.color = "grey"
		fuel_source.reset_cesspool()
