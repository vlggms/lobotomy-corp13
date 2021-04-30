/datum/export/slime/get_cost(obj/O, allowed_categories = NONE, apply_elastic = TRUE)
	var/costfromparent = ..()
	if (istype(O,/obj/item/slime_extract))
		var/obj/item/slime_extract/slimething = O
		if (slimething.sparkly == TRUE)
			return costfromparent*2
	return costfromparent
