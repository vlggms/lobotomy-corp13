/mob/living/simple_animal/hostile/ui_npc/shopkeeper
	name = "Marcus"
	desc = "A friendly shopkeeper with an impressive selection of wares."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_brown"  // Placeholder, you would use a proper shopkeeper sprite
	portrait = "the-goat.PNG"
	typing_interval = 50
	start_scene_id = "greeting"
	random_emotes = "adjusts inventory;checks his ledger;polishes an item;smiles warmly;hums a tune"
	bubble = "normal"


/mob/living/simple_animal/hostile/ui_npc/shopkeeper/Initialize()
	. = ..()
	// Set up scenes for this shopkeeper
	scene_manager.load_scenes(get_shop_scenes())

	// Set up NPC-specific variables
	scene_manager.npc_vars.variables["sale_enabled"] = TRUE
	scene_manager.npc_vars.variables["items"] = list(
		"medkit" = list("price" = 50, "description" = "A standard first-aid kit"),
		"multitool" = list("price" = 30, "description" = "A useful electronic device"),
		"oxygen_tank" = list("price" = 25, "description" = "A tank of oxygen for emergencies"),
		"rare_crystal" = list("price" = 150, "description" = "A shimmering crystal of unknown origin")
	)

	// Setting up global variables
	scene_manager.global_vars.variables["station_alert"] = FALSE
	scene_manager.global_vars.variables["time_of_day"] = "day"

/mob/living/simple_animal/hostile/ui_npc/shopkeeper/update_player_variables(mob/user)
	. = ..()
	if(!user?.client)
		return

	// Set player money as an example
	// In a real implementation, you would get this from the player's actual credits/money
	// var/player_money = scene_manager.get_var(user.client, "player.money")
	// if(isnull(player_money))
	// 	scene_manager.set_var(user.client, "player.money", 100)

	// Check if player has a multitool example
	// In a real implementation, you would check the player's actual inventory
	// var/has_multitool = scene_manager.get_var(user.client, "player.inventory.multitool")
	// if(isnull(has_multitool))
	// 	scene_manager.set_var(user.client, "player.inventory.multitool", FALSE)

	// // Setup player reputation if it doesn't exist
	// var/reputation = scene_manager.get_var(user.client, "npc.player_reputation")
	// if(isnull(reputation))
	// 	scene_manager.set_var(user.client, "npc.player_reputation", 0)

/mob/living/simple_animal/hostile/ui_npc/shopkeeper/proc/get_shop_scenes()
	var/list/scenes = list()

	// Greeting scene - handles first visit vs returning customer
	scenes["greeting"] = list(
		"text" = "Welcome {player.name}! \[dialog.is_first_visit?I don't think we've met before. I'm Marcus, and this is my shop.:Good to see you again!\] \[world.station_alert?Stay safe out there, the station's on high alert!:How can I help you today?\]",
		"on_enter" = list(
			"dialog.discussed.greeted" = TRUE
		),
		"actions" = list(
			"browse" = list(
				"text" = "I'd like to see what you have for sale.",
				"default_scene" = "shop_menu"
			),
			"chat" = list(
				"text" = "Let's chat for a bit.",
				"default_scene" = "chitchat"
			),
			"special" = list(
				"text" = "Do you have any rare items?",
				"visibility" = "dialog.visit_count > 2",
				"default_scene" = "rare_items"
			),
			"leave" = list(
				"text" = "I need to go.",
				"var_updates" = list(
					"npc.player_left_politely" = TRUE
				),
				"default_scene" = "goodbye"
			)
		)
	)

	// Shop menu
	scenes["shop_menu"] = list(
		"text" = "Here's what I have for sale today. You currently have {player.money} credits.",
		"actions" = list(
			"buy_medkit" = list(
				"text" = "Buy Medkit (50 credits) - {npc.items.medkit.description}",
				"enabled" = "player.money >= 50 AND npc.sale_enabled",
				"var_updates" = list(
					"player.money" = "{player.money - 50}",
					"player.inventory.medkit" = TRUE,
					"npc.player_reputation" = "{npc.player_reputation + 1}"
				),
				"default_scene" = "purchased_item"
			),
			"buy_multitool" = list(
				"text" = "Buy Multitool (30 credits) - {npc.items.multitool.description}",
				"enabled" = "player.money >= 30 AND npc.sale_enabled AND NOT player.inventory.multitool",
				"visibility" = "NOT player.inventory.multitool",
				"var_updates" = list(
					"player.money" = "{player.money - 30}",
					"player.inventory.multitool" = TRUE,
					"npc.player_reputation" = "{npc.player_reputation + 1}"
				),
				"default_scene" = "purchased_item"
			),
			"buy_oxygen" = list(
				"text" = "Buy Oxygen Tank (25 credits) - {npc.items.oxygen_tank.description}",
				"enabled" = "player.money >= 25 AND npc.sale_enabled",
				"var_updates" = list(
					"player.money" = "{player.money - 25}",
					"player.inventory.oxygen_tank" = TRUE,
					"npc.player_reputation" = "{npc.player_reputation + 1}"
				),
				"default_scene" = "purchased_item"
			),
			"back" = list(
				"text" = "Actually, let me think about it.",
				"default_scene" = "greeting"
			)
		)
	)

	// Purchase confirmation
	scenes["purchased_item"] = list(
		"text" = "Thank you for your purchase! Is there anything else you need?",
		"actions" = list(
			"more" = list(
				"text" = "I'd like to see what else you have.",
				"default_scene" = "shop_menu"
			),
			"done" = list(
				"text" = "That's all for now, thanks.",
				"default_scene" = "goodbye"
			)
		)
	)

	// Chitchat options
	scenes["chitchat"] = list(
		"text" = "What would you like to talk about?",
		"actions" = list(
			"about_shop" = list(
				"text" = "Tell me about your shop.",
				"var_updates" = list(
					"dialog.discussed.shop_history" = TRUE
				),
				"default_scene" = "about_shop"
			),
			"about_station" = list(
				"text" = "How's business on the station?",
				"default_scene" = "about_station"
			),
			"special_discount" = list(
				"text" = "Any chance for a discount?",
				"visibility" = "npc.player_reputation >= 3",
				"var_updates" = list(
					"npc.items.medkit.price" = 40,
					"dialog.discussed.discount" = TRUE
				),
				"default_scene" = "special_discount"
			),
			"back" = list(
				"text" = "Actually, let's talk about something else.",
				"default_scene" = "greeting"
			)
		)
	)

	// About shop scene
	scenes["about_shop"] = list(
		"text" = "I've been running this shop for nearly 15 years now. Started as a small trading post, but I've built up quite the inventory since then. \[dialog.discussed.discount?And for loyal customers like yourself, I'm always willing to negotiate prices.:I pride myself on fair prices and quality merchandise.\]",
		"actions" = list(
			"continue" = list(
				"text" = "Interesting. Let me ask about something else.",
				"default_scene" = "chitchat"
			),
			"shop" = list(
				"text" = "I'd like to see your inventory now.",
				"default_scene" = "shop_menu"
			)
		)
	)

	// About station scene
	scenes["about_station"] = list(
		"text" = "\[world.station_alert?Business is always strange during an alert. People rush to buy supplies, but then traffic drops to nothing. Stay safe out there.:Business has been steady. This station has its fair share of incidents, but we get by. The crew here is resourceful.\]",
		"actions" = list(
			"continue" = list(
				"text" = "Let me ask about something else.",
				"default_scene" = "chitchat"
			),
			"shop" = list(
				"text" = "I'd like to see your inventory now.",
				"default_scene" = "shop_menu"
			)
		)
	)

	// Special discount scene
	scenes["special_discount"] = list(
		"text" = "For a valued customer like yourself? I suppose I could offer a small discount on some items. I've adjusted a few prices for you.",
		"actions" = list(
			"thanks" = list(
				"text" = "Thanks! Let me see what you have.",
				"default_scene" = "shop_menu"
			),
			"continue" = list(
				"text" = "I appreciate it. Let me ask about something else first.",
				"default_scene" = "chitchat"
			)
		)
	)

	// Rare items scene
	scenes["rare_items"] = list(
		"text" = "Well... I don't normally show these to everyone, but I do have a few special items in stock. \[npc.player_reputation >= 5?For you, I'll offer my best price.:They're quite expensive, though.\]",
		"actions" = list(
			"buy_crystal" = list(
				"text" = "Buy Rare Crystal (\[npc.player_reputation >= 5?120:150\] credits) - {npc.items.rare_crystal.description}",
				"enabled" = "player.money >= \[npc.player_reputation >= 5?120:150\] AND npc.sale_enabled",
				"var_updates" = list(
					"player.money" = "{player.money - \[npc.player_reputation >= 5?120:150\]}",
					"player.inventory.rare_crystal" = TRUE,
					"npc.player_reputation" = "{npc.player_reputation + 2}"
				),
				"default_scene" = "purchased_rare"
			),
			"not_interested" = list(
				"text" = "That's a bit too expensive for me.",
				"default_scene" = "shop_menu"
			)
		)
	)

	// Purchased rare item
	scenes["purchased_rare"] = list(
		"text" = "An excellent choice! These crystals are quite rare. Some say they have unusual properties, though I've never witnessed anything myself.",
		"actions" = list(
			"inquire" = list(
				"text" = "What kind of properties?",
				"default_scene" = "crystal_info"
			),
			"thanks" = list(
				"text" = "Thanks, I'll keep that in mind.",
				"default_scene" = "goodbye"
			)
		)
	)

	// Crystal info scene
	scenes["crystal_info"] = list(
		"text" = "Well, it's mostly rumors. Some engineers claim they can amplify power systems. Others say they resonate with certain quantum fields. Could all be nonsense to justify the price, of course.",
		"actions" = list(
			"interesting" = list(
				"text" = "That's fascinating. I should experiment with it.",
				"default_scene" = "goodbye"
			),
			"skeptical" = list(
				"text" = "Sounds like marketing to me.",
				"default_scene" = "goodbye"
			)
		)
	)

	// Goodbye scene
	scenes["goodbye"] = list(
		"text" = "\[dialog.visit_count <= 1?It was nice meeting you! Come back soon.:Always good to see you. Stop by again!\] \[npc.player_reputation >= 3?You're one of my favorite customers, you know.:\]",
		"actions" = list(
			"leave" = list(
				"text" = "Goodbye.",
				"default_scene" = "greeting"
			)
		)
	)

	return scenes
