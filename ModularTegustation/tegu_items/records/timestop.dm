//Timefreeze records watch
/obj/item/records/timestop
	name = "records golden watch"
	desc = "A golden watch the records officer can use to stop time temporarily."
	icon_state = "watch_gold"
	var/usable = TRUE


/obj/item/records/timestop/attack_self(mob/user)
	if(user.mind.assigned_role != "Records Officer")
		to_chat(user, "<span class='warning'>You cannot use this!")
		return
	if(!usable)
		to_chat(user, "<span class='warning'>It hasn't recharged yet!")
		return
	new /obj/effect/timestop(get_turf(user), 3, 110, list(user))	//Stop for 10 seconds
	addtimer(CALLBACK(src, .proc/reset), 10 MINUTES)
	usable = FALSE

/obj/item/records/timestop/proc/reset()
	usable = TRUE
	audible_message("<span class='notice'>[src] is ready to use!</span>")
	playsound(get_turf(src), 'sound/machines/dun_don_alert.ogg', 50, TRUE)
