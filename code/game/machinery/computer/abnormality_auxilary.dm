// Console for all the random managerial stuff like calling rabbits or starting core suppressions
/obj/machinery/computer/abnormality_auxiliary
	name = "auxiliary managerial console"
	desc = "Used for various optional actions available to manager."
	resistance_flags = INDESTRUCTIBLE
	var/datum/suppression/selected_core_type = null

/obj/machinery/computer/abnormality_auxiliary/Initialize()
	. = ..()
	GLOB.abnormality_auxiliary_consoles += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality_auxiliary/Destroy()
	GLOB.abnormality_auxiliary_consoles -= src
	..()

/obj/machinery/computer/abnormality_auxiliary/ui_interact(mob/user)
	. = ..()
	var/dat
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
	var/datum/browser/popup = new(user, "abno_logs", "Auxiliary Managerial Console", 400, 400)
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
		if(href_list["choose_suppression"])
			var/datum/suppression/core_type = text2path(href_list["choose_suppression"])
			if(!ispath(core_type) || !(core_type in SSlobotomy_corp.available_core_suppressions))
				return FALSE
			selected_core_type = core_type
			to_chat(usr, "<span class='notice'>[initial(selected_core_type.name)] has been selected!</span>")
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE
		if(href_list["init_suppression"])
			if(!ispath(selected_core_type) || !(selected_core_type in SSlobotomy_corp.available_core_suppressions))
				return FALSE
			if(istype(SSlobotomy_corp.core_suppression))
				to_chat(usr, "<span class='warning'>A core suppression is already in the progress!</span>")
				selected_core_type = null
				return FALSE
			SSlobotomy_corp.core_suppression = new selected_core_type
			to_chat(usr, "<span class='userdanger'>Good luck, Manager.</span>")
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			addtimer(CALLBACK(SSlobotomy_corp.core_suppression, /datum/suppression/proc/Run), 2 SECONDS)
			return TRUE
