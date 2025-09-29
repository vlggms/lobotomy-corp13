//-----L_CORP-----
//L Corp generally makes your life a lot easier with L-Corp related things.
GLOBAL_LIST_EMPTY(lcorp_upgrades)

//Roll stuff
/datum/data/lc13research/reroll
	research_name = "Reroll Abno Choices"
	research_desc = "You can PROBABLY convince HQ Extraction to give you another set of 3 abnos, as you're pretty tight with Big B. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/reroll/ResearchEffect(obj/structure/representative_console/requester)
	SSabnormality_queue.next_abno_spawn = world.time + SSabnormality_queue.next_abno_spawn_time + ((min(16, SSabnormality_queue.spawned_abnos) - 6) * 6) SECONDS
	SSabnormality_queue.PickAbno()
	minor_announce("Extraction has given you another choice of [GetFacilityUpgradeValue(UPGRADE_ABNO_QUEUE_COUNT)] abnormalities.", "Extraction Alert:", TRUE)
	..()

/datum/data/lc13research/redroll
	research_name = "Enable Red Roll"
	research_desc = "HQ Extraction trusts your judgement to let the manager press the big red button. <br>Everyone involved knows that this is a bad idea "
	cost = LOW_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/redroll/ResearchEffect(obj/structure/representative_console/requester)
	SSabnormality_queue.hardcore_roll_enabled = TRUE
	minor_announce("Extraction has given you access to red rolls.", "Extraction Alert:", TRUE)
	..()

//RAKS overcharge
/datum/data/lc13research/regenerator_overcharge
	research_name = "Repeatable: RAK the Regenerator System"
	research_desc = "The security department blueprints say that all the regenerators <br>healing systems are connected at a junction point. <br>A department clerk offers to take the 10 second trip to the junction <br>and overcharge the whole system at the cost of some refined PE."
	cost = 2
	corp = L_CORP_REP

/datum/data/lc13research/regenerator_overcharge/ResearchEffect(obj/structure/representative_console/requester)
	if(repeat_cooldown > world.time)
		return
	for(var/obj/machinery/regenerator/R in GLOB.lobotomy_devices)
		R.burst = TRUE
	requester.visible_message(span_notice("The [requester] rumbles for a moment soon after your message is delivered."))
	repeat_cooldown = world.time + (10 SECONDS)


//PE quota Stuff
/datum/data/lc13research/pe_quota1
	research_name = "Alter Facility PE Quota I"
	research_desc = "You think you may be able to remove 1000 PE from the PE quota <br>at the cost of some raw PE. <br>Hopefully the sephirah overlook your tampering with the L corp delivery systems."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/pe_quota1/ResearchEffect(obj/structure/representative_console/requester)
	SSlobotomy_corp.box_goal -= 1000
	SSlobotomy_corp.AdjustGoalBoxes(0)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()

/datum/data/lc13research/pe_quota2
	research_name = "Alter Facility PE Quota II"
	research_desc = "You think you may be able to remove a further 1000 PE from the PE quota <br>at the cost of some raw PE. <br>This will however forfeit your bonus at the end of the shift."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/pe_quota1

/datum/data/lc13research/pe_quota2/ResearchEffect(obj/structure/representative_console/requester)
	SSlobotomy_corp.box_goal -= 1000
	SSlobotomy_corp.AdjustGoalBoxes(0)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()

/datum/data/lc13research/pe_quota3
	research_name = "Alter Facility PE Quota III"
	research_desc = "You think you may be able to remove a further 1000 PE from the PE quota <br>at the cost of some raw PE. <br>The manager will be contacted about this, but you think you can weasel them out of <br>any issues with the district manager."
	cost = AVERAGE_RESEARCH_PRICE+10
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/pe_quota2

/datum/data/lc13research/pe_quota3/ResearchEffect(obj/structure/representative_console/requester)
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

/datum/data/lc13research/Lcorplimitbreaker/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/limit_increase/lcorp(get_turf(requester))
	..()


//Officer Limit Breaker
/datum/data/lc13research/officerlimitbreaker
	research_name = "Officer Limit Breaker Injector"
	research_desc = "An order of an ampule to let you increase your maximum stats. <br>These ones are made for Training, Disciplinary, Records and Extraction Officers "
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/officerlimitbreaker/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/limit_increase/officer(get_turf(requester))
	..()


/datum/data/lc13research/understandingmachine
	research_name = "Abnormality Scanner"
	research_desc = "A machine that can be used to understand abnormalities. It does take a second. <br>These ones are made for Training, Disciplinary, Records and Extraction Officers "
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/understandingmachine/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/understandingbooster(get_turf(requester))
	..()

//Level 2 Clerks
/datum/data/lc13research/clerkbuff
	research_name = "Clerk Advanced Training"
	research_desc = "An authorization to train clerks better. <br>This should bring them up to around a level 2 agent."
	cost = HIGH_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/clerkbuff/ResearchEffect(obj/structure/representative_console/requester)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H?.mind?.assigned_role in GLOB.service_positions)
			H.set_attribute_limit(40)
			H.adjust_all_attribute_levels(40)

	GLOB.lcorp_upgrades += "Clerk Buff"
	..()

//Agent Workchange injector
/datum/data/lc13research/agentworkchance
	research_name = "Global Agent Workchance"
	research_desc = "An authorization to allow all agents to see work chances. <br>We have this feature off to save money."
	cost = HIGH_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/agentworkchance/ResearchEffect(obj/structure/representative_console/requester)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		ADD_TRAIT(H, TRAIT_WORK_KNOWLEDGE, JOB_TRAIT)

	GLOB.lcorp_upgrades += "Agent Workchance"
	..()

//EGO Gift Extractor
/datum/data/lc13research/ego_gift_extractor
	research_name = "Repeatable: EGO Gift Extractor"
	research_desc = "An order of an EGO Gift Extractor. "
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = L_CORP_REP

/datum/data/lc13research/ego_gift_extractor/ResearchEffect(obj/structure/representative_console/requester)
	if(repeat_cooldown > world.time)
		return
	new /obj/item/ego_gift_extractor(get_turf(requester))
	requester.visible_message(span_notice("The [requester] lights up as it teleports in the Extractor."))
	repeat_cooldown = world.time + (10 SECONDS)

//Refinery Upgrades
/datum/data/lc13research/refineryspeed/lvl3
	research_name = "Refinement Process Efficiency Upgrade III"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = LOW_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/refineryspeed/lvl2

/datum/data/lc13research/refineryspeed/lvl4
	research_name = "Refinement Process Efficiency Upgrade IV"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = LOW_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/refineryspeed/lvl3

/datum/data/lc13research/refineryspeed/lvl5
	research_name = "Refinement Process Efficiency Upgrade V"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/refineryspeed/lvl4

/datum/data/lc13research/refineryspeed/lvl6
	research_name = "Refinement Process Efficiency Upgrade VI"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/refineryspeed/lvl5

/datum/data/lc13research/refineryspeed/lvl7
	research_name = "Refinement Process Efficiency Upgrade VII"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/refineryspeed/lvl6

/datum/data/lc13research/refineryspeed/lvl8
	research_name = "Refinement Process Efficiency Upgrade VIII"
	research_desc = "Contribute some energy to improve the Refinery's processing speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/refineryspeed/lvl7

//Sales Upgrades
/datum/data/lc13research/salesspeed/lvl3
	research_name = "Sales Process Efficiency Upgrade III"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = LOW_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/salesspeed/lvl2

/datum/data/lc13research/salesspeed/lvl4
	research_name = "Sales Process Efficiency Upgrade IV"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = LOW_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/salesspeed/lvl3

/datum/data/lc13research/salesspeed/lvl5
	research_name = "Sales Process Efficiency Upgrade V"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/salesspeed/lvl4

/datum/data/lc13research/salesspeed/lvl6
	research_name = "Sales Process Efficiency Upgrade VI"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/salesspeed/lvl5

/datum/data/lc13research/salesspeed/lvl7
	research_name = "Sales Process Efficiency Upgrade VII"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/salesspeed/lvl6

/datum/data/lc13research/salesspeed/lvl8
	research_name = "Sales Process Efficiency Upgrade VIII"
	research_desc = "Contribute some energy to improve the sales machines' transfer speed."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/salesspeed/lvl7

//LOB points
/datum/data/lc13research/lob/lvl1
	research_name = "LOB points grant"
	research_desc = "HQ is allowing you more LOB points budget in exchange for PE."
	cost = HIGH_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/lob/lvl1/ResearchEffect(obj/structure/representative_console/requester)
	minor_announce("HQ has improved your LOB points budget.", "HQ Alert:", TRUE)
	for(var/obj/machinery/computer/abnormality_auxiliary/A in GLOB.lobotomy_devices)
		SSlobotomy_corp.lob_points +=2
		A.audible_message(span_notice("2 LOB points deposited! Reason: Improved budget from HQ."))
		playsound(get_turf(A), 'sound/machines/twobeep_high.ogg', 20, TRUE)
		A.updateUsrDialog()
	..()

/datum/data/lc13research/lob/lvl2
	research_name = "LOB points grant"
	research_desc = "HQ is impressed by your production and is allowing you even more LOB points budget in exchange for PE."
	cost = HIGH_RESEARCH_PRICE+25
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/lob/lvl1

/datum/data/lc13research/lob/lvl2/ResearchEffect(obj/structure/representative_console/requester)
	minor_announce("HQ has further improved your LOB points budget.", "HQ Alert:", TRUE)
	for(var/obj/machinery/computer/abnormality_auxiliary/A in GLOB.lobotomy_devices)
		SSlobotomy_corp.lob_points +=2
		A.audible_message(span_notice("2 LOB points deposited! Reason: Improved budget from HQ."))
		playsound(get_turf(A), 'sound/machines/twobeep_high.ogg', 20, TRUE)
		A.updateUsrDialog()
	..()
