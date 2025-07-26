/* Spreading Structures Code
	Stolen and edited from alien weed code. I wanted a spreading
	structure that doesnt have the atmospheric element attached to its root. */
/obj/structure/spreading
	name = "spreading structure"
	desc = "This thing seems to spread when supplied with a outside signal."
	max_integrity = 15
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	var/conflict_damage = 10
	var/last_expand = 0 //last world.time this weed expanded
	var/expand_cooldown = 1.5 SECONDS
	var/can_expand = TRUE
	var/bypass_density = FALSE
	var/static/list/blacklisted_turfs

/obj/structure/spreading/Initialize()
	. = ..()

	if(!blacklisted_turfs)
		blacklisted_turfs = typecacheof(list(
			/turf/open/space,
			/turf/open/chasm,
			/turf/open/lava,
			/turf/open/openspace))

/obj/structure/spreading/proc/expand(bypasscooldown = FALSE)
	if(!can_expand)
		return

	if(!bypasscooldown)
		last_expand = world.time + expand_cooldown

	var/turf/U = get_turf(src)
	if(is_type_in_typecache(U, blacklisted_turfs))
		qdel(src)
		return FALSE

	var/list/spread_turfs = U.reachableAdjacentTurfs()
	shuffle_inplace(spread_turfs)
	for(var/turf/T in spread_turfs)
		var/obj/machinery/M = locate(/obj/machinery) in T
		if(M)
			if(M.density && !bypass_density)
				continue
		var/obj/structure/spreading/S = locate(/obj/structure/spreading) in T
		if(S)
			if(S.type != type) //if it is not another of the same spreading structure.
				S.take_damage(conflict_damage, BRUTE, "melee", 1)
				break
			last_expand += (0.6 SECONDS) //if you encounter another of the same then the delay increases
			continue

		if(is_type_in_typecache(T, blacklisted_turfs))
			continue

		new type(T)
		break
	return TRUE

//Cosmetic Structures
/obj/structure/cavein_floor
	name = "blocked off floor entrance"
	desc = "An entrance to some underground facility that has been caved in."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "cavein_floor"
	anchored = TRUE

/obj/structure/cavein_door
	name = "blocked off facility entrance"
	desc = "A entrance to somewhere that has been blocked off with rubble."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "cavein_door"
	pixel_y = -8
	base_pixel_y = -8
	anchored = TRUE

/*
* Wave Spawners. Uses the monwave_spawners component.
*/
/obj/structure/den
	name = "spawning_den"
	desc = "subtype for dens you shouldnt be seeing this."
	icon_state = "hole"
	icon = 'icons/mob/nest.dmi'
	max_integrity = 200
	anchored = TRUE
	density = FALSE
	var/list/moblist = list()
	var/target

/obj/structure/den/tunnel/Initialize(mapload)
	. = ..()
	if(!target)
		target = get_turf(src)
	AddComponent(/datum/component/monwave_spawner, attack_target = target, new_wave_order = moblist)

/obj/structure/den/proc/changeTarget(thing)
	var/turf/target_turf = get_turf(thing)
	if(!target_turf)
		return FALSE
	var/datum/component/monwave_spawner/target_component = datum_components[/datum/component/monwave_spawner]
	target_component.GeneratePath(target_turf)
	return TRUE

/obj/structure/den/tunnel
	name = "tunnel entrance"
	desc = "A entrance to a underground tunnel. It would only take a few whacks to cave it in."
	icon_state = "hole"
	icon = 'icons/mob/nest.dmi'
	moblist = list(
		/mob/living/simple_animal/hostile/ordeal/steel_dawn = 3,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 1,
	)

/obj/structure/den/rce
	name = "X-Corp Attack Pylon"
	desc = "Best destroy this!"
	icon_state = "powerpylon"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	color = "#FF5522"
	max_integrity = 500
	moblist = list(
		/mob/living/simple_animal/hostile/ordeal/steel_dawn = 2,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 1,
		/mob/living/simple_animal/hostile/ordeal/green_bot = 1,
	)
	var/announce = FALSE

/obj/structure/den/rce/announcer
	announce = TRUE

/obj/structure/den/rce/Initialize(mapload)
	. = ..()
	if(SSgamedirector.available_landmarks.len == 0)
		target = pick(GLOB.department_centers)
	else
		target = SSgamedirector.PopRandomLandmark()
	AddComponent(/datum/component/monwave_spawner, attack_target = target, new_wave_order = moblist, try_for_announcer = announce)

/obj/structure/den/rce_defender
	name = "X-Corp Defense Pylon"
	desc = "Best destroy this!"
	icon_state = "defensepylon"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	color = "#FF0000"
	max_integrity = 1000
	moblist = list(
		/mob/living/simple_animal/hostile/ordeal/steel_dawn = 3,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 1,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk = 2,
		/mob/living/simple_animal/hostile/ordeal/green_bot = 2,
		/mob/living/simple_animal/hostile/ordeal/green_bot_big = 2,
		/mob/living/simple_animal/hostile/asteroid/elite/legionnaire = 1,
	)

/obj/structure/den/rce_defender/Initialize(mapload)
	. = ..()
	if(!target)
		target = get_turf(src)
	AddComponent(/datum/component/monwave_spawner, attack_target = target, new_wave_order = moblist)

/obj/structure/den/rce_heart
	name = "X-Corp Heart"
	desc = "Best destroy this!"
	icon_state = "nexus"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	color = "#FF0000"
	max_integrity = 5000
	moblist = list(
		/mob/living/simple_animal/hostile/megafauna/legion = 1,
	)

/obj/structure/den/rce_heart/Initialize(mapload)
	. = ..()
	if(!target)
		target = get_turf(src)
	AddComponent(/datum/component/monwave_spawner, attack_target = target, new_wave_order = moblist, max_mobs = 1)

/obj/structure/den/rce_heart/Destroy()
	SSgamedirector.AnnounceVictory()
	. = ..()

/**
 * List of button counters
 * Required as persistence subsystem loads after the ones present at mapload, and to reset to 0 upon explosion.
 */
GLOBAL_LIST_EMPTY(map_button_counters)
/obj/structure/sign/button_counter
	name = "button counter"
	sign_change_name = "Flip Sign- Days since buttoned"
	desc = "A pair of flip signs describe how long it's been since the last button incident."
	icon_state = "days_since_button"
	icon = 'ModularTegustation/Teguicons/button_counter.dmi'
	is_editable = TRUE
	var/since_last = 0

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/button_counter, 32)

/obj/structure/sign/button_counter/Initialize(mapload)
	. = ..()
	GLOB.map_button_counters += src
	if(!mapload)
		update_count(SSpersistence.rounds_since_button_pressed)

/obj/structure/sign/button_counter/Destroy()
	GLOB.map_button_counters -= src
	return ..()

/obj/structure/sign/button_counter/proc/update_count(new_count)
	since_last = min(new_count, 99)
	update_icon()

/obj/structure/sign/button_counter/update_icon()
	cut_overlays()
	var/ones = since_last % 10
	var/mutable_appearance/ones_overlay = mutable_appearance('ModularTegustation/Teguicons/button_counter.dmi', "days_[ones]")
	ones_overlay.pixel_x = 4

	var/tens = (since_last / 10) % 10
	var/mutable_appearance/tens_overlay = mutable_appearance('ModularTegustation/Teguicons/button_counter.dmi', "days_[tens]")
	tens_overlay.pixel_x = -5

	add_overlay(list(ones_overlay, tens_overlay))

/obj/structure/sign/button_counter/examine(mob/user)
	. = ..()
	. += span_info("It has been [since_last] day\s since the last button event at a Lobotomy facility.")
	switch(since_last)
		if(0)
			. += span_info("In case you didn't notice.")
		if(1)
			. += span_info("Let's do better today.")
		if(2 to 5)
			. += span_info("There's room for improvement.")
		if(6 to 10)
			. += span_info("Good work!")
		if(11 to INFINITY)
			. += span_info("Incredible!")
