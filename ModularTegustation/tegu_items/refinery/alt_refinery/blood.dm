/obj/structure/altrefiner/blood
	name = "Blood Refinery"
	desc = "A machine used by the Extraction Officer to give all but 1 of their HP for a chance at a PE box."
	icon_state = "dominator-red"
	extraction_cost = 75

/obj/structure/altrefiner/blood/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "This machine seems to be upgraded, decreasing damage done.")


/obj/structure/altrefiner/blood/attack_hand(mob/living/carbon/M)
	if(M.health <= 20)
		to_chat(M, span_warning("You have no more blood to give."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	. = ..()
	if(!.)
		return

	//Gamble it
	var/gambling_number = (M.health - 1)
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		gambling_number = gambling_number/2
	M.adjustBruteLoss(gambling_number-1)	//Just in case we get weird rounding shit

	//So you can't actually use it repeatedly, have a min health of 20
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		gambling_number *= 2
	if(prob(gambling_number - 20))
		to_chat(M, span_notice("Refining success."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		new /obj/item/refinedpe(get_turf(src))
	else
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(M, span_warning("Refining failure. Please try again."))
