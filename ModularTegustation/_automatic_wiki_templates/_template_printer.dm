/obj/structure/template_printer
	name = "Holographic training beacon"
	desc = "A nanotrasen approved beacon, you can insert megafauna tokens into it to practise fighting megafauna. Some rumors say you can insert gems into it too..."
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

/datum/action/generate_test_EGO
	name = "Generate a wiki entry for the training bunny EGO to test out generation"

/datum/action/generate_EGO
	name = "Generate a wiki entry for every single EGO weapon"

/obj/structure/template_printer/attack_hand(mob/user)
	. = ..()
	var/names = list()
	for(var/datum/action/thing as anything in selectable_modes) // lets show their names instead of raw datums
		names += initial(thing.name)

	var/choice = tgui_input_list(user, message = "Select the mode",  title = "Automatic wiki printer", buttons = names) // make it into TGUI, because TGUI > UI
	if(isnull(choice))
		visible_message("<span class='notice'>ERROR: no choice selected!</span>")
		return

	for(var/datum/action/thing as anything in selectable_modes) // convert it back to datums from names, just because names are so long
		if(initial(thing.name) == choice)
			choice = thing

	switch(choice)
		if(/datum/action/generate_test_EGO)
			generate_test_EGO()
		if(/datum/action/generate_EGO)
			generate_all_EGO()

/obj/structure/template_printer/proc/generate_test_EGO()
	visible_message("<span class='notice'>[src] starts generating a test wiki template...</span>")
	playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
	var/wiki = test_generate_ego_weapons()
	visible_message("<span class='notice'>[src] finished generation!</span>")
	if(wiki == null)
		CRASH("oh god, wiki returned null. THIS IS VERY BAD")
	visible_message("<span class='notice'>[wiki]</span>")

/obj/structure/template_printer/proc/generate_all_EGO()
	visible_message("<span class='notice'>[src] starts generating literally every single EGO weapon wiki in existance...</span>")
	playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
	var/wiki = generate_ego_weapons()
	visible_message("<span class='notice'>[src] finished generation!</span>")
	if(wiki == null)
		CRASH("oh god, wiki returned null. THIS IS VERY BAD")
	visible_message("<span class='notice'>[wiki]</span>")
