GLOBAL_LIST_INIT(attribute_types, subtypesof(/datum/attribute))

/datum/attribute
	var/name = "Attribute"
	var/desc = ""
	/// Current level of the skill
	var/level = 0
	/// How high it can go
	var/level_limit = 120
	/// How low it can get
	var/level_lower_limit = 0

/datum/attribute/proc/get_level() // Returns current level of attribute
	return level

/datum/attribute/proc/on_update(mob/living/carbon/user)
	return

// Procs

/datum/attribute/proc/adjust_level(mob/living/carbon/human/user, attribute, addition)
	if(!istype(user) || !attribute)
		return FALSE
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return FALSE
	atr.level = clamp((atr.level + addition), atr.level_lower_limit, atr.level_limit)
	atr.on_update(user)
	return TRUE

/proc/adjust_attribute_level(mob/living/carbon/human/user, attribute, addition)
	if(!istype(user) || !attribute)
		return 0
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 0
	return atr.adjust_level(user, attribute, addition)

/proc/get_attribute_level(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 0
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 0
	return max(1, atr.get_level())

// Returns a combination of attributes, giving a "level" from 1 to 6(EX)
/proc/get_user_level(mob/living/carbon/human/user)
	if(!istype(user))
		return 0
	var/collective_levels = 0
	for(var/a in user.attributes)
		var/datum/attribute/atr = user.attributes[a]
		collective_levels += atr.level
	return clamp(round(collective_levels / 70), 1, 5)
