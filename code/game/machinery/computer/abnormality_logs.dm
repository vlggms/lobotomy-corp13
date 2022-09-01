/obj/machinery/computer/abnormality_logs
	name = "abnormality work logging console"
	desc = "Used to view logs of work performed on abnormalities."
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/computer/abnormality_logs/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	if(LAZYLEN(SSlobotomy_corp.work_logs))
		dat += "<A href='byond://?src=[REF(src)];global_log_menu=1'>All logs</A><br><br>"
	for(var/i = 1 to SSlobotomy_corp.all_abnormality_datums.len)
		var/datum/abnormality/A = SSlobotomy_corp.all_abnormality_datums[i]
		if(!LAZYLEN(A.work_logs))
			dat += "\[[THREAT_TO_NAME[A.threat_level]]\] [A.name]"
		else
			dat += "<A href='byond://?src=[REF(src)];log_menu=[i]'>\[[THREAT_TO_NAME[A.threat_level]]\] [A.name]</A>"
		dat += "<br>"
	var/datum/browser/popup = new(user, "abno_logs", "Abnormality Logging Console", 400, 700)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/abnormality_logs/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["log_menu"])
			var/abno_num = text2num(href_list["log_menu"])
			var/datum/abnormality/A = SSlobotomy_corp.all_abnormality_datums[abno_num]
			var/dat
			for(var/log in A.work_logs)
				dat += "[log]<br>"
			var/datum/browser/popup = new(usr, "abno_logs_[A.name]", "[A.name] Work Logs", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE
		if(href_list["global_log_menu"])
			var/dat
			for(var/log in SSlobotomy_corp.work_logs)
				dat += "[log]<br>"
			var/datum/browser/popup = new(usr, "abno_logs_global", "Global Work Logs", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE
