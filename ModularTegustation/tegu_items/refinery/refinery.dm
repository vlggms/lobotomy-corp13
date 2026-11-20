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
			timeleft = refine_timer
			counter()
			playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0)
		else
			to_chat(user, span_notice("Something is already loaded."))

/obj/structure/refinery/proc/counter()
	timeleft--
	if(timeleft <= 0)
		loaded = FALSE
		new /obj/item/refinedpe(get_turf(src))
		visible_message(span_notice("The refinery finishes refining a box."))

		//If you complete the refinery minigame, you can
		if(prob(30))
			new /obj/item/refinedpe(get_turf(src))

	if(loaded)
		addtimer(CALLBACK(src, PROC_REF(counter)), 1 SECONDS)
