/datum/round_event_control/lc13/records_knowledge
	name = "Camera Failure"
	typepath = /datum/round_event/records_knowledge
	weight = 15
	max_occurrences = 150
	alert_observers = FALSE
	//This is so minor.

/datum/round_event/records_knowledge
	fakeable = FALSE

/datum/round_event/records_knowledge/start()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(prob(10))
			H.adjust_all_attribute_levels(1)
