//Extraction tool delivery item
/obj/item/extraction/delivery
	name = "E.G.O. Dissemination Device"
	desc = "A portable extraction console that can be used by only the extraction officer."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "coffin_empty"
	var/selected_level = ZAYIN_LEVEL
	var/obj/stored_item = null
	var/obj/structure/extraction_belt/linked_structure

/obj/item/extraction/delivery/examine(mob/user)
	. = ..()
	if(user.mind.assigned_role == "Extraction Officer")
		if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
			. += span_notice("This tool seems to be upgraded, reducing the cost needed to extract by 15%.")
	if(linked_structure)
		. += span_nicegreen("This tool is linked to an extraction arrival belt.")
	else
		. += span_red("This tool needs to be linked to an extraction arrival belt in order to perform E.G.O. returns.")

/obj/item/extraction/delivery/tool_action(mob/user)
	if(!stored_item)
		ui_interact(user)
		return
	user.playsound_local(user, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
	switch(tgui_alert(user,"Where will you send this [stored_item.name]?","E.G.O. Delivery Prompt",list("Here","An Agent","Arrival", "Cancel")))
		if("Here")
			user.playsound_local(user, 'sound/weapons/emitter2.ogg', 25, FALSE)
			new stored_item(get_turf(src))
			var/datum/effect_system/spark_spread/sparks = new
			sparks.set_up(5, 1, get_turf(src))
			sparks.attach(stored_item)
			sparks.start()
			stored_item = null
			if(linked_structure)
				var/obj/structure/return_pad/THEPAD = new(get_turf(src))
				THEPAD.linked_structure = linked_structure
		if("An Agent")
			user.playsound_local(user, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			var/M = input(user,"To whom would you like to send the E.G.O.?","Select Someone") as null|anything in AllLivingAgents()
			if(!M)
				user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
				to_chat(user, span_warning("Nobody was specified."))
				return
			new stored_item(get_turf(M))
			user.playsound_local(user, 'sound/weapons/emitter2.ogg', 25, FALSE)
			playsound(get_turf(M), 'sound/weapons/emitter2.ogg', 25, FALSE)
			to_chat(user, span_notice("[stored_item.name] has been shipped to [M]!"))
			to_chat(M, span_notice("[stored_item.name] has been shipped to your location by the Extraction Officer!"))
			var/datum/effect_system/spark_spread/sparks = new
			sparks.set_up(5, 1, get_turf(M))
			sparks.attach(stored_item)
			sparks.start()
			stored_item = null
			if(linked_structure)
				var/obj/structure/return_pad/THEPAD = new(get_turf(M))
				THEPAD.linked_structure = linked_structure
		if("Arrival")
			if(!linked_structure)
				user.playsound_local(user, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
				to_chat(user, span_warning("ERROR - E.G.O. ARRIVAL BELT UNLINKED"))
				return
			user.playsound_local(user, 'sound/weapons/emitter2.ogg', 25, FALSE)
			new stored_item(get_turf(linked_structure))
			to_chat(user, span_notice("[stored_item.name] has been shipped to the extraction belt!"))
			var/datum/effect_system/spark_spread/sparks = new
			sparks.attach(stored_item)
			sparks.start()
			stored_item = null
		if("Cancel")
			user.playsound_local(user, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
	update_icon()

/obj/item/extraction/delivery/ui_interact(mob/user)
	. = ..()
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
		var/mult = 1
		if(user.mind.assigned_role == "Extraction Officer")
			if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
				mult *= 0.85
		for(var/datum/ego_datum/E in A.ego_datums)
			dat += " <A href='byond://?src=[REF(src)];purchase=[E.name][E.item_category]'>[E.item_category] - [E.name] ([E.cost * mult] PE)</A>"
			var/info = html_encode(E.PrintOutInfo())
			if(info)
				dat += " - <A href='byond://?src=[REF(src)];info=[info]'>Info</A>"
			dat += "<br>"
		dat += "<br>"
	var/datum/browser/popup = new(user, "ego_purchase", "EGO Purchase Console", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/item/extraction/delivery/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(href_list["set_level"])
		var/level = text2num(href_list["set_level"])
		if(!(level < ZAYIN_LEVEL || level > ALEPH_LEVEL) && level != selected_level)
			selected_level = level
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			ui_interact(usr)
			return TRUE
		return FALSE
	if(href_list["purchase"])
		var/target_datum = href_list["purchase"]
		var/datum/ego_datum/E = GLOB.ego_datums[target_datum]
		var/datum/abnormality/A = E.linked_abno
		if(!E || !A)
			return FALSE
		if(stored_item)
			to_chat(usr, span_warning("Dispense the item currently stored in the [src] first."))
			return FALSE
		var/mult = 1
		if(usr.mind.assigned_role == "Extraction Officer")
			if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
				mult *= 0.85 //15% off
		if(A.stored_boxes < (E.cost * mult))
			to_chat(usr, span_warning("Not enough PE boxes stored for this operation."))
			playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
			return FALSE
		PrepareItem(E.item_path)
		to_chat(usr, span_notice("[E.name] has been dispensed!"))
		log_game("[key_name(usr)] purchased [E.item_path].")
		message_admins("[key_name(usr)] purchased [E.item_path].")
		A.stored_boxes -= E.cost * mult
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		updateUsrDialog()
		tool_action(usr)
		return TRUE

	if(href_list["info"])
		var/dat = html_decode(href_list["info"])
		var/datum/browser/popup = new(usr, "ego_info", "EGO Purchase Console", 340, 400)
		popup.set_content(dat)
		popup.open()
		return

/obj/item/extraction/delivery/proc/PrepareItem(obj/item/shipped)
	stored_item = shipped
	update_icon()
	return

/obj/item/extraction/delivery/update_icon()
	if(!stored_item)
		icon_state = "coffin_empty"
		return
	icon_state = "coffin"

// Telepad-related code
/obj/item/extraction/delivery/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(!tool_checks(user))
		return FALSE //You can't do any special interactions
	if(istype(A, /obj/structure/extraction_belt))
		linked_structure = A
		to_chat(usr, span_nicegreen("Device link successful."))
		return FALSE
	return TRUE
