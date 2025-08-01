/obj/machinery/conveyor/splitter
	icon = 'icons/obj/recycling.dmi'
	icon_state = "splitter0"
	name = "conveyor splitter"
	desc = "A round-robin conveyor splitter. Equally distributes items between enabled directions. \nUse a wrench to change its north/south outputs and a screwdriver to change its east/west outputs."
	var/directions = 0 // Bitflag N S E W format, eg. SE (technically ES) is 0110 or 6
	// WESN (MSB) NSEW (LSB) because BYOND fucking sucks
	// dmi states are SNEW/DURL??????????
	var/next_direction = 0
	// N S E W; How many percent of a time the direction should actually move when picked
	// Since I'm lazy, this is a POOR approximation for weighted things
	// If you need proper ratios, use belt balancers from Factorio lol
	// Off by default
	var/list/ratio = list(50, 50, 50, 50)
	var/deterministic = TRUE // Set to FALSE to use the above

/obj/machinery/conveyor/splitter/proc/advance_direction()
	if(next_direction == 3)
		next_direction = 0
	else
		next_direction++

/obj/machinery/conveyor/splitter/proc/toggle_northsouth()
	// 0 -> N -> NS -> S -> 0
	// 0 -> 1 -> 3 -> 2 -> 0
	var/ns = directions & 3

	switch(ns)
		if(0)
			directions = directions ^ 1
		if(1)
			directions = directions ^ 2
		if(2)
			directions = directions ^ 2
		if(3)
			directions = directions ^ 1

	update_icon_state()

/obj/machinery/conveyor/splitter/proc/toggle_eastwest()
	// 0 -> E -> EW -> W -> 0
	// 0 -> 4 -> 12 -> 8 -> 0
	var/ew = directions & 12

	switch(ew)
		if(0)
			directions = directions ^ 4
		if(4)
			directions = directions ^ 8
		if(8)
			directions = directions ^ 8
		if(12)
			directions = directions ^ 4

	update_icon_state()

/obj/machinery/conveyor/splitter/update_move_direction()
	update()

/obj/machinery/conveyor/splitter/update_icon_state()
	var/bits = count_set_bits_decimal(directions)
	icon_state = "splitter[abs(operating)][bits]"

	switch(bits)
		if(4,0)
			setDir(SOUTH) // default, somehow
		if(3)
			setDir(directions^15)
		if(2)
			if(directions == 3) setDir(SOUTH)
			else if(directions == 12) setDir(EAST)
			else setDir(directions)
		if(1)
			setDir(directions)

/obj/machinery/conveyor/splitter/convey(list/affecting)
	if(directions == 0)
		conveying = FALSE
		return
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
			var/moved = FALSE
			while(!moved)
				if(directions & 2 ** next_direction)
					if(!deterministic)
						if(prob(ratio[next_direction+1]))
							advance_direction()
							continue
					step(movable_thing, 2 ** next_direction)
					moved = TRUE
				advance_direction()
	conveying = FALSE

/obj/machinery/conveyor/splitter/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_CROWBAR)
		user.visible_message("<span class='notice'>[user] struggles to pry up \the [src] with \the [I].</span>", \
		"<span class='notice'>You struggle to pry up \the [src] with \the [I].</span>")
		if(I.use_tool(src, user, 40, volume=40))
			if(!(machine_stat & BROKEN))
				var/obj/item/stack/conveyor_splitter/C = new /obj/item/stack/conveyor_splitter(loc, 1, TRUE, null, null, id)
				transfer_fingerprints_to(C)
			to_chat(user, "<span class='notice'>You remove the conveyor belt.</span>")
			qdel(src)

	else if(I.tool_behaviour == TOOL_WRENCH)
		if(!(machine_stat & BROKEN))
			I.play_tool_sound(src)
			toggle_northsouth()
			to_chat(user, "<span class='notice'>You toggle the north-south output of [src].</span>")

	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(!(machine_stat & BROKEN))
			I.play_tool_sound(src)
			toggle_eastwest()
			to_chat(user, "<span class='notice'>You toggle the east-west output of [src].</span>")

	else if(user.a_intent != INTENT_HARM)
		user.transferItemToLoc(I, drop_location())

	// TODO: probably a good idea to add multitool support & tgui, esp. for changing ratios

	else
		return ..()

/obj/machinery/conveyor/splitter/attack_hand(mob/user)
	. = ..()
	if(.)
		return

/obj/item/stack/conveyor_splitter
	name = "conveyor splitter assembly"
	desc = "A conveyor splitter assembly."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "splitter_construct"
	max_amount = 30
	singular_name = "conveyor splitter"
	w_class = WEIGHT_CLASS_BULKY
	merge_type = /obj/item/stack/conveyor_splitter
	var/id = ""

/obj/item/stack/conveyor_splitter/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity || user.stat || !isfloorturf(A) || istype(A, /area/shuttle))
		return
	var/cdir = get_dir(A, user)
	if(A == user.loc)
		to_chat(user, "<span class='warning'>You cannot place a conveyor splitter under yourself!</span>")
		return
	var/obj/machinery/conveyor/splitter/C = new(A, cdir, id)
	transfer_fingerprints_to(C)
	use(1)

/obj/item/stack/conveyor_splitter/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/conveyor_switch_construct))
		to_chat(user, "<span class='notice'>You link the switch to the conveyor splitter assembly.</span>")
		var/obj/item/conveyor_switch_construct/C = I
		id = C.id
