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

/obj/item/assembly/signaler/system/receive_signal(datum/signal/signal)
	if(!signal)
		return FALSE
	if(signal.data["code"] != code)
		return FALSE
	//Shameful Code
	for(var/obj/structure/sigsystem/A in get_turf(src))
		A.pulse()
	return TRUE
