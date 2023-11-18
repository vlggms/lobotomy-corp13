/obj/machinery/computer/ego_purchase
	name = "abnormality EGO purchase console"
	desc = "Used to purchase EGO equipment."
	resistance_flags = INDESTRUCTIBLE
	/// Currently selected(shown) level of abnormalities whose EGO will be on the interface
	var/selected_level = ZAYIN_LEVEL
	var/active = FALSE	//Are we currently extracting?

/obj/machinery/computer/ego_purchase/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	for(var/level = ZAYIN_LEVEL to ALEPH_LEVEL)
		dat += "<A href='byond://?src=[REF(src)];set_level=[level]'>[level == selected_level ? "<b><u>[THREAT_TO_NAME[level]]</u></b>" : "[THREAT_TO_NAME[level]]"]</A>"
	dat += "<hr>"
	for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
		if(!LAZYLEN(A.ego_datums))
			continue
		if(A.threat_level != selected_level)
			continue
		dat += "[A.name] ([A.stored_boxes] PE):<br>"
		for(var/datum/ego_datum/E in A.ego_datums)
			dat += " <A href='byond://?src=[REF(src)];purchase=[E.name][E.item_category]'>[E.item_category] - [E.name] ([E.cost] PE)</A>"
			var/info = html_encode(E.PrintOutInfo())
			if(info)
				dat += " - <A href='byond://?src=[REF(src)];info=[info]'>Info</A>"
			dat += "<br>"
		dat += "<br>"
	var/datum/browser/popup = new(user, "ego_purchase", "EGO Purchase Console", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/ego_purchase/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["set_level"])
			var/level = text2num(href_list["set_level"])
			if(!(level < ZAYIN_LEVEL || level > ALEPH_LEVEL) && level != selected_level)
				selected_level = level
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				return TRUE
			return FALSE
		if(href_list["purchase"])
			var/target_datum = href_list["purchase"]
			var/datum/ego_datum/E = GLOB.ego_datums[target_datum]
			var/datum/abnormality/A = E.linked_abno
			if(!E || !A)
				return FALSE
			if(A.stored_boxes < E.cost)
				to_chat(usr, "<span class='warning'>Not enough PE boxes stored for this operation.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			if(active)
				to_chat(usr, "<span class='warning'>Console is already extracting.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE

			active = TRUE
			//Some roles get faster extraction
			var/user_role = usr?.mind?.assigned_role
			var/extraction_delay = 300
			var/living_players
			switch(user_role)
				if("Clerk")
					extraction_delay = 50
				if("Records Officer")	//No clue what the fuck you're doing here but go off.
					extraction_delay = 30
				if("Extraction Officer")
					extraction_delay = 1
			for(var/mob/living/carbon/human/L in GLOB.player_list)
				living_players++	//There's no fucking easier way to do this IIRC
			if(living_players<5)	//you should have A clerk by 5 living players
				extraction_delay = 1

			if(do_after(usr, extraction_delay, target = src))
				var/obj/item/I = new E.item_path(get_turf(src))
				A.stored_boxes -= E.cost
				A.current_ego += I
				to_chat(usr, "<span class='notice'>[I] has been dispensed!</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				active = FALSE
				return TRUE
			else
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				active = FALSE
				return FALSE

		if(href_list["info"])
			var/dat = html_decode(href_list["info"])
			var/datum/browser/popup = new(usr, "ego_info", "EGO Purchase Console", 340, 400)
			popup.set_content(dat)
			popup.open()
			return
