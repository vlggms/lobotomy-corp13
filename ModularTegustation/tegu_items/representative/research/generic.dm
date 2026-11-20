//-----GENERAL-----

/datum/data/lc13research/ratknife
	research_name = "Rat Equipment Stock"
	research_desc = "Contribute some energy to request the clerks in charge of stocking <br>our equipment to buy a crate of knives."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH

/datum/data/lc13research/ratknife/ResearchEffect(obj/structure/representative_console/requester)
	ItemUnlock(requester.order_list, "Rat Knife",	/obj/item/ego_weapon/city/rats/knife, 100)
	ItemUnlock(requester.order_list, "Rat Hammer",	/obj/item/ego_weapon/city/rats, 100)
	ItemUnlock(requester.order_list, "Brick",	/obj/item/ego_weapon/city/rats/brick, 100)
	ItemUnlock(requester.order_list, "Metal Pipe",	/obj/item/ego_weapon/city/rats/pipe, 100)
	..()

//-----MOB SPAWNERS-----

/datum/data/lc13research/mobspawner/zwei
	research_name = "Zwei Section 6 Team"
	research_desc = "For a small slice of funds we can hire the local zwei to assist us."
	cost = AVERAGE_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/zwei_call
