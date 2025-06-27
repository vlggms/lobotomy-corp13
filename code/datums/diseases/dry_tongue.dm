/datum/disease/dry_tongue
	name = "Dry Tongue"
	form = "Condtion"
	max_stages = 1
	spread_text = "Consuming Uncooked Meat"
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	desc = "If left untreated the subject will suffer from the polydipsia. They will require frequent hydration to function normally."
	cure_text = "Spaceacillin"
	cures = list(/datum/reagent/medicine/spaceacillin)
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_MEDIUM
	var/moisture = 100

/datum/disease/dry_tongue/stage_act()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = affected_mob
	var/sanity_percent = (H.sanityhealth / H.maxSanity)
	moisture = clamp(moisture - 5, 0, 150)
	if(H.reagents.has_reagent(/datum/reagent/water, needs_metabolizing = FALSE))
		H.reagents.remove_reagent(/datum/reagent/water, 10)
		moisture = clamp(moisture + 10, 0, 150)

	switch(moisture)
		if(0 to 40)
			if(prob(20))
				H.blur_eyes(10)
			if(prob(20))
				to_chat(H, span_warning("[pick("Your head pounds incessantly.", "Your mouth feels dry.", "You need water")]"))
				H.adjustStaminaLoss(15)
			if(sanity_percent >= 0.3)
				H.adjustSanityLoss(3)
		if(100 to 150)
			if(prob(10))
				if(prob(30))
					to_chat(H, "<span class='notice'>You feel moisturized and in your element!</span>")
				H.adjustStaminaLoss(-5)
				H.adjustSanityLoss(-4)
