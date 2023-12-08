//-----S_CORP-----
//S-Corp deals in a bit of everything having healing, ERTs and weaponry.

/datum/data/lc13research/s_corp_soda
	research_name = "S Corp Regenerative Soda"
	research_desc = "For a little side payment S Corp is willing to grant L Corp free access to purchase of their exclusive Grape Soda"
	cost = AVERAGE_RESEARCH_PRICE
	corp = S_CORP_REP

/datum/data/lc13research/s_corp_soda/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Grape Soda ",	/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple, 100)
	..()

/datum/data/lc13research/s_corp_guns
	research_name = "S Corp Soda Ballistics"
	research_desc = "These weaponries while not efficient are made through S Corp's ability to weaponize soda cheapily being easily mass produced and widely available to clerks and agents alike for no training"
	cost = LOW_RESEARCH_PRICE
	corp = S_CORP_REP

/datum/data/lc13research/s_corp_guns/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "S Corp Soda Shotgun ",	/obj/item/gun/ego_gun/sodashotty, 200)
	ItemUnlock(caller.order_list, "S Corp Soda Rifle ",		/obj/item/gun/ego_gun/sodarifle, 200)
	ItemUnlock(caller.order_list, "S Corp Soda Submachine Gun ",	/obj/item/gun/ego_gun/sodasmg, 200)
	ItemUnlock(caller.order_list, "S Corp Soda Assault Rifle ",	/obj/item/gun/ego_gun/shrimp/assault, 200)
	..()

/datum/data/lc13research/s_corp_guns2
	research_name = "Experimental S Corp Weaponry"
	research_desc = "Through grueling work the top researchers at S Corp have managed to create the Instant Shrimp Task Force Grenade and the top of the line Shrimp Minigun."
	cost = AVERAGE_RESEARCH_PRICE + 10
	corp = S_CORP_REP
	required_research = /datum/data/lc13research/s_corp_guns

/datum/data/lc13research/s_corp_guns2/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "S Corp Soda Minigun ", /obj/item/gun/ego_gun/shrimp/minigun, 1000)
	ItemUnlock(caller.order_list, "ISTF Grenade ", /obj/item/grenade/spawnergrenade/shrimp, 1000)
	..()

//ERTs
/datum/data/lc13research/mobspawner/internteam
	research_name = "Shrimp Liquidation Intern Team"
	research_desc = "These interns are new to the job and highly disposable, we can divert a few of them to your facility as their final task before a promotion, just don't rely on them to get much done"
	cost = LOW_RESEARCH_PRICE
	corp = S_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/scorp_call

/datum/data/lc13research/mobspawner/gunnerteam
	research_name = "Shrimp Liquidation Gunner Team"
	research_desc = "These are our top brass being capable of easily shredding threats and deploying quick backup, while they lack the IFF accuracy rabbits possess they are sure to rid you of any worries you might have"
	cost = AVERAGE_RESEARCH_PRICE + 10
	corp = S_CORP_REP
	required_research = /datum/data/lc13research/mobspawner/internteam
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/scorp_call/heavyweapons

/datum/data/lc13research/mobspawner/terminationteam
	research_name = "S-Corp Extermination Team"
	research_desc = "S Corp dislikes unauthorized use of it's equipment, this is a last resort incase they refuse to follow orders to return our equipment, do not call this team for any other reason"
	cost = 0
	corp = S_CORP_REP
	required_research = /datum/data/lc13research/mobspawner/internteam
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/scorp_call/terminationteam