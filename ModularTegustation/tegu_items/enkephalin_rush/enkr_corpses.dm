//dead stuff but better

/obj/effect/mob_spawn/human/agent//TODO: make these always available
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/agent
	brute_damage = 1000

/obj/effect/mob_spawn/human/agent/loot
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/agent

/obj/effect/mob_spawn/human/agent/loot/Initialize()
	..()//Loot generation goes here

/obj/effect/mob_spawn/human/manager
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/manager
	brute_damage = 1000
