/obj/structure/refiner
	name = "Unknwon refinery"
	desc = "Contact a coder immediately!"
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator-blue"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/refiner/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/refiner/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

