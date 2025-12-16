// For some reason we still have silicons in our codebase, and for some reason they take damage differently than other mobs (they don't take certain types of damage) so here we go with some duplicated code
/mob/living/silicon/deal_damage(damage_amount, damage_type, source = null, flags = null, attack_type = null, blocked = null, def_zone = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE)
	if(!damage_amount) // There are some extremely rare instances of 0 damage pre-armour reduction, for example King of Greed does a 0 damage HurtInTurf to fill up a hitlist to attack later.
		return FALSE

	// Damage shuffler station trait.
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type

	if(!(damage_type in list(BRUTE, RED_DAMAGE, BLACK_DAMAGE, FIRE))) // Silicons will only take these damage types
		return FALSE

	if((!(flags & DAMAGE_FORCED)) && (!PreDamageReaction(damage_amount, damage_type, source, attack_type))) // If our forced argument isn't TRUE, then we expect to receive a TRUE from PreDamageReaction to continue the proc.
		return FALSE

	// We will now send a signal that gives listeners the opportunity to cancel the damage being dealt. For some reason, in the original apply_damage, this happens before a "final damage" calculation, so I have chosen to preserve that behaviour.
	// Some examples of the listeners that may return COMPONENT_MOB_DENY_DAMAGE are manager shields, the Welfare Core reward, or Sweeper Persistence.
	var/signal_return = SEND_SIGNAL(src, COMSIG_MOB_APPLY_DAMGE, damage_amount, damage_type, def_zone, source, flags, attack_type)
	if(signal_return & COMPONENT_MOB_DENY_DAMAGE)
		return FALSE

	// Automatically run an armour check for the provided damage type if we weren't already provided with a blocked value, and if we aren't taking BRUTE damage.
	if((isnull(blocked)) && (damage_type != BRUTE))
		blocked = run_armor_check(null, damage_type)
	var/hit_percent = (100-blocked)/100
	var/bypass_resistance = flags & DAMAGE_PIERCING

	if(hit_percent <= 0 && !(bypass_resistance))
		return FALSE

	var/final_damage = bypass_resistance ? damage_amount : damage_amount * hit_percent

	switch(damage_type)
		if(BRUTE)
			adjustBruteLoss(final_damage, forced = bypass_resistance)
		if(FIRE)
			adjustFireLoss(final_damage, forced = bypass_resistance)
		if(RED_DAMAGE)
			adjustRedLoss(final_damage, forced = bypass_resistance)
		if(BLACK_DAMAGE)
			adjustBlackLoss(final_damage, forced = bypass_resistance)
	return 1


/mob/living/silicon/apply_effect(effect = 0,effecttype = EFFECT_STUN, blocked = FALSE)
	return FALSE //The only effect that can hit them atm is flashes and they still directly edit so this works for now. (This was written in at least 2016. Help)

/mob/living/silicon/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE) //immune to tox damage
	return FALSE

/mob/living/silicon/setToxLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/silicon/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE) //immune to clone damage
	return FALSE

/mob/living/silicon/setCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/silicon/adjustStaminaLoss(amount, updating_health = TRUE, forced = FALSE) //immune to stamina damage.
	return FALSE

/mob/living/silicon/setStaminaLoss(amount, updating_health = TRUE)
	return FALSE

/mob/living/silicon/adjustOrganLoss(slot, amount, maximum = 500) //immune to organ damage (no organs, duh)
	return FALSE

/mob/living/silicon/setOrganLoss(slot, amount)
	return FALSE

/mob/living/silicon/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE) //immune to oxygen damage
	if(istype(src, /mob/living/silicon/ai)) //ais are snowflakes and use oxyloss for being in AI cards and having no battery
		return ..()

	return FALSE

/mob/living/silicon/setOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(istype(src, /mob/living/silicon/ai)) //ditto
		return ..()

	return FALSE
