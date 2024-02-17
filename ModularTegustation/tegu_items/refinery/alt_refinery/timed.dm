/obj/structure/refiner/timed
	name = "Timed Auto-Refinery"
	desc = "A machine used by the Extraction Officer to automatically refine PE at the rate of 5 boxes every 5 minutes."
	icon_state = "dominator-blue"
	var/pecost = 500
	var/ready = TRUE

/obj/structure/refiner/timed/proc/reset()
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	ready = TRUE

/obj/structure/refiner/timed/attack_hand(mob/living/carbon/M)
	..()
	//Only the EO may use it
	if(M?.mind?.assigned_role != "Extraction Officer")
		to_chat(M, span_warning("Only the Extraction Officer can use this machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	//and you actually need the boxes
	if(SSlobotomy_corp.available_box < pecost)
		to_chat(M, span_warning("Not enough PE boxes stored for this operation. 500 PE is necessary for this operation. Current PE: [SSlobotomy_corp.available_box]."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	if(!ready)
		to_chat(M, span_warning("This machine is not yet ready."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	SSlobotomy_corp.AdjustAvailableBoxes(-1 * pecost)
	new /obj/item/refinedpe(get_turf(src))
	new /obj/item/refinedpe(get_turf(src))
	new /obj/item/refinedpe(get_turf(src))
	new /obj/item/refinedpe(get_turf(src))
	new /obj/item/refinedpe(get_turf(src))
	ready = FALSE
	addtimer(CALLBACK(src, PROC_REF(reset)), 5 MINUTES)
