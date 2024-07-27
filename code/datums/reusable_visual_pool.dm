/datum/reusable_visual_pool
	var/list/available_objects
	var/list/all_objects
	var/available_count = 0
	var/being_deleted = FALSE

/datum/reusable_visual_pool/New(size = 20)
	available_objects = new(size)
	all_objects = new(size)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(InitializeObjects), size)

/datum/reusable_visual_pool/proc/InitializeObjects(amount)
	for(var/i in 1 to amount)
		if(being_deleted)
			return
		var/obj/effect/reusable_visual/RV = new /obj/effect/reusable_visual(src)
		all_objects[i] = RV
		++available_count
		available_objects[available_count] = RV
		CHECK_TICK

/datum/reusable_visual_pool/Destroy()
	being_deleted = TRUE
	available_objects.Cut()
	QDEL_LIST(all_objects)
	return ..()

/datum/reusable_visual_pool/proc/TakePoolElement()
	var/obj/effect/reusable_visual/RV
	if(available_count < 1)
		RV = new /obj/effect/reusable_visual(src)
		all_objects += RV
		available_objects += null
	else
		RV = available_objects[available_count]
		--available_count
	RV.is_being_used = TRUE
	RV.invisibility = 0
	return RV

/datum/reusable_visual_pool/proc/ReturnToPool(obj/effect/reusable_visual/RV)
	if(!istype(RV) || RV.pool != src || !RV.is_being_used)
		return FALSE
	RV.delayed_return_count = 0
	RV.is_being_used = FALSE
	RV.invisibility = 101
	RV.can_be_z_moved = FALSE
	RV.alpha = 255
	RV.color = null
	RV.name = "nothing"
	RV.icon = 'icons/effects/effects.dmi'
	RV.icon_state = "nothing"
	RV.duration = 0
	RV.animate_movement = NO_STEPS
	RV.set_dir_on_move = FALSE
	RV.loc = null
	RV.transform = matrix()
	RV.dir = SOUTH
	RV.plane = GAME_PLANE
	RV.layer = ABOVE_MOB_LAYER
	animate(RV)
	++available_count
	available_objects[available_count] = RV
	return TRUE

/datum/reusable_visual_pool/proc/DelayedReturn(obj/effect/reusable_visual/RV, duration)
	set waitfor = 0
	RV.duration = duration
	RV.delayed_return_count += 1
	sleep(duration)
	if(QDELETED(RV))
		return
	if(RV.delayed_return_count < 2)
		ReturnToPool(RV)
	else
		RV.delayed_return_count -= 1

//Create procs like these for whatever effects
/datum/reusable_visual_pool/proc/NewSmashEffect(turf/location, duration = 3, color = null)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	RV.name = "smash"
	RV.icon_state = "smash"
	RV.color = color
	RV.loc = location
	DelayedReturn(RV, duration)
	return RV

/datum/reusable_visual_pool/proc/NewSparkles(turf/location, duration = 10, color = null)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	RV.name = "sparkles"
	RV.icon = 'icons/effects/effects.dmi'
	RV.icon_state = "sparkles"
	RV.color = color
	RV.dir = pick(GLOB.cardinals)
	RV.loc = location
	DelayedReturn(RV, duration)
	return RV

/datum/reusable_visual_pool/proc/NewCultSparks(turf/location, duration = 10)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	RV.name = "cult sparks"
	RV.icon = 'icons/effects/cult_effects.dmi'
	RV.icon_state = "bloodsparkles"
	RV.dir = pick(GLOB.cardinals)
	RV.loc = location
	DelayedReturn(RV, duration)
	return RV

/datum/reusable_visual_pool/proc/NewCultIn(turf/location, direction = SOUTH)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	RV.name = "cult in"
	RV.icon = 'icons/effects/cult_effects.dmi'
	RV.icon_state = "cultin"
	RV.dir = direction
	RV.loc = location
	DelayedReturn(RV, 7)
	return RV

/datum/reusable_visual_pool/proc/NewSmoke(turf/location, duration = 10, color = null)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	RV.name = "smoke"
	RV.icon = 'icons/effects/effects.dmi'
	RV.icon_state = "smoke"
	RV.color = color
	RV.dir = pick(GLOB.cardinals)
	RV.loc = location
	animate(RV, alpha = 0, time = duration)
	DelayedReturn(RV, duration)
	return RV
