/datum/round_event_control/lc13/hiring_freeze
	name = "Hiring Freeze"
	typepath = /datum/round_event/hiring_freeze
	max_occurrences = 4
	weight = 3	//This one is kinda scummy so
	earliest_start = 30 MINUTES

/datum/round_event/hiring_freeze
	announceWhen = 1
	endWhen = 200

/datum/round_event/hiring_freeze/announce()
	priority_announce("Records HQ is notifying this facility's Manager that we are re-assessing our hiring process. \
	For the next few minutes; hiring of new personnel will be extremely limited.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Records")



/datum/round_event/hiring_freeze/end()
	priority_announce("Welfare HQ is notifying this facility's Manager that the allotted 2 minute break has ended.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Welfare")
