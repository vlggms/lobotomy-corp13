/datum/disease/staining_rose
	name = "Hanahaki Disease"
	form = "Infection"
	max_stages = 4
	stage_prob = 15
	infectivity = 100
	spread_text = "Airborne"
	disease_flags = CAN_CARRY
	spread_flags = DISEASE_SPREAD_BLOOD|DISEASE_SPREAD_AIRBORNE
	cure_text = "Nothing"
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = DISEASE_SEVERITY_HARMFUL
	var/list/pickable_sounds = list(
		'sound/effects/wounds/blood1.ogg',
		'sound/effects/wounds/blood2.ogg',
		'sound/effects/wounds/blood3.ogg',
		) // some freaky sounds
	var/emote_cooldown_time = 10 SECONDS
	var/emote_cooldown

/datum/disease/staining_rose/cure()
	if(!ishuman(affected_mob))
		return ..()
	to_chat(affected_mob, "The pain in your body subsides.")
	return ..()

/datum/disease/staining_rose/spread() //no airborne spread from a dead person
	if(affected_mob.stat >= HARD_CRIT || affected_mob.health < 0)
		return
	..()

/datum/disease/staining_rose/stage_act()
	. = ..()
	if(!.)
		return

	if(!ishuman(affected_mob))
		return

	var/damage_to_deal = round(stage * 3)
	var/mob/living/carbon/human/H = affected_mob
	if((emote_cooldown < world.time) && (stage >= 2))
		H.manual_emote("[H] coughs up petals!")
		emote_cooldown = (world.time + emote_cooldown_time)
		if(stage >= 4)
			H.add_splatter_floor() // big blood splatter and full roses if we're at stage 4
			if(prob(10))
				new /obj/item/rose(get_turf(affected_mob))
		else
			H.add_splatter_floor(get_turf(src), TRUE)
		var/thesound = pick(pickable_sounds)
		playsound(get_turf(H), thesound, 50, 0, 5)
	H.apply_damage(damage_to_deal, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)


	if((stage >= max_stages) && prob(H.health * 0.3))
		cure(FALSE)
	return
