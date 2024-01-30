/datum/design/rcd_loaded/bluespace
	name = "Bluespace Rapid Construction Device"
	desc = "A prototype RCD with ranged capability and extended capacity. Requires a bluespace core to operate properly."
	id = "rcd_bluespace"
	materials = list(/datum/material/iron = 80000, /datum/material/glass = 20000, /datum/material/bluespace = 3000)
	build_path = /obj/item/construction/rcd/arcd/bluespace

/obj/item/construction/rcd/arcd/bluespace
	name = "bluespace rapid-construction-device (BRCD)"
	desc = "A prototype RCD with ranged capability and extended capacity. Requires a bluespace core to operate properly."
	max_matter = 240
	matter = 240
	delay_mod = 0.8
	var/anomaly_core = FALSE
	var/rcd_range = 4

/obj/item/construction/rcd/arcd/bluespace/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/assembly/signaler/anomaly/bluespace) && !anomaly_core)
		to_chat(user, span_notice("You insert [C] into the [src] and green light blinks on the panel."))
		anomaly_core = TRUE
		playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
		desc = "A prototype RCD with ranged capability and extended capacity."
		qdel(C)
		return
	. = ..()

/obj/item/construction/rcd/arcd/bluespace/attack_self(mob/user)
	if(!anomaly_core)
		to_chat(user, span_warning("The BRCD requires a bluespace anomaly core to operate!"))
		return
	. = ..()

/obj/item/construction/rcd/arcd/bluespace/afterattack(atom/A, mob/user)
	if(!anomaly_core)
		to_chat(user, span_warning("The BRCD requires a bluespace anomaly core to operate!"))
		return
	. = ..()

/obj/item/construction/rcd/arcd/bluespace/range_check(atom/A, mob/user)
	if(!(A in view(rcd_range, get_turf(user))))
		to_chat(user, span_warning("The \"Out of Range\" light on [src] blinks red."))
		return FALSE
	else
		return TRUE

/datum/design/magboots/anomaly
	name = "Anomalous Magnetic Boots"
	desc = "Magnetic boots that use gravity anomaly core power to reduce the weight and thus the slowdown."
	id = "magboots_anomaly"
	materials = list(/datum/material/iron = 10000, /datum/material/uranium = 5000, /datum/material/silver = 3500, /datum/material/gold = 3500)
	build_path = /obj/item/clothing/shoes/magboots/noslow

/obj/item/clothing/shoes/magboots/noslow
	desc = "Pair of magnetic boots using a gravity core to reduce the weight and slowdown."
	name = "dormant anomalous magboots"
	icon = 'ModularTegustation/Teguicons/teguclothing.dmi'
	slowdown_active = SHOES_SLOWDOWN
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	throw_speed = 2
	throw_range = 3
	var/anomaly_core = FALSE

/obj/item/clothing/shoes/magboots/noslow/attack_self(mob/user)
	if(!anomaly_core)
		to_chat(user, span_warning("[src] require a gravity anomaly core to operate!"))
		return
	. = ..()

/obj/item/clothing/shoes/magboots/noslow/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/assembly/signaler/anomaly/grav) && !anomaly_core)
		name = "anomalous magboots"
		to_chat(user, span_notice("You insert [C] into [src] and they start to feel much lighter."))
		playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
		anomaly_core = TRUE
		throw_speed = 3
		throw_range = 7
		qdel(C)
		return
	. = ..()
