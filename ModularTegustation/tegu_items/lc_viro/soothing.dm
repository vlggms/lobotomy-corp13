/datum/symptom/soothing
	name = "Soothing Feel"
	desc = "The virus deals mild brain damage, healing the mind"
	stealth = 1
	resistance = 2
	stage_speed = -1
	transmittable = -2
	level = 5
	severity = 2
	base_message_chance = 15
	symptom_delay_min = 2
	symptom_delay_max = 15
	threshold_descs = list(
	)

/datum/symptom/soothing/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(prob(10))
		to_chat(H, span_warning("You feel your mind turning to mush."))
	H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2)	//Deals very small amounts of damage.
	H.adjustSanityLoss(-2)

