/datum/symptom/weaken

	name = "Bone Hollowing"
	desc = "The virus speeds up the user by hollowing it's bones out."
	stealth = 2
	resistance = 0
	stage_speed = 2
	transmittable = -2
	level = 5
	severity = 1
	symptom_delay_min = 25
	symptom_delay_max = 75

/datum/symptom/disfiguration/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = A.affected_mob
	H.physiology.red_mod /= 0.8
	H.physiology.white_mod /= 0.8
	H.physiology.black_mod /= 0.8
	H.physiology.pale_mod /= 0.8

/datum/status_effect/wilting/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.8
	status_holder.physiology.white_mod *= 0.8
	status_holder.physiology.black_mod *= 0.8
	status_holder.physiology.pale_mod *= 0.8


/datum/symptom/disfiguration/End(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.affected_mob)
		REMOVE_TRAIT(A.affected_mob, TRAIT_DISFIGURED, DISEASE_TRAIT)
