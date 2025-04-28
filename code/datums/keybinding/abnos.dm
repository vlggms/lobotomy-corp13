/datum/keybinding/derf
	category = CATEGORY_DERF

/datum/keybinding/derf/der_freischutz_portal_view
	hotkey_keys = list("Space") // PAGEUP
	name = "der_freischutz_portal_view"
	full_name = "Der Freischutz Portal View"
	description = "Der Freischutz Portal View"
	keybind_signal = COMSIG_KB_MOB_DER_FREISCHUTZ_PORTAL_VIEW

/datum/keybinding/derf/der_freischutz_portal_view/down(client/user)
	. = ..()
	if(.)
		return
	if (!istype(user.mob, /mob/living/simple_animal/hostile/abnormality/der_freischutz))
		return
	var/mob/living/simple_animal/hostile/abnormality/der_freischutz/M = user.mob
	M.TriggerPortalView()
	return TRUE

/datum/keybinding/derf/der_freischutz_portal_remove
	hotkey_keys = list("E") // PAGEUP
	name = "der_freischutz_portal_remove"
	full_name = "Der Freischutz Portal Remove"
	description = "Der Freischutz Portal Remove"
	keybind_signal = COMSIG_KB_MOB_DER_FREISCHUTZ_PORTAL_REMOVE

/datum/keybinding/derf/der_freischutz_portal_remove/down(client/user)
	. = ..()
	if(.)
		return
	if (!istype(user.mob, /mob/living/simple_animal/hostile/abnormality/der_freischutz))
		return
	var/mob/living/simple_animal/hostile/abnormality/der_freischutz/M = user.mob
	M.TriggerPortalRemove()
	return TRUE

/datum/keybinding/blueshep
	category = CATEGORY_BLUESHEP

/datum/keybinding/blueshep/blue_shepherd_dodge
	hotkey_keys = list("Space") // PAGEUP
	name = "blue_shepherd_dodge"
	full_name = "Blue Shepherd Dodge"
	description = "Blue Shepherd Dodge"
	keybind_signal = COMSIG_KB_MOB_BLUE_SHEPHERD_DODGE

/datum/keybinding/blueshep/blue_shepherd_dodge/down(client/user)
	. = ..()
	if(.)
		return
	if (!istype(user.mob, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		return
	var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/M = user.mob
	M.TriggerDodge()
	return TRUE

/datum/keybinding/blueshep/blue_shepherd_counter
	hotkey_keys = list("E") // PAGEUP
	name = "mob_blue_shepherd_counter"
	full_name = "Blue Shepherd Counter"
	description = "Blue Shepherd Counter"
	keybind_signal = COMSIG_KB_MOB_BLUE_SHEPHERD_COUNTER

/datum/keybinding/blueshep/blue_shepherd_counter/down(client/user)
	. = ..()
	if(.)
		return
	if (!istype(user.mob, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		return

	var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/M = user.mob
	M.TriggerCounter()
	return TRUE

/datum/keybinding/fragment
	category = CATEGORY_FRAGMENT

/datum/keybinding/fragment/fragment_song
	hotkey_keys = list("Space")
	name = "fragment_song"
	full_name = "Fragment Song"
	description = "Fragment Song"
	keybind_signal = COMSIG_KB_MOB_FRAGMENT_SONG

/datum/keybinding/fragment/fragment_song/down(client/user)
	. = ..()
	if(.)
		return
	if (!istype(user.mob, /mob/living/simple_animal/hostile/abnormality/fragment))
		return

	var/mob/living/simple_animal/hostile/abnormality/fragment/M = user.mob
	M.TriggerSong()
	return TRUE
