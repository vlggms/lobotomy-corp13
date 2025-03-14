
/**
* TRIPWIRE TRAPS
*/
	/* Tripwire Trap
/datum/crafting_recipe/tripwire
	name = "Tripwire"
	result = /obj/structure/destructible/tripwire_trap
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 2, /obj/item/stack/sheet/mineral/wood = 2)
	time = 40
	category = CAT_MISC
*/

/obj/structure/destructible/tripwire_trap
	name = "tripwire"
	desc = "A string attached to two sticks."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "tripwire"
	alpha = 100
	break_message = span_warning("The trap falls apart!")
	debris = list(/obj/item/stack/sheet/cotton/cloth = 1)
	var/triggered_attack

/obj/structure/destructible/tripwire_trap/Initialize(mapload)
	. = ..()
	if(!isfloorturf(get_turf(src)))
		qdel(src)
	if(mapload)
		var/obj/item/I = locate(/obj/item) in loc
		if(I)
			I.forceMove(src)
			triggered_attack = 1

/obj/structure/destructible/tripwire_trap/attackby(obj/item/W, mob/user)
	if(!triggered_attack && isitem(W) && user.a_intent != INTENT_HARM)
		visible_message(span_notice("[user] ties [W] to the [src]."))
		W.forceMove(src)
		triggered_attack = 1
		return
	return ..()

/obj/structure/destructible/tripwire_trap/Crossed(atom/movable/AM as mob|obj)
	. = ..()
	if(triggered_attack == 1)
		if(ismob(AM))
			var/mob/MM = AM
			if(!(MM.movement_type & FLYING))
				if(ishuman(AM))
					var/mob/living/carbon/H = AM
					if(H.m_intent == MOVE_INTENT_RUN)
						trapEffect(H)
						H.visible_message(span_warning("[H] accidentally steps on [src]."), \
							span_warning("You accidentally step on [src]"))
				else
					trapEffect(MM)
		else if(AM.density) // For mousetrap grenades, set off by anything heavy
			trapEffect(AM)
	..()

/obj/structure/destructible/tripwire_trap/proc/trapEffect(mob/living/L)
	for(var/obj/item/I in src)
		visible_message(span_notice("[I] swings down."))
		I.forceMove(get_turf(src))
		UniqueItemEffect(I)
		I.throw_impact(L)
		triggered_attack = 0
	deconstruct(TRUE)

/obj/structure/destructible/tripwire_trap/proc/UniqueItemEffect(obj/item/I)
	if(istype(I, /obj/item/grenade))
		var/obj/item/grenade/G = I
		G.arm_grenade(null, G.det_time)

/*-------------\
| SIGNAL TRAPS |
\-------------*/

/obj/structure/sigsystem
	name = "incomplete signal system"
	desc = "Someone tried to make a signal system here."
	icon = 'ModularTegustation/Teguicons/sigsystem_icons.dmi'
	density = FALSE
	anchored = TRUE
	var/fire_cooldown = 0
	var/fire_delay = 3
	var/signaller_freq = FREQ_PRESSURE_PLATE
	var/signaller_code = 111
	var/signaller_range
	var/obj/item/assembly/signaler/system/sigdev
	var/list/list_triggers = list()

/obj/structure/sigsystem/Initialize()
	. = ..()
	LoadSignallers()

/obj/structure/sigsystem/proc/pulse(signaller_code)
	if(fire_cooldown > world.time)
		return FALSE
	return TRUE

/obj/structure/sigsystem/proc/LoadSignallers()
	sigdev = new(src)
	sigdev.set_frequency(signaller_freq)
	sigdev.code = signaller_code
	if(signaller_range)
		sigdev.effective_range = signaller_range
	return

/*-----------------------\
|Trap Projectile Launcher|
\-----------------------*/
/obj/structure/sigsystem/projectile_launcher
	name = "launching mechanism"
	desc = "A hole that launches a projectile when supplied with a signal."
	icon_state = "hole"


	var/projectile_type = /obj/projectile/bullet/shotgun_beanbag
	var/projectile_sound = 'sound/weapons/sonic_jackhammer.ogg'

/obj/structure/sigsystem/projectile_launcher/pulse(signaller_code)
	. = ..()
	if(!.)
		return FALSE
	var/obj/projectile/P = new projectile_type(get_step(get_turf(src), dir))
	playsound(src, projectile_sound, 50, TRUE)
	P.firer = src
	P.fired_from = src
	P.fire(dir2angle(dir))
	fire_cooldown = world.time + fire_delay
	return P

/*-----------------\
|Trap Atom Deployer|
\-----------------*/
// Essentally a signal fed copy of /obj/effect/step_trigger/place_atom
/obj/structure/sigsystem/deployer
	name = "deploying mechanism"
	desc = "A hole that deploys something when supplied with a signal."
	icon_state = "hole"

	var/atom_path
	var/atom_rename
	var/deploy_sound
	var/spawn_flavor_text
	var/happens_once = TRUE
	//Cords are offset from current position.
	var/spawn_dist_x = 0
	var/spawn_dist_y = 0


/obj/structure/sigsystem/deployer/pulse(signaller_code)
	. = ..()
	if(!.)
		return FALSE
	if(fire_cooldown > world.time)
		return
	//Remotely finds the turf where we spawn the thing.
	var/checkturf = get_turf(locate(x + spawn_dist_x, y + spawn_dist_y, z))
	if(checkturf)
		CreateThing(checkturf)
		fire_cooldown = world.time + fire_delay
		if(happens_once)
			qdel(src)

/obj/structure/sigsystem/deployer/proc/CreateThing(turf/T)
	if(atom_path)
		var/atom/movable/M = new atom_path(T)
		//The thing has somehow failed to spawn.
		if(!M)
			return
		if(deploy_sound)
			playsound(src, deploy_sound, 50, TRUE)
		//TECHNICALLY you could spawn a single turf with this? -IP
		if(atom_rename && !iseffect(M))
			M.name = atom_rename
		if(spawn_flavor_text)
			M.visible_message(span_danger("[M] [spawn_flavor_text]."))
		return M

/*--------------------------\
|Fail Success Condition Code|
\--------------------------*/
/obj/structure/sigsystem/keypad
	name = "keypad"
	desc = "A panel requesting a password."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "keypad"

	//Signal for misfortune that occurs when foolin about.
	var/spawn_failsig = FALSE
	var/fail_signaller_code = 111
	var/obj/item/assembly/signaler/system/fail_sigdev
	//Solution
	var/code_soln = "1234"

/obj/structure/sigsystem/keypad/Initialize()
	. = ..()
	if(spawn_failsig)
		fail_sigdev = new(src)
		fail_sigdev.set_frequency(signaller_freq)
		fail_sigdev.code = fail_signaller_code

/obj/structure/sigsystem/keypad/attack_hand(mob/living/user)
	..()
	var/user_input = input(user,"Type in Code:", "Type in Code") as text|null
	if(!user_input)
		return
	if(!user.canUseTopic(src, BE_CLOSE))
		to_chat(user, span_notice("You attempted to input the code from a distance. You need to stand next to the keypad."))
		return
	InputCheck(user_input)

/obj/structure/sigsystem/keypad/proc/InputCheck(input_code = "0000")
	var/obj/item/assembly/signaler/system/focus_sig = fail_sigdev
	if(input_code == code_soln)
		focus_sig = sigdev
	if(istype(focus_sig))
		focus_sig.signal()

/*----------------\
|Sigsystem Adaptor|
\----------------*/
/obj/structure/sigsystem/adaptor
	name = "signal system adaptor"
	desc = "An adaptor to bridge the divide between different systems."
	icon_state = "repeater"
	var/obj/item/assembly/device = null
	var/device_type
	//ID for door if using airlock control assemblys
	var/device_id

/obj/structure/sigsystem/adaptor/Initialize(mapload)
	. = ..()

	if(!device && device_type)
		device = new device_type(src)

	SetUpDevice()

/obj/structure/sigsystem/adaptor/pulse(signaller_code)
	. = ..()
	if(!.)
		return FALSE
	if(fire_cooldown > world.time)
		return
	if(device)
		ActivateDevice()

/obj/structure/sigsystem/adaptor/proc/SetUpDevice()
	if(id && istype(device, /obj/item/assembly/control))
		var/obj/item/assembly/control/A = device
		A.id = device_id

/obj/structure/sigsystem/adaptor/proc/ActivateDevice()
	if(istype(device, /obj/item/assembly/control/airlock))
		if(!id_tag)
			return
		var/obj/item/assembly/control/airlock/A = device
		A.activate()

/*-------------\
|SIGNAL CIRCUIT|
\--------------/
* Awful insane signal logic.
* sigdev is the output signal
* duo and tri sigdevs are the input.
*/

/obj/structure/sigsystem/circuit
	name = "sigsystem circuit"
	desc = "Some deranged mess of wires and signallers."
	icon_state = "wires"
	//Sorry its to preserve the decor of the room.
	invisibility = INVISIBILITY_ABSTRACT

	//If repeating the same signal switches a ON status to OFF
	var/switch_off = FALSE
	//Signaller Two: Recieves Signal
	var/duo_signaller_code = 121
	var/obj/item/assembly/signaler/system/duo_sigdev
	//Solution signals
	var/list/sig_conditions = list()
	//Sending out several signals one after another
	var/repeat_amt = 1
	//Amount of signals required to send 1 signal
	var/current_buffer = 0
	var/buffer_amt = 0
	//Time delay on when the signal should occur
	var/sig_delay = 1

/obj/structure/sigsystem/circuit/pulse(signaller_code)
	var/code_value = "[signaller_code]"
	var/code_value2 = sig_conditions[code_value]
	if(!code_value || !code_value2)
		return FALSE
	switch(code_value2)
		if(1)
			sig_conditions[code_value] = 2
		if(2)
			if(switch_off)
				sig_conditions[code_value] = 1
	update_icon_state()
	if(ConditionCheckSig())
		Signal()
	return "[signaller_code]|[code_value]|[code_value2]"

/obj/structure/sigsystem/circuit/LoadSignallers()
	. = ..()
	duo_sigdev = new(src)
	duo_sigdev.set_frequency(signaller_freq)
	duo_sigdev.code = duo_signaller_code

	AddCondition(duo_signaller_code)

/obj/structure/sigsystem/circuit/proc/Signal()
	current_buffer = 0
	//This looks like it shouldnt be.
	for(var/i = 1 to repeat_amt)
		//Unsure if i should use sleep here -IP
		sleep(sig_delay)
		sigdev.signal()

/obj/structure/sigsystem/circuit/proc/AddCondition(initial_key)
	var/formatted_value = "[initial_key]"
	sig_conditions += formatted_value
	sig_conditions[formatted_value] = 1

/obj/structure/sigsystem/circuit/proc/ConditionCheckSig()
	. = TRUE
	if(buffer_amt)
		current_buffer++
		if(current_buffer < buffer_amt)
			return FALSE

/*--------------\
|SIGNAL AND-GATE|
\---------------/
* Functions like a Minecraft redstone AND_Gate
*/

/obj/structure/sigsystem/circuit/and_gate
	name = "sigsystem and-gate"
	desc = "A circuit that sends out a signal when supplied with two different signals."
	icon_state = "andgate"
	//Just in the case you want to show progress
	invisibility = SEE_INVISIBLE_MINIMUM

	//Signaller Three: Recieves Signal
	var/tri_signaller_code = 131
	var/obj/item/assembly/signaler/system/tri_sigdev

/obj/structure/sigsystem/circuit/and_gate/update_icon_state()
	cut_overlays()
	var/place_in_list = 1
	for(var/i in sig_conditions)
		if(sig_conditions[i] == 2)
			var/mutable_appearance/powered_overlay = mutable_appearance(icon, "andgate_[place_in_list]")
			add_overlay(powered_overlay)
		place_in_list++

/obj/structure/sigsystem/circuit/and_gate/ConditionCheckSig()
	. = TRUE
	var/false_found = FALSE
	for(var/i in sig_conditions)
		if(sig_conditions[i] == 1)
			false_found = TRUE
			break
	if(false_found)
		return FALSE

/obj/structure/sigsystem/circuit/and_gate/LoadSignallers()
	. = ..()
	tri_sigdev = new(src)
	tri_sigdev.set_frequency(signaller_freq)
	tri_sigdev.code = tri_signaller_code

	AddCondition(tri_signaller_code)

/*
* Gate with 3 inputs.
* After this you may need to hook up several gates
* to facilitate conditions larger than three.
*/

/obj/structure/sigsystem/circuit/and_gate/three_input
	icon_state = "andgate_tri"
	desc = "A circuit that sends out a signal when supplied with three different signals."
	//Signaller Three: Recieves Signal
	var/quad_signaller_code = 141
	var/obj/item/assembly/signaler/system/quad_sigdev

/obj/structure/sigsystem/circuit/and_gate/three_input/LoadSignallers()
	. = ..()
	quad_sigdev = new(src)
	quad_sigdev.set_frequency(signaller_freq)
	quad_sigdev.code = quad_signaller_code

	AddCondition(quad_signaller_code)

/*
* Adapted Sigsystem Structures/Machinery
*/

/*------------\
|SIGNAL BUTTON|
\------------*/
/obj/machinery/button/sigsystem
	device_type = /obj/item/assembly/signaler/system
	var/signaller_freq = FREQ_PRESSURE_PLATE
	var/signaller_code = 111

/obj/machinery/button/sigsystem/setup_device()
	if(istype(device, /obj/item/assembly/signaler/system))
		var/obj/item/assembly/signaler/system/A = device
		A.set_frequency(signaller_freq)
		A.code = signaller_code
	initialized_button = 1

/*-----------\
|SIGNAL CHEST| Bit sloppy
\-----------*/
/obj/structure/closet/crate/sigsystem
	name = "system crate"
	desc = "A rectangular steel crate. Seems to be wired to be unlocked remotely."
	anchored = TRUE
	anchorable = TRUE
	var/obj/item/assembly/signaler/system/sigdev
	var/signaller_freq = FREQ_PRESSURE_PLATE
	var/signaller_code = 111
	var/obj/item/assembly/signaler/system/lock_sigdev
	var/lock_signaller_freq = FREQ_PRESSURE_PLATE
	var/lock_signaller_code

/obj/structure/closet/crate/sigsystem/Initialize()
	. = ..()
	if(lock_signaller_code)
		if(!locked)
			locked = TRUE
		lock_sigdev = new(src)
		lock_sigdev.set_frequency(lock_signaller_freq)
		lock_sigdev.code = lock_signaller_code
	sigdev = new(src)
	sigdev.set_frequency(signaller_freq)
	sigdev.code = signaller_code

/obj/structure/closet/crate/sigsystem/after_open(mob/living/user, force = FALSE)
	//No i must hide the sigdev before they see the wires.
	if(sigdev)
		sigdev.signal()
		qdel(sigdev)
	if(lock_sigdev)
		qdel(lock_sigdev)

/obj/structure/closet/crate/sigsystem/proc/pulse(code)
	if(code == lock_signaller_code && locked)
		locked = FALSE
		update_icon()

/*---------------\
|SIGNAL DOOR/WALL| Bit sloppy, just copied puzzle_pieces.dm code
\---------------*/
/obj/machinery/door/keycard/sigsystem
	name = "locked door"
	desc = "This doors lock seems to be connected to a trigger somewhere nearby. It looks virtually indestructable."
	var/obj/item/assembly/signaler/system/sigdev
	var/signaller_freq = FREQ_PRESSURE_PLATE
	var/signaller_code = 111

/obj/machinery/door/keycard/sigsystem/Initialize()
	. = ..()
	sigdev = new(src)
	sigdev.set_frequency(signaller_freq)
	sigdev.code = signaller_code

/obj/machinery/door/keycard/sigsystem/proc/pulse(code)
	if(code == signaller_code)
		if(density)
			open()
		else
			close()
