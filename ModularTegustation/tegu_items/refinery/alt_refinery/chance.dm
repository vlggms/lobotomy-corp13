/obj/structure/altrefiner/chance
	name = "Chance Refinery"
	desc = "A machine used by the Extraction Officer to coinflip for a PE box. Costs 25 cargo PE."
	icon_state = "dominator-purple"
	var/pecost = 25

/obj/structure/altrefiner/chance/attack_hand(mob/living/carbon/M)
	..()
	//Only the EO may use it
	if(M?.mind?.assigned_role != "Extraction Officer")
		to_chat(M, span_warning("Only the Extraction Officer can use this machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	//This is more expensive than regular refining still
	if(SSlobotomy_corp.available_box < pecost)
		to_chat(M, span_warning("Not enough PE boxes stored for this operation. 25 PE is necessary for this operation. Current PE: [SSlobotomy_corp.available_box]."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	if(prob(50))
		to_chat(M, span_notice("Refining success."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		new /obj/item/refinedpe(get_turf(src))
	else
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(M, span_warning("Refining failure. Please try again."))
	SSlobotomy_corp.AdjustAvailableBoxes(-1 * pecost)

