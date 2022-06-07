
/// depending on the species, it will run the corresponding apply_damage code there
/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE)
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness)

/mob/living/carbon/human/proc/adjustSanityLoss(amount)
	if(status_flags & GODMODE)
		return FALSE
	sanityhealth = clamp((sanityhealth + amount), 0, maxSanity)
	if(sanityhealth > 0)
		if(sanity_lost)
			sanity_lost = FALSE
		return amount
	sanity_lost = TRUE
	var/highest_atr = FORTITUDE_ATTRIBUTE
	if(mind?.attributes)
		var/highest_level = -1
		for(var/datum/attribute/atr in mind.attributes)
			if(atr.level > highest_level)
				highest_level = atr.level
				highest_atr = atr.name
	SanityLossEffect(highest_atr)
	return amount

/mob/living/carbon/human/proc/SanityLossEffect(attribute) // Work-in-progress
	to_chat(src, "<span class='warning'>You've been overwhelmed by what is going on in this place... There's no hope!</span>")
	Paralyze(200) // WIP. Replace it later with cool AI control and whatsnot.
	return TRUE
