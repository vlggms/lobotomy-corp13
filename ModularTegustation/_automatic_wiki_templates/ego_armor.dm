/**
 * Currently does not work, need to commit this as it conflicts with my API call changes
 */

/datum/wiki_template/ego_armors/proc/generate_output(datum/ego_datum/armor/item, risk_level)

	var/datum/ego_datum/armor/output = new item

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

	if(output.item_path == /obj/item/clothing/suit/armor/ego_gear/aleph/seasons)
		return // how about YOU stop crashing the code please <3
	var/armor_name = capitalize(initial(output.item_path.name))
	var/extracted_abnormality = initial(output.linked_abno.name)

	var/obj/item/clothing/suit/armor/ego_gear/armor_probe = new output.item_path(src)
	var/red_armor = armor_probe.armor.red
	var/white_armor = armor_probe.armor.white
	var/black_armor = armor_probe.armor.black
	var/pale_armor = armor_probe.armor.pale
	var/total_armor = red_armor + white_armor + black_armor + pale_armor
	qdel(armor_probe)

/**
 * The template that gets shown on the wiki
 */

	var/created_template = ""
	created_template += "| [armor_name]\n"
	created_template += "| [extracted_abnormality]\n" // BREAKS EVERYTHING AT THE MOMENT
	created_template += "| [risk_level]\n"
	created_template += "| [red_armor]\n"
	created_template += "| [white_armor]\n"
	created_template += "| [black_armor]\n"
	created_template += "| [pale_armor]\n"
	created_template += "| [total_armor]\n"
	created_template += "|-\n"

	return created_template



/proc/test_generate_ego_armors() // if you want to test out how the tables work without spamming up your chat
	var/datum/wiki_template/ego_armors/new_template = new
	return new_template.generate_output(/datum/ego_datum/armor/training)



GLOBAL_VAR_INIT(ego_armor_wiki, "")
/proc/generate_ego_armors() // calling this using the advanced_proc_call and copy-pasting it is basically how you are meant to update the wiki for now, until we figure out a way to do it automatically
	var/mega_string = ""
	var/datum/wiki_template/ego_armors/new_template = new
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		mega_string += "[new_template.generate_output(listed_weapon)]"

	GLOB.ego_armor_wiki = mega_string
	return mega_string

/proc/generate_sorted_ego_armors()
	var/mega_string = "\n"
	var/datum/wiki_template/ego_armors/new_template = new
	var/Wiki_text = "\
	{{AutoWiki}} \n\
	\n\
	{| class=\"wikitable\" \n\
	|+ \n\
	!EGO Name \n\
	!Origin \n\
	!Level \n\
	!R \n\
	!W \n\
	!B \n\
	!P \n\
	!Total \n\
	|- \n\
	"

	mega_string += Wiki_text
	mega_string += "|-\n"
	for(var/datum/ego_datum/armor/listed_armor as anything in (subtypesof(/datum/ego_datum/armor)))
		mega_string += "[new_template.generate_output(listed_armor, "Zayin")]"
		mega_string += "[new_template.generate_output(listed_armor, "Zayin+")]"
	mega_string += "! colspan=\"8\" |TETH\n"
	mega_string += "|-\n"
	for(var/datum/ego_datum/armor/listed_armor as anything in (subtypesof(/datum/ego_datum/armor)))
		mega_string += "[new_template.generate_output(listed_armor, "Teth")]"
		mega_string += "[new_template.generate_output(listed_armor, "Teth+")]"
	mega_string += "! colspan=\"8\" |HE\n"
	mega_string += "|-\n"
	for(var/datum/ego_datum/armor/listed_armor as anything in (subtypesof(/datum/ego_datum/armor)))
		mega_string += "[new_template.generate_output(listed_armor, "He")]"
		mega_string += "[new_template.generate_output(listed_armor, "He+")]"
	mega_string += "! colspan=\"8\" |WAW\n"
	mega_string += "|-\n"
	for(var/datum/ego_datum/armor/listed_armor as anything in (subtypesof(/datum/ego_datum/armor)))
		mega_string += "[new_template.generate_output(listed_armor, "Waw")]"
		mega_string += "[new_template.generate_output(listed_armor, "Waw+")]"
	mega_string += "! colspan=\"8\" |ALEPH\n"
	mega_string += "|-\n"
	for(var/datum/ego_datum/armor/listed_armor as anything in (subtypesof(/datum/ego_datum/armor)))
		mega_string += "[new_template.generate_output(listed_armor, "Aleph")]"
		mega_string += "[new_template.generate_output(listed_armor, "Aleph+")]"

	GLOB.ego_armor_wiki = mega_string
	return mega_string
