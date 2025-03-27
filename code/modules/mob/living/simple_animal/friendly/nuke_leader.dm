/mob/living/simple_animal/hostile/ui_npc/rat_leader
	name = "leader scavenger"
	desc = "One of the many inhabitants of the backstreets, armed with an odd knife."
	maxHealth = 500
	health = 500
	typing_interval = 30
	typing_volume = 25
	talking = sound('sound/creatures/lc13/mailman.ogg', repeat = TRUE)
	portrait = "rat_leader.PNG"
	start_scene_id = "intro"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "rat_knife"
	icon_living = "rat_knife"
	icon_dead = "rat_knife_dead"
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 12
	melee_damage_upper = 13
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	rapid_melee = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	emote_delay = 2000
	random_emotes = "quickly looks at some files;looks at their rusty watch;mumbles something under their breath"
	loot = (/obj/item/keycard/stockroom = 1)
	butcher_results = list(/obj/item/food/meat/slab/human = 1, /obj/item/stack/spacecash/c10 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/human_simple = 1)

/mob/living/simple_animal/hostile/ui_npc/rat_leader/Initialize()
	. = ..()

	glob_faction = GLOB.nuke_rats_players
	faction = list("neutral")

	// Set up NPC-specific variables
	scene_manager.npc_vars.variables["knows_about_bastion"] = FALSE
	scene_manager.npc_vars.variables["has_explained_mutation"] = FALSE

	// Load scenes with enhanced features
	scene_manager.load_scenes(list(
		//Intro to the NPC
		"intro" = list(
			"text" = "... Who are you? Another lost scavenger in this hellscape?",
			"on_enter" = list(
				"dialog.first_meeting" = TRUE
			),
			"actions" = list(
				"outsider" = list(
					"text" = "Nope! I am from outside this place!",
					"default_scene" = "greeting1"
				),
				"question" = list(
					"text" = "Well, I am {player.name}, Who are you?",
					"default_scene" = "greeting2"
				),
				"built" = list(
					"text" = "I'm not lost... No way!",
					"default_scene" = "greeting3"
				)
			)
		),

		"greeting1" = list(
			"text" = "Then what in the world are you doing here?! Why would any reasonable person willing arrive here-",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1_2"
				)
			)
		),

		"greeting1_2" = list(
			"text" = "Oh, let me take a guess- job of some sort?",
			"actions" = list(
				"..." = list(
					"text" = "Yep, I got hired by Eric.T to find their suitcase.",
					"default_scene" = "greeting1_3"
				),
				"..." = list(
					"text" = "Nope, Just got on a bus and happend to drive over here!",
					"default_scene" = "greeting1_4"
				)
			)
		),

		"greeting1_3" = list(
			"text" = "Yeeep... Of course it would be for some sort of suitcase... rich bastards...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),


		"greeting1_4" = list(
			"text" = "Man, the city grows more crazy day by day...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"greeting2" = list(
			"text" = "Well, I guess I can introduce myself. At least you are not breaking down my doors unlike the last guys.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting2_2"
				)
			)
		),

		"greeting2_2" = list(
			"text" = "I am Leon and I kind of the de facto leader around this place. No one else was willing to do anything so I had to do something.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"greeting3" = list(
			"text" = "... Sure kid, you are definitely not lost around here.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting3_2"
				)
			)
		),

		"greeting3_2" = list(
			"text" = "Especially wearing such fancy outfits- definitely built to live around here.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"main_screen" = list(
			"text" = "\[dialog.first_meeting?Well, You seem friendly enough. Is there anything you would like to know?:Welcome back, got anything to ask?\]",
			"on_enter" = list(
				"dialog.first_meeting" = FALSE
			),
			"actions" = list(
				"outpost" = list(
					"text" = "What is this outpost?",
					"default_scene" = "outpost_1"
				),
				"who" = list(
					"text" = "Who are you?",
					"default_scene" = "who_1"
				),
				"threats" = list(
					"text" = "Any threats out here?",
					"default_scene" = "threats_1"
				),
				"breifcase" = list(
					"text" = "I am looking for a breifcase...",
					"default_scene" = "breifcase_1"
				),
			)
		),

		//Outpost info
		"outpost_1" = list(
			"text" = "... The reason for this hell, it's a painful story...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outpost_2"
				)
			)
		),
	))
