/datum/attribute/justice
	name = JUSTICE_ATTRIBUTE
	desc = "Attribute responsible for damage and move speed."

/datum/attribute/justice/on_update(mob/living/carbon/user)
	if(!istype(user))
		return FALSE
	var/slowdown = -(get_level()/260) // Maximum being -0.5, without buffs
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/justice_attribute, multiplicative_slowdown = slowdown)
	return TRUE
