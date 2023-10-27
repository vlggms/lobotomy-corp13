/datum/wiki_template/ego_weapons/proc/generate_output(datum/ego_datum/weapon/item)
	var/datum/ego_datum/weapon/output = new item

	var/weapon_name = capitalize(initial(output.item_path.name))

	var/weapon_description = initial(output.item_path.desc)

/*
	var/weapon_icon = null // to be implemented
*/

	var/weapon_force = initial(output.item_path.force)

	var/weapon_damage = initial(output.item_path.damtype)

	var/extraction_cost = initial(output.cost)






	var/created_template = "## [weapon_name] \n"
	created_template += "| --- | --- | --- | \n"
	created_template += "Weapon description: [weapon_description] \n"
/*
	created_template += "Weapon icon: [weapon_icon] \n"
*/
	created_template += "Weapon force: [weapon_force] \n"
	created_template += "weapon damage type: [weapon_damage] \n"
	created_template += "this weapon costs [extraction_cost] PE to extract\n"

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
