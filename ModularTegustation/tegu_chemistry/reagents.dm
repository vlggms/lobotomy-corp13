/datum/reagent/bananium
	name = "Bananium"
	description = "A soft, slippery metal. Shining yellow and emitting laughter..?"
	reagent_state = SOLID
	color = "#FFFF00"
	taste_description = "entire circus"
	material = /datum/material/bananium

/datum/reagent/bananium_essence
	name = "Concentrated Bananium Essence"
	description = "An essence made of pure bananium and some other powerful reagents."
	color = "#FAFA5A"
	taste_description = "pure bananium"
	can_synth = FALSE
	addiction_threshold = 3
	overdose_threshold = 5
	metabolization_rate = 0.2

/datum/reagent/bananium_essence/on_mob_life(mob/living/M)
	M.AdjustUnconscious(-50)
	M.AdjustStun(-30)
	M.AdjustKnockdown(-20)
	M.AdjustImmobilized(-20)
	M.AdjustParalyzed(-20)
	M.adjustStaminaLoss(-15, 0)
	M.adjustOxyLoss(-5, 0)
	M.adjustBruteLoss(-2, 0)
	M.adjustFireLoss(-2, 0)
	M.adjustToxLoss(-2, 0, TRUE)
	M.adjustCloneLoss(-1, 0)

/datum/reagent/bananium_essence/addiction_act_stage1(mob/living/M)
	M.hallucination += 8
	if(prob(10))
		M.emote(pick("twitch","laugh","smile"))
	if(prob(5))
		M.adjustBruteLoss(1, 0)
	if(prob(5))
		M.adjustFireLoss(1, 0)
	..()

/datum/reagent/bananium_essence/addiction_act_stage2(mob/living/M)
	M.hallucination += 16
	if(prob(20))
		M.emote(pick("twitch","laugh","smile"))
	if(prob(10))
		M.adjustBruteLoss(1, 0)
	if(prob(10))
		M.adjustFireLoss(1, 0)
	if(prob(10))
		M.adjustStaminaLoss(5, 0)
	..()

/datum/reagent/bananium_essence/addiction_act_stage3(mob/living/M)
	M.hallucination += 24
	if(prob(30))
		M.emote(pick("twitch","laugh","smile"))
	if(prob(15))
		M.adjustBruteLoss(1, 0)
	if(prob(15))
		M.adjustFireLoss(1, 0)
	if(prob(15))
		M.adjustStaminaLoss(5, 0)
	if(prob(15))
		M.adjustToxLoss(1, 0, TRUE)
	..()

/datum/reagent/bananium_essence/addiction_act_stage4(mob/living/carbon/human/M)
	M.hallucination += 32
	if(prob(40))
		M.emote(pick("twitch","laugh","smile"))
	if(prob(20))
		M.adjustBruteLoss(1, 0)
	if(prob(20))
		M.adjustFireLoss(1, 0)
	if(prob(20))
		M.adjustStaminaLoss(5, 0)
	if(prob(20))
		M.adjustToxLoss(1, 0, TRUE)
	if(prob(20))
		M.adjustCloneLoss(1, 0)
	..()
	. = 1

/datum/reagent/bananium_essence/overdose_process(mob/living/M)
	M.ForceContractDisease(new /datum/disease/transformation/clown_mutant(), FALSE, TRUE) // Uh oh...
	M.adjustStaminaLoss(-10, 0) // Overdose has its own benefits.
	M.adjustBruteLoss(-2, 0)
	M.adjustFireLoss(-2, 0)
	M.adjustCloneLoss(2, 0) // And draws...
	if(prob(50))
		M.emote(pick("twitch","laugh","smile"))
	..()
