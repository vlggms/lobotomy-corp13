/obj/machinery/facility_holomap
	name = "facility holomap"
	desc = "A virtual map of the surrounding facility."
	icon = 'icons/obj/machines/facilitymap.dmi'
	icon_state = "station_map"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	vis_flags = VIS_HIDE // They have an emissive that looks bad in openspace due to their wall-mounted nature

	light_color = "#64c864"
	light_range = 4
	light_power = 1
	light_system = STATIC_LIGHT

	layer = ABOVE_WINDOW_LAYER	// Above windows.

	var/mob/watching_mob = null
	var/image/small_facility_map = null
	var/image/floor_markings = null
	var/image/panel = null

	var/original_zLevel = 1	// zLevel on which the facility map was initialized. (defaults to machinery z level)
	var/forced_zLevel = 0	//can be set by mappers to override the facility Map's original_zLevel
	var/datum/facility_holomap/holomap_datum

/obj/machinery/facility_holomap/Destroy()
	SSholomap.facility_holomaps -= src
	if(watching_mob)
		if(watching_mob?.client)
			watching_mob.client.images -= holomap_datum.facility_map
		UnregisterSignal(watching_mob, COMSIG_MOVABLE_MOVED)
	watching_mob = null
	QDEL_NULL(holomap_datum)
	return ..()

/obj/machinery/facility_holomap/New()
	..()
	flags_1 |= ON_BORDER_1

/obj/machinery/facility_holomap/Initialize()
	. = ..()
	holomap_datum = new()
	SSholomap.facility_holomaps += src

	//Set pixel offsets based on dir (the side of the holomap facing the person)
	if(dir == NORTH)
		pixel_x = 0
		pixel_y = -32
	if(dir == SOUTH)
		pixel_x = 0
		pixel_y = 32
	if(dir == WEST)
		pixel_x = 32
		pixel_y = 0
	if(dir == EAST)
		pixel_x = -32
		pixel_y = 0

	if(SSholomap.initialized)
		update_map_data()
	add_floor_decal()

/obj/machinery/facility_holomap/proc/update_map_data()
	var/turf/T = get_turf(src)
	original_zLevel = T.z
	var/forced = FALSE
	if(forced_zLevel && original_zLevel != forced_zLevel) //in case a holomap is forced to the level its already on
		T = locate(T.x,T.y,forced_zLevel)
		original_zLevel = forced_zLevel
		forced = TRUE

	holomap_datum.initialize_holomap(T, reinit = TRUE, is_forced = forced)

	//Small map for icon
	small_facility_map = image(SSholomap.extra_minimaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[original_zLevel]"], dir = dir)
	small_facility_map.plane = ABOVE_LIGHTING_PLANE
	small_facility_map.layer = ABOVE_LIGHTING_LAYER

	update_icon()

/obj/machinery/facility_holomap/proc/add_floor_decal()
	floor_markings = image('icons/obj/machines/facilitymap.dmi', "decal_station_map")
	floor_markings.dir = src.dir
	floor_markings.layer = ABOVE_OPEN_TURF_LAYER
	floor_markings.pixel_x = -src.pixel_x
	floor_markings.pixel_y = -src.pixel_y
	update_icon()

/obj/machinery/facility_holomap/attack_hand(mob/user)
	if(watching_mob)
		if(watching_mob != user)
			to_chat(user, "<span class='warning'>Someone else is currently watching the holomap.</span>")
			return
		else
			stopWatching()
			return
	if(user.loc != loc)
		to_chat(user, "<span class='warning'>You need to stand in front of \the [src].</span>")
		return
	startWatching(user)

// Let people bump up against it to watch
/obj/machinery/facility_holomap/Bumped(atom/movable/AM)
	if(!watching_mob && isliving(AM) && AM.loc == loc)
		startWatching(AM)

// In order to actually get Bumped() we need to block movement.  We're (visually) on a wall, so people
// couldn't really walk into us anyway.  But in reality we are on the turf in front of the wall, so bumping
// against where we seem is actually trying to *exit* our real loc
/obj/machinery/facility_holomap/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(get_dir(target, loc) == dir) // Opposite of "normal" since we are visually in the next turf over
		return FALSE
	else
		return TRUE

/obj/machinery/facility_holomap/proc/startWatching(mob/user)
	if(isliving(user) && anchored && !(machine_stat & (NOPOWER|BROKEN)))
		if(user.hud_used && user.hud_used.holomap)
			holomap_datum.facility_map.loc = user.hud_used.holomap  // Put the image on the holomap hud
			holomap_datum.facility_map.alpha = 0 // Set to transparent so we can fade in
			watching_mob = user
			watching_mob.client.images |= holomap_datum.facility_map
			flick("facility_map_activate", src)
			animate(holomap_datum.facility_map, alpha = 255, time = 5, easing = LINEAR_EASING)

			RegisterSignal(watching_mob, COMSIG_MOVABLE_MOVED, PROC_REF(checkPosition))
			use_power = ACTIVE_POWER_USE

			if(holomap_datum.bogus)
				to_chat(user, "<span class='warning'>The holomap failed to initialize. This region cannot be mapped.</span>")
			else
				to_chat(user, "<span class='notice'>A hologram of your current location appears before your eyes.</span>")
			START_PROCESSING(SSmachines, src)

/obj/machinery/facility_holomap/process()
	if((machine_stat & (NOPOWER|BROKEN)))
		stopWatching()
		STOP_PROCESSING(SSmachines, src)
		return PROCESS_KILL

/obj/machinery/facility_holomap/proc/checkPosition()
	SIGNAL_HANDLER

	if(!watching_mob || (watching_mob.loc != loc) || (dir != watching_mob.dir))
		stopWatching()

/obj/machinery/facility_holomap/proc/stopWatching()
	if(watching_mob)
		if(watching_mob.client)
			animate(holomap_datum.facility_map, alpha = 0, time = 5, easing = LINEAR_EASING)
			var/mob/M = watching_mob
			addtimer(CALLBACK(src, PROC_REF(clear_image), M, holomap_datum.facility_map), 5, TIMER_CLIENT_TIME)//we give it time to fade out
		UnregisterSignal(watching_mob, COMSIG_MOVABLE_MOVED)
	watching_mob = null
	use_power = IDLE_POWER_USE

/obj/machinery/facility_holomap/proc/clear_image(mob/M, image/I)
	if(M.client)
		M.client.images -= I
	holomap_datum.reset_level()

/obj/machinery/facility_holomap/power_change()
	. = ..()
	update_icon()
	if(machine_stat & NOPOWER)	// Maybe port /vg/'s autolights? Done manually for now.
		set_light_on(FALSE)
	else
		set_light_on(TRUE)

/obj/machinery/facility_holomap/update_icon_state()
	. = ..()
	if(machine_stat & BROKEN)
		icon_state = "station_mapb"
	else if((machine_stat & NOPOWER) || !anchored)
		icon_state = "station_map0"
	else
		icon_state = "station_map"

/obj/machinery/facility_holomap/update_overlays()
	. = ..()
	cut_overlays()

	if(!(machine_stat & (BROKEN|NOPOWER)) && anchored)
		if(small_facility_map)
			add_overlay(small_facility_map)

	if(floor_markings)
		add_overlay(floor_markings)

	if(panel_open)
		add_overlay("station_map-panel")
	else
		cut_overlay("station_map-panel")
