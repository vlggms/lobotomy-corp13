/obj/machinery/computer/abnormality_queue
	name = "abnormality queue console"
	desc = "Used to select and view queued abnormality extraction process."
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/computer/abnormality_queue/Initialize()
	. = ..()
	GLOB.abnormality_queue_consoles += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality_queue/Destroy()
	GLOB.abnormality_queue_consoles -= src
	..()

/obj/machinery/computer/abnormality_queue/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AbnormalityQueue")
		ui.open()

/obj/machinery/computer/abnormality_queue/ui_data(mob/user)
	var/list/data = list()
	data["current"] = "ERROR - Please yell at coders"

	if(!LAZYLEN(SSabnormality_queue.picking_abnormalities) && !ispath(SSabnormality_queue.queued_abnormality))
		data["current"] = "ERROR - No data. Please try again later."

	if(ispath(SSabnormality_queue.queued_abnormality))
		var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality
		data["current"] = "[initial(queued_abno.name)]"
		data["colorcurrent"] = "[THREAT_TO_CSS_COLOR[initial(queued_abno.threat_level)]]"
		data["threatcurrent"] = "[THREAT_TO_NAME[initial(queued_abno.threat_level)]]"

	if(LAZYLEN(SSabnormality_queue.picking_abnormalities))
		var/list/choices = list()

		for(var/type in SSabnormality_queue.picking_abnormalities)
			var/mob/living/simple_animal/hostile/abnormality/abno = type
			choices.Add("[initial(abno.name)]")
			data["[initial(abno.name)]"] = type
			data["color[initial(abno.name)]"] = "[THREAT_TO_CSS_COLOR[initial(abno.threat_level)]]"
			data["threat[initial(abno.name)]"] = "[THREAT_TO_NAME[initial(abno.threat_level)]]"

		data["choices"] = choices

	return data

/obj/machinery/computer/abnormality_queue/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("change_current")
			var/param = params["change_current"]
			var/mob/living/simple_animal/hostile/abnormality/target_type = text2path(param)

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
			log_game("[usr] has changed the queued anomaly to [initial(target_type.name)].")

	update_icon()

/obj/machinery/computer/abnormality_queue/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
