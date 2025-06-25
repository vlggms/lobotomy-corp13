//EO Key
/obj/item/extraction/key
	name = "Suppression Level Control Key"
	desc = "Use on a work console to lower the qliphoth suppression field of the abnormality cell, speeding up work."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "key"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/machinery/computer/abnormality/archived_console = null
	var/stored_user
	var/passed_variable = EXTRACTION_KEY
	var/itemname = "Key"
	var/howtouse = "This tool can only be used on a containment cell that has not reached 50% understanding, and will expire when understanding reaches 50%. This does NOT affect Qliphoth Counter."

/obj/item/extraction/key/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice("This tool seems to be upgraded, increases work speed even more.")

/obj/item/extraction/key/proc/UserDeath()
	if(archived_console)
		archived_console.ApplyEOTool(passed_variable, TRUE, src)
	UnregisterSignal(stored_user, COMSIG_LIVING_DEATH)

/obj/item/extraction/key/Destroy()
	if(archived_console)
		archived_console.ApplyEOTool(passed_variable, TRUE)
	if(stored_user)
		UnregisterSignal(stored_user, COMSIG_LIVING_DEATH)
	return ..()

/obj/item/extraction/key/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(!tool_checks(user))
		return FALSE //You can't do any special interactions
	if(archived_console)
		to_chat(user, span_warning("You must remove the currently active [itemname] before placing a new one!"))
		return FALSE
	if(istype(A, /obj/machinery/computer/abnormality))
		if(archived_console)
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			to_chat(user, span_warning("Remove the currently linked [itemname] first!"))
			return FALSE
		var/obj/machinery/computer/abnormality/target = A
		if(target.ApplyEOTool(passed_variable, FALSE, src))
			archived_console = A
			user.playsound_local(user, 'sound/machines/terminal_processing.ogg', 50, FALSE)
			to_chat(user, span_nicegreen("[itemname] succesfully applied!"))
			if(!stored_user)
				RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(UserDeath))
				stored_user = user
			update_icon()
			return TRUE
		user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
		to_chat(user, span_warning("ERROR : [itemname] application failed!"))
		return TRUE
	return FALSE  //Not a console - just hit the thing

/obj/item/extraction/key/tool_action(mob/user)
	if(archived_console)
		user.playsound_local(user, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
		switch(tgui_alert(user,"Remove [itemname] from containment cell?","Extraction Officer [itemname] Prompt",list("Yes", "No")))
			if("Yes")
				user.playsound_local(user, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
				archived_console.ApplyEOTool(passed_variable, TRUE, src)
			if("No")
				user.playsound_local(user, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
		return
	user.playsound_local(user, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
	to_chat(user, span_warning("No linked console detected!"))
	return

/obj/item/extraction/key/proc/Deactivate()
	playsound(src, 'sound/machines/twobeep.ogg', 25, FALSE)
	archived_console = null
	visible_message(span_notice("The [src] buzzes quietly, and the golden lights fade away."))
	update_icon()

/obj/item/extraction/key/update_icon()
	if(!archived_console)
		icon_state = "key"
		return
	icon_state = "key_active"

/obj/item/extraction/key/examine(mob/user)
	. = ..()
	if(archived_console)
		. += "It is actively working on a containment cell."
	. += howtouse
