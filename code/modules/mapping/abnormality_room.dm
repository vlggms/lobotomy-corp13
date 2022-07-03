/datum/map_template/abnormality_room
	name = "Abnormality Room"
	mappath = "_maps/templates/abnormality_containment.dmm"

/datum/map_template/abnormality_room/load(turf/T, centered = FALSE)
	. = ..()
	post_load(T, centered)

/datum/map_template/abnormality_room/post_load(turf/T, centered = FALSE)
	var/list/list_o_turfs = get_affected_turfs(T, centered)
	var/list/allObjects = list()
	var/mob/living/simple_animal/hostile/abnormality/abno_path = SSabnormality_queue.queued_abnormality
	var/datum/abnormality/abno_datum
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
		break
	for(var/obj/machinery/door/airlock/AR in allObjects)
		AR.name = "[abno_datum.name] containment zone"
		AR.desc = "Containment zone of [abno_datum.name]. Threat level: [THREAT_TO_NAME[abno_datum.threat_level]]."
	SSabnormality_queue.postspawn()
	SSlobotomy_corp.NewAbnormality(abno_datum)
