#define STONKUI_MAIN 1
#define STONKUI_HISTORY 2
#define STONKUI_FOCUS 3
/*
* Stonk Investor
* Warning uses defines within the adventure.dm file.
*/
/datum/stonk_investor
	//The name of the stonker
	var/investor_name = "Dude"
	var/budget = 0
	var/display_mode = STONKUI_MAIN
	var/debug = FALSE
	var/datum/stonk_company/focused_company
	/*
	* Company Standard Stonk Time
	*/
	var/static/last_login = 0
	/*
	* Your stonks!
	*/
	var/stonk_history = "Stonk History:<br>"
	var/static/list/public_companies

/datum/stonk_investor/New(is_debug = FALSE)
	if(!public_companies)
		InitializeCompanies()
	if(debug)
		debug = TRUE
		budget = 500

/datum/stonk_investor/proc/InitializeCompanies()
	public_companies = list(
		new /datum/stonk_company("Georges Pets", "Dogs", 10, ) = 0,
		new /datum/stonk_company("Fixers Ramen", "Ramen", 10, ) = 0,
		new /datum/stonk_company("WeRCheese", "Cheese Dolls", 10, ) = 0,
		)

	/*---------------\
	|Return Visual UI|
	\---------------*/

/datum/stonk_investor/proc/Stonks(obj/machinery/requester, mob/living/carbon/human/H)
	if(!H.client)
		return

// CSS seems to be presets for what table icons should be colored.
	var/css={"<style>
.change {
	font-weight: bold;
	font-family: monospace;
}
.up {
	background: #00a000;
}
.down {
	background: #a00000;
}
.stable {
	width: 100%
	border-collapse: collapse;
	border: 1px solid #305260;
	border-spacing: 4px 4px;
}
.stable td, .stable th {
	border: 1px solid #305260;
	padding: 0px 3px;
}
.bankrupt {
	border: 1px solid #a00000;
	background: #a00000;
}

a.updated {
	color: red;
}
</style>"}

	. = "<html><head><title>[station_name()] Stock Exchange</title>[css]</head><body><br>\
		<tt>----------</tt><br>\
		BUDGET:[budget]"
	GENERAL_BUTTON(REF(requester),"reclaimAhn",REF(src),"WITHDRAWL AHN")
	. += "<br>"

	for(var/mode_option = STONKUI_MAIN to STONKUI_FOCUS)
		if(mode_option == STONKUI_FOCUS & !focused_company)
			continue
		GENERAL_BUTTON(REF(requester),"set_display",mode_option,"[mode_option == display_mode ? "<b><u>[nameMenu(mode_option)]</u></b>" : "[nameMenu(mode_option)]"]")

	. += "<br>[DisplayUI(requester, H)]<br>\
		<tt>----------</tt><br></body></html>"

	CatchUp()

/datum/stonk_investor/proc/DisplayUI(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	switch(display_mode)
		if(STONKUI_MAIN)
			. += "[StonkMain(interfacer, viewer)]"
		if(STONKUI_HISTORY)
			. += "[StonkHistory(interfacer, viewer)]"
		if(STONKUI_FOCUS)
			. += "[StonkFocus(interfacer, viewer)]"

/datum/stonk_investor/proc/StonkMain(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	. = "<tt>\
		----------------------------------<br>\
		|~List of Buisnesses within Range~|<br>\
		-----------------------------------</tt><br>"
	. += "<b>Actions:</b> + Buy, - Sell, F Focus<br><br>\
		<table class='stable'>\
		<tr><th>&nbsp;</th><th>Name</th><th>Value</th><th>Owned</th><th>Avail</th><th>Actions</th></tr>"
	for(var/datum/stonk_company/S in public_companies)
		if(S.bankrupt)
			. += "<tr class='bankrupt'>"
		else
			. += "<tr>"

		if(S.disp_value_change > 0)
			. += "<td class='change up'>+</td>"
		else if(S.disp_value_change < 0)
			. += "<td class='change down'>-</td>"
		else
			. += "<td class='change'>=</td>"
		//Name
		. += "<td>[S.name]</td>"
		//Value
		if(!S.bankrupt)
			. += "<td>[S.value]</td>"
		else
			. += "<td>0</td>"
		//Owned Shares
		. += "<td>[ReturnStonkValue(S)]</td>"
		//Available Shares
		. += "<td>[S.available_shares]</td>"
		//Actions
		. += "<td>"
		if (S.bankrupt)
			. += "<span class='linkOff'>+</span>\
				 <span class='linkOff'>-</span> "
		else
			. += "<a href='?src=[REF(interfacer)];buyshares=[REF(S)]'>+</a> \
				<a href='?src=[REF(interfacer)];sellshares=[REF(S)]'>-</a> \
				<a href='?src=[REF(interfacer)];select_stock=[REF(S)]'>F</a>"

		. += "</tr>"
	. += "</td></table>"

/datum/stonk_investor/proc/StonkHistory(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	. = "STONK HISTORY OF [investor_name]<br>"
	. += stonk_history

/datum/stonk_investor/proc/StonkFocus(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	if(!focused_company)
		return "ERROR NO COMPANY DATA<br>"

	. += focused_company.companyInfo(interfacer, src, viewer)

	/*-----------------------\
	|Numerical Variable Edits|
	\-----------------------*/

/datum/stonk_investor/proc/AdjustStonk(amt, datum/stonk_company/stonk)
	var/actual_value = amt
	var/logging_text = ""
	if(amt > 0)
		actual_value = clamp(amt, 0, budget)
		logging_text = "$[actual_value]$ worth of [stonk.name] shares invested."
	if(amt < 0)
		actual_value = clamp(amt, 0, -1 * stonk.value)
		logging_text = "$[actual_value]$ worth of [stonk.name] shares sold."
	if(!actual_value)
		return
	budget -= actual_value
	public_companies[stonk] += actual_value
	stonk_history += "[logging_text]<br>"

	/*---------\
	|Misc Procs|
	\---------*/

/datum/stonk_investor/proc/nameMenu(cat)
	switch(cat)
		if(STONKUI_MAIN)
			return "MAIN MENU"
		if(STONKUI_HISTORY)
			return "STONK HISTORY"
		if(STONKUI_FOCUS)
			return "SELECTED COMPANY"

/datum/stonk_investor/proc/ReturnStonkValue(company)
	return public_companies[company]

/datum/stonk_investor/proc/CatchUp()
	if(last_login)
		return
	last_login = world.time
