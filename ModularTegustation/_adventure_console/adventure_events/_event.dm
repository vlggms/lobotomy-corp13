/**
 * Unique events can be the memories of the abnormalities, their victims, or formative encounters.
 * Just a interesting event that may or may not provide or be based on the lore.
 */
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

/**
 * This is where most of the choices and effects will appear.
 * After your condition for the choice is made with "if(cords == 2)" remember to add a return if you do not want the continue button to appear.
 * Since we have link to the profile and the user we can use their stats for checks if we are clever.
 */
/datum/adventure_event/proc/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	. += "[temp_text]"
	if(cords)
		BUTTON_FORMAT(0,"CONTINUE", M)

/**
 * This proc is called by the adventure datum in order to build the UI.
 * Its like a hub where all other general things are called.
 */
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

/**
 * Formating stuff such as UI display that is returned to the calling userface
 * such as the events name, current cords, and flavor text.
 */
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

/**
 * This is inconviently weird/simple? meaning if you want it to be more complext you need to override it.
 * The place where the chance buttons appear would be A on the flavor text list.
 * If it succeeds it would then go to B.
 * If it fails then it would go to C.
 * So when structuring the adventure cords list keep it in mind.
 * Visual example:
 * list(
 *     "Ability Challenge",
 *     "YES WE DID IT",
 *     "Ah, eto... Bleh!",
 * )
 * -IP
 */
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
/datum/adventure_event/proc/AdjustHitPoint(add_num)
	gamer.AdjustHP(add_num)
	if(add_num <= -1)
		temp_text += "[add_num] HP LOST<br>"
	if(add_num >= 1)
		temp_text += "[add_num] HP GAINED<br>"

/datum/adventure_event/proc/AdjustCurrency(add_num)
	gamer.AdjustCoins(add_num)
	if(add_num <= -1)
		temp_text += "[abs(add_num)] COIN[add_num == -1 ? "S" : ""] LOST<br>"
	if(add_num >= 1)
		temp_text += "[add_num] COIN[add_num == 1 ? "S" : ""] GAINED<br>"

/datum/adventure_event/proc/AdjustStatNum(stat_to_add, add_num)
	gamer.AdjustStats(stat_to_add, add_num)
	if(add_num <= -1)
		temp_text += "[add_num] [gamer.nameStat(stat_to_add)] LOST<br>"
	if(add_num >= 1)
		temp_text += "[add_num] [gamer.nameStat(stat_to_add)] GAINED<br>"
