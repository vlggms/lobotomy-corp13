/datum/disease/parasite
	form = "Parasite"
	name = "Parasitic Infection"
	max_stages = 4
	cure_text = "Surgical replacement of the liver."
	agent = "Consuming Live Parasites"
	spread_text = "Intermediate Parasite"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 1
	desc = "If left untreated the subject will passively lose nutrients and eventually suffer liver damage."
	severity = DISEASE_SEVERITY_NONTHREAT
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	required_organs = list(/obj/item/organ/liver)
	bypasses_immunity = TRUE
	var/obj/item/organ/liver/affected_liver


/datum/disease/parasite/stage_act()
	. = ..()
	if(!.)
		return
	if(!affected_liver)
		affected_liver = affected_mob.getorganslot(ORGAN_SLOT_LIVER)
	if(!affected_liver)
		cure()
		return FALSE
	if(!affected_liver.owner)
		affected_mob.visible_message("<span class='notice'><B>[affected_mob]'s liver is covered in tiny larva! They quickly shrivel and die after being exposed to the open air.</B></span>")
		cure()
		return FALSE
	if(affected_liver.organ_flags & ORGAN_SYNTHETIC)
		to_chat(affected_mob, "<span class='nicegreen'>Your liver starts whirring and making noises like someone threw popcorn into a blender.</span>")
		//That cant be good for your liver.
		affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 20, 200)
		cure()
		return FALSE

	switch(stage)
		if(1)
			if(prob(5))
				affected_mob.emote("cough")
		if(2)
			if(prob(10))
				if(prob(50))
					to_chat(affected_mob, "<span class='notice'>You feel the weight loss already!</span>")
				affected_mob.adjust_nutrition(-3)
		if(3)
			if(prob(20))
				if(prob(20))
					to_chat(affected_mob, "<span class='notice'>You're... REALLY starting to feel the weight loss.</span>")
				affected_mob.adjust_nutrition(-6)
		if(4)
			if(prob(30))
				if(affected_mob.nutrition >= 100)
					if(prob(10))
						to_chat(affected_mob, "<span class='warning'>You feel like your body's shedding weight rapidly!</span>")
					affected_mob.adjust_nutrition(-12)
				else
					affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 5, 200)
					return FALSE
