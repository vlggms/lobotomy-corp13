//Box used to teach intents
/obj/structure/tutorialbox
	icon = 'icons/obj/mining.dmi'
	desc = "A heavy wooden box, which can be pushed."
	icon_state = "orebox"
	name = "pushable box"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODECONSTRUCT_1
	move_resist = MOVE_FORCE_STRONG

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
			to_chat(user, "<span class='notice'>You push \the [src] out of the way.</span>")
			addtimer(CALLBACK(src, /atom/movable/proc/forceMove, oldturf), 20 SECONDS)

/obj/machinery/power/emitter/energycannon/tutorialemitter

//I only removed the playsound because its SO ANNOYING
/obj/machinery/power/emitter/energycannon/tutorialemitter/fire_beam(mob/user)
	var/obj/projectile/P = new projectile_type(get_turf(src))
	if(prob(35))
		sparks.start()
	P.firer = user ? user : src
	P.fired_from = src
	if(last_projectile_params)
		P.p_x = last_projectile_params[2]
		P.p_y = last_projectile_params[3]
		P.fire(last_projectile_params[1])
	else
		P.fire(dir2angle(dir))
	if(!manual)
		last_shot = world.time
		if(shot_number < 3)
			fire_delay = 20
			shot_number ++
		else
			fire_delay = rand(minimum_fire_delay,maximum_fire_delay)
			shot_number = 0
	return P

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
					to_chat(H, "<span class='warning'>You need to take your backpack off your back slot!</span>")
					check_times[H] = world.time + TUTORIAL_MESSAGE_COOLDOWN
				alarm_beep()
				return FALSE
		for(var/obj/O in H.get_contents())
			if(O.type in prohibited_objects)
				if(!check_times[H] || check_times[H] < world.time)
					to_chat(H, "<span class='warning'>Please return any Lobotomy Corp property you have taken!</span>")
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
		to_chat(user, "<span class='alert'>A Qliphoth Meltdown has occured in the Containment Zone of [T.datum_reference.name].</span>")
		playsound(src, 'sound/effects/meltdownAlert.ogg', 30)
		return
	to_chat(user, "<span class='notice'>There are no avaliable abnormalities to meltdown.</span>")
