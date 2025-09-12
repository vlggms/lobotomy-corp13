//LC13 Healing chemicals

// Kcorp - heals HP and organ damage
/datum/reagent/medicine/helapoeisis
	name = "Helapoeisis"
	description = "Treats all injuries by restoring one's body to how they remember it was before injury. Less effective on burns."
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
	for(var/organ in H.internal_organs)
		var/obj/item/organ/O = organ
		O.applyOrganDamage(-1)
	if(M.getBruteLoss() > (M.maxHealth*0.25))
		M.adjustBruteLoss(-2*REM, 0)
	else
		M.adjustBruteLoss(-0.5*REM, 0)

	if(M.getFireLoss() > (M.maxHealth*0.25))
		M.adjustFireLoss(-0.2*REM, 0)
	else
		M.adjustFireLoss(-0.05*REM, 0)
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

// Hcorp - Heals Burns/Toxin/Oxy
/datum/reagent/medicine/bolus
	name = "Hongyuan Bolus Concoction"
	description = "A substance known across the city as the \"Essence of Healing\". Effective on all types of damage except Brute. Overdose can cause severe mental atrophy."
	reagent_state = LIQUID
	color = "#1E8BFF"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

/datum/reagent/medicine/bolus/on_mob_life(mob/living/M)
	if(M.getFireLoss() > (M.maxHealth*0.25))
		M.adjustFireLoss(-4*REM, 0)
	else
		M.adjustFireLoss(-0.4*REM, 0)

	if(M.getToxLoss() > (M.maxHealth*0.25))
		M.adjustToxLoss(-4*REM, 0)
	else
		M.adjustToxLoss(-0.4*REM, 0)

	if(M.getOxyLoss() > (M.maxHealth*0.25))
		M.adjustOxyLoss(-4*REM, 0)
	else
		M.adjustOxyLoss(-0.4*REM, 0)

	if(M.getBruteLoss() > (M.maxHealth*0.25))
		M.adjustBruteLoss(-0.4*REM, 0)
	else
		M.adjustBruteLoss(-0.05*REM, 0)

	..()
	. = 1

/datum/reagent/medicine/bolus/overdose_process(mob/living/M)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.adjustSanityLoss(5 * REM) // hopefully keeps them at at least 1 sanity
	new /obj/effect/temp_visual/damage_effect/sinking(get_turf(H))
	..()
	. = 1
