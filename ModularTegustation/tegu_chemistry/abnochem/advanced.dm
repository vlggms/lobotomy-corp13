///// Advanced
/datum/reagent/abnormality/odisone // Increases Fort and Justice by 10 while reducing all other stats by 20
	name = "Odisone"
	description = "Deriving from the latin odium, this substance \
		highens the thrill of combat while greatly reducing the \
		subjects ability to think."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = COLOR_RED
	stat_changes = list(15, -5, -5, 15)

/datum/reagent/abnormality/dyscrasone // Addictive stat buffing. Debuff is in status_effects/debuff.dm
	name = "Dyscrasone"
	description = "This drug increases all of a subjects attributes \
		but induces a heavy withdrawl penalty."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = COLOR_BUBBLEGUM_RED
	stat_changes = list(10, 10, 10, 10)

/datum/reagent/abnormality/dyscrasone/on_mob_metabolize(mob/living/L)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.remove_status_effect(/datum/status_effect/display/dyscrasone_withdrawl)

/datum/reagent/abnormality/dyscrasone/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.apply_status_effect(/datum/status_effect/display/dyscrasone_withdrawl)

/datum/reagent/abnormality/serelam // Increases Prudence and Temperance by 10 while reducing all other stats by 20
	name = "Serelam"
	description = "Formed from the mixture of mundance and \
		supernatural fluids, this substance strengthens the \
		users calm in intense situations but also weakens \
		their muscles during combat."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	stat_changes = list(-5, 15, 15, -5)

/datum/reagent/abnormality/culpusumidus // Increases Prudence and heals SP but inflicts sanity damage when exiting system.
	name = "Culpus Umidus"
	description = "This fluid increases prudence but induces \
		a intense feeling of remorse when leaving the subjects system."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = COLOR_BEIGE
	sanity_restore = 2
	stat_changes = list(0, 10, 0, 0)

/datum/reagent/abnormality/culpusumidus/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		to_chat(H, span_warning("You need to suffer for what was done."))
		H.adjustSanityLoss(H.maxSanity * 0.15, TRUE)

/datum/reagent/abnormality/nepenthe // Rapidly restores sanity to those who are insane.
	name = "Lesser Nepenthe"
	description = "Rapidly restores sanity to those who have gone insane. \
		For those who consume this drink, forgetfulness takes away their sorrow."
	metabolization_rate = 1 * REAGENTS_METABOLISM
	color = COLOR_BLUE

/datum/reagent/abnormality/nepenthe/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.sanity_lost)
			H.adjustSanityLoss((-H.maxSanity*0.07)*REM)
		else
			H.adjustSanityLoss(-1*REM)
	return ..()

/datum/reagent/abnormality/piedrabital // Heals but has a chance of immobalizing the subject
	name = "Piedrabital"
	description = "Closes wounds and heals bruises but sometimes causes \
		muscles to seize up due to tissue build up."
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	color = COLOR_BUBBLEGUM_RED

/datum/reagent/abnormality/piedrabital/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(10 + (0.5 * current_cycle)))
			//Chance of stun increases by 0.5 per cycle
			if(!H.IsStun())
				to_chat(H, "Your limbs suddenly spasm and tighten like you have pebbles stuck inside them.")
				H.Stun(10*REM)
		else
			H.adjustBruteLoss(rand(-8,-4)*REM)
	return ..()

/datum/reagent/abnormality/gaspilleur // Heals 2 sanity and health but reduces stats by -40
	name = "Gaspilleur"
	description = "A strange substance that restores the mind and body. \
		Subjects under the effects of this substance report feeling numb \
		physically and emotionally."
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	color = COLOR_RED
	health_restore = 5
	sanity_restore = 5
	stat_changes = list(-40, -40, -40, -40)

/datum/reagent/abnormality/lesser_sange_rau // Rapidly converts blood into health
	name = "Lesser Sange Rau"
	description = "Theorized to be an element of some abnormalities digestive systems. \
		This fluid inefficently converts blood into regenerative tissue."
	metabolization_rate = 1 * REAGENTS_METABOLISM
	color = COLOR_MAROON

/datum/reagent/abnormality/lesser_sange_rau/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.blood_volume > (10 * REAGENTS_METABOLISM))
			H.blood_volume -= (10 * REAGENTS_METABOLISM)
			H.adjustBruteLoss(rand(-4,-1)*REM)
	return ..()
