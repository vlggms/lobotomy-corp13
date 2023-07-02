#define TGS_STATUS_THROTTLE 5

/datum/tgs_chat_command/tgsstatus
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE

/datum/tgs_chat_command/tgsstatus/Run(datum/tgs_chat_user/sender, params)
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]).\n"
	var/round_time = world.time - SSticker.round_start_time
	status += "Players: [GLOB.clients.len] (Active: [get_active_player_count(0,1,0)]). Mode: [SSticker.mode ? SSticker.mode.name : "Not started"]; Round Time: [round_time > MIDNIGHT_ROLLOVER ? "[round(round_time/MIDNIGHT_ROLLOVER)]:[gameTimestamp("hh:mm:ss", round_time)]" : gameTimestamp("hh:mm:ss", round_time)].\n"
	if(istype(SSlobotomy_corp.next_ordeal))
		status += "Next ordeal will be __[SSlobotomy_corp.next_ordeal.name]__.\n"
	if(istype(SSlobotomy_corp.core_suppression))
		status += "[SSlobotomy_corp.core_suppression.name] is currently in the process.\n"
	return status

/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Gets the playercount, gamemode, round duration, abnormality count, alert level, core suppression status and server address."

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	var/server = CONFIG_GET(string/server)
	var/check = "[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] players on [SSmapping.config.map_name]; Alert level: [capitalize(get_security_level())].\n"
	var/round_time = world.time - SSticker.round_start_time
	check += "Gamemode: [GLOB.master_mode]; Round Time: [round_time > MIDNIGHT_ROLLOVER ? "[round(round_time/MIDNIGHT_ROLLOVER)]:[gameTimestamp("hh:mm:ss", round_time)]" : gameTimestamp("hh:mm:ss", round_time)].\n"
	var/abno_count = SSlobotomy_corp.all_abnormality_datums.len
	if(abno_count > 0)
		check += "Abnormalit[abno_count > 1 ? "ies" : "y"] in the facility: __[abno_count]__.\n"
	if(LAZYLEN(SSlobotomy_corp.current_ordeals))
		var/list/ordeal_names = list()
		for(var/datum/ordeal/O in SSlobotomy_corp.current_ordeals)
			ordeal_names += O.name
		check += "[english_list(ordeal_names)] [length(ordeal_names) > 1 ? "are" : "is"] currently in the process.\n"
	if(istype(SSlobotomy_corp.next_ordeal)) // Let's tell people what ordeal type is next
		check += "Next ordeal type will be __[SSlobotomy_corp.next_ordeal.ReturnSecretName()]__.\n"
	if(istype(SSlobotomy_corp.core_suppression)) // Currently active core suppression
		check += "**[SSlobotomy_corp.core_suppression.name]** is currently in the process.\n"
	check += "Join the round: `byond://[server ? server : "[world.internet_address ? world.internet_address : world.address]:[world.port]"]`"
	return check

/datum/tgs_chat_command/ahelp
	name = "ahelp"
	help_text = "<ckey|ticket #> <message|ticket <close|resolve|icissue|reject|reopen <ticket #>|list>>"
	admin_only = TRUE

/datum/tgs_chat_command/ahelp/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "Insufficient parameters"
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return "Ticket #[id] not found!"
	var/res = TgsPm(target, all_params.Join(" "), sender.friendly_name)
	if(res != "Message Successful")
		return res

/datum/tgs_chat_command/namecheck
	name = "namecheck"
	help_text = "Returns info on the specified target"
	admin_only = TRUE

/datum/tgs_chat_command/namecheck/Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return "Insufficient parameters"
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("Name checking [params] from [sender.friendly_name]")
	return keywords_lookup(params, 1)

/datum/tgs_chat_command/adminwho
	name = "adminwho"
	help_text = "Lists administrators currently on the server"
	admin_only = TRUE

/datum/tgs_chat_command/adminwho/Run(datum/tgs_chat_user/sender, params)
	return tgsadminwho()

GLOBAL_LIST(round_end_notifiees)

/datum/tgs_chat_command/endnotify
	name = "endnotify"
	help_text = "Pings the invoker when the round ends"
	admin_only = TRUE

/datum/tgs_chat_command/endnotify/Run(datum/tgs_chat_user/sender, params)
	if(!SSticker.IsRoundInProgress() && SSticker.HasRoundStarted())
		return "[sender.mention], the round has already ended!"
	LAZYINITLIST(GLOB.round_end_notifiees)
	GLOB.round_end_notifiees[sender.mention] = TRUE
	return "I will notify [sender.mention] when the round ends."

/datum/tgs_chat_command/sdql
	name = "sdql"
	help_text = "Runs an SDQL query"
	admin_only = TRUE

/datum/tgs_chat_command/sdql/Run(datum/tgs_chat_user/sender, params)
	if(GLOB.AdminProcCaller)
		return "Unable to run query, another admin proc call is in progress. Try again later."
	GLOB.AdminProcCaller = "CHAT_[sender.friendly_name]"	//_ won't show up in ckeys so it'll never match with a real admin
	var/list/results = world.SDQL2_query(params, GLOB.AdminProcCaller, GLOB.AdminProcCaller)
	GLOB.AdminProcCaller = null
	if(!results)
		return "Query produced no output"
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	. = "[text_res.Join("\n")][refs ? "\nRefs: [refs.Join(" ")]" : ""]"

/datum/tgs_chat_command/reload_admins
	name = "reload_admins"
	help_text = "Forces the server to reload admins."
	admin_only = TRUE

/datum/tgs_chat_command/reload_admins/Run(datum/tgs_chat_user/sender, params)
	ReloadAsync()
	log_admin("[sender.friendly_name] reloaded admins via chat command.")
	return "Admins reloaded."

/datum/tgs_chat_command/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

/datum/tgs_chat_command/tgsabnos
	name = "abnos"
	help_text = "Gets the current abnormalities in the facility by threat level."

/datum/tgs_chat_command/tgsabnos/Run(datum/tgs_chat_user/sender, params)
	var/list/abnos = list("ZAYIN" = list(), "TETH" = list(), "HE" = list(), "WAW" = list(), "ALEPH" = list())
	if(!LAZYLEN(SSlobotomy_corp.all_abnormality_datums))
		return "There's currently no abnormalities in the facility!"

	var/abnos_report = "Current abnormalities in the facility:"
	for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
		var/a_threat = THREAT_TO_NAME[A.threat_level]
		if(!(a_threat in abnos)) // How???
			continue
		abnos[a_threat] += A.name

	for(var/threat in abnos)
		if(!LAZYLEN(abnos[threat]))
			continue
		abnos_report += "\n- **[threat]**: [english_list(abnos[threat])]."

	return abnos_report
