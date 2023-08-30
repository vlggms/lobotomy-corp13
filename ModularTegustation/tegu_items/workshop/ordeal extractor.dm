#define TRES /obj/item/tresmetal
#define CRIMSON /obj/item/food/meat/slab/crimson
#define CRIMSON_MAT /obj/item/tresmetal/crimson
#define VIOLET /obj/item/food/meat/slab/fruit
#define VIOLET_MAT /obj/item/tresmetal/violet
#define PEOPLE /obj/item/food/meat/slab/human
#define PEOPLE_MAT /obj/item/tresmetal/human
#define GREEN /obj/item/food/meat/slab/robot
#define GREEN_MAT /obj/item/tresmetal/green
#define INDIGO /obj/item/food/meat/slab/sweeper
#define INDIGO_MAT /obj/item/tresmetal/indigo
#define AMBER /obj/item/food/meat/slab/worm
#define AMBER_MAT /obj/item/tresmetal/amber

/obj/structure/ordeal_extractor
	name = "tres association material extractor"
	desc = "A device made by the Tres Association to extract materials from irregular 'organic' material. \
		\nMultiple of the same material has a chance to produce better quality materials.\
		\nAlt-Click to start the machine.\nCtrl-Click to empty the machine in manageable boxes."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "smoke0"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	var/list/allowed_items = list(
		TRES,
		CRIMSON,
		VIOLET,
		PEOPLE,
		GREEN,
		INDIGO,
		AMBER,
		CRIMSON_MAT,
		VIOLET_MAT,
		PEOPLE_MAT,
		GREEN_MAT,
		INDIGO_MAT,
		AMBER_MAT
	)

	var/list/to_process = list()

	var/processing_time_base = 20
	var/processing_timer
	var/processing = FALSE

/obj/structure/ordeal_extractor/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Hit with a storage item to dump all items in it into the machine.</span>"

/obj/structure/ordeal_extractor/attacked_by(obj/item/I, mob/living/user)
	if(user.a_intent != INTENT_HELP)
		return ..()
	if(processing)
		to_chat(user, "<span class='notice'>[src] is currently processing, you can't add anything into it!</span>")
		return ..()

	var/item_count = 0

	if(istype(I, /obj/item/storage)) // Code for storage dumping
		var/obj/item/storage/S = I
		for(var/obj/item in S)
			if(!(item.type in allowed_items))
				continue
			if(istype(item, /obj/item/tresmetal))
				var/obj/item/tresmetal/mat = item
				if(!(mat.resource_type in allowed_items))
					continue
				var/add_amount = 1
				if(mat.quality)
					add_amount = 10*mat.quality
				if(SEND_SIGNAL(S, COMSIG_TRY_STORAGE_TAKE, mat, src))
					LAZYADDASSOC(to_process, mat.resource_type, add_amount)
				continue
			if(SEND_SIGNAL(S, COMSIG_TRY_STORAGE_TAKE, item, src))
				LAZYADDASSOC(to_process, item.type, 1)
		for(var/list_item in to_process)
			item_count += to_process[list_item]
		to_chat(user, "<span class='notice'>\The [S] was dumped into [src]. [item_count] total items have been loaded.</span>")
		playsound(I, "rustle", 50, TRUE, -5)
		if(istype(S, /obj/item/storage/box/materials_disposable))
			S.emptyStorage() // If SOMEHOW unvalid materials got in
			qdel(S)
		return TRUE

	if(!(I.type in allowed_items))
		to_chat(user, "<span class='danger'>[src] can't proccess [I]!</span>")
		return ..()

	if(!user.transferItemToLoc(I, src))
		to_chat(user, "<span class='warning'>\The [I] is stuck to your hand!</span>")
		return FALSE


	if(istype(I, /obj/item/tresmetal))
		var/obj/item/tresmetal/mat = I
		if(!(mat.resource_type in allowed_items))
			return ..()
		var/add_amount = 1
		if(mat.quality)
			add_amount = 10*mat.quality
		LAZYADDASSOC(to_process, mat.resource_type, add_amount)
	else
		LAZYADDASSOC(to_process, I.type, 1)


	for(var/list_item in to_process)
		item_count += to_process[list_item]
	to_chat(user, "<span class='notice'>\The [I] was loaded into [src]. [item_count] total items have been loaded.</span>")
	return TRUE

/obj/structure/ordeal_extractor/AltClick(mob/user)
	if(get_dist(user, src) > 1)
		to_chat(user, "<span class='danger'>You must be closer to interact with [src]!</span>")
		return FALSE
	var/list/material_list = list()
	var/M = input(user,"What would you like to create?","Select Material") as null|anything in GetMaterials(material_list)
	if(!M)
		return FALSE
	return StartProcessing(user, LAZYACCESSASSOC(material_list, M, 1), LAZYACCESSASSOC(material_list, M, 2))

/obj/structure/ordeal_extractor/proc/GetMaterials(list/materials = list())
	. = materials
	for(var/I in to_process)
		var/quantity = to_process[I]
		if(quantity <= 0)
			continue
		var/name = " tressium"
		var/material = TRES
		switch(I)
			if(CRIMSON)
				name = " honkium"
				material = CRIMSON
			if(VIOLET)
				name = " fractured potentium"
				material = VIOLET
			if(PEOPLE)
				name = "... oh no"
				material = PEOPLE
			if(GREEN)
				name = " sentium"
				material = GREEN
			if(INDIGO)
				name = " sweepium"
				material = INDIGO
			if(AMBER)
				name = " hungium"
				material = AMBER
		LAZYADDASSOC(., "inferior[name]", list(material, 0))
		if(quantity >= 10)
			LAZYADDASSOC(., "standard[name]", list(material, 1))
		if(quantity >= 20)
			LAZYADDASSOC(., "potent[name]", list(material, 2))
		if(quantity >= 30)
			LAZYADDASSOC(., "dense[name]", list(material, 3))

	return

/obj/structure/ordeal_extractor/CtrlClick(mob/user)
	if(get_dist(user, src) > 1)
		to_chat(user, "<span class='danger'>You must be closer to interact with [src]!</span>")
		return FALSE
	if(processing)
		to_chat(user, "<span class='notice'>[src] is currently processing, you can't empty it!</span>")
		return FALSE
	return SpillContents(user)

/obj/structure/ordeal_extractor/proc/StartProcessing(mob/user, material_type, quality)
	if(to_process.len < 1)
		to_chat(user, "span class='danger'>There's nothing in [src]!</span>")
		return FALSE
	if(processing)
		to_chat(user, "<span class='notice'>[src] is currently processing, you can't start it again?!</span>")
		return FALSE
	processing = TRUE
	processing_timer = addtimer(CALLBACK(src, .proc/ProcessContents, material_type, quality), processing_time_base, TIMER_UNIQUE)
	icon_state = "smoke1"
	playsound(src, "sound/items/welder.ogg", 70)
	visible_message("<span class='nicegreen'>[src] has begun processing materials.</span>")
	return TRUE

/obj/structure/ordeal_extractor/proc/ProcessContents(material_type, quality)
	var/take_count = quality > 0 ? quality * 10 : 1
	if(to_process[material_type] - take_count < 0)
		say("Tried to remove [take_count] from [to_process[material_type]] items.")
		playsound(src, 'sound/machines/terminal_error.ogg', 70)
		return FinishProcessing()

	to_process[material_type] = to_process[material_type] - take_count

	MakeDrop(material_type, quality)

	for(var/obj/item/I in contents)
		if(istype(I, material_type))
			contents.Remove(I)
			take_count--
		if(take_count <= 0)
			break

	if(take_count > 0)
		WARNING("Not enough instances of [material_type] in Ordeal Extractor to pay for item.")

	if(to_process[material_type] <= 0)
		to_process -= material_type

	playsound(src, "sound/items/welder.ogg", 70)
	sleep(5)
	return FinishProcessing()

/obj/structure/ordeal_extractor/proc/MakeDrop(drop_type, drop_quality)
	var/obj/item/tresmetal/drop
	switch(drop_type)
		if(CRIMSON)
			drop = new CRIMSON_MAT(get_turf(src))
		if(VIOLET)
			drop = new VIOLET_MAT(get_turf(src))
		if(PEOPLE)
			drop = new PEOPLE_MAT(get_turf(src))
		if(GREEN)
			drop = new GREEN_MAT(get_turf(src))
		if(INDIGO)
			drop = new INDIGO_MAT(get_turf(src))
		if(AMBER)
			drop = new AMBER_MAT(get_turf(src))
		else
			drop = new drop_type(get_turf(src))
	drop.SetQuality(drop_quality)
	visible_message("<span class='nicegreen'>[src] distills \a [drop]!</span>")
	return TRUE

/obj/structure/ordeal_extractor/proc/FinishProcessing()
	playsound(src, "sound/machines/terminal_success.ogg", 50)
	visible_message("<span class='nicegreen'>[src] has finished processing materials.</span>")
	processing = FALSE
	icon_state = "smoke0"
	return

/obj/structure/ordeal_extractor/proc/SpillContents()
	if(!LAZYLEN(contents))
		return
	var/obj/item/storage/box/materials_disposable/MD = new(get_turf(src))
	var/datum/component/storage/ST = MD.GetComponent(/datum/component/storage)
	for(var/I in to_process)
		for(var/E = 1 to to_process[I])
			var/obj/item/D = new I(get_turf(src))
			if(ST.can_be_inserted(D, TRUE, null)) // Try to put in the current one
				ST.handle_item_insertion(D, TRUE, null)
				continue
			MD = new(get_turf(src)) // Make a new one if full
			ST = MD.GetComponent(/datum/component/storage)
			ST.handle_item_insertion(D, TRUE, null)
	visible_message("<span class='notice'>[src] drops it's contents onto the ground.</span>")
	contents.Cut()
	to_process.Cut()
	return

/obj/item/storage/box/materials_disposable
	name = "temporary material storage box"
	desc = "a box designed to hold forging materials"
	foldable = FALSE

/obj/item/storage/box/materials_disposable/Initialize(mapload)
	. = ..()
	var/datum/component/storage/ST = GetComponent(/datum/component/storage)
	ST.can_hold = list()
	ST.can_hold.Add(
		typecacheof(TRES),
		typecacheof(CRIMSON),
		typecacheof(VIOLET),
		typecacheof(PEOPLE),
		typecacheof(GREEN),
		typecacheof(INDIGO),
		typecacheof(AMBER),
		)
	ST.max_w_class = WEIGHT_CLASS_BULKY
	ST.max_combined_w_class = 80 // Max 20 Bulky Items
	ST.max_items = 21 // Rows of 7, so 21 for 3 rows.
	ST.click_gather = TRUE


#undef TRES
#undef CRIMSON
#undef CRIMSON_MAT
#undef VIOLET
#undef VIOLET_MAT
#undef PEOPLE
#undef PEOPLE_MAT
#undef GREEN
#undef GREEN_MAT
#undef INDIGO
#undef INDIGO_MAT
#undef AMBER
#undef AMBER_MAT
