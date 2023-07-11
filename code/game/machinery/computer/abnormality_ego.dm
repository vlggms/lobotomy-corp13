/obj/machinery/computer/ego_purchase
	name = "abnormality EGO purchase console"
	desc = "Used to purchase EGO equipment."
	resistance_flags = INDESTRUCTIBLE
	/// Currently selected(shown) level of abnormalities whose EGO will be on the interface
	var/selected_level = ZAYIN_LEVEL

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
			var/obj/item/I = new E.item_path(get_turf(src))
			A.stored_boxes -= E.cost
			A.current_ego += I
			to_chat(usr, "<span class='notice'>[I] has been dispensed!</span>")
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE
		if(href_list["info"])
			var/dat = html_decode(href_list["info"])
			var/datum/browser/popup = new(usr, "ego_info", "EGO Purchase Console", 340, 400)
			popup.set_content(dat)
			popup.open()
			return
