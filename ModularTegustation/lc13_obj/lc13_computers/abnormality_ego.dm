/obj/machinery/computer/ego_purchase
	name = "abnormality EGO purchase console"
	desc = "Used to purchase EGO equipment."
	icon_screen = "extraction_ego"
	resistance_flags = INDESTRUCTIBLE
	/// Currently selected(shown) level of abnormalities whose EGO will be on the interface
	var/selected_level = ZAYIN_LEVEL
	var/delay = 15 SECONDS

/obj/machinery/computer/ego_purchase/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
		if(user.mind.assigned_role == "Extraction Officer")
			. += span_notice("This console seems to be upgraded, reducing the cost needed to extract by 15%.")
		else
			. += span_notice("This console seems to be upgraded, cutting the shipment time in half.")

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
			var/mult = 1
			if(usr.mind.assigned_role == "Extraction Officer")
				if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
					mult *= 0.85 //15% off
			if(A.stored_boxes < (E.cost * mult))
				to_chat(usr, span_warning("Not enough PE boxes stored for this operation."))
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			if(usr.mind.assigned_role == "Extraction Officer")
				new E.item_path(get_turf(src))
				to_chat(usr, span_notice("[E.item_path] has been dispensed!"))

			else
				if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
					delay = initial(delay)/2
				addtimer(CALLBACK(src, PROC_REF(ShipOut), E.item_path),delay)
				audible_message(span_notice("[usr.name] has purchased a [E.name]"))

			A.stored_boxes -= E.cost * mult
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			log_game("[key_name(usr)] purchased [E.item_path].")
			message_admins("[key_name(usr)] purchased [E.item_path].")
			updateUsrDialog()
			return TRUE

		if(href_list["info"])
			var/dat = html_decode(href_list["info"])
			var/datum/browser/popup = new(usr, "ego_info", "EGO Purchase Console", 340, 400)
			popup.set_content(dat)
			popup.open()
			return

/obj/machinery/computer/ego_purchase/proc/ShipOut(obj/item/shipped)
	var/list/tablesinrange = list()
	var/list/extractioninrange = list()
	var/turf/T
	for(var/obj/structure/table/V in range(3, src))
		tablesinrange+=V
	for(var/obj/structure/extraction_belt/Y in range(8, src))
		extractioninrange+=Y

	if(LAZYLEN(extractioninrange))
		T = get_turf(pick(extractioninrange))
		var/obj/item/egopackage/E = new (T)
		E.contained_ego = shipped
		return

	if(LAZYLEN(tablesinrange))
		T = get_turf(pick(tablesinrange))
	else
		T = get_turf(src)

	var/obj/structure/closet/supplypod/extractionpod/pod = new()
	pod.explosionSize = list(0,0,0,0)
	new shipped(pod)
	new /obj/effect/pod_landingzone(T, pod)
	stoplag(2)

//This exists for flavor. It was asked of me.
/obj/structure/extraction_belt
	name = "Agent EGO extraction arrival"
	desc = "If an agent or non-extraction officer orders EGO, it will arrive via this output."
	resistance_flags = INDESTRUCTIBLE
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "extraction_belt"

/obj/item/egopackage
	name = "EGO package"
	desc = "a package containing EGO of some kind."
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "extract_pack"
	var/contained_ego = /obj/item/ego_weapon/training

/obj/item/egopackage/attack_self(mob/user)
	..()
	new contained_ego(get_turf(user))
	qdel(src)
