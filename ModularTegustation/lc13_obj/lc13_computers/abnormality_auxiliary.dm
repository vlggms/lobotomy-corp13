// The console "pages" available
#define CORE_SUPPRESSIONS "Core Suppression"
#define FACILITY_UPGRADES "Facility Upgrades"

// Console for all the random managerial stuff like calling rabbits or starting core suppressions
/obj/machinery/computer/abnormality_auxiliary
	name = "auxiliary managerial console"
	desc = "Used for various optional actions available to manager."
	resistance_flags = INDESTRUCTIBLE
	icon_screen = "aux"
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
	return ..()

/obj/machinery/computer/abnormality_auxiliary/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(user?.client?.prefs.auxiliary_console_tgui == TRUE)
		ui = SStgui.try_update_ui(user, src, ui)
		if(!ui)
			ui = new(user, src, "AuxiliaryManagerConsole")
			ui.open()
			ui.set_autoupdate(TRUE)
		return

	var/dat
	for(var/p in all_pages)
		dat += "<A href='byond://?src=[REF(src)];set_page=[p]'>[p == page ? "<b><u>[p]</u></b>" : "[p]"]</A>"
	dat += "<A href='byond://?src=[REF(src)];switch_style=1'>Switch UI style to TGUI</A>"
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
			dat += "<b>LOB Points:</b> [round(SSlobotomy_corp.lob_points, 0.001)]"
			dat += "<hr>"
			var/list/upgrades_per_category = list(
				"Bullets" = list(),
				"Bullet Upgrades" = list(),
				"Facility" = list(),
				"Higher-Up Specialization Tier 1" = list(),
				"Higher-Up Specialization Tier 2" = list(),
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
					dat += "- [F.CanUpgrade() ? "<A href='byond://?src=[REF(src)];upgrade=[F.name]'>Upgrade \[[F.cost]\]</A> " : (F.value >= F.max_value ? "" : "\[[F.cost]\] ")]<b>[F.name]</b>: [F.DisplayValue()]"
					var/info = html_encode(F.PrintOutInfo())
					if(F.info)
						dat += " - <A href='byond://?src=[REF(src)];info=[info]'>Info</A> <br>"
					else
						dat += "<br>"
				if(i != length(upgrades_per_category))
					dat += "<hr>"
	var/datum/browser/popup = new(user, "abno_auxiliary", "Auxiliary Managerial Console", 480, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/abnormality_auxiliary/Topic(href, href_list)
	. = ..()
	if(href_list["switch_style"])
		if(!usr.client.prefs)
			return FALSE

		usr.client.prefs.auxiliary_console_tgui = TRUE
		usr.client.prefs.save_preferences()
		ui_interact(usr)
		return TRUE

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
			if(usr.mind.assigned_role != "Manager")
				to_chat(usr, span_warning("Only the Manager can start a Core Suppression!"))
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
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
			if(U.name == UPGRADE_ARCHITECT_1 || U.name == UPGRADE_ARCHITECT_2)
				if(usr.mind.assigned_role != "Manager")
					to_chat(usr, span_warning("Only the Manager can buy this."))
					playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
					return FALSE
			U.Upgrade()
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE
		if(href_list["info"])
			var/dat = html_decode(href_list["info"])
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			var/datum/browser/popup = new(usr, "upgrade_info", "Auxiliary Managerial Console", 340, 400)
			popup.set_content(dat)
			popup.open()
			return
#undef CORE_SUPPRESSIONS
#undef FACILITY_UPGRADES

// TGUI stuff onwards, all beware ye who enter

// gather all the assets needed for optional decorative stuff
/datum/asset/simple/sephirah
	assets = list(
		// upper layer

		"SEPHIRAH.yellow.png" = icon('icons/obj/plushes.dmi', "malkuth"),
		"SEPHIRAH.purple.png" = icon('icons/obj/plushes.dmi', "yesod"),
		"SEPHIRAH.green.png" = icon('icons/obj/plushes.dmi', "netzach"),
		"SEPHIRAH.orange.png" = icon('icons/obj/plushes.dmi', "hod"),

		// middle layer

		// command overriden
		"SEPHIRAH.blue.png" = icon('icons/obj/plushes.dmi', "chesed"),
		"SEPHIRAH.red.png" = icon('icons/obj/plushes.dmi', "gebura"),

		// lower layer

		// extraction overriden
		"SEPHIRAH.white.png" = icon('icons/obj/plushes.dmi', "hokma"),

		// icon overrides

		"SEPHIRAH.AYIN.png" = icon('icons/obj/plushes.dmi', "ayin"), // fuck you *turns ayin into a sephirah*
		"SEPHIRAH.TWINS.png" = icon('icons/obj/plushes.dmi', "lisa"),
		"SEPHIRAH.BINAH.png" = icon('icons/obj/plushes.dmi', "binah"),

	)

/obj/machinery/computer/abnormality_auxiliary/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/sephirah),
	)

/obj/machinery/computer/abnormality_auxiliary/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	// start facility upgrade info
	data["Upgrade_points"] = round(SSlobotomy_corp.lob_points, 0.001)

	// preferably this would be in static, but the cost and avaibility needs to be updated whenever an action is performed

	var/list/bullet_upgrades = list()
	var/list/real_bullet_upgrades = list()
	var/list/agent_upgrades = list()
	var/list/abnormality_upgrades = list()
	var/list/lvl_1_special_upgrades = list()
	var/list/lvl_2_special_upgrades = list()
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
			modified_upgrade_name = "[upgrade.name] ([upgrade.DisplayValue() ? upgrade.DisplayValue() :upgrade.value])"


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

			if("Facility")
				abnormality_upgrades += upgrade_data
			if("Higher-Up Specialization Tier 1")
				lvl_1_special_upgrades += upgrade_data
			if("Higher-Up Specialization Tier 2")
				lvl_2_special_upgrades += upgrade_data
			else
				you_didnt_give_it_a_proper_category_dammit_upgrades += upgrade_data

	data["bullet_upgrades"] = bullet_upgrades
	data["real_bullet_upgrades"] = real_bullet_upgrades
	data["agent_upgrades"] = agent_upgrades
	data["abnormality_upgrades"] = abnormality_upgrades
	data["lvl1_upgrades"] = lvl_1_special_upgrades
	data["lvl2_upgrades"] = lvl_2_special_upgrades
	data["misc_upgrades"] = you_didnt_give_it_a_proper_category_dammit_upgrades
	// end facility upgrade info

	return data


/obj/machinery/computer/abnormality_auxiliary/ui_static_data(mob/user)
	. = ..()
	var/list/data = list()

	// start core suppression info
	data["current_suppression"] = FALSE // if the type check fails, we send FALSE instead
	if(istype(SSlobotomy_corp.core_suppression))
		var/core_suppression_name = SSlobotomy_corp.core_suppression.name

		data["current_suppression"] = core_suppression_name
		data["selected_core_color"] = "red"
		var/icon_override = FALSE // normally the assets are fetched via the color of the core being supressed, this overrides it
		switch(core_suppression_name) // we choose the core's color once its locked in place here, the mother of all switches
			// upper layer
			if(CONTROL_CORE_SUPPRESSION)
				data["selected_core_color"] = "yellow"

			if(INFORMATION_CORE_SUPPRESSION)
				data["selected_core_color"] = "purple"

			if(SAFETY_CORE_SUPPRESSION)
				data["selected_core_color"] = "green"

			if(TRAINING_CORE_SUPPRESSION)
				data["selected_core_color"] = "orange"

			// middle layer

			if(COMMAND_CORE_SUPPRESSION)
				data["selected_core_color"] = "yellow"
				icon_override = "TWINS"

			if(WELFARE_CORE_SUPPRESSION)
				data["selected_core_color"] = "blue"

			if(DISCIPLINARY_CORE_SUPPRESSION)
				data["selected_core_color"] = "red"

			// bottom layer
			if(EXTRACTION_CORE_SUPPRESSION)
				data["selected_core_color"] = "yellow"
				icon_override = "BINAH"

			if(RECORDS_CORE_SUPPRESSION)
				data["selected_core_color"] = "white"

			// literal hell layer

			// should divide them and give them colors later, but no clue what they could have for now
			if(DAY46_CORE_SUPPRESSION, DAY47_CORE_SUPPRESSION, DAY48_CORE_SUPPRESSION, DAY49_CORE_SUPPRESSION, DAY50_CORE_SUPPRESSION)
				data["selected_core_color"] = "white"
				icon_override = "AYIN"

			// you didnt set a proper core layer
			else
				data["selected_core_color"] = "red"

		if(icon_override)
			data["selected_core_icon"] = "SEPHIRAH.[icon_override].png"
		else
			data["selected_core_icon"] = "SEPHIRAH.[data["selected_core_color"]].png"

	if(ispath(selected_core_type))
		data["selected_core_name"] = initial(selected_core_type.name)
		data["selected_core_description"] = initial(selected_core_type.desc)
		data["selected_core_goal"] = initial(selected_core_type.goal_text)
		data["selected_core_reward"] = initial(selected_core_type.reward_text)

	var/list/available_suppressions = list()
	for(var/core_type in SSlobotomy_corp.available_core_suppressions)
		var/datum/suppression/core_suppression = core_type
		available_suppressions += list(list(
			"name" = core_suppression.name,
			"ref" = REF(core_suppression),
		))

	data["available_suppressions"] = available_suppressions

	var/list/pre_made_core_suppressions = subtypesof(/datum/suppression)
	var/list/all_core_suppressions = list()
	for(var/core_type in pre_made_core_suppressions)
		var/datum/suppression/core_suppression = core_type
		all_core_suppressions += list(list(
			"name" = core_suppression.name,
			"ref" = REF(core_suppression),
		))

	data["all_core_suppressions"] = all_core_suppressions
	// end core suppression info

	var/is_admin
	if(user.client.holder)
		is_admin = TRUE
	else
		is_admin = FALSE

	data["is_admin"] = is_admin // used to determine if we unlock special admin-only options

	return data


/obj/machinery/computer/abnormality_auxiliary/ui_act(action, list/params)
	. = ..()
	if(. && !usr.client.holder) // the usr.client.holder check allows admins to bypass the typical TGUI proximity checks
		return

	switch(action)
		if("Switch Style")
			if(!usr.client.prefs)
				return

			usr.client.prefs.auxiliary_console_tgui = FALSE
			usr.client.prefs.save_preferences()
			ui_interact(usr)

		if("Select Core Suppression") // selects a core suppression
			var/core_suppression = locate(params["selected_core"]) in SSlobotomy_corp.available_core_suppressions
			if(!ispath(core_suppression) || !(core_suppression in SSlobotomy_corp.available_core_suppressions))
				return

			selected_core_type = core_suppression
			say("[initial(selected_core_type.name)] has been selected!")
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			update_static_data_for_all_viewers()

		if("Activate Core Suppression") // activates the currently selected core suppression
			if(!ispath(selected_core_type) || !(selected_core_type in SSlobotomy_corp.available_core_suppressions))
				return
			if(istype(SSlobotomy_corp.core_suppression))
				CRASH("[src] has attempted to activate a core suppression via TGUI whilst its not possible!")
			if(usr.mind.assigned_role != "Manager")
				to_chat(usr, span_warning("Only the Manager can start a Core Suppression!"))
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return
			log_action(usr,
				message_override = "[usr] has started the [initial(selected_core_type.name)] core suppression"
			)

			say("[initial(selected_core_type.name)] protocol activated, good luck manager.")
			SSlobotomy_corp.core_suppression = new selected_core_type
			SSlobotomy_corp.core_suppression.legitimate = TRUE
			SSlobotomy_corp.available_core_suppressions = list()
			selected_core_type = null
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, Run)), 2 SECONDS)
			update_static_data_for_all_viewers()

		if("Buy Upgrade") // Buys an upgrade, looking for a parameter that is given to the upgrade thats being bought on the TGUI side
			var/datum/facility_upgrade/U = locate(params["selected_upgrade"]) in SSlobotomy_corp.upgrades
			if(!istype(U) || !U.CanUpgrade())
				return
			if(U.name == UPGRADE_ARCHITECT_1 || U.name == UPGRADE_ARCHITECT_2)
				if(usr.mind.assigned_role != "Manager")
					to_chat(usr, span_warning("Only the Manager can buy this."))
					playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
					return
			log_action(usr,
				message_override = "[usr] has purchased the [U.name] facility upgrade"
			)
			U.Upgrade()
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		if("Info")
			var/datum/facility_upgrade/U = locate(params["selected_upgrade"]) in SSlobotomy_corp.upgrades
			if(!istype(U))
				return
			var/dat = U.PrintOutInfo()
			var/datum/browser/popup = new(usr, "upgrade_info", "Auxiliary Managerial Console", 340, 400)
			popup.set_content(dat)
			popup.open()
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			return
		// admin-only actions, remember to put a if(!log_action) check with a proper return
		if("Unlock Core Suppressions")
			if(!log_action(usr, admin_action = TRUE,
				message_override = "[usr] has used admin powers to manipulate the available cores in the auxiliary console"
			))
				update_static_data_for_all_viewers()
				return

			var/core_to_unlock = params["core_unlock"]

			if(core_to_unlock != 1)
				var/list/all_cores = subtypesof(/datum/suppression)
				var/selected_core = locate(params["core_unlock"]) in all_cores

				SSlobotomy_corp.available_core_suppressions += selected_core

			else // unlock all of them if the core to unlock is not specified
				SSlobotomy_corp.available_core_suppressions = subtypesof(/datum/suppression)

			update_static_data_for_all_viewers()

		if("Disable Core Suppression")
			if(istype(SSlobotomy_corp.core_suppression) || !LAZYLEN(SSlobotomy_corp.available_core_suppressions))
				message_admins("[usr] has tried to disable all core suppressions but there were none, all admins laugh at them!")
				return

			if(!log_action(usr, admin_action = TRUE,
				message_override = "[usr] has used admin powers to disable all core suppressions!"
			))
				update_static_data_for_all_viewers()
				return

			SSlobotomy_corp.ResetPotentialSuppressions()
			update_static_data_for_all_viewers()

		if("End Core Suppression")
			if(!log_action(usr, admin_action = TRUE,
				message_override = "[usr] has used admin powers to end the current core suppression (persistence not saved)"
			))
				update_static_data_for_all_viewers()
				return

			SSlobotomy_corp.core_suppression.legitimate = FALSE // let admins mess around without worrying about persistence
			SSlobotomy_corp.core_suppression.End()
			update_static_data_for_all_viewers()

		if("Change LOB Points")
			var/amount = params["LOB_amount"]
			if(!log_action(usr, admin_action = TRUE,
				message_override = "[usr] has used admin powers to [amount > 0 ? "add" : "remove"] [amount] LOB point[(amount > 1 || amount < -1) ? "s" : ""] in the auxiliary console"
			))
				update_static_data_for_all_viewers()
				return
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			SSlobotomy_corp.lob_points += amount

		else // something bad happened, refresh the data and it hopefully fixes itself
			update_static_data_for_all_viewers()

/**
 * Logs interactions with the console
 *
 * arguments:
 * (required) console_user = the user that is using the console (usr)
 * (optional) admin_action = if the current action should be restricted for only admins
 * (optional/required) message_override = if set on any value other than FALSE, the logging message will be replaced by it
 */
/obj/machinery/computer/abnormality_auxiliary/proc/log_action(mob/console_user, admin_action = FALSE, message_override = FALSE)
	if(!console_user)
		CRASH("user not provided in (/obj/machinery/computer/abnormality_auxiliary/proc/log_action)")

	if(!admin_action)
		if(message_override)
			log_game(message_override)
			message_admins(message_override)
			return TRUE
		else // if you are going to use it on non-admin actions, you need a message because we have actually no clue whats happening
			CRASH("message_override not set up on a non-admin action within the TGUI auxiliary console whilst its mandatory!")

	var/is_admin = console_user.client.holder
	if(!is_admin)
		message_admins("[usr] has used an admin-only option in the auxiliary console TGUI whilst not an admin!")
		return FALSE

	if(message_override)
		log_game(message_override)
		message_admins(message_override)
		return TRUE

	log_game("[usr] has used admin powers to trigger an admin-only action in the auxiliary console")
	message_admins("[usr] has used admin powers to trigger an admin-only action in the auxiliary console")
	return TRUE
