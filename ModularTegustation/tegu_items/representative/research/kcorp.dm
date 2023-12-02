//-----K_CORP-----
//K Corp sells mostly healing gear.
///Healing Items Line
/datum/data/lc13research/syringe
	research_name = "Ampule Runoff Permit"
	research_desc = "Due to your efforts, we are granting you the privilage of <br>purchasing low level hp ampules at a 90% discount."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/syringe/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Ampule ",	/obj/item/ksyringe, 300)
	..()

/datum/data/lc13research/krevival
	research_name = "K Corp Experimental Ampule "
	research_desc = "Hey, listen buddy, it's Joe from research. <br>The supply team went home for the night, and I'm tired, but I need this tested. <br>It'll revive one guy, once. It's a major breakthrough, give it a shot."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/syringe

/datum/data/lc13research/krevival/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/krevive(get_turf(caller))
	..()

/datum/data/lc13research/krevival2
	research_name = "K Corp Experimental Ampule II "
	research_desc = "Hey, listen buddy, it's Joe from research. <br>The supply team greenlit our last one, but they REALLY want to get their money back on this one. <br>It'll revive one guy, once. These are forbidden however, so I can't give you any more."
	cost = HIGH_RESEARCH_PRICE+5
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/krevival

/datum/data/lc13research/krevival2/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/krevive(get_turf(caller))
	..()

//Misc stuff.
/datum/data/lc13research/bullets
	research_name = "Manager Bullet Permits "
	research_desc = "Due to your efforts, we are granting you the privilage of <br>purchasing low level hp ampules at a 90% discount."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/bullets/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Manager Bullet ",	/obj/item/managerbullet, 100)
	..()

/datum/data/lc13research/injector
	research_name = "Chem Injection Implant"
	research_desc = "Our research into auto injection implants is suffering <br>from energy drain. Send us some refined PE and we will <br>sell you some of the prototypes."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/injector/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/reagent_containers/syringe/epinephrine(get_turf(caller))
	ItemUnlock(caller.order_list, "K Corp Implanter ",	/obj/item/implanter, 50)
	ItemUnlock(caller.order_list, "K Corp Chem Implant ",	/obj/item/implantcase/chem, 300)
	..()

/datum/data/lc13research/regenerator_overcharge/kcorp
	research_name = "Repeatable: RAK the Regenerator System "
	research_desc = "KCorp made this system for LCorp. <br>All you need to do is enter the following code into the machine, 9887. <br>Don't let LCorp know or they'll use it all the time and they'll break it; they have warranty."
	corp = K_CORP_REP

//Crit increaser
/datum/data/lc13research/critincrease
	research_name = "Repeatable: Crit Increaser Syringe "
	research_desc = "Hey man, its Joe from research. <br>We got this new item here? Should stop you from going into critical condition; you just die. <br>Management says it needs to be tested, and you can buy more anytime."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/critincrease/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/kcrit(get_turf(caller))

