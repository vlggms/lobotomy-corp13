/datum/objective_item/steal/iandog
	name = "Ian, the Head of Personnel's pet corgi, alive."
	targetitem = /obj/item/pet_carrier
	difficulty = 20
	excludefromjob = list("Head of Personnel")
	altitems = list(/obj/item/clothing/head/mob_holder)

/datum/objective_item/steal/iandog/New()
	special_equipment += /obj/item/lazarus_injector
	..()

/datum/objective_item/steal/iandog/check_special_completion(obj/item/I)
	if(istype(I, /obj/item/pet_carrier))
		var/obj/item/pet_carrier/C = I
		for(var/mob/living/simple_animal/pet/dog/corgi/ian/D in C)
			if(D.stat != DEAD)//checks if pet is alive.
				return TRUE
		for(var/mob/living/simple_animal/pet/dog/corgi/puppy/D in C)
			if(D.stat != DEAD)//checks if pet is alive.
				if(D.desc == "It's the HoP's beloved corgi puppy.")
					return TRUE
	if(istype(I, /obj/item/clothing/head/mob_holder))
		var/obj/item/clothing/head/mob_holder/C = I
		for(var/mob/living/simple_animal/pet/dog/corgi/ian/D in C)
			if(D.stat != DEAD)//checks if pet is alive.
				return TRUE
		for(var/mob/living/simple_animal/pet/dog/corgi/puppy/D in C)
			if(D.stat != DEAD)//checks if pet is alive.
				if(D.desc == "It's the HoP's beloved corgi puppy.")
					return TRUE
	return FALSE

/datum/objective_item/steal/runtimecat
	name = "Runtime, the Chief Medical Officer's pet, alive."
	targetitem = /obj/item/pet_carrier
	difficulty = 20
	excludefromjob = list("Chief Medical Officer")
	altitems = list(/obj/item/clothing/head/mob_holder)

/datum/objective_item/steal/runtimecat/New()
	special_equipment += /obj/item/lazarus_injector
	..()

/datum/objective_item/steal/runtimecat/check_special_completion(obj/item/H)
	if(istype(H, /obj/item/pet_carrier))
		var/obj/item/pet_carrier/T = H
		for(var/mob/living/simple_animal/pet/cat/runtime/D in T)
			if(D.stat != DEAD)//checks if pet is alive.
				return TRUE
	if(istype(H, /obj/item/clothing/head/mob_holder))
		var/obj/item/clothing/head/mob_holder/T = H
		for(var/mob/living/simple_animal/pet/cat/runtime/D in T)
			if(D.stat != DEAD)//checks if pet is alive.
				return TRUE
	return FALSE

/datum/objective_item/steal/lamarr // Might require maintaining if Xeno rework is merged
	name = "Lamarr The subject of study by the research director."
	targetitem = /obj/item/clothing/mask/facehugger/lamarr
	difficulty = 40
	excludefromjob = list("Research Director")

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
