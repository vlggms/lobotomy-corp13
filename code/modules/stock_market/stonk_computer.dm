/obj/machinery/stonkmarket
	name = "stonk exchange computer"
	desc = "A console that connects to the local stonk market."
	icon = 'icons/obj/computer.dmi'
	icon_state = "oldcomp"
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	density = TRUE
	//Keepin it simple and soft coded.
	var/datum/stonk_investor/trader_program
	//Saved profiles that are password locked
	var/list/profile_list = list()

//Console with debug program for testing.
/obj/machinery/stonkmarket/debug/Initialize()
	. = ..()
	NewProfile(TRUE)

/obj/machinery/stonkmarket/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/holochip) && trader_program)
		var/obj/item/holochip/H = I
		var/ahn_amount = H.get_item_credit_value()
		H.spend(ahn_amount)
		AdjustMonies(ahn_amount)
		return
	else
		return ..()

/obj/machinery/stonkmarket/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	if(trader_program)
		dat += trader_program.Stonks(src, user)
		dat += "<br><A href='byond://?src=[REF(src)];log_out_profile=[REF(src)]'>LOG OUT</A><br>"
		//Unsure if this method is extremely bad. -IP
		if(profile_list.Find(trader_program) != 1)
			dat += "<A href='byond://?src=[REF(src)];new_profile_password=[REF(src)]'>CREATE PASSWORD</A>"
	else
		dat += ProfileMenu()
	var/datum/browser/popup = new(user, "stonks", "StonkMarket", 600, 600)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/stonkmarket/Topic(href, href_list)
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
		trader_program = set_profile
		updateUsrDialog()
		return TRUE

	if(href_list["log_out_profile"])
		trader_program = null
		updateUsrDialog()
		return TRUE

	if(href_list["new_profile"])
		if(!length(profile_list))
			to_chat(usr, "FIRST PROFILE IS ALWAYS A PUBLIC ACCOUNT")
		NewProfile()
		updateUsrDialog()
		return TRUE

	if(href_list["new_profile_password"])
		var/new_password = input(usr, "PLEASE TYPE IN 3 DIGIT PASSWORD", "PASSWORD INPUT") as null|num
		if(new_password)
			profile_list[trader_program] = clamp(new_password,100,999)
			to_chat(usr, span_notice("PASSWORD SUCCESSFULLY CHANGED TO [profile_list[trader_program]]"))
			updateUsrDialog()
			return TRUE

	//Program Inputs

	if(href_list["set_display"])
		var/set_display = text2num(href_list["set_display"])
		if(isnum(set_display) && set_display != trader_program.display_mode)
			trader_program.display_mode = set_display
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

	if(href_list["set_historydisplay"])
		var/set_display = text2num(href_list["set_historydisplay"])
		if(isnum(set_display) && set_display != trader_program.mini_menumode)
			trader_program.mini_menumode = set_display
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

	if(href_list["companymenubutton"])
		var/set_display = text2num(href_list["companymenubutton"])
		if(isnum(set_display) && set_display != trader_program.display_mode)
			trader_program.companyinfo_mode = set_display
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

	if(href_list["select_stock"])
		var/datum/stonk_company/focus_company = locate(href_list["select_stock"]) in trader_program.public_companies
		if(focus_company != trader_program.focused_company)
			trader_program.focused_company = focus_company
			//Automatically go to stock menu
			trader_program.display_mode = 3
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

	//Functional Inputs

	if (href_list["reclaimAhn"])
		var/credits = input(usr, "WITHDRAWL AMOUNT", "WITHDRAW AHN") as null|num
		if(credits)
			RefundMonies(credits)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

	if (href_list["buyshares"])
		var/datum/stonk_company/S = locate(href_list["buyshares"]) in trader_program.public_companies
		if(S)
			trader_program.BuyStonk(S, usr)
			updateUsrDialog()
			return TRUE

	if (href_list["sellshares"])
		var/datum/stonk_company/S = locate(href_list["sellshares"]) in trader_program.public_companies
		if(S)
			trader_program.SellStonk(S, usr)
			updateUsrDialog()
			return TRUE

	if(href_list["rename"])
		var/new_username = input(usr, "PLEASE TYPE IN USERNAME", "USERNAME INPUT") as null|text
		if(new_username)
			trader_program.investor_name = new_username
			to_chat(usr, span_notice("USERNAME SUCCESSFULLY CHANGED TO [trader_program.investor_name]"))
			updateUsrDialog()
			return TRUE

	if(href_list["debug_process"])
		trader_program.ProcessCompanies(4)
		to_chat(usr, span_notice("STONK PROGRAM PROCESSED 4 CYCLES"))
		updateUsrDialog()
		return TRUE

/obj/machinery/stonkmarket/proc/ProfileMenu(href, href_list)
	. = "<tt>\
		-------------------<br>\
		|PROFILE SELECTION|<br>\
		-------------------<br></tt>"
	var/profile_num = 1
	for(var/i in profile_list)
			//Guest profile is the true first variable in the list. So for display the 2nd profile is the 1st one.
		if(profile_num == 1)
			. += "|<A href='byond://?src=[REF(src)];profile=1'>PUBLIC PROFILE</A><br>"
		else
			. += "|<A href='byond://?src=[REF(src)];profile=[profile_num]'>PROFILE [profile_num - 1]</A><br>"
		profile_num++
	. += "|<A href='byond://?src=[REF(src)];new_profile=[ref(src)]'>NEW PROFILE</A><br>\
		<tt>-----------------</tt>"

/obj/machinery/stonkmarket/proc/NewProfile(debug_profile = FALSE)
	if(length(profile_list) > 4)
		to_chat(usr, span_notice("MAXIMUM PROFILES REACHED"))
		return
	var/new_profile = new /datum/stonk_investor(debug_profile)
	profile_list += new_profile
	profile_list[new_profile] = null
	trader_program = new_profile

/obj/machinery/stonkmarket/proc/AdjustMonies(new_monies)
	trader_program.budget += new_monies

/obj/machinery/stonkmarket/proc/RefundMonies(refund_monies)
	if(refund_monies <= 0 || !trader_program)
		return
	var/obj/item/holochip/holochip = new (get_turf(src))
	holochip.credits = refund_monies
	holochip.name = "[holochip.credits] ahn holochip"
	AdjustMonies(-1 * refund_monies)
