// Virology "advanced" symptoms.
/datum/symptom/adv_transmit
	name = "TCS-TSA 1" // Tiger Co Syndicate - Transmission Speed Accelerant
	desc = "Some sort of a dark, rapidly developing bacteria; Although it makes presence of the virus very obvious, \
	it rapidly transmits and evolves to the last stages almost instantly, possibly killing everything in the process."
	stealth = -9
	resistance = -5
	stage_speed = 7
	transmittable = 5
	level = 19 // Can't get it normally

/datum/symptom/adv_everything
	name = "TCS-MPA 2" // Tiger Co Syndicate - Multi-Purpose Accelerant
	desc = "A multi-purpose strain, capable of increasing most statistics of a virus by a small amount."
	stealth = 2
	resistance = 4
	stage_speed = 4
	transmittable = 3
	level = 19

/datum/symptom/adv_stealth
	name = "TCS-SRA 3" // Tiger Co Syndicate - Stealth Resistance Accelerant
	desc = "A rare symptom, previously unknown to Nanotrasen. \
	This symptom makes virus near to impossible to spot, although hinders its ability to develop fast enough."
	stealth = 7
	resistance = 5
	stage_speed = -9
	transmittable = -3
	level = 19

/datum/symptom/fake_oxygen // Fake self-respiration, heals until stage 5, then begins to kill.
	name = "Self-Respiratory Detonator"
	desc = "Virus that resembles Self-Respiration symptom, up until the last stage where it begins to absord oxygen in victim's body."
	stealth = 1
	resistance = -3
	stage_speed = -3
	transmittable = -4
	level = 19
	severity = 0
	base_message_chance = 5
	symptom_delay_min = 2
	symptom_delay_max = 3
	var/regenerate_blood = FALSE
	threshold_descs = list(
		"Resistance 8" = "Regenerates blood. At the last stage it will ignore body safety thresholds."
	)

/datum/symptom/fake_oxygen/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 8) //blood "regeneration"
		regenerate_blood = TRUE

/datum/symptom/fake_oxygen/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	switch(A.stage)
		if(5)
			M.adjustOxyLoss(5, 0)
			if(prob(20))
				M.losebreath += 2
				M.emote("gasp")
			if(prob(base_message_chance))
				to_chat(M, span_userdanger("[pick("You feel a dull pain in your chest.", "You try to breathe, but can't inhale air!", "Your lungs feel empty!")]"))
			if(regenerate_blood && M.blood_volume < BLOOD_VOLUME_MAX_LETHAL) // It won't really kill you, but you will feel bad.
				M.blood_volume += 2
		if(3, 4)
			M.adjustOxyLoss(-7, 0)
			M.losebreath = max(0, M.losebreath - 4)
			if(regenerate_blood && M.blood_volume < BLOOD_VOLUME_NORMAL)
				M.blood_volume += 1
		if(1, 2)
			if(prob(base_message_chance))
				to_chat(M, span_notice("[pick("Your lungs feel great.", "You realize you haven't been breathing.", "You don't feel the need to breathe.")]"))
	return

/datum/symptom/fake_oxygen/on_stage_change(datum/disease/advance/A)
	if(!..())
		return FALSE
	var/mob/living/carbon/M = A.affected_mob
	if(A.stage >= 3 && A.stage < 5) // Third and fourth stage.
		ADD_TRAIT(M, TRAIT_NOBREATH, DISEASE_TRAIT)
	else
		REMOVE_TRAIT(M, TRAIT_NOBREATH, DISEASE_TRAIT)
	return TRUE

/datum/symptom/fake_oxygen/End(datum/disease/advance/A)
	if(!..())
		return
	REMOVE_TRAIT(A.affected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)


// "Diseases" for bottles.
//TS
/datum/disease/advance/adv_ts
	copy_type = /datum/disease/advance

/datum/disease/advance/adv_ts/New()
	symptoms = list(new/datum/symptom/adv_transmit)
	..()

//MP
/datum/disease/advance/adv_mp
	copy_type = /datum/disease/advance

/datum/disease/advance/adv_mp/New()
	symptoms = list(new/datum/symptom/adv_everything)
	..()

//SR
/datum/disease/advance/adv_sr
	copy_type = /datum/disease/advance

/datum/disease/advance/adv_sr/New()
	symptoms = list(new/datum/symptom/adv_stealth)
	..()

/datum/disease/advance/fake_oxygen
	copy_type = /datum/disease/advance

/datum/disease/advance/fake_oxygen/New()
	symptoms = list(new/datum/symptom/fake_oxygen)
	..()

/datum/disease/transformation/clown_mutant
	name = "Bananium Essence Overdose"
	cure_text = "large amount of modafinil."
	cures = list(/datum/reagent/medicine/modafinil) // Good luck
	cure_chance = 1 // As I said - GOOD LUCK.
	stage_prob = 3
	agent = "Pure joy"
	desc = "Nobody can withstand the true power of bananium."
	severity = DISEASE_SEVERITY_BIOHAZARD
	visibility_flags = NONE
	stage1 = list("You feel happy!")
	stage2 = list("You are twitching from happiness!")
	stage3 = list(span_danger("You feel like your arm is  going to fall off!"), span_danger("Your skin twitches."), span_danger("You could really go for some bananium right now!"))
	stage4 = list(span_danger("You hear circus sounds everywhere."), span_danger("Your feel like your head is about to explode!"))
	stage5 = list(span_danger("H... O... N... K..."))
	new_form = /mob/living/simple_animal/hostile/retaliate/clown

/datum/disease/transformation/clown_mutant/do_disease_transformation(mob/living/affected_mob)
	var/list/le_list = list(\
		/mob/living/simple_animal/hostile/retaliate/clown/mutant/slow = 8, \
		/mob/living/simple_animal/hostile/retaliate/clown/mutant/glutton = 3, \
		/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/honcmunculus = 1)
	new_form = pickweight(le_list)

	if(istype(affected_mob, /mob/living/carbon) && affected_mob.stat != DEAD)
		if(stage5)
			to_chat(affected_mob, pick(stage5))
		if(QDELETED(affected_mob))
			return
		if(affected_mob.notransform)
			return
		affected_mob.notransform = 1
		for(var/obj/item/W in affected_mob.get_equipped_items(TRUE))
			affected_mob.dropItemToGround(W)
		for(var/obj/item/I in affected_mob.held_items)
			affected_mob.dropItemToGround(I)
		var/mob/living/new_mob = new new_form(affected_mob.loc)
		if(istype(new_mob))
			if(bantype && is_banned_from(affected_mob.ckey, bantype))
				replace_banned_player(new_mob)
			new_mob.a_intent = INTENT_HARM
			if(affected_mob.mind)
				affected_mob.mind.transfer_to(new_mob)
			else
				new_mob.key = affected_mob.key
		if(transformed_antag_datum)
			new_mob.mind.add_antag_datum(transformed_antag_datum)
		new_mob.name = pick(affected_mob.real_name, "clown mutant", "horrible creature", "monster", "biological mess")
		new_mob.real_name = new_mob.name
		new_mob.remove_language(/datum/language/common) // Suffer
		qdel(affected_mob)

/datum/disease/transformation/clown_mutant/stage_act()
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if (prob(20))
				affected_mob.emote("laugh")
			if (prob(10))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/happiness = 2))
		if(3)
			if (prob(30))
				affected_mob.emote("smile")
			if (prob(10))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/happiness = 3))
				affected_mob.say(pick("Urgh...", "Heh-he...", "Ho-nk..."))
			if (prob(5))
				to_chat(affected_mob, span_danger("You feel a stabbing pain in your head."))
				affected_mob.Unconscious(20)
		if(4)
			if (prob(30))
				to_chat(affected_mob, span_danger("The pain is unbearable!"))
				affected_mob.emote("cry")
			if (prob(20))
				to_chat(affected_mob, span_danger("Your skin begins to shift, hurting like hell!"))
				affected_mob.emote("scream")
				affected_mob.Jitter(4)
			if (prob(10))
				affected_mob.reagents.add_reagent_list(list(/datum/reagent/drug/happiness = 4))
				affected_mob.say(pick("Kkkwah...", "Hhhonn...", "K-iilll, me-e...", "The pa-ain..."))
