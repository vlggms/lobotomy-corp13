/*
* Sigsystem, originally made with signals now made more directional.
*/

/obj/structure/sigsystem
	name = "incomplete sigsystem"
	desc = "Someone tried to make a signal system here."
	icon_state = "wires"
	icon = 'ModularTegustation/Teguicons/sigsystem_icons.dmi'
	density = FALSE
	anchored = TRUE
	invisibility = INVISIBILITY_ABSTRACT
	/*
	* To prevent infinite loops im setting
	* a limit on the amount of pings
	* that can occur in a certain amount of time.
	* mainly here to prevent infinite loops.
	*/
	var/nextfailsafe_reset = 0
	var/failsafe_fire_allowance = 0
	/*
	* If the connector can only work once.
	*/
	var/happens_once = FALSE
	var/fired = FALSE
	//Used in deployer and projectile launchers to prevent infinite fire.
	var/fire_cooldown = 0
	var/fire_delay = 3

/obj/structure/sigsystem/proc/PingDirection(front = dir)
	fired = TRUE
	var/turf/T = get_step(src, front)
	for(var/obj/structure/sigsystem/S in T)
		if(S)
			S.ReceivePing(FALSE)
	return TRUE

/obj/structure/sigsystem/proc/ReceivePing()
	failsafe_fire_allowance++
	if(nextfailsafe_reset < world.time)
		nextfailsafe_reset = world.time + 10
		failsafe_fire_allowance = 0
	if(failsafe_fire_allowance > 20)
		return FALSE
	PingDirection(dir)
	return TRUE

	/*--------\
	|CONNECTOR|
	\---------/
* Connectors are the inbetween of
* systems that run most of the
* buffering, delaying, or repeating
*/

/obj/structure/sigsystem/connector
	name = "system connector"
	icon_state = "connector"
	//repeating function
	var/repeat_amt = 1
	/*
	* amount of buffer signals
	* required for one signal
	*/
	var/buffer_amt
	var/buffer_req
	/*
	* Time between the moment
	* the signal is called and when it fires.
	*/
	var/delay_time = 0

/obj/structure/sigsystem/connector/PingDirection(front = dir)
	buffer_amt = 0
	return ..()

/obj/structure/sigsystem/connector/ReceivePing()
	buffer_amt++
	if(happens_once && fired)
		return
	if(buffer_amt < buffer_req)
		return
	fired = TRUE
	if(repeat_amt > 1 || delay_time)
		INVOKE_ASYNC(src, PROC_REF(TruePing))
		return
	PingEffect(dir)

/obj/structure/sigsystem/connector/proc/TruePing()
	for(var/i = 1 to repeat_amt)
		//Unsure if i should use sleep here -IP
		if(delay_time)
			sleep(delay_time)
		PingEffect()

/obj/structure/sigsystem/connector/proc/PingEffect()
	PingDirection()

//A connector that pings infront of and behind itself
/obj/structure/sigsystem/connector/split
	icon_state = "connector_twoway"

/obj/structure/sigsystem/connector/split/PingEffect(front = dir)
	PingDirection()
	PingDirection(turn(dir, 180))

	/*---------------\
	|Assembly Adaptor|
	\----------------/
* Mostly its just a door opener using the
* control assembly which only requires a
* matching id var.
*/
/obj/structure/sigsystem/adaptor
	name = "signal system adaptor"
	desc = "An adaptor to bridge the divide between different systems."
	icon_state = "device"
	invisibility = INVISIBILITY_ABSTRACT
	var/obj/item/assembly/device = null
	var/device_type = /obj/item/assembly/control
	//ID for door if using airlock control assemblys
	var/device_id
	//Dont know what this is but doors dont seem to respond without it.
	var/sync_doors = TRUE

/obj/structure/sigsystem/adaptor/Initialize(mapload)
	. = ..()

	if(!device && device_type)
		device = new device_type(src)

	SetUpDevice()

/obj/structure/sigsystem/adaptor/ReceivePing()
	if(device)
		ActivateDevice()

/obj/structure/sigsystem/adaptor/proc/SetUpDevice()
	if(device && istype(device, /obj/item/assembly/control))
		var/obj/item/assembly/control/C = device
		C.id = device_id
		C.sync_doors = sync_doors

/obj/structure/sigsystem/adaptor/proc/ActivateDevice()
	if(istype(device, /obj/item/assembly/control))
		device.pulsed()
	if(istype(device, /obj/item/assembly/signaler))
		var/obj/item/assembly/signaler/sigdev = device
		sigdev.signal()

	/*----------\
	| SIGNALLER |
	\-----------/
* For sending and recieving signals
*/
/obj/structure/sigsystem/adaptor/signaller
	name = "signaller"
	desc = "A signaller hybridized with some machine."
	icon_state = "signal"
	device_type = /obj/item/assembly/signaler
	var/signaller_freq = FREQ_PRESSURE_PLATE
	//Output signaller code
	var/signaller_code
	//Input signaller code
	var/input_signaller_code
	var/datum/radio_frequency/radio_connection

//sloppy duplicate of /tower proc
/obj/structure/sigsystem/adaptor/signaller/ReceivePing(was_signaller = FALSE)
	if(was_signaller)
		PingDirection(dir)
		return
	ActivateDevice()

/obj/structure/sigsystem/adaptor/signaller/Initialize()
	. = ..()
	set_frequency(signaller_freq)

/obj/structure/sigsystem/adaptor/signaller/Destroy()
	SSradio.remove_object(src,signaller_freq)
	. = ..()

/obj/structure/sigsystem/adaptor/signaller/SetUpDevice()
	if(device)
		PrepSignaller(device, signaller_code)

/obj/structure/sigsystem/adaptor/signaller/receive_signal(datum/signal/signal)
	if(!signal)
		return FALSE
	if(signal.data["code"] != input_signaller_code)
		return FALSE

	ReceivePing(was_signaller = TRUE)
	return TRUE

/obj/structure/sigsystem/adaptor/signaller/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, signaller_freq)
	signaller_freq = new_frequency
	radio_connection = SSradio.add_object(src, signaller_freq, RADIO_SIGNALER)
	return

/obj/structure/sigsystem/adaptor/signaller/proc/PrepSignaller(obj/item/assembly/signaler/signal_device, sig_code)
	if(sig_code)
		signal_device = new(src)
		signal_device.set_frequency(signaller_freq)
		signal_device.code = sig_code

/obj/structure/sigsystem/adaptor/signaller/proc/signal()
	if(!radio_connection)
		return

	var/logging_data

	var/datum/signal/signal = new(list("code" = input_signaller_code), logging_data = logging_data)
	radio_connection.post_signal(src, signal)

	/*------------------\
	|Sigsystem Announcer|
	\------------------*/
/obj/structure/sigsystem/announcer
	name = "signal system announcer"
	desc = "A structure that produces sounds or messages upon recieving a signal."
	icon_state = "announcer"
	invisibility = INVISIBILITY_ABSTRACT
	happens_once = TRUE
	var/message
	var/sound
	var/sound_volume = 30
	var/message_range = 2

/obj/structure/sigsystem/announcer/ReceivePing()
	if(sound)
		playsound(get_turf(src),sound,sound_volume,FALSE,3)

	if(message)
		for(var/mob/living/L in view(message_range, src))
			if(L.client)
				to_chat(L, span_boldwarning("[message]"))
	if(happens_once)
		qdel(src)

	/*-----------------------\
	|Trap Projectile Launcher|
	\-----------------------*/
/obj/structure/sigsystem/projectile_launcher
	name = "launching mechanism"
	desc = "A hole that launches a projectile when supplied with a signal."
	icon_state = "hole"

	var/projectile_type = /obj/projectile/bullet/shotgun_beanbag
	var/projectile_sound = 'sound/weapons/sonic_jackhammer.ogg'

/obj/structure/sigsystem/projectile_launcher/ReceivePing()
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
	icon_state = "spawner"
	happens_once = TRUE

	var/atom_path
	var/atom_rename
	var/deploy_sound
	var/spawn_flavor_text
	//Cords are offset from current position.
	var/spawn_dist_x = 0
	var/spawn_dist_y = 0

/obj/structure/sigsystem/deployer/ReceivePing()
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
