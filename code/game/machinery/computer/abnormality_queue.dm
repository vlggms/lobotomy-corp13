/obj/machinery/computer/abnormality_queue
	name = "abnormality queue console"
	desc = "Used to select and view queued abnormality extraction process."
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/computer/abnormality_queue/ui_interact(mob/user)
	. = ..()
	var/dat
	if(ispath(SSabnormality_queue.queued_abnormality))
		var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality
		dat += "<b>Currently queued:</b><br>"
		dat += "<b><span style='color: [THREAT_TO_COLOR[initial(queued_abno.threat_level)]]'>\[[THREAT_TO_NAME[initial(queued_abno.threat_level)]]\]</span> [initial(queued_abno.name)]</b><br><br>"
	if(LAZYLEN(SSabnormality_queue.picking_abnormalities))
		for(var/type in SSabnormality_queue.picking_abnormalities)
			var/mob/living/simple_animal/hostile/abnormality/abno = type
			dat += " <A href='byond://?src=[REF(src)];queue=[abno]'>\[[THREAT_TO_NAME[initial(abno.threat_level)]]\] [initial(abno.name)]</A><br>"
	var/datum/browser/popup = new(user, "abno_queue", "Abnormality Queue Console", 400, 260)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/abnormality_queue/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["queue"])
			var/mob/living/simple_animal/hostile/abnormality/target_type = text2path(href_list["queue"])
			if(!ispath(target_type)) // Should never happen
				to_chat(usr, "<span class='warning'>Extraction request has been denied.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			if(!(target_type in SSabnormality_queue.picking_abnormalities))
				to_chat(usr, "<span class='warning'>Extraction request has timed out. Retry.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				updateUsrDialog() // Forcibly update it, in case someone doesn't understand why it won't work
				return FALSE
			SSabnormality_queue.queued_abnormality = target_type
			to_chat(usr, "<span class='notice'>[initial(target_type.name)] has been selected.</span>")
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE
