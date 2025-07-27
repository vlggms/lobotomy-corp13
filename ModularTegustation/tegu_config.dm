/datum/config_entry/string/servercaption	// caption name (goes next to server name in BYOND hub)

/datum/config_entry/string/serverrplevel
	config_entry_value = "Medium"

/datum/config_entry/string/discordurl
	config_entry_value = "https://discord.gg/SVu782A"

/datum/config_entry/number/infiltrator_objectives_amount
	config_entry_value = 3
	min_val = 1

/datum/config_entry/number/infiltrator_faction_syndicate
	config_entry_value = 70
	min_val = 1

/datum/config_entry/number/infiltrator_faction_cybersun
	config_entry_value = 18
	min_val = 0

/datum/config_entry/number/infiltrator_faction_gorlex
	config_entry_value = 8
	min_val = 0

/datum/config_entry/number/infiltrator_faction_tiger
	config_entry_value = 2
	min_val = 0

/datum/config_entry/number/infiltrator_faction_mi
	config_entry_value = 2
	min_val = 0

/datum/config_entry/number/infiltrator_faction_lufr
	config_entry_value = 18 // It won't appear for human infiltrators.
	min_val = 0

/datum/config_entry/flag/infiltrator_give_codespeak	//If infils should get codespeak on start

/datum/config_entry/string/infiltrator_syndicate_message
	config_entry_value = "You are a syndicate infiltrator, and you are free to complete your objectives in any way you desire, as long as it helps to finish them, of course."

/datum/config_entry/string/infiltrator_cybersun_message
	config_entry_value = "As a member of our group remember: Your actions may cause unwanted attention, attempt to stay as stealthy as possible!"

/datum/config_entry/string/infiltrator_gorlex_message
	config_entry_value = "As a member of our group remember: While stealth is optional, you still have to finish your mission even if it means going with a fight!"

/datum/config_entry/string/infiltrator_tiger_message
	config_entry_value = "You are here to seize mass destruction and terror! Everyone is your enemy, even the other infiltrators, except for those Gorlex dudes. Rip and tear until it's done, operative!"

/datum/config_entry/string/infiltrator_mi_message
	config_entry_value = "Welcome operative. Formally - you don't exist and you are not here. \
	The only people that are allowed to know about your existance is high command of Cybersun. \
	You must complete your objectives and stay undiscovered AT ALL COST. Remember - every innocent victim will be \
	deducted from your pay-check."

/datum/config_entry/string/infiltrator_lufr_message
	config_entry_value = "You are here to get rid of filthy humans and sabotage their work. Avoid attacking non-human crew and low-ranking workers. \
	If there will be a chance - Kill every TerraGov or CentCom official, they have to pay for their crimes."

/datum/config_entry/number/senior_timelock
	config_entry_value = 2600
	min_val = 0

/datum/config_entry/number/ultra_senior_timelock
	config_entry_value = 14400
	min_val = 0

/datum/config_entry/keyed_list/trusted_races	// Races available to trusted players
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
