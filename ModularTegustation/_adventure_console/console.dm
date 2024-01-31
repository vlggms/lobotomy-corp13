/obj/machinery/text_adventure_console
	name = "adventure console"
	desc = "This computer has a program on it that can decrypt abnormality data."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "nanite_program_hub"
	//Feels weird to make it indestructable but it is a unique machine.
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	density = TRUE
	//Keepin it simple and soft coded.
	var/datum/adventure_layout/adventure_data

//Console with debug text adventure program for testing.
/obj/machinery/text_adventure_console/debug/Initialize()
	. = ..()
	if(!adventure_data)
		adventure_data = new(TRUE)

//Stolen from nanite_program_hub.dm
/obj/machinery/text_adventure_console/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	SSvis_overlays.add_vis_overlay(src, icon, "nanite_program_hub_on", layer, plane)
	SSvis_overlays.add_vis_overlay(src, icon, "nanite_program_hub_on", EMISSIVE_LAYER, EMISSIVE_PLANE)

/obj/machinery/text_adventure_console/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	if(!adventure_data)
		adventure_data = new
	dat += adventure_data.Adventure(src, user)
	var/datum/browser/popup = new(user, "Adventure", "AdventureTest", 500, 600)
	popup.set_content(dat)
	popup.open()
	return

//This is where the magic happens with the adventure datum. Choices in the datum are returned and processed here.
/obj/machinery/text_adventure_console/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(!ishuman(usr))
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	//Setting display menu for the text adventure.
	if(href_list["set_display"])
		var/set_display = text2num(href_list["set_display"])
		if(!(set_display < 1 || set_display > 3) && set_display != adventure_data.display_mode)
			adventure_data.display_mode = set_display
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

	//Adventure Mode choice reaction.
	if(href_list["travel"])
		var/travel_num = text2num(href_list["travel"])
		adventure_data.AdventureModeReact(travel_num)
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		updateUsrDialog()
		return TRUE

	//Choosing an adventure from the event options.
	if(href_list["adventure"])
		/**
		 * There must be a better way of doing this because returning
		 * A itself just brings the name instead of the instance.
		 * -IP
		 */
		var/created_event = text2path(href_list["adventure"])
		adventure_data.GenerateEvent(created_event)
		playsound(get_turf(src), 'sound/machines/uplinkpurchase.ogg', 50, TRUE)
		updateUsrDialog()
		return TRUE

	//Event choices.
	if(href_list["choice"])
		var/reaction = text2num(href_list["choice"])

		//Remotely call event reaction with our choice.
		adventure_data.event_data.EventReact(reaction)

		//Essential for refreshing the UI after completing a event.
		playsound(get_turf(src), 'sound/machines/pda_button2.ogg', 50, TRUE)
		updateUsrDialog()
		return TRUE

	if(href_list["extra_chance"])

		//Remotely call event reaction with our choice.
		adventure_data.event_data.AddChanceReact()

		//Essential for refreshing the UI after completing a event.
		playsound(get_turf(src), 'sound/machines/pda_button2.ogg', 50, TRUE)
		updateUsrDialog()
		return TRUE

	//For very niche effects and conditions.
	if(href_list["event_misc"])
		var/reaction = text2num(href_list["event_misc"])

		//Remotely call event reaction with our choice.
		adventure_data.event_data.ChanceCords(reaction)

		//Essential for refreshing the UI after completing a event.
		playsound(get_turf(src), 'sound/machines/pda_button2.ogg', 50, TRUE)
		updateUsrDialog()
		return TRUE
