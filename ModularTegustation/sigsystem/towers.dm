
	/*--------------------------\
	|Short Range Sigsystem Tower|
	\--------------------------*/

/obj/structure/sigsystem/tower
	name = "short-range system tower"
	desc = "A tower for short ranged pings between other towers."
	icon_state = "radio"
	//The code we check other towers for
	var/signal_code
	//The effective range of our tower
	var/signal_range = 7
	//Any special data contained in the signal, is used for and-gates
	var/signal_data
	//If the tower does not recieve pings and only sends them out.
	var/transmitter = FALSE
	//All towers that exist and initialized correctly
	var/static/list/towers

/obj/structure/sigsystem/tower/Initialize()
	. = ..()
	RegisterAsTower()

/obj/structure/sigsystem/tower/Destroy()
	towers -= src
	return ..()

/*
* If pinged from a tower, ping physically
* if pinged physically, ping a tower
* A tower pinging a tower without any inbetween
* functions seem redundant.
*/
/obj/structure/sigsystem/tower/ReceivePing(was_tower = FALSE, incoming_data)
	if(transmitter)
		return
	if(was_tower)
		PingDirection(dir)
		return
	PingTower(signal_code, signal_range, signal_data)

/obj/structure/sigsystem/tower/proc/RegisterAsTower()
	if(transmitter)
		return

	if(!towers)
		towers = list(src)
		return
	towers += src

/obj/structure/sigsystem/tower/proc/PingTower(code, range, data)
	if(!code || !signal_code)
		return FALSE
	for(var/obj/structure/sigsystem/tower/reciever in towers)
		if(!reciever)
			towers -= reciever
			continue
		if(reciever == src)
			continue
		if(reciever.signal_code == code)
			if(z != reciever.z)
				continue
			var/distance = get_dist(src, reciever)
			if(distance > range)
				continue
			reciever.ReceivePing(TRUE, data)

	/*--------------\
	|SIGNAL AND-GATE|
	\---------------/
* Functions like a Minecraft redstone AND_Gate
*/

/obj/structure/sigsystem/tower/and_gate
	name = "sigsystem and-gate"
	desc = "A tower that sends out a signal when supplied with two different signals."
	icon_state = "andgate"
	//Just in the case you want to show progress
	invisibility = SEE_INVISIBLE_MINIMUM
	//The code sent out by the gate when all conditions are met.
	var/activation_code
	//If repeating the same signal switches a ON status to OFF
	var/switch_off = FALSE
	//If the tower should immidiately send a signal when all sig conditions are good.
	var/send_on_success = FALSE
	//conditions before pinging
	var/list/sig_conditions = list(
		"one" = 1,
		"two" = 1,
		)

/obj/structure/sigsystem/tower/and_gate/update_icon_state()
	cut_overlays()
	var/place_in_list = 1
	for(var/i in sig_conditions)
		if(sig_conditions[i] == 2)
			var/mutable_appearance/powered_overlay = mutable_appearance(icon, "andgate_[place_in_list]")
			add_overlay(powered_overlay)
		place_in_list++

/obj/structure/sigsystem/tower/and_gate/ReceivePing(was_tower = FALSE, incoming_data)
	if(was_tower)
		var/code_value = "[incoming_data]"
		var/code_value2 = sig_conditions[code_value]
		if(code_value2)
			switch(code_value2)
				if(1)
					sig_conditions[code_value] = 2
				if(2)
					if(switch_off)
						sig_conditions[code_value] = 1
		update_icon_state()
		if(ConditionCheckSig() && send_on_success)
			PingTower(activation_code, signal_range, signal_data)
			return TRUE
		return FALSE
	/*
	* Shamefully i made it so that the and_gate requires
	* a ping from a non tower in order to check its conditions.
	* This is for puzzles that have multiple signals being input
	* at once so that if one signal is true it wont unlock
	* the door before the second signal makes it false.
	*/
	if(ConditionCheckSig() && !send_on_success)
		PingTower(activation_code, signal_range, signal_data)
		return TRUE

/obj/structure/sigsystem/tower/and_gate/proc/ConditionCheckSig()
	. = TRUE
	var/false_found = FALSE
	for(var/i in sig_conditions)
		if(sig_conditions[i] == 1)
			false_found = TRUE
			break
	if(false_found)
		return FALSE

/*
* Gate with 3 inputs.
* After this you may need to hook up several gates
* to facilitate conditions larger than three.
*/

/obj/structure/sigsystem/tower/and_gate/three_input
	icon_state = "andgate_tri"
	desc = "A circuit that sends out a signal when supplied with three different signals."
	sig_conditions = list(
		"one" = 1,
		"two" = 1,
		"three" = 1,
		)

	/*----------\
	|Keypad Code|
	\----------*/
/obj/structure/sigsystem/tower/keypad
	name = "keypad"
	desc = "A panel requesting a password."
	icon_state = "keypad"
	invisibility = SEE_INVISIBLE_MINIMUM
	transmitter = TRUE
	//Signal produced when incorrect password.
	var/fail_signal_code
	//Solution
	var/code_soln = "1234"

/obj/structure/sigsystem/tower/keypad/attack_hand(mob/living/user)
	..()
	var/user_input = input(user,"Type in Code:", "Type in Code") as text|null
	if(!user_input)
		return
	if(!user.canUseTopic(src, BE_CLOSE))
		to_chat(user, span_notice("You attempted to input the code from a distance. You need to stand next to the keypad."))
		return
	InputCheck(user_input)

/obj/structure/sigsystem/tower/keypad/proc/InputCheck(input_code = "0000")
	if(input_code != code_soln)
		if(fail_signal_code)
			PingTower(fail_signal_code, signal_range, signal_data)
		return
	PingTower(signal_code, signal_range, signal_data)
	return

	/*------------\
	|SIGNAL BUTTON|
	\-------------/
* Reinventing buttons. Unfortunately
* with towers since i dont know how to
* make the icon not obviously pointing
*/
/obj/structure/sigsystem/tower/button
	name = "button"
	desc = "A remote control switch."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl"
	invisibility = SEE_INVISIBLE_MINIMUM
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	transmitter = TRUE
	var/skin = "doorctrl"

/obj/structure/sigsystem/tower/button/update_icon_state()
	icon_state = skin

/obj/structure/sigsystem/tower/button/attack_ai(mob/user)
	return attack_hand(user)

/obj/structure/sigsystem/tower/button/attack_robot(mob/user)
	return attack_ai(user)

/obj/structure/sigsystem/tower/button/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	ButtonEffect()

	flick("[skin]1", src)

/obj/structure/sigsystem/tower/button/proc/ButtonEffect()
	PingTower(signal_code, signal_range, signal_data)
