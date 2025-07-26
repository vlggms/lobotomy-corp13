SUBSYSTEM_DEF(gamedirector)
	name = "RCE Director"
	flags = SS_BACKGROUND || SS_NO_FIRE
	wait = 30 SECONDS
	init_order = INIT_ORDER_GAMEDIRECTOR

	var/list/obj/effect/landmark/available_landmarks = list()
	var/datum/component/wave_announcer
	var/first_announce = TRUE

/datum/controller/subsystem/gamedirector/Initialize()
	. = ..()
	available_landmarks = GLOB.department_centers

/datum/controller/subsystem/gamedirector/fire(resumed = FALSE)
	return

/datum/controller/subsystem/gamedirector/proc/PopRandomLandmark()
	if(available_landmarks.len > 0)
		var/x = pick(available_landmarks)
		available_landmarks.Remove(x)
		return x
	else
		return pick(GLOB.department_centers)

/datum/controller/subsystem/gamedirector/proc/RegisterAsWaveAnnouncer(datum/component/applicant)
	if(!wave_announcer)
		wave_announcer = applicant
		return TRUE
	return FALSE

/datum/controller/subsystem/gamedirector/proc/AnnounceWave()
	if(first_announce)
		first_announce = FALSE
		return
	var/text = "A new X-Corp attack wave is inbound."
	show_global_blurb(60 SECONDS, text, 1 SECONDS, "red", "black")

/datum/controller/subsystem/gamedirector/proc/AnnounceVictory()
	var/text = "The X-Corp Heart has been destroyed! Victory achieved."
	show_global_blurb(60 SECONDS, text, 1 SECONDS, "gold", "white")
	SSticker.force_ending = 1
