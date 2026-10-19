GLOBAL_LIST_EMPTY(lobotomy_boats)

/obj/vehicle/sealed/adventure_boat
	name = "boat"
	desc = "A boat. This shouldn't be available."
	icon_state = "middle_ship"
	icon = 'icons/obj/vehicles.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	can_buckle = FALSE
	var/list/shipturfs = list()
	var/capacity = list()
	var/mob/living/driver
	var/obj/structure/boat_interior/interior
	var/datum/sailor/my_sailor
	var/mob/living/captain
	max_occupants = 1

/obj/vehicle/sealed/adventure_boat/Initialize()
	..()
	for(var/obj/structure/boat_interior/myboat in GLOB.lobotomy_boats)
		if(myboat.current_vessel)
			continue
		interior = myboat
		for(var/turf/open/T in view(12, myboat))
			shipturfs += T
		myboat.current_vessel = src
		GLOB.lobotomy_boats -= myboat
		break

/obj/vehicle/sealed/adventure_boat/generate_actions()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/disembark)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/enter)

/obj/vehicle/sealed/adventure_boat/Destroy()
	if(interior)
		interior.current_vessel = 0
		GLOB.lobotomy_boats += interior
	..()

/obj/vehicle/sealed/adventure_boat/attack_hand(mob/living/carbon/human/user)
	user.forceMove(get_turf(interior))
	say("This is where you'll be connecting to your boat: [get_turf(interior)]")

/obj/vehicle/sealed/adventure_boat/examine(mob/user)
	. = ..()
	. += "It can carry [max_occupants] occupants."

/obj/vehicle/sealed/adventure_boat/relaymove(mob/living/user, direction)
	vehicle_move(direction)
	return TRUE

/obj/vehicle/sealed/adventure_boat/vehicle_move(direction, forcerotate = FALSE)
	if(!COOLDOWN_FINISHED(src, cooldown_vehicle_move))
		return FALSE
	COOLDOWN_START(src, cooldown_vehicle_move, movedelay)
	if(dir != direction)
		setDir(direction)
		return TRUE

	set_glide_size(DELAY_TO_GLIDE_SIZE(movedelay))
	//Otherwise just walk normally
	. = step(src,direction, dir)

/obj/vehicle/sealed/adventure_boat/add_occupant(mob/M, control_flags)
	//RegisterSignal(M, COMSIG_LIVING_DEATH, PROC_REF(mob_exit)) - Causes a runtime, hopefully nothing bad comes from disabling this
	. = ..()
	update_icon()

/obj/vehicle/sealed/adventure_boat/say(message as text, language, ignore_spam, forced, sanitize, spans)
	if(!my_sailor)//The boat should generally not speak without a sailor present
		return
	var/former_name = name
	name = my_sailor.name
	..()
	name = former_name

/obj/vehicle/sealed/adventure_boat/proc/AddSailor(datum/sailor/D)
	if(my_sailor)
		qdel(my_sailor)
	my_sailor = D
	var/spawned = FALSE
	for(var/turf/T in shipturfs)
		for(var/obj/effect/landmark/sailor_spawn/L in T)
			D.landmark = L
			D.RespawnMob()
			to_chat(world, "L [L] has been assigned and RespawnMob() has been called on datum [D]")
			spawned = TRUE
			break
	if(!spawned)
		to_chat(world, "AddSailor on [D] has failed to activate. Check if the landmark has been found.")

/obj/vehicle/sealed/adventure_boat/proc/CheckCaptain(mob/living/carbon/user)
	if(!captain)
		captain = user
		var/new_name = input(user,"Type a new name for your ship","Name the ship")
		if(new_name)
			name = new_name
		to_chat(user, "You claim the [name] as its new captain.")
		return TRUE
	if(captain.stat == DEAD)
		captain = null
	if(user != captain)
		return FALSE
	return TRUE

/obj/vehicle/sealed/adventure_boat/skiff
	name = "skiff"
	desc = "A small vessel popularized by the fixer of the great lake. Experienced sailors use it to hunt massive whales."
	icon_state = "goliath_boat"
	icon = 'icons/obj/lavaland/dragonboat.dmi'
	max_occupants = 2

/obj/vehicle/sealed/adventure_boat/sloop
	name = "sloop"
	desc = "A larger vessel that serves as a generalist when navigating throughout the Great Lake."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "longboat"
	max_occupants = 4

//SAILOR DATUMS// These are very similar to abnormality datums

/datum/sailor
	var/name = "Sailor"
	/// We'll use abnormality risk levels as a comparable metric for its tier
	var/threat_level = ZAYIN_LEVEL
	var/mob/living/simple_animal/hostile/sailor/mob_path
	/// Reference to current mob, if alive
	var/mob/living/simple_animal/hostile/sailor/current
	/// Reference to respawn landmark
	var/obj/effect/landmark/sailor_spawn/landmark

/datum/sailor/noob
	mob_path = /mob/living/simple_animal/hostile/sailor/noob

/datum/sailor/basic
	mob_path = /mob/living/simple_animal/hostile/sailor/basic
	threat_level = TETH_LEVEL

/datum/sailor/pro
	mob_path = /mob/living/simple_animal/hostile/sailor/pro
	threat_level = WAW_LEVEL

/datum/sailor/New(obj/effect/landmark/sailor_spawn/new_landmark)
	if(!new_landmark)
		CRASH("Sailor datum was created without reference to landmark.")
	if(!ispath(mob_path))
		CRASH("Sailor datum was created without a path to the mob.")
	landmark = new_landmark
	name = initial(mob_path.name)
	to_chat(world, "Sailor datum has been created with mob path [mob_path]. Calling RespawnMob()!")

/datum/sailor/proc/RespawnMob()//doesn't work
	if(!istype(landmark))
		CRASH("Couldn't respawn an sailor [initial(mob_path.name)] due to missing landmark.")
	if(!ispath(mob_path))
		CRASH("Sailor tried to respawn a mob, but mob path wasn't valid.")
	if(istype(current))
		to_chat(world, "sailor failed istype() check")//debug text
		return
	var/turf/T = get_turf(landmark)
	current = new mob_path(T)
	to_chat(world, "Creating sailor mob [current] at landmark located at [T]")//debug text
	current.datum_reference = src
	current.setDir(WEST)
	name = current.name

/datum/sailor/Destroy()
	if(current)
		qdel(current)
	landmark = null
	..()

//Misc objects

/obj/effect/boatspawn
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0

/obj/structure/boat_interior
	name = "to surface"
	desc = "A ladder leading to the top deck."
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder10"
	var/obj/vehicle/sealed/adventure_boat/current_vessel
	var/datum/sailor/current_sailor
	var/mob_path = /mob/living/simple_animal/hostile/sailor

/obj/structure/boat_interior/Initialize(mapload)
	GLOB.lobotomy_boats += src
	..()

/obj/structure/boat_interior/attack_hand(mob/living/carbon/human/user)
	if(current_vessel)
		current_vessel.add_occupant(user)
		user.forceMove(current_vessel)
	else
		user.forceMove(locate(128, 4, 7))//un-hardcode this
