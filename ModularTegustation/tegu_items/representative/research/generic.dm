//-----GENERAL-----

/datum/data/lc13research/ratknife
	research_name = "Rat Equipment Stock"
	research_desc = "Contribute some energy to request the clerks in charge of stocking <br>our equipment to buy a crate of knives."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH

/datum/data/lc13research/ratknife/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Rat Knife",	/obj/item/ego_weapon/city/rats/knife, 100)
	ItemUnlock(caller.order_list, "Rat Hammer",	/obj/item/ego_weapon/city/rats, 100)
	ItemUnlock(caller.order_list, "Brick",	/obj/item/ego_weapon/city/rats/brick, 100)
	ItemUnlock(caller.order_list, "Metal Pipe",	/obj/item/ego_weapon/city/rats/pipe, 100)
	..()

/datum/data/lc13research/refineryspeed
	research_name = "Refinement Process Efficiency Upgrade I"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH

/datum/data/lc13research/refineryspeed/ResearchEffect(obj/structure/representative_console/caller)
	. = ..()
	for(var/obj/structure/refinery/ref in GLOB.lobotomy_devices)
		ref.refine_timer -= initial(ref.refine_timer)/10

/datum/data/lc13research/refineryspeed/lvl2
	research_name = "Refinement Process Efficiency Upgrade II"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH
	required_research = /datum/data/lc13research/refineryspeed

/datum/data/lc13research/salesspeed
	research_name = "Sales Process Efficiency Upgrade I"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH

/datum/data/lc13research/salesspeed/ResearchEffect(obj/structure/representative_console/caller)
	. = ..()
	for(var/obj/structure/pe_sales/sales in GLOB.lobotomy_devices)
		sales.power_timer -= initial(sales.power_timer)/10
		sales.crate_timer -= (initial(sales.power_timer)/10)*sales.crates_per_box

/datum/data/lc13research/salesspeed/lvl2
	research_name = "Sales Process Efficiency Upgrade II"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH
	required_research = /datum/data/lc13research/salesspeed

/// MOB SPAWNERS

/datum/data/lc13research/mobspawner/zwei
	research_name = "Zwei Section 6 Team"
	research_desc = "For a small slice of funds we can hire the local zwei to assist us."
	cost = AVERAGE_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/zwei_call
