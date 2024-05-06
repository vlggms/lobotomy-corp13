/**
 * Currently does not work, need to commit this as it conflicts with my API call changes
 */

/datum/wiki_template/ego_armors/proc/generate_output(datum/ego_datum/armor/item, risk_level)

	var/datum/ego_datum/armor/output = new item

/**
 * var's set to later use in the template
 */

	if(output.item_path == /obj/item/clothing/suit/armor/ego_gear/aleph/seasons)
		return // how about YOU stop crashing the code please <3

	var/armor_name = capitalize(initial(output.item_path.name))

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

	var/list/ALEPH_PLUS = list()
	var/list/ALEPH = list()
	var/list/WAW_PLUS = list()
	var/list/WAW = list()
	var/list/HE_PLUS = list()
	var/list/HE = list()
	var/list/TETH_PLUS = list()
	var/list/TETH = list()
	var/list/ZAYIN_PLUS = list()
	var/list/ZAYIN = list()

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
	for(var/datum/ego_datum/armor/listed_armor as anything in (subtypesof(/datum/ego_datum/armor)))
		var/extraction_cost = initial(listed_armor.cost)
		if(listed_armor == /datum/ego_datum/armor/seasons) // make this check for a list of objects instead later on
			continue
		switch(extraction_cost) // We are making the mother of all switches jack, cant fret over every shitcode
			if(101 to INFINITY)
				ALEPH_PLUS += "[new_template.generate_output(listed_armor, "ALEPH+")]"
			if(100)
				ALEPH += "[new_template.generate_output(listed_armor, "ALEPH")]"
			if(51 to 99)
				WAW_PLUS += "[new_template.generate_output(listed_armor, "WAW+")]"
			if(50)
				WAW += "[new_template.generate_output(listed_armor, "WAW")]"
			if(36 to 49)
				HE_PLUS += "[new_template.generate_output(listed_armor, "HE+")]"
			if(35)
				HE += "[new_template.generate_output(listed_armor, "HE")]"
			if(21 to 34)
				TETH_PLUS += "[new_template.generate_output(listed_armor, "TETH+")]"
			if(20)
				TETH += "[new_template.generate_output(listed_armor, "TETH")]"
			if(13 to 19) // if this ever exists, what the actual hell are developers thinking. Putting it here juuuuuuust in case
				ZAYIN_PLUS += "[new_template.generate_output(listed_armor, "ZAYIN+")]"
			if(12)
				ZAYIN += "[new_template.generate_output(listed_armor, "ZAYIN")]"

	mega_string += "! colspan=\"8\" |ALEPH \n"
	mega_string += "|- \n"
	for(var/EGO in ALEPH_PLUS)
		mega_string += EGO
	for(var/EGO in ALEPH)
		mega_string += EGO

	mega_string += "! colspan=\"8\" |WAW \n"
	mega_string += "|- \n"
	for(var/EGO in WAW_PLUS)
		mega_string += EGO
	for(var/EGO in WAW)
		mega_string += EGO

	mega_string += "! colspan=\"8\" |HE \n"
	mega_string += "|- \n"
	for(var/EGO in HE_PLUS)
		mega_string += EGO
	for(var/EGO in HE)
		mega_string += EGO

	mega_string += "! colspan=\"8\" |TETH \n"
	mega_string += "|- \n"
	for(var/EGO in TETH_PLUS)
		mega_string += EGO
	for(var/EGO in TETH)
		mega_string += EGO
	mega_string += "\n"

	mega_string += "! colspan=\"8\" |ZAYIN \n"
	mega_string += "|- \n"
	for(var/EGO in ZAYIN_PLUS)
		mega_string += EGO
	for(var/EGO in ZAYIN)
		mega_string += EGO

	mega_string += "|}\n"

	GLOB.ego_armor_wiki = mega_string
	return mega_string
