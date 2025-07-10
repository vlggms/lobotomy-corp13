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
	desc = "A magical girl who believes in protecting everyone with love and justice. As Queen of Hatred, you excel at keeping others safe from elimination attempts. Your protective magic shields one player each night from any direct elimination, making you a valuable ally. However, your pure heart makes you less likely to be chosen as the villain, which can be both a blessing and a curse. Best suited for players who enjoy supporting others and building trust networks."
	portrait = "hatred_queen"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "hatred"
	icon_living = "hatred"
	icon_dead = "hatred_dead"

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
	desc = "A tortured soul consumed by paranoia and violence. The Forsaken Murderer turns defense into offense - by targeting yourself with Restrained Violence, you create a trap that causes the first action against you to fail completely. Your paranoia grants you valuable information, revealing how many players targeted you each night. This makes you excellent at baiting the villain or other threats. Perfect for players who enjoy mind games and defensive strategies."
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
	desc = "A cheerful helper with sticky fingers and opportunistic tendencies. The All-Around Cleaner uses their Room Cleaning service as cover to steal items. You can talk and trade with your target for 2 minutes, then automatically steal one random item from them. Your Night Cleaner ability ensures you always have items to work with by granting you a random used item after each night. Ideal for players who enjoy resource manipulation and social deception."
	portrait = "cleaner"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "cleaner"
	icon_living = "cleaner"
	icon_dead = "helper_dead"
	base_pixel_x = -8

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
	desc = "A solemn guide who watches over the movements of the living and the dead. Funeral of the Dead Butterflies excels at tracking player movements - your Guidance ability reveals everyone who visited your target during the night. When someone is eliminated, your Mercy ability tells you how many players visited them, providing crucial clues about the killer. Perfect for investigators who want to map out player interactions and solve the mystery through deduction."
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
	desc = "An elegant gentleman who uses his enchanted wine to facilitate social encounters. The Fairy Gentleman creates Fairy Wine items that enable talk/trade with targets, but with a twist - you're alerted whenever someone uses your wine, and your own main action gains the wine's effects automatically. This creates a network of information and control. Best for players who enjoy creating alliances and monitoring social interactions."
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
	desc = "A devoted feline guardian who bestows powerful blessings. Puss in Boots can permanently protect one player from direct eliminations with Greetings, Master - but only one at a time. Blessing a new player removes protection from the previous one. Your Inheritance ability lets you talk/trade with blessed players as a secondary action, creating a private communication network. Excellent for players who want to form strong alliances and coordinate protection strategies."
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
	desc = "A legendary marksman who made a deal with dark forces. Der Freischütz is unique - you can only eliminate players after making an Elimination Contract during trading. This changes your win condition but gives you the deadly Magic Bullet ability. You must carefully negotiate contracts and choose your target wisely. Perfect for players who enjoy high-risk, high-reward gameplay and complex negotiations."
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
	desc = "A mysterious reindeer who observes without speaking. Rudolta cannot talk but possesses the unique Observe ability - during evening, you select a player and physically follow them throughout the night, seeing everything they do. You cannot observe the same person twice, so choose wisely. Your silence may seem like a weakness, but your unmatched surveillance makes you the ultimate information gatherer. Best for players who prefer action over words."
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
	desc = "A divine arbiter who passes judgment on the actions of others. Judgement Bird's Judge ability reveals whether your target's action is Innocent (Investigative/Protective/Typeless) or Guilty (Suppressive/Elimination), helping identify threats. This costs only a secondary action, leaving your main action free. Your Blind Eye passive makes you immune to investigation and suppression while judging. Ideal for players who want to identify the villain through their actions."
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

// Shrimp Association Executive
/datum/villains_character/shrimp_executive
	name = "Shrimp Association Executive"
	character_id = VILLAIN_CHAR_SHRIMPEXEC
	desc = "A business-savvy crustacean executive with powerful connections. The Shrimp Executive's Corporate Connections reveals both your target's inventory and who they visited last night, providing comprehensive intelligence. Your Impatient Executive passive rewards isolation - if no one visits you during the night, you learn the identity of a random item user. This creates an interesting dynamic where being avoided grants you valuable information. Perfect for information brokers and strategic planners."
	portrait = "shrimp_executive"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "executive"
	icon_living = "executive"
	icon_dead = "wellcheers_dead"

	active_ability_name = "Corporate Connections"
	active_ability_desc = "Learn what items your target is carrying and who they visited last night."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Impatient Executive"
	passive_ability_desc = "If no one visits you during a night phase, you learn the identity of one random player who used an item."

/datum/villains_character/shrimp_executive/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Reveal target's inventory and last night's visit
	to_chat(user, span_notice("You use your corporate connections to investigate [target]."))
	return TRUE

// Sunset Traveller
/datum/villains_character/sunset_traveller
	name = "Sunset Traveller"
	character_id = VILLAIN_CHAR_SUNSETTRAVELLER
	desc = "A serene traveler accompanied by mystical butterflies. The Sunset Traveller's butterflies follow your target and report back on everyone who visits them, making you excellent at identifying popular players or potential victims. Your Restful Presence grants immunity to suppression for anyone who talks/trades with you that night, making you a valuable ally. Best for players who want to build trust networks while gathering visitor information."
	portrait = "sunset_traveller"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sunset"
	icon_living = "sunset"
	icon_dead = "sunset"

	active_ability_name = "Butterfly Guide"
	active_ability_desc = "Your butterflies follow the target - learn all players who visit your target tonight."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Restful Presence"
	passive_ability_desc = "Players who talk/trade with you cannot be targeted by Suppressive actions for the rest of that night."

/datum/villains_character/sunset_traveller/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Track all visitors to target
	to_chat(user, span_notice("Your butterflies follow [target] to observe their visitors."))
	return TRUE

// Fairy-Long-Legs
/datum/villains_character/fairy_longlegs
	name = "Fairy-Long-Legs"
	character_id = VILLAIN_CHAR_FAIRYLONGLEGS
	desc = "A deceptive fairy who lures victims under their umbrella. Fairy-Long-Legs excels at disruption - your Deceptive Invitation forces your target to redirect their main action to you instead of their intended target. When someone is redirected to you, False Shelter activates, stealing a random item from them. This creates a powerful trap that disrupts plans while gaining resources. Ideal for players who enjoy controlling the flow of the game and creating chaos."
	portrait = "fairy_long_legs"
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "fairy_longlegs"
	icon_living = "fairy_longlegs"
	icon_dead = "fairy_longlegs_dead"
	base_pixel_x = -16

	active_ability_name = "Deceptive Invitation"
	active_ability_desc = "Force your target to target you instead of their intended target (redirect their main action to you)."
	active_ability_type = VILLAIN_ACTION_SUPPRESSIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "False Shelter"
	passive_ability_desc = "When someone is redirected to you, steal a random item from their inventory."

/datum/villains_character/fairy_longlegs/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Redirect target's action to user
	to_chat(user, span_notice("You invite [target] to take shelter under your umbrella..."))
	return TRUE

// Red Blooded American
/datum/villains_character/red_blooded_american
	name = "Red Blooded American"
	character_id = VILLAIN_CHAR_REDBLOODEDAMERICAN
	desc = "A patriotic demon who draws all attention to themselves. The Red Blooded American's Patriotic Fervor is a unique protective ability - it forces everyone targeting your protected player to target you instead. This can save allies but puts you at great risk. Your Military Instincts reveal the total number of suppressive and elimination actions used each night, helping track dangerous players. Best for brave players who want to be the center of attention while gathering crucial statistics."
	portrait = "red_blooded_american"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "american_idle"
	icon_living = "american_idle"
	icon_dead = "american_idle"

	active_ability_name = "Patriotic Fervor"
	active_ability_desc = "Forces the everyone who targeted your target to target yourself."
	active_ability_type = VILLAIN_ACTION_PROTECTIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Military Instincts"
	passive_ability_desc = "During the investigation phase, you learn the amount of suppressive and elimination actions used last nighttime phase."

/datum/villains_character/red_blooded_american/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Force target to reveal action type
	to_chat(user, span_notice("Your patriotic fervor makes you the center of attention!"))
	return TRUE

// Kikimora
/datum/villains_character/kikimora
	name = "Kikimora"
	character_id = VILLAIN_CHAR_KIKIMORA
	desc = "A mystical creature who curses others with corrupted speech. Kikimora's Cursed Words prevents your target from speaking normally - they can only say 'kiki' or 'mora' for the rest of the night. Your Contagious Curse spreads this affliction to anyone who hears the cursed player speak, potentially silencing multiple players. All curses lift at dawn. Perfect for players who want to disrupt communication and create confusion during crucial night discussions."
	portrait = "kikimora"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "kikimora"
	icon_living = "kikimora"
	icon_dead = "kikimora"

	active_ability_name = "Cursed Words"
	active_ability_desc = "Target cannot speak for the rest of the nighttime phase (they can only say 'kiki' or 'mora')."
	active_ability_type = VILLAIN_ACTION_SUPPRESSIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Contagious Curse"
	passive_ability_desc = "Anyone who hears someone cursed by your 'Cursed Words' action, they will also become cursed. All curses are removed at the start of the morning/investigation phase."

/datum/villains_character/kikimora/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Apply speech curse
	to_chat(user, span_notice("You curse [target] with corrupted words!"))
	return TRUE

// Little Red Riding Hooded Mercenary
/datum/villains_character/red_hood
	name = "Little Red Riding Hooded Mercenary"
	character_id = VILLAIN_CHAR_REDHOOD
	desc = "A relentless hunter in tattered red robes who tracks dangerous prey. Little Red Riding Hooded Mercenary's Hunter's Mark monitors your target - if they use any Elimination or Suppressive action that night, you're immediately notified. Your Mercenary's Fee ensures payment for your services - after using Hunter's Mark, you automatically steal a random item from another player the next morning. Excellent for players who want to identify aggressive players and build an item collection through hunting."
	portrait = "little_red"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "red_hood"
	icon_living = "red_hood"
	icon_dead = "red_hood"
	base_pixel_x = -8

	active_ability_name = "Hunter's Mark"
	active_ability_desc = "Mark your target. If they use an Elimination or Suppressive action tonight, you'll be notified."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Mercenary's Fee"
	passive_ability_desc = "If you have used 'Hunter's Mark', next morning phase you will steal a random item from another player."

/datum/villains_character/red_hood/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Mark target for tracking
	to_chat(user, span_notice("You mark [target] as your prey, watching for aggressive movements."))
	return TRUE

// The Warden
/datum/villains_character/warden
	name = "The Warden"
	character_id = VILLAIN_CHAR_WARDEN
	desc = "A grotesque keeper who hoards both souls and possessions. The Warden's Soul Gather is devastatingly powerful - if your target uses any items, you cancel ALL their item-based actions and steal those items. Your Protective Custody passive lets you hold 5 items instead of the normal limit, making you a walking arsenal. This character dominates item-based strategies and can completely shut down item-dependent players. Perfect for those who want to control the game's resources."
	portrait = "warden"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "warden"
	icon_living = "warden"
	icon_dead = "warden_dead"
	base_pixel_x = -8

	active_ability_name = "Soul Gather"
	active_ability_desc = "If the target is using items, cancel all of their actions that used items and steal their items."
	active_ability_type = VILLAIN_ACTION_SUPPRESSIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Protective Custody"
	passive_ability_desc = "You are able to hold 5 items."

/datum/villains_character/warden/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Track visitors
	to_chat(user, span_notice("You begin gathering [target]'s soul, gathering all that is connected to it."))
	return TRUE

// Blue Smocked Shepherd
/datum/villains_character/blue_shepherd
	name = "Blue Smocked Shepherd"
	character_id = VILLAIN_CHAR_BLUESHEPHERD
	desc = "A deceptive shepherd who mixes truth with lies. Blue Smocked Shepherd has a unique relationship with information - your False Prophet ability (targeting only yourself) reveals the villain's action, but has a 20% chance of showing a random player's action instead. You won't know which is which. Your Shepherd's Lies passive adds false information to your morning reports, further muddying the waters. Best for players who excel at reading between the lines and separating truth from fiction."
	portrait = "blue_shepherd"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "blueshep"
	icon_living = "blueshep"
	icon_dead = "blueshep_dead"
	base_pixel_x = -8

	active_ability_name = "False Prophet"
	active_ability_desc = "You can only target yourself, learn the action of the villain. There is a 20% chance of learning the action of another player."
	active_ability_type = VILLAIN_ACTION_INVESTIGATIVE
	active_ability_cost = VILLAIN_ACTION_MAIN

	passive_ability_name = "Shepherd's Lies"
	passive_ability_desc = "During morning phase, you see one random false piece of information (you won't know it's false)."

/datum/villains_character/blue_shepherd/perform_active_ability(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!target)
		return FALSE
	// TODO: Force vote reveal
	to_chat(user, span_notice("You learn the actions of the villain..."))
	return TRUE

// Character list for selection
/proc/get_villains_characters()
	var/list/characters = list()
	for(var/path in typesof(/datum/villains_character) - /datum/villains_character)
		var/datum/villains_character/C = new path
		characters[C.character_id] = C
	return characters
