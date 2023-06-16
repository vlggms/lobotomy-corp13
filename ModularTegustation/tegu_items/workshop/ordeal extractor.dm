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
		\nAlt-Click to start the machine.\nCrtl-Click to empty the machine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "smoke0"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	var/list/allowed_items = list(
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
	var/processing_time = 0
	var/processing_timer
	var/processing = FALSE

/obj/structure/ordeal_extractor/Initialize()
	. = ..()

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
		processing_time = processing_time_base * item_count/(1+0.2*(item_count - 1))
		to_chat(user, "<span class='notice'>\The [S] was dumped into [src]. [item_count] total items have been loaded.</span>")
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
	processing_time = processing_time_base / (1+0.2*(item_count - 1))
	to_chat(user, "<span class='notice'>\The [I] was loaded into [src]. [item_count] total items have been loaded.</span>")
	return TRUE

/obj/structure/ordeal_extractor/AltClick(mob/user)
	if(get_dist(user, src) > 1)
		to_chat(user, "<span class='danger'>You must be closer to interact with [src]!</span>")
		return FALSE
	return StartProcessing()

/obj/structure/ordeal_extractor/CtrlClick(mob/user)
	if(get_dist(user, src) > 1)
		to_chat(user, "<span class='danger'>You must be closer to interact with [src]!</span>")
		return FALSE
	if(processing)
		to_chat(user, "<span class='notice'>[src] is currently processing, you can't empty it!</span>")
		return FALSE
	return SpillContents(user)

/obj/structure/ordeal_extractor/proc/StartProcessing(mob/user)
	if(to_process.len < 1)
		to_chat(user, "span class='danger'>There's nothing in [src]!</span>")
		return FALSE
	if(processing)
		to_chat(user, "<span class='notice'>[src] is currently processing, you can't start it again?!</span>")
		return FALSE
	processing = TRUE
	processing_timer = addtimer(CALLBACK(src, .proc/ProcessContents), processing_time, TIMER_UNIQUE)
	icon_state = "smoke1"
	playsound(src, "sound/items/welder.ogg", 70)
	visible_message("<span class='nicegreen'>[src] has begun processing materials.</span>")
	return TRUE

/obj/structure/ordeal_extractor/proc/ProcessContents()
	var/drop_quality = 0
	for(var/I in to_process)
		if(to_process[I] > 30 && prob(-300+to_process[I]*10))
			LAZYREMOVEASSOC(to_process, I, 30)
			drop_quality = 3
		else if(to_process[I] > 20 && prob(-200+to_process[I]*10))
			LAZYREMOVEASSOC(to_process, I, 20)
			drop_quality = 2
		else if(to_process[I] > 10 && prob(-100+to_process[I]*10))
			LAZYREMOVEASSOC(to_process, I, 10)
			drop_quality = 1
		else
			LAZYREMOVEASSOC(to_process, I, 1)
		MakeDrop(I, drop_quality)
		break
	if(to_process)
		if(to_process.len > 0)
			playsound(src, "sound/items/welder.ogg", 70)
			processing_timer = addtimer(CALLBACK(src, .proc/ProcessContents), processing_time, TIMER_UNIQUE)
			return
	return FinishProcessing()

/obj/structure/ordeal_extractor/proc/MakeDrop(drop_type, drop_quality)
	var/obj/item/tresmetal/drop
	switch(drop_type)
		if(AMBER)
			drop = new AMBER_MAT(get_turf(src))
		if(VIOLET)
			drop = new VIOLET_MAT(get_turf(src))
		if(CRIMSON)
			drop = new CRIMSON_MAT(get_turf(src))
		if(INDIGO)
			drop = new INDIGO_MAT(get_turf(src))
		if(AMBER)
			drop = new AMBER_MAT(get_turf(src))
		if(PEOPLE)
			drop = new PEOPLE_MAT(get_turf(src))
		else
			return
	drop.SetQuality(drop_quality)
	visible_message("<span class='nicegreen'>[src] distills \a [drop]!</span>")
	return TRUE

/obj/structure/ordeal_extractor/proc/FinishProcessing()
	playsound(src, "sound/machines/terminal_success.ogg", 50)
	visible_message("<span class='nicegreen'>[src] has finished processing materials.</span>")
	processing_time = 0
	contents.Cut()
	processing = FALSE
	icon_state = "smoke0"
	return

/obj/structure/ordeal_extractor/proc/SpillContents()
	for(var/I in to_process)
		for(var/E = 1 to to_process[I])
			new I(get_turf(src))
	visible_message("<span class='notice'>[src] drops it's contents onto the ground.</span>")
	contents.Cut()
	to_process.Cut()
	return

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
