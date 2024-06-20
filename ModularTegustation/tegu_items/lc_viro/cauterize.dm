/datum/symptom/cauterize
	name = "Continuous Cauterization"
	desc = "The virus burns the skin, healing brute damage and sealing wounds."
	stealth = -2
	resistance = -2
	stage_speed = 2
	transmittable = 3
	level = 6
	severity = 4
	base_message_chance = 15
	symptom_delay_min = 2
	symptom_delay_max = 15
	threshold_descs = list(
	)

/datum/symptom/cauterize/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(prob(10))
		to_chat(H, span_warning("You feel your skin burn, but your wounds mend."))
	H.adjustBurnLoss(0.2)
	H.adjustBruteLoss(-2)

