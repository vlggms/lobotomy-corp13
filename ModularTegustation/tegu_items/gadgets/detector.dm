	//improved detector code WARNING USES PROCESS

/obj/item/powered_gadget/detector_gadget
	name = "incomplete detector"
	desc = "This is the incomplete assembly of a detector gadget."
	icon_state = "gadget2_low"
	default_icon = "gadget2" //roundabout way of making update item easily changed. Used in updateicon proc.
	batterycost = 40 // 1 minute
	var/on = 0
	var/entitydistance
	var/nearestentity
	var/their_loc
	var/distance

/obj/item/powered_gadget/detector_gadget/attack_self(mob/user)
	..()
	if(on == 1)
		on = 0
		STOP_PROCESSING(SSobj, src)
		return
	if(cell && cell.charge >= batterycost)
		if(on == 0)
			on = 1
			START_PROCESSING(SSobj, src)
			return
	if(cell && cell.charge < batterycost)
		icon_state = "[default_icon]-nobat"

/obj/item/powered_gadget/detector_gadget/proc/calcdistance(distance)
	switch(distance)
		if(0 to 9) // the abnormality is within your sight or 10 tiles away from you
			icon_state = "[default_icon]_high"
			playsound(src, 'sound/machines/beep.ogg', 20, TRUE)
		if(10 to 20) //the abnormality is one screen away
			icon_state = "[default_icon]_mid"
			playsound(src, 'sound/machines/beep.ogg', 10, TRUE)
		else //the abnormality is too far away to be registered.
			icon_state = "[default_icon]_low"

/obj/item/powered_gadget/detector_gadget/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/powered_gadget/detector_gadget/process(delta_time)
	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		var/turf/my_loc = get_turf(src)
		detectthing()
		var/target_loc = get_turf(nearestentity)
		var/entitydistance = get_dist_euclidian(my_loc, target_loc)
		calcdistance(entitydistance)
		return
	on = 0
	icon_state = "[default_icon]-nobat"
	STOP_PROCESSING(SSobj, src)

/obj/item/powered_gadget/detector_gadget/proc/detectthing(mob/user)
	src.visible_message("<span class='notice'>The [src] falls apart.</span>", "<span class='notice'>You press a button and the [src] starts whirring before falling apart.</span>")
	qdel(src)
	return

	//Abnormality Detector
/obj/item/powered_gadget/detector_gadget/abnormality
	name = "Enkaphlin Drain Monitor"
	desc = "This device detects abnormalities by taking advantage of their siphon of Enkaphlin. Use in hand to activate."
	icon_state = "gadget2_low"
	default_icon = "gadget2" //roundabout way of making update item easily changed. Used in updateicon proc.

/obj/item/powered_gadget/detector_gadget/abnormality/calcdistance(distance)
	switch(distance)
		if(0 to 9) // the abnormality is within your sight or 10 tiles away from you
			icon_state = "[default_icon]_high"
			playsound(src, 'sound/machines/beep.ogg', 8, TRUE)
		if(10 to 20) //the abnormality is one screen away
			icon_state = "[default_icon]_mid"
			playsound(src, 'sound/machines/beep.ogg', 5, TRUE)
		else //the abnormality is too far away to be registered.
			icon_state = "[default_icon]_low"
			return
	if(nearestentity)
		var/mob/living/simple_animal/hostile/abnormality/THREAT = nearestentity
		if(THREAT.threat_level == ALEPH_LEVEL)
			if(prob(25))
				playsound(src, 'sound/hallucinations/over_here1.ogg', 5, TRUE)
			playsound(src, 'sound/magic/voidblink.ogg', 12, TRUE)
			return

/obj/item/powered_gadget/detector_gadget/abnormality/detectthing()
	var/turf/my_loc = get_turf(src)
	var/list/mob/living/simple_animal/hostile/abnormality/nearbyentities = list()
	for(var/mob/living/simple_animal/hostile/abnormality/ABNO in livinginrange(21, get_turf(src)))
		if(!(ABNO.status_flags & GODMODE))
			their_loc = get_turf(ABNO)
			var/distance = get_dist_euclidian(my_loc, their_loc)
			nearbyentities[ABNO] = (20 ** 1) - (distance ** 1)
			nearestentity = pickweight(nearbyentities)


	//Ordeal Detector
/obj/item/powered_gadget/detector_gadget/ordeal
	name = "R-corp Keen Sense Rangefinder" //placeholder name
	desc = "Through the joint research of L and R corp this device can detect the proximity of hostile creatures without having employees or abnormalities caught in its range. Use in hand to activate."
	icon_state = "gadget2r-low"
	default_icon = "gadget2r" //roundabout way of making update item easily changed. Used in updateicon proc.

/obj/item/powered_gadget/detector_gadget/ordeal/Initialize()
	..()
	if(prob(2))
		name = "R-corp Peen Sense Rangefinder"

/obj/item/powered_gadget/detector_gadget/ordeal/calcdistance(distance)
	switch(distance)
		if(0 to 5)
			icon_state = "[default_icon]-max"
			playsound(src, 'sound/machines/beep.ogg', 14, TRUE)
		if(6 to 9)
			icon_state = "[default_icon]-high"
			playsound(src, 'sound/machines/beep.ogg', 8, TRUE)
		if(10 to 20) //the entity is one screen away
			icon_state = "[default_icon]-mid"
			playsound(src, 'sound/machines/beep.ogg', 5, TRUE)
		else //the entity is too far away to be registered.
			icon_state = "[default_icon]-low"

/obj/item/powered_gadget/detector_gadget/ordeal/detectthing()
	var/turf/my_loc = get_turf(src)
	var/list/mob/living/simple_animal/hostile/ordeal/nearbyentities = list()
	if(nearestentity)
		var/mob/living/simple_animal/hostile/ordeal/M = nearestentity
		if(M.stat == DEAD)
			nearbyentities -= nearestentity
			nearestentity = null
	for(var/mob/living/simple_animal/hostile/ordeal/MON in livinginrange(21, get_turf(src)))
		if(!(MON.status_flags & GODMODE) && MON.stat != DEAD)
			their_loc = get_turf(MON)
			distance = get_dist_euclidian(my_loc, their_loc)
			nearbyentities[MON] = (20 ** 1) - (distance ** 1)
			nearestentity = pickweight(nearbyentities)
