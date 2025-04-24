/*
* You know that story Shiver by Jinji Ito?
* You ever think "man id survive the holes
* im built different".
*/
/datum/disease/porosity
	name = "Porosity"
	form = "Condition"
	agent = "Unknown"
	max_stages = 7
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Subject has mysterious holes spreading across their body."
	severity = DISEASE_SEVERITY_HARMFUL
	disease_flags = CURABLE|CAN_CARRY
	var/mutable_appearance/hole_overlay
	var/list/holed_body = list()
	var/list/solid_bodyparts = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)


/datum/disease/porosity/stage_act()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/M = affected_mob
	if(ishuman(M) && stage >= 2 && prob(8 * stage))
		switch(rand(1,6))
			if(1 to 3)
				var/picked_bodypart = pick(holed_body)
				var/obj/item/bodypart/bodypart = M.get_bodypart(picked_bodypart)
				if(bodypart && bodypart.status == BODYPART_ORGANIC && !bodypart.is_pseudopart)
					var/can_scratch = !M.incapacitated()
					if(prob(15))
						M.visible_message("[can_scratch ? span_warning("[M] scratches [M.p_their()] [bodypart.name].") : ""]", span_warning(pick("More holes appear on your [bodypart.name]", "\
							You tear at the pocketed flesh on your [bodypart.name].", "Bugs! Bugs are in your [bodypart.name]!")))
					bodypart.receive_damage(5)
			if(4 to 5)
				M.adjustSanityLoss(10)
				if(prob(15))
					to_chat(M, span_danger(pick("Wind is whistling through the holes.", "Someone is following you.")))
			if(6)
				return

/datum/disease/porosity/update_stage()
	holed_body.Add(pick_n_take(solid_bodyparts))
	applyHoles(affected_mob)
	return ..()

/datum/disease/porosity/remove_disease()
	if(hole_overlay)
		var/mob/living/carbon/human/H = affected_mob
		H.cut_overlay(hole_overlay)
	return ..()

/datum/disease/porosity/proc/applyHoles(mob/living/carbon/human/H = affected_mob)
	. = TRUE

	if(!H || !ishuman(H))
		return FALSE
	H.cut_overlay(hole_overlay)

	hole_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "blank", -DAMAGE_LAYER)

	for(var/X in H.bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.body_zone in holed_body)
			hole_overlay.add_overlay("holes_[BP.body_zone]")

	H.add_overlay(hole_overlay)
