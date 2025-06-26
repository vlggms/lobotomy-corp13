/obj/structure/altrefiner/timed
	name = "Timed Auto-Refinery"
	desc = "A machine used by the Extraction Officer to automatically refine PE at the rate of 5 boxes every 5 minutes."
	icon_state = "dominator-blue"
	extraction_cost = 500
	var/ready = TRUE

/obj/structure/altrefiner/timed/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "This machine seems to be upgraded, reducing its time to produce boxes by 2 minutes.")

/obj/structure/altrefiner/timed/proc/reset()
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	ready = TRUE

/obj/structure/altrefiner/timed/attack_hand(mob/living/carbon/M)
	var/reset_time = 5 MINUTES
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		reset_time = 3 MINUTES
	if(!ready)
		to_chat(M, span_warning("This machine is not yet ready."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	. = ..()
	if(!.)
		return

	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	for(var/i in 1 to 5)
		new /obj/item/refinedpe(get_turf(src))

	ready = FALSE
	addtimer(CALLBACK(src, PROC_REF(reset)), reset_time)
