// Most of its effects are applied elsewhere
/datum/suppression/information
	name = "Information Core Suppression"
	run_text = "The core suppression of Information department has begun. The information and sensors will be distorted for its duration."

/datum/suppression/information/Run(run_white = TRUE)
	. = ..()
	for(var/obj/machinery/telecomms/processor/P in GLOB.telecomms_list)
		P.process_mode = 0 // Makes all messages pure gibberish

/datum/suppression/information/End()
	for(var/obj/machinery/telecomms/processor/P in GLOB.telecomms_list)
		P.process_mode = 1
	return ..()
