GLOBAL_LIST_INIT(attribute_types, list(
	/datum/attribute/fortitude,
	/datum/attribute/prudence,
	/datum/attribute/temperance,
	/datum/attribute/justice,
	))

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
	/// A buff to the raw stat, does not affect work rates, mechanics, etc.
	var/level_bonus = 0
	/// What it affects
	var/list/affected_stats = list()
	/// The initial value of the affected stat. 100 in the case of health/sanity
	var/initial_stat_value = 0

// Procs

/datum/attribute/proc/get_level() // Returns current level of attribute + buff
	return level + level_buff

/datum/attribute/proc/get_modified_level() // Returns current level of attribute + buff + bonus
	return level + level_buff + level_bonus

/datum/attribute/proc/get_raw_level() // Returns current level of attribute
	return level

/datum/attribute/proc/get_level_buff() // Returns current level of buff
	return level_buff

/datum/attribute/proc/get_level_bonus() // Returns current level of bonus
	return level_bonus

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

/datum/attribute/proc/adjust_bonus(mob/living/carbon/human/user, addition)
	if(!istype(user))
		return FALSE
	level_bonus += addition
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

//Getting level, which is level + buff
/proc/get_attribute_level(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 1
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 1
	return max(1, atr.get_level())

//Getting modified level, which is level + buff + bonus
/proc/get_modified_attribute_level(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 1
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 1
	return max(1, atr.get_modified_level())

//Getting raw level, mostly for tools.
/proc/get_raw_level(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 1
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 1
	return max(1, atr.get_raw_level())

//Get level buff, mostly for tools
/proc/get_level_buff(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 1
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 1
	return max(1, atr.get_level_buff())

/proc/get_level_bonus(mob/living/carbon/human/user, attribute)
	if(!istype(user) || !attribute)
		return 1
	var/datum/attribute/atr = user.attributes[attribute]
	if(!istype(atr))
		return 1
	return max(1, atr.get_level_bonus())

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

// Attribute Bonuses
/mob/living/carbon/human/proc/adjust_attribute_bonus(attribute, addition)
	if(!attribute)
		return 0
	var/datum/attribute/atr = attributes[attribute]
	if(!istype(atr))
		return 0
	return atr.adjust_bonus(src, addition)

/mob/living/carbon/human/proc/adjust_all_attribute_bonuses(addition)
	for(var/atr_type in attributes)
		var/datum/attribute/atr = attributes[atr_type]
		if(!istype(atr))
			continue
		atr.adjust_bonus(src, addition)
	return TRUE

//Set attribute levels
/mob/living/carbon/human/proc/set_attribute_limit(attribute_set)
	for(var/atr_type in attributes)
		var/datum/attribute/atr = attributes[atr_type]
		if(!istype(atr))
			continue
		atr.level_limit = attribute_set
	return TRUE

/mob/living/carbon/human/proc/adjust_attribute_limit(attribute_set)
	for(var/atr_type in attributes)
		var/datum/attribute/atr = attributes[atr_type]
		if(!istype(atr))
			continue
		atr.level_limit += attribute_set
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

// Returns a level for the show_attributes proc as a roman numeral I - V, or EX if level is too high.
/mob/living/carbon/human/proc/get_text_level()
	var/collective_levels = 0
	for(var/a in attributes)
		var/datum/attribute/atr = attributes[a]
		collective_levels += atr.level
	switch(clamp(round(collective_levels / 70), 1, 6))
		if(1) // 70
			return "I"
		if(2) // 140
			return "II"
		if(3) // 210
			return "III"
		if(4) // 280
			return "IV"
		if(5) // 350
			return "V"
		if(6) // 420+
			return "EX"
	return "N/A"

/mob/living/carbon/human/proc/get_attribute_text_level(attribute_level)
	switch(clamp(round(attribute_level / 20), 1, 6))
		if(-INFINITY to 1) // 20
			return "I"
		if(2) // 40
			return "II"
		if(3) // 60
			return "III"
		if(4) // 80
			return "IV"
		if(5) // 100
			return "V"
		if(6 to INFINITY) // 120+
			return "EX"
	return "N/A"
