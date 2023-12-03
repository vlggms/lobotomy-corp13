//-----L_CORP-----
//L Corp generally makes your life a lot easier with L-Corp related things.

//Roll stuff
/datum/data/lc13research/reroll
	research_name = "Reroll Abno Choices "
	research_desc = "You can PROBABLY convince HQ Extraction to give you another set of 3 abnos, as you're pretty tight with Big B. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/reroll/ResearchEffect(obj/structure/representative_console/caller)
	SSabnormality_queue.postspawn()
	minor_announce("Extraction has given you another choice of 3 abnos", "Extraction Alert:", TRUE)
	..()

/datum/data/lc13research/redroll
	research_name = "Enable Red Roll "
	research_desc = "HQ Extraction trusts your judgement to let the manager press the big red button. <br>Everyone involved knows that this is a bad idea "
	cost = LOW_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/redroll/ResearchEffect(obj/structure/representative_console/caller)
	SSabnormality_queue.hardcore_roll_enabled = TRUE
	minor_announce("Extraction has given you access to red rolls.", "Extraction Alert:", TRUE)
	..()

//RAKS overcharge
/datum/data/lc13research/regenerator_overcharge
	research_name = "Repeatable: RAK the Regenerator System "
	research_desc = "The security department blueprints say that all the regenerators <br>healing systems are connected at a junction point. <br>A department clerk offers to take the 10 second trip to the junction <br>and overcharge the whole system at the cost of some refined PE."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/regenerator_overcharge/ResearchEffect(obj/structure/representative_console/caller)
	if(repeat_cooldown > world.time)
		return
	for(var/obj/machinery/regenerator/R in GLOB.regenerators)
		R.burst = TRUE
	caller.visible_message(span_notice("The [caller] rumbles for a moment soon after your message is delivered."))
	repeat_cooldown = world.time + (10 SECONDS)


//PE quota Stuff
/datum/data/lc13research/pe_quota1
	research_name = "Alter Facility PE Quota I "
	research_desc = "You think you may be able to remove 1000 PE from the PE quota <br>at the cost of some raw PE. <br>Hopefully the sephirah overlook your tampering with the L corp delivery systems."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/pe_quota1/ResearchEffect(obj/structure/representative_console/caller)
	SSlobotomy_corp.box_goal -= 1000
	SSlobotomy_corp.AdjustGoalBoxes(0)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()

/datum/data/lc13research/pe_quota2
	research_name = "Alter Facility PE Quota II "
	research_desc = "You think you may be able to remove a further 1000 PE from the PE quota <br>at the cost of some raw PE. <br>This will however forfeit your bonus at the end of the shift."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/pe_quota1

/datum/data/lc13research/pe_quota2/ResearchEffect(obj/structure/representative_console/caller)
	SSlobotomy_corp.box_goal -= 1000
	SSlobotomy_corp.AdjustGoalBoxes(0)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()

/datum/data/lc13research/pe_quota3
	research_name = "Alter Facility PE Quota III "
	research_desc = "You think you may be able to remove a further 1000 PE from the PE quota <br>at the cost of some raw PE. <br>The manager will be contacted about this, but you think you can weasel them out of <br>any issues with the district manager."
	cost = AVERAGE_RESEARCH_PRICE+10
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/pe_quota2

/datum/data/lc13research/pe_quota3/ResearchEffect(obj/structure/representative_console/caller)
	SSlobotomy_corp.box_goal -= 1000
	SSlobotomy_corp.AdjustGoalBoxes(0)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()


//Limit Breaker
/datum/data/lc13research/Lcorplimitbreaker
	research_name = "Limit Breaker Injector"
	research_desc = "An order of an ampule to let you increase your maximum stats. <br>We make them in house, but shipping them from district 12 is a pain"
	cost = HIGH_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/Lcorplimitbreaker/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/limit_increase/lcorp(get_turf(caller))
	..()


//Officer Limit Breaker
/datum/data/lc13research/officerlimitbreaker
	research_name = "Officer Limit Breaker Injector"
	research_desc = "An order of an ampule to let you increase your maximum stats. <br>These ones are made for Records and Extraction Officers "
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/officerlimitbreaker/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/limit_increase/officer(get_turf(caller))
	..()


/datum/data/lc13research/understandingmachine
	research_name = "Abnormality Scanner"
	research_desc = "A machine that can be used to understand abnormalities. It does take a second. <br>These ones are made for Records and Extraction Officers "
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/understandingmachine/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/understandingbooster(get_turf(caller))
	..()
