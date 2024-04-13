/obj/structure/altrefiner/chance
	name = "Chance Refinery"
	desc = "A machine used by the Extraction Officer to coinflip for a PE box. Costs 25 cargo PE."
	icon_state = "dominator-purple"
	extraction_cost = 25

/obj/structure/altrefiner/chance/attack_hand(mob/living/carbon/M)
	. = ..()
	if(!.)
		return

	if(prob(50))
		to_chat(M, span_notice("Refining success."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		new /obj/item/refinedpe(get_turf(src))
	else
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(M, span_warning("Refining failure. Please try again."))
