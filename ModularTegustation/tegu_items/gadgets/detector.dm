	//improved detector code WARNING USES PROCESS

/obj/item/powered_gadget/detector_gadget
	name = "incomplete detector"
	desc = "This is the incomplete assembly of a detector gadget."
	icon_state = "gadget2"
	default_icon = "gadget2" //roundabout way of making update item easily changed. Used in updateicon proc.
	batterycost = 40 // 1 minute
	var/on = 0
	//Stuff related to detection.
	var/entitydistance
	var/nearestentity
	var/their_loc
	var/distance
	//entity you are detecting, if there is none then the device will self destruct.
	var/detectable_entity

/obj/item/powered_gadget/detector_gadget/attack_self(mob/user)
	..()
	if(on == 1)
		on = 0
		CancelOverlays()
		STOP_PROCESSING(SSobj, src)
		return
	if(cell && cell.charge >= batterycost)
		if(on == 0)
			on = 1
			if(!detectable_entity)
				to_chat(user, span_notice("You press a button and the [src] starts whirring before falling apart."))
				return QDEL_IN(src, 1)
			update_icon_state()
			START_PROCESSING(SSobj, src)
			return
	CancelOverlays()

/obj/item/powered_gadget/detector_gadget/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/powered_gadget/detector_gadget/process(delta_time)
	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		var/turf/my_loc = get_turf(src)
		nearestentity = detectthing()
		var/entitydistance
		//Skip all of this is there isnt even a entity.
		if(nearestentity)
			var/target_loc = get_turf(nearestentity)
			entitydistance = get_dist_euclidian(my_loc, target_loc)
		calcdistance(entitydistance)
		update_icon()
		return
	on = 0
	icon_state = "[default_icon]-nobat"
	CancelOverlays()
	STOP_PROCESSING(SSobj, src)

/obj/item/powered_gadget/detector_gadget/proc/calcdistance(distance)
	switch(distance)
		if(0 to 4)
			powered_overlay = "[default_icon]-max"
			playsound(src, 'sound/machines/beep.ogg', 14, TRUE)
		if(5 to 9)
			powered_overlay = "[default_icon]-high"
			playsound(src, 'sound/machines/beep.ogg', 8, TRUE)
		if(10 to 20) //the entity is one screen away
			powered_overlay = "[default_icon]-mid"
			playsound(src, 'sound/machines/beep.ogg', 5, TRUE)
		//the entity is too far away to be registered.
		else
			powered_overlay = "[default_icon]-low"
			return

//What can be detected and what cant.
/obj/item/powered_gadget/detector_gadget/proc/DetectConditions(mob/living/T)
	if(istype(T, detectable_entity) && !(T.status_flags & GODMODE) && T.stat != DEAD)
		return TRUE
	return FALSE

/obj/item/powered_gadget/detector_gadget/proc/detectthing()
	var/turf/my_loc = get_turf(src)
	var/list/nearbyentities = list()
	for(var/mob/living/L in livinginrange(20, get_turf(src)))
		if(DetectConditions(L))
			their_loc = get_turf(L)
			nearbyentities += L
			nearbyentities[L] = get_dist_euclidian(my_loc, their_loc)
	return ReturnLowestValue(nearbyentities)

/obj/item/powered_gadget/detector_gadget/proc/CancelOverlays()
	powered_overlay = null
	update_icon()

	//Abnormality Detector
/obj/item/powered_gadget/detector_gadget/abnormality
	name = "Enkaphlin Drain Monitor"
	desc = "This device detects abnormalities by taking advantage of their siphon of Enkaphlin. Use in hand to activate."
	icon_state = "gadget2"
	default_icon = "gadget2"
	detectable_entity = /mob/living/simple_animal/hostile/abnormality

//Finding an abnormalities corpse may be important.
/obj/item/powered_gadget/detector_gadget/abnormality/DetectConditions(mob/living/T)
	if(istype(T, detectable_entity) && !(T.status_flags & GODMODE))
		return TRUE
	return FALSE

/obj/item/powered_gadget/detector_gadget/abnormality/calcdistance(distance)
	..()
	//Unique Reaction to Alephs
	if(nearestentity)
		var/mob/living/simple_animal/hostile/abnormality/THREAT = nearestentity
		if(THREAT.threat_level == ALEPH_LEVEL)
			if(prob(25))
				playsound(src, 'sound/hallucinations/over_here1.ogg', 5, TRUE)
			playsound(src, 'sound/magic/voidblink.ogg', 12, TRUE)

	//Ordeal Detector
/obj/item/powered_gadget/detector_gadget/ordeal
	name = "R-corp Keen Sense Rangefinder" //placeholder name
	desc = "Through the joint research of L and R corp this device can detect the proximity of hostile creatures without having employees or abnormalities caught in its range. Use in hand to activate."
	icon_state = "gadget2r"
	//roundabout way of making update item easily changed. Used in updateicon proc.
	default_icon = "gadget2r"
	detectable_entity = /mob/living/simple_animal/hostile/ordeal

/obj/item/powered_gadget/detector_gadget/ordeal/Initialize()
	..()
	if(prob(2))
		name = "R-corp Peen Sense Rangefinder"
