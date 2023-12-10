/datum/map_template/abnormality_room
	name = "Abnormality Room"
	width = 7
	height = 5
	mappath = "_maps/templates/abnormality_containment.dmm"

/datum/map_template/abnormality_room/load(turf/T, centered = FALSE)
	. = ..()
	post_load(T, centered)

/datum/map_template/abnormality_room/post_load(turf/T, centered = FALSE)
	var/list/list_o_turfs = get_affected_turfs(T, centered)
	var/list/allObjects = list()
	var/mob/living/simple_animal/hostile/abnormality/abno_path = SSabnormality_queue.queued_abnormality
	var/datum/abnormality/abno_datum
	var/obj/machinery/computer/abnormality/room_console
	if(!ispath(abno_path))
		CRASH("Abnormality room spawned with wrong mob path.")
	for(var/turf/TF in list_o_turfs)
		for(var/obj/O in TF.contents)
			allObjects += O
	for(var/obj/effect/landmark/abnormality_spawn/AS in allObjects)
		abno_datum = new(AS, abno_path)
		AS.datum_reference = abno_datum
		break // There can be only one
	for(var/obj/machinery/computer/abnormality/AC in allObjects)
		AC.datum_reference = abno_datum
		AC.datum_reference.console = AC
		room_console = AC
		break
	if(room_console)
		for(var/obj/machinery/containment_panel/C in allObjects)
			C.linked_console = room_console
			room_console.LinkPanel(C)
			C.console_status(room_console)
			C.name = "\proper [C.linked_console.datum_reference.name]'s containment panel"
			break
	for(var/obj/machinery/door/airlock/AR in allObjects)
		AR.name = "[abno_datum.name] containment zone"
		AR.desc = "Containment zone of [abno_datum.name]. Threat level: [THREAT_TO_NAME[abno_datum.threat_level]]."
	for(var/obj/machinery/camera/ACM in allObjects)
		ACM.c_tag = "Containment zone: [abno_datum.name]"
	SSabnormality_queue.PostSpawn()
	SSlobotomy_corp.NewAbnormality(abno_datum)

GLOBAL_LIST_EMPTY(abnormality_room_spawners)

// Room spawner for abnormalities
/obj/effect/spawner/abnormality_room
	name = "abnormality room spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "abno_room"
	dir = NORTH
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/global/datum/map_template/abnormality_room/template

/obj/effect/spawner/abnormality_room/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/spawner/abnormality_room/LateInitialize()
	if(!template)
		template = TRUE // to avoid generating it multiple times, since new() isn't instant
		template = new(cache = TRUE)
	GLOB.abnormality_room_spawners += src

/obj/effect/spawner/abnormality_room/proc/SpawnRoom()
	template.load(get_turf(src))
	qdel(src)

/obj/effect/spawner/abnormality_room/Destroy()
	GLOB.abnormality_room_spawners -= src
	..()
