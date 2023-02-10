//RO meltdown watch
//Slows meltdown
/obj/item/records/abnodelay
	name = "records bronze watch"
	desc = "A bronze watch the records officer can use to increase the time it takes for the next abnormality to arrive."
	icon_state = "watch_bronze"
	var/usable = TRUE

/obj/item/records/abnodelay/attack_self(mob/user)
	if(!usable)
		to_chat(user, "<span class='notice'>It's not ready yet.</span>")
		return
	if(user.mind.assigned_role != "Records Officer")
		to_chat(user, "<span class='warning'>You cannot use this!")
		return

	usable = FALSE
	to_chat(user, "<span class='notice'>You check your watch. It's not time for the next abnormality to arrive yet.</span>")
	SSabnormality_queue.next_abno_spawn += 5 MINUTES
	addtimer(CALLBACK(src, .proc/reset), 30 MINUTES)

/obj/item/records/abnodelay/proc/reset()
	usable = TRUE
	audible_message("<span class='notice'>[src] is ready to use!</span>")
	playsound(get_turf(src), 'sound/machines/dun_don_alert.ogg', 50, TRUE)
