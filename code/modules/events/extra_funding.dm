/datum/round_event_control/lc13/extra_funding
	name = "Extra Funding"
	typepath = /datum/round_event/extra_funding
	max_occurrences = 2
	weight = 2	//Corporate thinks you're well funded.

/datum/round_event/extra_funding
	announceWhen = 1
	endWhen = 200

/datum/round_event/extra_funding/announce()
	priority_announce("HQ Central Command has assessed that your facility is in desperate need of funding, \
	and has shifted some LOB into your manager's account. \
	In exchange, your manager will have this reflected on their quarterly performance report.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Central Command")

	SSlobotomy_corp.lob_points += 1

