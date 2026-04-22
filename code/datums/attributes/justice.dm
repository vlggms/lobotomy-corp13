GLOBAL_LIST_INIT(justice_multiplier, 0.5)

/datum/attribute/justice
	name = JUSTICE_ATTRIBUTE
	desc = "Attribute responsible for damage and move speed."
	affected_stats = list("Power Modifier") //todo : split into Melee Strength and Movement Speed

/datum/attribute/justice/on_update(mob/living/carbon/user)
	if(!istype(user))
		return FALSE
	var/slowdown = -(get_modified_level() / JUSTICE_MOVESPEED_DIVISER)
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/justice_attribute, multiplicative_slowdown = slowdown)
	return TRUE

//Getting the justice multiplier on attacks
/proc/get_attack_multiplier(mob/living/carbon/human/user)
	if(!istype(user))
		return 1
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	if(!userjust)
		return 1
	return 1 + ((userjust / 100) * GLOB.justice_multiplier)
