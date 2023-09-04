
//Represenative Accomadations Console
#define ALL_REP_RESEARCH "~"
#define K_CORP_REP "K corp"
#define L_CORP_REP "L corp"
#define R_CORP_REP "R corp"
#define W_CORP_REP "W corp"
#define IS_MONIES istype(I, /obj/item/holochip)
#define IS_REFINED_PE istype(I, /obj/item/refinedpe)

/obj/structure/representative_console
	name = "representative accomadations console"
	desc = "Representatives that place their ID on this machine will allow their corp to send in unique technology."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "def_radar"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/our_corporation
	var/pe_points = 0
	var/monies = 0
	//For things we can buy with ahn.
	var/list/order_list = list()
	//For things we can research.
	var/list/research_list = list()
	//For things we already researched.
	var/list/researched_stuff = list()

//Landmarks for placing office stuff
/obj/effect/landmark/custom_office/poster
	name = "custom office landmark"
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "lc13_logo2"

/obj/effect/landmark/custom_office/crate
	name = "custom office landmark"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "crate_lcb"

/* The machine only activates if you set it up with a ID card.
	After that you can use PE and ahn on it.*/
/obj/structure/representative_console/attackby(obj/I, mob/user, params)
	if(isidcard(I))
		var/obj/item/card/id/R = I
		if(!our_corporation)
			PlaceRepStuff(R.assignment, user)
			return
	if(our_corporation)
		if(IS_MONIES)
			var/obj/item/holochip/H = I
			var/ahn_amount = H.get_item_credit_value()
			H.spend(ahn_amount)
			AdjustMonies(ahn_amount)
		if(IS_REFINED_PE)
			AdjustPoints(1)
			qdel(I)
		return
	else
		return ..()

/obj/structure/representative_console/ui_interact(mob/user)
	. = ..()
	if(!our_corporation)
		return
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += " ----------------------------<br>"
	dat += " :[our_corporation] RESEARCH:<br>"
	dat += "-[pe_points] PE- <br>"
	dat += " ----------------------------<br>"
	for(var/datum/data/lc13research/R in research_list)
		if(!LAZYFIND(researched_stuff, R) && R.CanResearch(src))
			dat += " <A href='byond://?src=[REF(src)];research=[REF(R)]'>[R.research_name]([R.cost] PE)</A><br>"
			dat += "	:[R.research_desc] <br>"
			dat += " -----<br>"
	dat += " ----------------------------<br>"
	dat += " :[our_corporation] PRODUCTS:<br>"
	dat += " <A href='byond://?src=[REF(src)];reclaimAhn=[REF(src)]'>-[monies] AHN-</A><br>"
	dat += " ----------------------------<br>"
	for(var/datum/data/extraction_cargo/A in order_list)
		if((A.catagory == our_corporation || A.catagory == ALL_REP_RESEARCH))
			dat += " <A href='byond://?src=[REF(src)];purchase=[REF(A)]'>[A.equipment_name]([A.cost] AHN)</A><br>"
	var/datum/browser/popup = new(user, "RepVendor", "RepVendor", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/structure/representative_console/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		//RESEARCH
		if(href_list["research"])
			var/datum/data/lc13research/research_datum = locate(href_list["research"]) in research_list
			if(!research_datum || locate(research_datum) in researched_stuff)
				to_chat(usr, "<span class='warning'>ERROR.</span>")
				return FALSE
			if(pe_points < research_datum.cost)
				to_chat(usr, "<span class='warning'>[our_corporation]: [usr] your research request requires more energy.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			AdjustPoints(-1 * research_datum.cost)
			research_datum.ResearchEffect(src)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

		//PRODUCTS
		if(href_list["purchase"])
			//The href_list returns the individual number code and only works if we have it in the first column. -IP
			var/datum/data/extraction_cargo/product_datum = locate(href_list["purchase"]) in order_list
			if(!product_datum)
				to_chat(usr, "<span class='warning'>ERROR.</span>")
				return FALSE
			if(monies < product_datum.cost)
				to_chat(usr, "<span class='warning'>INSUFFICENT FUNDS.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			new product_datum.equipment_path(get_turf(src))
			AdjustMonies(-1 * product_datum.cost)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

		if(href_list["reclaimAhn"])
			RefundMonies(monies)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

//Commerce procs that handle numbers.
/obj/structure/representative_console/proc/AdjustPoints(new_points)
	pe_points += new_points

/obj/structure/representative_console/proc/AdjustMonies(new_monies)
	monies += new_monies

/obj/structure/representative_console/proc/RefundMonies(refund_monies)
	if(refund_monies <= 0)
		return
	var/obj/item/holochip/holochip = new (get_turf(src))
	holochip.credits = refund_monies
	holochip.name = "[holochip.credits] ahn holochip"
	AdjustMonies(-1 * refund_monies)

//For placing stuff at landmarks
/obj/structure/representative_console/proc/PlaceRepStuff(reptype, mob/living/user)
	switch(reptype)
		if("K Corp Representative")
			//our corp determines what research and products we get.
			our_corporation = K_CORP_REP
			CustomizeOffice(/obj/structure/sign/departments/k_corp, /obj/structure/lootcrate/k_corp)
			//add preloaded items to this list.
			order_list = list()

		if("Main Office Representative")
			our_corporation = L_CORP_REP
			CustomizeOffice(/obj/structure/sign/departments/l_corp, /obj/structure/lootcrate/l_corp)
			order_list = list()

		if("R Corp Representative")
			our_corporation = R_CORP_REP
			CustomizeOffice(/obj/structure/sign/departments/r_corp, /obj/structure/lootcrate/r_corp)
			order_list = list(
				new /datum/data/extraction_cargo("R Corp Ordeal Detector", /obj/item/powered_gadget/detector_gadget/ordeal, 500, R_CORP_REP) = 1,
				)

		if("W Corp Representative")
			our_corporation = W_CORP_REP
			CustomizeOffice(/obj/structure/sign/departments/w_corp, /obj/structure/lootcrate/w_corp)
			order_list = list()

		else
			to_chat(usr, "<span class='warning'>ASSIGNMENT ERROR.</span>")
			playsound(get_turf(src), 'sound/machines/uplinkerror.ogg', 20, 1)
			return
	CreateResearchList(our_corporation)
	name = "[our_corporation] corp representative console"
	playsound(get_turf(src), 'sound/machines/terminal_success.ogg', 20, 1)
	return

/obj/structure/representative_console/proc/CustomizeOffice(obj/poster, obj/crate)
	var/poster_place = get_turf(locate(/obj/effect/landmark/custom_office/poster) in GLOB.landmarks_list)
	if(isturf(poster_place))
		new poster(get_turf(poster_place))

	var/crate_place = get_turf(locate(/obj/effect/landmark/custom_office/crate) in GLOB.landmarks_list)
	if(!crate_place)
		crate_place = get_turf(src)
	new crate(get_turf(crate_place))

//Due to the list requiring a =1 added to the end i had to jump through some hoops by defining the research first and then defining its value as 1
/obj/structure/representative_console/proc/CreateResearchList(our_benifactor)
	research_list = list()
	var/datum/data/lc13research/research
	var/list/added_research = list()
	for(var/_research in subtypesof(/datum/data/lc13research))
		research = new _research()
		if(research.corp == our_benifactor || research.corp == ALL_REP_RESEARCH)
			added_research += research
			added_research[research] = 1
	LAZYADD(research_list, added_research)

#undef IS_MONIES
#undef IS_REFINED_PE

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
#define LOW_RESEARCH_PRICE 10
#define AVERAGE_RESEARCH_PRICE 30
#define HIGH_RESEARCH_PRICE 90
#define MAX_RESEARCH_PRICE 120
//-----GENERAL-----

/datum/data/lc13research/ratknife
	research_name = "Rat Knife Stock "
	research_desc = "Contribute some energy to request the clerks in charge of stocking <br>our equipment to buy a crate of knives."
	cost = LOW_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH

/datum/data/lc13research/ratknife/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Rat Knife ",	/obj/item/ego_weapon/city/rats/knife, 1)
	..()

/datum/data/lc13research/regenerator_overcharge
	research_name = "Repeatable: RAK the Regenerator System "
	research_desc = "The security department blueprints say that all the regenerators <br>healing systems are connected at a junction point. <br>A department clerk offers to take the 10 second trip to the junction <br>and overcharge the whole system at the cost of some refined PE."
	cost = AVERAGE_RESEARCH_PRICE
	corp = ALL_REP_RESEARCH

/datum/data/lc13research/regenerator_overcharge/ResearchEffect(obj/structure/representative_console/caller)
	if(repeat_cooldown > world.time)
		return
	for(var/obj/machinery/regenerator/R in GLOB.regenerators)
		R.burst = TRUE
	caller.visible_message("<span class='notice'>The [caller] rumbles for a moment soon after your message is delivered.</span>")
	repeat_cooldown = world.time + (10 SECONDS)

//-----K_CORP-----

/datum/data/lc13research/syringe
	research_name = "Ampule Runoff Permit"
	research_desc = "Due to your efforts, we are granting you the privilage of <br>purchasing low level hp ampules at a 90% discount."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/syringe/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "K Corp Ampule ",	/obj/item/ksyringe, 800)
	..()

/datum/data/lc13research/syringe
	research_name = "Chem Injection Implant"
	research_desc = "Our research into auto injection implants is suffering <br>from energy drain. Send us some refined PE and we will <br>sell you some of the prototypes."
	cost = AVERAGE_RESEARCH_PRICE
	corp = K_CORP_REP

/datum/data/lc13research/syringe/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/reagent_containers/syringe/epinephrine(get_turf(caller))
	ItemUnlock(caller.order_list, "K Corp Implanter ",	/obj/item/implanter, 50)
	ItemUnlock(caller.order_list, "K Corp Chem Implant ",	/obj/item/implantcase/chem, 300)
	..()

//-----L_CORP-----

/datum/data/lc13research/detector
	research_name = "Affordable Detector Research"
	research_desc = "Contributed energy will be sent to welfare in order to develop <br>abnormality detectors made from more affordable material."
	cost = AVERAGE_RESEARCH_PRICE
	corp = L_CORP_REP

/datum/data/lc13research/detector/ResearchEffect(obj/structure/representative_console/caller)
	ItemUnlock(caller.order_list, "Abnormality Detector ",	/obj/item/powered_gadget/detector_gadget/abnormality, 1)
	..()

/datum/data/lc13research/pe_quota1
	research_name = "Alter Facility PE Quota "
	research_desc = "You think you may be able to remove 3000 PE from the PE quota <br>at the cost of some refined PE. <br>Hopefully the sephirah overlook your tampering with the L corp delivery systems."
	cost = AVERAGE_RESEARCH_PRICE + 20
	corp = L_CORP_REP

/datum/data/lc13research/pe_quota1/ResearchEffect(obj/structure/representative_console/caller)
	SSlobotomy_corp.AdjustGoalBoxes(-3000)
	..()

//-----R_CORP-----

/datum/data/lc13research/mobspawner/rabbit
	research_name = "4th Pack Rabbit Team"
	research_desc = "Our contract with L corp garentees at least one rabbit call <br>per day in exchange for energy. We can abuse a loophole in the contract <br>and list you as the client if you remain descreet."
	cost = AVERAGE_RESEARCH_PRICE
	corp = R_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/rabbit_call

/datum/data/lc13research/mobspawner/raven
	research_name = "4th Pack Raven Team"
	research_desc = "We need data on how our ravens preform in confined hallways. <br>Same conditions of the last deal apply."
	cost = AVERAGE_RESEARCH_PRICE + 10
	corp = R_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/raven_call
	required_research = /datum/data/lc13research/mobspawner/rabbit

/datum/data/lc13research/mobspawner/rhino
	research_name = "4th Pack Twin Rhinos"
	research_desc = "Two rhinos in the barracks are getting restless. We can <br>send them to you if you take responsibility for any damages they cause."
	cost = AVERAGE_RESEARCH_PRICE + 20
	corp = R_CORP_REP
	mobspawner_type = /obj/effect/mob_spawn/human/supplypod/r_corp/rhino_call
	required_research = /datum/data/lc13research/mobspawner/raven

//-----W_CORP-----
/datum/data/lc13research/teleporter
	research_name = "Instant Transmission Device"
	research_desc = "W Corp will grant you a portable teleporter in exchange for energy."
	cost = LOW_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/rabbit/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/powered_gadget/teleporter(get_turf(caller))
	..()

/datum/data/lc13research/teleporter
	research_name = "Prototype Quantum Pads"
	research_desc = "Our cleanup crew found one half of these pads and a <br>instruction manual in one of our trains. Our researchers managed to reverse engineer <br>a replica with a copy of the book. We would like you to test <br>these pads in the facility your currently working in and <br>report back if its function threatens our buisness."
	cost = AVERAGE_RESEARCH_PRICE
	corp = W_CORP_REP

/datum/data/lc13research/rabbit/ResearchEffect(obj/structure/representative_console/caller)
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
