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
	research_name = "K Corp Experimental Ampule"
	research_desc = "Hey, listen buddy, it's Joe from research. <br>The supply team went home for the night, and I'm tired, but I need this tested. <br>It'll revive one guy, once. It's a major breakthrough, give it a shot."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/syringe

/datum/data/lc13research/krevival/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/krevive(get_turf(caller))
	..()

/datum/data/lc13research/krevival2
	research_name = "K Corp Experimental Ampule II"
	research_desc = "Hey, listen buddy, it's Joe from research. <br>The supply team greenlit our last one, but they REALLY want to get their money back on this one. <br>It'll revive one guy, once. These are forbidden however, so I can't give you any more."
	cost = HIGH_RESEARCH_PRICE+5
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/krevival

/datum/data/lc13research/krevival2/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/krevive(get_turf(caller))
	..()

//Misc stuff.
/datum/data/lc13research/bullets
	research_name = "Manager Bullet Permits"
	research_desc = "Due to your efforts, we are granting you the privilage of <br>purchasing managerial bullets at a 90% discount."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/bullets/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Manager Bullet",	/obj/item/managerbullet, 100)
	..()

/datum/data/lc13research/injector
	research_name = "Chem Injection Implant"
	research_desc = "Our research into auto injection implants is suffering <br>from energy drain. Send us some refined PE and we will <br>sell you some of the prototypes."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/injector/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/reagent_containers/syringe/epinephrine(get_turf(caller))
	ItemUnlock(caller.order_list, "K Corp Implanter",	/obj/item/implanter, 50)
	ItemUnlock(caller.order_list, "K Corp Chem Implant",	/obj/item/implantcase/chem, 300)
	..()

/datum/data/lc13research/regenerator_overcharge/kcorp
	research_name = "Repeatable: RAK the Regenerator System"
	research_desc = "KCorp made this system for LCorp. <br>All you need to do is enter the following code into the machine, 9887. <br>Don't let LCorp know or they'll use it all the time and they'll break it; they have warranty."
	corp = K_CORP_REP

//Health booster
/datum/data/lc13research/healthboost
	research_name = "Health Booster Syringe"
	research_desc = "Hey man, its Joe from research. <br>We've got a new item over here, something about increasing your overall health? <br>They only really made one of these and told us to get it tested ASAP, i'm assuming that want to wait before investing. Mind helping us out?"
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/syringe

/datum/data/lc13research/healthboost/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/khpboost(get_turf(caller))
	..()

//ERTs
/datum/data/lc13research/mobspawner/k1team
	research_name = "Class 1 Strike Team"
	research_desc = "Heads up, Kcorp's given a greenlight on drawing from their more... Physical resources. <br>All they're asking for is a foward investment. You can handle that right?"
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/kcorp_call

/datum/data/lc13research/mobspawner/k3team
	research_name = "Class 3 Strike Team"
	research_desc = "Good news, KCorp's got some excision officers free for a contract. As long as they're paid they won't go after LCorps agents. <br>Hopefully."
	cost = AVERAGE_RESEARCH_PRICE+10
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/mobspawner/k1team
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/kcorp_call/level3

//Free kill team, only unlocks when you actually should use it.
/datum/data/lc13research/mobspawner/kteamkill
	research_name = "K-Corp Asset Protection Service"
	research_desc = "Theres a small little caveat with the strike teams. HQ is very protective of their equipment and won't tolerate anyone, L-Corp included, using them without permission. <br>As part of the agreement it falls on you to call a K-Corp Asset Protection Team when this violation occurs. <br>Keep in mind this WILL break our contract with L-Corp so use it as a last resort."
	cost = 0
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/mobspawner/k1team
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/kcorp_call/killteam

/datum/data/lc13research/mobspawner/kteamkill/ResearchEffect(obj/structure/representative_console/caller)
	minor_announce("Attention all L-Corp branch employees. We have discovered unauthorized usage of our equipment. An Asset Protection Team is enroute to your location.", "K Corp HQ Update:", TRUE)
	..()

//Weapons
//This one does nothing, however It's a bar to entry to actually grab the weapons.
/datum/data/lc13research/kweapons
	research_name = "K-Corp Weapon Permit"
	research_desc = "This is just an agreement that we're here to make weapons business. <br>We usually refuse to give up our weapons due to them being manufactured in low amounts, <br>We require some up front."
	cost = LOW_RESEARCH_PRICE
	corp = K_CORP_REP


/datum/data/lc13research/kspears
	research_name = "K-Corp Spears Shipment"
	research_desc = "Wow, you actually bought it? <br>This is Jill from supply. Our weapons are known for being low quality, and so we're not too willing to give them out. <br>However, it seems like you really do need weapons. Must be desperate, huh? I'll put in a spear order for you. <br>Don't tell L-Corp or the execs about the low quality bit, Let's keep it under wraps."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/kweapons

/datum/data/lc13research/kspears/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Spear",	/obj/item/ego_weapon/city/kcorp/spear, 600)
	ItemUnlock(caller.order_list, "K Corp DoubleSpear",	/obj/item/ego_weapon/city/kcorp/dspear, 600)
	..()


/datum/data/lc13research/kguns
	research_name = "K-Corp Firearms Shipment"
	research_desc = "Hey, this is Jill from supply. <br>We've been keeping a handful of gun projects under wraps to replace our batons. <br>It sounds expensive, but these are actually air rifles. They fire using compressed air.<br> Smart right? Ammo is cheap, almost free. We're currently looking to arm some Class 2s with them over in district 7. <br>I can order another shipment for you if you'd like."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/kweapons

/datum/data/lc13research/kguns/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Machinepistole",	/obj/item/gun/ego_gun/pistol/kcorp/smg, 600)
	ItemUnlock(caller.order_list, "K Corp Light Grenade Launcher",	/obj/item/gun/ego_gun/pistol/kcorp/nade, 600)
	..()

/datum/data/lc13research/karmor1
	research_name = "K-Corp Class-1 Armor Shipment"
	research_desc = "Not a lot of people buy these. <br>Hi, I'm Jill from supply. These armors were sitting around collecting dust in the warehouse as we have quite a lot of these, we could lend you some for general use, while in a better state compared to our spears I wouldn't call them top grade. <br>I trust you won't tell our client this however."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/kweapons

/datum/data/lc13research/karmor1/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Class-1 Armor", /obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1/weak, 600)
	ItemUnlock(caller.order_list, "K Corp L1 Helmet",	/obj/item/clothing/head/ego_hat/helmet/kcorp, 100)
	ItemUnlock(caller.order_list, "K Corp L1 Visor Helmet",	/obj/item/clothing/head/ego_hat/helmet/kcorp/visor, 100)

//Spawners
/datum/data/lc13research/kdrones
	research_name = "K-Corp Healing Drones"
	research_desc = "Jill here, you know, from supply? <br>You guys wanted some of our Healing drones? <br>They're really fucking annoying but sure. Usually we're not supposed to give these out but fuck me if I'm going to miss my bonus this month."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP
	required_research = /datum/data/lc13research/syringe

/datum/data/lc13research/kguns/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Drone Spawner",	/obj/item/grenade/spawnergrenade/khealing, 600)
	..()
