/obj/structure/fish_refinery
	name = "Fish Refinery"
	desc = "A machine used to refine any fish into raw PE."
	icon = 'ModularTegustation/fishing/icons/fishmachines.dmi'
	icon_state = "fish_refinery"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/refine_timer = 2 MINUTES
	var/loaded = FALSE
	var/fish_amount = 0

/obj/structure/fish_refinery/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/fish_refinery/Destroy()
	GLOB.lobotomy_devices -= src
	if(loaded)
		new /obj/item/food/fish(get_turf(src))
	return ..()

/obj/structure/fish_refinery/examine(mob/user)
	. = ..()
	if(!loaded)
		. += span_notice("There are [fish_amount]/20 fishes in the refinery.")
	else
		. += span_notice("The refinery is currently busy refining.")

/obj/structure/fish_refinery/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/food/fish))
		if(!loaded)
			fish_amount +=1
			to_chat(user, span_notice("You load fish into the machine."))
			qdel(I)
			playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0)
		else
			to_chat(user, span_notice("Something is already loaded."))
		if(fish_amount ==20)
			loaded = TRUE
			fish_amount = 0
			INVOKE_ASYNC(src, PROC_REF(counter))
		else
			return


/obj/structure/fish_refinery/proc/counter()
	if(loaded)
		sleep(refine_timer)
		loaded = FALSE
		new /obj/item/rawpe(get_turf(src))
		visible_message(span_notice("The refinery finishes refining a box."))
