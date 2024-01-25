
//Represenative Accomadations Console
#define ALL_REP_RESEARCH "~"
#define K_CORP_REP "K corp"
#define L_CORP_REP "L corp"
#define R_CORP_REP "R corp"
#define W_CORP_REP "W corp"
#define N_CORP_REP "N corp"
#define P_CORP_REP "P corp"
#define IS_MONIES istype(I, /obj/item/holochip)
#define IS_REFINED_PE istype(I, /obj/item/refinedpe)
#define IS_RAW_PE istype(I, /obj/item/rawpe)

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

/obj/structure/representative_console/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/representative_console/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

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
			AdjustPoints(2)
			qdel(I)
		if(IS_RAW_PE)
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
	dat += " :[our_corporation] PRODUCTS:<br>"
	dat += " <A href='byond://?src=[REF(src)];reclaimAhn=[REF(src)]'>-[monies] AHN-</A><br>"
	dat += " ----------------------------<br>"
	for(var/datum/data/extraction_cargo/A in order_list)
		if((A.catagory == our_corporation || A.catagory == ALL_REP_RESEARCH))
			dat += " <A href='byond://?src=[REF(src)];purchase=[REF(A)]'>[A.equipment_name] ([A.cost] AHN)</A><br>"

	dat += " ----------------------------<br>"
	dat += " :[our_corporation] RESEARCH:<br>"
	dat += "-[pe_points] PE- <br>"
	dat += " ----------------------------<br>"
	for(var/datum/data/lc13research/R in research_list)
		if(!LAZYFIND(researched_stuff, R) && R.CanResearch(src))
			dat += " <A href='byond://?src=[REF(src)];research=[REF(R)]'>[R.research_name] ([R.cost] PE)</A><br>"
			dat += "	:[R.research_desc] <br>"
			dat += " -----<br>"
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
				to_chat(usr, span_warning("ERROR."))
				return FALSE
			if(pe_points < research_datum.cost)
				to_chat(usr, span_warning("[our_corporation]: [usr] your research request requires more energy."))
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
				to_chat(usr, span_warning("ERROR."))
				return FALSE
			if(monies < product_datum.cost)
				to_chat(usr, span_warning("INSUFFICENT FUNDS."))
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
			CustomizeOffice(/obj/structure/sign/departments/k_corp, /obj/structure/pe_sales/k_corp)
			//add preloaded items to this list.
			order_list = list(
				new /datum/data/extraction_cargo("K Corp Intern Outfit", /obj/item/clothing/under/rank/k_corporation/intern, 100, K_CORP_REP) = 1,
				new /datum/data/extraction_cargo("K Corp Baton", /obj/item/ego_weapon/city/kcorp, 400, K_CORP_REP) = 1,
				new /datum/data/extraction_cargo("K Corp Axe", /obj/item/ego_weapon/city/kcorp/axe, 400, K_CORP_REP) = 1,
				new /datum/data/extraction_cargo("K Corp Shield", /obj/item/ego_weapon/shield/kcorp, 400, K_CORP_REP) = 1,
				new /datum/data/extraction_cargo("K Corp Pistol", /obj/item/gun/ego_gun/pistol/kcorp, 400, K_CORP_REP) = 1,
			)

		if("Main Office Representative")
			our_corporation = L_CORP_REP
			CustomizeOffice(/obj/structure/sign/departments/l_corp, /obj/structure/pe_sales/l_corp)
			order_list = list(
				new /datum/data/extraction_cargo("L Corp Regeneration Augmentation Kit", /obj/item/safety_kit, 400, L_CORP_REP) = 1,
				new /datum/data/extraction_cargo("L Corp Slowing Trap Generator", /obj/item/powered_gadget/slowingtrapmk1, 400, L_CORP_REP) = 1,
				new /datum/data/extraction_cargo("L Corp Vitals Projector", /obj/item/powered_gadget/vitals_projector, 400, L_CORP_REP) = 1,
				new /datum/data/extraction_cargo("L Corp Clerkbot Kit", /obj/item/clerkbot_gadget, 400, L_CORP_REP) = 1,
				new /datum/data/extraction_cargo("L Corp Taser", /obj/item/powered_gadget/handheld_taser, 700, L_CORP_REP) = 1,
			)

		if("R Corp Representative")
			our_corporation = R_CORP_REP
			CustomizeOffice(/obj/structure/sign/departments/r_corp, /obj/structure/pe_sales/r_corp)
			order_list = list(
				new /datum/data/extraction_cargo("R Corp Mercenary Outfit", /obj/item/clothing/under/suit/lobotomy/rabbit, 100, R_CORP_REP) = 1,
				new /datum/data/extraction_cargo("R Corp Ordeal Detector", /obj/item/powered_gadget/detector_gadget/ordeal, 400, R_CORP_REP) = 1,
				new /datum/data/extraction_cargo("R Corp Lawnmower 2000", /obj/item/gun/energy/e_gun/rabbitdash, 500, R_CORP_REP) = 1,
				new /datum/data/extraction_cargo("R Corp Officer Outfit", /obj/item/clothing/under/suit/lobotomy/rabbit, 100, R_CORP_REP) = 1,
			)

		if("W Corp Representative")
			our_corporation = W_CORP_REP
			CustomizeOffice(/obj/structure/sign/departments/w_corp, /obj/structure/pe_sales/w_corp)
			order_list = list(
				new /datum/data/extraction_cargo("W Corp Cleanup Outfit", /obj/item/clothing/under/suit/lobotomy/wcorp, 100, W_CORP_REP) = 1,
				new /datum/data/extraction_cargo("W Corp Hat", /obj/item/clothing/head/ego_hat/wcorp, 100, W_CORP_REP) = 1,
				new /datum/data/extraction_cargo("W Corp Cleanup Baton", /obj/item/ego_weapon/city/charge/wcorp, 500, W_CORP_REP) = 1,
				new /datum/data/extraction_cargo("W Corp Armor Vest", /obj/item/clothing/suit/armor/ego_gear/wcorp, 700, W_CORP_REP) = 1,
			)

		if("N Corp Representative")
			our_corporation = N_CORP_REP
			CustomizeOffice(null, /obj/structure/pe_sales/n_corp)
			order_list = list()

		if("P Corp Representative")
			our_corporation = P_CORP_REP
			CustomizeOffice(null, null)
			order_list = list(
				new /datum/data/extraction_cargo("P Corp Canned Bread", /obj/item/food/canned/pcorp, 10, P_CORP_REP) = 1,
			)

		else
			to_chat(usr, span_warning("ASSIGNMENT ERROR."))
			playsound(get_turf(src), 'sound/machines/uplinkerror.ogg', 20, 1)
			return
	CreateResearchList(our_corporation)
	name = "[our_corporation] corp representative console"
	playsound(get_turf(src), 'sound/machines/terminal_success.ogg', 20, 1)
	return

/obj/structure/representative_console/proc/CustomizeOffice(obj/poster, obj/crate)
	var/poster_place = get_turf(locate(/obj/effect/landmark/custom_office/poster) in GLOB.landmarks_list)
	if((isturf(poster_place)) && poster)
		new poster(get_turf(poster_place))

	var/crate_place = get_turf(locate(/obj/effect/landmark/custom_office/crate) in GLOB.landmarks_list)
	if((!crate_place) && crate)
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
#undef IS_RAW_PE
