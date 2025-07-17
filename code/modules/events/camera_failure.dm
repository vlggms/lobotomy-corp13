/datum/round_event_control/lc13/camera_failure
	name = "Camera Failure"
	typepath = /datum/round_event/camera_failure
	weight = 30
	max_occurrences = 5
	//The RO should probably see this happening.

/datum/round_event/camera_failure
	fakeable = FALSE

/datum/round_event/camera_failure/start()
	var/list/cameras = GLOB.cameranet.cameras.Copy()
	var/obj/machinery/camera/C = pick_n_take(cameras)
	if (!C)
		return
	if (!("ss13" in C.network))
		return
	if(C.status)
		C.toggle_cam(null, 0)
