// Villains of the Night game items

/obj/item/villains
	name = "game item"
	desc = "An item used in the Villains of the Night game."
	icon = 'icons/obj/device.dmi'
	icon_state = "tablet"
	
	var/action_type = VILLAIN_ACTION_TYPELESS
	var/action_cost = VILLAIN_ACTION_MAIN
	var/freshness = VILLAIN_ITEM_FRESH
	var/evidence_color = "#FFFF00" // Yellow for investigation phase
	
	// Visual indicators
	var/mutable_appearance/outline_overlay

/obj/item/villains/Initialize()
	. = ..()
	update_outline()

/obj/item/villains/proc/update_outline()
	cut_overlays()
	if(freshness == VILLAIN_ITEM_FRESH)
		outline_overlay = mutable_appearance(icon, "[icon_state]_outline")
		outline_overlay.color = "#00FF00" // Green outline for fresh items
		add_overlay(outline_overlay)
	else if(freshness == VILLAIN_ITEM_USED)
		outline_overlay = mutable_appearance(icon, "[icon_state]_outline")
		outline_overlay.color = evidence_color
		add_overlay(outline_overlay)

/obj/item/villains/proc/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	freshness = VILLAIN_ITEM_USED
	update_outline()
	return TRUE

/obj/item/villains/pickup(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		// Check fresh item limit
		if(freshness == VILLAIN_ITEM_FRESH)
			var/fresh_count = 0
			for(var/obj/item/villains/I in H.contents)
				if(I.freshness == VILLAIN_ITEM_FRESH)
					fresh_count++
			if(fresh_count > VILLAIN_MAX_FRESH_ITEMS)
				to_chat(H, span_warning("You can only carry [VILLAIN_MAX_FRESH_ITEMS] fresh items at a time!"))
				H.dropItemToGround(src)

// Investigative Items

/obj/item/villains/enkephalin_detector
	name = "Enkephalin Detector"
	desc = "Learn your target's targets for their main and secondary actions."
	icon_state = "analyzer"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/enkephalin_detector/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE
	// TODO: Reveal target's action targets
	to_chat(user, span_notice("You scan [target] with the Enkephalin Detector..."))
	return TRUE

/obj/item/villains/deepscan_kit
	name = "'DEEPSCAN' Kit"
	desc = "Learn your target's main and secondary actions."
	icon_state = "health_analyzer"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/drain_monitor
	name = "Drain Monitor"
	desc = "Learn everyone who targeted your target."
	icon_state = "scanner"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/rangefinder
	name = "Keen-Sense Rangefinder"
	desc = "Learn all of the actions that targeted your target."
	icon_state = "pinpointer"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/binoculars
	name = "Binoculars"
	desc = "Learn the target's inventory."
	icon_state = "binoculars"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/command_projector
	name = "Command Projector"
	desc = "Send a short message to a player (max 100 characters)."
	icon_state = "radio"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_SECONDARY

// Protective Items

/obj/item/villains/forcefield_projector
	name = "Forcefield Projector"
	desc = "Target becomes immune to direct eliminations. Can only target yourself."
	icon_state = "shield"
	action_type = VILLAIN_ACTION_PROTECTIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/forcefield_projector/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(target != user)
		to_chat(user, span_warning("You can only use this on yourself!"))
		return FALSE
	if(!..())
		return FALSE
	// TODO: Apply protection
	to_chat(user, span_notice("You activate the forcefield projector, protecting yourself."))
	return TRUE

// Suppressive Items

/obj/item/villains/handheld_taser
	name = "Handheld Taser"
	desc = "Your targeted player's main action will fail tonight."
	icon_state = "taser"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/w_corp_teleporter
	name = "W-Corp Teleporter"
	desc = "Your target's main action's target will be randomized."
	icon_state = "beacon"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/throwing_bola
	name = "Throwing Bola"
	desc = "Your targeted player's secondary action will fail tonight."
	icon_state = "bola"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_SECONDARY

/obj/item/villains/nitrile_gloves
	name = "Nitrile Gloves"
	desc = "Steal a random item from the target's inventory. If they were using it, their action is canceled."
	icon_state = "gloves"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN

// Special Items

/obj/item/villains/fairy_wine
	name = "Fairy Wine"
	desc = "Talk and Trade with the target of your Main Action. Makes your action appear as Talk and Trade to investigators."
	icon_state = "bottle"
	action_type = VILLAIN_ACTION_TYPELESS
	action_cost = VILLAIN_ACTION_SECONDARY

/obj/item/villains/fairy_wine/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE
	// TODO: Alert Fairy Gentleman players
	to_chat(user, span_notice("You drink the Fairy Wine, feeling more charismatic..."))
	return TRUE

// Item spawning helper
/proc/spawn_villains_items(area/A, amount = 5)
	var/list/item_types = list(
		/obj/item/villains/enkephalin_detector,
		/obj/item/villains/deepscan_kit,
		/obj/item/villains/drain_monitor,
		/obj/item/villains/rangefinder,
		/obj/item/villains/binoculars,
		/obj/item/villains/command_projector,
		/obj/item/villains/forcefield_projector,
		/obj/item/villains/handheld_taser,
		/obj/item/villains/w_corp_teleporter,
		/obj/item/villains/throwing_bola,
		/obj/item/villains/nitrile_gloves
	)
	
	var/list/spawned = list()
	var/list/turfs = get_area_turfs(A)
	
	for(var/i in 1 to amount)
		if(!length(turfs))
			break
		var/turf/T = pick_n_take(turfs)
		var/item_type = pick(item_types)
		var/obj/item/villains/I = new item_type(T)
		spawned += I
		
	return spawned