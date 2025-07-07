/datum/round_event_control/lc13/quota_recalculation
	name = "Quota Recalculation"
	typepath = /datum/round_event/quota_recalculation
	weight = 4
	max_occurrences = 3
	earliest_start = 20 MINUTES

/datum/round_event/quota_recalculation
	announceWhen = 1

/datum/round_event/quota_recalculation/announce(fake)
	priority_announce("Central Command apologizes for their supplied quota. Quota has been re-calculated based off current facility staff.", "HQ Central Command")

/datum/round_event/quota_recalculation/start()
	var/player_mod = length(GLOB.player_list) * 0.2
	SSlobotomy_corp.box_goal = clamp(round(7500 * player_mod), 3000, 36000)
