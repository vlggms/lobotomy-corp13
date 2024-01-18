//-----R_CORP-----
//R-Corp has mostly ERTs, deals in cheap weapons too.
// Weapon Platforms
/datum/data/lc13research/redweapon
	research_name = "Red Weaponry"
	research_desc = "We have a few new weapon designs drawn up using the RED bullets L-Corp is giving us. However we need more funding to kickstart the project, mind handing some over? I'm sure they won't mind."
	cost = LOW_RESEARCH_PRICE
	corp = R_CORP_REP

/datum/data/lc13research/redweapon/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "R Corp X-15 Minigun ",	/obj/item/gun/energy/e_gun/rabbit/minigun, 600)
	ItemUnlock(caller.order_list, "R Corp X-12 Sniper ",	/obj/item/gun/energy/e_gun/rabbitdash/sniper, 600)
	ItemUnlock(caller.order_list, "R Corp X-13 Beam ",		/obj/item/gun/energy/e_gun/rabbitdash/laser, 600)
	ItemUnlock(caller.order_list, "R Corp X-9 Heavy",	/obj/item/gun/energy/e_gun/rabbitdash/heavy, 700)
	ItemUnlock(caller.order_list, "R Corp Model 2200",		/obj/item/gun/energy/e_gun/rabbitdash/small, 600)
	ItemUnlock(caller.order_list, "R Corp Model 2300",		/obj/item/gun/energy/e_gun/rabbitdash/shotgun, 600)
	..()

/datum/data/lc13research/singlephase
	research_name = "Single Phase Weaponry"
	research_desc = "The success of the our new weapons got more attention of L-Corp over here, they want us to use more than just RED bullets this time. Thing is we're out of energy to spare, send us some more will you?"
	cost = LOW_RESEARCH_PRICE
	corp = R_CORP_REP
	required_research = /datum/data/lc13research/redweapon

/datum/data/lc13research/singlephase/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "R Corp Model 2100 White",	/obj/item/gun/energy/e_gun/rabbitdash/white, 700)
	ItemUnlock(caller.order_list, "R Corp Model 2400 Black",		/obj/item/gun/energy/e_gun/rabbitdash/black, 700)
	ItemUnlock(caller.order_list, "R Corp Model 2900 Blue",		/obj/item/gun/energy/e_gun/rabbitdash/pale, 700)
	..()

/datum/data/lc13research/multiphase
	research_name = "Multiphase Weaponry"
	research_desc = "L-Corp's sent us the blueprints for their bullets, and HQ wants it all in one package. The designs are drawn up but the energy requirement is massive for this project. We're going to need much more this time.."
	cost = AVERAGE_RESEARCH_PRICE
	corp = R_CORP_REP
	required_research = /datum/data/lc13research/singlephase

/datum/data/lc13research/multiphase/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "R Corp Model 2800",	/obj/item/gun/energy/e_gun/rabbit/nopin, 800)
	ItemUnlock(caller.order_list, "R Corp 3500 Minigun",	/obj/item/gun/energy/e_gun/rabbit/minigun/tricolor, 800)
	ItemUnlock(caller.order_list, "R Corp High Frequency Combat Blade",	/obj/item/ego_weapon/city/rabbit_blade, 800)
	..()

/datum/data/lc13research/experimental
	research_name = "Experimental Weaponry"
	research_desc = "The energy we've recived has gotten our top scientists thinking and made some very ambitious plans. Send us some more energy and we can make their plans a reality for both us, and you."
	cost = AVERAGE_RESEARCH_PRICE
	corp = R_CORP_REP
	required_research = /datum/data/lc13research/singlephase

/datum/data/lc13research/experimental/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "R Corp Rush Blade",	/obj/item/ego_weapon/city/rabbit_rush, 900)
	ItemUnlock(caller.order_list, "R Corp Reindeer Staff",	/obj/item/ego_weapon/city/reindeer, 900)
	..()

// ERTs
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
	required_research = /datum/data/lc13research/mobspawner/rabbit

/datum/data/lc13research/mobspawner/rabbit/kill/ResearchEffect(obj/structure/representative_console/caller)
	minor_announce("Attention. Unauthorized use of R Corp Equipment. Rabbit kill team authorize and enroute.", "R Corp HQ Update:", TRUE)
	..()
