/datum/round_event_control/extraction_blitz
	name = "Extraction Blitz"
	typepath = /datum/round_event/extraction_blitz
	weight = 10
	max_occurrences = 5

/datum/round_event/extraction_blitz
	fakeable = FALSE

/datum/round_event/extraction_blitz/announce(fake)
	priority_announce("Localized energetic flux wave detected on long range scanners. Expected location of impact: [impact_area.name].", "Anomaly Alert")

/datum/round_event/extraction_blitz/start()
	var/iterations = 1
	var/list/cameras = GLOB.cameranet.cameras.Copy()
	var/obj/machinery/camera/C = pick_n_take(cameras)
	if (!C)
		break
	if (!("ss13" in C.network))
		continue
	if(C.status)
		C.toggle_cam(null, 0)
	iterations *= 2.5
