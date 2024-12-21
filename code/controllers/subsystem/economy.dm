SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME
	var/roundstart_paychecks = 5
	var/budget_pool = 35000
	var/list/department_accounts = list(ACCOUNT_CIV = ACCOUNT_CIV_NAME,
										ACCOUNT_ENG = ACCOUNT_ENG_NAME,
										ACCOUNT_SCI = ACCOUNT_SCI_NAME,
										ACCOUNT_MED = ACCOUNT_MED_NAME,
										ACCOUNT_SRV = ACCOUNT_SRV_NAME,
										ACCOUNT_CAR = ACCOUNT_CAR_NAME,
										ACCOUNT_SEC = ACCOUNT_SEC_NAME)
	var/list/generated_accounts = list()
	var/full_ancap = FALSE // Enables extra money charges for things that normally would be free, such as sleepers/cryo/cloning.
							//Take care when enabling, as players will NOT respond well if the economy is set up for low cash flows.
	/// Departmental cash provided to science when a node is researched in specific configs.
	var/techweb_bounty = 250
	/**
	  * List of normal (no department ones) accounts' identifiers with associated datum accounts, for big O performance.
	  * A list of sole account datums can be obtained with flatten_list(), another variable would be redundant rn.
	  */
	var/list/bank_accounts_by_id = list()
	var/list/dep_cards = list()
	/// A var that collects the total amount of credits owned in player accounts on station, reset and recounted on fire()
	var/station_total = 0
	/// A var that tracks how much money is expected to be on station at a given time. If less than station_total prices go up in vendors.
	var/station_target = 1
	/// A passively increasing buffer to help alliviate inflation later into the shift, but to a lesser degree.
	var/station_target_buffer = 0
	/// A var that displays the result of inflation_value for easier debugging and tracking.
	var/inflation_value = 1
	/// How many civilain bounties have been completed so far this shift? Affects civilian budget payout values.
	var/civ_bounty_tracker = 0
	/// Contains the message to send to newscasters about price inflation and earnings, updated on price_update()
	var/earning_report
	///The modifier multiplied to the value of bounties paid out.
	var/bounty_modifier = 1
	///The modifier multiplied to the value of cargo pack prices.
	var/pack_price_modifier = 1
	var/market_crashing = FALSE
	//STOCK MARKET VARS
	var/list/stocks = list()
	var/list/balances = list()
	var/list/last_read = list()
	var/list/stock_brokers = list()
	var/list/logs
	var/list/frozen_accounts = list()


/datum/controller/subsystem/economy/Initialize(timeofday)
	var/budget_to_hand_out = round(budget_pool / department_accounts.len)
	for(var/A in department_accounts)
		new /datum/bank_account/department(A, budget_to_hand_out)
	generateBrokers()
	generateStocks()
	return ..()

/datum/controller/subsystem/economy/Recover()
	generated_accounts = SSeconomy.generated_accounts
	bank_accounts_by_id = SSeconomy.bank_accounts_by_id
	dep_cards = SSeconomy.dep_cards

/datum/controller/subsystem/economy/fire(resumed = 0)
	var/temporary_total = 0
	departmental_payouts()
	station_total = 0
	station_target_buffer += STATION_TARGET_BUFFER
	for(var/account in bank_accounts_by_id)
		var/datum/bank_account/bank_account = bank_accounts_by_id[account]
		if(bank_account?.account_job)
			temporary_total += (bank_account.account_job.paycheck * STARTING_PAYCHECKS)
		if(!istype(bank_account, /datum/bank_account/department))
			station_total += bank_account.account_balance
	station_target = max(round(temporary_total / max(bank_accounts_by_id.len * 2, 1)) + station_target_buffer, 1)
//	if(!market_crashing)
//		price_update()		Fucks up Workshop, I'll figure out how to make it override soon:tm: - Kirie
	for(var/stock in stocks)
		var/datum/stock/S = stock
		S.process()

/**
 * Handy proc for obtaining a department's bank account, given the department ID, AKA the define assigned for what department they're under.
 */
/datum/controller/subsystem/economy/proc/get_dep_account(dep_id)
	for(var/datum/bank_account/department/D in generated_accounts)
		if(D.department_id == dep_id)
			return D

/**
 * Departmental income payments are kept static and linear for every department, and paid out once every 5 minutes, as determined by MAX_GRANT_DPT.
 * Iterates over every department account for the same payment.
 */
/datum/controller/subsystem/economy/proc/departmental_payouts()
	for(var/iteration in department_accounts)
		var/datum/bank_account/dept_account = get_dep_account(iteration)
		if(!dept_account)
			continue
		dept_account.adjust_money(MAX_GRANT_DPT)

/**
 * Updates the prices of all station vendors with the inflation_value, increasing/decreasing costs across the station, and alerts the crew.
 *
 * Iterates over the machines list for vending machines, resets their regular and premium product prices (Not contraband), and sends a message to the newscaster network.
 **/
/datum/controller/subsystem/economy/proc/price_update()
	for(var/obj/machinery/vending/V in GLOB.machines)
		if(istype(V, /obj/machinery/vending/custom))
			continue
		if(!is_station_level(V.z))
			continue
		V.reset_prices(V.product_records, V.coin_records)
	earning_report = "District 12 Economic Report<br /> District vendor prices are currently at [SSeconomy.inflation_value()*100]%.<br /> The facility spending power is currently <b>[station_total] Ahn</b>, and the staff's targeted allowance is at <b>[station_target] Ahn</b>.<br /> That's all from the <i>District 12 Economist Division</i>."
	GLOB.news_network.SubmitArticle(earning_report, "Facility Earnings Report", "Facility Announcements", null, update_alert = FALSE)

/**
 * Proc that returns a value meant to shift inflation values in vendors, based on how much money exists on the station.
 *
 * If crew are somehow aquiring far too much money, this value will dynamically cause vendables across the station to skyrocket in price until some money is spent.
 * Additionally, civilain bounties will cost less, and cargo goodies will increase in price as well.
 * The goal here is that if you want to spend money, you'll have to get it, and the most efficient method is typically from other players.
 **/
/datum/controller/subsystem/economy/proc/inflation_value()
	if(!bank_accounts_by_id.len)
		return 1
	inflation_value = max(round(((station_total / bank_accounts_by_id.len) / station_target), 0.1), 1.0)
	return inflation_value

//STOCK MARKET PROCS
/datum/controller/subsystem/economy/proc/list_frozen()
	for(var/A in frozen_accounts)
		to_chat(usr, "[A]: [length(frozen_accounts[A])] borrows")

/datum/controller/subsystem/economy/proc/balanceLog(whose, net)
	if (!(whose in balances))
		balances[whose] = net
	else
		balances[whose] += net

/datum/controller/subsystem/economy/proc/generateBrokers()
	stock_brokers = list()
	var/list/fnames = list("Goldman", "Edward", "James", "Luis", "Alexander", "Walter", "Eugene", "Mary", "Morgan", "Jane", "Elizabeth", "Xavier", "Hayden", "Samuel", "Lee")
	var/list/names = list("Johnson", "Rothschild", "Sachs", "Stanley", "Hepburn", "Brown", "McColl", "Fischer", "Edwards", "Becker", "Witter", "Walker", "Lambert", "Smith", "Montgomery", "Lynch", "Roosevelt", "Lehman")
	var/list/locations = LC_DISTRICT_LIST
	var/list/first = list("The", "First", "Premier", "Finest", "Prime")
	var/list/company = list("Investments", "Securities", "Corporation", "Bank", "Brokerage", "& Co.", "Brothers", "& Sons", "Investement Firm", "Union", "Partners", "Capital", "Trade", "Holdings")
	for(var/i in 1 to 5)
		var/pname = ""
		switch (rand(1,5))
			if (1)
				pname = "[prob(10) ? pick(first) + " " : null][pick(names)] [pick(company)]"
			if (2)
				pname = "[pick(names)] & [pick(names)][prob(25) ? " " + pick(company) : null]"
			if (3)
				pname = "[prob(45) ? pick(first) + " " : null][pick(locations)] [pick(company)]"
			if (4)
				pname = "[prob(10) ? "The " : null][pick(names)] [pick(locations)] [pick(company)]"
			if (5)
				pname = "[prob(10) ? "The " : null][pick(fnames)] [pick(names)][prob(10) ? " " + pick(company) : null]"
		if (pname in stock_brokers)
			i--
			continue
		stock_brokers += pname

/datum/controller/subsystem/economy/proc/generateDesignation(name)
	if (length(name) <= 4)
		return uppertext(name)
	var/list/w = splittext(name, " ")
	if (w.len >= 2)
		var/d = ""
		for(var/i in 1 to min(5, w.len))
			d += uppertext(ascii2text(text2ascii(w[i], 1)))
		return d
	else
		var/d = uppertext(ascii2text(text2ascii(name, 1)))
		for(var/i in 2 to length(name))
			if (prob(100 / i))
				d += uppertext(ascii2text(text2ascii(name, i)))
		return d

/datum/controller/subsystem/economy/proc/generateStocks(amt = 15)
	var/list/fruits = list("Banana", "Mimana", "Watermelon", "Ambrosia", "Pomegranate", "Reishi", "Papaya", "Mango", "Tomato", "Conkerberry", "Wood", "Lychee", "Mandarin", "Harebell", "Pumpkin", "Rhubarb", "Tamarillo", "Yantok", "Ziziphus", "Oranges", "Gatfruit", "Daisy", "Kudzu")
	var/list/tech_prefix = list("Nano", "Cyber", "Funk", "Astro", "Fusion", "Tera", "Exo", "Star", "Virtual", "Plasma", "Robust", "Bit", "Future", "Hugbox", "Carbon", "Nerf", "Buff", "Nova", "Space", "Meta", "Cyber")
	var/list/tech_short = list("soft", "tech", "prog", "tec", "tek", "ware", "", "gadgets", "nics", "tric", "trasen", "tronic", "coin")
	var/list/random_nouns = list("Johnson", "Cluwne", "General", "Specific", "Master", "King", "Queen", "Table", "Rupture", "Dynamic", "Massive", "Mega", "Giga", "Certain", "Singulo", "State", "National", "International", "Interplanetary", "Sector", "Planet", "Burn", "Robust", "Exotic", "Solar", "Lunar", "Chelp", "Corgi", "Lag", "Lizard")
	var/list/company = list("Company", "Factory", "Incorporated", "Industries", "Group", "Consolidated", "GmbH", "LLC", "Ltd", "Inc.", "Association", "Limited", "Software", "Technology", "Programming", "IT Group", "Electronics", "Nanotechnology", "Farms", "Stores", "Mobile", "Motors", "Electric", "Designs", "Energy", "Pharmaceuticals", "Communications", "Wholesale", "Holding", "Health", "Machines", "Astrotech", "Gadgets", "Kinetics")
	for (var/i = 1, i <= amt, i++)
		var/datum/stock/S = new
		var/sname = ""
		switch (rand(1,6))
			if(1)
				if(sname == "" || sname == "FAG") // honestly it's a 0.6% chance per round this happens - or once in 166 rounds - so i'm accounting for it before someone yells at me
					sname = "[CONSONANTS][VOWELS][CONSONANTS]"
			if (2)
				sname = "[pick(tech_prefix)][pick(tech_short)][prob(20) ? " " + pick(company) : null]"
			if (3 to 4)
				var/fruit = pick(fruits)
				fruits -= fruit
				sname = "[prob(10) ? "The " : null][fruit][prob(40) ? " " + pick(company): null]"
			if (5 to 6)
				var/pname = pick(random_nouns)
				random_nouns -= pname
				switch (rand(1,3))
					if (1)
						sname = "[pname] & [pname]"
					if (2)
						sname = "[pname] [pick(company)]"
					if (3)
						sname = "[pname]"
		S.name = sname
		S.short_name = generateDesignation(S.name)
		S.current_value = rand(10, 125)
		var/dv = rand(10, 40) / 10
		S.fluctuational_coefficient = prob(50) ? (1 / dv) : dv
		S.average_optimism = rand(-10, 10) / 100
		S.optimism = S.average_optimism + (rand(-40, 40) / 100)
		S.current_trend = rand(-200, 200) / 10
		S.last_trend = S.current_trend
		S.disp_value_change = rand(-1, 1)
		S.speculation = rand(-20, 20)
		S.average_shares = round(rand(500, 10000) / 10)
		S.outside_shareholders = rand(1000, 30000)
		S.available_shares = rand(200000, 800000)
		S.fluctuation_rate = rand(6, 20)
		S.generateIndustry()
		S.generateEvents()
		stocks += S
		last_read[S] = list()

/datum/controller/subsystem/economy/proc/add_log(log_type, user, company_name, stocks, shareprice, money)
	var/datum/stock_log/L = new log_type
	L.user_name = user
	L.company_name = company_name
	L.stocks = stocks
	L.shareprice = shareprice
	L.money = money
	L.time = time2text(world.timeofday, "hh:mm")
	logs += L
