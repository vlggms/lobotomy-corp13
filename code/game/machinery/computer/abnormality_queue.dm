/obj/machinery/computer/abnormality_queue
	name = "abnormality queue console"
	desc = "Used to select and view queued abnormality extraction process."
	resistance_flags = INDESTRUCTIBLE
	var/locked = FALSE
	var/display_threat = FALSE

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
	data["enablehardcore"] = SSabnormality_queue.hardcore_roll_enabled
	data["pe_dif"] = SSabnormality_queue.owed_pe > 0 ? "+[SSabnormality_queue.owed_pe]" : SSabnormality_queue.owed_pe == 0 ? "0" : "[SSabnormality_queue.owed_pe]"

	if(!ispath(SSabnormality_queue.queued_abnormality))
		data["current"] = "ERROR - No data. Please try again later."

	if(ispath(SSabnormality_queue.queued_abnormality))
		var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality
		data["current"] = "[initial(queued_abno.name)]"
		data["colorcurrent"] = "[THREAT_TO_CSS_COLOR[initial(queued_abno.threat_level)]]"
		data["threatcurrent"] = "[THREAT_TO_NAME[initial(queued_abno.threat_level)]]"

	if(LAZYLEN(SSabnormality_queue.manual_available_levels) && !locked)
		var/list/choices = list()
		data["display_abnos"] = display_threat > 0
		if(!display_threat)
			for(var/threat in SSabnormality_queue.manual_available_levels)
				var/threat_name = THREAT_TO_NAME[threat]
				choices.Add("[threat_name]")
				data["[threat_name]"] = threat
				data["color[threat_name]"] = "[THREAT_TO_CSS_COLOR[threat]]"
				var/cost = GetCost(threat)
				data["cost[threat_name]"] = SSabnormality_queue.spawned_abnos == 0 ? "0" : cost > 0 ? "+[cost]" : "[cost]"
		else
			for(var/type in SSabnormality_queue.possible_abnormalities[display_threat])
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
		to_chat(usr, "<span class='boldwarning'>The selected Abnormality cannot be changed.</span>")
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	switch(action)
		if("change_current")
			var/param = params["change_current"]
			var/mob/living/simple_animal/hostile/abnormality/target_type = text2path(param)

			if(!ispath(target_type)) // Should never happen
				to_chat(usr, "<span class='warning'>Extraction request has been denied.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE

			if(!(target_type in SSabnormality_queue.possible_abnormalities[display_threat]))
				to_chat(usr, "<span class='warning'>Your Extraction request has timed out. Retry.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				updateUsrDialog() // Forcibly update it, in case someone doesn't understand why it won't work
				return FALSE

			var/cost = GetCost(initial(target_type.threat_level))

			if(SSlobotomy_corp.available_box + cost < 0)
				to_chat(usr, "<span class='warning'>Insufficient PE allowance.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE

			SSabnormality_queue.owed_pe = cost
			UpdateAnomaly(target_type, "changed", FALSE)
			updateUsrDialog()
			display_threat = FALSE

		if("get_abno_list")
			var/param = params["get_abno_list"]
			display_threat = text2num(param)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()

		if("lets_roll")
			var/threat = initial(SSabnormality_queue.queued_abnormality.threat_level)
			SSabnormality_queue.owed_pe = GetCost(threat)
			UpdateAnomaly(pick(SSabnormality_queue.possible_abnormalities[threat]), "lets rolled", FALSE)
		if("fuck_it_lets_roll")
			UpdateAnomaly(SSabnormality_queue.GetRandomPossibleAbnormality(), "fucked it lets rolled", TRUE)
		if("hardcore_fuck_it_lets_roll")
			if (SSabnormality_queue.hardcore_roll_enabled)
				UpdateAnomaly(pick(pick(SSabnormality_queue.possible_abnormalities)), "hardcore fucked it and rolled", TRUE)
			else
				message_admins("[usr] has managed to send a TGUI signal to hardcore fuck it and roll despite the option being disabled. This is indicative of hacking.")

	update_icon()

/obj/machinery/computer/abnormality_queue/proc/UpdateAnomaly(mob/living/simple_animal/hostile/abnormality/target_type, logstring, lock_after)
	SSabnormality_queue.queued_abnormality = target_type
	to_chat(usr, "<span class='boldnotice'>[initial(target_type.name)] has been selected.</span>")
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	log_game("[usr] has [logstring] the anomaly to [initial(target_type.name)].")
	if(lock_after)
		message_admins("[usr] has [logstring] the anomaly to [initial(target_type.name)].")
		locked = TRUE
		// PE awarded for yellow roll - just as kirie had wanted.
		SSabnormality_queue.owed_pe = max(round(SSlobotomy_corp.box_goal * 0.02, 1), 120)*2
		to_chat(usr, "<span class='boldnotice'>A random Abnormality has been selected. L Corp HQ has reimbursed you for the costs of extracting a specific Abnormality.</span>")
		SSabnormality_queue.AnnounceLock()
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

/proc/GetCost(threat_level)
	. = 0
	if(SSabnormality_queue.spawned_abnos > 0)
		var/current_threat = SSabnormality_queue.automated_available_levels.len
		for(var/TH in SSabnormality_queue.automated_available_levels)
			current_threat--
			if(current_threat <= 0)
				current_threat = TH

		. = threat_level - current_threat

		. = . < 0 ? . - 1 : . + 1
		// Anything weaker than the highest current automated abnormality selection costs PE, while the others grant it.
		. *= max(round(SSlobotomy_corp.box_goal * 0.02, 1), 120) // 2% of quota per level difference.
	return
