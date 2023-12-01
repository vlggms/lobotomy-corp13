//-----N_CORP-----
//N Corp sells exp boosters.
///Stat booster line
/datum/data/lc13research/nbuff1
	research_name = "N-Corporation Small Experience Ampules (x3) "
	research_desc = "An order of 3 small experience ampules. <br>We make these dime a dozen so we can ship 3 of them over to Lcorp for cheap."
	cost = LOW_RESEARCH_PRICE
	corp = N_CORP_REP

/datum/data/lc13research/nbuff1/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/attribute_increase/small(get_turf(caller))
	new /obj/item/attribute_increase/small(get_turf(caller))
	new /obj/item/attribute_increase/small(get_turf(caller))
	..()

/datum/data/lc13research/nbuff2
	research_name = "N-Corporation Medium Experience Ampules (x3) "
	research_desc = "An order of 3 medium experience ampules. <br>These ones are a little pricy, but we're selling them for a lot so it's all good."
	cost = AVERAGE_RESEARCH_PRICE
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/nbuff1

/datum/data/lc13research/nbuff2/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/attribute_increase/medium(get_turf(caller))
	new /obj/item/attribute_increase/medium(get_turf(caller))
	new /obj/item/attribute_increase/medium(get_turf(caller))
	..()

/datum/data/lc13research/nbuff3
	research_name = "N-Corporation Large Experience Ampules (x3) "
	research_desc = "An order of 3 large experience ampules. <br>These ones were a pain in the ass to get ahold of, to be honest with you. \
			<br> L-Corp is a good partner though, so we can part with these"
	cost = HIGH_RESEARCH_PRICE
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/nbuff2

/datum/data/lc13research/nbuff3/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/attribute_increase/large(get_turf(caller))
	new /obj/item/attribute_increase/large(get_turf(caller))
	new /obj/item/attribute_increase/large(get_turf(caller))
	..()

/datum/data/lc13research/nbuff4
	research_name = "N-Corporation Extra Large Experience Ampule "
	research_desc = "An order of an extra large experience ampule. <br>These ones were a pain in the ass to get ahold of, to be honest with you. \
			<br> L-Corp is a good partner though, so we can part with these"
	cost = MAX_RESEARCH_PRICE
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/nbuff3

/datum/data/lc13research/nbuff4/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/attribute_increase/xtralarge(get_turf(caller))
	..()


//Limit Breaker Line
/datum/data/lc13research/nlimit1
	research_name = "N-Corporation Limit Breaker Ampule I "
	research_desc = "An order of an ampule to let you increase your maximum stats. <br>These ones are hot off the presses, and don't come cheap."
	cost = HIGH_RESEARCH_PRICE
	corp = N_CORP_REP

/datum/data/lc13research/nlimit1/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/limit_increase(get_turf(caller))
	..()

/datum/data/lc13research/nlimit2
	research_name = "N-Corporation Limit Breaker Ampule II "
	research_desc = "An order of an ampule to let you increase your maximum stats. <br>These ones are hot off the presses, and don't come cheap."
	cost = HIGH_RESEARCH_PRICE
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/nlimit1

/datum/data/lc13research/nlimit2/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/limit_increase(get_turf(caller))
	..()


