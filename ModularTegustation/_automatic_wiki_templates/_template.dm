/datum/wiki_template/i_am_template/proc/generate_output(datum/some_path/some_more_paths/item)

	var/datum/some_path/some_more_paths/output = new item

	if(ispath(output.item_path, /obj/item/gun/ego_gun)) // you can filter your datum's paths like this
		return

/**
 * var's set to later use in the template, usually should have more of these
 */

	var/weapon_name = capitalize(initial(output.item_path.name))
	var/weapon_description = initial(output.item_path.desc)

/**
 * Here we add some text to the vars, we could do it in the template but that would make it harder to read/edit
 */

	var/name_template = "Hey, my name is [weapon_name]"
	var/description_template = "And my description is [weapon_description]"

/**
 * The template that gets shown on the wiki, this one is a wiki table!
 */

	var/created_template = " \n"
	created_template += "{| class=\"wikitable\" \n"
	created_template += "|+ [weapon_name] \n"									//			Ayin's favorite knife
	created_template += "| colspan=\"2\" |[weapon_description] \n"				//	This is Ayin's favorite knife, spooky
	created_template += "|}"

	return created_template



/proc/test_generate_i_am_template() // if you want to test out how the tables work without spamming up your chat
	var/datum/wiki_template/i_am_template/new_template = new
	return new_template.generate_output(datum/some_path/some_more_paths/item)



GLOBAL_VAR_INIT(i_am_template_wiki, "")
/proc/generate_i_am_template() // calling this using the advanced_proc_call and copy-pasting it is basically how you are meant to update the wiki for now, until we figure out a way to do it automatically
	var/mega_string = ""
	var/datum/wiki_template/i_am_template/new_template = new
	for(var/datum/some_path/some_more_paths/listed_thingimajig as anything in (subtypesof(datum/some_path/some_more_paths)))
		mega_string += "[new_template.generate_output(listed_thingimajig)] \n"

	GLOB.i_am_template_wiki = mega_string
	return mega_string
