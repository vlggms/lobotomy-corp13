/datum/round_event_control/lc13/pizza_party
	name = "Pizza Party!"
	typepath = /datum/round_event/pizza_party
	max_occurrences = 1
	weight = 2	//Corporate does NOT want you to have pizza
	earliest_start = 45 MINUTES

/datum/round_event/pizza_party
	announceWhen = 1

/datum/round_event/pizza_party/announce()
	priority_announce("Welfare HQ has decided that for the good of all the agents in the facility, \
	a pizza party has been authorized. A pizza has been shipped into each department centre.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Welfare")

	var/pizzatype_list = subtypesof(/obj/item/food/pizza)
	// Funny enough you can still get the murder pizza becuase it's funny
	pizzatype_list -= /obj/item/food/pizza/margherita/robo // No robo pizza
	for(var/turf/T in GLOB.department_centers)
		// Yes, this delivers to dead bodies. It's REALLY FUNNY.
		var/obj/structure/closet/supplypod/centcompod/pod = new()
		var/pizzatype = pick(pizzatype_list)
		new pizzatype(pod)
		pod.explosionSize = list(0,0,0,0)
		new /obj/effect/pod_landingzone(T, pod)

