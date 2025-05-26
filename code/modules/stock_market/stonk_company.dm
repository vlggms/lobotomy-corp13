/datum/stonk_company
	var/name
	var/product
	var/value

	var/performance = 0						// The current performance of the company. Tends itself to 0 when no events happen.

	// These variables determine standard fluctuational patterns for this stock.
	var/fluctuational_coefficient = 1		// How much the price fluctuates on an average daily basis
	var/average_optimism = 0				// The history of shareholder optimism of this stock
	var/current_trend = 0
	var/last_trend = 0
	var/speculation = 0
	var/bankrupt = 0

	var/disp_value_change = 0
	var/optimism = 0
	var/last_unification = 0
	var/average_shares = 100
	var/outside_shareholders = 10		// The amount of offstation people holding shares in this company. The higher it is, the more fluctuation it causes.
	var/available_shares = 100
	var/list/history = list()

/datum/stonk_company/New(company_name, company_product, company_value)
	name = company_name
	product = company_product
	value = company_value
	history = list(company_value)

/datum/stonk_company/proc/companyInfo(obj/machinery/interfacer, datum/stonk_investor/investor, mob/living/carbon/human/viewer)
	. = "|[name]<br>\
		|Product:[product]<br>\
		|Value:[value]<br>\
		|Shares:[investor.ReturnStonkValue(src)]<br>\
		|"
	GENERAL_BUTTON(REF(interfacer),"buyshares",REF(src),"Buy")
	. += " "
	GENERAL_BUTTON(REF(interfacer),"sellshares",REF(src),"Sell")
	. += "<br>"

	. += plotBarGraph(history, "[name] share value per share")

/datum/stonk_company/proc/AddValueHistory(amt)
	history += amt
	if(length(history) > 10)
		history.Cut(1)

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
