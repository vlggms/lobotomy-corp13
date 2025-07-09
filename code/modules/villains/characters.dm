// Villains of the Night character system

/datum/villains_character
	var/name = "Unknown"
	var/character_id
	var/desc = "A mysterious character."
	var/icon_state
	var/portrait = "UNKNOWN" // Portrait image name for UI display
	var/icon // Icon file to use for the mob
	var/icon_living // Icon state when alive
	var/icon_dead // Icon state when dead
	var/base_pixel_x = 0 // Base pixel offset for sprite positioning
	var/base_pixel_y = 0 // Base pixel offset for sprite positioning

	// Abilities
	var/active_ability_name
	var/active_ability_desc
	var/active_ability_type = VILLAIN_ACTION_TYPELESS
	var/active_ability_cost = VILLAIN_ACTION_MAIN

	var/passive_ability_name
	var/passive_ability_desc

	// Character stats
	var/villain_weight = 1 // Chance to be selected as villain

/datum/villains_character/proc/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	return TRUE

/datum/villains_character/proc/apply_passive_ability(mob/living/user, datum/villains_controller/game)
	return

/datum/villains_character/proc/on_phase_change(phase, mob/living/user, datum/villains_controller/game)
	return

// Queen of Hatred
/datum/villains_character/queen_of_hatred
	name = "Queen of Hatred"
	character_id = VILLAIN_CHAR_QUEENOFHATRED
	desc = "The magical girl who protects others with the power of love!"
	portrait = "hatred_queen"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "hatred"
	icon_living = "hatred"
	icon_dead = "hatred_dead"
	base_pixel_x = -32

	active_ability_name = "Arcana Beats"
	active_ability_desc = "Pick a player. That player will be protected from Direct Eliminations for the night."
	active_ability_type = VILLAIN_ACTION_PROTECTIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Hero of Love!"
	passive_ability_desc = "You are 50% less likely to be chosen as the Villain"

	villain_weight = 0.5

/datum/villains_character/queen_of_hatred/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Apply protection buff
	to_chat(user, span_notice("You protect [target] with your magical powers!"))
	return TRUE

// Forsaken Murderer
/datum/villains_character/forsaken_murder
	name = "Forsaken Murderer"
	character_id = VILLAIN_CHAR_FORSAKENMURDER
	desc = "A paranoid soul trapped by their own violence."
	portrait = "forsaken_murderer"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "forsakenmurdererinert"
	icon_living = "forsakenmurdererinert"
	icon_dead = "forsakenmurdererdead"

	active_ability_name = "Restrained Violence"
	active_ability_desc = "You can only target yourself. The first player who targets you will have their action fail."
	active_ability_type = VILLAIN_ACTION_SUPPRESSIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Paranoid"
	passive_ability_desc = "At the end of the night, you will learn the number of players who have targeted you."

/datum/villains_character/forsaken_murder/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(target != user)
		to_chat(user, span_warning("You can only target yourself with this ability!"))
		return FALSE
	// TODO: Set up action counter
	to_chat(user, span_notice("You prepare to counter the first action against you."))
	return TRUE

// All-Around Cleaner
/datum/villains_character/all_round_cleaner
	name = "All-Around Cleaner"
	character_id = VILLAIN_CHAR_ALLROUNDCLEANER
	desc = "Always eager to help... and take what they need."
	portrait = "cleaner"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "cleaner"
	icon_living = "cleaner"
	icon_dead = "helper_dead"
	base_pixel_x = -16
	base_pixel_y = -16

	active_ability_name = "Room Cleaning"
	active_ability_desc = "Talk and trade with your target for 2 minutes before stealing one random item from their inventory."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Night Cleaner"
	passive_ability_desc = "After the nighttime phase, you will gain one random item out of the list of items that were used tonight."

// Funeral of the Dead Butterflies
/datum/villains_character/funeral_butterflies
	name = "Funeral of the Dead Butterflies"
	character_id = VILLAIN_CHAR_FUNERALBUTTERFLIES
	desc = "Guide of souls, watcher of the departed."
	portrait = "funeral"
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "funeral"
	icon_living = "funeral"
	icon_dead = "funeral_dead"
	base_pixel_x = -16

	active_ability_name = "Guidance"
	active_ability_desc = "You target a player, and you will learn about everyone who has visited them tonight."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Mercy"
	passive_ability_desc = "At the start of the investigation phase, you will learn the amount of people who visited the eliminated player."

// Fairy Gentleman
/datum/villains_character/fairy_gentleman
	name = "Fairy Gentleman"
	character_id = VILLAIN_CHAR_FAIRYGENTLEMAN
	desc = "A charming host who shares his special brew."
	portrait = "fairy_gentleman"
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "fairy_gentleman"
	icon_living = "fairy_gentleman"
	icon_dead = "fairy_gentleman_dead"
	base_pixel_x = -34

	active_ability_name = "Fairy Brew"
	active_ability_desc = "Create a 'Fairy Wine' item. This item allows talk and trade with your main action target."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Outstanding Charisma"
	passive_ability_desc = "When someone uses Fairy Wine, you become alerted and your main action gains the effects of Fairy Wine."

// Puss in Boots
/datum/villains_character/puss_in_boots
	name = "Puss in Boots"
	character_id = VILLAIN_CHAR_PUSSINBOOTS
	desc = "A loyal servant who protects their master."
	portrait = "puss_in_boots"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "cat_contained"
	icon_living = "cat_contained"
	icon_dead = "cat_dead"

	active_ability_name = "Greetings, Master"
	active_ability_desc = "The targeted player gains your blessing, making them immune to direct eliminations until you bless another."
	active_ability_type = VILLAIN_ACTION_PROTECTIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Inheritance"
	passive_ability_desc = "You are able to talk and trade with your blessed players as a Secondary Action."

// Der Freischütz
/datum/villains_character/der_freischutz
	name = "Der Freischütz"
	character_id = VILLAIN_CHAR_DERFREISCHUTZ
	desc = "The marksman with the devil's bullets."
	portrait = "der_freischutz"
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "derfreischutz"
	icon_living = "derfreischutz"
	icon_dead = "derfreischutz_dead"

	active_ability_name = "Magic Bullet"
	active_ability_desc = "Eliminate your target if you have an Elimination Contract. Changes your win condition."
	active_ability_type = VILLAIN_ACTION_ELIMINATION
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Elimination Contract"
	passive_ability_desc = "While trading, you can offer an Elimination Contract to gain the ability to use Magic Bullet."

// Rudolta of the Sleigh
/datum/villains_character/rudolta
	name = "Rudolta of the Sleigh"
	character_id = VILLAIN_CHAR_RUDOLTA
	desc = "The silent watcher who sees all."
	portrait = "rudolta"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "rudolta"
	icon_living = "rudolta"
	icon_dead = "rudolta_dead"
	base_pixel_x = -16

	active_ability_name = "Observe"
	active_ability_desc = "During evening, select a player to physically follow during the night."
	active_ability_type = VILLAIN_ACTION_TYPELESS
	active_ability_cost = VILLAIN_ACTION_FREE

	passive_ability_name = "Watcher"
	passive_ability_desc = "You are unable to speak, but can select a player to Observe each night. You can't observe the same person twice."

// Judgement Bird
/datum/villains_character/judgement_bird
	name = "Judgement Bird"
	character_id = VILLAIN_CHAR_JUDGEMENTBIRD
	desc = "The arbiter who judges actions as innocent or guilty."
	portrait = "judgement_bird"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "judgement_bird"
	icon_living = "judgement_bird"
	icon_dead = "judgement_bird_dead"
	base_pixel_x = -8

	active_ability_name = "Judge"
	active_ability_desc = "Check your target's main action. Investigative/Protective/Typeless = Innocent. Suppressive/Elimination = Guilty."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_SECONDARY

	passive_ability_name = "Blind Eye"
	passive_ability_desc = "You are immune to Investigative and Suppressive items while using Judge."

// Character list for selection
/proc/get_villains_characters()
	var/list/characters = list()
	for(var/path in typesof(/datum/villains_character) - /datum/villains_character)
		var/datum/villains_character/C = new path
		characters[C.character_id] = C
	return characters
