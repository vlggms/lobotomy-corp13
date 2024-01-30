/**
 * TEXT BASED ADVENTURES
 * Adventures that are mostly predefined paths.
 * This was difficult to finalize since i havent made a text based adventure before.
 */

/datum/adventure_layout
	///Current players health
	var/virtual_integrity = 100
	///Coins for flipping.
	var/virtual_coins = 0
	///Event progress so that your not stuck with nothing but null events.
	var/program_progress = 0
	///Damage in battle senarios. Based on dice values.
	var/virtual_damage = "1d6"
	///Variable for when they last logged in. Used in StatCatchup()
	var/last_logged_time = 0
	///What we are currently displaying.
	var/display_mode = NORMAL_TEXT_DISPLAY
	///What is currently happening while traveling.
	var/travel_mode = ADVENTURE_MODE_TRAVEL
	///If debug menu comes up.
	var/debug_menu = FALSE
	///Temp text for occasional informative text on the UI.
	var/temp_text = ""
	///Currently Selected Event
	var/datum/adventure_event/event_data
	///Used in event chances.
	var/list/virtual_stats = list(
		WRATH_STAT = 10,
		LUST_STAT = 10,
		SLOTH_STAT = 10,
		GLUTT_STAT = 10,
		GLOOM_STAT = 10,
		PRIDE_STAT = 10,
		ENVY_STAT = 10,
	)
	///Used in the adventure mechanics. Generated paths will be put here until they are walked.
	var/list/paths_to_tread = list()
	///Events we can choose from.
	var/list/event_options = list()
	///list of all events.
	var/static/list/events = list()

	//Battle Mode Variables
	///Enemy's current health
	var/enemy_integrity = 0
	///Enemy flavor text. Currently this is the way we register that a enemy currently exists and it is cleared after battle.
	var/enemy_desc
	///Enemy damage dice
	var/enemy_damage = "1d6"
	///Coins rewarded after defeating the enemy
	var/enemy_coin = 0
	///One day maybe we will have proper enemies but for now this will suffice. -IP
	var/list/enemy_descriptions = list(
		"<b>Recorded Clerk</b>:A familiar looking humanoid. They wear ragged clothes and a L corp armband. You swear you used to know their name.<br>",
		"<b>Recorded Rat</b>:A low life from the backstreets. Their face is disfigured beyond recognition, all you can make out are their eyes.<br>",
		"<b>Digital Reflection</b>:Its you! Well it looks LIKE you.<br>",
	)

/datum/adventure_layout/New(set_debug_menu = FALSE)
	. = ..()
	if(!events.len)
	//Later on this may become very heavy on processing when a new adventure profile is made.
		for(var/_event in subtypesof(/datum/adventure_event))
			events += _event
	debug_menu = set_debug_menu

	/*---------------\
	|Return Visual UI|
	\---------------*/

/**
 * This proc is called by the adventure datum in order to build the UI.
 * Its like a hub where all other general things are called.
 */
/datum/adventure_layout/proc/Adventure(obj/machinery/caller, mob/living/carbon/human/H)
	if(!H.client)
		return

	//Dispaly Event Data
	if(event_data)
		. += event_data.Event(caller, H)
		if(!event_data)
			//Emergency Exit because the event can lead to a empty screen due to the event deleting itself.
			GENERAL_BUTTON(REF(caller),"set_display",NORMAL_TEXT_DISPLAY,"RETURN TO MAIN PROGRAM")
	else
		//STATS! ARE HERE
		. = "<tt>\
			|USER:[uppertext(H.name)]|HP:[virtual_integrity]|COINS:[virtual_coins]|<br>\
			|DAMAGE_DICE:[virtual_damage]|EVENT_CHANCE:[program_progress]|<br>\
			|WRATH:[virtual_stats[WRATH_STAT]]\
			|LUST:[virtual_stats[LUST_STAT]]\
			|SLOTH:[virtual_stats[SLOTH_STAT]]\
			|GLUTT:[virtual_stats[GLUTT_STAT]]\
			|GLOOM:[virtual_stats[GLOOM_STAT]]\
			|PRIDE:[virtual_stats[PRIDE_STAT]]\
			|ENVY:[virtual_stats[ENVY_STAT]]|<br>\
			</tt>"
		//From highest menu define to lowest. -IP
		for(var/mode_option = NORMAL_TEXT_DISPLAY to ADVENTURE_TEXT_DISPLAY)
			. += "<A href='byond://?src=[REF(caller)];set_display=[mode_option]'>[mode_option == display_mode ? "<b><u>[nameMenu(mode_option)]</u></b>" : "[nameMenu(mode_option)]"]</A>"
		if(debug_menu)
			. += "<A href='byond://?src=[REF(caller)];set_display=[DEBUG_TEXT_DISPLAY]'>[display_mode == DEBUG_TEXT_DISPLAY ? "<b><u>[nameMenu(DEBUG_TEXT_DISPLAY)]</u></b>" : "[nameMenu(DEBUG_TEXT_DISPLAY)]"]</A>"

		. += "<br>\
			[DisplayUI(caller, H)]<br>\
			<tt>~~~~~~~~~~</tt><br><b>[pick(
				"THE RUINS ARE CLOSING IN",
				"THEY ALL MARCH OUTWARDS<br>LEAVING THE CITY BEHIND",
				"IS THAT YOU",
				"I REMEMBER ALL THEIR NAMES",
				"WHAT CANT THE BEHOLDERS SEE",
				"YOUR CITY IS STARVING",
				"YOUR LEADERS PLAN TO SACRIFICE YOU WHILE YOU WORK",
			)]</b>"

	StatCatchup()

//The seperation of this from the Adventure proc was mostly due to how messy the Adventure proc currently is.
/datum/adventure_layout/proc/DisplayUI(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	switch(display_mode)
		if(DEBUG_TEXT_DISPLAY)
			. += "<tt>~~~~~~~~~~</tt><br>DEBUG EVENT MENU<br><tt>~~~~~~~~~~</tt><br>"
			for(var/_option in events)
				var/datum/adventure_event/A = _option
				GENERAL_BUTTON(REF(interfacer),"adventure",A,initial(A.name))
				. += "[initial(A.desc)]<br>"

		if(NORMAL_TEXT_DISPLAY)
			. += "<tt>~~~~~~~~~~</tt><br>WELCOME [uppertext(viewer.name)]<br> \
				YOUR LAST REGISTERED ENTRY WAS [round((world.time - last_logged_time)/(1 SECONDS))] SECONDS AGO.<br>\
				[temp_text]<br>\
				NOTE_ENTRY:<br>\
				The purpose of this program is to dicipher recorded information about<br>\
				abnormalities. Any information unrelated to abnormalities or the<br>\
				enkanaphlin process is to be considered a flaw in the program.<br><br>\
				The process of deciphering abnormality data used to be a arduous task that<br>\
				exposed many to unforeseen mind warping effects. In order to alliviate the<br>\
				mental strain the process has been redesigned into a 'game'.<br>\
				Abnormal effects should be relagated to the occasional glitch<br>\
				<br><b>How to Play</b><br>\
				At the top of the screen you will see your stats. When your HP or program<br>\
				stability reaches 0 you will be unable to continue playing until it<br>\
				increases above 0. You recover 1 health every 10 seconds based on the<br>\
				time of your last action on the program.Coins seem to be only used in<br>\
				some obscure situations such as events. Coins are gained from battle.<br>\
				A dice is used to determine damage when you encounter a battle event.<br>\
				The value of this die can be used to reduce damage with block or inflict<br>\
				damage with fight. I did not say this was a great game. Event chance is<br>\
				the programs chance to present a event to you. Event chance increases the<br>\
				more you interact with the program. When traveling down paths in the<br>\
				adventure tab you will gain 3% additive chance to find a event. Winning<br>\
				battles will grant you a 10% increased chance. These events are generally<br>\
				related to abnormalities that you have within your facility. At the end of<br>\
				your shift a report will be expected on the events you encounter.<br>"

		if(ADVENTURE_TEXT_DISPLAY)
			. += "[TravelUI(interfacer)]"

/datum/adventure_layout/proc/TravelUI(obj/machinery/call_machine)
	switch(travel_mode)
		if(ADVENTURE_MODE_BATTLE to ADVENTURE_MODE_EVENT_BATTLE)
			if(!enemy_desc)
				GenerateEnemy()
			. += BattleModeDisplay(call_machine)
		if(ADVENTURE_MODE_TRAVEL)
			if(!paths_to_tread.len)
				GeneratePaths(3)
			. += TravelModeDisplay(call_machine)

/datum/adventure_layout/proc/BattleModeDisplay(obj/machinery/call_machine)
	//<tt> placed for monospaced formatting.
	. += "<tt>\
		ENEMY DESCRIPTION: [enemy_desc]\
		</tt><br>\
		[temp_text]\
		<br>"

	GENERAL_BUTTON(REF(call_machine),"travel",1,"BLOCK")
	. += "|"
	GENERAL_BUTTON(REF(call_machine),"travel",2,"FIGHT")
	. += "|"
	GENERAL_BUTTON(REF(call_machine),"travel",3,"LOOK")
	. += "|"
	if(travel_mode != ADVENTURE_MODE_EVENT_BATTLE)
		GENERAL_BUTTON(REF(call_machine),"travel",4,"RUN")
		. += "|"

/datum/adventure_layout/proc/TravelModeDisplay(obj/machinery/call_machine)
	if(virtual_integrity <= 0)
		return "ERROR:INTEGRITY FAILURE"
	//<tt> placed for monospaced formatting.
	. += "<tt>You have 3 paths to travel.</tt><br>\
		[temp_text]<br>"

	var/path_num = 1
	for(var/i in paths_to_tread)
		GENERAL_BUTTON(REF(call_machine),"travel",path_num,"PATH:")
		. += "[DescribePath(path_num)]<br>"
		path_num++

	/*---------------\
	|Generator Proc's|
	\---------------*/

/**
 * Enemy Generation for Battle Mode
 * Currently not very great, terrible even, but i just need to get this up and running.
 */
/datum/adventure_layout/proc/GenerateEnemy()
	enemy_desc = pick(enemy_descriptions)
	enemy_integrity = rand(10, 50)
	var/temp_dice = rand(1,2)
	var/temp_sides
	//Esoteric and strange balancing choices by me. -IP
	switch(temp_dice)
		if(1)
			temp_sides = rand(3,10)
		if(2)
			temp_sides = rand(1,7)
	enemy_damage = "[temp_dice]d[temp_sides]"
	/**
	 * Ill just leave it at this until i can get it working.
	 * 10/5 = 2, 14/5 = 2
	 * -IP
	 */
	enemy_coin = round((temp_sides * temp_dice)/5)

/datum/adventure_layout/proc/GeneratePaths(max_paths)
	for(var/i=1 to max_paths)
		//Unsure if i should put in a check in order to prevent 3% chance events.-IP
		if(prob(program_progress) && program_progress > 25)
			paths_to_tread += GrabEvent()
			continue
		if(prob(program_progress + 10))
			paths_to_tread += ADVENTURE_MODE_BATTLE
			continue
		else
			paths_to_tread += ADVENTURE_MODE_TRAVEL
	return paths_to_tread

//Creates and sets a event. 2nd part to GrabEvent().
/datum/adventure_layout/proc/GenerateEvent(A)
	event_data = new A(src)

	/*---------------\
	|Button Reactions|
	\---------------*/

//Reaction from machine of adventure choices. Chosen path reactions.
/datum/adventure_layout/proc/AdventureModeReact(num)
	temp_text = ""
	switch(travel_mode)
		if(ADVENTURE_MODE_TRAVEL)
			TravelModeReact(num)
			//Every step is 3 more progress to the event.
			AdjustProgress(3)

		/*I put || in here and the code got upset so i have to do TO instead
			Eugh maybe we will fix it later on if adventure mode event battle stops being 3. -IP*/
		if(ADVENTURE_MODE_BATTLE to ADVENTURE_MODE_EVENT_BATTLE)
			BattleModeReact(num)

//Reactions for adventure based on mode.
/datum/adventure_layout/proc/TravelModeReact(path_tread_num)
	travel_mode = paths_to_tread[path_tread_num]
	if(!isnum(travel_mode))
		//This looks weird but i want grab event to be its own thing.
		GenerateEvent(travel_mode)
		//Reset event chance.
		program_progress = 0
		travel_mode = ADVENTURE_MODE_TRAVEL
	paths_to_tread.Cut()
	return travel_mode

/datum/adventure_layout/proc/BattleModeReact(battle_num)
	if(enemy_integrity > 0 && virtual_integrity > 0)
		switch(battle_num)
			if(1)
				DoBattle(roll(virtual_damage), TRUE)
			if(2)
				DoBattle(roll(virtual_damage))
			if(3)
				if(prob(50))
					temp_text += "THE ENEMY TAKES THE CHANCE TO STRIKE<br>"
					DoBattle(0)
				temp_text += "<br>HP:[enemy_integrity]<br>DAMAGE:[enemy_damage]<br>YOUR WELCOME<br>"
			if(4)
				if(prob(50))
					temp_text += "<br>YOU RUN AWAY FROM YOUR OPPONENT<br>5 DAMAGE HEALED<br>EVENT PROGRESS -5<br>"
					AdjustHP(5)
					AdjustProgress(-5)
				else
					DoBattle(0)
					temp_text += "<br>YOU FAIL TO ESCAPE THE ENEMY<br>"
		return TRUE
	//Everything past this is what happens if you or the enemy reach 0 health.
	paths_to_tread.Cut()
	enemy_desc = null
	travel_mode = ADVENTURE_MODE_TRAVEL
	if(enemy_integrity <= 0)
		BattleWinReward()
	else
		temp_text += "PROGRAM UNSTABLE<br>1 COIN LOST<br>EVENT PROGRESS -2"
		virtual_coins--
		AdjustProgress(-2)

	/*-----------\
	|Battle Procs|
	\-----------*/
//What happens every time you press a button in battle.
/datum/adventure_layout/proc/DoBattle(hit_num, BLOCKING = FALSE)
	var/enemy_hit = roll(enemy_damage)
	if(BLOCKING)
		enemy_hit -= hit_num
		if(enemy_hit < 0)
			enemy_hit = 0
		temp_text += "YOUR ENEMY DEALS [enemy_hit]. YOU PREVENTED [hit_num] DAMAGE."
	else
		temp_text += "YOU SUFFER [enemy_hit] WHILE THE ENEMY SUFFERS [hit_num]."
		enemy_integrity -= hit_num
	AdjustHP(-enemy_hit)

//What happens when you win.
/datum/adventure_layout/proc/BattleWinReward()
	var/increased_stat = rand(1,7)
	temp_text += "OBSTACLE CLEARED<br>[enemy_coin] COINS GAINED<br>EVENT PROGRESS +5<br>STAT:[nameStat(increased_stat)] INCREASED BY 2"
	virtual_coins += enemy_coin
	AdjustProgress(10)
	AdjustStats(increased_stat, 2)

	/*-----------------------\
	|Numerical Variable Edits|
	\-----------------------*/

/datum/adventure_layout/proc/AdjustCoins(num)
	virtual_coins += round(num)

/datum/adventure_layout/proc/AdjustHP(num)
	virtual_integrity += round(num)

/datum/adventure_layout/proc/AdjustStats(stat_in_question, num)
	virtual_stats[stat_in_question] += num

// This may be too many adjustment procs.
/datum/adventure_layout/proc/AdjustProgress(num)
	program_progress += num

	/*---------\
	|Misc Procs|
	\---------*/
//Grabs an event out of the options we already have and adds new ones.
/datum/adventure_layout/proc/GrabEvent()
	CheckEventList()
	var/new_event = pickweight(event_options)
	//Just randomize our next chance of encountering this again but make it less than a new events chance.
	event_options[new_event] = rand(1,8)
	return new_event

//Updates event list to see if we can have any new events
/datum/adventure_layout/proc/CheckEventList()
	//The event list except all events we already have are removed.
	var/list/new_events = events - event_options
	for(var/_option in new_events)
		var/datum/adventure_event/A = _option
		if(initial(A.require_abno))
			if(!locate(initial(A.require_abno)) in GLOB.abnormality_mob_list)
				continue
		event_options += A
		event_options[A] = 10

//Describes details about the path ahead.
/datum/adventure_layout/proc/DescribePath(path_num)
	var/what_path = paths_to_tread[path_num]
	var/path_descs = list()
	if(what_path == ADVENTURE_MODE_BATTLE)
		path_descs = list(
			"THIS PATH IS STREWN WITH BROKEN TREES",
			"YOU SEE SOMETHING APPROACHING",
			"A BROKEN STRING OF YARN LEADS INTO THIS PATH",
		)
	if(what_path == ADVENTURE_MODE_TRAVEL)
		//When this is more formed i may change these to be the event descriptions.
		path_descs = list(
			"THIS PATH IS COLD",
			"THIS PATH IS SAFE",
			"THIS PATH IS DULL",
		)
	if(ispath(what_path))
		//There used to be a EVENT_MODE_TRAVEL here but i chose the chaotic option that is extremly janky.-IP
		var/datum/adventure_event/A = what_path
		var/event_text = initial(A.desc)
		if(!event_text)
			event_text = "THIS PATH IS BRIGHT"
		path_descs = list(event_text)

	. += "[pick(path_descs)]<br>"

//for each catagory please place the number its defined as -IP
/datum/adventure_layout/proc/nameMenu(cat)
	switch(cat)
		if(1)
			return "CHOOSE EVENT"
		if(2)
			return "MAIN MENU"
		if(3)
			return "ADVENTURE"

/datum/adventure_layout/proc/nameStat(stat_named)
	switch(stat_named)
		if(1)
			return "WRATH"
		if(2)
			return "LUST"
		if(3)
			return "SLOTH"
		if(4)
			return "GLUTT"
		if(5)
			return "GLOOM"
		if(6)
			return "PRIDE"
		if(7)
			return "ENVY"

//Recover Health based on time. I may scrap this because the thought of mobile game stamina makes me feel sick -IP
/datum/adventure_layout/proc/StatCatchup()
	var/newhealth = 0
	//Your actually missing health and your not currently in battle.
	if(virtual_integrity < 100 && travel_mode != ADVENTURE_MODE_BATTLE)
		newhealth = round((world.time - last_logged_time)/(10 SECONDS))
		if(newhealth == 0)
			return
	//To make stat checkup only restore to 50 change the 100's to 50.
	var/hp_overload_check = (virtual_integrity + newhealth)-100
	if(hp_overload_check > 0)
		//Remove overflow from the health we are adding
		newhealth -= hp_overload_check
	AdjustHP(newhealth)
	last_logged_time = world.time
