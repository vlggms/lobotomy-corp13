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
	loot = (/obj/item/keycard/stockroom)
	butcher_results = list(/obj/item/food/meat/slab/human = 1, /obj/item/stack/spacecash/c10 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/human_simple = 1)
	mark_once_attacked = TRUE
	return_to_origin = TRUE

/mob/living/simple_animal/hostile/ui_npc/rat_leader/update_player_variables(mob/user)
	. = ..()
	if(!user)
		return

	// Initialize player-specific variables if they don't exist
	if(isnull(scene_manager.get_var(user, "player.mini_quest")))
		scene_manager.set_var(user, "player.mini_quest", FALSE)

	var/has_heart = heart_check(user)
	scene_manager.set_var(user, "player.has_heart", has_heart)

/mob/living/simple_animal/hostile/ui_npc/rat_leader/Initialize()
	. = ..()

	glob_faction = GLOB.nuke_rats_players
	faction = list("neutral")

	// Set up NPC-specific variables
	scene_manager.npc_vars.variables["collected_heart"] = FALSE

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
					"text" = "\[player.mini_quest?About our deal...:I am looking for a breifcase with-...\]",
					"default_scene" = "breifcase_1",
					"transitions" = list(
						list(
							"expression" = "npc.collected_heart",
							"scene" = "heart_late"
						),
						list(
							"expression" = "player.mini_quest",
							"scene" = "breifcase_11"
						),
					),
				)
			),
		),

		//Outpost info
		"outpost_1" = list(
			"text" = "This outpost? It's nothing much but its now the home of the remaining scavengers around here.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outpost_2"
				)
			)
		),

		"outpost_2" = list(
			"text" = "After the... Event. All of us who lived and kept our sanity where able to find this small cavern which is mostly safe.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outpost_3"
				)
			)
		),

		"outpost_3" = list(
			"text" = "So using the scrap we could find around here we built a few huts for homes, and lived here ever since.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outpost_4"
				)
			)
		),

		"outpost_4" = list(
			"text" = "... But hey, we are making improvements! At least we have mattressess now, It was a real pain to find any that are still intact...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"who_1" = list(
			"text" = "I could spare infomation about me, however it isn't anything too special.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "who_2"
				)
			)
		),

		"who_2" = list(
			"text" = "I am Leon, ex-office worker and now busy with managing my fellow scavengers. Making sure that we deal out food equally, who gets to use the sleeper and all of that.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "who_3"
				)
			)
		),

		"who_3" = list(
			"text" = "Man, you learn many things about yourself when put into a place like this...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "who_4"
				)
			)
		),

		"who_4" = list(
			"text" = "Like, never imagined that I would learn how too cook burgers out of rats! haha-ha...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),
		"threats_1" = list(
			"text" = "Threats around here... I can think 3 that you should keep in mind...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "threats_2"
				)
			)
		),

		"threats_2" = list(
			"text" = "For one, if you go northeast of here, you will run into some... Weird mutants. We call them 'mi-go's and they make some horrific screeches, but nothing else luckily.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "threats_3"
				)
			)
		),

		"threats_3" = list(
			"text" = "Then there are the mutated rats up northwest, small and weak yet they can quickly overwhelm you if you don't act careful. Normally I send my hammer wielders to get them.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "threats_4"
				)
			)
		),

		"threats_4" = list(
			"text" = "Lastly... There are most horrific ones, the Joy Mutants... The ones most mutated by the blast...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "threats_5"
				)
			)
		),

		"threats_5" = list(
			"text" = "They wander around, screaming as if they are in constant pain and if you break their mask. You better be ready for a world of pain as they will stop at NOTHING to beat you into a bloody paste.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "threats_6"
				)
			)
		),

		"threats_6" = list(
			"text" = "If only we could get rid of them. We could explore much deeper into the alleyways, but no luck.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"breifcase_1" = list(
			"text" = "Eric.T's name on it? Oh we have it, the better question is why we would give it to you...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_2",
					"var_updates" = list(
						"player.mini_quest" = TRUE
					),
				)
			)
		),

		"breifcase_2" = list(
			"text" = "That lazy rich bastard just abandoned us when the event happend, and now you expect us to help him out so blindly?",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_3"
				)
			)
		),

		"breifcase_3" = list(
			"text" = "How about this? If you prove to us that you are worth trusting, We will give it too you...",
			"actions" = list(
				"..." = list(
					"text" = "Prove?",
					"default_scene" = "breifcase_4"
				)
			)
		),

		"breifcase_4" = list(
			"text" = "You know those Joy Mutants wandering around? They are a real pain to deal with, yet I found they have one weakness...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_5"
				)
			)
		),

		"breifcase_5" = list(
			"text" = "They have a leader that they call 'Grandfather' or something like that. Most importantly, They appear to be connected to him in some way...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_6"
				)
			)
		),

		"breifcase_6" = list(
			"text" = "So this can go like this. If you kill their 'Grandfather', and bring me their heart. Then I will be willing to give you the breifcase...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_7"
				)
			)
		),

		"breifcase_7" = list(
			"text" = "Are the terms understood?",
			"actions" = list(
				"Yes" = list(
					"text" = "Understood.",
					"default_scene" = "breifcase_9"
				),
				"Nope" = list(
					"text" = "Are you sure this is a good idea?",
					"default_scene" = "breifcase_8"
				)
			)
		),

		"breifcase_8" = list(
			"text" = "Let me tell you this, If this get's us closer to those supplies, then it is worth it...",
			"actions" = list(
				"..." = list(
					"text" = "Understood.",
					"default_scene" = "breifcase_9"
				)
			)
		),

		"breifcase_9" = list(
			"text" = "Also, The zone where I assume 'Grandfather' is located has a lot of toxic gases.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_10"
				)
			)
		),

		"breifcase_10" = list(
			"text" = "I have sent out some scouts to make gas masks to traverse, you should be able to find them in the old butcher's restaurant.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_11"
				)
			)
		),

		"breifcase_11" = list(
			"text" = "Oh, one more thing of note. After some careful observations of those clowns, they appear to share some sort of connection with their 'Grandfather'.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_12"
				)
			)
		),

		"breifcase_12" = list(
			"text" = "So, if you wish attempt to hunt down the 'Grandfather', I would recommend killing every single clown before hand. You would not want to be jumped by all of them.",
			"actions" = list(
				"..." = list(
					"text" = "Thanks for the warning.",
					"default_scene" = "breifcase_main"
				)
			)
		),

		"breifcase_main" = list(
			"text" = "Hm... Got any updates on that?",
			"actions" = list(
				"..." = list(
					"text" = "Sorry, nothing new...",
					"default_scene" = "main_screen"
				),

				"got_heart" = list(
					"text" = "Here is 'Grandfather's heart.",
					"visibility_expression" = "player.has_heart",
					"proc_callbacks" = list(CALLBACK(src, PROC_REF(heart_trade))),
					"var_updates" = list(
						"npc.collected_heart" = TRUE
					),
					"default_scene" = "heart_done",
					"transitions" = list(
						list(
							"expression" = "NOT player.has_heart",
							"scene" = "heart_juke"
						)
					)
				),
			)
		),

		"heart_done" = list(
			"text" = "Oh- wow... You were able to actually take them down... Thanks a lot man, feel free to take anything from our stockroom. You should be able to find it north of this location, and on the right side of it you will find the door.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"heart_juke" = list(
			"text" = "Really man? I didn't get a good look at it to make sure it was the real thing, keep it in your hands.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "breifcase_main"
				)
			)
		),

		"heart_late" = list(
			"text" = "Sorry man, someone else has already killed 'Grandfather', so the deal is off.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

	))


/mob/living/simple_animal/hostile/ui_npc/rat_leader/proc/heart_check(mob/user)
	if(!user)
		user = usr

	if(isliving(user))
		var/mob/living/L = user
		var/B = L.is_holding_item_of_type(/obj/item/organ/heart/mutant_heart)
		if(B)
			var/obj/item/organ/heart/mutant_heart/heart = B
			if(heart && istype(heart))
				return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/rat_leader/proc/heart_trade()
	if(scene_manager.npc_vars.variables["collected_heart"])
		return FALSE

	if(isliving(usr))
		var/mob/living/L = usr
		var/B = L.is_holding_item_of_type(/obj/item/organ/heart/mutant_heart)
		if(B)
			var/obj/item/organ/heart/mutant_heart/heart = B
			if(heart && istype(heart))
				qdel(heart)
				new /obj/item/keycard/stockroom (get_turf(L))
				playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
				
				// Award achievement for completing the quest
				if(L.client)
					L.client.give_award(/datum/award/achievement/lc13/city/rat_leader_quest, L)
				
				return TRUE
	return FALSE
