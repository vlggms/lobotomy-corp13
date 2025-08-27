/datum/reagent/bananium
	name = "Bananium"
	description = "A soft, slippery metal. Shining yellow and emitting laughter..?"
	reagent_state = SOLID
	color = "#FFFF00"
	taste_description = "pure bananium"
	material = /datum/material/bananium

/datum/reagent/drug/bananium_essence
	name = "Concentrated Bananium Essence"
	description = "An essence made of pure bananium and some other powerful reagents."
	color = "#FAFA5A"
	taste_description = "entire circus"
	overdose_threshold = 5
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	addiction_types = list(/datum/addiction/bananium_essence = 10)

/datum/reagent/drug/bananium_essence/on_mob_life(mob/living/M)
	M.AdjustUnconscious(-5)
	M.AdjustStun(-5)
	M.AdjustKnockdown(-5)
	M.AdjustImmobilized(-5)
	M.AdjustParalyzed(-5)
	M.adjustStaminaLoss(-10, 0)
	M.adjustOxyLoss(-5, 0)
	M.adjustBruteLoss(-2, 0)
	M.adjustFireLoss(-2, 0)
	M.adjustToxLoss(-2, 0, TRUE)
	M.adjustCloneLoss(-1, 0)
	if(prob(4))
		M.emote(pick("twitch", "smile"))
		M.Jitter(4)
	..()

/datum/reagent/drug/bananium_essence/overdose_process(mob/living/M)
	M.ForceContractDisease(new /datum/disease/transformation/clown_mutant(), FALSE, TRUE) // Uh oh...
	M.adjustStaminaLoss(-5, 0) // Overdose has its own benefits.
	M.adjustBruteLoss(-1.5, 0)
	M.adjustFireLoss(-1.5, 0)
	M.adjustCloneLoss(1.5, 0) // And draws...
	if(prob(30))
		M.emote(pick("twitch","laugh","smile"))
		if(prob(50))
			M.Jitter(4)
	..()
