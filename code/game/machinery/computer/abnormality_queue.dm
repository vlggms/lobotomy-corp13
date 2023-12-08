/obj/machinery/computer/abnormality_queue
	name = "abnormality queue console"
	desc = "Used to select and view queued abnormality extraction process."
	resistance_flags = INDESTRUCTIBLE
	var/locked = FALSE

/obj/machinery/computer/abnormality_queue/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality_queue/Destroy()
	GLOB.lobotomy_devices -= src
	..()

/obj/machinery/computer/abnormality_queue/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AbnormalityQueue")
		ui.open()

/obj/machinery/computer/abnormality_queue/ui_data(mob/user)
	var/list/data = list()
	data["current"] = "ERROR - Please yell at coders"
	data["enablehardcore"] = SSabnormality_queue.hardcore_roll_enabled

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
	if(locked)
		to_chat(usr, span_boldwarning("The selected Abnormality cannot be changed."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	switch(action)
		if("change_current")
			var/param = params["change_current"]
			var/mob/living/simple_animal/hostile/abnormality/target_type = text2path(param)

			if(!ispath(target_type)) // Should never happen
				to_chat(usr, span_warning("Extraction request has been denied."))
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE

			if(!(target_type in SSabnormality_queue.picking_abnormalities))
				to_chat(usr, span_warning("Your Extraction request has timed out. Retry."))
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				updateUsrDialog() // Forcibly update it, in case someone doesn't understand why it won't work
				return FALSE

			UpdateAnomaly(target_type, "changed", FALSE)
		if("lets_roll")
			var/mob/living/simple_animal/hostile/abnormality/target_type = pick(SSabnormality_queue.picking_abnormalities)
			UpdateAnomaly(target_type, "lets rolled", FALSE)
		if("fuck_it_lets_roll")
			var/mob/living/simple_animal/hostile/abnormality/target_type = SSabnormality_queue.GetRandomPossibleAbnormality()
			UpdateAnomaly(target_type, "fucked it lets rolled", TRUE)
		if("hardcore_fuck_it_lets_roll")
			if (SSabnormality_queue.hardcore_roll_enabled)
				var/mob/living/simple_animal/hostile/abnormality/target_type = pick(pick(SSabnormality_queue.possible_abnormalities))
				UpdateAnomaly(target_type, "hardcore fucked it and rolled", TRUE)
			else
				message_admins("[usr] has managed to send a TGUI signal to hardcore fuck it and roll despite the option being disabled. This is indicative of hacking.")

	update_icon()

/obj/machinery/computer/abnormality_queue/proc/UpdateAnomaly(mob/living/simple_animal/hostile/abnormality/target_type, logstring, lock_after)
	SSabnormality_queue.queued_abnormality = target_type
	to_chat(usr, span_boldnotice("[initial(target_type.name)] has been selected."))
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	log_game("[usr] has [logstring] the anomaly to [initial(target_type.name)].")
	if(lock_after)
		message_admins("[usr] has [logstring] the anomaly to [initial(target_type.name)].")
		locked = TRUE
		// PE awarded for yellow roll - just as kirie had wanted.
		SSlobotomy_corp.available_box += 250
		to_chat(usr, span_boldnotice("A random Abnormality has been selected. L Corp HQ has reimbursed you for the costs of extracting a specific Abnormality."))
		SSabnormality_queue.AnnounceLock()
		SSabnormality_queue.ClearChoices()
		SStgui.close_uis(src) // Hacky solution but I don't care
		var/datum/tgui/ui = new(usr, src, "AbnormalityQueue")
		ui.open()
		SStgui.try_update_ui(usr, src, ui)

	return

/obj/machinery/computer/abnormality_queue/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)

/obj/machinery/computer/abnormality_queue/proc/ChangeLock(lockstatus)
	locked = lockstatus
	return
