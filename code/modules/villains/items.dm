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

/obj/item/villains/Initialize()
	. = ..()
	update_outline()

/obj/item/villains/Destroy()
	remove_filter("villains_glow")
	return ..()

/obj/item/villains/proc/update_outline()
	// Remove any existing filters
	remove_filter("villains_glow")

	if(freshness == VILLAIN_ITEM_FRESH)
		// Green outline for fresh items
		add_filter("villains_glow", 2, list("type" = "outline", "color" = "#00FF0080", "size" = 2))
		// Start glow animation
		addtimer(CALLBACK(src, PROC_REF(glow_loop)), rand(1,19))
	else if(freshness == VILLAIN_ITEM_USED)
		// Yellow outline for used items (evidence)
		add_filter("villains_glow", 2, list("type" = "outline", "color" = evidence_color + "80", "size" = 2))
		// Start glow animation
		addtimer(CALLBACK(src, PROC_REF(glow_loop)), rand(1,19))

/obj/item/villains/proc/glow_loop()
	var/filter = get_filter("villains_glow")
	if(filter)
		animate(filter, alpha = 110, time = 15, loop = -1)
		animate(alpha = 40, time = 25)

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
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget2"
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
	icon = 'icons/obj/storage.dmi'
	icon_state = "maint_kit"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/drain_monitor
	name = "Drain Monitor"
	desc = "Learn everyone who targeted your target."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget2"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/rangefinder
	name = "Keen-Sense Rangefinder"
	desc = "Learn all of the actions that targeted your target."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget2r"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/binoculars
	name = "Binoculars"
	desc = "Learn the target's inventory."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "binoculars"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/command_projector
	name = "Command Projector"
	desc = "Send a short message to a player (max 100 characters)."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget3"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_SECONDARY

// Protective Items

/obj/item/villains/forcefield_projector
	name = "Forcefield Projector"
	desc = "Target becomes immune to direct eliminations. Can only target yourself."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker_forcefield"
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
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "taser"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/w_corp_teleporter
	name = "W-Corp Teleporter"
	desc = "Your target's main action's target will be randomized."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "teleporter"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN

/obj/item/villains/throwing_bola
	name = "Throwing Bola"
	desc = "Your targeted player's secondary action will fail tonight."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bola"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_SECONDARY

/obj/item/villains/nitrile_gloves
	name = "Nitrile Gloves"
	desc = "Steal a random item from the target's inventory. If they were using it, their action is canceled."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "nitrile"
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

