/obj/structure/refiner/blood
	name = "Blood Refinery"
	desc = "A machine used by the Extraction Officer to give all but 1 of their HP for a chance at a PE box."
	icon_state = "dominator-red"
	var/ready = TRUE

/obj/structure/refiner/blood/proc/reset()
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	ready = TRUE

/obj/structure/refiner/blood/attack_hand(mob/living/carbon/M)
	..()
	//Only the EO may use it
	if(M?.mind?.assigned_role != "Extraction Officer")
		to_chat(M, span_warning("Only the Extraction Officer can use this machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	if(M.health <= 20)
		to_chat(M, span_warning("You have no more blood to give."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	if(!ready)
		to_chat(M, span_warning("This machine is not yet ready."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	var/gambling_number = (M.health - 1)
	M.adjustBruteLoss(gambling_number-1)	//Just in case we get weird rounding shit

	//So you can't actually use it repeatedly
	if(prob(gambling_number-20))
		to_chat(M, span_notice("Refining success."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		new /obj/item/refinedpe(get_turf(src))
		ready = FALSE
	else
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(M, span_warning("Refining failure. Please try again."))
	addtimer(CALLBACK(src, PROC_REF(reset)), 45 SECONDS)

