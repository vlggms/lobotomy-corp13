/obj/machinery/quantumpad/warp
	name = "strange pad"
	desc = "A strange pad that has a W corp sticker on it."
	circuit = null

/obj/item/quantum_keycard/warp
	name = "warp pad keycard"
	desc = "A keycard able to link to a quantum pad's particle signature, allowing other quantum pads to travel there instead of their linked pad. The moment you use this card on a pad it will start teleporting to the cards pad."

/obj/item/package_quantumpad
	name = "bulky W corp package"
	desc = "Theres a warning on the side that when deployed they cannot be picked back up."
	icon = 'icons/obj/storage.dmi'
	icon_state = "alienbox"
	var/amount = 2

/obj/item/package_quantumpad/attack_self(mob/living/user)
	..()
	if(amount >= 2)
		to_chat(user, span_notice("You see another pad is still in the box."))
	if(amount <= 1)
		to_chat(user, span_notice("The [src] falls apart."))
		qdel(src)
	new /obj/machinery/quantumpad/warp(get_turf(user))
	to_chat(user, span_notice("You open the box and a strange pad falls out onto the floor."))
	amount--
