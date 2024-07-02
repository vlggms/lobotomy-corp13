
#define FILE_PLAYER_MAP_DATA(P, Player) "data/player_saves/[P]/[Player]/office.dmm"
// DMM_file = FILE_PLAYER_MAP_DATA(copytext(Player, 1, 2), Player) -- This is here in case we wanna save it into a person's data folder

/**
 * Welcome to absolute hellcode
 * As far as im aware, there's no actual way right now to save DMM files... so we gotta do it manually :)
 * Please, don't blame me for the lack of readability
 */

/**
 * Saves a given area to a DMM file
 */
/datum/controller/subsystem/mapping/proc/Save_Map(
	area/our_area, // the area we are trying to save, can save everything if it has "EVERYTHING" in it
	DMM_file = "tmp/facility.dmm", // the DMM file we are saving to, if overridden PLAYER is unnecessary
	rotation = NORTH, // the rotation of the area, for example SOUTH rotates the entire thing by 180 degrees
	delete_after_saving = FALSE, // If TRUE it will delete items as it saves them, this is to prepare the map for pasting at the same area
	list/override_turfs = FALSE, // if overridden, will check
)
	var/file = "" // stores all information about the office
	var/code_file = ""
	var/list/unique_entries = list() // Dictionary to track unique entries in the code_file
	var/map_file = ""

	// variables that determine what's the map's final size after we process all the turfs
	var/right_y = -INFINITY
	var/right_x = -INFINITY
	var/left_y = INFINITY
	var/left_x = INFINITY

	var/turf/left_x_ref

	// Comment that prevents re-conversion into a basic dmm file because funky dmm2tgm.py things or something
	file += "//MAP CREATED BY PERSISTENT FIXERS OFFICES (ModularTegustation/persistent_fixers), DO NOT REMOVE THIS COMMENT\n"

	var/list/area_turfs = our_area.contents
	if(!override_turfs)
		code_file += "\"aa\" = (\n" // null template, this is universal to all files created and serves to prepare the map for generation
		code_file += "/turf/template_noop,\n"
		code_file += "/area/template_noop)\n"
	else
		area_turfs = override_turfs
		code_file += "\"aaa\" = (\n" // null template, this is universal to all files created and serves to prepare the map for generation
		code_file += "/turf/template_noop,\n"
		code_file += "/area/template_noop)\n"

	for(var/turf/Turf in area_turfs) // first off, we look at every turf to determine whats the dimensions of our map
		if(!istype(Turf))
			continue

		if(Turf.y > right_y) // Variable setting hell
			right_y = Turf.y // Please pay your respect
		if(Turf.y < left_y)
			left_y = Turf.y
		if(Turf.x > right_x)
			right_x = Turf.x
		if(Turf.x < left_x)
			left_x = Turf.x
			left_x_ref = Turf // this is a suprise tool that we'll use later

	var/turf/reader_turf = left_x_ref // that later is now
	switch(rotation)
		if(NORTH)
			for(var/holy_shit in 1 to right_y - left_x_ref.y)
				reader_turf = get_step(reader_turf, NORTH)

		if(EAST)
			for(var/holy_shit in 1 to right_y - left_x_ref.y)
				reader_turf = get_step(reader_turf, NORTH)

			for(var/my_god in 1 to right_x - left_x_ref.x)
				reader_turf = get_step(reader_turf, EAST)

		if(SOUTH)
			for(var/holy_shit in 1 to (left_y - left_x_ref.y) * -1)
				reader_turf = get_step(reader_turf, SOUTH)

			for(var/my_god in 1 to right_x - left_x_ref.x)
				reader_turf = get_step(reader_turf, EAST)

		if(WEST)
			for(var/holy_shit in 1 to (left_y - left_x_ref.y) * -1)
				reader_turf = get_step(reader_turf, SOUTH)

	var/map_x = (right_x - left_x) + 1
	var/map_y = (right_y - left_y) + 1

	if(rotation == EAST || rotation == WEST) // we need to rotate it
		var/temp_x = map_x
		map_x = map_y
		map_y = temp_x

	var/line = 1
	var/iteration = 0
	for(var/horizontal_axis in 1 to map_x)
		map_file += "([line],1,1) = {\"\n"
		var/ticker_y = 0
		for(var/vertical_axis in 1 to map_y)
			var/turf/processing_turf = reader_turf
			for(var/x in 1 to line - 1)
				processing_turf = get_step(processing_turf, turn(rotation, 270))

			for(var/y in 1 to ticker_y)
				processing_turf = get_step(processing_turf, turn(rotation, 180))

			ticker_y += 1

			if(get_area(processing_turf) == our_area || (override_turfs && get_area(processing_turf) != /area/space))
				var/list/items_to_save = list()
				var/list/items_to_delete = list()
				var/content_string = "[processing_turf.type], [get_area(processing_turf)]"

				for(var/atom/thing in processing_turf.contents)
					if(!istype(thing) || !thing.name || istype(thing, /mob/living/carbon/human) || istype(thing, /mob/dead/observer))
						continue
					items_to_save += thing
					content_string += ", [thing.type]"
					content_string += thing.save_variables(rotation)
					if(delete_after_saving)
						items_to_delete += thing

				items_to_save += processing_turf
				items_to_save += get_area(processing_turf)

				if(!unique_entries[content_string])
					code_file += "\"[Convert_Number_To_Symbol(iteration, override_turfs ? 703 : 27)]\" = (\n"
					for(var/variable_item in 1 to length(items_to_save))
						var/atom/desired_item = items_to_save[1]
						if(istype(desired_item, /mob/living/simple_animal/hostile/abnormality))
							var/mob/living/simple_animal/hostile/abnormality/abno = desired_item
							abno.datum_reference = null
							code_file += "/obj/effect/abnormality_helper{\n	dir = [rotation];\n	stored_abnormality = [desired_item.type]\n	}"
						else
							code_file += "[desired_item.type]"
							code_file += desired_item.save_variables(rotation)

						code_file += "[length(items_to_save) > 1 ? ",\n": ")\n"]"
						items_to_save -= desired_item

					unique_entries[content_string] = Convert_Number_To_Symbol(iteration, override_turfs ? 703 : 27)
					map_file += "[Convert_Number_To_Symbol(iteration, override_turfs ? 703 : 27)]\n"
					iteration += 1
				else
					var/existing_iteration = unique_entries[content_string]
					map_file += "[existing_iteration]\n"

				QDEL_LIST(items_to_delete)
			else
				map_file += "aa\n" // its not a part of our area, so we place pass-through tiles onto it

		map_file += "\"}\n"
		line += 1

	file += code_file
	file += "\n"
	file += map_file

	rustg_file_write(file, DMM_file)

	return list(right_y, right_x, left_y, left_x, left_x_ref) // used for potential loading

#undef FILE_PLAYER_MAP_DATA

/datum/controller/subsystem/mapping/proc/Convert_Number_To_Symbol(number, magic_number = 27) // turns understandable numbers into necronomicon pages
	var/symbol = ""
	// how to set the magical number:
	// for 2 digits of memory, 27 (26 results in null being overridden, below that is corruption land and above is wastefull)
	// for 3 digits of memory, 703
	number += magic_number
	while(number >= 0)
		symbol = "[ascii2text(97 + (number % 26))]" + symbol
		number = (number / 26) - 1
	return symbol
