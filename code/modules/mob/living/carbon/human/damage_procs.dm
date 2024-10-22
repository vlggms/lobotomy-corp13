/// depending on the species, it will run the corresponding apply_damage code there
/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)



//// Damage Effects
/mob/living/carbon/human/adjustRedLoss(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	//Failsafe
	if(. && !forced)
		if(. > 0)
			new /obj/effect/temp_visual/damage_effect/red(get_turf(src))

/mob/living/carbon/human/adjustWhiteLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	var/damage_amt = amount
	if(sanity_lost && white_healable) // Heal sanity instead.
		damage_amt *= -1
	if(damage_amt > 0 && !forced)
		new /obj/effect/temp_visual/damage_effect/white(get_turf(src))
	adjustSanityLoss(damage_amt, forced)
	if(updating_health)
		updatehealth()
	return damage_amt

/mob/living/carbon/human/adjustBlackLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	var/damage_amt = amount
	if(sanity_lost && white_healable) // Heal sanity instead.
		damage_amt *= -1
	if(amount > 0 && !forced)
		new /obj/effect/temp_visual/damage_effect/black(get_turf(src))
	adjustBruteLoss(amount, forced = forced)
	adjustSanityLoss(damage_amt, forced = forced)
	return damage_amt

/mob/living/carbon/human/adjustPaleLoss(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. && !forced)
		if(. > 0)
			new /obj/effect/temp_visual/damage_effect/pale(get_turf(src))

/mob/living/carbon/human/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. && !forced)
		if(. > 0)
			new /obj/effect/temp_visual/damage_effect/tox(get_turf(src))

/mob/living/carbon/human/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	. = ..()
	if(. && !forced)
		if(. > 0)
			new /obj/effect/temp_visual/damage_effect/burn(get_turf(src))

//

/mob/living/carbon/human/proc/adjustSanityLoss(amount, forced = FALSE)
	if((status_flags & GODMODE) || !attributes || stat == DEAD)
		return FALSE
	if(!forced && amount < 0 && HAS_TRAIT(src, TRAIT_SANITY_HEALING_BLOCKED))
		return FALSE
	sanityloss = clamp(sanityloss + amount, 0, maxSanity)
	if(HAS_TRAIT(src, TRAIT_SANITYIMMUNE))
		sanityloss = 0
	if(sanityhealth > maxSanity)
		sanityhealth = maxSanity
	sanityhealth = clamp((maxSanity - sanityloss), 0, maxSanity)
	if(amount > 0)
		playsound(loc, 'sound/effects/sanity_damage.ogg', min(amount, 50), TRUE, -1)
	else if(amount < 0)
		var/turf/T = get_turf(src)
		new /obj/effect/temp_visual/sparkles/sanity_heal(T)
	if(sanity_lost && sanityhealth >= maxSanity)
		QDEL_NULL(ai_controller)
		sanity_lost = FALSE
		grab_ghost(force = TRUE)
		remove_status_effect(/datum/status_effect/panicked_type)
		visible_message(span_boldnotice("[src] comes back to [p_their(TRUE)] senses!"), \
						span_boldnotice("You are back to normal!"))
	else if(!sanity_lost && sanityhealth <= 0)
		sanity_lost = TRUE
		apply_status_effect(/datum/status_effect/panicked)
		var/highest_atr = PRUDENCE_ATTRIBUTE
		if(LAZYLEN(attributes))
			var/highest_level = -1
			for(var/i in shuffle(attributes))
				var/datum/attribute/atr = attributes[i]
				if(atr.get_level() > highest_level)
					highest_level = atr.get_level()
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
	var/datum/status_effect/panicked_type/status_effect_type
	if(SSmaptype.maptype in SSmaptype.citymaps && attribute == JUSTICE_ATTRIBUTE)
		attribute = TEMPERANCE_ATTRIBUTE // Justice panics default to temerance panics on city, no containment cells.
	switch(attribute)
		if(FORTITUDE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/murder
			warning_text = "[src] screams for a moment, murderous intent shining in [p_their()] eyes."
			status_effect_type = /datum/status_effect/panicked_type/murder
		if(PRUDENCE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/suicide
			warning_text = "[src] stops moving entirely, [p_they()] lost all hope..."
			status_effect_type = /datum/status_effect/panicked_type/suicide
		if(TEMPERANCE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/wander
			warning_text = "[src] twitches for a moment, [p_their()] eyes looking for [SSmaptype.maptype in SSmaptype.citymaps ? "a way out" : "an exit"]."
			status_effect_type = /datum/status_effect/panicked_type/wander
		if(JUSTICE_ATTRIBUTE)
			ai_controller = /datum/ai_controller/insane/release
			warning_text = "[src] laughs for a moment, as [p_they()] start[p_s()] approaching nearby containment zones."
			status_effect_type = /datum/status_effect/panicked_type/release
	apply_status_effect(status_effect_type)
	visible_message(span_bolddanger("[warning_text]"), \
					span_userdanger("You've been overwhelmed by what is going on in this place... There's no hope!"))
	var/turf/T = get_turf(src)
	if(mind)
		if(mind.name && mind.active && !istype(T.loc, /area/ctf))
			deadchat_broadcast(" has went insane(<i>[initial(status_effect_type.icon)]</i>) at <b>[get_area_name(T)]</b>.", "<b>[mind.name]</b>", follow_target = src, turf_target = T, message_type=DEADCHAT_DEATHRATTLE)
		mind.respawn_cooldown = world.time + CONFIG_GET(number/respawn_delay)
	ghostize(1)
	InitializeAIController()
	SpreadPanic(FALSE)
	return TRUE
