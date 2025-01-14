/**
 * Records Cabinet and its spawners
 *
 */

GLOBAL_LIST_EMPTY(records_cabinets)

/obj/effect/mapping_helpers/records_spawner
	name = "ZAYIN/TETH/HE records cabinet spawner"
	density = TRUE
	/// List of paper types that we want to spawn
	var/list/desired_papers = list(
		/obj/item/paper/fluff/info/zayin,
		/obj/item/paper/fluff/info/teth,
		/obj/item/paper/fluff/info/he,
	)

/obj/effect/mapping_helpers/records_spawner/Initialize()
	. = ..()
	var/current_location = 5 + (length(desired_papers) * -5)
	for(var/i in 1 to length(desired_papers))
		var/obj/structure/filingcabinet/smart/cabinet = new(get_turf(src))
		GLOB.records_cabinets += cabinet // Cabinets in this list are populated at round-start automatically

		cabinet.desired_type = desired_papers[i]
		cabinet.pixel_x = current_location

		current_location += 10
		if(!density)
			cabinet.density = density
			cabinet.pixel_y += 20

/obj/effect/mapping_helpers/records_spawner/second
	name = "WAW/ALEPH/TOOL records cabinet spawner"
	desired_papers = list(
		/obj/item/paper/fluff/info/waw,
		/obj/item/paper/fluff/info/aleph,
		/obj/item/paper/fluff/info/tool,
	)

/obj/effect/mapping_helpers/records_spawner/walk_through
	name = "ZAYIN/TETH/HE records cabinet spawner -- Walk-through"
	density = FALSE

/obj/effect/mapping_helpers/records_spawner/second/walk_through
	name = "WAW/ALEPH/TOOL records cabinet spawner -- Walk-through"
	density = FALSE

/obj/structure/filingcabinet/smart
	icon_state = "employmentcabinet"
	var/obj/item/paper/fluff/info/desired_type
	var/filled = FALSE // just in case we fail to get filled by the ticker at round-start, lets not screw over people

/obj/structure/filingcabinet/smart/interact(mob/user)
	if(!filled)
		message_admins("Records cabinet failed to fill at round-start, filling due to being touched by ([user])")
		spawn_records()

	return ..()

/obj/structure/filingcabinet/smart/proc/spawn_records()
	if(isnull(SSticker.mode))
		CRASH("(proc/spawn_records) called on ([src]) whilst gamemode is null!")

	var/datum/game_mode/management/gamemode = SSticker.mode
	filled = TRUE

	var/list/queue = subtypesof(desired_type)
	for(var/obj/item/paper/fluff/info/paper as anything in queue)
		if(desired_type == /obj/item/paper/fluff/info/tool) // skip the queue
			new paper(src)
			continue

		if(isnull(paper.abno_type)) // Most likelly a parent, that or someone fucked up
			message_admins("A records paper attempted to spawn, but failed due to not having an abnormality assigned ([paper])")
			continue

		var/paper_origin = paper.abno_type.abnormality_origin
		for(var/allowed_abnormalities in gamemode.abno_types)
			if(allowed_abnormalities == paper_origin)
				new paper(src)
				break

/**
 * closets filled with their respective papers, consider using mapping helpers, please
 */

/obj/structure/filingcabinet/smart/zayin
	name = "zayin abnormality information cabinet"
	desired_type = /obj/item/paper/fluff/info/zayin

/obj/structure/filingcabinet/smart/teth
	name = "teth abnormality information cabinet"
	desired_type = /obj/item/paper/fluff/info/teth

/obj/structure/filingcabinet/smart/he
	name = "he abnormality information cabinet"
	desired_type = /obj/item/paper/fluff/info/he

/obj/structure/filingcabinet/smart/waw
	name = "waw abnormality information cabinet"
	desired_type = /obj/item/paper/fluff/info/waw

/obj/structure/filingcabinet/smart/aleph
	name = "aleph abnormality information cabinet"
	desired_type = /obj/item/paper/fluff/info/aleph

/obj/structure/filingcabinet/smart/tool
	name = "tool abnormality information cabinet"
	desired_type = /obj/item/paper/fluff/info/tool

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
