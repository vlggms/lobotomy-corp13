//mob/living/carbon/human	i tried to make this on humans only, but i have no clue if we can. If anyone knows how to do it, please do
/mob // modular variable insertion
	/// Is this user being punished with slowly extracting EGO instead of instantly?
	var/slow_extraction_punishment = FALSE

/datum/smite/slow_extraction // Its nice to punish people without going through View-Variables
	name = "Slow extraction punishment (automatically role adjusted)"

/datum/smite/slow_extraction/effect(client/user, mob/living/target)
	target.slow_extraction_punishment = TRUE
	return ..()

/datum/smite/very_slow_extraction // wow, you must really hate this person
	name = "Slow extraction punishment (forced 30 seconds)"

/datum/smite/very_slow_extraction/effect(client/user, mob/living/target)
	target.slow_extraction_punishment = 2
	return ..()


/obj/machinery/computer/ego_purchase
	name = "abnormality EGO purchase console"
	desc = "Used to purchase EGO equipment."
	resistance_flags = INDESTRUCTIBLE
	/// Currently selected(shown) level of abnormalities whose EGO will be on the interface
	var/selected_level = ZAYIN_LEVEL
	/// Are we slowing down everyone's extracting capability EXCEPT the EO?
	var/slow_extraction = FALSE

/obj/machinery/computer/ego_purchase/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	for(var/level = ZAYIN_LEVEL to ALEPH_LEVEL)
		dat += "<A href='byond://?src=[REF(src)];set_level=[level]'>[level == selected_level ? "<b><u>[THREAT_TO_NAME[level]]</u></b>" : "[THREAT_TO_NAME[level]]"]</A>"
	dat += "<hr>"
	for(var/datum/abnormality/Abnormality_datum in SSlobotomy_corp.all_abnormality_datums)
		if(!LAZYLEN(Abnormality_datum.ego_datums))
			continue
		if(Abnormality_datum.threat_level != selected_level)
			continue
		dat += "[Abnormality_datum.name] ([Abnormality_datum.stored_boxes] PE):<br>"
		for(var/datum/ego_datum/Ego_datum in Abnormality_datum.ego_datums)
			dat += " <A href='byond://?src=[REF(src)];purchase=[Ego_datum.name][Ego_datum.item_category]'>[Ego_datum.item_category] - [Ego_datum.name] ([Ego_datum.cost] PE)</A>"
			var/info = html_encode(Ego_datum.PrintOutInfo())
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
	if(!ishuman(usr))
		return
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
		var/datum/ego_datum/Ego_datum = GLOB.ego_datums[target_datum]
		var/datum/abnormality/Abnormality_datum = Ego_datum.linked_abno
		if(!Ego_datum || !Abnormality_datum)
			return FALSE
		if(Abnormality_datum.stored_boxes < Ego_datum.cost)
			to_chat(usr, span_warning("Not enough PE boxes stored for this operation."))
			playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
			return FALSE

		//Some roles get faster extraction
		var/user_role = usr?.mind?.assigned_role
		var/extraction_delay = 30 SECONDS
		switch(user_role)
			if("Clerk")
				extraction_delay = 5 SECONDS
			if("Records Officer")	//No clue what the fuck you're doing here but go off.
				extraction_delay = 3 SECONDS
			if("Extraction Officer")
				extraction_delay = 0.1 SECONDS

		// If we are not supposed to slowly extract, lets just override the previous switch instead of making this whole thing an if else()
		if(!slow_extraction && !usr.slow_extraction_punishment)
			extraction_delay = 0.1 SECONDS

		if(usr.slow_extraction_punishment == 2) // has this person been afflicted with the worst punishment possible?
			extraction_delay = 30 SECONDS

		if(!do_after(usr, extraction_delay, target = src))
			playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
			return FALSE

		var/obj/item/Dispensed_item = new Ego_datum.item_path(get_turf(src))
		Abnormality_datum.stored_boxes -= Ego_datum.cost
		Abnormality_datum.current_ego += Dispensed_item
		to_chat(usr, span_notice("[Dispensed_item] has been dispensed!"))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		updateUsrDialog()
		return TRUE

	if(href_list["info"])
		var/dat = html_decode(href_list["info"])
		var/datum/browser/popup = new(usr, "ego_info", "EGO Purchase Console", 340, 400)
		popup.set_content(dat)
		popup.open()
