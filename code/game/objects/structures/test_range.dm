// EGO Printer
/obj/machinery/ego_printer
	name = "EGO printer"
	desc = "Use a records book on this machine to have it give you a copy of each EGO you can print from the abnormality."
	icon = 'icons/obj/machines/droneDispenser.dmi'
	icon_state = "on"
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/ego_printer/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	var/list/egolist
	for(var/path in subtypesof(/datum/ego_datum))
			path += egolist
			new ego((get_turf(user)))
		to_chat(user, span_nicegreen("You successfully printed the EGO."))
