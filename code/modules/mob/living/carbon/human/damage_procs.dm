/// depending on the species, it will run the corresponding apply_damage code there
/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)

/mob/living/carbon/human/adjustWhiteLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	var/damage_amt = -amount
	if(sanity_lost && white_healable) // Heal sanity instead.
		damage_amt *= -1
	adjustSanityLoss(damage_amt)
	return damage_amt

/mob/living/carbon/human/proc/adjustSanityLoss(amount)
	if((status_flags & GODMODE) || !attributes)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SANITYIMMUNE))
		amount = maxSanity+1
	if(sanityhealth > maxSanity)
		sanityhealth = maxSanity
	sanityhealth = clamp((sanityhealth + amount), 0, maxSanity)
	if(amount < 0)
		playsound(loc, 'sound/effects/sanity_damage.ogg', min(-amount, 50), TRUE, -1)
	else if(amount > 1)
		var/turf/T = get_turf(src)
		new /obj/effect/temp_visual/sanity_heal(T)
	if(sanity_lost && sanityhealth >= maxSanity)
		QDEL_NULL(ai_controller)
		sanity_lost = FALSE
		grab_ghost(force = TRUE)
		visible_message("<span class='notice'>[src] comes back to [p_their(TRUE)] senses!</span>", \
						"<span class='notice'>You are back to normal!</span>")
	else if(!sanity_lost && sanityhealth <= 0)
		sanity_lost = TRUE
		var/highest_atr = PRUDENCE_ATTRIBUTE
		if(LAZYLEN(attributes))
			var/highest_level = -1
			for(var/i in shuffle(attributes))
				var/datum/attribute/atr = attributes[i]
				if(atr.level > highest_level)
					highest_level = atr.level
					highest_atr = atr.name
		SanityLossEffect(highest_atr)
	update_sanity_hud()
	med_hud_set_sanity()
	return amount

/mob/living/carbon/human/proc/SanityLossEffect(attribute)
	if((status_flags & GODMODE) || HAS_TRAIT(src, TRAIT_SANITYIMMUNE) || stat >= HARD_CRIT)
		return
	QDEL_NULL(ai_controller) // In case there was one already
	SEND_SIGNAL(src, COMSIG_HUMAN_INSANE, attribute)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HUMAN_INSANE, src, attribute)
	playsound(loc, 'sound/effects/sanity_lost.ogg', 75, TRUE, -1)
	var/warning_text = "[src] shakes for a moment..."
	switch(attribute)
		if(FORTITUDE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/murder
			warning_text = "[src] screams for a moment, murderous intent shining in [p_their()] eyes."
		if(PRUDENCE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/suicide
			warning_text = "[src] stops moving entirely, [p_they()] lost all hope..."
		if(TEMPERANCE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/wander
			warning_text = "[src] twitches for a moment, [p_their()] eyes looking for an exit."
		if(JUSTICE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/release
			warning_text = "[src] laughs for a moment, as [p_they()] start[p_s()] approaching nearby containment zones."
	visible_message("<span class='danger'>[warning_text]</span>", \
					"<span class='userdanger'>You've been overwhelmed by what is going on in this place... There's no hope!</span>")
	ghostize(1)
	InitializeAIController()
	return TRUE
