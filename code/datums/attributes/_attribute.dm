GLOBAL_LIST_INIT(attribute_types, subtypesof(/datum/attribute))

/datum/attribute
	var/name = "Attribute"
	var/desc = ""
	/// Current level of the skill
	var/level = 0
	/// How high it can go
	var/level_limit = 130
	/// How low it can get
	var/level_lower_limit = 0

// Procs

/datum/attribute/proc/get_level() // Returns current level of attribute
	return level

/datum/attribute/proc/on_update(mob/living/carbon/user)
	return

/datum/attribute/proc/adjust_level(mob/living/carbon/human/user, addition)
	if(!istype(user))
		return FALSE
	level = clamp((level + addition), level_lower_limit, level_limit)
	on_update(user)
	return TRUE

// Other procs

/proc/adjust_attribute_level(mob/living/carbon/human/user, attribute, addition)
	if(!istype(user) || !attribute)
		return 0
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 0
	return atr.adjust_level(user, addition)

/proc/adjust_all_attribute_levels(mob/living/carbon/human/user, addition)
	if(!istype(user))
		return 0
	for(var/atr_type in user.attributes)
		var/datum/attribute/atr = user.attributes[atr_type]
		if(!istype(atr))
			continue
		atr.adjust_level(user, addition)
	return TRUE

/proc/get_attribute_level(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 1
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 1
	return max(1, atr.get_level())

// Returns a combination of attributes, giving a "level" from 1 to 5
/proc/get_user_level(mob/living/carbon/human/user)
	if(!istype(user))
		return 0
	var/collective_levels = 0
	for(var/a in user.attributes)
		var/datum/attribute/atr = user.attributes[a]
		collective_levels += atr.level
	return clamp(round(collective_levels / 70), 1, 5)
