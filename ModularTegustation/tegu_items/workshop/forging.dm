/obj/item/forginghammer
	name = "forging hammer"
	desc = "Metal used for forging into workshop weapons. Use on hot tresmetal resting on an anvil to work it"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "hammer"
	w_class = WEIGHT_CLASS_BULKY

/obj/structure/table/anvil
	name = "workshop anvil"
	desc = "An anvil used by workshop offices. Put hot tresmetal on it and hit with a hammer to make a weapon."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "anvil"
	resistance_flags = INDESTRUCTIBLE
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null


/obj/structure/forge
	name = "workshop forge"
	desc = "A machine used to refine tres metal into templates."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "furnace_on"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/heat_timer = 60 SECONDS

	//The loaded of things.
	//FALSE is for not busy
	//TRUE is for loaded
	var/loaded = FALSE

/obj/structure/forge/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tresmetal))
		if(!loaded)
			loaded = TRUE
			to_chat(user, span_notice("You load \a [I] into the machine."))
			qdel(I)
			addtimer(CALLBACK(src, PROC_REF(finish), I), heat_timer)

			playsound(get_turf(src), 'sound/items/welder.ogg', 100, 0)
		else
			to_chat(user, span_notice("Something is already heating."))
	..()

/obj/structure/forge/proc/finish(obj/item/tresmetal/metal)
	loaded = FALSE
	var/obj/item/hot_tresmetal/hot = new metal.heated_type(get_turf(src))
	hot.SetQuality(metal.quality)
	visible_message(span_notice("The tresmetal is done heating, and will start cooling..."))
