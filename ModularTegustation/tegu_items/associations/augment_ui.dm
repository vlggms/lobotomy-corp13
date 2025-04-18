//--------------------------------------
// Augment Fabricator TGUI Handler Datum
//--------------------------------------
/datum/tgui_handler/augment_fabricator
	/// The machine instance this handler is managing the UI for.
	var/obj/machinery/augment_fabricator/machine = null

	/// The TGUI key associated with the frontend component.
	var/const/ui_key = "AugmentFabricator" // Match the JS component key

	/// Track the validation datum temporarily during fabrication attempt
	var/datum/augment_design/current_validation_design = null

	var/cached_preview_base64 = null

/datum/tgui_handler/augment_fabricator/New(obj/machinery/augment_fabricator/holder)
	// Call parent's New if inheriting from a base handler
	// ..()
	if(!istype(holder))
		CRASH("Augment Fabricator TGUI Handler received an invalid holder: [holder]")
	src.machine = holder
	RegisterSignal(machine, COMSIG_PARENT_QDELETING, PROC_REF(on_holder_qdel))
	log_runtime("Augment Fabricator TGUI Handler created for [machine]")

/datum/tgui_handler/augment_fabricator/Destroy()
	log_runtime("Augment Fabricator TGUI Handler destroyed for [machine]")
	machine = null
	qdel(current_validation_design)
	current_validation_design = null
	cached_preview_base64 = null
	return ..()

/// Called when the machine is qdeleted.
/datum/tgui_handler/augment_fabricator/proc/on_holder_qdel(atom/source, force)
	SIGNAL_HANDLER
	log_runtime("Augment Fabricator TGUI Handler cleaning up due to holder qdel: [source]")
	qdel(src) // Delete the handler datum itself

// --- Standard TGUI Datum Procs ---

/// Returns the object the user is physically interacting with.
/datum/tgui_handler/augment_fabricator/ui_host(mob/user)
	return machine

/// Determines if the user can still interact with the UI.
/datum/tgui_handler/augment_fabricator/ui_status(mob/user)
	if (machine && machine.Adjacent(user) && !user.incapacitated() ) // Add access check if needed: && machine.check_access(user.get_id_card()))
		// Consider adding machine power check etc. here
		return UI_INTERACTIVE // Or specific status if needed
	return UI_CLOSE // Close UI if interaction is no longer valid

/// Standard UI state.
/datum/tgui_handler/augment_fabricator/ui_state(mob/user)
	return GLOB.physical_state // Or a machine-specific state if applicable

/datum/tgui_handler/augment_fabricator/proc/update_uis()
	SStgui.update_uis(src)

/// Opens or updates the TGUI window for the user.
/datum/tgui_handler/augment_fabricator/ui_interact(mob/user, datum/tgui/ui = null)
	if(!machine)
		log_runtime("ui_interact called on handler with no machine for [user]")
		return FALSE

	log_tgui(user, src, "Attempting Interaction via Handler") // Log using the handler as src

	// Try to update existing UI, using the handler datum (src) as the key object
	ui = SStgui.try_update_ui(user, src, ui)
	if (ui)
		log_tgui(user, src, "Updated existing UI via Handler")
		return TRUE

	// Create a new UI instance if none exists
	log_tgui(user, src, "Creating new UI via Handler")
	// Use the handler (src) as the source object, but the machine's name for the title
	ui = new(user, src, src.ui_key, "[machine.name] Configuration") // Adjust constructor args as needed

	if(ui)
		ui.open()
		log_tgui(user, src, "Opened new UI via Handler")
		return TRUE
	else
		log_admin("Failed to create tgui instance via handler for [user] and [machine]")
		return FALSE

/// Provides data to the TGUI interface.
/datum/tgui_handler/augment_fabricator/ui_data(mob/user)
	if(!machine)
		log_runtime("ui_data called on handler with no machine for [user]")
		return list() // Return empty list on error

	var/list/data = list()

	// Get data directly from the machine instance
	data["forms"] = list()
	for(var/form_key in machine.available_forms) // Iterate by key to get full list data
		var/list/form_details = machine.available_forms[form_key]
		// Make sure critical fields exist before adding
		if(form_details && form_details["id"] && form_details["icon_file"] && form_details["icon_preview"])
			data["forms"] += list(form_details) // Send copy of the full form details list
		else
			log_runtime("Skipping invalid form definition '[form_key]' in [src] ui_data.")

	data["effects"] = list()
	for(var/list/effect_data in machine.available_effects) // Iterate through the list of lists
		data["effects"] += list(effect_data.Copy()) // Send copy

	data["maxRank"] = machine.maxRank
	data["rankAttributeReqs"] = machine.rankAttributeReqs
	data["currencySymbol"] = machine.currencySymbol

	data["previewIconBase64"] = src.cached_preview_base64

	return data

/// Handles actions sent from the UI. Replaces Topic handling for UI actions.
/datum/tgui_handler/augment_fabricator/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	// Ensure UI object is valid as we'll need it for updates
	if(!machine || !ui || ui_status(usr) == UI_CLOSE)
		return TRUE

	// --- Variable to track if an update is needed by the action ---
	var/needs_update = FALSE
	// --- Variable to track if the action was handled (to prevent falling through to parent) ---
	var/action_handled = FALSE

	// --- Fabrication Action (Clear cache as part of final action) ---
	if(action == "fabricate")
		action_handled = TRUE // Mark action as handled
		log_tgui(usr, src, "ui_act: fabricate")

		if(current_validation_design)
			log_tgui(usr, src, "ui_act: fabricate rejected, already processing.")
			return TRUE // Already processing, stop here

		var/list/config
		var/config_json = params["config"]
		if(!config_json) /* Handle missing config */ return TRUE
		config = json_decode(config_json)
		if(!istype(config, /list)) /* Handle malformed config */ return TRUE

		// --- Server-side Validation ---
		var/form_id = config["form"] // Get ID from config
		var/rank = clamp(text2num(config["rank"]), 1, machine.maxRank)
		var/list/selected_effect_ids = config["selectedEffects"]
		if(!istype(selected_effect_ids, /list))
			selected_effect_ids = list()

		// --- Find form name from ID for validation call (if needed) ---
		// NOTE: Assumes validate_and_calculate needs the NAME, not ID. Adjust if it takes ID.
		var/form_name = null
		for (var/key in machine.available_forms)
			if (machine.available_forms[key] && machine.available_forms[key]["id"] == form_id)
				form_name = machine.available_forms[key]["name"]
				break
		if (!form_name)
			to_chat(usr, "<span class='warning'>Invalid augment form selected. Fabrication cancelled.</span>")
			return TRUE // Stop fabrication

		current_validation_design = new()
		if(!current_validation_design.validate_and_calculate(form_name, rank, selected_effect_ids, machine))
			to_chat(usr, "<span class='warning'>Invalid augment configuration. Reason: [current_validation_design.validation_error || "Validation error"]</span>")
			qdel(current_validation_design)
			current_validation_design = null
			return TRUE // Stop fabrication

		// Extract sanitized data
		//var/total_ahn_cost = current_validation_design.total_ahn_cost
		var/creator_name = sanitize_text(config["name"], 64)
		var/creator_desc = sanitize_text(config["description"], 256)
		var/primary_color = sanitize_hex_color(config["primaryColor"])
		var/secondary_color = sanitize_hex_color(config["secondaryColor"])

		// --- Perform Fabrication ---
		to_chat(usr, "<span class='notice'>Initiating fabrication process...</span>")
		var/obj/item/augment/new_augment = machine.perform_fabrication(usr, current_validation_design, creator_name, creator_desc, primary_color, secondary_color)

		if(new_augment)
			to_chat(usr, "<span class='good'>Fabrication complete! [new_augment] is ready.</span>")
			src.cached_preview_base64 = null // Clear cache on successful fabrication
			qdel(current_validation_design) // Clean up successful design datum
			current_validation_design = null
			SStgui.close_user_uis(usr, src) // Close UI
			return TRUE // Stop processing since UI is closed
		else
			// Fabrication failed (perform_fabrication should have messaged user)
			to_chat(usr, "<span class='warning'>Fabrication failed.</span>") // Generic fallback message
			src.cached_preview_base64 = null // Clear cache on failure too
			needs_update = FALSE // No update needed, failure message is enough? Or set TRUE if UI should refresh state.
			qdel(current_validation_design) // Clean up failed design datum
			current_validation_design = null
			// Fall through to potential update if needs_update was set TRUE

	// --- Preview Icon Generation Action (REVISED V2) ---
	else if (action == "get_preview_icon")
		action_handled = TRUE // Mark action as handled
		var/form_id = params["formId"]
		var/primary_color_hex = params["primaryColor"]
		var/secondary_color_hex = params["secondaryColor"]
		log_tgui(usr, src, "ui_act: get_preview_icon (Form: [form_id], P: [primary_color_hex], S: [secondary_color_hex])")

		var/list/form_data = null
		for(var/key in machine.available_forms)
			if(machine.available_forms[key] && machine.available_forms[key]["id"] == form_id)
				form_data = machine.available_forms[key];
				break

		var/base64_icon = null // Default to null

		if (!form_data || !form_data["icon_file"] || !form_data["icon_preview"])
			log_runtime("Invalid form_id '[form_id]' or missing icon data for preview.")
			// Keep base64_icon as null
		else
			// Sanitize colors, generate icon, encode to base64_icon
			var/s_primary = sanitize_hex_color(primary_color_hex, "#FFFFFF")
			var/s_secondary = sanitize_hex_color(secondary_color_hex, "#888888")
			var/icon/final_icon = generate_augment_preview_icon(form_data["icon_file"], form_data["icon_preview"], form_data["primary_overlay_state"], form_data["secondary_overlay_state"], s_primary, s_secondary)
			if(final_icon)
				base64_icon = icon2base64(final_icon)
				qdel(final_icon)

		// --- REVISED V2: Store result directly. Mark for update. ---
		// Only update cache if the new value is different (prevents redundant updates if colors typed quickly)
		if (src.cached_preview_base64 != base64_icon)
			src.cached_preview_base64 = base64_icon
			needs_update = TRUE // Mark that an update IS needed
			log_tgui(usr, src, "Stored new preview icon ([!isnull(base64_icon) ? "Data" : "Null"]), marked for UI update.")
		else
			log_tgui(usr, src, "Preview icon unchanged, no update triggered.")
			// No update needed if the result is the same as what's already cached
			needs_update = FALSE


	// --- Add other actions here if needed ---
	// else if (action == "some_other_action") {
	//     action_handled = TRUE
	//     // ... do stuff ...
	//     needs_update = TRUE // If this action changes state visible in ui_data
	// }

	// --- Trigger update *if* any action above marked it as needed ---
	if (needs_update)
		// Use targeted update for the specific UI instance that sent the action
		SStgui.update_uis(src)

	// Return TRUE if the action was specifically handled by this ui_act,
	// otherwise return null or ..() to let parent Topics handle it.
	if (action_handled)
		return TRUE

	return ..()

/proc/generate_augment_preview_icon(icon_file, base_state, primary_overlay_state, secondary_overlay_state, primary_color, secondary_color)
	// Basic validation
	if (!icon_file || !base_state)
		log_runtime("generate_augment_preview_icon missing required args: file='[icon_file]', state='[base_state]'")
		return null

	// Check if the base state exists in the file
	if(!(base_state in icon_states(icon(icon_file))))
		log_runtime("Base state '[base_state]' not found in icon file '[icon_file]'")
		return null // Return null if base state doesn't exist

	// Create the base image
	// Using /image directly avoids needing a dummy atom
	var/image/base_image = image(icon = icon_file, icon_state = base_state)
	if(!base_image)
		return null // Failed to create base image

	// List to hold overlays
	base_image.overlays = list()

	// Create and add Primary Color Overlay (if state and color are valid)
	if (primary_overlay_state && primary_color && (primary_overlay_state in icon_states(icon(icon_file))))
		var/image/primary_overlay = image(icon = icon_file, icon_state = primary_overlay_state)
		primary_overlay.color = primary_color // Apply the color directly to the overlay image
		primary_overlay.layer = 1 // Ensure overlays are drawn above base (adjust layer if needed)
		base_image.overlays += primary_overlay
	else if(primary_overlay_state && !(primary_overlay_state in icon_states(icon(icon_file))))
		log_runtime("Primary overlay state '[primary_overlay_state]' not found in '[icon_file]'")


	// Create and add Secondary Color Overlay (if state and color are valid)
	if (secondary_overlay_state && secondary_color && (secondary_overlay_state in icon_states(icon(icon_file))))
		var/image/secondary_overlay = image(icon = icon_file, icon_state = secondary_overlay_state)
		secondary_overlay.color = secondary_color // Apply color
		secondary_overlay.layer = 2 // Ensure secondary is drawn over primary (adjust layer if needed)
		base_image.overlays += secondary_overlay
	else if(secondary_overlay_state && !(secondary_overlay_state in icon_states(icon(icon_file))))
		log_runtime("Secondary overlay state '[secondary_overlay_state]' not found in '[icon_file]'")

	// Flatten the image and its overlays into a single icon using getFlatIcon
	// getFlatIcon handles applying the colors and overlays correctly.
	// Pass no_anim=TRUE for potentially better performance/consistency if animation isn't needed.
	var/icon/flat_icon = getFlatIcon(base_image, no_anim = TRUE)

	// getFlatIcon returns a new icon object, the original /image is not needed anymore
	// qdel(base_image) // qdel overlays is handled by GC when base_image is qdelled/GC'd

	return flat_icon // Return the final flattened icon object
