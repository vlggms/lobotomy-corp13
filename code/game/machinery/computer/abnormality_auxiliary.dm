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

	// toggles if the window being opened is TGUI or UI, players can toggle it in case TGUI fails to load
	var/TGUI_mode = TRUE
	// toggles special debugging options if the person is an admin
	var/is_admin = FALSE

/obj/machinery/computer/abnormality_auxiliary/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality_auxiliary/Destroy()
	GLOB.lobotomy_devices -= src
	..()

/obj/machinery/computer/abnormality_auxiliary/AltClick(mob/user) // toggles if the UI is using TGUI or not
	. = ..()
	// If we dont close them, some things can be weird
	SStgui.close_uis(src)
	TGUI_mode = !TGUI_mode
	say("[TGUI_mode ? "Turned on" : "Turned off"] TGUI mode")
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)

/obj/machinery/computer/abnormality_auxiliary/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(TGUI_mode)
		ui = SStgui.try_update_ui(user, src, ui)
		if(!ui)
			if(user.client.holder) // we only ever need to set it once when opening the TGUI, no need to continue refreshing it
				is_admin = TRUE
			else
				is_admin = FALSE

			to_chat(user, span_notice("If TGUI is failing to load, you can alt+click the console to switch to UI mode"))
			ui = new(user, src, "AuxiliaryManagerConsole")
			ui.open()
			ui.set_autoupdate(TRUE)
		return

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

// TGUI stuff onwards, all beware ye who enter

/obj/machinery/computer/abnormality_auxiliary/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	// start core supression info
	data["current_supression"] = FALSE
	if(istype(SSlobotomy_corp.core_suppression))
		data["current_supression"] = SSlobotomy_corp.core_suppression.name

	data["selected_core_name"] = FALSE
	data["selected_core_description"] = "Select a core to see its description"
	data["selected_core_goal"] = "Select a core to see its goal"
	data["selected_core_reward"] = "Select a core to see its rewards obtained upon completing it"
	if(ispath(selected_core_type))
		data["selected_core_name"] = initial(selected_core_type.name)
		data["selected_core_description"] = initial(selected_core_type.desc)
		data["selected_core_goal"] = initial(selected_core_type.goal_text)
		data["selected_core_reward"] = initial(selected_core_type.reward_text)
	// end core supression info

	// start facility upgrade info
	data["Upgrade_points"] = round(SSlobotomy_corp.lob_points, 0.1)
	// end facility upgrade info

	// start facility upgrade info
	// preferably this would be in static, but the cost and avaibility needs to be updated whenever an action is performed

	var/list/bullet_upgrades = list()
	var/list/real_bullet_upgrades = list()
	var/list/agent_upgrades = list()
	var/list/abnormality_upgrades = list()
	var/list/you_didnt_give_it_a_proper_category_dammit_upgrades = list()

	for(var/thing in SSlobotomy_corp.upgrades)
		var/datum/facility_upgrade/upgrade = thing
		if(!upgrade.CanShowUpgrade())
			continue

		var/available = TRUE
		if(upgrade.value >= upgrade.max_value)
			available = FALSE

		var/modified_upgrade_name
		if(upgrade.value == 0) // if the upgrade is just a toggle, there's no point in showing its value now, is there?
			modified_upgrade_name = upgrade.name
		else
			modified_upgrade_name = "[upgrade.name] ([upgrade.value])"


		var/list/upgrade_data = list(list(
			"name" = modified_upgrade_name,
			"ref" = REF(upgrade),
			"cost" = upgrade.cost,
			"available" = available,
		))


		var/upgrade_category = upgrade.category
		switch(upgrade_category) // sort them into different lists depending on what category they fit in
			if("Bullets")
				bullet_upgrades += upgrade_data

			if("Bullet Upgrades")
				real_bullet_upgrades += upgrade_data

			if("Agent")
				agent_upgrades += upgrade_data

			if("Abnormalities")
				abnormality_upgrades += upgrade_data

			else
				you_didnt_give_it_a_proper_category_dammit_upgrades += upgrade_data

	data["bullet_upgrades"] = bullet_upgrades
	data["real_bullet_upgrades"] = real_bullet_upgrades
	data["agent_upgrades"] = agent_upgrades
	data["abnormality_upgrades"] = abnormality_upgrades
	data["misc_upgrades"] = you_didnt_give_it_a_proper_category_dammit_upgrades

	return data


/obj/machinery/computer/abnormality_auxiliary/ui_static_data(mob/user)
	. = ..()
	var/list/data = list()

	// start core supression info
	var/list/available_supressions = list()
	for(var/core_type in SSlobotomy_corp.available_core_suppressions)
		var/datum/suppression/available_suppression = core_type
		available_supressions += list(list(
			"name" = available_suppression.name,
			"ref" = REF(available_suppression),
		))
	data["available_suppressions"] = available_supressions
	// end core supression info

	data["is_admin"] = is_admin // used to determine if we unlock special admin-only options

	return data


/obj/machinery/computer/abnormality_auxiliary/ui_act(action, list/params)
	. = ..()
	if (.)
		return

	switch(action) // player actions
		if("Select Core Suppression") // selects a core supression
			var/core_supression = locate(params["selected_core"]) in SSlobotomy_corp.available_core_suppressions
			if(!ispath(core_supression) || !(core_supression in SSlobotomy_corp.available_core_suppressions))
				return FALSE
			selected_core_type = core_supression
			say("[initial(selected_core_type.name)] has been selected!")
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)

		if("Activate Core Suppression") // activates the currently selected core supression
			if(!ispath(selected_core_type) || !(selected_core_type in SSlobotomy_corp.available_core_suppressions))
				return FALSE
			if(istype(SSlobotomy_corp.core_suppression))
				CRASH("[src] has attempted to activate a core supression via TGUI whilst its not possible!")

			say("[initial(selected_core_type.name)] protocol activated, good luck manager.")
			SSlobotomy_corp.core_suppression = new selected_core_type
			SSlobotomy_corp.core_suppression.legitimate = TRUE
			SSlobotomy_corp.available_core_suppressions = list()
			selected_core_type = null
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, Run)), 2 SECONDS)

		if("Buy Upgrade") // Buys an upgrade, looking for a parameter that is given to the upgrade thats being bought on the TGUI side
			var/datum/facility_upgrade/U = locate(params["selected_upgrade"]) in SSlobotomy_corp.upgrades
			if(!istype(U) || !U.CanUpgrade())
				return FALSE

			U.Upgrade()
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)

	if(!usr.client.holder)
		return

	switch(action) // admin actions
		if("Unlock All Cores")
			log_game("[usr] has used admin powers to make all cores avaible in the auxiliary console")
			message_admins("[usr] has used admin powers to make all cores avaible in the auxiliary console")
			SSlobotomy_corp.available_core_suppressions = subtypesof(/datum/suppression)
			SStgui.close_uis(src) // cores are static, so we need to close the TGUI to forcibly update static data

		if("Change LOB Points")
			var/amount = params["LOB_amount"]
			log_game("[usr] has used admin powers to [amount > 0 ? "add" : "remove"] [amount] LOB point[(amount > 1 || amount < -1) ? "s" : ""] in the auxiliary console")
			message_admins("[usr] has used admin powers to [amount > 0 ? "add" : "remove"] [amount] LOB point[(amount > 1 || amount < -1) ? "s" : ""] in the auxiliary console")
			SSlobotomy_corp.lob_points += amount
