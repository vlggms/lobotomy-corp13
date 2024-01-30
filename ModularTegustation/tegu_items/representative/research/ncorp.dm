//-----N_CORP-----
//N Corp sells exp boosters.
///Stat booster line
/datum/data/lc13research/nbuff1
	research_name = "N-Corporation Small Experience Ampules (x3)"
	research_desc = "An order of 3 small experience ampules. <br>We make these dime a dozen so we can ship 3 of them over to Lcorp for cheap."
	cost = LOW_RESEARCH_PRICE
	corp = N_CORP_REP

/datum/data/lc13research/nbuff1/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/attribute_increase/small(get_turf(caller))
	new /obj/item/attribute_increase/small(get_turf(caller))
	new /obj/item/attribute_increase/small(get_turf(caller))
	..()

/datum/data/lc13research/nbuff2
	research_name = "N-Corporation Medium Experience Ampules (x3)"
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
	research_name = "N-Corporation Large Experience Ampules (x3)"
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
	research_name = "N-Corporation Extra Large Experience Ampule"
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
	research_name = "N-Corporation Limit Breaker Ampule I"
	research_desc = "An order of an ampule to let you increase your maximum stats. <br>These ones are hot off the presses, and don't come cheap."
	cost = HIGH_RESEARCH_PRICE
	corp = N_CORP_REP

/datum/data/lc13research/nlimit1/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/limit_increase(get_turf(caller))
	..()

/datum/data/lc13research/nlimit2
	research_name = "N-Corporation Limit Breaker Ampule II"
	research_desc = "An order of an ampule to let you increase your maximum stats. <br>These ones are hot off the presses, and don't come cheap."
	cost = HIGH_RESEARCH_PRICE
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/nlimit1

/datum/data/lc13research/nlimit2/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/limit_increase(get_turf(caller))
	..()

//Temporary line
/datum/data/lc13research/ntemp1
	research_name = "N-Corporation Temporary Experience Ampules"
	research_desc = "A permit to sell temporarily stat increasing experience ampules. <br>Through a bit of experimentation we have found out to repeatedly extract segmented experience from prisioners for mass production, <br>however the repeated draining of their experiences causes these memories to become fragile and fade. <br>I'm sure however you can still easily market these for some profit."
	cost = AVERAGE_RESEARCH_PRICE
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/nbuff1

/datum/data/lc13research/ntemp1/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Fading Fortitude Ampule",	/obj/item/attribute_temporary/fortitudesmall, 500)
	ItemUnlock(caller.order_list, "Fading Temperance Ampule",	/obj/item/attribute_temporary/temperancesmall, 500)
	ItemUnlock(caller.order_list, "Fading Prudence Ampule",	/obj/item/attribute_temporary/prudencesmall, 500)
	ItemUnlock(caller.order_list, "Fading Justice Ampule",	/obj/item/attribute_temporary/justicesmall, 500)
	..()

/datum/data/lc13research/ntemp2
	research_name = "N-Corporation Strengthened Temporary Experience Ampules"
	research_desc = "A permit to sell more potent temporary stat increasing experience ampules. <br>Through trial and error we have managed to increase the amount of experience that can be repeatedly gathered from a individual at the cost of heightened fading, <br>though it's duration is ineffective for long-term use it can be efficiently deployed in emergencies. I believe you already know the drill, <br>I'm sure these ones will sell far better than our previous ampules."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/ntemp1

/datum/data/lc13research/ntemp2/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Fading Attribute Ampule",	/obj/item/attribute_temporary/stattemporary, 1000)
	..()

/datum/data/lc13research/ntemp3
	research_name = "N-Corporation Focused Temporary Experience Ampules"
	research_desc = "A permit to sell focused temporary stat increasing experience ampules. <br>While losing a few impure guinea pigs in the attempt to make it we have finally suceeded, <br>this ampule is the pinnacle of our research, capable of being infinitely produced out of repeated draining at 33% higher efficiency, <br>learning from the failure of past fading ampules however this one will not grant experience in more than one area to avoid rapid fading. I'm sure you can put the remains of that mechanical filth to good use."
	cost = HIGH_RESEARCH_PRICE
	corp = N_CORP_REP
	required_research = /datum/data/lc13research/ntemp2

/datum/data/lc13research/ntemp1/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Focused Fading Fortitude Ampule",	/obj/item/attribute_temporary/fortitudebig, 1500)
	ItemUnlock(caller.order_list, "Focused Fading Temperance Ampule",	/obj/item/attribute_temporary/temperancebig, 1500)
	ItemUnlock(caller.order_list, "Focused Fading Prudence Ampule",	/obj/item/attribute_temporary/prudencebig, 1500)
	ItemUnlock(caller.order_list, "Focused Fading Justice Ampule",	/obj/item/attribute_temporary/justicebig, 1500)
	..()


