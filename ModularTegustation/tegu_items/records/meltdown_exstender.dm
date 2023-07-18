//Meltdown Exstender Watch
//Unlike other watches this is used on an object directly thus its calls and procs are working differently
/obj/item/records/meltdown_exstender
	name = "records wood watch"
	desc = "A treaded wooden watch for that when next to a abnormality console and wound will give additional time before meltdown."
	icon_state = "watch_wood"
	//Default cooldown is 5 Minutes
	records_cooldown_timer = 5 MINUTES
	/*
	Are fancy gimmic is that we when used on a work console will give in seconds,
	more time before a meltdown happens.
	For more documentationa and information see code/game/machinery/computer/abnormality_work.dm

	By default we add 30 seconds to a meltdown timer
	*/
	var/meltdowntimer_increase = 30

/obj/item/records/meltdown_exstender/watch_action(mob/user)
	//Shadow var to count if we were successful in getting a computer in are view
	var/CA_count = 0
	//Gather every console in are tile and its connected 8
	for(var/obj/machinery/computer/abnormality/CA in oview(1))
		//A simple safty check to make sure we do not count non-abnormalities
		if(CA.datum_reference)
			//Add every time we successfully do this to are CA_count
			/*
			A set of 3 TRUE if statment
			1: If we can meltdown
			2: If we *are* melting down currently
			3: If are meltdown time is greater then 0
			*/
			if(CA.can_meltdown && CA.meltdown && CA.meltdown_time > 0)
				//The watch itself has the time increase, we grab it and add that (in seconds)
				CA.meltdown_time += meltdowntimer_increase
				//Give feedback and tell the user how much time left
				to_chat(user,"<span class='warning'>You increase the time left untill a meltdown to: [CA.meltdown_time] on [CA.datum_reference.name]'s console.</span>")
				//This was a successful use of the watch, add it to the console counter
				CA_count++
			else
				//The unit does not need its timer exstended, give again feedback of this.
				to_chat(user,"<span class='warning'>This abnormality is not in a meltdown.</span>")

	if(CA_count > 0 && records_cooldown_timer && usable)
		//We have a cooldown, so first to not cheat the player out of time we first start the cooldown timer
		//If we have more then console in are view then increase are cooldown by that count. This is to keep the watches cost constant
		addtimer(CALLBACK(src, .proc/reset), (records_cooldown_timer * CA_count))
		//Set the watch to not be usable as we are now on cooldown
		usable = FALSE
	else
		//We dont have any consoles around us, give feedback to the player so they better know how to use the watch
		to_chat(user,"<span class='warning'>Their is no vaild close by console for the watch to use its affects.</span>")


	//We handle are cooldown in areself, no need to call parrent
	return
