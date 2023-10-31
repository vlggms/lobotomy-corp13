// Minimap generation system adapted from vorestation, adapted from /vg/.
// Seems to be much simpler/saner than /vg/'s implementation.

// Turfs that are ignored when drawing holomap

//change to typecache?
#define IS_ROCK(tile) (istype(tile, /turf/closed/mineral) || istype(tile, /turf/closed/indestructible/rock))

// Turfs that will be colored as HOLOMAP_OBSTACLE
#define IS_OBSTACLE(tile) (istype(tile, /turf/closed/wall) \
					|| istype(tile, /turf/closed/indestructible) \
					|| (locate(/obj/structure/grille) in tile))

// Turfs that will be colored as HOLOMAP_PATH
#define IS_PATH(tile) ((istype(tile, /turf/open/floor) && !istype(tile, /turf/open/floor/plating/asteroid)) \
					|| (locate(/obj/structure/lattice/catwalk) in tile))

SUBSYSTEM_DEF(holomap)
	name = "Holomap"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_HOLOMAP

	var/list/holo_minimaps = list() //base walls and path
	var/list/extra_minimaps = list()
	var/list/facility_holomaps = list() //holomap machines
	var/list/holomap_colored_areas = list() //list of colored boxes associated with area loc

/datum/controller/subsystem/holomap/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.

/datum/controller/subsystem/holomap/Initialize()
	holo_minimaps.len = world.maxz
	for (var/z = 1 to world.maxz)
		generateHolomap(z)

	//Update machinery if it has not been
	for(var/obj/machinery/facility_holomap/M in facility_holomaps)
		M.update_map_data()

	..()

/datum/controller/subsystem/holomap/proc/generateHolomap(zlevel)
	holo_minimaps |= zlevel
	holo_minimaps[zlevel] = generateBaseHolomap(zlevel) //dynamic holomap uses this
	holomap_colored_areas["[zlevel]"] = generateHolomapAreaOverlays(zlevel)

	var/offset_x = HOLOMAP_PIXEL_OFFSET_X
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		stack_trace("Minimap for z=[zlevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		stack_trace("Minimap for z=[zlevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	var/list/icon/holomap_areas = holomap_colored_areas["[zlevel]"]
	for(var/area/A in holomap_areas)
		var/icon/single = holomap_areas[A]
		canvas.Blend(single, ICON_OVERLAY)

	// Save this nice area-colored canvas in case we want to layer it or something I guess
	extra_minimaps |= "[HOLOMAP_EXTRA_STATIONMAPAREAS]_[zlevel]"
	extra_minimaps["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[zlevel]"] = canvas

	var/icon/map_base = icon(holo_minimaps[zlevel])
	//Make it green.
	map_base.Blend(HOLOMAP_HOLOFIER, ICON_MULTIPLY)

	// Generate the full sized map by blending the base and areas onto the backdrop
	var/icon/big_map = icon(HOLOMAP_ICON, "stationmap")
	big_map.Blend(map_base, ICON_OVERLAY)
	big_map.Blend(canvas, ICON_OVERLAY)
	extra_minimaps |= "[HOLOMAP_EXTRA_STATIONMAP]_[zlevel]"
	extra_minimaps["[HOLOMAP_EXTRA_STATIONMAP]_[zlevel]"] = big_map

	// Generate the "small" map
	var/icon/small_map = icon(HOLOMAP_ICON, "blank")
	small_map.Blend(map_base, ICON_OVERLAY)
	small_map.Blend(canvas, ICON_OVERLAY)
	small_map.Scale(world.icon_size, world.icon_size)

	// And rotate it in every direction of course!
	var/icon/actual_small_map = icon(small_map)
	actual_small_map.Insert(new_icon = small_map, dir = SOUTH)
	actual_small_map.Insert(new_icon = turn(small_map, 90), dir = WEST)
	actual_small_map.Insert(new_icon = turn(small_map, 180), dir = NORTH)
	actual_small_map.Insert(new_icon = turn(small_map, 270), dir = EAST)
	extra_minimaps |= "[HOLOMAP_EXTRA_STATIONMAPSMALL]_[zlevel]"
	extra_minimaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[zlevel]"] = actual_small_map

// Generates the "base" holomap for one z-level, showing only the physical structure of walls and paths.
/datum/controller/subsystem/holomap/proc/generateBaseHolomap(zlevel = 1)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		CRASH("Minimap for z=[zlevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		CRASH("Minimap for z=[zlevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	// Turfs that are ignored when drawing holomap
	var/list/rock_tcache = typecacheof(list(
		/turf/closed/mineral,
		/turf/closed/indestructible/rock
	))
	// Turfs that will be colored as HOLOMAP_OBSTACLE
	var/list/obstacle_tcache = typecacheof(list(
		/turf/closed/wall,
		/turf/closed/indestructible
	))
	// Turfs that will be colored as HOLOMAP_PATH
	var/list/path_tcache = typecacheof(list(
		/turf/open/floor
	)) - typecacheof(/turf/open/floor/plating/asteroid)

	for(var/thing in Z_TURFS(zlevel))
		var/turf/T = thing
		var/area/A = T.loc
		var/Ttype = T.type

		if (A.area_flags & HIDE_FROM_HOLOMAP)
			continue
		if (rock_tcache[Ttype])
			continue
		if (obstacle_tcache[Ttype] || (T.contents.len && locate(/obj/structure/grille, T)))
			canvas.DrawBox(HOLOMAP_OBSTACLE, T.x + offset_x, T.y + offset_y)
		else if(path_tcache[Ttype] || (T.contents.len && locate(/obj/structure/lattice/catwalk, T)))
			canvas.DrawBox(HOLOMAP_PATH, T.x + offset_x, T.y + offset_y)

		CHECK_TICK

	return canvas

// Generate colored overlays based on areas (used for interactable legend)
/datum/controller/subsystem/holomap/proc/generateHolomapAreaOverlays(zlevel)
	var/list/icon/areas = list()

	var/offset_x = HOLOMAP_PIXEL_OFFSET_X
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y

	for(var/thing in Z_TURFS(zlevel))
		var/turf/tile = thing
		if(tile && tile.loc)
			var/area/areaToPaint = tile.loc
			if(areaToPaint.holomap_color)
				if(!areas[areaToPaint])
					areas[areaToPaint] = icon(HOLOMAP_ICON, "blank")
				areas[areaToPaint].DrawBox(areaToPaint.holomap_color, tile.x + offset_x, tile.y + offset_y)
	return areas

#undef IS_ROCK
#undef IS_OBSTACLE
#undef IS_PATH
