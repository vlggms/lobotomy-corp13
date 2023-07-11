// Most of its effects are applied elsewhere
/datum/suppression/information
	name = "Information Core Suppression"
	desc = "Assignments on the abnormality work consoles will be in random positions.\n\
			Telecommunications and suit sensors will be negatively impacted."
	reward_text = "Unique PE gained by working on abnormalities is increased by 25%."
	run_text = "The core suppression of Information department has begun. The information and sensors will be distorted for its duration."

/datum/suppression/information/Run(run_white = FALSE)
	. = ..()
	for(var/obj/machinery/telecomms/processor/P in GLOB.telecomms_list)
		P.process_mode = 0 // Makes all messages pure gibberish

/datum/suppression/information/End()
	for(var/obj/machinery/telecomms/processor/P in GLOB.telecomms_list)
		P.process_mode = 1
	SSlobotomy_corp.box_work_multiplier *= 1.25
	return ..()
