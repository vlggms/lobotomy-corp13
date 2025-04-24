/datum/disease/muscular_parasites
	name = "Muscle Parasites"
	form = "Parasite"
	max_stages = 2
	spread_text = "Consuming Uncooked Meat"
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	disease_flags = CURABLE|CAN_CARRY
	desc = "If left untreated the subject will suffer from violent muscle spasms."
	cure_text = "Syriniver"
	cures = list(/datum/reagent/medicine/c2/syriniver)
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_MEDIUM
	var/datum/status_effect/spasm_effect

/datum/disease/muscular_parasites/stage_act()
	. = ..()
	if(!.)
		return
	if(stage == 2 && !spasm_effect)
		spasm_effect = affected_mob.apply_status_effect(STATUS_EFFECT_SPASMS)
	var/mob/living/carbon/M = affected_mob
	if(prob(8))
		var/picked_bodypart = pick(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
		var/obj/item/bodypart/bodypart = M.get_bodypart(picked_bodypart)
		if(bodypart && bodypart.status == BODYPART_ORGANIC && !bodypart.is_pseudopart)	 //robotic limbs will mean less scratching overall (why are golems able to damage themselves with self-scratching, but not androids? the world may never know)
			var/can_scratch = !M.incapacitated()
			M.visible_message("[can_scratch ? span_warning("[M] scratches [M.p_their()] [bodypart.name].") : ""]", span_warning("Your [bodypart.name] itches. [can_scratch ? " You scratch it." : ""]"))
			if(can_scratch)
				bodypart.receive_damage(0.2)

/datum/disease/muscular_parasites/remove_disease()
	if(spasm_effect)
		affected_mob.remove_status_effect(spasm_effect)
	return ..()
