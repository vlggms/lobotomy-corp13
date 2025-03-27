/mob/living/simple_animal/hostile/ui_npc/rat_scout
	name = "guide scavenger"
	desc = "One of the many inhabitants of the backstreets, armed with an odd hammer."
	maxHealth = 250
	health = 250
	typing_interval = 30
	typing_volume = 25
	talking = sound('sound/creatures/lc13/mailman.ogg', repeat = TRUE)
	portrait = "rat_guide.PNG"
	start_scene_id = "intro"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "rat_hammer"
	icon_living = "rat_hammer"
	icon_dead = "rat_hammer_dead"
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 12
	melee_damage_upper = 15
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	rapid_melee = 1
	attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
	attack_verb_continuous = "hammers"
	attack_verb_simple = "hammer"
	emote_delay = 2000
	random_emotes = "quickly looks around them;looks at their rusty watch;pokes the sand with their pipe"
	butcher_results = list(/obj/item/food/meat/slab/human = 1, /obj/item/stack/spacecash/c10 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/human_simple = 1)

/mob/living/simple_animal/hostile/ui_npc/rat_scout/Initialize()
	. = ..()
	glob_faction = GLOB.nuke_rats_players
	faction = list("neutral")
	scene_manager.load_scenes(list(
//Intro to the NPC
	"intro" = list(
		"text" = "“Wait... Another human is here? Completely untouched?! How.. How did you survive for so long?”",
		"actions" = list(
			"outsider" = list(
				"Text" = "“I am from outside this town.”",
				"next_scene" = "greeting1"),
			"question" = list(
				"Text" = "“Untouched? What do you mean?”",
				"next_scene" = "greeting2"),
			"built" = list(
				"Text" = "“I am just built different.”",
				"next_scene" = "greeting3"),
			)
		),
	"greeting1" = list(
		"text" = "“Oh my... People are finally taking notice...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "greeting1_2"),
			)
		),
	"greeting1_2" = list(
		"text" = "“I guess I should try to explain some things around here...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "main_screen"),
			)
		),
	"greeting2" = list(
		"text" = "“How do you not know? This has been happing for such a long tim... Oh, You might be an outsider.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "greeting2_2"),
			)
		),
	"greeting2_2" = list(
		"text" = "“Why the hell would you enter such a place- must be job or something...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "main_screen"),
			)
		),
	"greeting3" = list(
		"text" = "“Man how strong are you?! To endure all of mutants and mutations...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "greeting3_2"),
			)
		),
	"greeting3_2" = list(
		"text" = "“I need to tell the bastion about this... Oh! I should then tell you more about this place.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "main_screen"),
			)
		),
	"main_screen" = list(
		"text" = "“What do you want to know about this place?”",
		"actions" = list(
			"ruin" = list(
				"Text" = "“Why is everything so ruined?”",
				"next_scene" = "ruin_1"),
			"bastion" = list(
				"Text" = "“Where is everyone else?”",
				"next_scene" = "bastion_1"),
			"guide" = list(
				"Text" = "“Why are you out here?”",
				"next_scene" = "guide_1"),
			)
		),
//Ruin info
	"ruin_1" = list(
		"text" = "“... The reason for this hell, it's a painful story...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin_2"),
			)
		),
	"ruin_2" = list(
		"text" = "“Despite however everything looks around here, everything used to be normal only a month ago.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin_3"),
			)
		),
	"ruin_3" = list(
		"text" = "“Yet on one day... I guess there was a battle between the Blade Lineage and another faction.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin_4"),
			)
		),
	"ruin_4" = list(
		"text" = "“Since one of the combatants was able to get their hands on a nuclear weapon from hana...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin_5"),
			)
		),
	"ruin_5" = list(
		"text" = "“Next thing we know, sirens start blaring all over the town... People were screaming and running all buck wild.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin_6"),
			)
		),
	"ruin_6" = list(
		"text" = "“Some folks got lucky and were able to run away far enough, while others...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin_7"),
			)
		),
	"ruin_7" = list(
		"text" = "“Dusted or mutated... What a horrific it was to see them...”",
		"actions" = list(
			"mutated" = list(
				"Text" = "“Mutated?”",
				"next_scene" = "ruin1_1"),
			"stay" = list(
				"Text" = "“Then why are you still here?”",
				"next_scene" = "ruin2_1"),
			)
		),
	"ruin1_1" = list(
		"text" = "“The poor folk who didn't die to the blast...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin1_2"),
			)
		),
	"ruin1_2" = list(
		"text" = "“They are still out here, wandering across these worn streets.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin1_3"),
			)
		),
	"ruin1_3" = list(
		"text" = "“Endlessly screaming, devouring, crying. I doubt I could even call them humans by this point.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "main_screen"),
			)
		),
	"ruin2_1" = list(
		"text" = "“If only we could leave...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin2_2"),
			)
		),
	"ruin2_2" = list(
		"text" = "“Even if we got on your bus, Many of us would be unable to affored to move homes.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "ruin2_3"),
			)
		),
	"ruin2_3" = list(
		"text" = "“People have homes, familys, belongings that they would lose upon moving and they can't go of them...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "main_screen"),
			)
		),
//Bastion info
	"bastion_1" = list(
		"text" = "“Most of the other scavengers around here are probably back at the bastion.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "bastion_2"),
			)
		),
	"bastion_2" = list(
		"text" = "“It is a small hideout, southwest of here. Currently being lead by a fellow named Leon...”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "bastion_3"),
			)
		),
	"bastion_3" = list(
		"text" = "“He should be able to explain more about the small group he made.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "main_screen"),
			)
		),

//Guide info
	"guide_1" = list(
		"text" = "“Why am I here? It's pretty simple reason.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "guide_2"),
			)
		),
	"guide_2" = list(
		"text" = "“My boss Leon needed some lookouts to watch for any mutants that could try to attack the town.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "guide_3"),
			)
		),
	"guide_3" = list(
		"text" = "“I guess we also sometimes find survivors wandering the streets, and we help them to return to our bastion.”",
		"actions" = list(
			"..." = list(
				"Text" = "...",
				"next_scene" = "main_screen"),
			)
		),
	))
