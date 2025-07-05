/*
* /-----------------\
* |SYSTEM SIGNALLERS|
* \-----------------/
* SS13 anomalies (pyrostatic anomalies)
* use specialized subtypes of signallers
* /obj/item/assembly/signaler/anomaly to
* create the mechanic of signaller signals
* deactivating anomalies. However the
* inner mechanics of the anomaly signaller
* is the signaller simply deactivating
* all anomalies on the turf it exists on.
* Im sorry to make it even more complicated and stupid.
*/
/obj/item/assembly/signaler/system
	name = "system_signaller"
	desc = "A signaller reworked into a mechanical component. Strangely you feel alot of frusteration and hate emenating from this item."
	icon_state = "anomaly_core"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	resistance_flags = FIRE_PROOF
	silent = TRUE
	hearing_range = 0
	//Alter this to limit the range of devices that can ping this signaller
	var/effective_range = 10

/obj/item/assembly/signaler/system/signal()
	if(!radio_connection)
		return

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	var/coords = "???"
	if(T)
		coords = "[T.x],[T.y],[T.z]"

	var/logging_data
	if(usr)
		logging_data = "[time] <B>:</B> [usr.key] used [src] @ location ([coords]) <B>:</B> [format_frequency(frequency)]/[code]"
		GLOB.lastsignalers.Add(logging_data)

	var/datum/signal/signal = new(list("code" = code), logging_data = logging_data)
	radio_connection.post_signal(src, signal, range = effective_range)


/obj/item/assembly/signaler/system/receive_signal(datum/signal/signal)
	if(!signal)
		return FALSE
	if(signal.data["code"] != code)
		return FALSE
	//Shameful Code
	for(var/obj/structure/S in get_turf(src))
		if(istype(S, /obj/structure/sigsystem))
			var/obj/structure/sigsystem/A = S
			A.pulse(code)
		/*
		* My two options were to remake crates in the
		* sigsystem or make a crate subtype.
		* Suggestions on better code are welcome. -IP
		*/
		if(istype(S, /obj/structure/closet/crate/sigsystem))
			var/obj/structure/closet/crate/sigsystem/C = S
			C.pulse(code)
	for(var/obj/machinery/door/M in get_turf(src))
		if(istype(M, /obj/machinery/door/keycard/sigsystem))
			var/obj/machinery/door/keycard/sigsystem/D = M
			D.pulse(code)

	return TRUE
