/datum/disease/pallidification
	name = "Pallidification"
	form = "Condtion"
	max_stages = 2
	spread_text = "Being Consumed by a Whale or Consuming Pallid Flesh"
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	disease_flags = CURABLE|CAN_CARRY
	desc = "If left untreated the infected will become a violent mutant."
	cure_text = "Maintain above 60% sanity for around 3 minutes since infection."
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_HARMFUL
	stage_prob = 0
	var/final_stage_time = 0
	var/mutable_appearance/pallid_membrane

/datum/disease/pallidification/stage_act()
	. = ..()
	if(!.)
		return

	//Afteradd is not processing this bit of code so im putting it here -IP
	if(final_stage_time == 0)
		final_stage_time = world.time + (1 MINUTES)

	var/mob/living/carbon/human/H = affected_mob
	var/sanity_percent = (H.sanityhealth / H.maxSanity)
	switch(stage)
		if(1)
			H.adjustSanityLoss(H.maxSanity * 0.05)
			if(prob(15))
				to_chat(affected_mob, span_danger("[pick("You feel aimless.", "You brush off a white membrane growing on your shoulder.", "White membrane is growing out of you.")]"))
			if(world.time >= final_stage_time || H.sanity_lost)
				update_stage(min(stage + 1, max_stages))
		if(2)
			if(sanity_percent >= 0.6)
				cure()
				return FALSE
			if(!istype(H.ai_controller, /datum/ai_controller/insane/murder))
				//Replaces AI with murder one
				if(!H.sanity_lost)
					H.adjustSanityLoss(500)
				QDEL_NULL(H.ai_controller)
				H.ai_controller = /datum/ai_controller/insane/murder
				//Its too late, they are pallid now.
				ADD_TRAIT(H, TRAIT_BRUTESANITY, DISEASE_TRAIT)
				H.InitializeAIController()
				if(!pallid_membrane)
					AddSickOverlay()

/datum/disease/pallidification/cure()
	to_chat(affected_mob, span_nicegreen("You tear away the pallid membrane."))
	return ..()

/datum/disease/pallidification/remove_disease()
	if(pallid_membrane)
		var/mob/living/carbon/human/H = affected_mob
		H.cut_overlay(pallid_membrane)
		REMOVE_TRAIT(H, TRAIT_BRUTESANITY, DISEASE_TRAIT)
		H.adjustSanityLoss(-500)
	return ..()

/datum/disease/pallidification/proc/AddSickOverlay()
	pallid_membrane = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "pallid")
	affected_mob.add_overlay(pallid_membrane)
