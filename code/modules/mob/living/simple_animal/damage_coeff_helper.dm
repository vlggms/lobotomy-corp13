// This is a modifier to Simple Animal's damage coeff.
// It's built to standarize the damage changes to abnos and other simple animals without causing them to desync during phase changes.
/datum/dc_change
	/// TRUE if it adds the potency value to damage_coeff, FALSE if it multiplies.
	var/additive = FALSE
	/// The amount the damage type is added or multiplied by.
	var/potency = 0
	/// Affected Damage Type
	var/damage_type = RED_DAMAGE

/**
 * Adds a resistance modifier from an simple animal.
 *
 * vars:
 * * DC - the path of the dc_change to be added OR a list of paths to add.
 *
 * returns:
 * * FALSE if no value added, otherwise TRUE.
 */
/mob/living/simple_animal/proc/AddModifier(DC)
	. = FALSE
	if(islist(DC)) // If List
		for(var/p in DC) // Check each item in the list
			if(!ispath(p,/datum/dc_change)) // If it's not a path, skip it
				continue
			damage_mods.Add(new p) // Add a new one to the list
	else if(!ispath(DC,/datum/dc_change)) // Otherwise, if it's not a path, return.
		return
	else
		damage_mods.Add(new DC) // Otherwise, add a new one to the list.
	UpdateResistances()
	return TRUE

/**
 * Removes a resistance modifier from an simple animal.
 *
 * vars:
 * * DC - the path of the dc_change to be removed.
 *
 * returns:
 * * FALSE if no value removed, otherwise TRUE.
 */
/mob/living/simple_animal/proc/RemoveModifier(DC)
	. = FALSE
	if(islist(DC)) // If list
		for(var/p in DC) // Check each item in the list
			if(!ispath(p,/datum/dc_change))
				continue
			var/modifier = HasDamageMod(p) // Grab it if it exists
			if(!modifier)
				continue
			damage_mods.Remove(modifier) // Then remove it
			QDEL_NULL(modifier)
	else if(!ispath(DC,/datum/dc_change)) // Otherwise, if it's not a path, return.
		return
	else // If it IS a path
		var/modifier = HasDamageMod(DC) // Grab it
		if(!modifier)
			return
		damage_mods.Remove(modifier) // And Remove it
		QDEL_NULL(modifier)
	UpdateResistances()
	return TRUE

/**
 * Used to change a multiple resistances of an simple animal.
 *
 * vars:
 * * resistances - An associative list of damage types to be changed. See: list(RED_DAMAGE = 100, WHITE_DAMAGE = 50)
 */
/mob/living/simple_animal/proc/ChangeResistances(list/resistances = list())
	for(var/DT in resistances)
		ChangeResistance(DT, resistances[DT], FALSE)
	UpdateResistances()
	return

/**
 * Used to change a single resistance of an simple animal.
 *
 * vars:
 * * resistance - the damage type being altered.
 * * value - the number it's being set to.
 * * update (optional) - TRUE by default, if TRUE it will call UpdateResistances() after alteration.
 *
 * returns:
 * * TRUE if value was successfully changed.
 */
/mob/living/simple_animal/proc/ChangeResistance(resistance, value, update = TRUE)
	switch(resistance)
		if(BRUTE)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(brute = value)
		if(BURN)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(burn = value)
		if(TOX)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(tox = value)
		if(CLONE)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(clone = value)
		if(STAMINA)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(stamina = value)
		if(OXY)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(oxy = value)
		if(RED_DAMAGE)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(red = value)
		if(WHITE_DAMAGE)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(white = value)
		if(BLACK_DAMAGE)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(black = value)
		if(PALE_DAMAGE)
			unmodified_damage_coeff_datum = unmodified_damage_coeff_datum.setCoeff(pale = value)
		else
			return FALSE
	if(update)
		UpdateResistances()
	return TRUE

/**
 * Updates all of a mob's resistances to be based on their base value with modifiers added.
 */
/mob/living/simple_animal/proc/UpdateResistances()
	var/list/cached_resistances = unmodified_damage_coeff_datum.getList() // Reset resistances
	for(var/datum/dc_change/D in damage_mods) // Check our multiplicative mods
		if(D.additive)
			continue
		if(islist(D.damage_type))
			for(var/dam_type in D.damage_type)
				if(cached_resistances[dam_type] <= 0) // Immunity / Healing is not modified
					continue
				cached_resistances[dam_type] *= D.potency
		else
			if(cached_resistances[D.damage_type] <= 0) // Immunity / Healing is not modified
				continue
			cached_resistances[D.damage_type] *= D.potency
	for(var/datum/dc_change/D in damage_mods) // Then include additive modifiers
		if(!D.additive)
			continue
		if(islist(D.damage_type))
			for(var/dam_type in D.damage_type)
				if(damage_coeff[dam_type] <= 0) // Immunity / Healing is not modified
					continue
				cached_resistances[dam_type] += D.potency
		else
			if(damage_coeff[D.damage_type] <= 0) // Immunity / Healing is not modified
				continue
			cached_resistances[D.damage_type] += D.potency

	for(var/I in cached_resistances)
		cached_resistances[I] = round(cached_resistances[I], 0.1) // Minimizes damage_coeff datums created due to rampant decimals.

	damage_coeff_datum = damage_coeff_datum.setCoeff(
		cached_resistances[RED_DAMAGE],\
		cached_resistances[WHITE_DAMAGE],\
		cached_resistances[BLACK_DAMAGE],\
		cached_resistances[PALE_DAMAGE],\
		cached_resistances[BRUTE],\
		cached_resistances[BURN],\
		cached_resistances[TOX],\
		cached_resistances[CLONE],\
		cached_resistances[STAMINA],\
		cached_resistances[OXY])

/**
 * Give it a dc_change modifier path and it will check aganist that. If it exists in the list, it will be returned.
 *
 * vars:
 * * mod - A dc_change path
 *
 * returns:
 * * The matching modifier, otherwise FALSE.
 */
/mob/living/simple_animal/proc/HasDamageMod(mod)
	. = FALSE
	if(LAZYLEN(damage_mods))
		for(var/datum/dc_change/DC in damage_mods)
			if(istype(DC, mod))
				return DC


/**
 * Modify a group of resistances by a custom amount.
 * Note: This is permanent unless the returned DCs are kept and removed semi-manually later.
 * Using the other procs and making a custom dc_change datum is preferable to this, along with tying it to a status effect.
 *
 * vars:
 * * target - a simple animal
 * * changes - an associated list of damage types and values (RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, ...)
 * * additive - TRUE if the values should be added/subtracted to the damage_coeff or FALSE if used multiplicatively.
 *
 * returns: A list of DC_Changes if successful, otherwise FALSE.
 */
/proc/ModifyResistances(mob/living/simple_animal/target, list/changes = list(), additive = FALSE)
	if(!target || !LAZYLEN(changes))
		return FALSE
	. = list()
	for(var/DT in changes)
		var/datum/dc_change/DC = new
		DC.additive = additive
		DC.potency = changes[DT]
		DC.damage_type = DT
		. += DC
	target.damage_mods += .
	target.UpdateResistances()
	return

