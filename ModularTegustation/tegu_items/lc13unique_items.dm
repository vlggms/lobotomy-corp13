	//Plushie Gatcha
/obj/item/plushgacha //would of made players also have to find keys to open these but im not that cruel... as of today. - IP
	name = "extraction plush lootbox"
	desc = "Theres a thank you note attached from J corp for your patronage."
	icon = 'icons/obj/storage.dmi'
	icon_state = "brassbox"
	var/rewards = list(
		/obj/item/toy/plush/beeplushie = 50, //higher values are more common
		/obj/item/toy/plush/blank = 45,
		/obj/item/toy/plush/yisang = 25,
		/obj/item/toy/plush/faust = 25,
		/obj/item/toy/plush/don = 25,
		/obj/item/toy/plush/ryoshu = 25,
		/obj/item/toy/plush/meursault = 25,
		/obj/item/toy/plush/honglu = 25,
		/obj/item/toy/plush/heathcliff = 25,
		/obj/item/toy/plush/ishmael = 25,
		/obj/item/toy/plush/rodion = 25,
		/obj/item/toy/plush/sinclair = 25,
		/obj/item/toy/plush/outis = 25,
		/obj/item/toy/plush/gregor = 25,
		/obj/item/toy/plush/dante = 18,
		/obj/item/toy/plush/qoh = 10,
		/obj/item/toy/plush/kog = 10,
		/obj/item/toy/plush/kod = 10,
		/obj/item/toy/plush/sow = 10,
		/obj/item/toy/plush/bigbird = 10,
		/obj/item/toy/plush/rabbit = 5,
		/obj/item/toy/plush/yuri = 5,
		/obj/item/toy/plush/nihil = 4,
	)

/obj/item/plushgacha/attack_self(mob/user)
	var/obj/item/toy/plush/reward = pickweight(rewards)
	to_chat(user, span_notice("You got a prize!"))
	new reward(get_turf(src))
	qdel(src)

//LC13 Rename of quantum pad
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
