//--------------------------------------
// The Augment Fabricator Machine
//--------------------------------------
/obj/machinery/augment_fabricator
	name = "Augment Fabricator"
	desc = "A machine used to design and fabricate custom augments. Requires proper clearance."
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machine2"
	anchored = TRUE

	// --- TGUI Setup ---
	// Define the key used to identify this UI's type/component.
	// Needs to match the mapping used by your tgui setup if applicable,
	// or just be a unique identifier for the datum/tgui.
	var/const/ui_key = "AugmentFabricator"

	// --- Data (Same as before) ---
	var/list/available_forms = list(
		"Internal Prosthetic" = list(
			"name" = "Internal Prosthetic",
			"base_cost" = 200,
			"base_ep" = 4,
			"upgradable" = 1,
			"desc" = "A standard internal augmentation base.",
			"icon_preview" = "internal_base" // Placeholder icon state/name for JS preview
		),
		"Tattoo" = list(
			"name" = "Tattoo",
			"base_cost" = 100,
			"base_ep" = 4,
			"negative_immune" = 1,
			"desc" = "An augment woven into the skin. Resists negative side-effects.",
			"icon_preview" = "tattoo_base" // Placeholder icon state/name for JS preview
		)
		// Add other forms here
	)

	// --- Data accessible to the UI ---
	// ... available_forms list would be here ...

	var/list/available_effects = list(
		// --- Reactive Damage Effects ---
		list(
			"id" = "struggling_strength",
			"name" = "Struggling Strength",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "For every 25% of HP lost, deal 25%*X more damage.",
			"notes" = "\[Repeatable, Max of 3\]"
		),
		list(
			"id" = "struggling_defense",
			"name" = "Struggling Defense",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "For every 25% of HP lost, take 25%*X less damage.",
			"notes" = "\[Repeatable, Max of 3\]"
		),
		list(
			"id" = "emergency_shields_red",
			"name" = "Emergency Shields, RED",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take damage while under 50% HP, gain 5 RED Protection. This has a cooldown of 1 minute.",
			"notes" = ""
		),
		list(
			"id" = "emergency_shields_black",
			"name" = "Emergency Shields, BLACK",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take damage while under 50% HP, gain 5 BLACK Protection. This has a cooldown of 1 minute.",
			"notes" = ""
		),
		list(
			"id" = "emergency_shields_white",
			"name" = "Emergency Shields, WHITE",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take damage while under 50% SP, gain 5 WHITE Protection. This has a cooldown of 1 minute.",
			"notes" = ""
		),
		list(
			"id" = "defensive_preparations",
			"name" = "Defensive Preparations",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When taking HP damage, give yourself and all humans within 4 sqrs of you 4 Protection. This has a cooldown of 1.5 minutes.",
			"notes" = ""
		),
		list(
			"id" = "turbulence",
			"name" = "Turbulence",
			"ahn_cost" = 100,
			"ep_cost" = 8,
			"desc" = "Gain a new ability, \"Turbulence\". While \"Turbulence\" is active, take 50% less damage from RED and BLACK damage. However, take the remaining amount of damage as SP damage. You are able to toggle \"Turbulence\" by pressing the ability button.",
			"notes" = ""
		),

		// --- Attacking Effects ---
		list(
			"id" = "weakness_exploit",
			"name" = "Weakness Exploit",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When attacking a target, if their resistance to your damage type is their greatest weakness. Inflict Y Fragility to them. Y being the damage type you are hitting them with. This has a cooldown of 1 second.",
			"notes" = ""
		),
		list(
			"id" = "regeneration",
			"name" = "Regeneration",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a weapon, heal a flat 2*X HP (Has a cooldown of half a second)",
			"notes" = "\[Repeatable, Max of 3\]"
		),

		// --- Execution Effects ---
		list(
			"id" = "absorption",
			"name" = "Absorption",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On kill, regenerate as much HP the target had remaining.", // Added "had remaining" from image 2 context
			"notes" = ""
		),
		list(
			"id" = "brutalize",
			"name" = "Brutalize",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On kill, deal 15*X WHITE damage to all simple mobs within 2 sqrs of you.",
			"notes" = "\[Repeatable, Max of 3\]"
		),
		list(
			"id" = "adrenaline",
			"name" = "Adrenaline",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On kill, gain 2 Strength.",
			"notes" = ""
		),

		// --- Status Effects ---
		list(
			"id" = "burn_vigor",
			"name" = "Burn Vigor",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack, deal an extra 10*X% more damage for every 5 burn on self. (Max of 30*X%)",
			"notes" = "\[Repeatable, Max of 3\]"
		),
		list(
			"id" = "bleed_vigor",
			"name" = "Bleed Vigor",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack, deal an extra 10*X% more damage for every 5 bleed on self. (Max of 30*X%)",
			"notes" = "\[Repeatable, Max of 3\]"
		),
		list(
			"id" = "tremor_defense",
			"name" = "Tremor Defense",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "For every 10 Tremor on self, take 10*X% less damage from RED/BLACK attacks. (Max of 30*X%)",
			"notes" = "\[Repeatable, Max of 3\]"
		),
		list(
			"id" = "earthquake",
			"name" = "Earthquake",
			"ahn_cost" = 100,
			"ep_cost" = 8,
			"desc" = "When attacking a target with 20+ Tremor, trigger a Tremor burst on target and deal (Tremor on target * 4) RED damage to all mobs within 3 sqrs of the target. This has a cooldown of 30 seconds.",
			"notes" = ""
		),
		list(
			"id" = "tremor_break",
			"name" = "Tremor Break",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When attacking a target with 10+ Tremor, trigger a Tremor Burst on the target and inflict (Tremor on Target / 5) Feeble to the target. This has a cooldown of 30 seconds.",
			"notes" = ""
		),
		list(
			"id" = "tremor_bursting",
			"name" = "Tremor Bursting",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "When attacking a target with 5+ Tremor, trigger a Tremor Burst on the target. This has a cooldown of 10 seconds.",
			"notes" = ""
		),
		list(
			"id" = "reflective_tremor",
			"name" = "Reflective Tremor",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When taking RED/BLACK damage from a melee attack, inflict 2*X Tremor to the target",
			"notes" = "\[Repeatable, Max of 4\]"
		),
		list(
			"id" = "blood_cycler",
			"name" = "Blood Cycler",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "Any time a mob within 3 sqrs of you takes Bleed damage, heal HP equal to 50% of the bleed damage they have taken. (Min of 4, Max of 12)",
			"notes" = ""
		),
		list(
			"id" = "pyromaniac",
			"name" = "Pyromaniac",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack, while having 5+ burn on self, transfer 2 Burn on self to the target.",
			"notes" = ""
		),
		list(
			"id" = "hemomaniac",
			"name" = "Hemomaniac",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack, while having 5+ bleed on self, transfer 2 Bleed on self to the target.", // Added "the target" from image 3 context
			"notes" = ""
		),

		// --- Ability Effects ---
		list(
			"id" = "grappling_hook",
			"name" = "Grappling Hook",
			"ahn_cost" = 75,
			"ep_cost" = 6,
			"desc" = "You gain a new ability called \"Grapple\". This causes you to select a location (Pointed spell), Where you will then fire a grappling hook projectile. Upon hitting a target or reaching the target location, you will throw yourself towards that location. In order to fire the grappling hook, you will need to spend a charge, which you gain 1 every 10 seconds. And can hold a max of 3.",
			"notes" = ""
		),
		list(
			"id" = "weapon_sheaths",
			"name" = "Weapon Sheaths",
			"ahn_cost" = 75,
			"ep_cost" = 6,
			"desc" = "Gain a new ability, \"Sheath\". When activating this ability... If you are currently holding a weapon, store it inside of you. If you already were storing a weapon, instantly equip that weapon. This ability has a cooldown of 10 seconds.",
			"notes" = ""
		),
		list(
			"id" = "consuming_augment",
			"name" = "Consuming Augment",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "You gain a new ability called \"Consuming Augment\". When you use this ability, you are able to select a dead simple mob corpse right next to you. (Pointed spell) Once you do, you will gib that corpse and gain something depending on the effect's []. This ability has a cooldown of 40 seconds.\n\[HP\]: Gibbing a corpse will cause you to heal 25% of your max HP\n\[Protection\]: Gibbing a corpse will cause you to take 40% less damage from all attacks for 30 seconds.\n\[Strength\]: Gibbing a corpse will cause you to deal 40% more damage with your attacks for 30 seconds.",
			"notes" = "If the user has other \[Consuming Augment\] effects, all of their effects are added to the same ability."
		),
		list(
			"id" = "mark",
			"name" = "Mark",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "You gain a new ability called \"Mark Target\". This causes you to select a target (Pointed spell), who will become marked by you for 30 seconds. (You can't mark yourself). The effects of the mark are determined by the effects []. This has a cooldown of 1 minute.\n\[Commander\]: The marked target takes 50% more damage from all melee attacks, (excluding your attacks.)\n\[Protection\]: The marked target takes 50% less damage from damage, as long as you are within 3 sqrs of them.\n\[Assassination\]: The marked target takes 50% more damage from your attacks, as long as they are not targeting you. (They need to have a target in order to get the damage buff), (This only works on hostile mobs)\n\[Aid\]: The marked target heals 4 HP every time you attack a mob. This has a cooldown of half a second.",
			"notes" = "If the user has other \[Mark\] effects, all of their effects are added to the same ability."
		),

		// --- Negative Effects ---
		list(
			"id" = "paranoid",
			"name" = "Paranoid",
			"ahn_cost" = 75,
			"ep_cost" = -6,
			"desc" = "Whenever you take damage, you take an extra 5 WHITE damage if you don't have any human insight.",
			"notes" = "\[Negative\]" // Explicitly adding note for UI clarity
		),
		list(
			"id" = "boot_up_sequence",
			"name" = "Boot Up Sequence",
			"ahn_cost" = 50,
			"ep_cost" = -4,
			"desc" = "When you make an attack, gain 3 Feeble. This has a cooldown of 2 minutes.",
			"notes" = "\[Negative\]"
		),
		list(
			"id" = "overheated",
			"name" = "Overheated",
			"ahn_cost" = 25,
			"ep_cost" = -2,
			"desc" = "When you make an attack, for the next 10 seconds each time you attack you gain 2*X Burn. This has a cooldown of 1.5 minutes.",
			"notes" = "\[Repeatable, Max of 3\]\[Negative\]" // Combined notes
		),
		list(
			"id" = "thanatophobia",
			"name" = "Thanatophobia",
			"ahn_cost" = 50,
			"ep_cost" = -4,
			"desc" = "When you take damage while under 50% HP, take an extra 10 WHITE damage. Has a cooldown of 1 second.",
			"notes" = "\[Negative\]"
		),
		list(
			"id" = "pacifist",
			"name" = "Pacifist",
			"ahn_cost" = 50,
			"ep_cost" = -4,
			"desc" = "On kill, gain 2 Feeble.",
			"notes" = "\[Negative\]"
		),
		list(
			"id" = "struggling_weakness",
			"name" = "Struggling Weakness",
			"ahn_cost" = 50,
			"ep_cost" = -4,
			"desc" = "For every 25% of HP lost, deal 25%*X less damage.",
			"notes" = "\[Repeatable, Max of 3\]\[Negative\]"
		),
		list(
			"id" = "struggling_fragility",
			"name" = "Struggling Fragility",
			"ahn_cost" = 50,
			"ep_cost" = -4,
			"desc" = "For every 25% of HP lost, take 25%*X more damage.",
			"notes" = "\[Repeatable, Max of 3\]\[Negative\]"
		)
	)


	// --- Core Interaction Procs ---

	// Called when a user clicks the machine (Standard BYOND interaction)
	// This often sets user.machine = src and then calls ui_interact,
	// but the exact flow might vary slightly in LC13. Assuming direct call works.
/obj/machinery/augment_fabricator/attack_hand(mob/user)
	if(!Adjacent(user, src)) // Basic distance check
		return ..() // Let parent handle if too far

	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, "<span class='warning'>You can't operate this machine.</span>")
		return TRUE // Interaction consumed

	// --- Access Check ---
	// var/obj/item/card/id/id_card = user.get_id_card() // Assuming helper proc exists
	// if(!id_card || !check_access(id_card)) // Replace check_access with your actual proc
	// 	to_chat(user, "<span class='warning'>Access denied.</span>")
	// 	return TRUE // Interaction consumed

	// --- Open the UI via ui_interact ---
	// This delegates opening/updating to the standard tgui proc for this object.
	return ui_interact(user) // Return value might matter based on parent calls

	// Standard TGUI Interaction Entry Point
	// Called by attack_hand, or potentially by SStgui subsystem for updates.
/obj/machinery/augment_fabricator/ui_interact(mob/user, datum/tgui/ui = null)
	// Log the interaction attempt
	log_tgui(user, src, "Attempting Interaction")

	// Try to update an existing UI first
	// SStgui.try_update_ui handles finding an existing UI for the user/src pair
	ui = SStgui.try_update_ui(user, src, ui)
	if(ui)
		// If an existing UI was found and updated, we're done.
		log_tgui(user, src, "Updated existing UI")
		return TRUE // Indicate interaction happened

	// If no existing UI, create a new one
	log_tgui(user, src, "Creating new UI")
	// The constructor for datum/tgui likely takes (user, src_object, key, title, ...)
	// Adjust arguments based on your specific datum/tgui definition in LC13
	ui = new (user, src, src.ui_key, src.name) // Added width/height example

	// Open the newly created UI
	if(ui)
		ui.open()
		log_tgui(user, src, "Opened new UI")
		return TRUE // Indicate interaction happened
	else
		log_admin("Failed to create tgui instance for [user] and [src]")
		return FALSE // Indicate failure

	// Provides data to the TGUI interface (datum/tgui calls this)
/obj/machinery/augment_fabricator/ui_data(mob/user)
	var/list/data = list()

	// Send form definitions
	data["forms"] = list()
	for(var/form_name in available_forms)
		data["forms"] += list(available_forms[form_name])

	// Send effect definitions
	data["effects"] = list()
	for(var/effect_data in available_effects)
		data["effects"] += list(effect_data)

	// Send Rank info
	data["maxRank"] = 5
	data["rankAttributeReqs"] = list(0, 40, 60, 80, 100) // Req for rank 1, 2, 3, 4, 5
	data["currencySymbol"] = "ahn" // Assuming "ahn" is correct

	// --- Potentially add current state if the UI needs it on initial load ---
	// For example, if a user could leave and come back to a partially configured augment:
	// data["currentState"] = get_user_saved_state(user) // Hypothetical proc

	return data

// Handles actions sent back from the UI via Topic?action=...
// /obj/machinery/augment_fabricator/ui_host(mob/user) // Needed for SStgui to check if the user can still interact
// 	return Adjacent(user, src) && !user.incapacitated()  //&& check_access(user.get_id_card()

// Topic handles actions sent from the UI
/obj/machinery/augment_fabricator/Topic(href, href_list, datum/tgui/ui) // datum/tgui might be passed by the subsystem
	if(..()) // Handle default Topic links first
		return TRUE

	// Ensure the interaction is valid via ui_host check
	if(!ui_host(usr))
		log_tgui(usr, src, "Topic rejected: ui_host failed")
		// Optionally close the UI if interaction is no longer valid
		// if(ui) ui.close() // Or SStgui.close_user_uis(usr, src)
		return TRUE // Reject the action silently

	var/action = href_list["action"]
	if(action == "fabricate")
		log_tgui(usr, src, "Topic: fabricate")
		var/list/config
		// Use try-catch for safety when decoding JSON
		// try
		config = json_decode(href_list["config"])
		// catch(var/exception/e)
		// 	log_admin("JSON Decode failed in [src] Topic: [e.message]")
		// 	to_chat(usr, "<span class='warning'>Error processing request. Invalid data received.</span>")
		// 	return TRUE // Stop processing

		if(!config || !istype(config, /list))
			log_admin("Invalid config data received in [src] Topic.")
			to_chat(usr, "<span class='warning'>Error processing request. Malformed data received.</span>")
			return TRUE

		// --- Server-side Validation ---
		var/form_name = config["form"]
		var/rank = clamp(text2num(config["rank"]), 1, 5) // Clamp rank for safety
		var/list/selected_effect_ids = config["selectedEffects"]
		if(!istype(selected_effect_ids, /list)) selected_effect_ids = list() // Ensure it's a list

		var/datum/augment_design/validation_design = new()
		if(!validation_design.validate_and_calculate(form_name, rank, selected_effect_ids, src))
			to_chat(usr, "<span class='warning'>Invalid augment configuration. Fabrication cancelled. Reason: [validation_design.validation_error || "Unknown validation error"]</span>")
			qdel(validation_design)
			return TRUE

		var/total_ahn_cost = validation_design.total_ahn_cost
		var/creator_name = sanitize_text(config["name"], 64) // Sanitize user input
		var/creator_desc = sanitize_text(config["description"], 256)
		var/primary_color = sanitize_hex_color(config["primaryColor"]) // Sanitize color codes
		var/secondary_color = sanitize_hex_color(config["secondaryColor"])

		// --- Check Resources ---
		// if(!usr.pay_amount(total_ahn_cost)) // Replace with your payment logic
		// 	to_chat(usr, "<span class='warning'>You don't have enough Ahn ([total_ahn_cost]) to fabricate this augment.</span>")
		// 	qdel(validation_design)
		// 	return TRUE

		// --- Create the Augment ---
		to_chat(usr, "<span class='notice'>Fabricating augment...</span>")
		// Optional delay can go here

		var/obj/item/augment/new_augment = new(get_turf(src)) // Create item on the machine's turf
		if(new_augment)
			new_augment.name = creator_name ? "[creator_name] ([validation_design.form_data["name"]])" : "[validation_design.form_data["name"]] Augment"
			new_augment.desc = creator_desc ? creator_desc : "A custom-fabricated augment."
			new_augment.apply_design(validation_design, primary_color, secondary_color) // Pass validated design

			to_chat(usr, "<span class='good'>Fabrication complete! [new_augment] is ready.</span>")
			// Close the UI using the subsystem after successful fabrication
			SStgui.close_user_uis(usr, src)
		else
			log_admin("Failed to create augment item at [src].")
			to_chat(usr, "<span class='warning'>Fabrication failed! Contact administration.</span>")
			//usr.give_amount(total_ahn_cost) // Refund cost on failure

		// Clean up the validation datum
		qdel(validation_design)
		return TRUE // Action was handled

	// If action not recognized, let parent handle
	return ..()

	// Helper proc for access check (replace with actual logic)
// /obj/machinery/augment_fabricator/proc/check_access(obj/item/card/id/id_card)
// 	// TODO: Implement actual access check logic (e.g., check for surgeon access bit)
// 	return id_card && id_card.access // Example: Check if any access exists on card

// Helper datum for validation (slightly improved)
/datum/augment_design
	var/list/form_data
	var/rank
	var/list/selected_effects_data = list()
	var/base_ep
	var/total_ep_cost
	var/remaining_ep
	var/base_ahn_cost
	var/effects_ahn_cost
	var/total_ahn_cost
	var/validation_error = "" // Store error message for user feedback

/datum/augment_design/proc/validate_and_calculate(form_name, rank_num, list/selected_effect_ids, obj/machinery/augment_fabricator/fabricator)
	src.validation_error = "" // Reset error

	// 1. Validate Form
	if(!fabricator.available_forms[form_name])
		src.validation_error = "Selected form ('[form_name]') is invalid."
		log_admin("[src.validation_error]")
		return FALSE
	src.form_data = fabricator.available_forms[form_name]

	// 2. Validate Rank
	// Assuming maxRank is 5, adjust if dynamic
	if(rank_num < 1 || rank_num > 5)
		src.validation_error = "Selected rank ([rank_num]) is out of range (1-5)."
		log_admin("[src.validation_error]")
		return FALSE
	src.rank = rank_num
	// TODO: Server-side check of attribute requirements if necessary (requires access to 'usr')

	// 3. Calculate Base Values
	src.base_ahn_cost = form_data["base_cost"] * src.rank
	src.base_ep = form_data["base_ep"] * src.rank

	// 4. Validate and Calculate Effects
	src.total_ep_cost = 0
	src.effects_ahn_cost = 0
	src.selected_effects_data = list() // Reset effect data list
	var/list/effect_counts = list() // For tracking non-repeatable effects

	for(var/effect_id in selected_effect_ids)
		var/found = FALSE
		var/effect_def = null
		// Find the effect definition efficiently if possible (e.g., if effects list used IDs as keys)
		// Otherwise, loop through:
		for(var/list/e_def in fabricator.available_effects)
			if(e_def["id"] == effect_id)
				effect_def = e_def
				found = TRUE
				break

		if(!found)
			src.validation_error = "An invalid effect ID ('[effect_id]') was selected."
			log_admin("[src.validation_error]")
			return FALSE

		// Check if repeatable
		// var/is_repeatable = findtext(effect_def["notes"], "[repeatable]")
		// effect_counts[effect_id] = (effect_counts[effect_id] || 0) + 1
		// if(!is_repeatable && effect_counts[effect_id] > 1)
		// 	src.validation_error = "Non-repeatable effect '[effect_def["name"]]' added multiple times."
		// 	log_admin("[src.validation_error]")
		// 	return FALSE

		// Check form restrictions (Example: Tattoo form immunity)
		if(form_data["negative_immune"] && effect_def["ep_cost"] < 0)
			src.validation_error = "The '[form_data["name"]]' form cannot accept negative effects like '[effect_def["name"]]'."
			log_admin("[src.validation_error]")
			return FALSE

		// Add validated effect
		src.selected_effects_data += list(effect_def) // Store the definition list
		src.total_ep_cost += effect_def["ep_cost"]
		src.effects_ahn_cost += effect_def["ahn_cost"]

	// 5. Final Calculations & Checks
	src.remaining_ep = src.base_ep - src.total_ep_cost
	if(src.remaining_ep < 0)
		src.validation_error = "Total EP cost ([src.total_ep_cost]) exceeds base EP ([src.base_ep])."
		log_admin("[src.validation_error]")
		return FALSE

	src.total_ahn_cost = src.base_ahn_cost + src.effects_ahn_cost
	// Ensure cost doesn't somehow go negative unless intended
	src.total_ahn_cost = max(0, src.total_ahn_cost)

	// TODO: Add any other validation rules (e.g., incompatible effects check)

	return TRUE // Validation successful

// Augment Item definition (basic structure)
/obj/item/augment
	name = "Augment"
	// ... other properties ...
	var/datum/augment_design/design_details // Store the applied design data
	var/primary_color = "#FFFFFF"
	var/secondary_color = "#CCCCCC"

/obj/item/augment/proc/apply_design(datum/augment_design/applied_design, p_color, s_color)
	if(!applied_design)
		log_admin("Attempted to apply null design to [src]")
		return
	// It's often better to copy relevant data than hold a reference
	// to the temporary validation datum, unless the datum is designed
	// to be persistent. Let's assume we copy needed info.
	// src.design_details = applied_design // If keeping reference is okay

	// Example: Copying key details
	src.design_details = new /datum/augment_design() // Create persistent storage
	src.design_details.form_data = applied_design.form_data.Copy() // Copy lists/datums
	src.design_details.rank = applied_design.rank
	src.design_details.selected_effects_data = applied_design.selected_effects_data.Copy()
	src.design_details.base_ep = applied_design.base_ep
	src.design_details.total_ep_cost = applied_design.total_ep_cost
	// We don't usually need to store cost on the item itself

	src.primary_color = p_color
	src.secondary_color = s_color

	// TODO: Apply actual game effects based on design_details
	// - Modify stats (if applicable)
	// - Add components/verbs for abilities from selected_effects_data
	// - Update icon based on form_data and colors (requires icon generation/state logic)
	// Example: queue_icon_update()

	// Optional: Cleanup when deleted
	// Del()
	//    qdel(design_details)
	//    ..()

/proc/sanitize_hex_color(color_text, default_color = "#FFFFFF")
	if(!color_text) return default_color
	// Basic check for # followed by 3 or 6 hex chars
	if(length(color_text) == 4 || length(color_text) == 7)
		if(copytext(color_text, 1, 2) == "#")
			var/hex = copytext(color_text, 2)
			for(var/i=1 to length(hex))
				var/char_code = text2ascii(hex, i)
				// Check if 0-9, A-F, a-f
				if(!((char_code >= 48 && char_code <= 57) || (char_code >= 65 && char_code <= 70) || (char_code >= 97 && char_code <= 102)))
					return default_color // Invalid character
			return uppertext(color_text) // Return valid hex, uppercased for consistency
	return default_color // Failed validation

// Assume these helper procs exist or implement them:
// mob/proc/get_id_card() - returns the user's ID card object
// mob/proc/pay_amount(amount) - deducts currency, returns TRUE on success
// mob/proc/give_amount(amount) - adds currency (for refunds)
