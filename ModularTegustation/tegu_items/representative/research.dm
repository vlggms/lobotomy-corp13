
/*Representative Datum that contains research procs
	Researched var is for if we have already bought
	this research and it is a one time thing.*/
/datum/data/lc13research
	var/research_name = "ERROR"
	var/research_desc = "ERROR"
	var/cost = 0
	//What type of rep is this research visable to.
	var/corp
	//for repeatable research cooldowns.
	var/repeat_cooldown = 0
	//research required for this to appear.
	//I tried making this a list but the methods i used didnt work. -IP
	var/required_research

//Pre loaded with making researched true since most researches will only happen once.
/datum/data/lc13research/proc/ResearchEffect(obj/structure/representative_console/caller)
	caller.researched_stuff += src

/datum/data/lc13research/proc/CanResearch(obj/structure/representative_console/caller)
	if(!ReqResearch(caller, required_research))
		return FALSE
	if(repeat_cooldown > world.time)
		return FALSE
	return TRUE

//Proc that returns false if any of the research that is required is missing from the callers researched_stuff.
/datum/data/lc13research/proc/ReqResearch(obj/structure/representative_console/caller, research_needed)
	var/req = locate(research_needed) in caller.research_list
	if(!req || LAZYFIND(caller.researched_stuff, req))
		return TRUE
	return FALSE

/* Generalized item unlock for the ahn section.
	Override this section with a proc in order
	to make it effect stuff outside the console.*/
/datum/data/lc13research/proc/ItemUnlock(list/for_sale, product_name, product_path, product_cost)
	var/list/product = list( new /datum/data/extraction_cargo(product_name, product_path, product_cost, corp) = 1)
	LAZYADD(for_sale, product)

//Utilize mobspawners in the ghost_role_spawners.dm file.
/datum/data/lc13research/mobspawner
	var/mobspawner_type

/datum/data/lc13research/mobspawner/ResearchEffect(obj/structure/representative_console/caller)
	var/landing_zone = AnalyzeLandingZone()
	if(!landing_zone)
		//Well shit i guess we will just land here.
		landing_zone = get_turf(src)
	new mobspawner_type(landing_zone)
	..()

//Makes sure we spawn the mobspawner in a safe area.
/datum/data/lc13research/mobspawner/proc/AnalyzeLandingZone()
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		//if the landing zone is hot just skip it.
		if(locate(/mob/living/simple_animal/hostile/abnormality) in get_area(T))
			continue
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return pick(GLOB.department_centers)
	return pick(teleport_potential)

//This honestly doesnt help with understanding because im already adding + 10 to some of these. We just need a standard.
#define LOW_RESEARCH_PRICE 5
#define AVERAGE_RESEARCH_PRICE 10
#define HIGH_RESEARCH_PRICE 25
#define MAX_RESEARCH_PRICE 50
//-----GENERAL-----

/datum/data/lc13research/ratknife
	research_name = "Rat Equipment Stock "
	research_desc = "Contribute some energy to request the clerks in charge of stocking <br>our equipment to buy a crate of knives."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH

/datum/data/lc13research/ratknife/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Rat Knife",	/obj/item/ego_weapon/city/rats/knife, 100)
	ItemUnlock(caller.order_list, "Rat Hammer",	/obj/item/ego_weapon/city/rats, 100)
	ItemUnlock(caller.order_list, "Brick",	/obj/item/ego_weapon/city/rats/brick, 100)
	ItemUnlock(caller.order_list, "Metal Pipe",	/obj/item/ego_weapon/city/rats/pipe, 100)
	..()

/datum/data/lc13research/mobspawner/zwei
	research_name = "Zwei Section 6 Team"
	research_desc = "For a small slice of funds we can hire the local zwei to assist us."
	cost = AVERAGE_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/zwei_call

/*	Unfinished
/datum/data/lc13research/mobspawner/association
	research_name = "Association Call"
	research_desc = "Send out the local association. It's pricy, but they're worth it <br>."
	cost = HIGH_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/association/zwei
	var/list/associationspawners = list(
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/hana,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/zwei,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/shi,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/shi5,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/cinq,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/liu,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/liu6,
	/obj/effect/mob_spawn/human/supplypod/r_corp/association/seven,
	)

/datum/data/lc13research/mobspawner/association/ResearchEffect(obj/structure/representative_console/caller)
	mobspawner_type = pick(associationspawners)
	..()	*/

//-----K_CORP-----
//K Corp sells mostly healing gear.

/datum/data/lc13research/syringe
	research_name = "Ampule Runoff Permit"
	research_desc = "Due to your efforts, we are granting you the privilage of <br>purchasing low level hp ampules at a 90% discount."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/syringe/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Ampule ",	/obj/item/ksyringe, 300)
	..()

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

/datum/data/lc13research/krevival
	research_name = "K Corp Experimental Ampule "
	research_desc = "Hey, listen buddy, it's Joe from research. <br>The supply team went home for the night, and I'm tired, but I need this tested. <br>It'll revive one guy, once. It's a major breakthrough, give it a shot."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = K_CORP_REP

/datum/data/lc13research/krevival/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/krevive(get_turf(caller))
	..()

//-----L_CORP-----
//L Corp generally makes your life a lot easier with L-Corp related things.

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
	minor_announce("Extraction has given you another choice of 3 abnos", "Extraction Alert:", TRUE)
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
	caller.visible_message("<span class='notice'>The [caller] rumbles for a moment soon after your message is delivered.</span>")
	repeat_cooldown = world.time + (10 SECONDS)


//PE quota Stuff
/datum/data/lc13research/pe_quota1
	research_name = "Alter Facility PE Quota I "
	research_desc = "You think you may be able to remove 1000 PE from the PE quota <br>at the cost of some raw PE. <br>Hopefully the sephirah overlook your tampering with the L corp delivery systems."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/pe_quota1/ResearchEffect(obj/structure/representative_console/caller)
	SSlobotomy_corp.AdjustGoalBoxes(-1000)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()

/datum/data/lc13research/pe_quota2
	research_name = "Alter Facility PE Quota II "
	research_desc = "You think you may be able to remove a further 1000 PE from the PE quota <br>at the cost of some raw PE. <br>This will however forfeit your bonus at the end of the shift."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/pe_quota1

/datum/data/lc13research/pe_quota2/ResearchEffect(obj/structure/representative_console/caller)
	SSlobotomy_corp.AdjustGoalBoxes(-1000)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()

/datum/data/lc13research/pe_quota3
	research_name = "Alter Facility PE Quota III "
	research_desc = "You think you may be able to remove a further 1000 PE from the PE quota <br>at the cost of some raw PE. <br>The manager will be contacted about this, but you think you can weasel them out of <br>any issues with the district manager."
	cost = AVERAGE_RESEARCH_PRICE+10
	corp = L_CORP_REP
	required_research = /datum/data/lc13research/pe_quota2

/datum/data/lc13research/pe_quota3/ResearchEffect(obj/structure/representative_console/caller)
	SSlobotomy_corp.AdjustGoalBoxes(-1000)
	minor_announce("HQ has reduced your PE quota by 1000.", "HQ Alert:", TRUE)
	..()

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

//-----W_CORP-----
//W-Corp has movement technology, and upgraded weapons.

/datum/data/lc13research/w_corp_typea
	research_name = "W Corp Type A Weapons"
	research_desc = "W Corp will let you purchase their Type-A weapons, at a pretty steep cost."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/w_corp_typea/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "W Corp Type A Fist ",	/obj/item/ego_weapon/city/wcorp/fist, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Axe ",		/obj/item/ego_weapon/city/wcorp/axe, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Spear ",	/obj/item/ego_weapon/city/wcorp/spear, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Dagger ",	/obj/item/ego_weapon/city/wcorp/dagger, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Hammer ",	/obj/item/ego_weapon/city/wcorp/hammer, 1000)
	ItemUnlock(caller.order_list, "W Corp Type A Hatchet ",	/obj/item/ego_weapon/city/wcorp/hatchet, 1000)
	..()

/datum/data/lc13research/mobspawner/wcorp
	research_name = "W-Corp L1 Cleanup Team"
	research_desc = "The nearby intern staff are looking for easy training. <br>We can ship them to you but they won't be that effective."
	cost = LOW_RESEARCH_PRICE
	corp = W_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/wcorp_call

/datum/data/lc13research/mobspawner/wcorpl3
	research_name = "W-Corp L2 Cleanup Team"
	research_desc = "The nearby L2 staff are looking for their monthly bonus. <br>They're at the ready should you need them."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/wcorp_call
	required_research = /datum/data/lc13research/mobspawner/wcorp

/datum/data/lc13research/teleporter
	research_name = "Prototype Quantum Pads"
	research_desc = "Our cleanup crew found one half of these pads and a <br>instruction manual in one of our trains. Our researchers managed to reverse engineer <br>a replica with a copy of the book. We would like you to test <br>these pads in the facility your currently working in and <br>report back if its function threatens our buisness."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/teleporter/ResearchEffect(obj/structure/representative_console/caller)
	var/place_to_place = get_turf(src)
	//two keycards for both quantum pads.
	new /obj/item/quantum_keycard(place_to_place)
	new /obj/item/quantum_keycard(place_to_place)
	//a outdated guide
	new /obj/item/paper/guides/quantumpad(place_to_place)
	//and a box with 2 quantum pads
	new /obj/item/package_quantumpad(place_to_place)
	..()

#undef LOW_RESEARCH_PRICE
#undef AVERAGE_RESEARCH_PRICE
#undef HIGH_RESEARCH_PRICE
#undef MAX_RESEARCH_PRICE
#undef ALL_REP_RESEARCH
#undef K_CORP_REP
#undef L_CORP_REP
#undef R_CORP_REP
#undef W_CORP_REP
