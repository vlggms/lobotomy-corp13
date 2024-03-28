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
	//Saved profiles that are password locked
	var/list/profile_list = list()

//Console with debug text adventure program for testing.
/obj/machinery/text_adventure_console/debug/Initialize()
	. = ..()
	NewProfile(TRUE)

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
	if(adventure_data)
		dat += adventure_data.Adventure(src, user)
		dat += "<br><A href='byond://?src=[REF(src)];log_out_profile=[REF(src)]'>LOG OUT</A><br>\
			<A href='byond://?src=[REF(src)];new_profile_password=[REF(src)]'>CREATE PASSWORD</A>"
	else
		dat += ProfileMenu()
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

	//Profile Selection
	if(href_list["profile"])
		var/set_profile = profile_list[text2num(href_list["profile"])]
		if(!set_profile)
			updateUsrDialog()
			return TRUE
		if(profile_list[set_profile] != null)
			var/input_password = input(usr, "PLEASE TYPE IN PASSWORD", "PASSWORD INPUT") as null|num
			if(input_password != profile_list[set_profile])
				to_chat(usr, span_notice("INCORRECT PASSWORD"))
				return TRUE
		adventure_data = set_profile
		updateUsrDialog()
		return TRUE

	if(href_list["log_out_profile"])
		adventure_data = null
		updateUsrDialog()
		return TRUE

	if(href_list["new_profile"])
		NewProfile()
		updateUsrDialog()
		return TRUE

	if(href_list["new_profile_password"])
		var/new_password = input(usr, "PLEASE TYPE IN 3 DIGIT PASSWORD", "PASSWORD INPUT") as null|num
		if(new_password)
			profile_list[adventure_data] = clamp(new_password,100,999)
			to_chat(usr, span_notice("PASSWORD SUCCESSFULLY CHANGED TO [profile_list[adventure_data]]"))
			updateUsrDialog()
			return TRUE

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

/obj/machinery/text_adventure_console/proc/ProfileMenu(href, href_list)
	. = "<tt>\
		-------------------<br>\
		|PROFILE SELECTION|<br>\
		-------------------<br></tt>"
	var/profile_num = 1
	for(var/i in profile_list)
		if(i)
			. += "|<A href='byond://?src=[REF(src)];profile=[profile_num]'>PROFILE [profile_num]</A><br>"
			profile_num++

	. += "|<A href='byond://?src=[REF(src)];new_profile=[ref(src)]'>NEW PROFILE</A><br>\
		<tt>-----------------</tt>"

/obj/machinery/text_adventure_console/proc/NewProfile(debug_profile = FALSE)
	if(profile_list.len > 4)
		to_chat(usr, span_notice("MAXIMUM PROFILES REACHED"))
		return
	var/new_profile = new /datum/adventure_layout(debug_profile)
	profile_list += new_profile
	profile_list[new_profile] = null
	adventure_data = new_profile
