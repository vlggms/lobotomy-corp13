#define SAVE_AREA (1<<0)
#define SAVE_MAP (1<<1)

/obj/item/lc_debug/office_saver
	name = "DEBUG AREA SAVER"
	desc = "This lets you save areas to then paste in using admin tools. "
	icon_state = "oddity7_firewater"
	var/list/saved_maps = list()
	var/list/saved_vars = list()
	var/list/saved_turfs = list()
	var/mode = SAVE_AREA

/obj/item/lc_debug/office_saver/attack_self(mob/user)
	. = ..()
	switch(mode)
		if(SAVE_AREA)
			mode = SAVE_MAP
			to_chat(user, span_notice("Now saving a custom area"))
			to_chat(user, span_notice("Click on the borders of where the saving should extend to"))
			to_chat(user, span_notice("When you are done, click on this tool again to start saving the map"))
		if(SAVE_MAP)
			mode = SAVE_AREA
			if(!saved_turfs.len)
				to_chat(user, span_notice("Now saving a pre-defined area"))
				return
			to_chat(user, span_notice("Saving custom map..."))
			afterattack(pick(saved_turfs), user)

/obj/item/lc_debug/office_saver/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(mode == SAVE_MAP)
		saved_turfs += get_turf(target)
		to_chat(user, span_notice("Turf saved"))
		return

	saved_maps = list()
	saved_vars = list()
	var/deletion = FALSE
	if(alert(user, "Delete all items after saving them? (preparation for map loading)", "Deletion", "Yes", "No") == "Yes")
		deletion = TRUE

	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	for(var/direction as anything in dirs)
		saved_vars = SSmapping.Save_Map(
			get_area(target),
			rotation = direction,
			delete_after_saving = (direction == dirs[4] ? deletion : FALSE),
			override_turfs = (saved_turfs.len ? saved_turfs : FALSE),
		)
		var/map = "tmp/facility.dmm"
		var/cosmetic_direction = "ERROR"
		switch(direction)
			if(NORTH)
				cosmetic_direction = "NORTH"
			if(SOUTH)
				cosmetic_direction = "SOUTH"
			if(EAST)
				cosmetic_direction = "EAST"
			if(WEST)
				cosmetic_direction = "WEST"

		var/datum/map_template/M = new(map, "AAA-[cosmetic_direction]-ROTATED-MAP", TRUE)
		if(!M.cached_map)
			to_chat(user, span_warning("Map template '[map]' failed to parse properly."), confidential = TRUE)
			return

		var/datum/map_report/report = M.cached_map.check_for_errors()
		var/report_link
		if(report)
			report.show_to(user)
			report_link = " - <a href='?src=[REF(report)];[HrefToken(TRUE)];show=1'>validation report</a>"
			to_chat(user, span_warning("Map template '[map]' <a href='?src=[REF(report)];[HrefToken()];show=1'>failed validation</a>."), confidential = TRUE)
			if(report.loadable)
				var/response = alert(user, "The map failed validation, would you like to load it anyways?", "Map Errors", "Cancel", "Upload Anyways")
				if(response != "Upload Anyways")
					return
			else
				alert(user, "The map failed validation and cannot be loaded.", "Map Errors", "Oh Darn")
				return

		SSmapping.map_templates[M.name] = M
		saved_maps += M
		message_admins(span_adminnotice("[key_name_admin(user)] has uploaded a map template '[map]' ([M.width]x[M.height])[report_link]."))
		to_chat(user, span_notice("Map template '[map]' ready to place ([M.width]x[M.height])"), confidential = TRUE)

	saved_turfs = list()
	if(!deletion)
		return

	if(alert(user, "Immediatelly load the map on its old spot?", "Template Confirm", "Yes", "No") != "Yes")
		return

	var/datum/map_template/template = input(user, "Choose a rotation", "Place Map Template") as null|anything in sortList(saved_maps)

	var/turf/x_ref = saved_vars[5]
	var/y = saved_vars[3]

	for(var/le_variable in 1 to (y - x_ref.y) * -1)
		x_ref = get_step(x_ref, SOUTH)

	if(template.load(x_ref, centered = FALSE))
		var/affected = template.get_affected_turfs(x_ref, centered = FALSE)
		for(var/AT in affected)
			for(var/obj/docking_port/mobile/P in AT)
				if(istype(P, /obj/docking_port/mobile))
					template.post_load(P)
					break

		message_admins(span_adminnotice("[key_name_admin(user)] has placed a map template ([template.name]) at [ADMIN_COORDJMP(x_ref)]"))
	else
		to_chat(user, "Failed to place map", confidential = TRUE)

#undef SAVE_AREA
#undef SAVE_MAP
