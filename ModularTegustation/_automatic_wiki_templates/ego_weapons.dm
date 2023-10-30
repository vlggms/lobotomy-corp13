/datum/wiki_template/ego_weapons/proc/generate_output(datum/ego_datum/weapon/item)

	var/datum/ego_datum/weapon/output = new item

	if(ispath(output.item_path, /obj/item/gun/ego_gun)) // they break everything at the moment, so its a no-go
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
	var/weapon_properties = "" // set in if() checks

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

	var/created_template = " \n"
	created_template += "{| class=\"wikitable\" \n"
	created_template += "|+ [weapon_name] \n"									//			Ayin's favorite knife
	created_template += "| colspan=\"2\" |[weapon_description] \n"				//	This is Ayin's favorite knife, spooky
	created_template += "|- \n"
	created_template += "| [damage_template] \n"								//	This weapon deals [24] [white] damage
	created_template += "| [throw_damage_template] \n"							//	This weapon deals [24] damage when thrown
	created_template += "|- \n"
	created_template += "| [weapon_reach_template] \n"							//	This weapon can reach up to [1] tiles away
	created_template += "| [extraction_cost_template] \n"						//	This weapon costs [20] PE to extract
	created_template += "|- \n"
	created_template += "| colspan=\"2\" |Weapon properties:[weapon_properties] \n"
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
		mega_string += "[new_template.generate_output(listed_weapon)] \n"

	GLOB.ego_weapon_wiki = mega_string
	return mega_string
