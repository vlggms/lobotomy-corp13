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
	/// A buff to the level, separate from it. Allows attributes to get higher than the limit.
	var/level_buff = 0

// Procs

/datum/attribute/proc/get_level() // Returns current level of attribute + buff
	return level + level_buff

/datum/attribute/proc/on_update(mob/living/carbon/user)
	return

/datum/attribute/proc/adjust_level(mob/living/carbon/human/user, addition)
	if(!istype(user))
		return FALSE
	level = clamp((level + addition), level_lower_limit, level_limit)
	on_update(user)
	return TRUE

/datum/attribute/proc/adjust_buff(mob/living/carbon/human/user, addition)
	if(!istype(user))
		return FALSE
	level_buff += addition
	on_update(user)
	return TRUE

// Other procs

// Levels

/mob/living/carbon/human/proc/adjust_attribute_level(attribute, addition)
	if(!attribute)
		return 0
	var/datum/attribute/atr = attributes[attribute]
	if(!istype(atr))
		return 0
	return atr.adjust_level(src, addition)

/mob/living/carbon/human/proc/adjust_all_attribute_levels(addition)
	for(var/atr_type in attributes)
		var/datum/attribute/atr = attributes[atr_type]
		if(!istype(atr))
			continue
		atr.adjust_level(src, addition)
	return TRUE

/proc/get_attribute_level(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 1
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 1
	return max(1, atr.get_level())

// Attribute buffs

/mob/living/carbon/human/proc/adjust_attribute_buff(attribute, addition)
	if(!attribute)
		return 0
	var/datum/attribute/atr = attributes[attribute]
	if(!istype(atr))
		return 0
	return atr.adjust_buff(src, addition)

/mob/living/carbon/human/proc/adjust_all_attribute_buffs(addition)
	for(var/atr_type in attributes)
		var/datum/attribute/atr = attributes[atr_type]
		if(!istype(atr))
			continue
		atr.adjust_buff(src, addition)
	return TRUE

// Returns a combination of attributes, giving a "level" from 1 to 5
/proc/get_user_level(mob/living/carbon/human/user)
	if(!istype(user))
		return 0
	var/collective_levels = 0
	for(var/a in user.attributes)
		var/datum/attribute/atr = user.attributes[a]
		collective_levels += atr.level
	return clamp(round(collective_levels / 70), 1, 5)
