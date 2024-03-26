/obj/structure/refinery
	name = "PE Refinery"
	desc = "A machine used to refine PE."
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machine"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/refine_timer = 60
	var/timeleft

	//This system has a blackjack mechanic. It gives you a number from 2 to 21 and you have to reach it with your filters.
	//Blue - 2
	//Green - 3
	//Red - 6
	//Yellow - 10
	var/blackjack

	//The loaded of things.
	//FALSE is for not busy
	//TRUE is for loaded
	var/loaded = FALSE

/obj/structure/refinery/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/refinery/Destroy()
	GLOB.lobotomy_devices -= src
	if(loaded)
		new /obj/item/rawpe(get_turf(src))
	return ..()

/obj/structure/refinery/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rawpe))
		if(!loaded)
			loaded = TRUE
			to_chat(user, span_notice("You load PE into the machine."))
			qdel(I)
			blackjack = rand(2,21)
			timeleft = refine_timer
			counter()
			playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0)
			to_chat(user, span_notice("The required filter strength is [blackjack]."))
		else
			to_chat(user, span_notice("Something is already loaded."))


	if(!loaded || !(istype(I, /obj/item/refiner_filter))	)
		return

	if(!do_after(user, 12))
		return

	switch(I.type)
		if(/obj/item/refiner_filter/blue)
			blackjack -= 2

		if(/obj/item/refiner_filter/green)
			blackjack -= 3

		if(/obj/item/refiner_filter/red)
			blackjack -= 6

		if(/obj/item/refiner_filter/yellow)
			blackjack -= 10


	qdel(I)
	to_chat(user, span_notice("You insert a filter."))
	playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0, 3)
	if(blackjack < 0)
		to_chat(user, span_danger("You filtered it too hard! The PE box was destroyed."))
		loaded = FALSE
	else if(blackjack == 0)
		timeleft -= round(refine_timer/3)
		to_chat(user, span_notice("You correctly filter the PE, speeding up refining."))

/obj/structure/refinery/proc/counter()
	timeleft--
	if(timeleft <= 0)
		loaded = FALSE
		new /obj/item/refinedpe(get_turf(src))
		visible_message(span_notice("The refinery finishes refining a box."))

	if(loaded)
		addtimer(CALLBACK(src, PROC_REF(counter)), 1 SECONDS)
