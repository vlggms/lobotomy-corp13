// Simple datum to keep track of a running holomap. Each machine capable of displaying the holomap will have one.
/datum/facility_holomap
	var/image/facility_map
	var/image/cursor

	var/list/atom/movable/screen/legend/legend
	var/list/atom/movable/screen/maptexts
	var/list/atom/movable/screen/levelselect/lbuttons
	var/list/image/levels //base levels

	var/list/z_levels //list of actual z placements, only supports Station z levels
	var/z = -1 // z level the holomap is initialized to start at
	var/default_z_index = 0 //index of level corresponding to z
	var/displayed_level = 1 //Index of level currently displayed
	var/bogus = TRUE		//set to TRUE when you initialize the station map on a zLevel that doesn't have its own icon formatted for use by holomaps.
	var/forced = FALSE

/datum/facility_holomap/Destroy()
	QDEL_NULL(facility_map)
	QDEL_NULL(cursor)
	QDEL_LIST(legend)
	QDEL_LIST(lbuttons)
	QDEL_LIST_ASSOC_VAL(maptexts)
	QDEL_LIST_ASSOC_VAL(levels)
	LAZYCLEARLIST(maptexts)
	LAZYCLEARLIST(levels)
	LAZYCLEARLIST(z_levels)
	. = ..()

/datum/facility_holomap/proc/initialize_holomap(turf/T, isAI = null, mob/user = null, reinit = FALSE, is_forced = FALSE)
	bogus = FALSE
	z = T.z
	forced = is_forced
	if(!("[HOLOMAP_EXTRA_STATIONMAP]_[z]" in SSholomap.extra_minimaps))
		initialize_holomap_bogus()
		return

	if(!facility_map || reinit)
		facility_map = image(icon(HOLOMAP_ICON, "stationmap"))
		facility_map.layer = UNDER_HUD_LAYER
	if(!cursor || reinit)
		cursor = image('icons/misc/holomap_markers.dmi', "you")
		cursor.layer = HUD_ABOVE_ITEM_LAYER
	if(!LAZYLEN(legend) || reinit)
		if(LAZYLEN(legend))
			QDEL_LIST_ASSOC_VAL(legend)
		LAZYINITLIST(legend)
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_CONTROL, "■ Control"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_INFORMATION, "■ Information"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_SAFETY, "■ Safety"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_TRAINING, "■ Training"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_COMMAND, "■ Command"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_DISCIPLINE, "■ Disciplinary"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_WELFARE, "■ Welfare"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_RECORDS, "■ Records"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_EXTRACTION, "■ Extraction"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_ARCHITECTURE, "■ Architecture"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_MANAGER, "■ Manager"))
		LAZYADD(legend, new /atom/movable/screen/legend(null ,HOLOMAP_AREACOLOR_HALLWAYS, "■ Hallways"))
		LAZYADD(legend, new /atom/movable/screen/legend/cursor(null ,HOLOMAP_AREACOLOR_BASE, "You are here"))
	if(reinit)
		QDEL_LIST(lbuttons)
		QDEL_LIST_ASSOC_VAL(maptexts)
		LAZYCLEARLIST(maptexts)
		LAZYCLEARLIST(levels)
		LAZYCLEARLIST(z_levels)

	z_levels = SSmapping.levels_by_trait(ZTRAIT_STATION)
	if(z_levels.len > 1)
		if(!LAZYLEN(lbuttons))
			//Add the buttons for switching levels
			LAZYADD(lbuttons, new /atom/movable/screen/levelselect/up(null, src))
			LAZYADD(lbuttons, new /atom/movable/screen/levelselect/down(null, src))
		lbuttons[1].pixel_y = HOLOMAP_MARGIN - 22
		lbuttons[2].pixel_y = HOLOMAP_MARGIN + 5
		lbuttons[1].pixel_x = 254
		lbuttons[2].pixel_x = 196

	default_z_index = initial(default_z_index)
	for(var/L = 1; L <= z_levels.len; L++)
		var/z_level = z_levels[L] //actual z placement
		if(z == z_level)
			default_z_index = L

		//Turfs and walls
		var/icon/map_icon = icon(SSholomap.holo_minimaps[z_level])
		map_icon.Blend(HOLOMAP_HOLOFIER, ICON_MULTIPLY)
		var/image/map_image = image(map_icon)
		map_image.layer = HUD_LAYER

		//Store the image for future use
		//LAZYADD(levels, map_image)
		LAZYSET(levels, "[z_level]", map_image)

		var/atom/movable/screen/maptext_overlay = new(null)
		maptext_overlay.icon = null
		maptext_overlay.layer = HUD_ITEM_LAYER
		maptext_overlay.maptext = "<span style=\"text-align:center;font-family: 'Small Fonts';\">LEVEL [L-1]</span>"
		maptext_overlay.maptext_width = 96
		maptext_overlay.pixel_x = (HOLOMAP_ICON_SIZE / 2) - (maptext_overlay.maptext_width / 2)
		maptext_overlay.pixel_y = HOLOMAP_MARGIN + 2

		LAZYSET(maptexts, "[z_level]", maptext_overlay)

//Then set cursor based on user position
	if(isAI)
		T = get_turf(user.client.eye)
	cursor.pixel_x = (T.x - 6 + HOLOMAP_PIXEL_OFFSET_X) * (world.icon_size/32)
	cursor.pixel_y = (T.y - 6 + HOLOMAP_PIXEL_OFFSET_Y) * (world.icon_size/32)

	if(!default_z_index) //if our z level is not a station z level use the static image
		initialize_fixed_holomap(z)
	else
		set_level(default_z_index)

	return TRUE

//adds the holomap overlays, only supports Station z levels right now
/datum/facility_holomap/proc/set_level(level)
	if(level > z_levels.len)
		return

	displayed_level = level //index

	facility_map.cut_overlays()
	facility_map.vis_contents.Cut()

	if(!forced && z == z_levels[displayed_level])
		facility_map.add_overlay(cursor)

	facility_map.overlays += LAZYACCESS(levels, "[z_levels[displayed_level]]")
	facility_map.vis_contents += LAZYACCESS(maptexts, "[z_levels[displayed_level]]")

	//Fix legend position
	var/pixel_y = HOLOMAP_LEGEND_Y
	for(var/atom/movable/screen/legend/element in legend)
		element.owner = src
		element.pixel_y = pixel_y //Set adjusted pixel y as it will be needed for area placement
		if(element.Setup(z_levels[displayed_level]))
			pixel_y -= 10
			facility_map.vis_contents += element

	if(displayed_level < z_levels.len)
		facility_map.vis_contents += lbuttons[1]

	if(displayed_level > 1)
		facility_map.vis_contents += lbuttons[2]

/datum/facility_holomap/proc/reset_level()
	if(bogus)
		return
	legend_deselect()
	if(default_z_index)
		set_level(default_z_index)

/datum/facility_holomap/proc/legend_select(atom/movable/screen/legend/L)
	var/was_selected = L.selected
	legend_deselect()
	if(!was_selected) //this deselects an previously selected legend
		L.Select()

/datum/facility_holomap/proc/legend_deselect()
	for(var/atom/movable/screen/legend/entry in legend)
		entry.Deselect()

/atom/movable/screen/levelselect
	icon = 'icons/misc/mark.dmi'
	layer = HUD_ITEM_LAYER
	var/active = TRUE
	var/datum/facility_holomap/owner = null

/atom/movable/screen/levelselect/Initialize(mapload, datum/facility_holomap/_owner)
	. = ..()
	owner = _owner

/atom/movable/screen/levelselect/Click()
	return (!usr.incapacitated() && !isdead(usr))

/atom/movable/screen/levelselect/up
	icon_state = "fup"

/atom/movable/screen/levelselect/up/Click()
	if(..())
		if(owner)
			owner.set_level(owner.displayed_level + 1)

/atom/movable/screen/levelselect/down
	icon_state = "fdn"

/atom/movable/screen/levelselect/down/Click()
	if(..())
		if(owner)
			owner.set_level(owner.displayed_level - 1)

/atom/movable/screen/legend
	icon = null
	maptext_height = 128
	maptext_width = 128
	layer = HUD_ITEM_LAYER
	pixel_x = HOLOMAP_LEGEND_X
	var/saved_color
	var/datum/facility_holomap/owner = null
	var/selected = FALSE

/atom/movable/screen/legend/cursor
	icon = 'icons/misc/holomap_markers.dmi'
	icon_state = "you"
	maptext_x = 11
	pixel_x = HOLOMAP_LEGEND_X - 3

/atom/movable/screen/legend/Initialize(mapload, color, text)
	. = ..()
	saved_color = color
	maptext = "<a href='?src=[REF(src)]' style='color: [saved_color]'><span style=\"font-family: 'Small Fonts'; font-size: 7px;\">[text]</span></a>"
	alpha = 254
/atom/movable/screen/legend/Click(location, control, params)
	if(!usr.incapacitated() && !isdead(usr))
		if(istype(owner))
			owner.legend_select(src)

/atom/movable/screen/legend/proc/Setup(z_level)
	//Get the areas for this z level and mark if we're empty
	selected = FALSE
	var/has_areas = FALSE
	overlays.Cut()
	var/list/icon/holomap_areas = SSholomap.holomap_colored_areas["[z_level]"]
	for(var/area/A in holomap_areas)
		if(A.holomap_color == saved_color)
			var/image/area = image(holomap_areas[A])
			area.pixel_x = -pixel_x
			area.pixel_y = -pixel_y
			overlays += area
			has_areas = TRUE
	return has_areas

//What happens when we are clicked on / when another is clicked on
/atom/movable/screen/legend/proc/Select()
	//Start blinking
	selected = TRUE
	animate(src, alpha = 0, time = 2, loop = -1, easing = JUMP_EASING | EASE_IN | EASE_OUT)
	animate(alpha = 254, time = 2, loop = -1, easing = JUMP_EASING | EASE_IN | EASE_OUT)

/atom/movable/screen/legend/proc/Deselect()
	//Stop blinking
	selected = FALSE
	animate(src, flags = ANIMATION_END_NOW)

//Cursor doesnt do anything specific.
/atom/movable/screen/legend/cursor/Setup()
	return TRUE

/atom/movable/screen/legend/cursor/Select()

/atom/movable/screen/legend/cursor/Deselect()

/datum/facility_holomap/proc/initialize_fixed_holomap(z_level)
	facility_map.cut_overlays()
	facility_map.vis_contents.Cut()

	facility_map = image(SSholomap.extra_minimaps["[HOLOMAP_EXTRA_STATIONMAP]_[z_level]"])
	facility_map.add_overlay(cursor)
	facility_map.add_overlay(image('icons/effects/64x64.dmi', "legend", pixel_x = 96, pixel_y = 96))

/datum/facility_holomap/proc/initialize_holomap_bogus()
	bogus = TRUE
	facility_map.cut_overlays()
	facility_map.vis_contents.Cut()

	facility_map = image('icons/480x480.dmi', "stationmap")
	facility_map.add_overlay(image('icons/effects/64x64.dmi', "notfound", pixel_x = 7 * world.icon_size, pixel_y = 7 * world.icon_size))
