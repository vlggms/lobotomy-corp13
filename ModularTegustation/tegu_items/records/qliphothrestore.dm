//Increases if applicable the qliphoth by 1
/obj/item/records/qliphoth_repair
	name = "records platinum watch"
	desc = "A shiney platinum watch the records officer can use to restore an abnormality qliphoth counter if possable."
	icon_state = "watch_platinum"
	var/usable = TRUE

/obj/item/records/qliphoth_repair/attack_self(mob/user)
	if(user.mind.assigned_role != "Records Officer")
		to_chat(user, "<span class='warning'>You cannot use this!")
		return
	if(!usable)
		to_chat(user, "<span class='warning'>It hasn't recharged yet!")
		return
	to_chat(user, "<span class='warning'>The watch is ready to be used.")

/obj/item/records/qliphoth_repair/proc/cooldown()
	addtimer(CALLBACK(src, .proc/reset), 10 MINUTES)
	usable = FALSE

/obj/item/records/qliphoth_repair/proc/reset()
	usable = TRUE
	audible_message("<span class='notice'>[src] is ready to use!</span>")
	playsound(get_turf(src), 'sound/machines/dun_don_alert.ogg', 50, TRUE)

