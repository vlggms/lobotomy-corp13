//-----R_CORP-----
//R-Corp has only ERTs, and a lot of them.

/datum/data/lc13research/mobspawner/rabbit
	research_name = "4th Pack Rabbit Team"
	research_desc = "Our contract with L corp garentees at least one rabbit call <br>per day in exchange for energy. We can abuse a loophole in the contract <br>and list you as the client if you remain descreet."
	cost = AVERAGE_RESEARCH_PRICE
	corp = R_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/rabbit_call

/datum/data/lc13research/mobspawner/raven
	research_name = "4th Pack Raven Team"
	research_desc = "We need data on how our ravens preform in confined hallways. <br>Same conditions of the last deal apply."
	cost = AVERAGE_RESEARCH_PRICE + 5
	corp = R_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/raven_call
	required_research = /datum/data/lc13research/mobspawner/rabbit

/datum/data/lc13research/mobspawner/rhino
	research_name = "4th Pack Triple Rhinos"
	research_desc = "Three rhinos in the barracks are getting restless. We can <br>send them to you if you take responsibility for any damages they cause."
	cost = HIGH_RESEARCH_PRICE
	corp = R_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/rhino_call
	required_research = /datum/data/lc13research/mobspawner/raven

//This one is free as a kill team
/datum/data/lc13research/mobspawner/rabbit/kill
	research_name = "Rabbit Kill Team"
	research_desc = "This summons your personal Rabbit team to kill all LCorp agents. <br>Use this in case of LCorp stealing our equipment for their own use. <br>Do check that they are not selling power in exchange for our gear first, however."
	cost = 0
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/rabbit_call/kill

/datum/data/lc13research/mobspawner/rabbit/kill/ResearchEffect(obj/structure/representative_console/caller)
	minor_announce("Attention. Unauthorized use of R Corp Equipment. Rabbit kill team authorize and enroute.", "R Corp HQ Update:", TRUE)
	..()
