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



/proc/generate_ego_weapons()

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
	var/datum/wiki_template/ego_weapons/new_template = new
	var/Wiki_text = "\
	{{AutoWiki}} \n\
	\n\
	This page contains all EGO weapons \n\
	\n\
	Only melee weapons are included due to complications with code \n\
	\n\
	If you wish to search for specific properties, highlight \" Extended range\", \" Throwable\" or \" small\" with your cursor and click ctrl+f. \n\
	\n\
	"
	mega_string += Wiki_text
	for(var/datum/ego_datum/weapon/listed_weapon as anything in (subtypesof(/datum/ego_datum/weapon)))
		var/extraction_cost = initial(listed_weapon.cost)
		if(listed_weapon == /datum/ego_datum/weapon/seasons) // make this check for a list of objects instead later on
			continue
		switch(extraction_cost) // We are making the mother of all switches jack, cant fret over every shitcode
			if(101 to INFINITY)
				ALEPH_PLUS += "[new_template.generate_output(listed_weapon)]"
			if(100)
				ALEPH += "[new_template.generate_output(listed_weapon)]"
			if(51 to 99)
				WAW_PLUS += "[new_template.generate_output(listed_weapon)]"
			if(50)
				WAW += "[new_template.generate_output(listed_weapon)]"
			if(36 to 49)
				HE_PLUS += "[new_template.generate_output(listed_weapon)]"
			if(35)
				HE += "[new_template.generate_output(listed_weapon)]"
			if(21 to 34)
				TETH_PLUS += "[new_template.generate_output(listed_weapon)]"
			if(20)
				TETH += "[new_template.generate_output(listed_weapon)]"
			if(13 to 19) // if this ever exists, what the actual hell are developers thinking. Putting it here juuuuuuust in case
				ZAYIN_PLUS += "[new_template.generate_output(listed_weapon)]"
			if(12)
				ZAYIN += "[new_template.generate_output(listed_weapon)]"

	mega_string += "== ALEPH == \n" // i have no idea how to optimize the following spaghetti :3
	for(var/EGO in ALEPH_PLUS)
		mega_string += EGO
	for(var/EGO in ALEPH)
		mega_string += EGO
	mega_string += "\n"

	mega_string += "== WAW == \n"
	for(var/EGO in WAW_PLUS)
		mega_string += EGO
	for(var/EGO in WAW)
		mega_string += EGO
	mega_string += "\n"

	mega_string += "== HE == \n"
	for(var/EGO in HE_PLUS)
		mega_string += EGO
	for(var/EGO in HE)
		mega_string += EGO
	mega_string += "\n"

	mega_string += "== TETH == \n"
	for(var/EGO in TETH_PLUS)
		mega_string += EGO
	for(var/EGO in TETH)
		mega_string += EGO
	mega_string += "\n"

	mega_string += "== ZAYIN == \n"
	for(var/EGO in ZAYIN_PLUS)
		mega_string += EGO
	for(var/EGO in ZAYIN)
		mega_string += EGO

	return mega_string
