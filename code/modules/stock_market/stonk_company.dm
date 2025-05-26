/*
* This is a butchered ramshackle version
* of TG stocks code.
*/

/datum/stonk_company
	var/name
	var/desc = "An upstart company formed from a group of \"reformed\" rats from the backstreets."
	var/product = "Scrap & Guts"
	var/current_value = 10
	var/last_value = 10

	// The current performance of the company. Tends itself to 0 when no events happen.
	var/performance = 0

	// These variables determine standard fluctuational patterns for this stock.
	// How much the price fluctuates on an average daily basis
	var/fluctuational_coefficient = 1
	// The history of shareholder optimism of this stock
	var/average_optimism = 0
	// Used in Fluctuate()
	var/current_trend = 0
	var/last_trend = 0
	var/speculation = 0
	var/bankrupt = 0

	var/disp_value_change = 0
	var/optimism = 0
	var/last_unification = 0
	var/average_shares = 100
	var/outside_shareholders = 10
	var/available_shares = 100
	var/fluctuation_rate = 15
	var/fluctuation_counter = 0
	var/list/values = list()
	var/list/shareholders = list()

/datum/stonk_company/New(company_name, company_product, company_value, company_desc)
	name = company_name
	if(company_product)
		product = company_product
	if(company_value)
		current_value = company_value
		values = list(company_value)
	if(company_desc)
		desc = company_desc

/datum/stonk_company/proc/companyInfo(obj/machinery/interfacer, datum/stonk_investor/investor, mob/living/carbon/human/viewer)
	. = "ID:[name]<br>\
		Desc:[desc]<br>\
		Product:[product]<br>\
		Value:[current_value]<br>\
		Shares:[investor.ReturnStonkValue(src)]<br>"
	GENERAL_BUTTON(REF(interfacer),"buyshares",REF(src),"Buy")
	. += " "
	GENERAL_BUTTON(REF(interfacer),"sellshares",REF(src),"Sell")
	. += "<br>"

	. += plotBarGraph(values, "[name] share value per share")

	/*-------------------\
	|Process Four Minutes|
	\-------------------*/

/datum/stonk_company/proc/CalculateMinutes()
	if (bankrupt)
		return
	fluctuation_counter += rand(5,10)
	if (fluctuation_counter >= fluctuation_rate)
		fluctuation_counter = 0
		fluctuate()

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

/datum/stonk_company/proc/frc(amt)
	var/shares = available_shares + outside_shareholders * average_shares
	var/fr = amt / 100 / shares * fluctuational_coefficient * fluctuation_rate * max(-(current_trend / 100), 1)
	if ((fr < 0 && speculation < 0) || (fr > 0 && speculation > 0))
		fr *= max(abs(speculation) / 5, 1)
	else
		fr /= max(abs(speculation) / 5, 1)
	return fr

	//Called by events to randomly effect trends.
/datum/stonk_company/proc/affectPublicOpinion(boost)
	optimism += rand(0, 500) / 500 * boost
	average_optimism += rand(0, 150) / 5000 * boost
	speculation += rand(-1, 50) / 10 * boost
	performance += rand(0, 150) / 100 * boost

	//Used in sellShares()
/datum/stonk_company/proc/supplyGrowth(amt)
	var/fr = frc(amt)
	available_shares += amt
	if (abs(fr) < 0.0001)
		return
	current_value -= fr * current_value

	//Used in buyShares
/datum/stonk_company/proc/supplyDrop(amt)
	supplyGrowth(-amt)

	//This changes stock value over time. Lots of MATH.
/datum/stonk_company/proc/fluctuate()
	var/change = rand(-100, 100) / 10 + optimism * rand(200) / 10
	optimism -= (optimism - average_optimism) * (rand(10,80) / 1000)
	var/shift_score = change + current_trend
	var/as_score = abs(shift_score)
	var/sh_change_dev = rand(-10, 10) / 10
	var/sh_change = shift_score / (as_score + 100) + sh_change_dev
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

	if (current_value < 5)
		current_value = 5

	if (performance != 0)
		performance = rand(900,1050) / 1000 * performance
		if (abs(performance) < 0.2)
			performance = 0

	disp_value_change = (cv < current_value) ? 1 : ((cv > current_value) ? -1 : 0)
	last_value = current_value
	if (values.len >= 50)
		values.Cut(1,2)
	values += current_value

	if (current_value < 10)
		unifyShares()

	last_trend = current_trend
	current_trend += rand(-200, 200) / 100 + optimism * rand(200) / 10 + max(50 - abs(speculation), 0) / 50 * rand(0, 200) / 1000 * (-current_trend) + max(speculation - 50, 0) * rand(0, 200) / 1000 * speculation / 400

	//Used in fluctuate()
/datum/stonk_company/proc/unifyShares()
	for (var/I in shareholders)
		var/shr = shareholders[I]
		if (shr % 2)
			sellShares(I, 1)
		shr -= 1
		shareholders[I] /= 2
		if (!shareholders[I])
			shareholders -= I
	average_shares /= 2
	available_shares /= 2
	current_value *= 2
	last_unification = world.time

	//Visual UI for a bar graph based on the values of a list.
/datum/stonk_company/proc/plotBarGraph(list/points, base_text, width=400, height=400)
	var/output = "<table style='border:1px solid black; border-collapse: collapse; width: [width]px; height: [height]px'>"
	if (points.len && height > 20 && width > 20)
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
		var/cwid = width / (points.len + 1)
		for (var/y = cells, y > 0, y--)
			if (y == cells)
				output += "<tr>"
			else
				output += "<tr style='border:none; border-top:1px solid #00ff00; height: 20px'>"
			for (var/x = 0, x <= points.len, x++)
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
		output += "<tr><td style='font-size:10px; height: 20px; width: 100%; background:black; color:green; text-align:center' colspan='[points.len + 1]'>[base_text]</td></tr>"
	else
		output += "<tr><td style='width:[width]px; height:[height]px; background: black'></td></tr>"
		output += "<tr><td style='font-size:10px; background:black; color:green; text-align:center'>[base_text]</td></tr>"

	return "[output]</table>"
