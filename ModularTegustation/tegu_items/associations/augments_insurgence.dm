/obj/machinery/augment_fabricator/insurgence
	name = "Insurgence Augment Fabricator"
	desc = "A specialized machine that produces augments with... unique properties. The prices seem too good to be true."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "protolathe"

	roles = list("Insurgence Transport Agent", "Insurgence Nightwatch Agent", "Prosthetics Surgeon", "Office Director", "Office Fixer", "Doctor")
	sale_percentages = list(75, 80, 90) // Even better discounts
	on_sale_pct = 1.0 // Everything is always on sale
	markup_pct = 0

	var/locked = TRUE
	var/lockout_time = 0
	var/initial_lockout_duration = 6000 // 10 minutes in deciseconds

/obj/machinery/augment_fabricator/insurgence/Initialize()
	. = ..()
	// Add Mental Corrosion as a forced negative effect for all Insurgence augments
	for(var/list/effect in available_effects)
		if(effect["id"] == "mental_corrosion")
			effect["forced"] = TRUE // This effect is always included
			effect["ahn_cost"] = 0 // Free!
			break

	// Set lockout timer
	lockout_time = world.time + initial_lockout_duration
	addtimer(CALLBACK(src, PROC_REF(unlock_fabricator)), initial_lockout_duration)
	update_icon()

/obj/machinery/augment_fabricator/insurgence/proc/unlock_fabricator()
	locked = FALSE
	update_icon()
	playsound(src, 'sound/machines/ping.ogg', 50, TRUE)

	// Alert all Insurgence members
	for(var/mob/M in GLOB.player_list)
		if(!M.mind || !M.client)
			continue
		if(M.mind.assigned_role in list("Insurgence Transport Agent", "Insurgence Nightwatch Agent"))
			to_chat(M, span_nicegreen("<b>ALERT:</b> The Insurgence augment fabricator is now operational! You may begin distributing augments."))
			M.playsound_local(M, 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)

/obj/machinery/augment_fabricator/insurgence/ui_interact(mob/user, datum/tgui/ui = null)
	if(locked)
		var/time_left = max(0, round((lockout_time - world.time) / 10)) // Convert to seconds
		to_chat(user, span_warning("The fabricator is still calibrating... [time_left] seconds remaining."))
		playsound(src, 'sound/machines/buzz-two.ogg', 30, TRUE)
		return
	return ..()

/obj/machinery/augment_fabricator/insurgence/attack_hand(mob/user)
	if(locked)
		var/time_left = max(0, round((lockout_time - world.time) / 10)) // Convert to seconds
		to_chat(user, span_warning("The fabricator is still calibrating... [time_left] seconds remaining."))
		playsound(src, 'sound/machines/buzz-two.ogg', 30, TRUE)
		return
	return ..()

/obj/machinery/augment_fabricator/insurgence/examine(mob/user)
	. = ..()
	if(locked)
		var/time_left = max(0, round((lockout_time - world.time) / 10)) // Convert to seconds
		. += span_warning("The system is locked down for calibration. Time remaining: [time_left] seconds.")
	else
		. += span_nicegreen("The system is fully operational.")

/obj/machinery/augment_fabricator/insurgence/update_icon()
	. = ..()
	if(locked)
		icon_state = "protolathe"
	else
		icon_state = "protolathe_n"

/obj/machinery/augment_fabricator/insurgence/make_new_augment()
	return new /obj/item/augment/insurgence

/obj/item/augment/insurgence
	name = "modified augment"
	desc = "This augment seems to have been modified with additional components. The modifications are seamlessly integrated."
	rankAttributeReqs = list(0, 20, 40, 60, 80) // 20 reduction as stated in the MD
	roles = list("Insurgence Transport Agent", "Insurgence Nightwatch Agent")

/obj/item/augment/insurgence/ApplyEffects(mob/living/carbon/human/H)
	. = ..()
	// Force apply Mental Corrosion if not already present
	var/has_corrosion = FALSE
	for(var/datum/component/augment/mental_corrosion/MC in H.GetComponents(/datum/component/augment/mental_corrosion))
		has_corrosion = TRUE
		break

	if(!has_corrosion)
		H.AddComponent(/datum/component/augment/mental_corrosion, 1)
		to_chat(H, span_notice("The augment integrates seamlessly with your body... though something feels different."))

// Tracking console for Insurgence Clan
/obj/machinery/computer/insurgence_tracker
	name = "augment monitoring console"
	desc = "Monitors the status of distributed augments and their users."
	icon_screen = "comm_logs"
	var/list/tracked_augments = list()

/obj/machinery/computer/insurgence_tracker/ui_interact(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind || !(H.mind.assigned_role in list("Insurgence Transport Agent", "Insurgence Nightwatch Agent")))
		to_chat(user, span_warning("Access denied. Insurgence credentials required."))
		return

	var/dat = "<h3>Augment User Tracking</h3><hr>"
	dat += "<table border='1' style='width:100%'>"
	dat += "<tr><th>Subject</th><th>Location</th><th>Health</th><th>Corrosion</th><th>Bonds</th></tr>"

	// Find all humans with mental corrosion
	for(var/mob/living/carbon/human/target in GLOB.alive_mob_list)
		if(!target.mind)
			continue
		for(var/datum/component/augment/mental_corrosion/MC in target.GetComponents(/datum/component/augment/mental_corrosion))
			dat += "<tr>"
			dat += "<td>[target.real_name]</td>"
			dat += "<td>[get_area_name(target)]</td>"
			dat += "<td>[target.health]/[target.maxHealth]</td>"
			dat += "<td><b>[MC.corrosion_level]%</b></td>"

			// Build bonds list
			var/bonds_text = ""
			if(MC.bonds.len > 0)
				var/list/bond_names = list()
				for(var/mob/living/carbon/human/bonded in MC.bonds)
					if(bonded && bonded.real_name)
						bond_names += bonded.real_name
				bonds_text = jointext(bond_names, ", ")
			else
				bonds_text = "None"
			dat += "<td>[bonds_text]</td>"
			dat += "</tr>"

	dat += "</table>"
	dat += "<hr><i>Remember: The Elder One watches. Guide them to the water when ready.</i>"

	var/datum/browser/popup = new(user, "insurgence_tracker", "Augment Monitoring", 600, 400)
	popup.set_content(dat)
	popup.open()
