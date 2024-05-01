/datum/reusable_visual_pool
	var/list/available_objects
	var/list/all_objects

/datum/reusable_visual_pool/New(size = 20)
	available_objects = list()
	all_objects = list()
	INVOKE_ASYNC(src, PROC_REF(InitializeObjects), size)
	return ..()

/datum/reusable_visual_pool/proc/InitializeObjects(amount)
	for(var/i in 1 to amount)
		var/obj/effect/reusable_visual/RV = new /obj/effect/reusable_visual(src)
		all_objects += RV
		available_objects += RV
		sleep(-1)

/datum/reusable_visual_pool/Destroy()
	available_objects.Cut()
	QDEL_LIST(all_objects)
	return ..()

/datum/reusable_visual_pool/proc/TakePoolElement()
	var/obj/effect/reusable_visual/RV
	if(available_objects.len < 1)
		RV = new /obj/effect/reusable_visual(src)
		all_objects += RV
	else
		RV = available_objects[available_objects.len]
		--available_objects.len
	RV.is_being_used = TRUE
	RV.invisibility = 0
	return RV

/datum/reusable_visual_pool/proc/ReturnToPool(obj/effect/reusable_visual/RV)
	if(!istype(RV) || RV.pool != src || !RV.is_being_used)
		return FALSE
	deltimer(RV.timer_id)
	RV.timer_id = null
	RV.is_being_used = FALSE
	RV.invisibility = 101
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
	available_objects += RV
	return TRUE

#define SET_RV_RETURN_TIMER(RV, DURATION) ##RV.duration = DURATION; if(DURATION > 0) ##RV.timer_id = addtimer(CALLBACK(##RV.pool, TYPE_PROC_REF(/datum/reusable_visual_pool, ReturnToPool), ##RV), ##RV.duration, TIMER_STOPPABLE);

/datum/reusable_visual_pool/proc/NewSmashEffect(turf/location, duration = 4, color = null)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	SET_RV_RETURN_TIMER(RV, duration)
	RV.name = "smash"
	RV.icon_state = "smash"
	RV.color = color
	RV.loc = location
	return RV

/datum/reusable_visual_pool/proc/NewCultSparks(turf/location, duration = 10, color = null)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	SET_RV_RETURN_TIMER(RV, duration)
	RV.name = "blood sparks"
	RV.icon = 'icons/effects/cult_effects.dmi'
	RV.icon_state = "bloodsparkles"
	RV.color = color
	RV.dir = pick(GLOB.cardinals)
	RV.loc = location
	return RV