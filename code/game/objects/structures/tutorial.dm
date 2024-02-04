//Box used to teach intents
/obj/structure/tutorialbox
	name = "pushable box"
	desc = "A heavy wooden box, which can be pushed."
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODECONSTRUCT_1
	move_resist = MOVE_FORCE_STRONG
	var/turf/origin_turf

/obj/structure/tutorialbox/Initialize()
	. = ..()
	if(!origin_turf)
		origin_turf = get_turf(src)

/obj/structure/tutorialbox/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!istype(user))
		return
	if(user.a_intent == INTENT_DISARM)
		var/turf/oldturf = loc
		var/shove_dir = get_dir(user.loc, oldturf)
		var/turf/shove_turf = get_step(loc, shove_dir)
		if(Move(shove_turf, shove_dir))
			to_chat(user, span_notice("You push \the [src] out of the way."))
			/*
			* If pushed out of the way from its original spot
			* in 20 seconds it will return to its original spot.
			* This obviously breaks if it is pushed from a spot
			* that isnt its origin but it prevents callback spam.
			*/
			if(oldturf == origin_turf && loc != origin_turf)
				addtimer(CALLBACK(src, /atom/movable/proc/forceMove, origin_turf), 20 SECONDS)

//prevent smuggling tutorial items
/obj/machinery/scanner_gate/tutorialscanner
	name = "tutorial scanner gate"
	density = FALSE
	locked = TRUE
	use_power = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/check_bag = TRUE
	var/list/check_times = list()
	var/list/prohibited_objects = list(
		/obj/item/kirbyplants,
		/obj/item/paper_bin,
		/obj/item/paper,
		/obj/item/paperplane,
		/obj/item/megaphone,
		/obj/item/megaphone/clown,
		/obj/item/flashlight,
		/obj/item/binoculars,
		/obj/item/reagent_containers/spray/chemsprayer/janitor,
		/obj/item/storage/backpack/satchel,
		/obj/item/evidencebag,
		/obj/item/storage/belt/ego,
		/obj/item/ego_weapon/tutorial,
		/obj/item/ego_weapon/tutorial/white,
		/obj/item/ego_weapon/tutorial/black,
		/obj/item/ego_weapon/tutorial/pale,
		/obj/item/clothing/suit/armor/ego_gear/rookie,
		/obj/item/clothing/suit/armor/ego_gear/fledgling,
		/obj/item/clothing/suit/armor/ego_gear/apprentice,
		/obj/item/clothing/suit/armor/ego_gear/freshman
		)

/obj/machinery/scanner_gate/tutorialscanner/auto_scan(atom/movable/AM)
	return

/obj/machinery/scanner_gate/tutorialscanner/attackby(obj/item/W, mob/user, params)
	return

/obj/machinery/scanner_gate/tutorialscanner/emag_act(mob/user)
	return

#define TUTORIAL_MESSAGE_COOLDOWN 50
/obj/machinery/scanner_gate/tutorialscanner/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(isobj(mover))
		return FALSE
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		set_scanline("scanning", 5)
		if(check_bag)
			if(istype(H.get_item_by_slot(ITEM_SLOT_BACK),/obj/item/storage/backpack))
				if(!check_times[H] || check_times[H] < world.time) //Let's not spam the message
					to_chat(H, span_boldwarning("You need to take your backpack off your back slot!"))
					check_times[H] = world.time + TUTORIAL_MESSAGE_COOLDOWN
				alarm_beep()
				return FALSE
		for(var/obj/O in H.get_contents())
			if(O.type in prohibited_objects)
				if(!check_times[H] || check_times[H] < world.time)
					to_chat(H, span_boldwarning("Please return any tutorial items you have taken!"))
					check_times[H] = world.time + TUTORIAL_MESSAGE_COOLDOWN
				alarm_beep()
				return FALSE

#undef TUTORIAL_MESSAGE_COOLDOWN

/obj/machinery/button/tutorialmeltdown
	name = "tutorial meltdown device"
	desc = "This device is used to train employees with abnormality meltdowns."
	use_power = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/button/tutorialmeltdown/emag_act(mob/user)
	return

/obj/machinery/button/tutorialmeltdown/attackby(obj/item/W as obj, mob/user as mob, params)
	if(user.a_intent != INTENT_HARM && !(W.item_flags & NOBLUDGEON))
		return attack_hand(user)

/obj/machinery/button/tutorialmeltdown/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	flick("[skin]1",src)
	var/area/currentarea = get_area(src)
	var/list/avaliable = list()
	for(var/obj/machinery/computer/abnormality/tutorial/AT in currentarea)
		if(AT.meltdown || AT.datum_reference.working)
			continue
		if(!AT.datum_reference || !AT.datum_reference.current)
			continue
		if(!(AT.datum_reference.current.status_flags & GODMODE) || (!AT.datum_reference.qliphoth_meter && AT.datum_reference.qliphoth_meter_max))
			continue
		avaliable += AT
	if(LAZYLEN(avaliable))
		var/obj/machinery/computer/abnormality/tutorial/T = pick(avaliable)
		T.start_meltdown()
		to_chat(user, span_alert("A Qliphoth Meltdown has occured in the Containment Zone of [T.datum_reference.name]."))
		playsound(src, 'sound/effects/meltdownAlert.ogg', 30)
		return
	to_chat(user, span_notice("There are no avaliable abnormalities to meltdown."))

//Tutorial Holodisks are located in holocall.dm
