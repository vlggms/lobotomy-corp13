//-----J_CORP-----
//J Corp mostly impacts RNG. It also has some other things related to J corp casinos.

GLOBAL_LIST_EMPTY(jcorp_upgrades)

///Gacha

/datum/data/lc13research/gacha_chance
	research_name = "Crate Rarity Upgrade"
	research_desc = "With some power, we can provide the facility with a slightly better chance to get rarer products from places they sell to."
	cost = LOW_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/gacha_chance/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 1"

/datum/data/lc13research/gacha_chance2
	research_name = "Crate Rarity Upgrade II"
	research_desc = "With some power, we can provide the facility with better chances to get rarer products from places they sell to."
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance

/datum/data/lc13research/gacha_chance2/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 2"

/datum/data/lc13research/gacha_chance3
	research_name = "Crate Rarity Upgrade III"
	research_desc = "With some more power, we can provide the facility with an even better chances to get rarer products from places they sell to."
	cost = HIGH_RESEARCH_PRICE-10
	corp = J_CORP_REP
	required_research = /datum/data/lc13research/gacha_chance2

/datum/data/lc13research/gacha_chance3/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	GLOB.jcorp_upgrades += "Gacha Chance 3"

/datum/data/lc13research/gacha_chance4
	research_name = "Crate Rarity Upgrade IV"
	research_desc = "With some power, we can provide the facility with a final upgrade for better chances to get rarer products from places they sell to. The Disciplinary and Extraction Officer will likely love you with this research."
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

//Casino Machines

/datum/data/lc13research/casino_machine
	research_name = "J Corp Casino Machine"
	research_desc = "If the agents want to bring gambling to their facility, we got a spare casino machine to offer."
	cost = LOW_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/casino_machine/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	new /obj/machinery/jcorp_slot_machine(get_turf(requester))
	requester.visible_message(span_notice("The [requester] lights up as it teleports in the Casino Machine."))

/datum/data/lc13research/blood_machine
	research_name = "J Corp Lifeforce Slots"
	research_desc = "Some people are so addicted to gambling, they have admitted to be willing to sacrifice blood for gambling! So here are two devices in exchange for PE!"
	cost = LOW_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/blood_machine/ResearchEffect(obj/structure/representative_console/requester)
	. = ..()
	new /obj/item/blood_slots(get_turf(requester))
	new /obj/item/blood_slots(get_turf(requester))
	requester.visible_message(span_notice("The [requester] lights up as it teleports in two odd devices."))

//ERTs
/*
/datum/data/lc13research/mobspawner/casino_slaves
	research_name = "Casino Slaves"
	research_desc = "We can pay some local casinos to send over some of the slaves they have to help the facility. The casinos could care less of what happens to the slaves, as long as the casinos get back their pickaxes."
	cost = LOW_RESEARCH_PRICE
	corp = J_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/jcorp_call/casino_slaves

/datum/data/lc13research/mobspawner/casino_security
	research_name = "Casino Security"
	research_desc = "We can pay some local casinos to send some of their security to help with combat. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/jcorp_call/casino_security
	required_research = /datum/data/lc13research/mobspawner/casino_slaves

/datum/data/lc13research/mobspawner/casino_killteam
	research_name = "Casino Reaquisition Team"
	research_desc = "The local casino owners will be PISSED if Lcorp stole security gear or the slave pickaxes. The deal we made with the casinos was that this team would be used if such were to occur."
	cost = 0
	corp = J_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/jcorp_call/casino_security/killteam
	required_research = /datum/data/lc13research/mobspawner/casino_slaves
*/
/*
// Critical Hits (Untested! Don't add till Critical Hits PR is merged)
/datum/data/lc13research/crit_hits
	research_name = "Enable Critical Hits"
	research_desc = "This upgrade should allow your singularity to impact L Corp's weapons to occasionally land stronger hits!"
	cost = AVERAGE_RESEARCH_PRICE
	corp = J_CORP_REP

/datum/data/lc13research/crit_sticker/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/clothing/mask/crit_sticker(get_turf(requester))
	..()
*/
