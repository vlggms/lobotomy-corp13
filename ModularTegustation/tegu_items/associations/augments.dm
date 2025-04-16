//--------------------------------------
// The Augment Fabricator Machine
//--------------------------------------

#define AUGMENT_ICON_FILE 'icons/effects/augment_fab.dmi' // CHANGE THIS to your actual DMI file path

/obj/machinery/augment_fabricator
	name = "Augment Fabricator"
	desc = "A machine used to design and fabricate custom augments. Requires proper clearance."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "protolathe"
	var/icon_state_animation = "protolathe_n"
	anchored = TRUE
	density = TRUE

	// --- TGUI Handler ---
	/// Manages the TGUI interactions for this machine.
	var/datum/tgui_handler/augment_fabricator/ui_handler = null

	var/const/ui_key = "AugmentFabricator"

	// --- Data (Same as before) ---
	var/list/available_forms = list(
		"Internal Prosthetic" = list(
			"id" = "prosthetic",
			"name" = "Internal Prosthetic",
			"base_cost" = 200,
			"base_ep" = 2,
			"upgradable" = 1,
			"desc" = "A standard internal augmentation base.",
			"icon_file" = AUGMENT_ICON_FILE, // Store the file path
			"icon_preview" = "prosthetic", // Base icon state
			"primary_overlay_state" = "prosthetic_prim", // State for primary color mask
			"secondary_overlay_state" = "prosthetic_secon" // State for secondary color mask
			),
		"Tattoo" = list(
			"id" = "tattoo",
			"name" = "Tattoo",
			"base_cost" = 50,
			"base_ep" = 4,
			"negative_immune" = 1,
			"desc" = "An augment woven into the skin. Unable to have negative effect.",
			"icon_file" = AUGMENT_ICON_FILE, // Store the file path
			"icon_preview" = "tattoo", // Base icon state
			"primary_overlay_state" = "tattoo_prim", // State for primary color mask
			"secondary_overlay_state" = "tattoo_secon" // State for secondary color mask
		)
		// Add other forms here
	)

	// --- Data accessible to the UI ---
	// ... available_forms list would be here ...

	var/list/available_effects = list(
		// --- Reactive Damage Effects ---
		list(
			"id" = "struggling_defense",
			"name" = "Struggling Defense",
			"ahn_cost" = 50,
			"ep_cost" = 4, // Positive EP cost
			"desc" = "For every 25% of HP lost, take 10%*X less damage.",
			"repeatable" = 3, // Max 3 times
			"component" = /datum/component/augment/struggling_defense
		),
		list(
			"id" = "ES_red",
			"name" = "Emergency Shields, RED",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take brute damage while under 50% HP, gain 8 RED Protection. This has a cooldown of 1 minute.",
			"component" = /datum/component/augment/ES_red
		),
		list(
			"id" = "ES_black",
			"name" = "Emergency Shields, BLACK",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take brute damage while under 50% HP, gain 8 BLACK Protection. This has a cooldown of 1 minute.",
			"component" = /datum/component/augment/ES_black
		),
		list(
			"id" = "ES_white",
			"name" = "Emergency Shields, WHITE",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "When you take sanity damage while under 50% SP, gain 8 WHITE Protection. This has a cooldown of 1 minute.",
			"component" = /datum/component/augment/ES_white
		),
		list(
			"id" = "defensive_preparations",
			"name" = "Defensive Preparations",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When taking brute damage, give yourself and all humans within 4 sqrs of you 4 Protection. This has a cooldown of 1.5 minutes.",
			"repeatable" = 3,
			"component" = /datum/component/augment/defensive_preparations
		),
		list(
			"id" = "reinforcement_nanties",
			"name" = "Reinforcement Nanties",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "When you take damage, you will take 5*X% less damage per human you can see. (Max of 40%).",
			"repeatable" = 3,
			"component" = /datum/component/augment/reinforcement_nanties
		),
		// --- Attacking Effects ---
		list(
			"id" = "regeneration",
			"name" = "Regeneration",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a RED weapon, heal a flat 2*X HP (Has a cooldown of half a second)",
			"repeatable" = 3,
			"component" = /datum/component/augment/regeneration
		),
		list(
			"id" = "tranquility",
			"name" = "Tranquility",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a WHITE weapon, heal a flat 2*X SP (Has a cooldown of half a second)",
			"repeatable" = 3,
			"component" = /datum/component/augment/tranquility
		),
		list(
			"id" = "struggling_strength",
			"name" = "Struggling Strength",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"repeatable" = 3,
			"desc" = "For every 25% of HP lost, deal 10%*X more damage.",
			"component" = /datum/component/augment/struggling_strength
		),
		list(
			"id" = "ar_red",
			"name" = "Armor Rend, RED",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit with a BLACK weapon, inflict 1 RED fragility.",
			"component" = /datum/component/augment/ar_red
		),
		list(
			"id" = "ar_black",
			"name" = "Armor Rend, BLACK",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit with a RED weapon, inflict 1 BLACK fragility.",
			"component" = /datum/component/augment/ar_black
		),
		list(
			"id" = "dual_wield",
			"name" = "Strong Arms",
			"ahn_cost" = 200,
			"ep_cost" = 8,
			"desc" = "When you perform a melee attack, if you are holding another weapon in your other hand, attack the same target with your other weapon. This has a cooldown of the other weapons attack speed *4",
			"component" = /datum/component/augment/dual_wield
		),
		list(
			"id" = "unstable",
			"name" = "Unstable",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "While at 50% or higher SP, you BLACK melee attacks deal 20% more damage, but you also take SP damage equal to 5% of your Max SP per hit.",
			"component" = /datum/component/augment/unstable
		),
		list(
			"id" = "shattering_mind_red",
			"name" = "Shattering Mind, RED",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 25% of your missing SP, deal an extra 10*X% RED damage.",
			"component" = /datum/component/augment/shattering_mind_red
		),
		list(
			"id" = "shattering_mind_white",
			"name" = "Shattering Mind, WHITE",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 25% of your missing SP, deal an extra 10*X% WHITE damage.",
			"component" = /datum/component/augment/shattering_mind_white
		),
		list(
			"id" = "shattering_mind_black",
			"name" = "Shattering Mind, BLACK",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 25% of your missing SP, deal an extra 10*X% BLACK damage.",
			"component" = /datum/component/augment/shattering_mind_black
		),
		list(
			"id" = "gashing_wounds",
			"name" = "Gashing Wounds",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a RED weapon, inflict 2 Bleed (Cooldown of half a second)",
			"component" = /datum/component/augment/gashing_wounds
		),
		list(
			"id" = "scorching_mind",
			"name" = "Scorching Mind",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a WHITE weapon, inflict 3 Burn (Cooldown of 1 second.)",
			"component" = /datum/component/augment/scorching_mind
		),
		list(
			"id" = "slothful_decay",
			"name" = "Slothful Decay",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a BLACK weapon, inflict 2 Tremor. If the weapon has an attack speed greater than 1.5 second, Inflict an extra 2 Tremor. (Cooldown of 1.5 seconds.)",
			"component" = /datum/component/augment/slothful_decay
		),
		// --- Execution Effects ---
		list(
			"id" = "absorption",
			"name" = "Absorption",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On kill, regenerate as much HP as the amount of damage you dealt.",
			"component" = /datum/component/augment/absorption
		),
		list(
			"id" = "brutalize",
			"name" = "Brutalize",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "On kill, deal 15*X WHITE damage to all simple mobs within 2 sqrs of you.",
			"component" = /datum/component/augment/brutalize
		),
		list(
			"id" = "flesh_morphing",
			"name" = "Flesh-Morphing",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"repeatable" = 3,
			"desc" = "On kill, One human within 4 sqrs of you (not including you), Heals 10% * X of your target max HP.",
			"component" = /datum/component/augment/flesh_morphing
		),
		// --- Negative Effects ---
		list(
			"id" = "paranoid",
			"name" = "Paranoid ",
			"ahn_cost" = 50,
			"ep_cost" = -6, // Negative EP cost signifies a downside, grants EP
			"desc" = "Whenever you take damage, you take an extra 10 WHITE damage if you don’t have any human insight.",
			"component" = /datum/component/augment/paranoid
		),
		list(
			"id" = "bus",
			"name" = "Boot Up Sequence",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "When you make an attack, gain 3 Feeble. This has a cooldown of 70 seconds.",
			"component" = /datum/component/augment/bus
		),
		list(
			"id" = "overheated",
			"name" = "Overheated",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you make an attack, for the next 10 seconds each time you attack you gain 2*X Burn. This has a cooldown of 1.5 minutes.",
			"repeatable" = 3,
			"component" = /datum/component/augment/overheated
		),
		list(
			"id" = "thanatophobia",
			"name" = "Thanatophobia",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "When you take damage while under 50% HP, take an extra 10 WHITE damage. Has a cooldown of 1 second.",
			"component" = /datum/component/augment/thanatophobia
		),
		list(
			"id" = "pacifist",
			"name" = "Pacifist",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "On kill, gain 3 Feeble",
			"component" = /datum/component/augment/pacifist
		),
		list(
			"id" = "struggling_weakness",
			"name" = "Struggling Weakness",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "For every 25% of HP lost, deal 20%*X less damage..",
			"repeatable" = 3,
			"component" = /datum/component/augment/struggling_weakness
		),
		list(
			"id" = "struggling_fragility",
			"name" = "Struggling Fragility",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "For every 25% of HP lost, take 20%*X more damage..",
			"repeatable" = 3,
			"component" = /datum/component/augment/struggling_fragility
		),
		list(
			"id" = "algophobia",
			"name" = "Algophobia",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you take RED damage, take an extra (RED damage) * 0.5 * X WHITE damage. This has a cooldown of 1 second.",
			"repeatable" = 3,
			"component" = /datum/component/augment/algophobia
		),
		list(
			"id" = "weak_arms",
			"name" = "Weak Arms",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "Your melee attacks have their attack speed decreased by half.",
			"component" = /datum/component/augment/weak_arms
		),
		list(
			"id" = "annoyance",
			"name" = "Annoyance",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "After every 8 attacks, all foes within 3 sqrs will start targeting you and you gain 2 Fragile.",
			"component" = /datum/component/augment/annoyance
		),
		list(
			"id" = "allodynia",
			"name" = "Allodynia",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you take damage, you gain 2 * X Bleed. (Has a cooldown of 1 second). Also, you take bleed damage each time you attack. (That has a cooldown of 3 seconds)",
			"repeatable" = 3,
			"component" = /datum/component/augment/allodynia
		),
		// Add other effects following this structure
	)

	var/maxRank = 5
	var/list/rankAttributeReqs = list(20, 40, 60, 80, 100)
	var/currencySymbol = "ahn"

// --- Initialization ---
/obj/machinery/augment_fabricator/Initialize(mapload) // Use Initialize if available, otherwise New()
	. = ..()
	// Create and assign the UI handler, passing this machine instance
	ui_handler = new(src)
	if(!ui_handler)
		log_admin("Failed to initialize tgui_handler for [src]")

	// --- Core Interaction ---
/obj/machinery/augment_fabricator/attack_hand(mob/user)
	if(!Adjacent(user, src))
		return ..()

	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, "<span class='warning'>You lack the dexterity to operate this machine.</span>")
		return TRUE

	// --- Access Check ---
	// if(!check_access(user.get_id_card())) // Use your access check proc
	// 	to_chat(user, "<span class='warning'>Access denied.</span>")
	// 	return TRUE

	// --- Delegate UI Interaction to the Handler ---
	if(ui_handler)
		return ui_handler.ui_interact(user)
	else
		log_admin("Missing ui_handler on [src] during attack_hand by [user]")
		to_chat(user, "<span class='warning'>Machine interface error. Please report this.</span>")
		return TRUE

	// --- Machine-Specific Logic Procs ---

/// Placeholder for checking if the user can afford the cost.
/obj/machinery/augment_fabricator/proc/can_afford(mob/user, amount)
	// Replace with actual currency check logic (e.g., checking user's bank account, wallet)
	// Example: return user.get_bank_balance() >= amount
	log_runtime("Checking if [user] can afford [amount] [src.currencySymbol]")
	// Placeholder: Assume everyone can afford for now
	// If using a direct payment system on the mob:
	// var/datum/money_account/account = user.get_account() // Hypothetical
	// return account && account.can_afford(amount)
	return TRUE // Placeholder

	/// Placeholder for deducting the cost.
/obj/machinery/augment_fabricator/proc/deduct_cost(mob/user, amount)
	// Replace with actual currency deduction logic
	// Example: user.deduct_from_bank(amount)
	log_runtime("Deducting [amount] [src.currencySymbol] from [user]")
	// Placeholder: Assume deduction works
	// If using a direct payment system on the mob:
	// var/datum/money_account/account = user.get_account() // Hypothetical
	// return account && account.pay_amount(amount)
	return TRUE // Placeholder

/// Handles the actual creation of the augment item. Called by the UI handler.
/obj/machinery/augment_fabricator/proc/perform_fabrication(mob/user, datum/augment_design/design, creator_name, creator_desc, primary_color, secondary_color)
	if(!design || !user)
		log_admin("perform_fabrication called with invalid args for [user] at [src]")
		return null

	var/total_ahn_cost = design.total_ahn_cost

	// --- Final Checks & Payment ---
	if(!can_afford(user, total_ahn_cost))
		to_chat(user, "<span class='warning'>You cannot afford the cost of [total_ahn_cost] [src.currencySymbol].</span>")
		return null // Fabrication fails

	if(!deduct_cost(user, total_ahn_cost))
		to_chat(user, "<span class='warning'>Failed to deduct [total_ahn_cost] [src.currencySymbol]. Payment cancelled.</span>")
		return null // Fabrication fails

	// --- Create the Augment ---
	// Optional: Add a fabrication delay?
	// sleep(30) // 3 seconds delay

	var/temp_icon_state = icon_state
	icon_state = icon_state_animation
	sleep(7)
	icon_state = temp_icon_state

	var/obj/item/augment/new_augment = new(get_turf(src)) // Create item at machine's location
	if(new_augment)
		new_augment.name = creator_name ? "[creator_name] ([design.form_data["name"]])" : "[design.form_data["name"]] Augment (Rank [design.rank])"
		new_augment.desc = creator_desc ? creator_desc : "A custom-fabricated augment using the '[design.form_data["name"]]' template at Rank [design.rank]."
		new_augment.apply_design(design, primary_color, secondary_color) // Apply the validated design

		log_game("[key_name(user)] fabricated '[new_augment.name]' using [src.name] at ([loc.x],[loc.y],[loc.z]). Design Cost: [total_ahn_cost].")
		return new_augment
	else
		log_runtime("Failed to create augment item at [src] for [user].")
		to_chat(user, "<span class='warning'>Critical fabrication failure! Please contact administration.</span>")
		// Attempt to refund the cost on critical failure
		// if(total_ahn_cost > 0) user.give_amount(total_ahn_cost) // Replace with refund logic
		log_runtime("Refunding [total_ahn_cost] [src.currencySymbol] to [user] due to creation failure.")
		// machine.refund_cost(user, total_ahn_cost) // Use a refund proc if available
		return null


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

	// 1. Validate Form (No change)
	if(!fabricator || !fabricator.available_forms[form_name])
		src.validation_error = "Selected form ('[form_name]') is invalid or fabricator missing."
		log_admin("[src.validation_error]")
		return FALSE
	src.form_data = fabricator.available_forms[form_name]

	// 2. Validate Rank (No change)
	if(rank_num < 1 || rank_num > 5) // Assuming maxRank is still 5
		src.validation_error = "Selected rank ([rank_num]) is out of range (1-5)."
		log_admin("[src.validation_error]")
		return FALSE
	src.rank = rank_num

	// 3. Calculate Base Values (No change)
	src.base_ahn_cost = form_data["base_cost"] * src.rank
	src.base_ep = form_data["base_ep"] * src.rank

	// 4. Validate and Calculate Effects (UPDATED LOGIC)
	src.total_ep_cost = 0
	src.effects_ahn_cost = 0
	src.selected_effects_data = list() // Reset effect data list
	var/list/effect_counts = list() // Track counts of each effect ID

	for(var/effect_id in selected_effect_ids)
		var/list/effect_def = null // Initialize to null

		// --- Manual Search Loop ---
		for(var/list/possible_effect in fabricator.available_effects)
			if(possible_effect["id"] == effect_id)
				effect_def = possible_effect // Found it!
				break // Stop searching this inner loop
		// --- End Manual Search Loop ---

		if(!effect_def) // Check if we found it after the loop
			src.validation_error = "An invalid effect ID ('[effect_id]') was selected."
			log_admin("[src.validation_error]")
			return FALSE

		// Increment count for this effect ID
		effect_counts[effect_id] = (effect_counts[effect_id] || 0) + 1

		// Check repeatability
		var/max_repeats = text2num(effect_def["repeatable"]) // Convert to number, defaults to 0 if null/invalid
		if(max_repeats > 0) // If the effect is repeatable
			if(effect_counts[effect_id] > max_repeats)
				src.validation_error = "Effect '[effect_def["name"]]' can only be repeated [max_repeats] times (tried to add [effect_counts[effect_id]]).."
				log_admin("[src.validation_error]")
				return FALSE
		else // If the effect is NOT repeatable (max_repeats is 0 or less)
			if(effect_counts[effect_id] > 1)
				src.validation_error = "Non-repeatable effect '[effect_def["name"]]' added multiple times."
				log_admin("[src.validation_error]")
				return FALSE

		// Check form restrictions (Example: Tattoo form immunity to negative effects)
		// Negative effect identified by ep_cost < 0
		if(form_data["negative_immune"] && effect_def["ep_cost"] < 0)
			src.validation_error = "The '[form_data["name"]]' form cannot accept negative effects like '[effect_def["name"]]'."
			log_admin("[src.validation_error]")
			return FALSE

		// Add validated effect data (only add the definition once, even if selected multiple times in input)
		// The final list of effects to apply should probably be reconstructed based on counts later
		// Let's keep adding the raw definition for now, apply_design might need counts
		src.selected_effects_data += list(effect_def) // Store the definition list for reference
		src.total_ep_cost += effect_def["ep_cost"]
		src.effects_ahn_cost += effect_def["ahn_cost"]

	// 5. Final Calculations & Checks (No change)
	src.remaining_ep = src.base_ep - src.total_ep_cost
	if(src.remaining_ep < 0)
		src.validation_error = "Total EP cost ([src.total_ep_cost]) exceeds base EP ([src.base_ep])."
		log_admin("[src.validation_error]")
		return FALSE

	src.total_ahn_cost = src.base_ahn_cost + src.effects_ahn_cost
	src.total_ahn_cost = max(0, src.total_ahn_cost)

	// TODO: Add any other validation rules

	return TRUE // Validation successful

// Helper proc to find effect definition by ID within the list of lists
/proc/find_effect_by_id(list/effect_definition, effect_id_to_find)
	return effect_definition["id"] == effect_id_to_find

// Augment Item definition (basic structure)
/obj/item/augment
	name = "Augment"
	icon = AUGMENT_ICON_FILE
	icon_state = "prosthetic"
	var/datum/augment_design/design_details // Store the applied design data
	var/primary_color = "#FFFFFF"
	var/secondary_color = "#CCCCCC"
	var/list/rankAttributeReqs = list(20, 40, 60, 80, 100)
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/augment/attack(mob/M, mob/user)
	. = ..()
	if (!CanUseAugment(user))
		to_chat(user, "Only surgeons can do that!")
		return FALSE
	if (!ishuman(M))
		to_chat(user, "Only affects human!")
		return FALSE
	var/mob/living/carbon/human/H = M
	var/stattotal
	for(var/attribute in stats)
		stattotal+=get_attribute_level(H, attribute)
	stattotal /= 4	//Potential is an average of stats
	if(stattotal < rankAttributeReqs[rank])
		to_chat(user, "[H.name] is too weak to use this augment!")
		return FALSE
	if (!do_after(user, 10 SECONDS, H))
		to_chat(user, "Interrupted!")
		return FALSE
	src.forceMove(H)
	ApplyEffects(H)

/obj/item/augment/proc/CanUseAugment(mob/user)
	return TRUE

/obj/item/augment/proc/ApplyEffects(mob/living/carbon/human/H)
	var/list/grouped_efects_list = new/list()
	for (var/list/effect in design_details.selected_effects_data)
		var/current_id = effect["id"]
		if (!islist(grouped_efects_list[current_id]))
			grouped_efects_list[current_id] = list(effect)
		else
			grouped_efects_list[current_id] += list(effect)

	for (var/id in grouped_efects_list)
		var/list/items_in_group = grouped_efects_list[id]
		var/effect = items_in_group[1]
		if (effect["component"])
			H.AddComponent(effect["component"], items_in_group.len)
	return

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

	var/form_data = applied_design.form_data
	icon = generate_augment_preview_icon(form_data["icon_file"], form_data["icon_preview"], form_data["primary_overlay_state"],
		form_data["secondary_overlay_state"], p_color, s_color)

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

/obj/item/augment_tester
	name = "Augment Tester"
	desc = "A device that can check what types of augments the target can use."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "potential_scanner"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/augment_tester/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/stattotal
		for(var/attribute in stats)
			stattotal+=get_attribute_level(H, attribute)
		stattotal /= 4	//Potential is an average of stats
		var/best_augment = round(stattotal/20)
		if(best_augment > 5)
			best_augment = 5
		if(best_augment < 1)
			to_chat(user, span_notice("The target is unable to use any augments."))
			return
		to_chat(user, span_notice("The target is able to use [best_augment] or lower augments."))
		return

	to_chat(user, span_notice("No human identified."))
