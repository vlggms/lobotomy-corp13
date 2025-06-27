/datum/disease/warts
	name = "Warts"
	form = "Virus"
	max_stages = 5
	spread_text = "On contact"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Salicylic Acid"
	cures = list(/datum/reagent/medicine/sal_acid)
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Subject has painful warts."
	severity = DISEASE_SEVERITY_MEDIUM
	disease_flags = CURABLE|CAN_CARRY


/datum/disease/warts/stage_act()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/M = affected_mob
	//It gets worse over time.
	if(prob(8 * stage))
		var/picked_bodypart = pick(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
		var/obj/item/bodypart/bodypart = M.get_bodypart(picked_bodypart)
		if(bodypart && bodypart.status == BODYPART_ORGANIC && !bodypart.is_pseudopart)	 //robotic limbs will mean less scratching overall (why are golems able to damage themselves with self-scratching, but not androids? the world may never know)
			var/can_scratch = !M.incapacitated()
			M.visible_message("[can_scratch ? span_warning("[M] scratches [M.p_their()] [bodypart.name].") : ""]", span_warning("Your [bodypart.name] itches. [can_scratch ? " You scratch it." : ""]"))
			if(can_scratch)
				bodypart.receive_damage(0.2)
				if(prob(30))
					M.add_splatter_floor(get_turf(affected_mob))
