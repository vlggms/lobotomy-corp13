
/**
 * Adjusts the health of a simple mob by a set amount and wakes AI if its idle to react
 *
 * Arguments:
 * * amount The amount that will be used to adjust the mob's health
 * * updating_health If the mob's health should be immediately updated to the new value
 * * forced If we should force update the adjustment of the mob's health no matter the restrictions, like GODMODE
 */
/mob/living/simple_animal/proc/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = FALSE
	if(forced || !(status_flags & GODMODE))
		if(!forced && amount < 0 && HAS_TRAIT(src, TRAIT_PHYSICAL_HEALING_BLOCKED))
			amount = 0
		bruteloss = round(clamp(bruteloss + amount, 0, maxHealth * 2), DAMAGE_PRECISION)
		if(updating_health)
			updatehealth()
		. = amount
	if(ckey || stat)
		return
	if(AIStatus == AI_IDLE)
		toggle_ai(AI_ON)

/mob/living/simple_animal/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount * damage_coeff.brute * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount * damage_coeff.fire * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount * damage_coeff.oxy * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount * damage_coeff.tox * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount * damage_coeff.clone * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustStaminaLoss(amount, updating_health = FALSE, forced = FALSE)
	if(forced)
		staminaloss = max(0, min(max_staminaloss, staminaloss + amount))
	else
		staminaloss = max(0, min(max_staminaloss, staminaloss + (amount * damage_coeff.stamina)))
	update_stamina()

/mob/living/simple_animal/adjustRedLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		var/damage_coeff_value = damage_coeff.red
		if(GLOB.damage_type_shuffler?.is_enabled)
			damage_coeff_value = damage_coeff.getCoeff(GLOB.damage_type_shuffler.mapping_defense[RED_DAMAGE])
		. = adjustHealth(amount * damage_coeff_value * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustWhiteLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		var/damage_coeff_value = damage_coeff.white
		if(GLOB.damage_type_shuffler?.is_enabled)
			damage_coeff_value = damage_coeff.getCoeff(GLOB.damage_type_shuffler.mapping_defense[WHITE_DAMAGE])
		. = adjustHealth(amount * damage_coeff_value * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustBlackLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		var/damage_coeff_value = damage_coeff.black
		if(GLOB.damage_type_shuffler?.is_enabled)
			damage_coeff_value = damage_coeff.getCoeff(GLOB.damage_type_shuffler.mapping_defense[BLACK_DAMAGE])
		. = adjustHealth(amount * damage_coeff_value * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustPaleLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		var/damage_coeff_value = damage_coeff.pale
		if(GLOB.damage_type_shuffler?.is_enabled)
			damage_coeff_value = damage_coeff.getCoeff(GLOB.damage_type_shuffler.mapping_defense[PALE_DAMAGE])
		. = adjustHealth(amount * damage_coeff_value * CONFIG_GET(number/damage_multiplier), updating_health, forced)
