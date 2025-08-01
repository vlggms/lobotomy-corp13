/obj/machinery/conveyor/filter
	icon = 'icons/obj/recycling.dmi'
	icon_state = "filter_codersprite0"
	name = "conveyor point filter"
	desc = "A filter that checks for factory materials. Matches get sent north."
	var/filter_type = "ALL"
	var/filter_typepath = /obj/item/factoryitem
	var/filter_output_dir = NORTH
	var/lazyhackyoutputdir = WEST

/obj/machinery/conveyor/filter/update_move_direction()
	update()

/obj/machinery/conveyor/filter/update_icon_state()
	icon_state = "filter_codersprite[abs(operating)]"

/obj/machinery/conveyor/filter/proc/cycle_type_paths()
	switch(filter_typepath)
		if(/obj/item/factoryitem)
			filter_typepath = /obj/item/factoryitem/red
			color = "#ff0000"
			filter_type = "RED"
		if(/obj/item/factoryitem/red)
			filter_typepath = /obj/item/factoryitem/green
			color = "#00ff00"
			filter_type = "GREEN"
		if(/obj/item/factoryitem/green)
			filter_typepath = /obj/item/factoryitem/blue
			color = "#0000ff"
			filter_type = "BLUE"
		if(/obj/item/factoryitem/blue)
			filter_typepath = /obj/item/factoryitem/purple
			color = "#aa00ff"
			filter_type = "PURPLE"
		if(/obj/item/factoryitem/purple)
			filter_typepath = /obj/item/factoryitem/orange
			color = "#ffaa00"
			filter_type = "ORANGE"
		if(/obj/item/factoryitem/orange)
			filter_typepath = /obj/item/factoryitem/silver
			color = "#aaaaff"
			filter_type = "SILVER"
		if(/obj/item/factoryitem/silver)
			filter_typepath = /obj/item/factoryitem
			color = ""
			filter_type = "ALL"
	return filter_type

/obj/machinery/conveyor/filter/convey(list/affecting)
	for(var/am in affecting)
		if(!ismovable(am))
			continue
		var/atom/movable/movable_thing = am
		stoplag()
		if(QDELETED(movable_thing) || (movable_thing.loc != loc))
			continue
		if(iseffect(movable_thing) || isdead(movable_thing))
			continue
		if(isliving(movable_thing))
			var/mob/living/zoommob = movable_thing
			if((zoommob.movement_type & FLYING) && !zoommob.stat)
				continue
		if(!movable_thing.anchored && movable_thing.has_gravity())
			if(istype(movable_thing, filter_typepath))
				step(movable_thing, filter_output_dir)
			else
				step(movable_thing, lazyhackyoutputdir)
	conveying = FALSE

/obj/machinery/conveyor/filter/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_CROWBAR)
		user.visible_message("<span class='notice'>[user] struggles to pry up \the [src] with \the [I].</span>", \
		"<span class='notice'>You struggle to pry up \the [src] with \the [I].</span>")
		if(I.use_tool(src, user, 40, volume=40))
			if(!(machine_stat & BROKEN))
				var/obj/item/stack/conveyor_filter/C = new /obj/item/stack/conveyor_filter(loc, 1, TRUE, null, null, id)
				transfer_fingerprints_to(C)
			to_chat(user, "<span class='notice'>You remove the conveyor belt.</span>")
			qdel(src)

	else if(I.tool_behaviour == TOOL_WRENCH)
		if(!(machine_stat & BROKEN))
			I.play_tool_sound(src)
			//Rotate code here lol
			var/newcolor = cycle_type_paths()
			to_chat(user, "<span class='notice'>You cycle the filter type. It now filters for [newcolor].</span>")

	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(!(machine_stat & BROKEN))
			I.play_tool_sound(src)
			//Direction reverse code here lol
			to_chat(user, "<span class='notice'>Sorry not implemented yet :-)</span>")

	else if(user.a_intent != INTENT_HARM)
		user.transferItemToLoc(I, drop_location())

	// TODO: probably a good idea to add multitool support & tgui, esp. for changing ratios

	else
		return ..()

/obj/item/stack/conveyor_filter
	name = "conveyor filter assembly"
	desc = "A conveyor filter assembly."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "filter_construct"
	max_amount = 30
	singular_name = "conveyor filter"
	w_class = WEIGHT_CLASS_BULKY
	merge_type = /obj/item/stack/conveyor_filter
	var/id = ""

/obj/item/stack/conveyor_filter/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity || user.stat || !isfloorturf(A) || istype(A, /area/shuttle))
		return
	var/cdir = get_dir(A, user)
	if(A == user.loc)
		to_chat(user, "<span class='warning'>You cannot place a conveyor filter under yourself!</span>")
		return
	var/obj/machinery/conveyor/filter/C = new(A, cdir, id)
	transfer_fingerprints_to(C)
	use(1)

/obj/item/stack/conveyor_filter/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/conveyor_switch_construct))
		to_chat(user, "<span class='notice'>You link the switch to the conveyor filter assembly.</span>")
		var/obj/item/conveyor_switch_construct/C = I
		id = C.id
