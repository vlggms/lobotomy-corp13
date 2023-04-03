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

/obj/structure/refinery/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rawpe))
		if(!loaded)
			loaded = TRUE
			to_chat(user, "<span class='notice'>You load PE into the machine.</span>")
			qdel(I)
			blackjack = rand(2,21)
			timeleft = refine_timer
			counter()
			playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0)
			to_chat(user, "<span class='notice'>The required filter strength is [blackjack].</span>")
		else
			to_chat(user, "<span class='notice'>Something is already loaded.</span>")


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
	to_chat(user, "<span class='notice'>You insert a filter.</span>")
	playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0, 3)
	if(blackjack < 0)
		to_chat(user, "<span class='danger'>You filtered it too hard! The PE box was destroyed.</span>")
		loaded = FALSE
	else if(blackjack == 0)
		timeleft -= 20
		to_chat(user, "<span class='notice'>You correctly filter the PE, speding up refining.</span>")

/obj/structure/refinery/proc/counter()
	timeleft--
	if(timeleft <= 0)
		loaded = FALSE
		new /obj/item/refinedpe(get_turf(src))
		visible_message("<span class='notice'>The refinery finishes refining a box.</span>")

	if(loaded)
		addtimer(CALLBACK(src, .proc/counter), 1 SECONDS)
