// Music armor - Based on jukebox implementation for proper music playback
/obj/item/clothing/suit/armor/ego_gear/city/music_armor
	name = "melodic armor"
	desc = "An experimental armor that can broadcast music to nearby listeners."
	icon_state = "capo"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 0,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)
	
	// Music configuration
	var/music_file = 'sound/ambience/ambicha3.ogg'
	var/music_volume = 50
	var/music_range = 10
	var/music_length = 600 // Length in deciseconds (60 seconds default)
	var/music_loop = FALSE // Whether to loop the music
	
	// Internal state
	var/active = FALSE
	var/stop = 0
	var/list/rangers = list() // Players currently hearing the music

/obj/item/clothing/suit/armor/ego_gear/city/music_armor/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/AS = new /obj/effect/proc_holder/ability/music_toggle
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/city/music_armor/Destroy()
	music_stop()
	. = ..()

/obj/item/clothing/suit/armor/ego_gear/city/music_armor/dropped(mob/user)
	music_stop()
	. = ..()

/obj/item/clothing/suit/armor/ego_gear/city/music_armor/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_OCLOTHING)
		music_stop()

/obj/item/clothing/suit/armor/ego_gear/city/music_armor/proc/music_start()
	if(active)
		return
	
	var/mob/living/wearer = loc
	if(!istype(wearer))
		return
	
	active = TRUE
	stop = world.time + music_length
	START_PROCESSING(SSobj, src)
	to_chat(wearer, span_notice("Music activated. Will play for [music_length/10] seconds."))

/obj/item/clothing/suit/armor/ego_gear/city/music_armor/proc/music_stop()
	if(!active)
		return
	
	for(var/mob/M in rangers)
		if(!M || !M.client)
			continue
		M.stop_sound_channel(CHANNEL_JUKEBOX)
	rangers = list()
	active = FALSE
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/suit/armor/ego_gear/city/music_armor/process()
	var/mob/living/wearer = loc
	if(!istype(wearer) || wearer.get_item_by_slot(ITEM_SLOT_OCLOTHING) != src)
		music_stop()
		return
	
	if(world.time < stop && active)
		// Add new listeners - using wearer's location
		for(var/mob/M in view(music_range, wearer))
			if(!M.client || !(M.client.prefs.toggles & SOUND_INSTRUMENTS))
				continue
			if(!(M in rangers))
				rangers[M] = TRUE
				M.playsound_local(get_turf(M), music_file, music_volume, channel = CHANNEL_JUKEBOX, use_reverb = FALSE)
				to_chat(M, span_notice("Now playing music from [src]."))
		
		// Remove distant listeners
		for(var/mob/M in rangers)
			if(get_dist(src, M) > music_range)
				rangers -= M
				if(!M || !M.client)
					continue
				M.stop_sound_channel(CHANNEL_JUKEBOX)
	else if(active)
		// Music finished
		if(music_loop)
			// Restart the music
			stop = world.time + music_length
			// Clear rangers to force re-playing for everyone
			rangers = list()
			to_chat(wearer, span_notice("Music looping..."))
		else
			// Stop the music
			music_stop()
			playsound(src, 'sound/machines/terminal_off.ogg', 25, TRUE)

// Music toggle ability
/obj/effect/proc_holder/ability/music_toggle
	name = "Toggle Music"
	desc = "Toggle your armor's music broadcast on or off."
	action_icon = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "spell_default"
	base_icon_state = "spell_default"
	cooldown_time = 2 SECONDS

/obj/effect/proc_holder/ability/music_toggle/Perform(target, mob/user)
	if(!ishuman(user))
		return ..()
	
	var/mob/living/carbon/human/H = user
	var/obj/item/clothing/suit/armor/ego_gear/city/music_armor/armor = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!armor || !istype(armor))
		return ..()
	
	if(armor.active)
		armor.music_stop()
		to_chat(user, span_notice("You deactivate the music broadcast."))
	else
		armor.music_start()
		to_chat(user, span_notice("You activate the music broadcast."))
	
	return ..()

// Example variants

// Jazz variant - smooth and quiet
/obj/item/clothing/suit/armor/ego_gear/city/music_armor/jazz
	name = "jazz ensemble suit"
	desc = "A sophisticated suit that plays smooth jazz to those nearby."
	music_file = 'sound/ambience/ambinice.ogg'
	music_volume = 30
	music_range = 7
	music_length = 300 // 30 seconds

// Battle variant - loud combat music that loops
/obj/item/clothing/suit/armor/ego_gear/city/music_armor/battle
	name = "war drummer's armor"
	desc = "Heavy armor that broadcasts inspiring battle music."
	music_file = 'sound/ambience/ambidanger.ogg'
	music_volume = 60
	music_range = 15
	music_length = 450 // 45 seconds
	music_loop = TRUE // Battle music loops!

// Meditation variant - calming music
/obj/item/clothing/suit/armor/ego_gear/city/music_armor/meditation
	name = "meditation robes"
	desc = "Peaceful robes that broadcast a calming melody."
	music_file = 'sound/ambience/ambiholy.ogg'
	music_volume = 25
	music_range = 5
	music_length = 200 // 20 seconds

// Custom variant for your own music files
/obj/item/clothing/suit/armor/ego_gear/city/music_armor/custom
	name = "custom music armor"
	desc = "An armor that plays custom music files."
	// Set these variables to your custom music
	music_file = 'sound/ambience/ambicha3.ogg' // Change to your file
	music_length = 600 // Set to your music's length in deciseconds (1 second = 10 deciseconds)
	music_volume = 40
	music_range = 10
	music_loop = FALSE // Set to TRUE if you want it to loop

// Looping ambient variant
/obj/item/clothing/suit/armor/ego_gear/city/music_armor/ambient_loop
	name = "ambient broadcaster"
	desc = "An armor that continuously broadcasts ambient music."
	music_file = 'sound/ambience/ambigen1.ogg'
	music_length = 150 // 15 seconds
	music_volume = 35
	music_range = 8
	music_loop = TRUE // Continuous ambient music
