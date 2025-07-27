//Records watch base item
/obj/item/records
	name = "uncaliberated watch"
	desc = "A watch that is not meant to exists, please content LCorp Development and report how you got this!"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "watch_template"
	//Used as a check for cooldowns
	var/usable = TRUE
	//Cooldown for using the watch again, we default this as ten minutes
	var/records_cooldown_timer = 10 MINUTES

//This is when a player clicks the watch in hand
/obj/item/records/attack_self(mob/user)
	//We ask if are user is infact able to use the watch
	if(watch_checks(user))
		//We now do the watch action, as we are able to use this watch
		watch_action(user)

//When someone looks are are watch, we want to give them feedback
/obj/item/records/examine(mob/user)
	. = ..()
	//We want to make sure that the watch here always gives you useful information.
	//So we need to check if it can or not be used
	if(usable)
		//Give the short and sweet feedback that we can be used, no fluff
		. += "[src.name] is ready to be used."
	else
		//We want to make sure that the failed verson is different enuff that at a glance someone can tell
		. += "[src.name] can not currently be used."


//This is used to make sure that are records watch is able to be used by the player
/obj/item/records/proc/watch_checks(mob/user)
	//First we check if they are a Records Officer
	if(user?.mind?.assigned_role != "Records Officer")
		//We were not the RO so give feedback and fail the check
		to_chat(user, span_warning("You cannot use this!"))
		return FALSE
	//Make sure are current records watch is not on cooldown
	if(!usable)
		//We were on cooldown so fail the check and give feedback
		to_chat(user, span_warning("It hasn't recharged yet!"))
		return FALSE
	//We passed the checks thus we return true
	return TRUE

//Base proc for watch actions, this is also were we give are cooldown
/obj/item/records/proc/watch_action(mob/user)
	//Ask if we do infact have a cooldown or not
	if(records_cooldown_timer)
		//We have a cooldown, so first to not cheat the player out of time we first start the cooldown timer
		addtimer(CALLBACK(src, PROC_REF(reset)), records_cooldown_timer)
		//Set the watch to not be usable as we are now on cooldown
		usable = FALSE

//Reset base proc for watches
/obj/item/records/proc/reset()
	//We first tell are watch we can be used again
	usable = TRUE
	//Give everyone around the watch feedback that the watch can be used again
	audible_message(span_notice("[src] is ready to use!"))
	//Additional sound feedback for people that dont read chat, and have sound on
	playsound(get_turf(src), 'sound/machines/dun_don_alert.ogg', 50, TRUE)
