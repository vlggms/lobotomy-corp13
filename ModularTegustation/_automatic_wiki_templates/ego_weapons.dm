/datum/wiki_template/ego_weapons/proc/generate_output(datum/ego_datum/weapon/item, risk_level)

	var/datum/ego_datum/weapon/output = new item

	if(ispath(output.item_path, /obj/item/gun/ego_gun)) // they break everything at the moment, so its a no-go
		return

	switch(risk_level) // We are making the mother of all switches jack, cant fret over every shitcode
		if("Aleph+")
			if(output.cost <= 100) // only accept EGO costing more than 100
				return
		if("Aleph")
			if(output.cost <> 100) // gotta cost 100 on-point
				return
		if("Waw+")
			if(output.cost >= 100 || output.cost <= 50) // gotta cost less than ALEPH, but more than WAW
				return
		if("Waw")
			if(output.cost <> 50)
				return
		if("He+")
			if(output.cost >= 50 || output.cost <= 35)
				return
		if("He")
			if(output.cost <> 35)
				return
		if("Teth+")
			if(output.cost >= 35 || output.cost <= 20)
				return
		if("Teth")
			if(output.cost <> 20)
				return
		if("Zayin+") // if this ever exists, what the actual hell are developers thinking. Putting it here juuuuuuust in case
			if(output.cost >= 20 || output.cost <= 12)
				return
		if("Zayin")
			if(output.cost <> 12)
				return
		if("Meme")
			return // There is no current way to see if a weapon is a meme/admin only or not, painfull aint it?

/**
 * var's set to later use in the template
 */

	var/weapon_name = capitalize(initial(output.item_path.name))
	var/weapon_description = initial(output.item_path.desc)
	var/weapon_force = initial(output.item_path.force)
	var/damage_type = initial(output.item_path.damtype)
	var/throw_damage = initial(output.item_path.throwforce)
	var/weapon_reach = initial(output.item_path.reach)
	var/extraction_cost = initial(output.cost)
	var/small = FALSE
	var/weapon_properties = ""

/**
 * Here we add some text to the vars, we could do it in the template but that would make it harder to read/edit
 */

	var/damage_template = "This weapon deals [weapon_force] [damage_type] damage."
	var/throw_damage_template = "This weapon cant be effectivelly thrown"
	var/weapon_reach_template = "this weapon does not have extended range"
	var/extraction_cost_template = "This weapon costs [extraction_cost] PE to extract"

/**
 * We do a lil bit of if() checks
 */

	if(ispath(output.item_path, /obj/item/ego_weapon/mini))
		small = TRUE
		weapon_properties += " Small,"

	if(throw_damage > weapon_force) // are we are a boomerang?
		throw_damage_template = "This weapon deals [throw_damage] damage when thrown."
		weapon_properties += " Throwable,"

	if(weapon_reach > 1) // should probably check if we are a spear or not
		weapon_reach_template = "This weapon can reach up to [weapon_reach] tiles away"
		weapon_properties += " Extended range,"

	if(weapon_properties == "") // if we dont have properties, state it
		weapon_properties = " None"

	if(!weapon_name || weapon_name == item) // safety check
		return

/**
 * The template that gets shown on the wiki
 */

	var/created_template = "\n"
	created_template += "{| class=\"wikitable\"\n"
	created_template += "|+ [weapon_name]\n"
	created_template += "| colspan=\"3\" |[weapon_description]\n"
	created_template += "|-\n"
	created_template += "| [damage_template]\n"
	created_template += "| [throw_damage_template]\n"
	created_template += "| rowspan=\"2\" |Fits in EGO belts?\n"
	if(small)
		created_template += "Yes\n"
	else
		created_template += "No\n"
	created_template += "|-\n"
	created_template += "| [weapon_reach_template]\n"
	created_template += "| [extraction_cost_template]\n"
	created_template += "|-\n"
	created_template += "| colspan=\"3\" |Weapon properties:[weapon_properties]\n"
	created_template += "|}"

	return created_template



/proc/test_generate_ego_weapons() // if you want to test out how the tables work without spamming up your chat
	var/datum/wiki_template/ego_weapons/new_template = new
	return new_template.generate_output(/datum/ego_datum/weapon/training)



GLOBAL_VAR_INIT(ego_weapon_wiki, "")
/proc/generate_ego_weapons() // calling this using the advanced_proc_call and copy-pasting it is basically how you are meant to update the wiki for now, until we figure out a way to do it automatically
	var/mega_string = ""
	var/datum/wiki_template/ego_weapons/new_template = new
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon)]"

	GLOB.ego_weapon_wiki = mega_string
	return mega_string

/proc/generate_sorted_ego_weapons()
	var/mega_string = " \n"
	var/datum/wiki_template/ego_weapons/new_template = new
	mega_string += "== ALEPH == \n" // i have no idea how to optimize the following spaghetti :3
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon, "Aleph+")]"
		mega_string += "[new_template.generate_output(listed_weapon, "Aleph")]"
	mega_string += "\n"
	mega_string += "== WAW == \n"
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon, "Waw+")]"
		mega_string += "[new_template.generate_output(listed_weapon, "Waw")]"
	mega_string += "\n"
	mega_string += "== HE == \n"
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon, "He+")]"
		mega_string += "[new_template.generate_output(listed_weapon, "He")]"
	mega_string += "\n"
	mega_string += "== TETH == \n"
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon, "Teth+")]"
		mega_string += "[new_template.generate_output(listed_weapon, "Teth")]"
	mega_string += "\n"
	mega_string += "== ZAYIN == \n"
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon, "Zayin+")]"
		mega_string += "[new_template.generate_output(listed_weapon, "Zayin")]"

	GLOB.ego_weapon_wiki = mega_string
	return mega_string
