/datum/objective/escape/escape_with_identity/infiltrator/New() //For infiltrators, so they get mulligan
	..()
	give_special_equipment(list(/obj/item/adv_mulligan))
