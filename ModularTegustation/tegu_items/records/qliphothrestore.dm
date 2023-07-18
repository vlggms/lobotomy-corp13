//Increases if applicable the qliphoth by 1
/obj/item/records/qliphoth_repair
	name = "records platinum watch"
	desc = "A shiney platinum watch the records officer can use to restore an abnormality qliphoth counter if possable, must be used next to a console."
	icon_state = "watch_platinum"
	//By default we can only restore every 15 mins
	records_cooldown_timer = 15 MINUTES
	//By defeault we restore one Qliphoth Counter
	var/restore_qliphoth_counter_amount = 1

/obj/item/records/qliphoth_repair/watch_action(mob/user)
	//Shadow var to count if we were successful in getting a computer in are view
	var/CA_count = 0
	//Gather every console in are tile and its connected 8
	for(var/obj/machinery/computer/abnormality/CA in oview(1))
		//A simple safty check to make sure we do not count non-abnormalities
		if(CA.datum_reference)
			//Add every time we successfully do this to are CA_count
			CA_count++
			//Tell are grabbed CA to go to its refence, and change its Qliphoth charge by the amount the watch restores, also give us feedback
			CA.datum_reference.qliphoth_change(restore_qliphoth_counter_amount, user, always_give_feedback = TRUE)

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

