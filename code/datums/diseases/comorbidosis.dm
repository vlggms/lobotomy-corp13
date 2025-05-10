/datum/disease/comorbidosis
	name = "Comorbidosis"
	form = "Bacteria"
	max_stages = 1
	spread_text = "Blood"
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	disease_flags = CURABLE|CAN_CARRY
	desc = "Provides a moderate regerative effect to patients based on how many other diseases they carry."
	cure_text = "Spaceacillin"
	cures = list(/datum/reagent/medicine/spaceacillin)
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_POSITIVE

/datum/disease/comorbidosis/stage_act()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = affected_mob
	var/healing_bonus = length(H.diseases) - 1
	Heal(H, healing_bonus)

/datum/disease/comorbidosis/proc/Heal(mob/living/carbon/human/M, heal_amt)
	if(!heal_amt)
		return FALSE

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC) //more effective on burns

	if(!parts.len)
		return

	if(prob(5))
		to_chat(M, "<span class='notice'>You feel your wounds close into soggy purple scars.</span>")

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len * 0.5, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()
