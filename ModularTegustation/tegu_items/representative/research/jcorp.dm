//-----J_CORP-----
//J Corp mostly impacts RNG.

GLOBAL_LIST_EMPTY(jcorp_upgrades)

///Gacha

/datum/data/lc13research/gacha_chance
	research_name = "Outlet Rarity Upgrade"
	research_desc = "With some power, we can provide the facility with a slightly better chance to get rarer products from places they sell to."
	cost = LOW_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/gacha_chance/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 1"

/datum/data/lc13research/gacha_chance2
	research_name = "Outlet Rarity Upgrade II"
	research_desc = "With some power, we can provide the facility with better chances to get rarer products from places they sell to."
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance

/datum/data/lc13research/gacha_chance2/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 2"

/datum/data/lc13research/gacha_chance3
	research_name = "Outlet Rarity Upgrade III"
	research_desc = "With some more power, we can provide the facility with an even better chances to get rarer products from places they sell to."
	cost = HIGH_RESEARCH_PRICE-10
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance2

/datum/data/lc13research/gacha_chance3/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 3"

/datum/data/lc13research/gacha_chance4
	research_name = "Outlet Rarity Upgrade IV"
	research_desc = "With some power, we can provide the facility with a final upgrade for better chances to get rarer products from places they sell to. The Suppression Agents and Extraction Officer will likely love you with this research."
	cost = HIGH_RESEARCH_PRICE
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance3

/datum/data/lc13research/gacha_chance4/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 4"

//Abnormality Mechanic Luck

/datum/data/lc13research/abno_mechanic_luck
	research_name = "Contained Abnormality Luck Upgrade"
	research_desc = "L Corp has asked us about possibly helping agents get a better chance with some abnormalities, from not getting spiked drinks, to games or Russian Roulette. With some PE, we can make their requests possible."
	cost = LOW_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/abno_mechanic_luck/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Abno Luck"

/datum/data/lc13research/tool_abno_gacha
	research_name = "Tool Abnormality Luck Upgrade"
	research_desc = "According to some information L corp has told us, some of their 'Tool Abnormalities' tends to be unpredictable, and open to chance, so we can lock some of the bad outcomes from occuring as often."
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/tool_abno_gacha/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Tool Gacha"

//Lootboxes

/datum/data/lc13research/lootbox
	research_name = "Repeatable: J Corp Brand Lootboxes"
	research_desc = "Hey, it's Tom from Marketing. We have been thinking of a new way to try to encourage people to gamble, and we heard some people won't resist a shiny box that can contain something neat. We will send you two boxes if you provide the energy."
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/lootbox/ResearchEffect(obj/structure/representative_console/requester)
	if(repeat_cooldown > world.time)
		return
	new /obj/item/a_gift/jcorp(get_turf(requester))
	new /obj/item/a_gift/jcorp(get_turf(requester))
	requester.visible_message(span_notice("The [requester] lights up as it teleports in the Lootboxes."))
	repeat_cooldown = world.time + (10 SECONDS)

// Critical Hits (Untested! Don't add till Critical Hits PR is merged)
///datum/data/lc13research/crit_sticker
//	research_name = "Critical Hit Sticker"
//	research_desc = "These stickers contain locks which should be able to lock away the doubt or second thoughts out of a person's mind midcombat, to make them take the best opprotunites and locations to hit."
//	cost = AVERAGE_RESEARCH_PRICE
//	corp = J_CORP_REP

// /datum/data/lc13research/crit_sticker/ResearchEffect(obj/structure/representative_console/requester)
//	new /obj/item/clothing/mask/crit_sticker(get_turf(requester))
//	..()
