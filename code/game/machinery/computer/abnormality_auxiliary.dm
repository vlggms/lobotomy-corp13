// The console "pages" available
#define CORE_SUPPRESSIONS "Core Suppression"
#define FACILITY_UPGRADES "Facility Upgrades"

// Console for all the random managerial stuff like calling rabbits or starting core suppressions
/obj/machinery/computer/abnormality_auxiliary
	name = "auxiliary managerial console"
	desc = "Used for various optional actions available to manager."
	resistance_flags = INDESTRUCTIBLE
	/// Currently selected console page
	var/page = CORE_SUPPRESSIONS
	/// All possible pages
	var/list/all_pages = list(
		CORE_SUPPRESSIONS,
		FACILITY_UPGRADES,
	)
	var/datum/suppression/selected_core_type = null

/obj/machinery/computer/abnormality_auxiliary/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality_auxiliary/Destroy()
	GLOB.lobotomy_devices -= src
	..()

/obj/machinery/computer/abnormality_auxiliary/ui_interact(mob/user)
	. = ..()
	var/dat
	for(var/p in all_pages)
		dat += "<A href='byond://?src=[REF(src)];set_page=[p]'>[p == page ? "<b><u>[p]</u></b>" : "[p]"]</A>"
	dat += "<hr>"
	switch(page)
		if(CORE_SUPPRESSIONS)
			if(istype(SSlobotomy_corp.core_suppression))
				dat += "<b><span style='color: yellow'>[SSlobotomy_corp.core_suppression.name] is currently in the progress!</span></b><hr>"
			else
				if(ispath(selected_core_type))
					dat += "<b>[initial(selected_core_type.name)]</b><br>"
					dat += "[initial(selected_core_type.desc)]<br>"
					dat += "<b>Goal:</b> [initial(selected_core_type.goal_text)]<br>"
					dat += "<b>Reward:</b> [initial(selected_core_type.reward_text)]<br>"
					dat += "<A href='byond://?src=[REF(src)];init_suppression=1'>Initiate</A>"
					dat += "<br><hr><br>"
				for(var/core_type in SSlobotomy_corp.available_core_suppressions)
					var/datum/suppression/S = core_type
					dat += "[initial(S.name)]: <A href='byond://?src=[REF(src)];choose_suppression=[core_type]'>Select</A><br>"

		if(FACILITY_UPGRADES)
			dat += "<b>LOB Points:</b> [round(SSlobotomy_corp.lob_points, 0.1)]"
			dat += "<hr>"
			var/list/upgrades_per_category = list(
				"Bullets" = list(),
				"Bullet Upgrades" = list(),
				"Agent" = list(),
				"Abnormalities" = list(),
				"Unsorted" = list(),
			)
			for(var/datum/facility_upgrade/F in SSlobotomy_corp.upgrades)
				if(!F.CanShowUpgrade())
					continue
				if(!(F.category in upgrades_per_category))
					upgrades_per_category[F.category] = list()
				upgrades_per_category[F.category] |= F
			for(var/i = 1 to length(upgrades_per_category))
				var/cat = upgrades_per_category[i]
				if(!LAZYLEN(upgrades_per_category[cat]))
					continue
				dat += "<b>[cat]</b><br>"
				for(var/datum/facility_upgrade/F in upgrades_per_category[cat])
					dat += "- [F.CanUpgrade() ? "<A href='byond://?src=[REF(src)];upgrade=[F.name]'>Upgrade \[[F.cost]\]</A> " : (F.value >= F.max_value ? "" : "\[[F.cost]\] ")]<b>[F.name]</b>: [F.DisplayValue()]<br>"
				if(i != length(upgrades_per_category))
					dat += "<hr>"
	var/datum/browser/popup = new(user, "abno_auxiliary", "Auxiliary Managerial Console", 480, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/abnormality_auxiliary/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		// Basic topics
		if(href_list["set_page"])
			var/new_page = href_list["set_page"]
			if((new_page in all_pages) && new_page != page)
				page = new_page
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				return TRUE
			return FALSE

		// Core Suppression topics
		if(href_list["choose_suppression"])
			var/datum/suppression/core_type = text2path(href_list["choose_suppression"])
			if(!ispath(core_type) || !(core_type in SSlobotomy_corp.available_core_suppressions))
				return FALSE
			selected_core_type = core_type
			to_chat(usr, span_notice("[initial(selected_core_type.name)] has been selected!"))
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

		if(href_list["init_suppression"])
			if(!ispath(selected_core_type) || !(selected_core_type in SSlobotomy_corp.available_core_suppressions))
				return FALSE
			if(istype(SSlobotomy_corp.core_suppression))
				to_chat(usr, span_warning("A core suppression is already in the progress!"))
				selected_core_type = null
				return FALSE
			SSlobotomy_corp.core_suppression = new selected_core_type
			SSlobotomy_corp.core_suppression.legitimate = TRUE
			SSlobotomy_corp.available_core_suppressions = list()
			selected_core_type = null
			to_chat(usr, span_userdanger("Good luck, Manager."))
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, Run)), 2 SECONDS)
			return TRUE

		// Facility upgrade topics
		if(href_list["upgrade"])
			var/datum/facility_upgrade/U = GetFacilityUpgrade(href_list["upgrade"])
			if(!istype(U) || !U.CanUpgrade())
				updateUsrDialog()
				return FALSE
			U.Upgrade()
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

#undef CORE_SUPPRESSIONS
#undef FACILITY_UPGRADES
