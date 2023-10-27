/datum/wiki_template/ego_weapons/proc/generate_output(datum/ego_datum/weapon/item)

	var/datum/ego_datum/weapon/output = new item

	if(ispath(output.item_path, /obj/item/gun/ego_gun))
		return

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

/**
 * Here we add some text to the vars, we could do it in the template but that would make it harder to read/edit
 */

	var/damage_template = "This weapon deals [weapon_force] [damage_type] damage."
	var/throw_damage_template = "This weapon deals [throw_damage] damage when thrown."
	var/weapon_reach_template = "This weapon can reach up to [weapon_reach] tiles away"
	var/extraction_cost_template = "This weapon costs [extraction_cost] PE to extract"

/**
 * The template that gets shown on the wiki
 */

	var/created_template = "{| class=\"wikitable\" style=\"margin:auto\" \n"
	created_template += "|+ [weapon_name] \n"																		// Ayin's favorite knife
	created_template += "| colspan=\"2\" |[weapon_description] \n"													// This is Ayin's favorite knife, spooky
	created_template += "|- \n"
	created_template += "| [damage_template] \n"																	// This weapon deals [24] [white] damage
	created_template += "| [throw_damage_template] \n"																// This weapon deals [24] damage when thrown
	created_template += "|- \n"
	created_template += "| [weapon_reach_template] \n"																// This weapon can reach up to [1] tiles away
	created_template += "| [extraction_cost_template] \n"															// This weapon costs [20] PE to extract
	created_template += "|}"

	return created_template



/proc/test_generate_ego_weapons()
	var/datum/wiki_template/ego_weapons/new_template = new
	return new_template.generate_output(/datum/ego_datum/weapon/training)



GLOBAL_VAR_INIT(ego_weapon_wiki, "")
/proc/generate_ego_weapons()
	var/mega_string = ""
	var/datum/wiki_template/ego_weapons/new_template = new
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon)] \n"

	GLOB.ego_weapon_wiki = mega_string
	return mega_string
