//-----W_CORP-----
//W-Corp has movement technology, and upgraded weapons.
//They're very much a jack of all trades.

/datum/data/lc13research/w_corp_typea
	research_name = "W Corp Type A Weapons"
	research_desc = "W Corp will let you purchase their Type-A weapons, at a pretty steep cost."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/w_corp_typea/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "W Corp Type A Fist",	/obj/item/ego_weapon/city/charge/wcorp/fist, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Axe",		/obj/item/ego_weapon/city/charge/wcorp/axe, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Spear",	/obj/item/ego_weapon/city/charge/wcorp/spear, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Dagger",	/obj/item/ego_weapon/city/charge/wcorp/dagger, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Hammer",	/obj/item/ego_weapon/city/charge/wcorp/hammer, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Hatchet",	/obj/item/ego_weapon/city/charge/wcorp/hatchet, 1000)
	..()

/datum/data/lc13research/w_corp_typec
	research_name = "W Corp Type C Weapons"
	research_desc = "W Corp will let you purchase their Type-C Support weapons, for a price."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/w_corp_typec/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "W Corp Type C ShieldBlade",	/obj/item/ego_weapon/city/charge/wcorp/shield, 850)
	ItemUnlock(caller.order_list, "W Corp Type C ShieldGlaive",		/obj/item/ego_weapon/city/charge/wcorp/shield/spear, 1000)
	ItemUnlock(caller.order_list, "W Corp Type C ShieldClub",	/obj/item/ego_weapon/city/charge/wcorp/shield/club, 850)
	ItemUnlock(caller.order_list, "W Corp Type C ShieldAxe",	/obj/item/ego_weapon/city/charge/wcorp/shield/axe, 850)
	..()

/datum/data/lc13research/mobspawner/wcorp
	research_name = "W-Corp L1 Cleanup Team"
	research_desc = "The nearby intern staff are looking for easy training. <br>We can ship them to you but they won't be that effective."
	cost = LOW_RESEARCH_PRICE
	corp = W_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/wcorp_call

/datum/data/lc13research/mobspawner/wcorpl2
	research_name = "W-Corp L2 Cleanup Team"
	research_desc = "The nearby L2 staff are looking for their monthly bonus. <br>They're at the ready should you need them."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/wcorp_call/level2
	required_research = /datum/data/lc13research/mobspawner/wcorp

/datum/data/lc13research/mobspawner/wcorpl3
	research_name = "W-Corp L3 Cleanup Team"
	research_desc = "Currently there are no trains requiring trains requiring major cleanup so we have nearby L3 available for contingency measures, only use this if corporation assets are claimed by another Wing. <br>They'll clean up any problems you have."
	cost = 0
	corp = W_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/wcorp_call/level3
	required_research = /datum/data/lc13research/mobspawner/wcorp

/datum/data/lc13research/mobspawner/wcorpl3/ResearchEffect(obj/structure/representative_console/caller)
	minor_announce("A notice to all L-Corp clientele, we have the saddening news that this facility is in need of cleanup due to a breach of contract, remain seated as W-Corp Staff resolve the issue.", "W Corp HQ Update:", TRUE)
	..()

//Teleporters
/datum/data/lc13research/teleporter
	research_name = "Prototype Quantum Pads"
	research_desc = "Our cleanup crew found one half of these pads and a <br>instruction manual in one of our trains. Our researchers managed to reverse engineer <br>a replica with a copy of the book. We would like you to test <br>these pads in the facility your currently working in and <br>report back if its function threatens our buisness."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/teleporter/ResearchEffect(obj/structure/representative_console/caller)
	var/place_to_place = get_turf(caller)
	//two keycards for both quantum pads.
	new /obj/item/quantum_keycard(place_to_place)
	new /obj/item/quantum_keycard(place_to_place)
	//a outdated guide
	new /obj/item/paper/guides/quantumpad(place_to_place)
	//and a box with 2 quantum pads
	new /obj/item/package_quantumpad(place_to_place)
	..()

/datum/data/lc13research/teleporter/setb
	research_name = "Prototype Quantum Pads II"
	research_desc = "We've decided to ship out more of those Quantum Pads. You can have this set for the same price."
	required_research = /datum/data/lc13research/teleporter


//Keys
/datum/data/lc13research/qkeys
	research_name = "Repurchasable: Quantum Pad Keys (x2)"
	research_desc = "A pair of Quantum Pad Keys for you to ship out to whoever. We have extras."
	cost = 3
	corp = W_CORP_REP

/datum/data/lc13research/qkeys/ResearchEffect(obj/structure/representative_console/caller)
	var/place_to_place = get_turf(caller)
	new /obj/item/quantum_keycard(place_to_place)
	new /obj/item/quantum_keycard(place_to_place)


//Fast Tiles
/datum/data/lc13research/fasttiles
	research_name = "Repurchasable: W-Corp High-Traction Tiles (x100)"
	research_desc = "These have been rotting in our warehouse the last couple years. <br>Running on these should make you slightly faster, but we have no use for them."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/fasttiles/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/stack/tile/noslip/fifty(get_turf(caller))
	new /obj/item/stack/tile/noslip/fifty(get_turf(caller))

/obj/item/stack/tile/noslip/fifty
	amount = 50


/datum/data/lc13research/bluespace
	research_name = "Repurchasable: W-Corp Quick Tiles (30x)"
	research_desc = "These have been rotting in our warehouse the last couple years. <br>Running on these should make you faster, but we have no use for them."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/bluespace/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/stack/tile/bluespace/thirty(get_turf(caller))

/obj/item/stack/tile/bluespace/thirty
	amount = 30
