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

/datum/reagent/medicine/helapoeisis/concentrated
	name = "Concentrated Helapoeisis"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	overdose_threshold = 5

// Lcorp/Mcorp - Heals SP
/datum/reagent/medicine/enkephalin
	name = "Refined Enkephalin"
	description = "Enklephalin refined for clinical use. Counters mental corruption and restores the mental state of the patient. Overdose will cause acute hallucinations."
	reagent_state = LIQUID
	color = "#CCFFFF"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

/datum/reagent/medicine/enkephalin/on_mob_life(mob/living/M)
	if(!ishuman(M))
		return
	if(overdosed)
		M.hallucination += 1 //Causes hallucinations in Lob Corp
		return
	var/mob/living/carbon/human/H = M
	if(HAS_TRAIT(H, TRAIT_HEALING)) // Used for "no medipens" challenge quirk
		holder.remove_reagent(/datum/reagent/medicine/enkephalin, 1)
		return
	H.adjustSanityLoss(-2.5*REM) // That's healing 2.5 units.
	..()
	. = 1

// Don't think too much about the names here.
/datum/reagent/medicine/enkephalin/concentrated
	name = "Moonlight Dust"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	overdose_threshold = 5

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

/datum/reagent/medicine/bolus/concentrated
	name = "Concentrated Hongyuan Bolus Concoction"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	overdose_threshold = 5

//Legacy chem

// LC13 Related Chems

/datum/reagent/drug/enkephalin
	name = "Raw Enkephalin"
	description = "Raw, unrefined Enkephalin. A substance known to be a drug, as well as a clean source of energy."
	reagent_state = LIQUID
	color = "#70fa9a"
	overdose_threshold = 15
	addiction_types = list(/datum/addiction/opiods = 25) //Unsure how strong this is ingame but it is addictive

/datum/reagent/drug/enkephalin/on_mob_metabolize(mob/living/L)
	. = ..()
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		H.set_screwyhud(SCREWYHUD_HEALTHY)
		if(istype(H.getorganslot(ORGAN_SLOT_STOMACH), /obj/item/organ/stomach)) //In case it doesn't exist
			var/obj/item/organ/stomach/S = H.getorganslot(ORGAN_SLOT_STOMACH)
			S.metabolism_efficiency -= 0.05

/datum/reagent/drug/enkephalin/on_mob_life(mob/living/M)
	. = ..()
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		H.adjustSanityLoss(-2*REM)
		H.hallucination += 1 //Causes hallucinations in Lob Corp
		H.set_screwyhud(SCREWYHUD_HEALTHY) //just in case of hallucinations
		H.adjustStaminaLoss(-2) //Lack of pain means less fatigue
		//Also slows tumor growth, such as brain tumors

/datum/reagent/drug/enkephalin/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		H.set_screwyhud(SCREWYHUD_NONE)
		if(istype(H.getorganslot(ORGAN_SLOT_STOMACH), /obj/item/organ/stomach)) //In case it doesn't exist
			var/obj/item/organ/stomach/S = H.getorganslot(ORGAN_SLOT_STOMACH)
			S.metabolism_efficiency += 0.5

/datum/reagent/drug/enkephalin/overdose_process(mob/living/M)
	. = ..()
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(prob(10))
			H.losebreath += 0.5 //Can cause the lungs to retract
		H.hallucination += 2
