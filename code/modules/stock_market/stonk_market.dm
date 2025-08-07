#define STONKUI_MAIN 1
#define STONKUI_HISTORY 2
#define STONKUI_FOCUS 3
#define STONKUI_EXPLAIN 4
#define COMPANY_DELAY 2
/*
* Stonk Investor
* Warning uses defines within the adventure.dm file.
*/
/datum/stonk_investor
	//The name of the stonker
	var/investor_name = "INVESTOR"
	var/budget = 0
	var/display_mode = STONKUI_MAIN
	var/mini_menumode = 1
	var/companyinfo_mode = 1
	var/debug = FALSE
	var/total_profit = 0
	var/datum/stonk_company/focused_company
	/*
	* Company Standard Stonk Time
	*/
	var/static/last_check = 0
	/*
	* Your stonks!
	*/
	var/stonk_history = "Stonk History:<br>"
	var/static/list/company_history = list()
	var/static/list/public_companies

/datum/stonk_investor/New(is_debug = FALSE)
	if(!public_companies)
		InitializeCompanies()
	if(is_debug)
		debug = TRUE
		budget = 500

/datum/stonk_investor/proc/InitializeCompanies()
	public_companies = list(
		new /datum/stonk_company("Georges Pets", "Dogs", company_desc = "\
			\"My ARMY of PUPPERS only GROWS!\" -George <br>\
			A dog breeder.") = 0,
		new /datum/stonk_company("Fixers Ramen", "Ramen",company_desc = "\
			\"Trained under the famous rank 4 chef, <br>\
			come for the best ramen in the district!\"<br> \
			A fixer themed ramen shop.") = 0,
		new /datum/stonk_company("WeRCheese", "Cheese Dolls",company_desc = "\
			\"We are the only source of true cheese.\"<br>\
			A cafe that sells figurines made of cheese.") = 0,
		new /datum/stonk_company("Distilled Angels", "Hard Drink",company_desc = "\
			\"Always remember the Angels share.\"<br>\
			A store that sells hard drinks imported from K corp.") = 0,
		new /datum/stonk_company("Pam\'s Arsenal", "Weapons & Armor",company_desc = "\
			\"You get what you get.\" -Pam<br>\
			A major supplier of the districts Zwei gear.") = 0,
		new /datum/stonk_company("Will\'s Wishing Well", "Lootboxes",company_desc = "\
			\"Ill be honest i dont know what is down there.\" -Well Will<br>\
			A gambling den slash pawn shop.") = 0,
		new /datum/stonk_company("Rival Favilla", "Weapons & Armor",company_desc = "\
			\"Rats are reduced to embers with Favilla!\"<br>\
			Rival weapon store to Pams Arsenal.") = 0,
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
		<tt>----------</tt><br>"
	//General Button already has a . += in its define so it must be written like this.
	GENERAL_BUTTON(REF(requester),"reclaimAhn",REF(src),"WITHDRAWL AHN")
	. += "	BUDGET:[budget]|STONKTIME:[TimeUntilUpdate(0.01)]/[COMPANY_DELAY] MINUTES<br>"

	for(var/mode_option = 1 to 4)
		if(mode_option == STONKUI_FOCUS && !focused_company)
			continue
		GENERAL_BUTTON(REF(requester),"set_display",mode_option,"[mode_option == display_mode ? "<b><u>[nameMenu(mode_option)]</u></b>" : "[nameMenu(mode_option)]"]")
	GENERAL_BUTTON(REF(requester),"rename","rename","RENAME USER")
	if(debug)
		GENERAL_BUTTON(REF(requester),"debug_process","debug_process","ADVANCE TIME 4 CYCLES")
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
		if(STONKUI_EXPLAIN)
			. += "Hello! If your reading this you likely need help with stocks.<br>\
			Stocks are people loaning money to small buisnesses and then<br>\
			collecting on their loan later when the value of the company<br>\
			has improved. Buy LOW, Sell HIGH. This is a good mantra to use<br>\
			but be careful, if a companies optimism becomes BAD, <br>\
			locate this value on the company focus screen, then theres<br>\
			a increasing chance of them going bankrupt which will temporarily<br>\
			remove them from the stock market and reset all of their shares.<br>\
			Bankruptsy can also occur if the value of a stock goes below 1 ahn.<br>\
			As a safety measure companies listed are<br>\
			in a different district to the investor.<br>\
			Stock values change every [COMPANY_DELAY] minutes with<br>\
			[COMPANY_DELAY * 3] resulting in 3 changes when you come back<br>\
			(:\])"

/datum/stonk_investor/proc/StonkMain(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	. = "<tt>\
		----------------------------------<br>\
		|~List of Buisnesses within Range~|<br>\
		-----------------------------------</tt><br>"
	. += "<b>Actions:</b> + Buy, - Sell, ? Focus, ! News Alert<br><br>\
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
			. += "<td>[round(S.current_value, 0.01)]</td>"
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
					<span class='linkOff'>-</span>"
		else
			. += "<a href='?src=[REF(interfacer)];buyshares=[REF(S)]'>+</a> \
				<a href='?src=[REF(interfacer)];sellshares=[REF(S)]'>-</a>"
		. += "<a href='?src=[REF(interfacer)];select_stock=[REF(S)]'>[S.news_notif == TRUE ? "<b>!</b>" : "?"]</a>"

		. += "</tr>"
	. += "</td></table>"

/datum/stonk_investor/proc/StonkHistory(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	for(var/mode_option = 1 to 2)
		GENERAL_BUTTON(REF(interfacer),"set_historydisplay",mode_option,"[mode_option == mini_menumode ? "<b><u>[nameHisMenu(mode_option)]</u></b>" : "[nameHisMenu(mode_option)]"]")
	. += "<br>"
	switch(mini_menumode)
		if(1)
			. += "\
				STONK HISTORY OF [investor_name]<br>\
				TOTAL PROFIT [total_profit]<br>"
			. += stonk_history
		if(2)
			. += "OVERALL STONK HISTORY<br>"
			for(var/i in company_history)
				. += i

/datum/stonk_investor/proc/StonkFocus(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	if(!focused_company)
		return "ERROR NO COMPANY DATA<br>"

	. += focused_company.companyInfo(interfacer, src, viewer, companyinfo_mode, debug)

	/*-----------------------\
	|Numerical Variable Edits|
	\-----------------------*/

		/*-------------------\
		|Stolen TG Stock Code|
		\-------------------*/

/datum/stonk_investor/proc/BuyStonk(datum/stonk_company/S, mob/living/user)
	if (!S || !user)
		return
	var/b = budget
	var/avail = S.available_shares
	var/price = S.current_value
	var/canbuy = round(b / price)
	var/amt = round(input(user, "How many shares? \n(Available: [avail], unit price: [price], can buy: [canbuy])", "Buy shares in [S.name]", 0) as num|null)
	if (!user)
		return
	b = budget

	amt = min(amt, S.available_shares, round(b / S.current_value))
	if (!amt)
		return
	if (!S.buyShares(src, amt))
		to_chat(user, span_danger("Could not complete transaction."))
		return

	var/total = amt * S.current_value
	var/feedback = span_notice("Bought [amt] shares of [S.name] at [S.current_value] a share for [total] ahn.")
	total_profit -= total
	to_chat(user, feedback)
	stonk_history += "[feedback]<br>"

/datum/stonk_investor/proc/SellStonk(datum/stonk_company/S, mob/living/user)
	if (!S || !user)
		return
	var/avail = S.shareholders[src]
	if (!avail)
		to_chat(user, span_danger("This account does not own any shares of [S.name]!"))
		return
	var/price = S.current_value
	var/amt = round(input(user, "How many shares? \n(Have: [avail], unit price: [price])", "Sell shares in [S.name]", 0) as num|null)
	amt = min(amt, S.shareholders[src])

	if (!user)
		return
	if (!amt)
		return

	var/total = amt * S.current_value
	if (!S.sellShares(src, amt))
		to_chat(user, span_danger("Could not complete transaction."))
		return

	var/feedback = span_notice("Sold [amt] shares of [S.name] at [S.current_value] a share for [total] ahn.")
	total_profit += total
	to_chat(user, feedback)
	stonk_history += "[feedback]<br>"

	/*---------\
	|Misc Procs|
	\---------*/

/datum/stonk_investor/proc/addToNews(company_name = "ERROR", txt = "")
	if(length(company_history) >= 10)
		company_history.Cut(1,2)
	company_history += "([company_name])[txt]<br>"

/datum/stonk_investor/proc/nameMenu(cat)
	switch(cat)
		if(STONKUI_MAIN)
			return "MAIN MENU"
		if(STONKUI_HISTORY)
			return "STONK HISTORY"
		if(STONKUI_FOCUS)
			return "SELECTED COMPANY"
		if(STONKUI_EXPLAIN)
			return "STONKS4DUMMIES"

/datum/stonk_investor/proc/nameHisMenu(cat)
	switch(cat)
		if(1)
			return "USER STONK"
		if(2)
			return "ALL STONKS"

/datum/stonk_investor/proc/ReturnStonkValue(datum/stonk_company/company)
	if(company.shareholders[src])
		return company.shareholders[src]
	return 0

/datum/stonk_investor/proc/CatchUp()
	if(!last_check)
		last_check = world.time
		return
	//Stock Market updates every few minutes based on the COMPANY_DELAY.
	var/inbetween_time = TimeUntilUpdate() / COMPANY_DELAY
	if(inbetween_time < 1)
		return
	if(inbetween_time > 10)
		inbetween_time = 8
	ProcessCompanies(inbetween_time)
	//Is there seconds lost inbetween minutes? -IP
	last_check = world.time
	return inbetween_time

/datum/stonk_investor/proc/ProcessCompanies(cycle_amt)
	for(var/cycles = 1 to cycle_amt)
		for(var/datum/stonk_company/SC in public_companies)
			if(!SC)
				continue
			SC.CalculateMinutes(src)

/datum/stonk_investor/proc/TimeUntilUpdate(round_amount = 1)
	return round(((world.time - last_check) / (1 MINUTES)), round_amount)

#undef STONKUI_MAIN
#undef STONKUI_HISTORY
#undef STONKUI_FOCUS
#undef STONKUI_EXPLAIN
#undef COMPANY_DELAY
