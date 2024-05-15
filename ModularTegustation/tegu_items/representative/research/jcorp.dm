//-----J_CORP-----
//J Corp mostly impacts RNG.

GLOBAL_LIST_EMPTY(jcorp_upgrades)

///Gacha

/datum/data/lc13research/gacha_chance
	research_name = "Outlet Rarity Upgrade"
	research_desc = "With some power, we can provide the facility with a slightly better chance to get rarer products from places they sell to."
	cost = LOW_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/gacha_chance/ResearchEffect(obj/structure/representative_console/caller)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 1"

/datum/data/lc13research/gacha_chance2
	research_name = "Outlet Rarity Upgrade II"
	research_desc = "With some power, we can provide the facility with better chances to get rarer products from places they sell to."
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance

/datum/data/lc13research/gacha_chance2/ResearchEffect(obj/structure/representative_console/caller)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 2"

/datum/data/lc13research/gacha_chance3
	research_name = "Outlet Rarity Upgrade III"
	research_desc = "With some more power, we can provide the facility with an even better chances to get rarer products from places they sell to."
	cost = HIGH_RESEARCH_PRICE-5
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance2

/datum/data/lc13research/gacha_chance3/ResearchEffect(obj/structure/representative_console/caller)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 3"

/datum/data/lc13research/gacha_chance4
	research_name = "Outlet Rarity Upgrade IV"
	research_desc = "With some power, we can provide the facility with a final upgrade for better chances to get rarer products from places they sell to. The Suppression Agents and Extraction Officer will likely love you with this research."
	cost = HIGH_RESEARCH_PRICE+5
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance3

/datum/data/lc13research/gacha_chance4/ResearchEffect(obj/structure/representative_console/caller)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 4"

/datum/data/lc13research/well_gacha
	research_name = "Wishing Well Output Rates"
	research_desc = "According to some information L corp has told us, this well seems to rely tends to be unpredictable, and open to chance, so we can lock some of the bad outcomes from occuring as often."
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/well_gacha/ResearchEffect(obj/structure/representative_console/caller)
	. = ..()
	GLOB.jcorp_upgrades += "Well Gacha"
