#define SAVE_NAME_AS_VARIABLE \
if(name != initial(name)){ \
	variables_to_add += "name = \"[name]\"" \
}

#define SAVE_DIR_AS_VARIABLE \
if(dir != initial(dir) || rotation != NORTH){ \
	var/pre_variable; \
	switch(rotation){ \
		if(NORTH){ \
			pre_variable = dir \
		} \
		if(EAST){ \
			pre_variable = turn(dir, 90) \
		} \
		if(SOUTH){ \
			pre_variable = turn(dir, 180) \
		} \
		if(WEST){ \
			pre_variable = turn(dir, 270) \
		} \
	} \
	if(pre_variable != initial(dir)){ \
		variables_to_add += "dir = [pre_variable]" \
	} \
}

#define SAVE_PIXEL_X_AS_VARIABLE \
if(pixel_x != initial(pixel_x)){ \
	switch(rotation){ \
		if(NORTH){ \
			variables_to_add += "pixel_x = [pixel_x]" \
		} \
		if(EAST){ \
			variables_to_add += "pixel_y = [pixel_x]" \
		} \
		if(SOUTH){ \
			variables_to_add += "pixel_x = [pixel_x * -1]" \
		} \
		if(WEST){ \
			variables_to_add += "pixel_y = [pixel_x * -1]" \
		} \
	} \
}

#define SAVE_PIXEL_Y_AS_VARIABLE \
if(pixel_y != initial(pixel_y)){ \
	switch(rotation){ \
		if(NORTH){ \
			variables_to_add += "pixel_y = [pixel_y]" \
		} \
		if(EAST){ \
			variables_to_add += "pixel_x = [pixel_y * -1]" \
		} \
		if(SOUTH){ \
			variables_to_add += "pixel_y = [pixel_y * -1]" \
		} \
		if(WEST){ \
			variables_to_add += "pixel_x = [pixel_y]" \
		} \
	} \
}

/atom/proc/save_variables(rotation = NORTH, child = FALSE, variables_to_add = list())
	var/JSON = ""

	if(child == FALSE)
		SAVE_NAME_AS_VARIABLE
		SAVE_PIXEL_X_AS_VARIABLE
		SAVE_PIXEL_Y_AS_VARIABLE

	if(length(variables_to_add) == 0) // nothing to add, return an empty string
		return JSON

	JSON += "{\n"
	for(var/variable in 1 to length(variables_to_add))
		var/added_variable = variables_to_add[1]
		JSON += "	[added_variable]"
		JSON += "[length(variables_to_add) > 1 ? ";\n": "\n	}"]"
		variables_to_add -= added_variable

	return JSON

/**
 * Structure children
 */

/obj/structure/save_variables(rotation = NORTH, child = FALSE, variables_to_add = list())
	var/JSON = ""

	if(child == FALSE)
		SAVE_NAME_AS_VARIABLE
		SAVE_DIR_AS_VARIABLE
		SAVE_PIXEL_X_AS_VARIABLE
		SAVE_PIXEL_Y_AS_VARIABLE

	if(length(variables_to_add) == 0) // nothing to add, return an empty string
		return JSON

	JSON += "{\n"
	for(var/variable in 1 to length(variables_to_add))
		var/added_variable = variables_to_add[1]
		JSON += "	[added_variable]"
		JSON += "[length(variables_to_add) > 1 ? ";\n": "\n	}"]"
		variables_to_add -= added_variable

	return JSON

/obj/structure/table/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_NAME_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

/obj/structure/sign/poster/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_DIR_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

/**
 * Machinery children
 */

/obj/machinery/light/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_DIR_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

/obj/machinery/camera/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_DIR_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

/obj/machinery/conveyor/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_DIR_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

/obj/machinery/computer/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_NAME_AS_VARIABLE
	SAVE_DIR_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

/obj/machinery/door/window/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_NAME_AS_VARIABLE
	SAVE_DIR_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

/obj/machinery/facility_holomap/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_DIR_AS_VARIABLE

	return ..()

/obj/machinery/chem_dispenser/drinks/save_variables(rotation = NORTH, child = TRUE, variables_to_add = list())
	SAVE_DIR_AS_VARIABLE
	SAVE_PIXEL_X_AS_VARIABLE
	SAVE_PIXEL_Y_AS_VARIABLE

	return ..()

#undef SAVE_NAME_AS_VARIABLE
#undef SAVE_DIR_AS_VARIABLE
#undef SAVE_PIXEL_X_AS_VARIABLE
#undef SAVE_PIXEL_Y_AS_VARIABLE
