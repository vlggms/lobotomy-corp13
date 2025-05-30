// Assoc list. NameCategory = Type
// Items are added here on abnormality datum spawn
GLOBAL_LIST_EMPTY(ego_datums)

/* EGO datums for purchase */
/* When adding a new datum here - try to keep it consistent with ego_weapons and ego_gear folders/files */

/datum/ego_datum
	/// If empty - will use name of the item
	var/name = null
	/// Simple 'category' of the weapon to display, i.e. "Weapon" or "Armor"
	var/item_category = "N/A"
	/// Path to the item
	var/obj/item/item_path
	/// Cost in PE boxes
	var/cost = 999
	// I hope this will be temporary...
	var/datum/abnormality/linked_abno
	/// All the data needed for displaying information on EGO console
	var/list/information = list()

/datum/ego_datum/New(datum/abnormality/DA)
	if(!name && item_path)
		name = initial(item_path.name)
	if(DA)
		linked_abno = DA

/datum/ego_datum/Destroy()
	GLOB.ego_datums -= src
	return ..()

/datum/ego_datum/proc/PrintOutInfo()
	return

// Because I'm lazy to type it all
/datum/ego_datum/weapon
	item_category = "Weapon"

/datum/ego_datum/weapon/New(datum/abnormality/DA)
	. = ..()
	if(!ispath(item_path, /obj/item/ego_weapon))
		if(!ispath(item_path, /obj/item/ego_weapon/ranged))
			return
		var/obj/item/ego_weapon/ranged/E = new item_path(src)
		var/bullet_damage_type = E.last_projectile_type
		var/bullet_damage = E.last_projectile_damage
		if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(bullet_damage_type))
			var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
			var/new_damage_type = shuffler.mapping_offense[bullet_damage_type]
			if(new_damage_type == PALE_DAMAGE && bullet_damage_type != PALE_DAMAGE)
				bullet_damage *= shuffler.pale_debuff
			else if(new_damage_type != PALE_DAMAGE && bullet_damage_type == PALE_DAMAGE)
				bullet_damage /= shuffler.pale_debuff
			bullet_damage_type = new_damage_type
		information["attribute_requirements"] = E.attribute_requirements.Copy()
		information["attack_info"] = "Its bullets deal [bullet_damage] [bullet_damage_type] damage."
		information["special"] = E.special
		var/fire_delay = E.fire_delay
		if(E.autofire)
			fire_delay = E.autofire * 0.75
		switch(fire_delay)
			if(0 to 5)
				information["attack_speed"] = "Fast"
			if(6 to 10)
				information["attack_speed"] = "Normal"
			if(11 to 15)
				information["attack_speed"] = "Somewhat slow"
			if(16 to 20)
				information["attack_speed"] = "Slow"
			else
				information["attack_speed"] = "Extremely slow"
		qdel(E)
		return
	var/obj/item/ego_weapon/E = new item_path(src)
	var/damage_type = E.damtype
	var/damage = E.force
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		if(new_damage_type == PALE_DAMAGE && damage_type != PALE_DAMAGE)
			damage *= shuffler.pale_debuff
		else if(new_damage_type != PALE_DAMAGE && damage_type == PALE_DAMAGE)
			damage /= shuffler.pale_debuff
		damage_type = new_damage_type
	information["attack_info"] = "It deals [damage] [damage_type] damage."
	information["throwforce"] = E.throwforce
	information["special"] = E.special
	information["attribute_requirements"] = E.attribute_requirements.Copy()
	information["reach"] = E.reach
	if(E.attack_speed < 0.4)
		information["attack_speed"] = "Very fast"
	else if(E.attack_speed<0.7)
		information["attack_speed"] = "Fast"
	else if(E.attack_speed<1)
		information["attack_speed"] = "Somewhat fast"
	else if(E.attack_speed == 1)
		information["attack_speed"] = "Normal"
	else if(E.attack_speed<1.5)
		information["attack_speed"] = "Somewhat slow"
	else if(E.attack_speed<2)
		information["attack_speed"] = "Slow"
	else if(E.attack_speed>=2)
		information["attack_speed"] = "Extremely slow"
	qdel(E)

/datum/ego_datum/weapon/PrintOutInfo()
	var/dat = "[capitalize(name)]<br><br>"
	if(LAZYLEN(information["attribute_requirements"]))
		dat += "Attribute requirements:<br>"
		for(var/attr in information["attribute_requirements"])
			dat += "- [attr]: [information["attribute_requirements"][attr]]<br>"
		dat += "<hr>"
	dat += "[information["attack_info"]]<br>"
	if("special" in information)
		dat += "[information["special"]]<br>"
	dat += "Attack speed: [information["attack_speed"]].<br>"
	if(ispath(item_path, /obj/item/ego_weapon/ranged))

	else if(ispath(item_path, /obj/item/ego_weapon))
		if(information["throwforce"] > 0)
			dat += "Throw force: [information["throwforce"]].<br>"
		if(information["reach"] > 1)
			dat += "This weapon has a reach of [information["reach"]].<br>"
	return dat

/datum/ego_datum/armor
	item_category = "Armor"

/datum/ego_datum/armor/New(datum/abnormality/DA)
	. = ..()
	if(!ispath(item_path, /obj/item/clothing/suit/armor/ego_gear))
		return
	var/obj/item/clothing/suit/armor/ego_gear/E = new item_path(src)
	information["armor"] = list()
	var/red_armor = E.armor.red
	var/white_armor = E.armor.white
	var/black_armor = E.armor.black
	var/pale_armor = E.armor.pale
	if(GLOB.damage_type_shuffler?.is_enabled)
		var/list/mapping = GLOB.damage_type_shuffler.mapping_defense
		red_armor = E.armor.getRating(mapping[RED_DAMAGE])
		white_armor = E.armor.getRating(mapping[WHITE_DAMAGE])
		black_armor = E.armor.getRating(mapping[BLACK_DAMAGE])
		pale_armor = E.armor.getRating(mapping[PALE_DAMAGE])
	information["armor"][RED_DAMAGE] = E.armor_to_protection_class(red_armor)
	information["armor"][WHITE_DAMAGE] = E.armor_to_protection_class(white_armor)
	information["armor"][BLACK_DAMAGE] = E.armor_to_protection_class(black_armor)
	information["armor"][PALE_DAMAGE] = E.armor_to_protection_class(pale_armor)
	information["attribute_requirements"] = E.attribute_requirements.Copy()
	qdel(E)

/datum/ego_datum/armor/PrintOutInfo()
	var/dat = "[capitalize(name)]<br><br>"
	if(LAZYLEN(information["attribute_requirements"]))
		dat += "Attribute requirements:<br>"
		for(var/attr in information["attribute_requirements"])
			dat += "- [attr]: [information["attribute_requirements"][attr]]<br>"
		dat += "<hr>"
	dat += "Armor:<br>"
	for(var/armor_type in information["armor"])
		if(!(information["armor"][armor_type])) // Zero armor and such
			continue
		dat += "- [capitalize(armor_type)]: [information["armor"][armor_type]].<br>"
	dat += "<br>"
	return dat
