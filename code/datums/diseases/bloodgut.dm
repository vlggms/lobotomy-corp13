/datum/disease/bloodgut
	name = "Bloodgut"
	form = "Infection"
	max_stages = 3
	stage_prob = 25
	spread_text = "Regurgitated Blood"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Spaceacillin"
	cures = list(/datum/reagent/medicine/spaceacillin)
	desc = "If left untreated the user will periodically vomit blood before eventually exploding."
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_MEDIUM
	var/vomit_pacing = 0

/datum/disease/bloodgut/stage_act()
	. = ..()
	if(!.)
		return

	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/H = affected_mob
	H.blood_volume += 5
	affected_mob.adjust_nutrition(-1)
	vomit_pacing++
	var/blood_added = H.blood_volume - BLOOD_VOLUME_NORMAL
	if(blood_added >= 100 && vomit_pacing >= 6)
		vomitBloodCustom()
		H.blood_volume -= 15
		vomit_pacing = 0

/datum/disease/bloodgut/proc/vomitBloodCustom()
	var/distance = stage
	if(affected_mob.is_mouth_covered()) //make this add a blood/vomit overlay later it'll be hilarious
		affected_mob.visible_message(span_danger("[affected_mob] throws up all over [affected_mob.p_them()]self!"), \
				span_userdanger("You throw up all over yourself!"))
		distance = 0
	else
		affected_mob.visible_message(span_danger("[affected_mob] throws up!"), span_userdanger("You throw up!"))

	playsound(get_turf(src), 'sound/effects/splat.ogg', 50, TRUE)
	var/turf/T = get_turf(affected_mob)

	for(var/i=0 to distance)
		if(T)
			affected_mob.add_splatter_floor(T)
			affected_mob.adjustBruteLoss(0.5)
		T = get_step(T, affected_mob.dir)
		if(T?.is_blocked_turf())
			var/mob/living/carbon/infectee = locate(/mob/living/carbon) in T
			if(infectee)
				infectee.ContactContractDisease(src)
			break

	return TRUE
