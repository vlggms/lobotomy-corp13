/*TEXT BASED ADVENTURES!!! Adventures that are mostly predefined paths.
	This was difficult to finalize since i havent made a text based
	adventure before. */
#define DEBUG_TEXT_DISPLAY 1
#define NORMAL_TEXT_DISPLAY 2
#define ADVENTURE_TEXT_DISPLAY 3
//Modes for what is displayed on the adventure panel.
#define ADVENTURE_MODE_TRAVEL 1
#define ADVENTURE_MODE_BATTLE 2
#define ADVENTURE_MODE_EVENT_BATTLE 3
//Stats defined. I honestly didnt want to make it have limbus company sins but here we are.
#define WRATH_STAT 1
#define LUST_STAT 2
#define SLOTH_STAT 3
#define GLUTT_STAT 4
#define GLOOM_STAT 5
#define PRIDE_STAT 6
#define ENVY_STAT 7
#define RAND_STAT rand(1,7)
//Enemy Standardization. Basically what is considered HARD and what is considered EASY.
#define MON_HP_RAND_EASY rand(10,50)
#define MON_HP_RAND_NORMAL rand(75,100)
#define MON_DAMAGE_EASY "1d6"
#define MON_DAMAGE_NORMAL "2d7"
#define MON_DAMAGE_HARD "2d12"
#define MON_DAMAGE_RAND "[rand(1,2)]d[rand(3,7)]"
/* Easy define for html button format. Place a <br> after this to make the buttons not be right next to eachother.
	WARNING: Only works if the proc is returning nothing or has no returns.*/
#define GENERAL_BUTTON(button_controller,topic,returned_value,button_text) . += " <A href='byond://?src=[button_controller];[topic]=[returned_value]'>[button_text]</A>"

/*-------------\
|Adventure Code|
\-------------*/
/datum/adventure_layout
	//Health?
	var/virtual_integrity = 100
	//Coins for flipping.
	var/virtual_coins = 0
	//Event progress so that your not stuck with nothing but null events.
	var/program_progress = 0
	//Damage in battle senarios. Based on dice values.
	var/virtual_damage = "1d6"
	//Variable for when they last logged in. Used in StatCatchup()
	var/last_logged_time = 0
	//What we are currently displaying.
	var/display_mode = NORMAL_TEXT_DISPLAY
	//What is currently happening while traveling.
	var/travel_mode = ADVENTURE_MODE_TRAVEL
	//If debug menu comes up.
	var/debug_menu = FALSE
	//Temp text for occasional informative text on the UI.
	var/temp_text = ""
	//Currently Selected Event
	var/datum/adventure_event/event_data
	//Used in event chances.
	var/list/virtual_stats = list(
		WRATH_STAT = 10,
		LUST_STAT = 10,
		SLOTH_STAT = 10,
		GLUTT_STAT = 10,
		GLOOM_STAT = 10,
		PRIDE_STAT = 10,
		ENVY_STAT = 10
		)
	//Used in the adventure mechanics. Generated paths will be put here until they are walked.
	var/list/paths_to_tread = list()
	//Events we can choose from.
	var/list/event_options = list()
	//list of all events.
	var/static/list/events = list()

	//Battle Mode Variables
	var/enemy_integrity = 0
	//Enemy flavor text. Currently this is the way we register that a enemy currently exists and it is cleared after battle.
	var/enemy_desc
	//Enemy damage dice
	var/enemy_damage = "1d6"
	//Coins rewarded after defeating the enemy
	var/enemy_coin = 0
	//One day maybe we will have proper enemies but for now this will suffice. -IP
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

/* This proc is called by the adventure datum in order to build the UI.
	Its like a hub where all other general things are called. */
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
			|WRATH:[virtual_stats[WRATH_STAT]]|LUST:[virtual_stats[LUST_STAT]]\
			|SLOTH:[virtual_stats[SLOTH_STAT]]|GLUTT:[virtual_stats[GLUTT_STAT]]\
			|GLOOM:[virtual_stats[GLOOM_STAT]]|PRIDE:[virtual_stats[PRIDE_STAT]]\
			|ENVY:[virtual_stats[ENVY_STAT]]|<br>\
			</tt>"
		//From highest menu define to lowest. -IP
		for(var/mode_option = NORMAL_TEXT_DISPLAY to ADVENTURE_TEXT_DISPLAY)
			. += "<A href='byond://?src=[REF(caller)];set_display=[mode_option]'>[mode_option == display_mode ? "<b><u>[nameMenu(mode_option)]</u></b>" : "[nameMenu(mode_option)]"]</A>"
		if(debug_menu)
			. += "<A href='byond://?src=[REF(caller)];set_display=[DEBUG_TEXT_DISPLAY]'>[display_mode == DEBUG_TEXT_DISPLAY ? "<b><u>[nameMenu(DEBUG_TEXT_DISPLAY)]</u></b>" : "[nameMenu(DEBUG_TEXT_DISPLAY)]"]</A>"

		. += "<br>\
			[DisplayUI(caller, H)]<br>\
			<tt>~~~~~~~~~~</tt><br><b>[pick("THE RUINS ARE CLOSING IN","THEY ALL MARCH OUTWARDS<br>LEAVING THE CITY BEHIND",\
			"IS THAT YOU","I REMEMBER ALL THEIR NAMES","WHAT CANT THE BEHOLDERS SEE",\
			"YOUR CITY IS STARVING","YOUR LEADERS PLAN TO SACRIFICE YOU WHILE YOU WORK")]</b>"

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
		if(ADVENTURE_MODE_BATTLE)
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

/* Enemy Generation for Battle Mode
	Currently not very great, terrible even,
	but i just need to get this up and running. */
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
	/* Ill just leave it at this until i can get it working.
		10/5 = 2, 14/5 = 2 -IP */
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

	/*
	This definition requires the destination of the path change,
	the description of the choice, and the interface recieving this
	definition. Hopefully this definition makes creating these easier.
	*/
#define BUTTON_FORMAT(path_change,choice_desc,interface_caller) . += " <A href='byond://?src=[REF(interface_caller)];choice=[path_change]'>[choice_desc]</A><br>"
#define CHANCE_BUTTON_FORMAT(number,button_text,interface_caller) . += " <A href='byond://?src=[REF(interface_caller)];event_misc=[number]'>[button_text]</A><br>"
//Defines for things that may need to be changed in the future.
#define EXTRA_CHANCE_MULTIPLIER 3
/*---------\
|Event Code|
\---------*/
/datum/adventure_event
	//Name of adventure, displayed at top.
	var/name
	//Description of adventure. This will be displayed next to its path.
	var/desc
	//Where the user is.
	var/cords = 1
	//Extra chance added onto event chances
	var/extra_chance = 0
	//Short lived text that says things that had happened.
	var/temp_text = ""
	//The adventure datum that this event is connected to. Hopefully is set upon being created by it.
	var/datum/adventure_layout/gamer
	//If we need a certain abnormality to appear as a option. If no abnormality is listed this event will occur normally
	var/mob/living/simple_animal/hostile/abnormality/require_abno
	//Discriptions of areas. If cords is 2 then B will be displayed for flavor_desc in UI_Display()
	var/list/adventure_cords = list(
		"A",
		"B",
		"C",
		)

/datum/adventure_event/New(datum/adventure_layout/player)
	. = ..()
	gamer = player


/*This is where most of the choices and effects will appear.
	After your condition for the choice is made with
	"if(cords == 2)" remember to add a return if you do not
	want the continue button to appear. Since we have link
	to the profile and the user we can use their stats
	for checks if we are clever.*/
/datum/adventure_event/proc/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	. += "[temp_text]"
	if(cords)
		BUTTON_FORMAT(0,"CONTINUE", M)

/* This proc is called by the adventure datum in order to build the UI.
	Its like a hub where all other general things are called. */
/datum/adventure_event/proc/Event(obj/machinery/caller, mob/living/carbon/human/H)
	if(!gamer)
		return "<br>ERROR:USER PROFILE MISSING"

	if(!caller)
		return "<br>ERROR:INTERFACE MISSING"

	if(cords == 0)
		EventComplete(caller,H)
		return

	//UI Data for machine that calls us.
	. = UI_Display()
	. += EventChoiceFormat(caller, H)

/* Formating stuff such as UI display that is
	returned to the calling userface such as
	the events name, current cords, and
	flavor text. */
/datum/adventure_event/proc/UI_Display(mob/living/carbon/human/H)
	var/flavor_desc = adventure_cords[cords]
	. += "<b>[name]:[cords]</b><br>"
	. += "-----------<br>[flavor_desc]<br>-----------<br>"

//Code that runs when the event is complete. Mostly resets things.
/datum/adventure_event/proc/EventComplete(obj/machinery/M)
	gamer.event_data = null
	cords = 1
	M.updateUsrDialog()
	qdel(src)

//Called by console after a choice is recieved.
/datum/adventure_event/proc/EventReact(new_cords)
	cords = new_cords

/datum/adventure_event/proc/AddChanceReact()
	extra_chance++
	AdjustCurrency(-1)

//The profile we are taking stats from and the stat we are checking
/datum/adventure_event/proc/ReturnStat(stat_name)
	return gamer.virtual_stats[stat_name]

//A quick proc to put in Flipping coin
/datum/adventure_event/proc/CoinFlipping(obj/machinery/M)
	if(extra_chance)
		. += "([extra_chance * EXTRA_CHANCE_MULTIPLIER]) EXTRA CHANCE<br>"
	if(gamer.virtual_coins > 0)
		if(extra_chance < 5)
			. += " <A href='byond://?src=[REF(M)];extra_chance=extra_chance'>ADD A COIN TO INCREASE CHANCE</A><br>"
	else
		. += "You have no coins.<br>"

		/*-----------------\
		|Event Effect Procs|
		\-----------------*/
/datum/adventure_event/proc/CauseBattle(new_desc = "ERROR", new_damage = "1d6", new_hp = 50)
	gamer.travel_mode = ADVENTURE_MODE_EVENT_BATTLE
	gamer.enemy_desc = new_desc
	gamer.enemy_integrity = new_hp
	gamer.enemy_damage = new_damage
	temp_text += "ENEMY INITIALIZATION COMPLETE<br>"

/* This is inconviently weird/simple? meaning if you want it
	to be more complext you need to override it. The
	place where the chance buttons appear would be A
	on the flavor text list. If it succeeds it would
	then go to B. If it fails then it would go to C.
	So when structuring the adventure cords list.
	visual exsample:
		list(
		"Ability Challenge",
		"YES WE DID IT",
		"Ah, eto... Bleh!")
			-IP*/
/datum/adventure_event/proc/ChanceCords(input_num)
	var/remember_chance = input_num + (extra_chance * EXTRA_CHANCE_MULTIPLIER)
	temp_text += "CHANCE [remember_chance]:"
	extra_chance = 0
	if(prob(remember_chance))
		temp_text += "SUCCESS<br>"
		cords += 1
	else
		temp_text += "FAILURE<br>"
		cords += 2

	/*---------------------\
	|Profile Variable Edits|
	\---------------------*/
/datum/adventure_event/proc/AdjustHitPoint(datum/adventure_layout/P, add_num)
	P.AdjustHP(add_num)
	if(add_num <= -1)
		temp_text += "[add_num] HP LOST<br>"
	if(add_num >= 1)
		temp_text += "[add_num] HP GAINED<br>"

/datum/adventure_event/proc/AdjustCurrency(datum/adventure_layout/P, add_num)
	P.AdjustCoins(add_num)
	if(add_num <= -1)
		temp_text += "[abs(add_num)] COIN[add_num == -1 ? "S" : ""] LOST<br>"
	if(add_num >= 1)
		temp_text += "[add_num] COIN[add_num == 1 ? "S" : ""] GAINED<br>"

/datum/adventure_event/proc/AdjustStatNum(datum/adventure_layout/P, stat_to_add, add_num)
	P.AdjustStats(stat_to_add, add_num)
	if(add_num <= -1)
		temp_text += "[add_num] [P.nameStat(stat_to_add)] LOST<br>"
	if(add_num >= 1)
		temp_text += "[add_num] [P.nameStat(stat_to_add)] GAINED<br>"

	/*------------\
	|Unique Events|
	\------------*/
/* Unique events can be the memories of the abnormalities, their victems, or formative encounters.
	Just a intresting event that may or may not provide or be based on the lore. */

		/*-------------\
		|General Events|
		\-------------*/
//Refrence to a shot from the early access trailer to lobotomy corp where a cowering agent is surrounded by a void of monsters.
/datum/adventure_event/legacy
	name = "The Falling World"
	desc = "THIS PATH IS STREWN WITH DEBRIS"
	adventure_cords = list(
		"A twisting green hue pours out from a door. Silhouetted against that light is a humanoid figure. \
			<br>The figure grabs their head and cowers as the edges of the room crumble away. \
			<br>Encircling the doorway at the edge of your visions are the writhing outline of monsters.",
		//Not great story choices i know -IP
		"You remain silent as the shadows obscure your view of the figure",
		"The figure looks towards you, and so do the shadows. You are not alone.",
		)

/datum/adventure_event/legacy/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"HIDE", M)
			BUTTON_FORMAT(3,"REACH OUT", M)
			return
		if(2)
			AdjustStatNum(SLOTH_STAT,1)
		if(3)
			//I just love how ominous this sound effect is.
			playsound(get_turf(H), 'sound/effects/creak1.ogg', 20, FALSE)
			AdjustStatNum(GLOOM_STAT,1)
	. = ..()

/datum/adventure_event/quiz
	name = "Quiz Time"
	desc = "YOU HEAR AN ANNOYING VOICE"
	adventure_cords = list(
		"As you step through the threshold a figure starts to take form as they run towards you yelling 'QUIZ TIME!'. \
			They have no face but you can infer from their outfit that they are some kind of fixer. The quiz fixer stops and \
			stares at you with their eyeless face.",
		"A simple push is all it takes to send them falling silently back into the void. You \
			watch their body as the darkness consumes them.",
		"'LET US SEE HOW MUCH YOU KNOW YOUR CITY!' the figure then pulls a peice of paper out of their pocket and unfolds it \
			'SWEEPER FLUID IS PATENTED BY ONE PERSON AND ONE PERSON ONLY. WHO IS IT?'.",
		"'YES THAT DOES SEEM TO BE WRITTEN HERE!' the figure says as they hand you some strange object.\
			'THANK YOU FOR ANSWERING RUN ALONG NOW.'",
		"They look down at their card and then back up at you. 'IM SORRY BUT THAT IS NOT \
			WRITTEN HERE GOODBYE' they then start violently growing blue metal out of \
			their face.",
		)

/datum/adventure_event/quiz/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"PUSH HER INTO THE VOID", M)
			BUTTON_FORMAT(3,"AGREE TO THE QUIZ", M)
			return
		if(3)
			BUTTON_FORMAT(4,"THE HEAD OF A CORP", M)
			BUTTON_FORMAT(5,"Z CORPORATION", M)
			BUTTON_FORMAT(5,"THE SWEEPER QUEEN", M)
			BUTTON_FORMAT(5,"K CORPORATION", M)
			BUTTON_FORMAT(5,"NONE CAN PATENT GOO", M)
			return
		if(4)
			AdjustStatNum(PRIDE_STAT,1)
		if(5)
			CauseBattle("Speculative Amalagam Error:Some imperfect mix of a fixer and a sweeper. The differing physiology of a sweeper and a human \
				causes them to violently ooze red fluid from where the sweeper parts end and the human parts begin.","1d10",MON_HP_RAND_EASY)
	. = ..()

/datum/adventure_event/sinking_bell
	name = "Sinking Bell"
	desc = "IT IS COLD AND MOIST"
	adventure_cords = list(
		"You find yourself inside some metal container chest deep in water. There is no floor to the contraption \
			leaving you wading above a pitch black abyss.",
		"You let yourself get dragged below the water. It feels like a relief, a cure to your exhaustion. Then \
			the pain starts. Your lungs burn as everything around you starts to squeeze. Wherever you are is \
			trying to push you out but that sinking feeling pulls you ever deeper. Desperately trying to get \
			back to the surface you claw at the formless walls that wrap your arms until they go numb.<br>\
			Your eyes are screaming, <br>\
			your lungs are screaming, <br>\
			your body is screaming, <br>\
			everything inside you is screaming.",
		"The next few minutes are a frenzied panic as the light grows dimmer. There is nowhere left to crawl. \
			The light is gone and your chest sinks like lead into the darkness.",
		"You wash back onto shore wounded but alive. You know you will be back here again. You return to the \
			path and continue your journey.",
		"You see a bell that is out of reach and an inscription below two eye holes that only peer out into \
			more darkness.<br>'FOR THAT WHICH WILL PROTECT ME I THANK YOU<br>RING THE BELL AND I WILL BE THERE SOON'.",
		"A feeling appears as you reach for the bell. It feels like a lead ball in your chest pulling you down \
			to the darkness below.",
		"You keep reaching for the bell. It is a exhuasting effort and sometimes you find yourself slipping \
			below the silver line of the water. The feeling in your chest grows in weight as you reach out.",
		"The water washes over your face as you use the last of your effort. You hear the bell and then go \
			limp. You slowly sink into the darkness.",
		"The silence is comforting as you are adrift above the darkness. The dull whirring of machinery \
			is your lulluby as you feel something push you back up from below. The pressure of the water \
			slowly fades as your broken body is pushed up to the water. When you awaken your on the shore \
			unharmed. As you look back you see a metal container with two eyes slowly sink below the waves.",
		)

/datum/adventure_event/sinking_bell/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(5,"CHECK FOR ANY EXITS", M)
			return
		if(2)
			BUTTON_FORMAT(3,"HELP ME", M)
			return
		if(3)
			BUTTON_FORMAT(4,"PLEASE COME BACK", M)
			return
		if(4)
			AdjustHitPoint(-20)
		if(5)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(6,"REACH FOR THE BELL", M)
			return
		if(6)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(7,"REACH FOR THE BELL", M)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			return
		if(7)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(8,"RING THE BELL", M)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(2,"SURRENDER TO THE PULL", M)
			return
		if(8)
			BUTTON_FORMAT(9,"REST", M)
			return
	. = ..()

		/*-----------\
		|ZAYIN Events|
		\-----------*/

		/*----------\
		|Teth Events|
		\----------*/

/datum/adventure_event/match
	name = "Final Match"
	desc = "A COLD WIND BLOWS FROM THIS PATH"
	require_abno = /mob/living/simple_animal/hostile/abnormality/scorched_girl
	adventure_cords = list(
		"You stand in the snow peering into a nicely lit home. Inside is the scene of a family \
			having dinner. Next to you is a small girl holding a box of matches, she stands there \
			watching blankly as the world ignores her.",
		"The window breaks as the inside of the house erupts into flames. The warmth of the fire \
			is comforting in the bitter chill. The girl next to you smiles weakly before the fire \
			dies down leaving nothing but cold ash and burnt matches.",
		//You cannot change the outcome of the story.
		"You feel strangely out of place while you fish out a coin from your pocket and request a \
			match. The girl turns to you, her form starts to sizzle and burn. After handing you a \
			match she erupts into a fire that carries no warmth.",
		)

/datum/adventure_event/match/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"CONTINUE TO WATCH", M)
			if(gamer.virtual_coins > 0)
				BUTTON_FORMAT(3,"REQUEST A MATCH", M)
			else
				. += "You have no coins.<br>"
			return
		if(2)
			AdjustHitPoint(10)
			AdjustStatNum(ENVY_STAT,1)
		if(3)
			AdjustCurrency(-1)
	. = ..()

/* This event is mostly based on what i THINK the creators of forsaken murderer are trying to say.
	Experimentation on murderers that leave them lobotomized shadows is just inherently selfish
	and provides only a oppertunity to do the unspeakable to others without a hint of guilt?
	Or that its messed up to see profit from the existence of murderers? Who knows? -IP */
/datum/adventure_event/murderer
	name = "The Forsaken Killer"
	desc = "YOU SEE SOMEONE STRAPPED TO A TABLE"
	require_abno = /mob/living/simple_animal/hostile/abnormality/forsaken_murderer
	adventure_cords = list(
		"Before you is a emaciated man strapped to a surgical bed. Next to him on a metal table are \
			documents of his crimes and a medical diagram indicating the location of something \
			of value within his brain.",
		"Ability Challenge",
		"Within his brain you find what you wanted. You walk away leaving a wound that will never \
			heal. Its only fitting his wretched life was of some use to you.",
		"You glance at the mans eyes. You dont see fear or sadness but... contempt? \
			While your distracted looking into the mans eyes, he then headbutts \
			you hard enough to knock you off your feet. You find youself somewhere \
			else as you regain your footing.",
		"As you turn to leave the monsterous man strapped to his table you hear the muffled \
			screams and tearing of flesh. You look back at the fading scene of a shadowy woman \
			tearing out something from the mans brain.",
		)

/datum/adventure_event/murderer/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"BUTCHER THE MANS BRAIN", M)
			BUTTON_FORMAT(3,"LEAVE", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT),"WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT),"SLOTH", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(3)
			AdjustStatNum(WRATH_STAT,3)
		if(4)
			AdjustHitPoint(-5)
	. = ..()

/datum/adventure_event/old_lady
	name = "The Lonely Lady"
	desc = "YOU HEAR THE CREAKING OF A ROCKING CHAIR"
	require_abno = /mob/living/simple_animal/hostile/abnormality/old_lady
	adventure_cords = list(
		"The doorframe buckles and splinters as you enter the room. You follow the \
			sound of creaking and see her. Her eyes are glazed over, sunken, and grey. \
			Her head tilts up as she asks if your ready to hear her story.",
		"The unease grows as you sit down before the woman. She slowly begins \
			to tell you a story. The story begins with her recounting some incomprehensible \
			events. Halfway through the story you feel burning bleed throughout your brain. \
			As you writhe on the ground you catch a small incomprehensible \
			part of the story before bolting out of the room. As the doorway fades away \
			you see her smiling at the spot where you sat.",
		"Ability Challenge",
		"As you leave her expression changes to a blank sadness. You feel the room decay \
			and the floor buckles with each step. You manage to dive out of the doorway as \
			the room is completely consumed in some vile gas.",
		"You feel a foul gas enter your lungs. The gas slowly manifests with each step you \
			attempt. It tastes of peeling wallpaper and threatens you with a eternity in \
			this room. With one last attempt you weakly dive out of the doorway."
		)

/datum/adventure_event/old_lady/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"STAY AND LISTEN", M)
			BUTTON_FORMAT(3,"LEAVE", M)
			return
		if(2)
			AdjustHitPoint(-15)
			AdjustStatNum(RAND_STAT,3)
		if(3)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT),"GLOOM", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT),"GLUTT", M)
			. += CoinFlipping(M)
			return
		if(5)
			AdjustHitPoint(-5)
	. = ..()

		/*--------\
		|HE Events|
		\--------*/

		/*---------\
		|WAW Events|
		\---------*/

		/*-----------\
		|ALEPH Events|
		\-----------*/

		/*--------------------\
		|LIMBUS COMPANY EVENTS|
		\--------------------*/
//In the event that we have to purge all of these events due to Project Moon not approving of them being here do not mix them in with original events. -IP

/datum/adventure_event/golden_grip
	name = "Mirror Shard:Golden Grip"
	adventure_cords = list(
		"Could these five appendages protruding from the urn be a palm?<br>\
			Or is it a naked person who put their head into the golden urn?<br>\
			What did this person see in the urn to cause them to shove their face into it?<br>\
			As if that wasn't enough, the whole body turned into a hand that tries to grasp everything it can.<br>\
			If it finally takes hold of everything in the world, will its grip loosen at last?",
		"Ability Challenge",
		"Trying to lightly remove it is like brushing off dust<br>\
			Is an affront to the greed that refused to dissipate even after shoving the head into it.<br>\
			There was no choice but to watch as the hand reached out.",
		"We thought we pulled it out, but couldn't move forward.<br>\
			Seeing it grasp at coattails until the end, you're sapped of strength, bound by the dreadful tenacity.",
		"Ability Challenge",
		"To hug is to embrace another.<br>\
			The fingers that were stretched to grasp things clasp with another's appendages for the first time.<br>\
			Between the quietly laced appendages, there was a warmth of blood beginning to circulate.<br>\
			Like that, the rigid greed loosens.",
		"It seems the basic manners of clearing sweat from the hand before extending it for a handshake were neglected.<br>\
			Your hand slipped, and the emptied palm wriggles as if to seek another left hand to grasp.<br>\
			However, it no longer tries to recklessly grab things, seemingly fulfilled by the attempt.")

/datum/adventure_event/golden_grip/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"REMOVE THE HEAD FROM THE URN", M)
			BUTTON_FORMAT(5,"HUG AND SHAKE THE BODY", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT),"SLOTH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(LUST_STAT),"LUST", M)
			. += CoinFlipping(M)
			return
		if(3)
			CauseBattle("Urn Body:A large grey human body with a gold urn for a head. You cant help but \
				notice the giant fanged mouth that has taken up most of its abdominal region.", MON_DAMAGE_NORMAL, 120)
		if(4)
			AdjustHitPoint(-40)
		if(5)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT),"GLUTTONY", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(PRIDE_STAT),"PRIDE", M)
			.+= CoinFlipping(M)
			return
		if(6)
			AdjustCurrency(3)
		if(7)
			AdjustCurrency(1)
			AdjustHitPoint(-15)
	. = ..()

/datum/adventure_event/coffin_return
	name = "Mirror Shard:Coffin Return"
	desc = "YOU HEAR THE WAILING"
	//I thought this event was cool for being just a lil red beetle until i read the rest of the text,-IP
	adventure_cords = list(
		"A wail fills the forest<br>\
			You cant help but wonder what it's so sorrowful for.<br>\
			Theres a coffin in the middle of the woods.<br>\
			It has been tied with multiple cords and ropes, in \
			what appears to be a desperate attempt to keep its contents from escaping.<br>\
			However, the coffin continues to rumble and creak.",
		"Ability Challenge",
		"With each rope that’s untied, the wail grows louder.\
			You feel sympathy for the trapped being.<br>\
			Undoing the ropes, you begin to weep<br>\
			along with their wailing.<br>\
			One undone knot accompanies sorrow.<br>\
			One undone knot accompanies lamentation.<br>\
			When the last is released,<br>\
			you discover that there is no one inside.<br>\
			Perplexed, you examine the interior,<br>\
			and find a single, red-jeweled beetle.<br>",
		"With each rope that’s untied, the wail grows louder.<br>\
			There’s more than one individual occupying the coffin.<br>\
			Several people are clinging to each other, all crying.<br>\
			The coffin bursts open, letting them out.<br>",
		"Ability Challenge",
		"The red arms wave in the air,<br>\
			as if pleading not to be left behind.<br>\
			But, after another look,<br>\
			it also seems as if they’re thankful for being left as they are.<br>\
			Though the wailing hasn’t ceased,<br>\
			the weeping seems to have softened, just a little..<br>",
		"You disregard the chilling sensation and move on.<br>\
			However, that feeling would linger, even after a while of walking.<br>\
			At one point, you stopped and turned around to find a hand.<br>\
			It was attached to an unnaturally scrawny red arm.<br>\
			It grabbed its speechless victim.<br>\
			A familiar note was added to the coffins wailing.")

/datum/adventure_event/coffin_return/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"OPEN THE COFFIN", M)
			BUTTON_FORMAT(5,"LEAVE IT BE", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT),"WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT),"GLUTTONY", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(1)
			AdjustStatNum(RAND_STAT,1)
		if(4)
			CauseBattle(pick("Wound Clerids:Small red insects that cause excessive bleeding.",
				"Coffin Hand:A slender red hand emerging from a coffin."), "3d3", MON_HP_RAND_EASY)
		if(5)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT),"WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT),"SLOTH", M)
			.+= CoinFlipping(M)
			return
		if(7)
			AdjustHitPoint(-27)
	. = ..()

#undef DEBUG_TEXT_DISPLAY
#undef NORMAL_TEXT_DISPLAY
#undef ADVENTURE_TEXT_DISPLAY
#undef ADVENTURE_MODE_TRAVEL
#undef ADVENTURE_MODE_BATTLE
#undef ADVENTURE_MODE_EVENT_BATTLE
#undef WRATH_STAT
#undef LUST_STAT
#undef SLOTH_STAT
#undef GLUTT_STAT
#undef GLOOM_STAT
#undef PRIDE_STAT
#undef ENVY_STAT
#undef RAND_STAT
#undef MON_HP_RAND_EASY
#undef MON_HP_RAND_NORMAL
#undef MON_DAMAGE_EASY
#undef MON_DAMAGE_NORMAL
#undef MON_DAMAGE_HARD
#undef MON_DAMAGE_RAND
#undef GENERAL_BUTTON
#undef BUTTON_FORMAT
#undef CHANCE_BUTTON_FORMAT
#undef EXTRA_CHANCE_MULTIPLIER
