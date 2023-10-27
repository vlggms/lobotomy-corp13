/datum/wiki_template/ego_weapons/proc/generate_output(datum/ego_datum/weapon/item)

	var/datum/ego_datum/weapon/output = new item

/**
 * var's set to later use in the template
 */

	var/weapon_name = capitalize(initial(output.item_path.name))
	var/weapon_description = initial(output.item_path.desc)
	var/weapon_force = initial(output.item_path.force)
	var/damage_type = initial(output.item_path.damtype)
	var/throw_damage = initial(output.item_path.throwforce)
//	var/special_ability = initial(output.item_path.special)
//	var/attack_speed = initial(output.item_path.attack_speed)
	var/weapon_reach = initial(output.item_path.reach)
	var/extraction_cost = initial(output.cost)
//	var/attributes = initial(output.item_path.attribute_requirements)

/**
 * The template that gets shown on the wiki
 */

	var/created_template = "{| class=\"wikitable\" style=\"margin:auto\" \n"
	created_template += "|+ [weapon_name] \n"															// Ayin's favorite knife
	created_template += "| colspan=\"3\" |[weapon_description] \n"										// This is Ayin's favorite knife, spooky
	created_template += "|- \n"
//	created_template += "| colspan=\"3\" |[special_ability] \n"											// you can slit your wrists by pressing z
	created_template += "| colspan=\"3\" |Placeholder, this is where the special ability of a weapon will be \n"
//	created_template += "|-"
	created_template += "| This weapon deals [weapon_force] [damage_type] damage. \n"					// This weapon deals [24] [white] damage
	created_template += "| This weapon deals [throw_damage] damage when thrown. \n"						// This weapon deals [24] damage when thrown
//	created_template += "| This weapon has [attack_speed] attack speed \n"								// This weapon has [average] attack speed
	created_template += "| Placeholder, this is where the weapons attack speed will be \n"
	created_template += "|- \n"
	created_template += "| This weapon can reach up to [weapon_reach] tiles away \n"					// This weapon can reach up to [1] tiles away
	created_template += "| This weapon costs [extraction_cost] PE to extract \n"						// This weapon costs [20] PE to extract
//	created_template += "| This weapon requires [attributes] to be wielded properly \n"					// This weapon requires [20 prudence] to be wielded properly
	created_template += "| placeholder, this is where the weapons attribute requirements will be \n"
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

/*
	if(special)
		. += "<span class='notice'>[special]</span>"
	if(LAZYLEN(attribute_requirements))
		. += "<span class='notice'>It has <a href='?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.</span>"

	if(reach>1)
		. += "<span class='notice'>This weapon has a reach of [reach].</span>"

	if(throwforce>force)
		. += "<span class='notice'>This weapon deals [throwforce] [damtype] damage when thrown.</span>"

	if(!attack_speed)
		return
	//Can't switch for less than for some reason
	if(attack_speed<0.4)
		. += "<span class='notice'>This weapon has a very fast attack speed.</span>"
	else if(attack_speed<0.7)
		. += "<span class='notice'>This weapon has a fast attack speed.</span>"
	else if(attack_speed<1)
		. += "<span class='notice'>This weapon attacks slightly faster than normal.</span>"
	else if(attack_speed<1.5)
		. += "<span class='notice'>This weapon attacks slightly slower than normal.</span>"
	else if(attack_speed<2)
		. += "<span class='notice'>This weapon has a slow attack speed.</span>"
	else if(attack_speed>=2)
		. += "<span class='notice'>This weapon attacks extremely slow.</span>"
*/
