//LC13 Healing chemicals

// Kcorp - heals HP and organ damage
/datum/reagent/medicine/helapoeisis
	name = "Helapoeisis"
	description = "Restores the body to its previous state, treating all physical injuries. Less effective on burns."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

/datum/reagent/medicine/helapoeisis/on_mob_life(mob/living/M)
	if(overdosed)
		M.adjustToxLoss(0.5*REM, 0)
		return
	var/mob/living/carbon/human/H = M
	if(HAS_TRAIT(H, TRAIT_HEALING)) // Used for "no medipens" challenge quirk
		holder.remove_reagent(/datum/reagent/medicine/helapoeisis, 1)
		return
	if(M.getBruteLoss() > (M.maxHealth*0.25))
		M.adjustBruteLoss(-2*REM, 0)
	else
		M.adjustBruteLoss(-0.5*REM, 0)
	..()
	. = 1

// Lcorp/Mcorp - Heals SP
/datum/reagent/medicine/enkephalin
	name = "Enkephalin"
	description = "Counters mental corruption and restores the mental state of the patient. Overdose will cause acute hallucinations."
	reagent_state = LIQUID
	color = "#CCFFFF"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

/datum/reagent/medicine/enkephalin/on_mob_life(mob/living/M)
	if(!ishuman(M))
		return
	if(overdosed)
		return
	var/mob/living/carbon/human/H = M
	if(HAS_TRAIT(H, TRAIT_HEALING)) // Used for "no medipens" challenge quirk
		holder.remove_reagent(/datum/reagent/medicine/enkephalin, 1)
		return
	H.adjustSanityLoss(-5*REM) // That's healing 5 units.
	..()
	. = 1
