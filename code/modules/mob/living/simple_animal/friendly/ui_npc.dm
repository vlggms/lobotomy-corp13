/mob/living/simple_animal/ui_npc
    name = "Talking Creature"
    icon = 'icons/mob/animal.dmi'
    icon_state = "goat"
    density = TRUE

    var/greeting = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

// Called to supply dynamic data to the UI.
/mob/living/simple_animal/ui_npc/ui_data(mob/user)
	return list("title" = name, "text" = greeting)

// Called to supply static data that seldom changes.
/mob/living/simple_animal/ui_npc/ui_static_data(mob/user)
	return list()

// Called when a user performs an action in the UI.
/mob/living/simple_animal/ui_npc/ui_act(action, data, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "talk")
		greeting += "\nThe creature continues: '...and another thing!'"
		return TRUE
	else if(action == "pet")
		greeting += "\nIt purrs softly."
		return TRUE
	else if(action == "close")
		// Closing handled by UI system; no changes needed here.
		return TRUE
	return FALSE

// Defines how the UI should currently behave.
// Usually returns UI_INTERACTIVE when ready.
/mob/living/simple_animal/ui_npc/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

    // Called when the UI closes.
/mob/living/simple_animal/ui_npc/ui_close(mob/user)
	// Perform any cleanup if necessary.
	return

// Called periodically if autoupdate=TRUE. If you need periodic refreshes, do them here.
/mob/living/simple_animal/ui_npc/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpeakingNpc")
		ui.open()

/mob/living/simple_animal/ui_npc/attack_hand(mob/living/carbon/user)
	. = ..()
	if(!user || !user.client)
		return
	ui_interact(user)

/mob/living/simple_animal/ui_npc/attackby(obj/item/O, mob/user, params)
	. = ..()
	if(!user || !user.client)
		return
	ui_interact(user)
