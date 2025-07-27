/**
 * The deal damage proc is a replacement for apply_damage() aimed to reduce copy-paste.
 * In comparison to apply_damage() it:
 * * Automatically checks for armor, and applies its damage reduction effects
 * * Can deal with multiple damages, read damage_type point 1
 *
 * damage_amount = The amount of damage you want to apply.
 *
 * damage_type = The damage types you want to apply, can be a list.
 * * if damage_type is a list, it will divide the damage_amount by the list lenght to always be at the "same" damage then it will apply each damage in the list equally, considering their individual armor values.
 */
/mob/living/proc/deal_damage(damage_amount, damage_type)
	if(!islist(damage_type)) // they just want to apply a single damage type
		return apply_damage(damage_amount, damage_type, blocked = (damage_type != BRUTE ? run_armor_check(null, damage_type) : null), spread_damage = TRUE)

	var/list/damage_types = damage_type
	damage_amount = damage_amount / damage_types.len // make sure the damage amount is still correct by dividing it
	for(var/damage as anything in damage_types)
		apply_damage(damage_amount, damage, blocked = (damage_type != BRUTE ? run_armor_check(null, damage) : null), spread_damage = TRUE)
