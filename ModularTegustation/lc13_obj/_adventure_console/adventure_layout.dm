/**
 * ADVENTURE CONSOLE V2.3
 * TEXT BASED ADVENTURES
 * Adventures that are mostly predefined paths.
 * This was difficult to finalize since i havent made a text based adventure before.
 * Special defines such as button macros are in the code/_DEFINES/~lobotomy_defines.dm
 *
 * The way i made this system is unusual to say the least. Its a stand alone datum that
 * is vaguely connected to the console that created it. While this does make the program
 * portable it also makes it so that when the console is destroyed there is just a datum
 * floating around in the code. Unsure how bad this is. -IP
 */

#define ATTACK_MINIMENU 0
#define HEALTH_MINIMENU 1
#define BLOCK_MINIMENU 2
#define RUN_MINIMENU 3
#define INFO_MINIMENU 4
#define EXTRA_MINIMENU 5

/datum/adventure_layout
	///Current and max player health
	var/max_integrity = 100
	var/virtual_integrity = 100
	///Coins for flipping.
	var/virtual_coins = 0
	///Event progress so that your not stuck with nothing but null events.
	var/program_progress = 0
	///Damage and block in battle senarios. Based on dice values.
	var/virtual_damage = "1d4"
	var/virtual_block = "1d4"
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
	///Events we cannot encounter again
	var/list/spent_events = list()
	///list of all events.
	var/static/list/events = list()
	//Keys required for events to appear.
	var/list/event_keys = list()

	//Battle Mode Variables
	///Enemy's current health
	var/enemy_integrity = 0
	///Enemy flavor text. Currently this is the way we register that a enemy currently exists and it is cleared after battle.
	var/enemy_desc
	///Enemy damage dice
	var/enemy_damage = "1d6"
	///Coins rewarded after defeating the enemy
	var/enemy_coin = 0
	//Event Key unlocked by defeating this enemy
	var/enemy_key
	///One day maybe we will have proper enemies but for now this will suffice. -IP
	var/list/enemy_descriptions = list(
		"<b>Recorded Clerk</b>:A familiar looking humanoid. They wear ragged clothes and a L corp armband. You swear you used to know their name.<br>",
		"<b>Recorded Rat</b>:A low life from the backstreets. Their face is disfigured beyond recognition, all you can make out are their eyes.<br>",
		"<b>Digital Reflection</b>:Its you! Well it looks LIKE you.<br>",
	)

	///UPGRADE STUFF
	///Do you have the all-abnos upgrade?
	var/all_abnos

	///How much HP do you heal on block?
	var/block_heal = 0
	var/block_heal_counter
	var/max_block_heal = 10

	//Run Chance, healing, and gold chance
	var/run_chance = 30
	var/run_healing = 0
	var/run_gold = 0

	//Info Chance and Bonus
	var/info_chance = 30
	var/info_bonus = 0
	var/currently_scanned = FALSE
	/*
	* Exchange shop for digital coins. The only other use for coins is during events
	* where you want to increase your chance of success in a event or have a unique
	* interaction. For defeating enemeies the calculation for coins rewarded is
	* enemy_coin = round((sides of damage die * amount of damage die)/5)
	* this means that enemies that deal 1d5 damage will grant 1 coin. theoretically
	* beelining enemy encounters will result in about 5 coins before the user is
	* defeated. -IP
	*/
	var/minimenu_mode = 0
	var/list/exchange_shop_list = list(
		/*		All Toys. Will add them back later in their own mini tab
		new /datum/data/extraction_cargo("SNAP POP",	/obj/item/toy/snappop,				10) = 1,
		new /datum/data/extraction_cargo("WATER BALLOON",	/obj/item/toy/waterballoon,		10) = 1,
		new /datum/data/extraction_cargo("TOY SWORD",	/obj/item/toy/waterballoon,			10) = 1,
		new /datum/data/extraction_cargo("CAT TOY",	/obj/item/toy/cattoy,					15) = 1,
		new /datum/data/extraction_cargo("PLUSH OF A FRIEND",/obj/item/toy/plush/binah,		15) = 1,
		new /datum/data/extraction_cargo("HOURGLASS",	/obj/item/hourglass,				25) = 1,
		new /datum/data/extraction_cargo("CAT",	/mob/living/simple_animal/pet/cat,			50) = 1,
		new /datum/data/extraction_cargo("CAK",	/mob/living/simple_animal/pet/cat/cak,		100) = 1,
		new /datum/data/extraction_cargo("SNAKE", /mob/living/simple_animal/hostile/retaliate/poison/snake,	100) = 1,*/

		//Actual Shit
		new /datum/data/extraction_cargo("SUSPICIOUS CRATE",		/obj/structure/lootcrate/money,			2) = 1,
		new /datum/data/extraction_cargo("A GRENADE",				/obj/effect/spawner/lootdrop/grenade,	3) = 1,
		new /datum/data/extraction_cargo("SOME AHN",				/obj/item/stack/spacecash/c500,			5) = 1,
		new /datum/data/extraction_cargo("POSITIVE ENKEPHALIN",		/obj/item/rawpe,						10) = 1,
		new /datum/data/extraction_cargo("UNMARKED CRATE",			/obj/structure/lootcrate,				15) = 1,
	)

	var/list/exchange_upgrade_list = list(
		//-------- ATTACK --------
		//DICE
		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 1d6","1d6",		1, "DICE", ATTACK_MINIMENU) = 1,	//Basically mandatory

		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 3d2","3d2",		5, "DICE", ATTACK_MINIMENU) = 1,	//This is a more powerful 1d6
		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 1d8","1d8",		5, "DICE", ATTACK_MINIMENU) = 1,

		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 2d4","2d4",		10, "DICE", ATTACK_MINIMENU) = 1,	//T3 dice
		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 1d10","1d10",	12, "DICE", ATTACK_MINIMENU) = 1,

		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 1d12","1d12",	18, "DICE", ATTACK_MINIMENU) = 1,	//T4 Dice
		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 2d6","2d6",		20, "DICE", ATTACK_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("COMBAT DICE UPGRADE 3d4","3d4",		22, "DICE", ATTACK_MINIMENU) = 1,

		//-------- HEALTH --------
		//Healing
		new /datum/data/adventure_upgrade("RESTORE 15 HEALTH",	15,		1, "HP", HEALTH_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RESTORE 100 HEALTH",	100,	5, "HP", HEALTH_MINIMENU) = 1,

		//Health
		new /datum/data/adventure_upgrade("MAX INTEGRITY: 110",	110,	3,	"MAXHP", HEALTH_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("MAX INTEGRITY: 120",	120,	7,	"MAXHP", HEALTH_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("MAX INTEGRITY: 130",	130,	15, "MAXHP", HEALTH_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("MAX INTEGRITY: 140",	140,	30, "MAXHP", HEALTH_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("MAX INTEGRITY: 150",	150,	50, "MAXHP", HEALTH_MINIMENU) = 1,

		//-------- BLOCK --------
		//Block Dice
		new /datum/data/adventure_upgrade("BLOCK DICE UPGRADE 1d6","1d6",		1, 	"BLOCKDICE", BLOCK_MINIMENU) = 1,	//Basically mandatory
		new /datum/data/adventure_upgrade("BLOCK DICE UPGRADE 1d8","1d8",		3, 	"BLOCKDICE", BLOCK_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("BLOCK DICE UPGRADE 1d10","1d10",		6,	"BLOCKDICE", BLOCK_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("BLOCK DICE UPGRADE 1d12","1d12",		10, "BLOCKDICE", BLOCK_MINIMENU) = 1,	//T4 Dice

		//Block Healing
		new /datum/data/adventure_upgrade("BLOCK HEALING: 3",	3,	5,	"BLOCKHEAL", BLOCK_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("BLOCK HEALING: 5",	5,	10,	"BLOCKHEAL", BLOCK_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("BLOCK HEALING: 10",	10,	25, "BLOCKHEAL", BLOCK_MINIMENU) = 1,

		//Max Block Healing
		new /datum/data/adventure_upgrade("MAX BLOCK HEALING: 20",	20,	15, "BLOCKMAX", BLOCK_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("MAX BLOCK HEALING: 30",	30,	30, "BLOCKMAX", BLOCK_MINIMENU) = 1,


		//-------- RUN --------
		//Run Chance
		new /datum/data/adventure_upgrade("RUN CHANCE: 40%",	40,	7,	"RUNCHANCE", RUN_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RUN CHANCE: 50%",	50,	15,	"RUNCHANCE", RUN_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RUN CHANCE: 60%",	60,	27, "RUNCHANCE", RUN_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RUN CHANCE: 70%",	70,	45, "RUNCHANCE", RUN_MINIMENU) = 1,

		//Run healing
		new /datum/data/adventure_upgrade("RUN HEALING: 3",		3,	3,	"RUNHEAL", RUN_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RUN HEALING: 5",		5,	10,	"RUNHEAL", RUN_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RUN HEALING: 10",	10,	25,	"RUNHEAL", RUN_MINIMENU) = 1,

		//Run gold chance
		new /datum/data/adventure_upgrade("RUN GOLD CHANCE: 10%",		10,	3,	"RUNGOLD", RUN_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RUN GOLD CHANCE: 35%",		35,	10,	"RUNGOLD", RUN_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("RUN GOLD CHANCE: 50%",		50,	25,	"RUNGOLD", RUN_MINIMENU) = 1,


		//-------- INFO --------
		//Info Chance
		new /datum/data/adventure_upgrade("INFO CHANCE: 40%",	40,	3,	"INFOCHANCE", INFO_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("INFO CHANCE: 60%",	60,	7,	"INFOCHANCE", INFO_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("INFO CHANCE: 80%",	80,	14, "INFOCHANCE", INFO_MINIMENU) = 1,

		//Info Bonus
		new /datum/data/adventure_upgrade("INFO BONUS: 1",		1,	7,	"INFOBONUS", INFO_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("INFO BONUS: 2",		2,	20,	"INFOBONUS", INFO_MINIMENU) = 1,
		new /datum/data/adventure_upgrade("INFO BONUS: 3",		3,	35,	"INFOBONUS", INFO_MINIMENU) = 1,


		//Special
		new /datum/data/adventure_upgrade("MORE CONTENT",	100,			20, "ABNOS", EXTRA_MINIMENU) = 1,
	)

	/*-----------------\
	|Stat Upgrade Datum|
	\-----------------*/
/datum/data/adventure_upgrade
	var/stuff_name = "ERROR"
	var/stat_value = 0
	var/cost = 0
	var/trade_type = "HP"
	var/cat = 0

/datum/data/adventure_upgrade/New(name, stat_amt, cost, trading_type, new_cat)
	src.stuff_name = name
	src.stat_value = stat_amt
	src.cost = cost
	src.trade_type = trading_type
	src.cat = new_cat

//---
/datum/adventure_layout/New(set_debug_menu = FALSE)
	. = ..()
	if(!events.len)
	//Later on this may become very heavy on processing when a new adventure profile is made.
		for(var/_event in subtypesof(/datum/adventure_event))
			events += _event
	debug_menu = set_debug_menu
	if(debug_menu)
		virtual_coins = 100

	/*-------------\
	|UNSORTED PROCS|
	\-------------*/
/**
 * Add a key to the list in order to unlock connected events
 */
/datum/adventure_layout/proc/GiveKey(key_id)
	if(!key_id)
		return FALSE
	if(event_keys.Find(key_id
	))
		return FALSE
	event_keys += key_id

	/*---------------\
	|Return Visual UI|
	\---------------*/

/**
 * This proc is called by the adventure datum in order to build the UI.
 * Its like a hub where all other general things are called.
 */
/datum/adventure_layout/proc/Adventure(obj/machinery/requester, mob/living/carbon/human/H)
	if(!H.client)
		return

	//Dispaly Event Data
	if(event_data)
		. += event_data.Event(requester, H)
		if(!event_data)
			//Due to a quirk of the code we have to set it to main menu before we can actually change back to where we were.
			display_mode = NORMAL_TEXT_DISPLAY
			//Emergency Exit because the event can lead to a empty screen due to the event deleting itself.
			GENERAL_BUTTON(REF(requester),"set_display",ADVENTURE_TEXT_DISPLAY,"RETURN TO THE PATH")
	else
		//STATS! ARE HERE
		. = "<tt>\
			|USER:[uppertext(H.name)]|HP:[virtual_integrity]/[max_integrity]|COINS:[virtual_coins]||EVENT_CHANCE:[program_progress]<br>\
			|DAMAGE_DICE:[virtual_damage]<br>\
			|BLOCK_DICE:[virtual_block]|BLOCK_HEALING:[block_heal]|MAXIMUM_BLOCK_HEALING:[max_block_heal]|<br>\
			|RUN_CHANCE:[run_chance]|RUN_HEALING:[run_healing]|RUN_GOLD:[run_gold]<br>\
			|LOOK_CHANCE:[info_chance]|LOOK_GOLDBONUS:[info_bonus]<br>\
			|WRATH:[virtual_stats[WRATH_STAT]]\
			|LUST:[virtual_stats[LUST_STAT]]\
			|SLOTH:[virtual_stats[SLOTH_STAT]]\
			|GLUTT:[virtual_stats[GLUTT_STAT]]\
			|GLOOM:[virtual_stats[GLOOM_STAT]]\
			|PRIDE:[virtual_stats[PRIDE_STAT]]\
			|ENVY:[virtual_stats[ENVY_STAT]]|<br>\
			</tt>"
		//From highest menu define to lowest. -IP
		for(var/mode_option = NORMAL_TEXT_DISPLAY to EXCHANGE_TEXT_DISPLAY)
			. += "<A href='byond://?src=[REF(requester)];set_display=[mode_option]'>[mode_option == display_mode ? "<b><u>[nameMenu(mode_option)]</u></b>" : "[nameMenu(mode_option)]"]</A>"
		if(debug_menu)
			. += "<A href='byond://?src=[REF(requester)];set_display=[DEBUG_TEXT_DISPLAY]'>[display_mode == DEBUG_TEXT_DISPLAY ? "<b><u>[nameMenu(DEBUG_TEXT_DISPLAY)]</u></b>" : "[nameMenu(DEBUG_TEXT_DISPLAY)]"]</A>"

		. += "<br>\
			[DisplayUI(requester, H)]<br>\
			<tt>~~~~~~~~~~</tt><br><b>[pick(
				"THE RUINS ARE CLOSING IN",
				"THEY ALL MARCH OUTWARDS<br>LEAVING THE CITY BEHIND",
				"IS THAT YOU",
				"I REMEMBER ALL THEIR NAMES",
				"WHAT CANT THE BEHOLDERS SEE",
				"YOUR CITY IS STARVING",
				"YOUR LEADERS PLAN TO SACRIFICE YOU WHILE YOU WORK",
				"GO BACK TO THE LAKE",
				"YELLOW FROG LEGS FOR MY EVIL SPELL",
				"WE ARE WATCHING",
				"[uppertext(H.name)]. [uppertext(H.name)]. [uppertext(H.name)]. [uppertext(H.name)]",
				"49 20 53 45 45 20 59 4F 55",
				"THEY ARE GETTING CLOSER",
				"DO NOT ENTER THE ELEVATOR WITH HIM.",
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
				your shift a report will be expected on the events you encounter.<br>\
				<tt>\
				----------<br>\
				|TROPHIES|<br>\
				----------<br>"
			var/items_per_rack = 0
			for(var/trophy_name in event_keys)
				. += "[trophy_name], "
				items_per_rack++
				if(items_per_rack >= 4)
					. += "<br>"
					items_per_rack = 0
			. += "</tt>"

		if(ADVENTURE_TEXT_DISPLAY)
			. += "[TravelUI(interfacer)]"

		if(EXCHANGE_TEXT_DISPLAY)
			. += "[ShoppeUI(interfacer, viewer)]"


/datum/adventure_layout/proc/ShoppeUI(obj/machinery/interfacer, mob/living/carbon/human/viewer)
	. += "COIN EXCHANGE <br> \
		<tt>--------------------| </tt><br>\
		PHYSICAL_MERCHANDISE<br>"
	//Code taken from fish_market.dm
	for(var/datum/data/extraction_cargo/A in exchange_shop_list)
		. += " <A href='byond://?src=[REF(interfacer)];purchase=[REF(A)]'>[A.equipment_name] ([A.cost] Coins)</A><br>"
	. += "<tt>--------------------| </tt><br> \
		SYSTEM UPGRADES<br>"
	for(var/minimenu_mode_option = ATTACK_MINIMENU to EXTRA_MINIMENU)
		. += "<A href='byond://?src=[REF(interfacer)];set_minidisplay=[minimenu_mode_option]'>[minimenu_mode_option == minimenu_mode ? "<b><u>[nameMiniMenu(minimenu_mode_option)]</u></b>" : "[nameMiniMenu(minimenu_mode_option)]"]</A>"
	. += "<br><tt>--------------------| </tt><br>"
	for(var/datum/data/adventure_upgrade/U in exchange_upgrade_list)
		if(U.cat == minimenu_mode)
			. += " <A href='byond://?src=[REF(interfacer)];upgrade=[REF(U)]'>[U.stuff_name] ([U.cost] Coins)</A><br>"
	. += "<tt>--------------------| </tt>"

/datum/adventure_layout/proc/TravelUI(obj/machinery/call_machine)
	switch(travel_mode)
		if(ADVENTURE_MODE_BATTLE, ADVENTURE_MODE_EVENT_BATTLE)
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
	enemy_key = null

/datum/adventure_layout/proc/GeneratePaths(max_paths)
	var/datum/adventure_event/forced_event
	var/list/editable_paths = list()
	for(var/i=1 to max_paths)
		//Unsure if i should put in a check in order to prevent 3% chance events.-IP
		//A minimum is fine, I set it to 15%. - KK
		if(prob(program_progress) && program_progress > 15)
			var/datum/adventure_event/P = GrabEvent()
			editable_paths += P
			if(P.force_encounter == TRUE)
				forced_event = P
				break
			continue
		if(prob(program_progress + 10))
			editable_paths += ADVENTURE_MODE_BATTLE
			continue
		else
			editable_paths += ADVENTURE_MODE_TRAVEL

	//Should we force the player to only take this path?
	if(forced_event)
		for(var/path_to_take in editable_paths)
			var/datum/adventure_event/A = editable_paths[path_to_take]
			if(forced_event && A == forced_event)
				continue
			editable_paths -= A
			if(istype(A, /datum/adventure_event))
				qdel(A)

	paths_to_tread = editable_paths.Copy()
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
		if(ADVENTURE_MODE_BATTLE, ADVENTURE_MODE_EVENT_BATTLE)
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
				DoBattle(roll(virtual_block), TRUE)
			if(2)
				DoBattle(roll(virtual_damage))
			if(3)
				if(prob(info_chance))
					temp_text += "<br>HP:[enemy_integrity]<br>DAMAGE:[enemy_damage]<br>YOUR WELCOME<br>"
					currently_scanned = TRUE
				else
					temp_text += "THE ENEMY TAKES THE CHANCE TO STRIKE<br>"
					DoBattle(0)
			if(4)
				if(prob(run_chance))
					temp_text += "<br>YOU RUN AWAY FROM YOUR OPPONENT<br>[run_healing] DAMAGE HEALED<br>EVENT PROGRESS -5<br>"
					if(prob(run_gold))
						temp_text += "<br>YOU FIND GOLD"
						virtual_coins++
					AdjustHP(run_healing)
					AdjustProgress(-5)
					paths_to_tread.Cut()
					enemy_desc = null
					travel_mode = ADVENTURE_MODE_TRAVEL
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
		enemy_key = null

	/*-----------\
	|Battle Procs|
	\-----------*/
//What happens every time you press a button in battle.
/datum/adventure_layout/proc/DoBattle(hit_num, BLOCKING = FALSE)
	var/enemy_hit = roll(enemy_damage)
	if(BLOCKING)
		var/heal_amount = 0
		enemy_hit -= hit_num
		if(enemy_hit < 0)
			enemy_hit = 0
		if(block_heal && block_heal_counter<max_block_heal)		//we'll give you one extra heal.
			AdjustHP(block_heal)
			block_heal_counter+=block_heal
			heal_amount = block_heal

		temp_text += "YOUR ENEMY DEALS [enemy_hit]. YOU PREVENTED [hit_num] DAMAGE. YOU HEAL [heal_amount] HP"
	else
		temp_text += "YOU SUFFER [enemy_hit] WHILE THE ENEMY SUFFERS [hit_num]."
		enemy_integrity -= hit_num
	AdjustHP(-enemy_hit)

//What happens when you win.
/datum/adventure_layout/proc/BattleWinReward()
	block_heal_counter = 0
	var/increased_stat = rand(1,7)
	temp_text += "OBSTACLE CLEARED<br>[enemy_coin] COINS GAINED<br>EVENT PROGRESS +5<br>STAT:[nameStat(increased_stat)] INCREASED BY 2"
	virtual_coins += enemy_coin
	if(currently_scanned && info_bonus)
		temp_text += "<br>INFORMATION BONUS:[info_bonus] COINS GAINED"
		virtual_coins += info_bonus
	if(enemy_key)
		temp_text += "<br>TROPHY GAINED:[enemy_key]"
		GiveKey(enemy_key)
	enemy_key = null
	currently_scanned = FALSE

	AdjustProgress(10)
	AdjustStats(increased_stat, 2)

	/*-----------------------\
	|Numerical Variable Edits|
	\-----------------------*/
/datum/adventure_layout/proc/ChangeDice(dice)
	if(!istext(dice))
		return FALSE
	virtual_damage = dice
	return dice

/datum/adventure_layout/proc/ChangeBlockDice(dice)
	if(!istext(dice))
		return FALSE
	virtual_block = dice
	return dice

/datum/adventure_layout/proc/AdjustCoins(num)
	virtual_coins += round(num)

/datum/adventure_layout/proc/AdjustHP(num)
	virtual_integrity += round(num)
	virtual_integrity = min(virtual_integrity , max_integrity)

/datum/adventure_layout/proc/AdjustStats(stat_in_question, num)
	virtual_stats[stat_in_question] += num

// This may be too many adjustment procs.
/datum/adventure_layout/proc/AdjustProgress(num)
	program_progress += num

// Easy proc for buying stats. Possibly redundant and should be two seperate procs.
/datum/adventure_layout/proc/BuyStats(cost = 0, value, type)
	if(!value || !type)
		return FALSE
	switch(type)
		//Health
		if("HP")
			if(virtual_integrity >= max_integrity)
				return FALSE
			AdjustHP(value)
		if("MAXHP")
			if(value < max_integrity)
				return FALSE
			max_integrity = value

		//Attack
		if("DICE")
			if(virtual_damage == value)
				return FALSE
			ChangeDice(value)

		//Block
		if("BLOCKDICE")
			if(virtual_block == value)
				return FALSE
			ChangeBlockDice(value)

		if("BLOCKHEAL")
			if(value < block_heal)
				return FALSE
			block_heal = value

		if("BLOCKMAX")
			if(value < max_block_heal)
				return FALSE
			max_block_heal = value

		//Running
		if("RUNCHANCE")
			if(value < run_chance)
				return FALSE
			run_chance = value

		if("RUNHEAL")
			if(value < run_healing)
				return FALSE
			run_healing = value

		if("RUNGOLD")
			if(value < run_gold)
				return FALSE
			run_gold = value

		//Info
		if("INFOCHANCE")
			if(value < info_chance)
				return FALSE
			info_chance = value

		if("INFOBONUS")
			if(value < info_bonus)
				return FALSE
			info_bonus = value

		//Extra
		if("ABNOS")
			if(all_abnos)
				return FALSE
			all_abnos = TRUE
	AdjustCoins(cost)

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
	//Remove spent events
	event_options.Remove(spent_events)
	//The event list except all events we already have are removed.
	var/list/new_events = events - event_options
	for(var/_option in new_events)
		var/datum/adventure_event/A = _option
		//Do not add already spent events.
		if(locate(A) in spent_events)
			continue
		//Lets see if i can make a lock + key event criteria.
		if(FormatNonexistentEventCriteria(initial(A.event_locks)))
			continue
		if(initial(A.require_abno) && !all_abnos)	//Do you require an abno and do you NOT have all abnos?
			if(!locate(initial(A.require_abno)) in GLOB.abnormality_mob_list)
				continue
		event_options += A
		event_options[A] = 10

//This is awful and insane for code. Since i cant get the list from a datum that doesnt exist, i will instead make it a text variable that i will then seperate into a list. -IP
/datum/adventure_layout/proc/FormatNonexistentEventCriteria(lock_chain)
	if(!lock_chain)
		return
	var/list/formatted_lock = splittext(lock_chain, ",")
	LAZYREMOVE(formatted_lock, event_keys)
	//If all of the locks are removed by keys then it will return null.
	return formatted_lock

//Describes details about the path ahead.
/datum/adventure_layout/proc/DescribePath(path_num)
	var/what_path = paths_to_tread[path_num]
	var/path_descs = list()
	if(what_path == ADVENTURE_MODE_BATTLE)
		path_descs = list(
			"THIS PATH IS STREWN WITH BROKEN TREES",
			"YOU SEE SOMETHING APPROACHING",
			"A BROKEN STRING OF YARN LEADS INTO THIS PATH",
			"YOU GET AN OMINOUS FEELING",
			"YOU READY YOUR WEAPON",
			"EYES IN THE DARKNESS",
			"THIS PATH IS DANGER",
			"A SHAPE IN THE FOG",
			"UNSEEN WHISPERS",
			"THE RUSTLING OF BUSHES",
		)
	if(what_path == ADVENTURE_MODE_TRAVEL)
		//When this is more formed i may change these to be the event descriptions.
		path_descs = list(
			"THIS PATH IS SAFE",
			"THIS ROAD IS CLEAR",
			"YOU SEE NOTHING OF NOTE",
			"A SHORT WALK",
			"IT IS COLD HERE.",
			"THIS IS DULL",
			"THE TRAIL SEEMS EMPTY.",
			"NOTHING THERE.",
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
		if(DEBUG_TEXT_DISPLAY)
			return "CHOOSE EVENT"
		if(NORMAL_TEXT_DISPLAY)
			return "MAIN MENU"
		if(ADVENTURE_TEXT_DISPLAY)
			return "ADVENTURE"
		if(EXCHANGE_TEXT_DISPLAY)
			return "COIN SHOP"

/datum/adventure_layout/proc/nameMiniMenu(cat)
	switch(cat)
		if(ATTACK_MINIMENU)
			return "ATTACK"
		if(HEALTH_MINIMENU)
			return "HEALTH"
		if(BLOCK_MINIMENU)
			return "BLOCK"
		if(RUN_MINIMENU)
			return "RUN"
		if(INFO_MINIMENU)
			return "INFO"
		if(EXTRA_MINIMENU)
			return "EXTRA"

/datum/adventure_layout/proc/nameStat(stat_named)
	switch(stat_named)
		if(WRATH_STAT)
			return "WRATH"
		if(LUST_STAT)
			return "LUST"
		if(SLOTH_STAT)
			return "SLOTH"
		if(GLUTT_STAT)
			return "GLUTT"
		if(GLOOM_STAT)
			return "GLOOM"
		if(PRIDE_STAT)
			return "PRIDE"
		if(ENVY_STAT)
			return "ENVY"

//Recover Health based on time. I may scrap this because the thought of mobile game stamina makes me feel sick -IP
/datum/adventure_layout/proc/StatCatchup()
	var/newhealth = 0
	//Your actually missing health and your not currently in battle.
	if(virtual_integrity < max_integrity && travel_mode != ADVENTURE_MODE_BATTLE)
		newhealth = round((world.time - last_logged_time)/(10 SECONDS))
		if(newhealth == 0)
			return
	//To make stat checkup only restore to 50 change the 100's to 50.
	var/hp_overload_check = (virtual_integrity + newhealth)-max_integrity
	if(hp_overload_check > 0)
		//Remove overflow from the health we are adding
		newhealth -= hp_overload_check
	AdjustHP(newhealth)
	last_logged_time = world.time

#undef ATTACK_MINIMENU
#undef HEALTH_MINIMENU
#undef BLOCK_MINIMENU
#undef RUN_MINIMENU
#undef INFO_MINIMENU
#undef EXTRA_MINIMENU
