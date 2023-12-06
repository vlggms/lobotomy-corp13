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
		var/understanding = round((A.understanding / A.max_understanding) * 100)
		if(!LAZYLEN(A.work_logs))
			dat += "\[[THREAT_TO_NAME[A.threat_level]]\] [A.name] ([understanding]%)"
		else
			dat += "<A href='byond://?src=[REF(src)];log_menu=[i]'>\[[THREAT_TO_NAME[A.threat_level]]\] [A.name] ([understanding]%)</A>"
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
			if(LAZYLEN(A.work_stats))
				dat += "<A href='byond://?src=[REF(src)];work_stats_menu=[abno_num]'>Work Statistics</A><br><br>"
			for(var/log in A.work_logs)
				dat += "[log]<br>"
			var/datum/browser/popup = new(usr, "abno_logs_[A.name]", "[A.name] Work Logs", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE
		if(href_list["global_log_menu"])
			var/dat
			if(LAZYLEN(SSlobotomy_corp.work_stats))
				dat += "<A href='byond://?src=[REF(src)];global_work_stats_menu=1'>Global Work Statistics</A><br><br>"
			for(var/log in SSlobotomy_corp.work_logs)
				dat += "[log]<br>"
			var/datum/browser/popup = new(usr, "abno_logs_global", "Global Work Logs", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE

		/**
		 *	Agent work stats
		 */
		if(href_list["work_stats_menu"])
			var/abno_num = text2num(href_list["work_stats_menu"])
			var/datum/abnormality/A = SSlobotomy_corp.all_abnormality_datums[abno_num]
			var/dat
			for(var/worker in A.work_stats)
				var/worker_name = A.work_stats[worker]["name"]
				var/work_count = A.work_stats[worker]["works"]
				dat += "<A href='byond://?src=[REF(src)];agent_stats=[worker]&abno_number=[abno_num]'>[worker_name] ([work_count] work[work_count > 0 ? "s" : ""])</A><br>"
			var/datum/browser/popup = new(usr, "abno_work_stats_[A.name]", "[A.name] Work Statistics", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE

		if(href_list["global_work_stats_menu"])
			var/dat
			for(var/worker in SSlobotomy_corp.work_stats)
				var/worker_name = SSlobotomy_corp.work_stats[worker]["name"]
				var/work_count = SSlobotomy_corp.work_stats[worker]["works"]
				dat += "<A href='byond://?src=[REF(src)];global_agent_stats=[worker]'>[worker_name] ([work_count] work[work_count > 0 ? "s" : ""])</A><br>"
			var/datum/browser/popup = new(usr, "abno_work_stats_global", "Global Work Statistics", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE

		/**
		 *	The individual window of an agent's work stats for that abnormality
		 */
		if(href_list["agent_stats"])
			var/worker = href_list["agent_stats"]
			var/abno_num = text2num(href_list["abno_number"])
			var/datum/abnormality/A = SSlobotomy_corp.all_abnormality_datums[abno_num]
			var/dat
			var/worker_name = A.work_stats[worker]["name"]
			var/work_count = A.work_stats[worker]["works"]
			var/work_earn = A.work_stats[worker]["pe"]
			var/work_gain = A.work_stats[worker]["gain"]
			dat += "<b><u>Agent:</u> [worker_name]</b><br>"
			dat += "<b><u>Abnormality:</u> [A.name]</b><br><br>"
			dat += "<u>Work count:</u> [work_count]<br>"
			dat += "<u>PE earned:</u> [work_earn]<br>"
			dat += "<u>Attributes gained:</u><br>"
			if(LAZYLEN(work_gain))
				for(var/attribute in work_gain)
					dat += "- [attribute]: [A.work_stats[worker]["gain"][attribute]]<br>"
			else
				dat += "<b>NONE</b><br>"
			dat += "<br><hr><br>"
			var/productivity = ((work_earn / work_count) / A.max_boxes) * 100
			dat += "<b><u>Agent's productivity:</u> [productivity]%</b><br>"
			if(productivity < 20)
				dat += "<b>Investigation recommended.</b>"

			var/datum/browser/popup = new(usr, "agent_work_stats_[A.name]_[worker]", "[A.name]: [worker_name] Work Statistics", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE

		/**
		 *	Same, but GLOBAL!
		 */
		if(href_list["global_agent_stats"])
			var/worker = href_list["global_agent_stats"]
			var/dat
			var/worker_name = SSlobotomy_corp.work_stats[worker]["name"]
			var/work_count = SSlobotomy_corp.work_stats[worker]["works"]
			var/work_earn = SSlobotomy_corp.work_stats[worker]["pe"]
			var/work_gain = SSlobotomy_corp.work_stats[worker]["gain"]
			dat += "<b><u>Agent:</u> [worker_name]</b><br><br>"
			dat += "<u>Work count:</u> [work_count]<br>"
			dat += "<u>PE earned:</u> [work_earn]<br>"
			dat += "<u>Attributes gained:</u><br>"
			if(LAZYLEN(work_gain))
				for(var/attribute in work_gain)
					dat += "- [attribute]: [SSlobotomy_corp.work_stats[worker]["gain"][attribute]]<br>"
			else
				dat += "<b>NONE</b><br>"
			var/datum/browser/popup = new(usr, "agent_work_stats_[worker]", "Global [worker_name] Work Statistics", 400, 700)
			popup.set_content(dat)
			popup.open()
			return TRUE
