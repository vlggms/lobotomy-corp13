/obj/structure/template_printer
	name = "Wiki template printer"
	desc = "A printer that creates code to be inserted into the wiki, go look at something else why dont ya?"
	icon = 'icons/obj/cardboard_cutout.dmi'
	icon_state = "cutout_basic"
	layer = ABOVE_ALL_MOB_LAYER
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	density = TRUE

	var/list/selectable_modes = list(
		/datum/action/generate_test_EGO,
		/datum/action/generate_EGO,
	)

// specify the datums and names here, they are purelly here so we can give them a proper name in the TGUI menu.
/datum/action/generate_test_EGO
	name = "Generate a wiki entry for the training bunny EGO to test out generation"

/datum/action/generate_EGO
	name = "Generate a wiki entry for every single EGO weapon"

/obj/structure/template_printer/attack_hand(mob/user) // touch it with your gentle hand, and get 40000 lines of text in return
	. = ..()
	var/names = list()
	for(var/datum/action/thing as anything in selectable_modes) // lets show their names instead of raw datums
		names += initial(thing.name)

	var/choice = tgui_input_list(user, message = "Select the mode",  title = "Automatic wiki printer", buttons = names) // make it into TGUI, because TGUI > UI
	if(isnull(choice))
		visible_message(span_notice("ERROR: no choice selected!"))
		return

	for(var/datum/action/thing as anything in selectable_modes) // convert it back to datums from names, just because names are so long
		if(initial(thing.name) == choice)
			choice = thing

	visible_message(span_notice("[src] starts generating a test wiki template..."))
	switch(choice) // and then use those datums to select an action we will wanna do
		if(/datum/action/generate_test_EGO)
			generate_test_EGO()
		if(/datum/action/generate_EGO)
			generate_all_EGO()

/obj/structure/template_printer/proc/generate_test_EGO()
	var/wiki = test_generate_ego_weapons()
	visible_message(span_notice("[src] finished generation!"))
	if(wiki == null)
		CRASH("oh god, wiki returned null. This in fact is not good")
	visible_message(span_notice("[wiki]"))
	playsound(src, 'sound/machines/ping.ogg', 15, TRUE)

/obj/structure/template_printer/proc/generate_all_EGO()
	var/wiki = generate_ego_weapons()
	visible_message(span_notice("[src] finished generation!"))
	if(wiki == null)
		CRASH("oh god, wiki returned null. This in fact is not good")
	visible_message(span_notice("[wiki]"))
	playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
