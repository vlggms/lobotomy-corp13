/**
 * Records Cabinet
 */

GLOBAL_LIST_EMPTY(records_cabinets)

/obj/effect/mapping_helpers/records_spawner
	/// List of papers that we want to spawn, hard-coded to be 3 in lenght
	var/list/desired_papers = list(
		/obj/item/paper/fluff/info/zayin,
		/obj/item/paper/fluff/info/teth,
		/obj/item/paper/fluff/info/he,
	)

/obj/effect/mapping_helpers/records_spawner/Initialize()
	. = ..()
	var/desired_location = -10
	for(var/i in 1 to desired_papers.len)
		var/obj/structure/filingcabinet/smart/cabinet = new(get_turf(src))

		// take the 1st item in the list then cut to remove it from the mapping helpers list, next continue the loop
		var/picked_paper = desired_papers[1]
		desired_papers -= picked_paper

		// set cabinet variables so it looks nice
		cabinet.desired_type = picked_paper
		cabinet.pixel_x = desired_location

		// add the cabinet to GLOB, so ticker can populate it at round-start
		GLOB.records_cabinets += cabinet
		desired_location += 10

/obj/effect/mapping_helpers/records_spawner/second
	desired_papers = list(
		/obj/item/paper/fluff/info/waw,
		/obj/item/paper/fluff/info/aleph,
		/obj/item/paper/fluff/info/tool,
	)

/obj/structure/filingcabinet/smart
	icon_state = "employmentcabinet"
	var/obj/item/paper/fluff/info/desired_type

/obj/structure/filingcabinet/smart/proc/spawn_records(mode)
	var/datum/game_mode/management/gamemode = mode

	var/list/queue = subtypesof(desired_type)
	for(var/obj/item/paper/fluff/info/paper as anything in queue)
		if(desired_type == /obj/item/paper/fluff/info/tool) // skip the queue
			new paper(src)
			continue

		if(isnull(paper.abno_type)) // Most likelly a parent, that or someone fucked up
			message_admins("A records paper attempted to spawn, but failed due to not having an abnormality assigned ([paper])")
			continue

		var/paper_origin = paper.abno_type.abnormality_origin
		var/passed_check = FALSE
		for(var/allowed_abnormalities in gamemode.abno_types)
			if(allowed_abnormalities == paper_origin)
				passed_check = TRUE

		if(!passed_check)
			continue

		new paper(src)

//Zayin
/obj/structure/filingcabinet/zayininfo
	name = "zayin abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/zayininfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/zayin)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/zayininfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//Teths
/obj/structure/filingcabinet/tethinfo
	name = "teth abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/tethinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/teth)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/tethinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//HEs
/obj/structure/filingcabinet/heinfo
	name = "he abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/heinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/he)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/heinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()


//WAWs
/obj/structure/filingcabinet/wawinfo
	name = "waw abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/wawinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/waw)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/wawinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//Aleph
/obj/structure/filingcabinet/alephinfo
	name = "aleph abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/alephinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/aleph)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/alephinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//Tools
/obj/structure/filingcabinet/toolinfo
	name = "tool abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/toolinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/tool)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/toolinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()


/*
 * Lore Cabinet
 */

/obj/structure/filingcabinet/lore
	name = "template supplimentary information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE
	var/list/infotype = /obj/item/paper/fluff/lore/zayin

/obj/structure/filingcabinet/lore/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

/obj/structure/filingcabinet/lore/proc/fillCurrent()
	for(var/sheet in subtypesof(infotype))
		new sheet(src)


//Zayin
/obj/structure/filingcabinet/lore/zayin
	name = "zayin supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/zayin

//Teth
/obj/structure/filingcabinet/lore/teth
	name = "teth supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/teth

//He
/obj/structure/filingcabinet/lore/he
	name = "he supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/he

//Waw
/obj/structure/filingcabinet/lore/waw
	name = "waw supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/waw

//Aleph
/obj/structure/filingcabinet/lore/aleph
	name = "aleph supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/aleph
