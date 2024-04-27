/**
 * This file serves to give the closets the functionality of making the mobs inside of them not necessarily safe
 * When going inside of a locker, a 5x5 area around you gets you into their var/list/possible_hiding_players
 * That list can aggro a mob when the mob walks over that tile onto a player inside of that list depending on var/noise
 */

/obj/structure/closet
	var/nonfunctional = FALSE // is this closet broken? (unable to be closed)

/obj/structure/closet/Destroy()
	if(opened)
		return ..()

	for(var/mob/living/person in src)
		for(var/turf/open/floor/funky_turf in range(2, drop_location()))
			funky_turf.noise = initial(funky_turf.noise)
			funky_turf.possible_hiding_players -= person

	return ..()

/obj/structure/closet/take_contents()
	. = ..()
	if(locate(/mob/living) in src.contents)
		anchorable = FALSE // dont let them move it
		set_anchored(TRUE)
		toggle_breathing(FALSE)

/obj/structure/closet/dump_contents()
	if(locate(/mob/living) in src.contents)
		anchorable = TRUE
		set_anchored(FALSE)
		toggle_breathing(TRUE)

	return ..()

/obj/structure/closet/attack_animal(mob/living/simple_animal/user)
	. = ..()
	if(!isabnormalitymob(user) || nonfunctional)
		return

	visible_message(span_warning("[user] starts tearing the [src]'s lid apart!"))
	if(!do_after(user, 1 SECONDS, src))
		visible_message(span_notice("[user] stops tearing the [src] open, visibly losing interest."))
		return

	visible_message(span_userdanger("[user] tears the [src]'s lid open with a loud noise!")) // run
	open(user)
	anchorable = FALSE // shit's broke for good
	set_anchored(TRUE)
	nonfunctional = TRUE

/obj/structure/closet/can_close(mob/living/user, force = FALSE)
	if(nonfunctional)
		return FALSE
	return ..()

/**
 * Toggles the turf's noise and possible_hiding_players list contents
 */
/obj/structure/closet/proc/toggle_breathing(opened = TRUE)
	if(!opened)
		for(var/turf/open/floor/funky_turf in range(2, drop_location()))
			if(SSlobotomy_corp.show_breathing)
				funky_turf.color = rgb(255, 255, 0)

			for(var/mob/living/person in src)
				funky_turf.possible_hiding_players += person

			for(funky_turf in range(1, drop_location())) // they can hear your breathing more clearly from closer away
				funky_turf.noise = 20
				if(SSlobotomy_corp.show_breathing)
					funky_turf.color = rgb(255, 0, 0)
		return

	// the closet is being opened, we need to remove the mobs and noise values from the lists
	for(var/turf/open/floor/funky_turf in range(2, drop_location()))
		if(SSlobotomy_corp.show_breathing)
			funky_turf.color = initial(funky_turf.color)

		funky_turf.noise = initial(funky_turf.noise)
		for(var/mob/living/person in src)
			funky_turf.possible_hiding_players -= person
