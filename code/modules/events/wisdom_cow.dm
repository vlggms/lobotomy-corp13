/datum/round_event_control/lc13/wisdomcow
	name = "Wisdom cow"
	typepath = /datum/round_event/wisdomcow
	max_occurrences = 3
	weight = 10

/datum/round_event/wisdomcow/announce(fake)
	priority_announce("A wise cow has been spotted in the area. Be sure to ask for her advice.", "HQ Safety")

/datum/round_event/wisdomcow/start()
	var/turf/targetloc = get_turf(pick(GLOB.xeno_spawn))
	new /mob/living/simple_animal/cow/wisdom(targetloc)
	do_smoke(1, targetloc)

