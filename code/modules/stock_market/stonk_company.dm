/*
* This is a butchered ramshackle version
* of TG stocks code.
*/

/datum/stonk_company
	var/name
	var/desc = "An upstart company formed from a group of \"reformed\" rats from the backstreets."
	var/product = "Scrap & Guts"
	var/current_value = 100
	var/last_value = 100

	// The current performance of the company. Tends itself to 0 when no events happen.
	var/performance = 0

	/*
	* These variables determine standard fluctuational patterns for this stock.
	* How much the price fluctuates on an average daily basis
	* NOTE: I set this to 3 and the stock went to 20000+
	*/
	var/fluctuational_coefficient = 1
	// The history of shareholder optimism of this stock
	var/average_optimism = 0
	// Used in Fluctuate()
	var/current_trend = 0
	var/last_trend = 0
	var/speculation = 0
	var/bankrupt = 0
	//A value to prevent exponential growth, decay.
	var/value_decay = 0
	//ISSUE: This will become false if anyone checks the news.
	var/news_notif = FALSE

	var/disp_value_change = 0
	/*
	* Optimism is a value effected by random events.
	* If optimism is in the negative then the company
	* has a chance of becoming bankrupt.
	* Optimism also effects the fluctuate() proc
	* that alters stock values.
	*/
	var/optimism = 0
	var/average_shares = 100
	var/outside_shareholders = 5
	var/available_shares = 100
	var/fluctuation_rate = 15
	var/fluctuation_counter = 0
	var/list/news = list()
	var/list/values = list()
	var/list/shareholders = list()

/datum/stonk_company/New(company_name, company_product, company_value, company_desc)
	name = company_name
	if(company_product)
		product = company_product
	if(company_value)
		current_value = company_value
		values = list(company_value)
	else
		//Gimme a value that is 10% to 100% of default value.
		current_value = current_value * (rand(35,200) / 100)
	if(company_desc)
		desc = company_desc


	/*----------\
	|UI ELEMENTS|
	\----------*/

/datum/stonk_company/proc/companyInfo(obj/machinery/interfacer, datum/stonk_investor/investor, mob/living/carbon/human/viewer, mode = 1, debug_mode = FALSE)
	. = "ID:[name]<br>\
		Desc:[desc]<br>\
		Product:[product]| Value:[current_value]| "
	if(investor)
		. += "Shares:[investor.ReturnStonkValue(src)]|"
	if(debug_mode)
		. += "<br>optimism:[optimism]|<br>\
			current_trend:[current_trend]|last_trend:[last_trend]|<br>\
			fluctuational_coefficient:[fluctuational_coefficient]|<br>\
			fluctuation_rate:[fluctuation_rate]|fluctuation_counter:[fluctuation_counter]<br>\
			speculation:[speculation]|performance:[performance]"
	else
		. += "<br>\
			Optimism:[NameOptimism(optimism)]|"
	. += "<br>"
	GENERAL_BUTTON(REF(interfacer),"buyshares",REF(src),"Buy")
	. += " "
	GENERAL_BUTTON(REF(interfacer),"sellshares",REF(src),"Sell")
	. += "<br>"
	for(var/i = 1 to 2)
		GENERAL_BUTTON(REF(interfacer),"companymenubutton",i,"[NameButtons(i)]")
	. += "<br>"
	switch(mode)
		if(1)
			. += plotBarGraph(values, "[name] share value per share")
		if(2)
			. += "Financial News <br>"
			for(var/i in news)
				. += i
	news_notif = FALSE

/datum/stonk_company/proc/NameButtons(butt)
	switch(butt)
		if(1)
			return "BAR GRAPH"
		if(2)
			return "NEWS"

/datum/stonk_company/proc/NameOptimism(val)
	var/refined_value = round(val)
	switch(refined_value)
		if(-INFINITY to -6)
			return "AWFUL"
		if(-5 to -1)
			return "BAD"
		if(0)
			return "NORMAL"
		if(1 to 2)
			return "GOOD"
		if(3 to INFINITY)
			return "GREAT"

	/*-------------------\
	|Process Four Minutes|
	\-------------------*/

/datum/stonk_company/proc/CalculateMinutes(datum/stonk_investor/I)
	fluctuation_counter += rand(5,10)
	if (fluctuation_counter >= fluctuation_rate)
		GenerateNews(I, rand(1,6))
		fluctuation_counter = 0
		if (!bankrupt)
			fluctuate()

	/*------------\
	|Generate News|
	\------------*/

/datum/stonk_company/proc/GenerateNews(datum/stonk_investor/I, effect)
	if(bankrupt && prob(15))
		bankrupt = FALSE
		GenerateNewsText(I, 3, "[name] has been bailed out of bankruptsy.")
		return
	if((!bankrupt && optimism < 0 && prob(abs(optimism))) || current_value < 1)
		Bankrupt()
		GenerateNewsText(I, 3, "[name] has filed for bankruptsy.")
		return

	switch(effect)
		if(1)
			GenerateNewsText(I, rand(-3, -1),"\
				[pick("The owner of [name] has been suspected of commiting a Taboo", "Rats have stolen the staff of [name]", "The owner of [name] has distorted")], <br>\
				investors are losing faith in the companies survival.")
		if(2 to 3)
			GenerateNewsText(I, rand(-2, 3),"\
				[name] has [pick("a new advertising campaign", "a service discount", "made a murder attempt on a customer")], <br>\
				investors are yet to see the effect this has on profits.")
		if(4)
			GenerateNewsText(I, rand(1, 2),"\
				[pick("The owner of [name] did a backflip infront of a cheering crowd", "Rat populations around [name] have decreased significantly")], <br>\
				company stocks are sure to increase now.")
		else
			return

/datum/stonk_company/proc/GenerateNewsText(datum/stonk_investor/investee, opinion_effect, txt = "ERROR")
	if(opinion_effect)
		affectPublicOpinion(opinion_effect)
	if(investee)
		investee.addToNews(name, txt)
	if(length(news) >= 10)
		news.Cut(1,2)
	news += "[txt]<br>"
	news_notif = TRUE

	/*---------------\
	|Functional Procs|
	\---------------*/

/datum/stonk_company/proc/Bankrupt()
	bankrupt = TRUE
	optimism = 0
	average_optimism = 0
	performance = 0
	current_value = 35
	average_shares = 100
	outside_shareholders = 5
	available_shares = 100
	shareholders = list()

	/*----------------\
	|Stolen Stock Code|
	\----------------*/
// Unsure how most of this code works.
/datum/stonk_company/proc/modifyAccount(datum/stonk_investor/stonker, by, force=0)
	if (stonker.budget)
		if (by < 0 && stonker.budget + by < 0 && !force)
			return 0
		stonker.budget += by
		return 1
	return 0

/datum/stonk_company/proc/buyShares(datum/stonk_investor/stonker, howmany)
	if (howmany <= 0)
		return
	howmany = round(howmany)
	var/loss = howmany * current_value
	if (available_shares < howmany)
		return 0
	if (modifyAccount(stonker, -loss))
		supplyDrop(howmany)
		if (!(stonker in shareholders))
			shareholders[stonker] = howmany
		else
			shareholders[stonker] += howmany
		return 1
	return 0

/datum/stonk_company/proc/sellShares(datum/stonk_investor/stonker, howmany)
	if (howmany < 0)
		return
	howmany = round(howmany)
	var/gain = howmany * current_value
	if (shareholders[stonker] < howmany)
		return 0
	if (modifyAccount(stonker, gain))
		supplyGrowth(howmany)
		shareholders[stonker] -= howmany
		if (shareholders[stonker] <= 0)
			shareholders -= stonker
		return 1
	return 0

	/*
	* Used in supplyGrowth()
	*/
/datum/stonk_company/proc/frc(amt)
	var/shares = available_shares + outside_shareholders * average_shares
	var/fr = amt / 100
	if(shares)
		fr = fr / shares * fluctuational_coefficient * fluctuation_rate * max(-(current_trend / 100), 1)
	if ((fr < 0 && speculation < 0) || (fr > 0 && speculation > 0))
		fr *= max(abs(speculation) / 5, 1)
	else
		fr /= max(abs(speculation) / 5, 1)
	return fr

	//Called by events to randomly effect trends.
/datum/stonk_company/proc/affectPublicOpinion(boost)
	if(optimism < 3)
		optimism += rand(0, 500) / 500 * boost
		average_optimism += rand(0, 150) / 5000 * boost
	speculation += rand(-1, 50) / 10 * boost
	performance += rand(0, 150) / 100 * boost

	/*
	* Used in sellShares()
	* This is the only part of the code that alters the current_value
	* Negative value change is up, positive is down.
	*/
/datum/stonk_company/proc/supplyGrowth(amt)
	var/fr = frc(amt)
	available_shares += amt
	if (abs(fr) < 0.0001)
		return
	//Growth cannot exceed 150 units
	var/value_change = clamp(fr * current_value, -150, 150)
	//Refresh value decay if below -10
	//sort of a soft cap. Canonically we send agents to sabotage the company.
	if((value_change < -75 || current_value > 600))
		if(value_decay != 0)
			value_decay -= 0.25
	else
		value_decay = 1
	/*
	* This is sloppy but if the value change
	* is negative do not decay it but also preserve
	* the value decay for when there is positive growth
	* to prevent spikes from sneaking by.
	*/
	var/final_value_decay = value_decay
	if(value_change > 0)
		final_value_decay = 1
	current_value -= value_change * final_value_decay

	//Used in buyShares and Fluctuate
/datum/stonk_company/proc/supplyDrop(amt)
	supplyGrowth(-amt)

	//This changes stock value over time. Lots of MATH.
/datum/stonk_company/proc/fluctuate()
	//Optimism is added to change
	var/change = rand(-100, 100) / 10 + optimism * rand(200) / 10
	//Optimism is then reduced by its difference from average times and random percent.
	optimism -= (optimism - average_optimism) * (rand(10,80) / 1000)
	var/shift_score = change + current_trend
	var/as_score = abs(shift_score)
	var/sh_change_dev = rand(-10, 10) / 10
	//shareholder change is effected by change minus current trend?
	var/sh_change = shift_score / (as_score + 100) + sh_change_dev
	//How much of the stock has been bought by outside shareholders
	var/shareholder_change = round(sh_change)
	outside_shareholders += shareholder_change
	var/share_change = shareholder_change * average_shares
	if (as_score > 20 && prob(as_score / 4))
		var/avg_change_dev = rand(-10, 10) / 10
		var/avg_change = shift_score / (as_score + 100) + avg_change_dev
		average_shares += avg_change
		share_change += outside_shareholders * avg_change

	var/cv = last_value
	supplyDrop(share_change)
	available_shares += share_change // temporary

	if (prob(25))
		average_optimism = max(min(average_optimism + (rand(-3, 3) - current_trend * 0.15) / 100, 1), -1)

	var/aspec = abs(speculation)
	if (prob((aspec - 75) * 2))
		speculation += rand(-4, 4)
	else
		if (prob(50))
			speculation += rand(-4, 4)
		else
			speculation += rand(-400, 0) / 1000 * speculation
			if (prob(1) && prob(5)) // pop that bubble
				speculation += rand(-4000, 0) / 1000 * speculation

	//Failsafe for negative value stocks
	if (current_value < 5)
		current_value = 5

	if (performance != 0)
		performance = rand(900,1050) / 1000 * performance
		if (abs(performance) < 0.2)
			performance = 0

	disp_value_change = (cv < current_value) ? 1 : ((cv > current_value) ? -1 : 0)
	last_value = current_value
	//TOO MANY VALUES THROW THE OLDEST OUT
	if (length(values) >= 50)
		values.Cut(1,2)
	values += current_value

	//If current value less than 25 unify the shares and double the value.
	if (current_value < 25)
		unifyShares()

	last_trend = current_trend
	/*
	* What even is this equation...
	* 2.50 random plus optimism
	* times 0 to 200 divided by 10
	* plus a max of 50 minus the absolute value of speculation
	* divided by 50 times a value between 0 to 200
	* then divide that by 1000 times
	* inverted current_trend + speclation minus 50
	* times a value from 0 to 200 divided by 1000
	* times speculation divided by 400. What even.
	*/
	current_trend += rand(-200, 200) / 100 + optimism * rand(200) / 10 + max(50 - abs(speculation), 0) / 50 * rand(0, 200) / 1000 * (-current_trend) + max(speculation - 50, 0) * rand(0, 200) / 1000 * speculation / 400
	//If the stock gains more than 20% of its current value in one move we cripple the company.
	if(current_value > last_value * 2)
		current_value = 100
		GenerateNewsText(txt = "The drastic increase in stock value has alerted district administration.")
	return "[change]|[shift_score]|[as_score]|[sh_change_dev]|[sh_change]|[shareholder_change]"

	//Used in fluctuate()
/datum/stonk_company/proc/unifyShares()
	for (var/I in shareholders)
		var/shr = shareholders[I]
		if (shr % 2)
			sellShares(I, 1)
		shr -= 1
		shareholders[I] = round(shareholders[I] / 2)
		if (!shareholders[I])
			shareholders -= I
	//Do not divide and double shares that are a fraction of a share.
	if(round(available_shares) >= 2)
		average_shares = round(average_shares / 2)
		available_shares = round(available_shares / 2)
		current_value *= 2

	//Visual UI for a bar graph based on the values of a list.
/datum/stonk_company/proc/plotBarGraph(list/points, base_text, width=400, height=400)
	var/output = "<table style='border:1px solid black; border-collapse: collapse; width: [width]px; height: [height]px'>"
	if (length(points) && height > 20 && width > 20)
		var/min = points[1]
		var/max = points[1]
		for (var/v in points)
			if (v < min)
				min = v
			if (v > max)
				max = v
		var/cells = (height - 20) / 20
		if (cells > round(cells))
			cells = round(cells) + 1
		var/diff = max - min
		var/ost = diff / cells
		if (min > 0)
			min = max(min - ost, 0)
		diff = max - min
		ost = diff / cells
		var/cval = max
		var/cwid = width / (length(points) + 1)
		for (var/y = cells, y > 0, y--)
			if (y == cells)
				output += "<tr>"
			else
				output += "<tr style='border:none; border-top:1px solid #00ff00; height: 20px'>"
			for (var/x = 0, x <= length(points), x++)
				if (x == 0)
					output += "<td style='border:none; height: 20px; width: [cwid]px; font-size:10px; color:#00ff00; background:black; text-align:right; vertical-align:bottom'>[round(cval - ost)]</td>"
				else
					var/v = points[x]
					if (v >= cval)
						output += "<td style='border:none; height: 20px; width: [cwid]px; background:#0000ff'>&nbsp;</td>"
					else
						output += "<td style='border:none; height: 20px; width: [cwid]px; background:black'>&nbsp;</td>"
			output += "</tr>"
			cval -= ost
		output += "<tr><td style='font-size:10px; height: 20px; width: 100%; background:black; color:green; text-align:center' colspan='[length(points) + 1]'>[base_text]</td></tr>"
	else
		output += "<tr><td style='width:[width]px; height:[height]px; background: black'></td></tr>"
		output += "<tr><td style='font-size:10px; background:black; color:green; text-align:center'>[base_text]</td></tr>"

	return "[output]</table>"
