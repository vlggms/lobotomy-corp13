/datum/objective/escape/escape_with_identity/infiltrator/New() //For infiltrators, so they get mulligan
	var/list/spec_equipment = list()
	spec_equipment += /obj/item/adv_mulligan
	give_special_equipment(spec_equipment)
	..()

/datum/objective/proc/find_target_by_race(race, invert=FALSE) // race = "human", and so on.
	var/list/datum/mind/owners = get_owners()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(!(possible_target in owners) && ishuman(possible_target.current))
			var/mob/living/carbon/human/H = possible_target.current
			if(invert)
				if((H.dna.species.id != race) && H.stat != DEAD)
					possible_targets += possible_target
			else
				if((H.dna.species.id == race) && H.stat != DEAD)
					possible_targets += possible_target
	if(length(possible_targets))
		target = pick(possible_targets)
	update_explanation_text()
	return target
