/datum/attribute/justice
	name = JUSTICE_ATTRIBUTE
	desc = "Attribute responsible for damage and move speed."
	affected_stats = list("Power Modifier") //todo : split into Melee Strength and Movement Speed

/datum/attribute/justice/on_update(mob/living/carbon/user)
	if(!istype(user))
		return FALSE
	var/slowdown = -(get_modified_level() / JUSTICE_MOD)
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/justice_attribute, multiplicative_slowdown = slowdown)
	return TRUE
