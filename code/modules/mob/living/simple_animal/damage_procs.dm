
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
		ez_dmg_numbers_text(src.loc, ., BRUTE, 100)
	else
		. = adjustHealth(amount * damage_coeff.brute * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., BRUTE, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., FIRE, 100)
	else
		. = adjustHealth(amount * damage_coeff.burn * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., FIRE, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., OXY, 100)
	else
		. = adjustHealth(amount * damage_coeff.oxy * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., OXY, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., TOX, 100)
	else
		. = adjustHealth(amount * damage_coeff.tox * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., TOX, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., CLONE, 100)
	else
		. = adjustHealth(amount * damage_coeff.clone * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., CLONE, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustStaminaLoss(amount, updating_health = FALSE, forced = FALSE)
	if(forced)
		staminaloss = max(0, min(max_staminaloss, staminaloss + amount))
		ez_dmg_numbers_text(src.loc, ., STAMINA, 100)
	else
		staminaloss = max(0, min(max_staminaloss, staminaloss + (amount * damage_coeff.stamina)))
		ez_dmg_numbers_text(src.loc, ., STAMINA, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))
	update_stamina()

/mob/living/simple_animal/adjustRedLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., RED_DAMAGE, 100)
	else
		. = adjustHealth(amount * damage_coeff.red * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., RED_DAMAGE, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustWhiteLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., WHITE_DAMAGE, 100)
	else
		. = adjustHealth(amount * damage_coeff.white * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., WHITE_DAMAGE, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustBlackLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., BLACK_DAMAGE, 100)
	else
		. = adjustHealth(amount * damage_coeff.black * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., BLACK_DAMAGE, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))

/mob/living/simple_animal/adjustPaleLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., PALE_DAMAGE, 100)
	else
		. = adjustHealth(amount * damage_coeff.pale * CONFIG_GET(number/damage_multiplier), updating_health, forced)
		ez_dmg_numbers_text(src.loc, ., PALE_DAMAGE, 100 * damage_coeff.brute * CONFIG_GET(number/damage_multiplier))
