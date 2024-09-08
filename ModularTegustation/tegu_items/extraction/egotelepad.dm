/obj/structure/return_pad
	name = "E.G.O. return pad"
	desc = "A device developed in a partnership with W-Corp for safe and insant transportation of E.G.O. to the extraction department."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "qpad-idle"
	var/obj/structure/extraction_belt/linked_structure
	var/available_teleports = 3
	var/ready = FALSE

/obj/structure/return_pad/Initialize()
	. = ..()
	QDEL_IN(src, 45 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(Warmup)), 1 SECONDS)

/obj/structure/return_pad/Destroy()
	linked_structure = null
	return ..()

/obj/structure/return_pad/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/clothing/suit/armor/ego_gear) || istype(I, /obj/item/gun/ego_gun/pistol) || istype(I, /obj/item/ego_weapon) || istype(I, /obj/item/gun/ego_gun))
		TryTeleport(I)
		return
	return ..()

/obj/structure/return_pad/proc/Warmup() // This proc basically exists so that people don't accidently toss items in it the instant it spawns
	ready = TRUE

/obj/structure/return_pad/proc/TryTeleport(obj/item/I)
	if(!linked_structure)
		visible_message(span_warning("ERROR - NO LINKED STRUCTURE!"))
		qdel(src)
		return
	if(!ready)
		visible_message(span_warning("ERROR - Warming up. Please wait one second."))
		return
	flick("qpad-beam", src)
	playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 25, TRUE)
	playsound(get_turf(linked_structure), 'sound/weapons/emitter2.ogg', 25, TRUE)
	do_teleport(I, get_turf(linked_structure),null,TRUE,null,null,null,null,TRUE, channel = TELEPORT_CHANNEL_FREE) // Don't want anything interrupting it
	available_teleports -= 1
	if(!available_teleports)
		visible_message(span_warning("[src] fizzles out and disappears!"))
		qdel(src)
