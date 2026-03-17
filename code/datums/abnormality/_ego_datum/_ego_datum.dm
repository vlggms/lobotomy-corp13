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
		return

	if(ispath(item_path, /obj/item/ego_weapon/ranged))
		var/obj/item/ego_weapon/ranged/G = new item_path(src)
		var/bullet_damage_type = G.last_projectile_type
		var/bullet_damage = G.last_projectile_damage
		if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(bullet_damage_type))
			var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
			var/new_damage_type = shuffler.mapping_offense[bullet_damage_type]
			bullet_damage_type = new_damage_type
		information["projectile_info"] = "Its bullets deal [bullet_damage] [bullet_damage_type] damage."
		if(G.pellets > 1)
			information["projectile_info"] = "Its bullets deal [bullet_damage] x [G.pellets] [bullet_damage_type] damage."
		var/fire_delay = G.fire_delay
		if(G.autofire)
			fire_delay = G.autofire * 0.75
			information["auto_fire"] = "This weapon fires automatically."
		switch(fire_delay)
			if(0 to 5)
				information["fire_rate"] = "Fast"
			if(6 to 10)
				information["fire_rate"] = "Normal"
			if(11 to 15)
				information["fire_rate"] = "Somewhat slow"
			if(16 to 20)
				information["fire_rate"] = "Slow"
			else
				information["fire_rate"] = "Extremely slow"
		if(!G.reloadtime)
			information["reload_speed"] += "This weapon has unlimited ammo."
		else
			information["ammo"] += G.shotsleft
			switch(G.reloadtime)
				if(0 to 0.71 SECONDS)
					information["reload_speed"] += "Reload speed: Very fast."
				if(0.71 SECONDS to 1.21 SECONDS)
					information["reload_speed"] += "Reload speed: Fast."
				if(1.21 SECONDS to 1.71 SECONDS)
					information["reload_speed"] += "Reload speed: Average."
				if(1.71 SECONDS to 2.51 SECONDS)
					information["reload_speed"] += "Reload speed: Slow."
				if(2.51 to INFINITY)
					information["reload_speed"] += "Reload speed: Extremely slow."

		switch(G.weapon_weight)
			if(WEAPON_HEAVY)
				information["weapon_weight"] += "This weapon requires both hands to fire."
			if(WEAPON_MEDIUM)
				information["weapon_weight"] += "This weapon can be fired with one hand."
			if(WEAPON_LIGHT)
				information["weapon_weight"] += "This weapon can be dual wielded."
		qdel(G)
	if(ispath(item_path, /obj/item/ego_weapon/shield))
		var/obj/item/ego_weapon/shield/S = new item_path(src)
		if(S.projectile_block_duration)
			information["shield"] += "This weapon blocks ranged attacks while attacking and can block on command."
		else
			information["shield"] += "This weapon can block on command."
		information["armor"] = list()
		information["armor"][RED_DAMAGE] = 1 - round(S.reductions[1], 10) / 100
		information["armor"][WHITE_DAMAGE] = 1 - round(S.reductions[2], 10) / 100
		information["armor"][BLACK_DAMAGE] = 1 - round(S.reductions[3], 10) / 100
		information["armor"][PALE_DAMAGE] = 1 - round(S.reductions[4], 10) / 100
		qdel(S)
	else if(ispath(item_path, /obj/item/ego_weapon/lance))
		information["lance"] += "This weapon can be used to perform a running charge by using it in hand. Charge into an enemy at high speeds for massive damage!"
	else if(ispath(item_path, /obj/item/ego_weapon/wield))
		var/obj/item/ego_weapon/wield/W = new item_path(src)
		if(W.two_hands_required)
			information["wield_stats"] += W.forced_wield_stats
		else
			information["wield_stats"] += W.wield_stats
		if(W.wield_special)
			information["wield_special"] += W.wield_special
		qdel(W)

	var/obj/item/ego_weapon/E = new item_path(src)
	var/damage_type = E.damtype
	var/damage = E.force
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	information["attack_info"] = "It deals [damage] [damage_type] damage."
	information["throwforce"] = E.throwforce
	information["special"] = E.special
	information["attribute_requirements"] = E.attribute_requirements.Copy()
	information["reach"] = E.reach
	var/attack_speed = E.attack_speed
	if(E.modified_attack_speed)
		attack_speed = E.modified_attack_speed
	if(attack_speed < 0.4)
		information["attack_speed"] = "Very fast"
	else if(attack_speed<0.7)
		information["attack_speed"] = "Fast"
	else if(attack_speed<1)
		information["attack_speed"] = "Somewhat fast"
	else if(attack_speed == 1)
		information["attack_speed"] = "Normal"
	else if(attack_speed<1.5)
		information["attack_speed"] = "Somewhat slow"
	else if(attack_speed<2)
		information["attack_speed"] = "Slow"
	else if(attack_speed>=2)
		information["attack_speed"] = "Extremely slow"
	if(E.stuntime)
		switch(E.stuntime)
			if(1 to 2)
				information["stun_time"] += "very short"
			if(2 to 4)
				information["stun_time"] += "short"
			if(5 to 6)
				information["stun_time"] += "moderate"
			if(6 to 8)
				information["stun_time"] += "long"
			if(9 to INFINITY)
				information["stun_time"] += "very Long"

	if(E.knockback)
		switch(E.knockback)
			if(KNOCKBACK_LIGHT)
				information["knockback"] += "This weapon has slight enemy knockback."

			if(KNOCKBACK_MEDIUM)
				information["knockback"] += "This weapon has decent enemy knockback."

			if(KNOCKBACK_HEAVY)
				information["knockback"] += "This weapon has neck-snapping enemy knockback."

			else
				information["knockback"] += "This weapon has [E.knockback >= 10 ? "neck-snapping": ""] enemy knockback."
	if(E.charge)
		information["charge"] += "This weapon has charge mechanics[E.attack_charge_gain ? " and gains a charge upon every hit" : ""].<br>"
		information["charge"] += "This weapon can hold up to [E.charge_cap] charge.<br>"
		information["charge"] += "Ability cost: [E.charge_cost].<br>"
		if(E.charge_effect)
			information["charge"] += "Ability: [E.charge_effect]"
	qdel(E)

/datum/ego_datum/weapon/PrintOutInfo()
	var/dat = "[capitalize(name)]<br><br>"
	if(LAZYLEN(information["attribute_requirements"]))
		dat += "Attribute requirements:<br>"
		for(var/attr in information["attribute_requirements"])
			dat += "- [attr]: [information["attribute_requirements"][attr]]<br>"
		dat += "<hr>"
	if(ispath(item_path, /obj/item/ego_weapon/ranged))
		dat += "[information["projectile_info"]]<br>"
		if("special" in information)
			dat += "[information["special"]]<br>"
		if("charge" in information)
			dat += "[information["charge"]]<br>"
		dat += "Fire rate: [information["fire_rate"]]<br>"
		if("auto_fire" in information)
			dat += "[information["auto_fire"]].<br>"
		dat += "[information["reload_speed"]]<br>"
		if("ammo" in information)
			dat += "Ammo: [information["ammo"]].<br>"
		dat += "[information["weapon_weight"]]<br>"
		dat += "<br>"
		dat += "[information["attack_info"]]<br>"
		dat += "Attack speed: [information["attack_speed"]].<br>"
	else
		dat += "[information["attack_info"]]<br>"
		if("special" in information)
			dat += "[information["special"]]<br>"
		if("charge" in information)
			dat += "[information["charge"]]<br>"
		dat += "Attack speed: [information["attack_speed"]].<br>"
		if("wield_stats" in information)
			dat += "[information["wield_stats"]]<br>"
		if("wield_special" in information)
			dat += "[information["wield_special"]]<br>"
		if("armor" in information)
			dat += "[information["shield"]]<br>"
			dat += "Deflect values:<br>"
			for(var/armor_type in information["armor"])
				if(!(information["armor"][armor_type])) // Zero armor and such
					continue
				dat += "- [capitalize(armor_type)]: [information["armor"][armor_type]].<br>"
	if(information["throwforce"] > 0)
		dat += "Throw force: [information["throwforce"]].<br>"
	if(information["reach"] > 1)
		dat += "This weapon has a reach of [information["reach"]].<br>"
	if("stun_time" in information)
		dat += "This weapon stuns you for a [information["stun_time"]] duration on hit.<br>"
	if("lance" in information)
		dat += "[information["lance"]]<br>"
	if("knockback" in information)
		dat += "[information["knockback"]]<br>"
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
	information["armor"][RED_DAMAGE] = 1 - round(red_armor, 10) / 100
	information["armor"][WHITE_DAMAGE] = 1 - round(white_armor, 10) / 100
	information["armor"][BLACK_DAMAGE] = 1 - round(black_armor, 10) / 100
	information["armor"][PALE_DAMAGE] = 1 - round(pale_armor, 10) / 100
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
