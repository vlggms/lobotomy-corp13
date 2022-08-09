/obj/machinery/computer/camera_advanced/manager
	name = "managerial camera console"
	var/datum/action/innate/door_bolt/bolt_action = new

/obj/machinery/computer/camera_advanced/manager/GrantActions(mob/living/carbon/user)
	..()

	if(bolt_action)
		bolt_action.Grant(user)
		actions += bolt_action

/datum/action/innate/door_bolt
	name = "Bolt Airlock"
	icon_icon = 'icons/mob/actions/actions_construction.dmi'
	button_icon_state = "airlock_select"

/datum/action/innate/door_bolt/Activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control

	var/turf/T = get_turf(remote_eye)
	for(var/obj/machinery/door/airlock/A in T.contents)
		if(A.locked)
			A.unbolt()
		else
			A.bolt()
