/obj/item/paper/fluff/lost_expedition
	name = "Fixer Contract: Lost Expedition"
	info = "<center><b>Lost Expedition</b></center><br>\
	<br>\
	Recommended Grade: </b>7-5</b> <br>\
	Danger: <b>Low</b> <br>\
	Possible Payment: <b>6800 ahn</b> <br>\
	Payment Type: <b>Savaging</b> <br>\
	Brief Description: <br>\
	Greetings, Fixers of the City. You may call me Joshua, and Explorer of the Outskirts and Ruin. Today, I am sending out this contract to you because I am looking for assistance in exploring specific temple called, 'The Temple of Motus'. It is quite troubling to take care of it by myself.\
	However, the rewards are said to be great and you have the freedom to loot anything you find there. I am just looking for a single artifact there. Also, make sure to speak with me once you get there. So we could venutre down into the temple together.<br>\
	<br>\
	<i>Written by the Joshua</i>"


/mob/living/simple_animal/hostile/ui_npc/elliot
	name = "Joshua"
	desc = "A strange explorer wearing a hood, they appear to be carrying a blade."
	gender = NEUTER
	health = 300
	maxHealth = 300
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	move_resist = MOVE_FORCE_VERY_WEAK // They kept stealing my abnormalities
	pull_force = MOVE_FORCE_VERY_WEAK
	density = FALSE
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	typing_interval = 30
	portrait = "elliot.PNG"
	start_scene_id = "intro"
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "elliot"
	icon_living = "elliot"
	icon_dead = "elliot_down"
	attack_sound = "sound/weapons/fixer/generic/blade2.ogg"
	emote_delay = 4000
	random_emotes = "looks around...;examines their blade carefuly;examines the floor..."
	city_faction = FALSE
	var/ending = FALSE
	var/stunned = FALSE
	var/can_act = TRUE
	var/mob/living/Leader = null // AI variable - tells the slime to follow this person
	var/holding_still = 0
	var/attack_tremor = 3
	var/last_staying_update
	var/staying_cooldown = 20 SECONDS
	var/revive_time = 4 SECONDS
	var/standstorm_stance_update
	var/standstorm_stance_cooldown = 20 SECONDS
	var/teleport_update
	var/teleport_cooldown = 10 SECONDS
	var/guilt = FALSE
	var/entered_boss_room = FALSE
	var/can_attack = TRUE
	var/mutable_appearance/guilt_icon
	var/list/standstorm_stance_lines = list(
		"Sandstorm Stance...",
		"Follow my lead!",
		"To strike them down...",
		"No room for hesitation!",
		"Shatter them...",
	)
	var/list/downed_lines = list(
		"Agh, I lost my balance...",
		"Shoot! Missed that-",
		"Dammit, I got overwhelmed...",
		"Such ferocity...",
		"Ha... Could use a hand here.",
	)
	var/list/rise_lines = list(
		"Back into the fight.",
		"Thank you...",
		"This will not be forgotten.",
		"Alright, Let get back to it.",
		"I rise once more...",
	)
	var/fly_alert = FALSE
	var/rose_alert = FALSE
	var/nest_alert = FALSE
	var/pre_boss_alert = FALSE
	var/obj/item/radio/headset/radio
	var/alert_update = 0
	var/alert_cooldown = 6 MINUTES

	var/puzzle_key = FALSE
	var/puzzle_dagger = FALSE
	var/puzzle_riddle = FALSE
	var/puzzle_heretic = FALSE
	var/turf/emergency_escape

/mob/living/simple_animal/hostile/ui_npc/elliot/Life()
	if(..())
		LosePatience()
		alert_humans()
		PuzzleScan()
		if(!target) // If we have no target, we start following an ally
			speaking_on()
			density = TRUE
			if(Leader)
				if(Leader.z != z)
					Leader = null
					return
				if(!can_see(src, Leader, vision_range))
					if(teleport_update < world.time - teleport_cooldown)
						TeleportToSomeone(Leader)
						teleport_update = world.time
						return
				if(!HAS_TRAIT(src, TRAIT_IMMOBILIZED) && isturf(loc))
					follow_leader()
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 5)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 10)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 15)
		else
			speaking_off()
			density = FALSE

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/PuzzleScan()
	if(!emergency_escape)
		for(var/obj/effect/motus_emergency_escape/escape in range(10, src))
			emergency_escape = get_turf(escape)
			break

	if(!puzzle_key)
		for(var/obj/structure/puzzle_key_case/key in range(3, src))
			puzzle_key = TRUE
			pointed(key)
			addtimer(CALLBACK(src, PROC_REF(key_hint)), 5)
			break

	if(!puzzle_dagger)
		for(var/mob/living/simple_animal/hostile/clan/stone_guard/dagger_puzzle/dagger in range(3, src))
			puzzle_dagger = TRUE
			pointed(dagger)
			addtimer(CALLBACK(src, PROC_REF(dagger_hint)), 5)
			break

	if(!puzzle_riddle)
		for(var/obj/machinery/door/keycard/puzzle_riddles/riddle in range(3, src))
			puzzle_riddle = TRUE
			pointed(riddle)
			addtimer(CALLBACK(src, PROC_REF(riddle_hint)), 5)
			break

	if(!puzzle_heretic)
		for(var/mob/living/simple_animal/hostile/clan/stone_guard/heretic_puzzle/heretic in range(3, src))
			puzzle_heretic = TRUE
			pointed(heretic)
			addtimer(CALLBACK(src, PROC_REF(heretic_hint)), 5)
			break

// Generic hint system to reduce code duplication
/mob/living/simple_animal/hostile/ui_npc/elliot/proc/give_hint(list/messages, list/delays = null)
	if(!delays)
		delays = list(30, 25) // default delays between messages

	for(var/i = 1 to messages.len)
		say(messages[i])
		if(i < messages.len && i <= delays.len)
			SLEEP_CHECK_DEATH(delays[i])

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/key_hint()
	give_hint(list(
		"Hey, these keys look a bit suspicious...",
		"You could pick one up right away, but...",
		"I think it would be wise to test these keys somehow."
	))

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/dagger_hint()
	give_hint(list(
		"Hm... don't these statues look weird?",
		"With different colored hands...",
		"It appears that they want something."
	))

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/riddle_hint()
	give_hint(list(
		"Oh, that door appears to have some sort of voice box.",
		"What if, you try to open this door?"
	), list(30))

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/heretic_hint()
	give_hint(list(
		"What strange statues...",
		"They appear to have some sort of motion detector on them...",
		"What would happen if you would poke them?"
	))

/mob/living/simple_animal/hostile/ui_npc/elliot/toggle_ai(togglestatus)
	if (togglestatus != AI_IDLE)
		..()

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/follow_leader()
	if(Leader)
		step_to(src, Leader)
	if(Leader.stat == DEAD)
		Leader = null

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/TeleportToSomeone(mob/living/teleport_target)
	if(!teleport_target)
		return
	var/turf/origin = get_turf(teleport_target)
	var/list/all_turfs = RANGE_TURFS(2, origin)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		var/available_turf
		var/list/leader_line = getline(T, teleport_target)
		for(var/turf/line_turf in leader_line)
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				available_turf = FALSE
				break
			available_turf = TRUE
		if(!available_turf)
			continue
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(src))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
		forceMove(T)
		new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(src))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
		LoseTarget()
		return

/mob/living/simple_animal/hostile/ui_npc/elliot/AttackingTarget(atom/attacked_target)
	if(!can_act || !can_attack)
		return FALSE
	. = ..()
	if(istype(attacked_target, /mob/living/simple_animal/hostile/mad_fly_swarm) && !fly_alert)
		fly_alert = TRUE
		addtimer(CALLBACK(src, PROC_REF(mad_alert)), 5)
	if(istype(attacked_target, /mob/living/simple_animal/hostile/mad_fly_nest) && !nest_alert)
		nest_alert = TRUE
		addtimer(CALLBACK(src, PROC_REF(mad_nest_alert)), 5)
	if(.)
		var/dir_to_target = get_dir(get_turf(src), get_turf(attacked_target))
		for(var/i = 1 to 2)
			var/turf/T = get_step(get_turf(src), dir_to_target)
			if(T.density)
				return
			if(locate(/obj/structure/window) in T.contents)
				return
			for(var/obj/machinery/door/D in T.contents)
				if(D.density)
					return
			forceMove(T)
			if(isliving(attacked_target))
				var/mob/living/tremor_target = attacked_target
				tremor_target.apply_lc_tremor(attack_tremor, 40)
			SLEEP_CHECK_DEATH(2)
	if(standstorm_stance_update < world.time - standstorm_stance_cooldown)
		say(pick(standstorm_stance_lines))
		StandstormStance()
		standstorm_stance_update = world.time

/mob/living/simple_animal/hostile/ui_npc/elliot/Move()
	if(!can_act || stunned)
		return FALSE
	..()

/mob/living/simple_animal/hostile/ui_npc/elliot/death(gibbed)
	if(ending)
		return ..()
	INVOKE_ASYNC(src, PROC_REF(Downed))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ui_npc/elliot, Unstun)), 10 MINUTES)
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/elliot/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/Downed(say_line = TRUE)
	can_act = FALSE
	status_flags |= GODMODE
	if(say_line)
		say(pick(downed_lines))
	visible_message(span_warning("[src] falls down!"))
	icon_state = "elliot_down"
	density = FALSE
	stunned = TRUE

/mob/living/simple_animal/hostile/ui_npc/elliot/attack_hand(mob/living/carbon/human/M)
	if(!stunned)
		return ..()
	to_chat(M, span_warning("You lifting up [src]!"))
	if(!do_after(M, revive_time, src) || !stunned)
		to_chat(M, span_warning("You let go before [src] gets back up!"))
		return
	Unstun()
	return

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/Unstun(say_line = TRUE)
	if(!stunned)
		return
	density = TRUE
	status_flags &= ~GODMODE
	stunned = FALSE
	icon_state = icon_living
	if(say_line)
		adjustBruteLoss(-maxHealth, forced = TRUE)
		say(pick(rise_lines))
	visible_message(span_warning("[src] gets back up!"))
	can_act = TRUE

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/Unguilt()
	if(guilt)
		cut_overlay(guilt_icon)
		guilt = FALSE
		ending = FALSE

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/StandstormStance()
	playsound(src, 'sound/weapons/purple_tear/change.ogg', 50, 1)
	for(var/mob/living/carbon/human/L in orange(5, get_turf(src)))
		if(L.stat != DEAD)
			L.apply_status_effect(/datum/status_effect/standstorm_stance)
			new /obj/effect/temp_visual/turn_book(get_turf(L))

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/alert_humans()
	if(alert_update < world.time - alert_cooldown)
		for(var/mob/living/carbon/human/L in view(5, get_turf(src)))
			if(L.stat == DEAD && L.mind)
				alert_update = world.time
				radio.talk_into(src, "Looks like [L] is down for the count, requesting the retrieval of them.", null)
				SLEEP_CHECK_DEATH(20)
				radio.talk_into(src, "You can find them in the Temple of Motus, use the bus to get there.", null)
				break

/datum/status_effect/standstorm_stance
	id = "standstorm_stance"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/standstorm_stance
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/standstorm_stance
	name = "Standstorm Stance"
	desc = "You feel the sand move with you, your attacks now inflict 2 Tremor on hit."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "false_kindness"

/datum/status_effect/standstorm_stance/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("You feel the sands move with you!"))
	RegisterSignal(status_holder, COMSIG_MOB_ITEM_ATTACK, PROC_REF(InflictTremor))

/datum/status_effect/standstorm_stance/proc/InflictTremor(datum/source, mob/living/target)
	target.apply_lc_tremor(2, 50)

/datum/status_effect/standstorm_stance/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_red("The sands slow down around you..."))
	UnregisterSignal(status_holder, COMSIG_MOB_ITEM_ATTACK)

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/boss_alert()
	say("We are getting close to the final obstacle...")
	SLEEP_CHECK_DEATH(40)
	say("Hey, With us getting there soon...")
	SLEEP_CHECK_DEATH(25)
	say("Can you speak with me? I think I might know how pass it.")

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/mad_alert()
	say("The Mad Fly Swarm... Looks like they built a nest here.")
	SLEEP_CHECK_DEATH(30)
	say("Don't get overwhelmed by their attacks.")
	SLEEP_CHECK_DEATH(25)
	say("They are trying to make you act irrationally, and make you attack yourself.")

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/mad_nest_alert()
	say("Looks like we found their nest...")
	SLEEP_CHECK_DEATH(30)
	say("Take it down as soon as possible if you don't wish to deal with more swarms.")

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/pre_boss_alert()
	manual_emote("arm twitches...")
	SLEEP_CHECK_DEATH(20)
	whisper("Back here again... They, are gone now...")
	SLEEP_CHECK_DEATH(20)
	whisper("Gone now...")

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/rose_alert()
	say("The Scarlet Rose, Quite a healthy looking one.")
	SLEEP_CHECK_DEATH(40)
	say("Just try to avoid moving too much in it's vines, and find their source.")
	SLEEP_CHECK_DEATH(25)
	say("It's just trying to make you stuggle and bleed yourself out.")

// Generic alert triggering system to reduce code duplication
/mob/living/simple_animal/hostile/ui_npc/elliot/proc/check_and_trigger_alert(condition, alert_var, alert_proc, delay = 5)
	if(condition && !vars[alert_var])
		vars[alert_var] = TRUE
		addtimer(CALLBACK(src, alert_proc), delay)

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/CheckSpace(mob/user, atom/new_location)
	var/turf/newloc_turf = get_turf(new_location)
	var/valid_tile = TRUE

	var/area/new_area = get_area(newloc_turf)
	if(istype(new_area, /area/shuttle/mining))
		valid_tile = FALSE

	// Check for scarlet vines
	for(var/obj/structure/spreading/scarlet_vine/vine in newloc_turf.contents)
		check_and_trigger_alert(TRUE, "rose_alert", PROC_REF(rose_alert))
		break

	// Check for boss room areas
	check_and_trigger_alert(
		istype(new_area, /area/city/backstreets_room/temple_motus/treasure_hallway),
		"entered_boss_room",
		PROC_REF(pre_boss_alert)
	)

	check_and_trigger_alert(
		istype(new_area, /area/city/backstreets_room/temple_motus/treasure_entrance),
		"pre_boss_alert",
		PROC_REF(boss_alert)
	)

	if(!valid_tile)
		if(last_staying_update < world.time - staying_cooldown)
			say("Sorry, But I can't leave back into the city...")
			last_staying_update = world.time
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/mob/living/simple_animal/hostile/ui_npc/elliot/attacked_by(obj/item/I, mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/attacker = user
		if(attacker.a_intent == INTENT_HELP)
			to_chat(attacker, span_nicegreen("You almost attack [src], but you carefuly avoid attacking them."))
			return FALSE
		else

	. = ..()


/mob/living/simple_animal/hostile/ui_npc/elliot/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(CheckSpace))
	guilt_icon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER)
	radio = new /obj/item/radio/headset/silicon/ai(src)

	scene_manager.load_scenes(list(
		//Intro to the NPC
		"intro" = list(
			"text" = "At long last, my contract has been taken...",
			"on_enter" = list(
				"dialog.first_meeting" = TRUE
			),
			"actions" = list(
				"contract?" = list(
					"text" = "I just found a random ticket...",
					"default_scene" = "greeting1-1"
				),
				"contract" = list(
					"text" = "So about the Contract.",
					"default_scene" = "greeting1-2"
				)
			)
		),

		"greeting1-1" = list(
			"text" = "Oh, that is strange. But I guess it still works out.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1-2"
				)
			)
		),

		"greeting1-2" = list(
			"text" = "Right, so allow me to introduce myself. You may call me [src], an Explorer of the outskirts and ruins. Tonight, I am exploring this tarnished temple.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1-3"
				)
			)
		),

		"greeting1-3" = list(
			"text" = "It was called the Temple of Motus, at least in it's prime. It was ran by machines seeking to understand human emotions, 'What it means to truly be human', and so forth.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1-4"
				)
			)
		),

		"greeting1-4" = list(
			"text" = "However, It appears that some horrible event has happend there. With it now resting ruined and abandoned, and ready to be pilfered from.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1-5"
				)
			)
		),

		"greeting1-5" = list(
			"text" = "After all, if the machines that used to work here were able to build all of this. They must surely have a lot of treasurers...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1-6"
				)
			)
		),

		"greeting1-6" = list(
			"text" = "So, you are free to take any treasures or artifacts around here, I am only looking for a specific artifact.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				),
				"question" = list(
					"text" = "How trustworthy is this info?",
					"default_scene" = "greeting1-7"
				)
			)
		),

		"greeting1-7" = list(
			"text" = "What can I say, good scout work truly delivers wonderful results.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1-8"
				)
			)
		),

		"greeting1-8" = list(
			"text" = "No need to worry about my info being incorrect, This not my first rodeo exploring old abandoned ruins.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "greeting1-9"
				)
			)
		),

		"greeting1-9" = list(
			"text" = "*[src] glances at the temple... before placing their arm on their chest...*.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"main_screen" = list(
			"text" = "\[dialog.first_meeting?Well, got anything to ask of me?:Anything else you want to ask about?\]",
			"on_enter" = list(
				"dialog.first_meeting" = FALSE
			),
			"actions" = list(
				"follow" = list(
					"text" = "Follow me, [src].",
					"proc_callbacks" = list(CALLBACK(src, PROC_REF(make_leader))),
					"default_scene" = "following"
				),
				"wait" = list(
					"text" = "Wait here, [src].",
					"proc_callbacks" = list(CALLBACK(src, PROC_REF(remove_leader))),
					"default_scene" = "waiting"
				),
				"guide" = list(
					"text" = "Do you know anything about this area?",
					"default_scene" = "confused",
					"transitions" = list(
						list(
							"expression" = "player.area = \"Outskirts\"",
							"scene" = "outskirts"
						),
						list(
							"expression" = "player.area = \"Temple Reception\"",
							"scene" = "temple_reception"
						),
						list(
							"expression" = "player.area = \"Temple Factory\"",
							"scene" = "temple_factory"
						),
						list(
							"expression" = "player.area = \"Temple Student Dorms\"",
							"scene" = "temple_student_dorms"
						),
						list(
							"expression" = "player.area = \"Temple Study Room A\"",
							"scene" = "temple_study_room_a"
						),
						list(
							"expression" = "player.area = \"Temple Study Room B\"",
							"scene" = "temple_study_room_b"
						),
						list(
							"expression" = "player.area = \"Temple Main Hall\"",
							"scene" = "temple_main_hall"
						),
						list(
							"expression" = "player.area = \"Temple Library\"",
							"scene" = "temple_library"
						),
						list(
							"expression" = "player.area = \"Temple Storage\"",
							"scene" = "temple_storage"
						),
						list(
							"expression" = "player.area = \"Temple Medbay\"",
							"scene" = "temple_medbay"
						)
					)
				),
				"final" = list(
					"text" = "Can you open the final door?",
					"visibility_expression" = "player.area = \"Temple Treasure Entrance\"",
					"default_scene" = "starting_boss"
				),
			)
		),

		"starting_boss" = list(
			"text" = "Yes, I believe I recognize this entrance and the mechanics around it.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "starting_boss1"
				)
			)
		),

		"starting_boss1" = list(
			"text" = "However, if what I belive is true, it could cause a particularly... Difficult defensive system to activate.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "starting_boss2"
				)
			)
		),

		"starting_boss2" = list(
			"text" = "This system, may block of the rest of the temple until we deal with it...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "starting_boss3"
				)
			)
		),

		"starting_boss3" = list(
			"text" = "Do you think you are ready to pass this final challenge?",
			"actions" = list(
				"start_boss" = list(
					"text" = "Yes, I believe we are ready.",
					"proc_callbacks" = list(CALLBACK(src, PROC_REF(start_boss_fight))),
					"default_scene" = "main_screen"
				),
				"wait_boss" = list(
					"text" = "Let's wait a little bit...",
					"default_scene" = "starting_boss_leave"
				)
			)
		),

		"starting_boss_leave" = list(
			"text" = "Understandable... We can't leave anything uninvestigated around here. *clutches their weapon tighter*",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

//Extra Flavor Stuff, Asking about the lore of diffrent rooms.
		"confused" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),
		"outskirts" = list(
			"text" = "Well, We are currently in the outskirts. To be more precise, the inner outskirts.",
			"actions" = list(
				"..." = list(
					"text" = "Inner Outskirts?",
					"default_scene" = "outskirts1"
				)
			)
		),

		"outskirts1" = list(
			"text" = "Oh right, Cityfolk might be as not as wellversed in the terminology used around here...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outskirts2"
				)
			)
		),

		"outskirts2" = list(
			"text" = "You see, the outskirts near the city can be split into 2 major sections. Inner and Outer Outskirts.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outskirts3"
				)
			)
		),

		"outskirts3" = list(
			"text" = "The boundary between those 2 sections is guarded by what I can assume are the City's forces. After all, I heard rummors that they called themselves 'Z-Corp'.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outskirts4"
				)
			)
		),

		"outskirts4" = list(
			"text" = "The inner outskirts hold some simple monsters and non-humans, stuff that just the walls of the City can prevent from getting in forcefully.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outskirts5"
				)
			)
		),

		"outskirts5" = list(
			"text" = "While the outer outskirts... They are a whole different ordeal. They hold the rest of the monsters and non-humans in the world.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outskirts6"
				)
			)
		),

		"outskirts6" = list(
			"text" = "Who knows how they look or act like, but there could even be whole civilizations of non-humans out there... But those are just random theories I have.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "outskirts7"
				)
			)
		),

		"outskirts7" = list(
			"text" = "Anyways, that is my short rundown on our terminology around here.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_reception" = list(
			"text" = "Well, we are currently in the temple's reception halls...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_reception1"
				)
			)
		),

		"temple_reception1" = list(
			"text" = "Probably used to be a calm place, where the students around here could chitchat about their day...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				),
				"question" = list(
					"text" = "Students?",
					"default_scene" = "temple_reception2"
				)
			)
		),

		"temple_reception2" = list(
			"text" = "Yep, what is weird abou- oh right, I forgot to tell you that this place was... Mostly likely structured as a school. ",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_reception3"
				)
			)
		),

		"temple_reception3" = list(
			"text" = "I mean, if they are learning about humanity around here, there are bound to be some experts who can act as 'Teachers' around here...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_reception4"
				)
			)
		),

		"temple_reception4" = list(
			"text" = "Any-yways, I belive we can move on from here.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_factory" = list(
			"text" = "This place appears to be their... Workshop room...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_factory1"
				)
			)
		),

		"temple_factory1" = list(
			"text" = "Even if they tried to abandon their steel bodies and minds, they could not ignore it completely.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_factory2"
				)
			)
		),

		"temple_factory2" = list(
			"text" = "*looks at the machine rubble*, They all have a core, the source of their thoughts and orders.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_factory3"
				)
			)
		),

		"temple_factory3" = list(
			"text" = "While this has some benefits, such as being able to be rebuilt as long as the core is intact. They don't last forever without repairs.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_factory4"
				)
			)
		),

		"temple_factory4" = list(
			"text" = "... And of course, only one of them knows the secret of these repairs.",
			"actions" = list(
				"one" = list(
					"text" = "Only one of them?",
					"default_scene" = "temple_factory5"
				),
				"..." = list(
					"text" = "Do you know these machines?",
					"default_scene" = "temple_factory7"
				)
			)
		),

		"temple_factory5" = list(
			"text" = "O-oh, just my intuition. I mean, all of their cores would be intact if all of them knew it, right.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_factory6"
				)
			)
		),

		"temple_factory6" = list(
			"text" = "*[src] quickly trails off as he starts examining the rest of the room, avoiding looking eye to eye with you.*",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_factory7" = list(
			"text" = "O-oh, not at all. I am just making assumptions based on what I could see. I haven't being that active in the machine side of the outskirts...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_student_dorms" = list(
			"text" = "These appear to be the student dorms around here...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_student_dorms1"
				)
			)
		),

		"temple_student_dorms1" = list(
			"text" = "Now I think about it, don't you think it is weird how these machines have dorms?",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_student_dorms2"
				)
			)
		),

		"temple_student_dorms2" = list(
			"text" = "They have no need to sleep or rest, yet they still partaken in this... 'Act of Sleeping'",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_student_dorms3"
				)
			)
		),

		"temple_student_dorms3" = list(
			"text" = "They must have wasted so much time, just lying around around their dorms, pretending to sleep...",
			"actions" = list(
				"question" = list(
					"text" = "How do you know?",
					"default_scene" = "temple_student_dorms4"
				),
				"..." = list(
					"text" = "Anything to follow the illusion.",
					"default_scene" = "temple_student_dorms5"
				)
			)
		),

		"temple_student_dorms4" = list(
			"text" = "Well, you know... Why else would they have these dorms? Would be a waste of space if they had beds and did not use them.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_student_dorms5" = list(
			"text" = "Yes... Anything to uphold the illusion. Maybe they said something alonge those lines...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_study_room_a" = list(
			"text" = "Hell... They have been growing here, just how much have they been fed...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_study_room_a1"
				)
			)
		),

		"temple_study_room_a1" = list(
			"text" = "Are they, still being fed?",
			"actions" = list(
				"..." = list(
					"text" = "What?",
					"default_scene" = "temple_study_room_a2"
				)
			)
		),

		"temple_study_room_a2" = list(
			"text" = "I mean, do you see these fresh bodies? And I know for sure that information on this location has been a very well kept secret...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_study_room_a3"
				)
			)
		),

		"temple_study_room_a3" = list(
			"text" = "Just... Who would be feding them?",
			"actions" = list(
				"question" = list(
					"text" = "Why would people feed them?",
					"default_scene" = "temple_study_room_a4"
				),
				"how" = list(
					"text" = "How did you learn about the temple?",
					"default_scene" = "temple_study_room_a6"
				)
			)
		),

		"temple_study_room_a4" = list(
			"text" = "Oh, you see, the nests of these pests can be harvested to create mental stabilizers.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_study_room_a5"
				)
			)
		),

		"temple_study_room_a5" = list(
			"text" = "Might be something related to how they are able to control their panicing targets to not attack them...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_study_room_a6" = list(
			"text" = "Well... You can sa-ay, I just happend to wander across it. Yep, I just got lucky with it...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_study_room_a7"
				)
			)
		),

		"temple_study_room_a7" = list(
			"text" = "*straightens his posture and looks at the door*, anyways, it appears that this place doesn't have much else to loot, we can move on...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_study_room_b" = list(
			"text" = "Oh... This place...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_study_room_b1"
				)
			)
		),

		"temple_study_room_b1" = list(
			"text" = "*[src] gazes at surgery tables, with an empty stare*.",
			"actions" = list(
				"..." = list(
					"text" = "[src]?",
					"default_scene" = "temple_study_room_b2"
				)
			)
		),

		"temple_study_room_b2" = list(
			"text" = "Oh, sorry... I don't know much about this place...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_main_hall" = list(
			"text" = "Hm... This appears to be the main hall of sorts. With the altars, this could also serve as a church of sorts.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_main_hall1"
				)
			)
		),

		"temple_main_hall1" = list(
			"text" = "Only makes sense with what is going on around here, if they wish to study or even become 'humans' they will need to have someone act as a preacher.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_main_hall2"
				)
			)
		),

		"temple_main_hall2" = list(
			"text" = "How else will you keep everyone's faith strong as they try to achieve the impossible... What filthy charlatans.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				),
				"belief" = list(
					"text" = "Belief can be used to give hope.",
					"default_scene" = "temple_main_hall3"
				)
			)
		),

		"temple_main_hall3" = list(
			"text" = "You may say that, but if that belief causes them to forgo basic logic. Something feels wrong about that, especially with what it could lead too...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_library" = list(
			"text" = "A great library of the Temple, now mostly worthless for us. Any books of great value must have been burnt away...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_library1"
				)
			)
		),

		"temple_library1" = list(
			"text" = "*[src] pulls out a book from their bag, and compares them to the other books in this library*",
			"actions" = list(
				"look" = list(
					"text" = "*look at the cover of the book*",
					"default_scene" = "temple_library2"
				),
				"question" = list(
					"text" = "What is this book?",
					"default_scene" = "temple_library3"
				)
			)
		),

		"temple_library2" = list(
			"text" = "*You once the cover says ‘The Exploration of Love and Fear, By Elliot’*... Oh, don't worry about this too much.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_library4"
				)
			)
		),

		"temple_library3" = list(
			"text" = "Oh, It's a book I... Found recently while traveling... Just thought that- hm, might be related to this place",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "temple_library4"
				)
			)
		),

		"temple_library4" = list(
			"text" = "*[src] quickly puts away their book...*",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_storage" = list(
			"text" = "Well, This appears to be a simple storage area of this temple. To store their supplies for what ever they were doing in here...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_medbay" = list(
			"text" = "Oh, this appears to be some sort of research or medbay like room. Although if it was a medbay room, it would be quite pointless...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_medbay1" = list(
			"text" = "These appear to be normal chemicals all over this room, and they would be pointless for machines...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_medbay2" = list(
			"text" = "What if they were selling them? But to how would they sell them to...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_medbay3" = list(
			"text" = "Or they were... *sighs*, mayhaps they did... At least they appear to be useful things to loot.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"following" = list(
			"text" = "Sure, I shall follow your lead.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"waiting" = list(
			"text" = "Very well, I shall stand guard here.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

	))

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/make_leader(mob/user)
	if(!user)
		user = usr

	if(isliving(user))
		var/mob/living/L = user
		Leader = L

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/remove_leader()
	Leader = null

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/start_boss_fight()
	Leader = null
	close_all_tgui()
	for(var/obj/effect/motus_final_door/final in range(10, src))
		final.active = TRUE
		var/turf/patrol_turf = get_turf(final)
		patrol_to(patrol_turf)
		break

/obj/effect/motus_emergency_escape
	name = "motus_emergency_escape"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "city_of_cogs"
	alpha = 0
	mouse_opacity = FALSE
	anchored = TRUE
	var/active = FALSE

/obj/effect/motus_final_door
	name = "motus_final_waypoint"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "city_of_cogs"
	alpha = 0
	mouse_opacity = FALSE
	anchored = TRUE
	var/active = FALSE

/obj/effect/motus_final_door/Crossed(atom/movable/AM)
	. = ..()
	if(istype(AM, /mob/living/simple_animal/hostile/ui_npc/elliot) && active)
		var/mob/living/simple_animal/hostile/ui_npc/elliot/elliot_target = AM
		elliot_target.trigger_boss()
		qdel(src)

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/trigger_boss()
	speaking_off()
	playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 40, TRUE)
	SLEEP_CHECK_DEATH(10)
	say("What... It didn't work...")
	SLEEP_CHECK_DEATH(40)
	say("It should work, It worked last time-")
	for(var/obj/effect/keeper_piller_spawn/piller in range(20, src))
		var/turf/spawn_turf = get_turf(piller)
		new /mob/living/simple_animal/npc/tinkerer/elliot_taunt(spawn_turf)

/obj/machinery/door/keycard/final_door
	name = "heavily locked door"
	desc = "This door only opens when a keycard is swiped. It looks virtually indestructable, looks like you will need someone else's help."
	puzzle_id = "motus_treasure"

/obj/item/keycard/motus_treasure
	name = "treasure keycard"
	desc = "A treasure keycard. How fantastic. Looks like it belongs to a high security door."
	color = "#a58806"
	puzzle_id = "motus_treasure"

/mob/living/simple_animal/hostile/ui_npc/elliot/Destroy()
	Leader = null
	QDEL_NULL(radio)
	return ..()

/mob/living/simple_animal/npc/tinkerer/elliot_taunt
	default_delay = 13
	speech = list("Icon: tinker_d", "Icon: tinker", "At long last, we meet again...", "Elliot: Tinkerer... What the hell did you do to this place?!", "Oh? You are wondering what I did to this place?", "My cute little drone, don't you know better then anyone?", "Elliot: No... I moved past it...", "Oh did you? Dear Elliot...", "Elliot: I... discarded that name...", "Yet you still returned to this place...", "Aw, don't tell me... Do you still wish to live after all you have done?", "Elliot: I...", "HA! So much for your regrets over this place...", "Elliot: ... Please, I can't just...", "Ha... I have had enough with your excuses, Dear Elliot.", "Tonight, I shall finish what I have started...", "And ruin the last followers of Motus!", "... And rid you of your guilt, Elliot...", "Icon: tinker_u")
	faction = list("city", "hostile", "neutral")
	var/icon_amount = 0
	var/elliot_change = FALSE
	var/list/fear_affected = list()

/mob/living/simple_animal/npc/tinkerer/elliot_taunt/Life()
	. = ..()
	FearEffect()

/mob/living/simple_animal/npc/tinkerer/elliot_taunt/proc/FearEffect()
	for(var/mob/living/carbon/human/H in ohearers(7, src))
		if(H in fear_affected)
			continue
		if(H.stat == DEAD)
			continue
		fear_affected += H
		var/sanity_damage = H.maxSanity*0.3
		H.apply_status_effect(/datum/status_effect/panicked_lvl_2)
		to_chat(H, span_danger("You are frozen in fear... As you witness something of pure hatred, for humanity."))
		H.adjustSanityLoss(sanity_damage)
		var/stun_time = speech.len
		H.Immobilize((stun_time - 4) * (default_delay + 20), TRUE)

/mob/living/simple_animal/npc/tinkerer/elliot_taunt/Speech()
	for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in range(20, src))
		victim.can_act = FALSE
		victim.speaking_off()
	for (var/S in speech)
		if (findtext(S, "Emote: ") == 1)
			manual_emote(copytext(S, 8, length(S) + 1))
		else if (findtext(S, "Move: ") == 1)
			step(src, text2dir(copytext(S, 7, length(S) + 1)))
		else if (findtext(S, "Icon: ") == 1)
			icon_state = copytext(S, 7, length(S) + 1)
			icon_amount++
		else if (findtext(S, "Delay: ") == 1)
			SLEEP_CHECK_DEATH(text2num(copytext(S, 8, length(S) + 1)))
		else if (findtext(S, "Elliot: ") == 1)
			for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in range(20, src))
				victim.face_atom(src)
				victim.say("[copytext(S, 9, length(S) + 1)]")
			SLEEP_CHECK_DEATH(20)
		else
			say(S)
			if(S == "Oh did you? Dear Elliot...")
				for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in range(20, src))
					victim.name = "Elliot"
			SLEEP_CHECK_DEATH(20)
		if(icon_amount == 3)
			icon_amount = 0
			for(var/obj/effect/keeper_piller_spawn/piller in range(20, src))
				var/turf/spawn_turf = get_turf(piller)
				new /mob/living/simple_animal/hostile/clan/stone_keeper(spawn_turf)
		SLEEP_CHECK_DEATH(default_delay)
	for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in range(20, src))
		victim.can_act = TRUE

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/execute_keeper(mob/living/simple_animal/hostile/clan/stone_keeper/execute_target)
	TeleportToSomeone(execute_target)
	var/list/human_list = list()
	for(var/mob/living/carbon/human/nearby_humans in range(10, src))
		human_list += nearby_humans
	var/list/turf_list = list()
	for(var/turf/open/nearby_turf in view(3, src))
		turf_list += nearby_turf
	shuffle_inplace(turf_list)
	for(var/mob/living/carbon/human/watcher in human_list)
		watcher.forceMove(pick(turf_list))
	can_attack = FALSE
	new /obj/effect/timestop(get_turf(src), 20, 45 SECONDS, list(src))
	say("Historian's Protocol...")
	SLEEP_CHECK_DEATH(30)
	say("Golden Time...")
	SLEEP_CHECK_DEATH(20)
	manual_emote("sighs...")
	SLEEP_CHECK_DEATH(30)
	say("Once more... The tides of battle turn to their favor...")
	SLEEP_CHECK_DEATH(30)
	say("Everyone is fated to fall... As the sanctuary crumbles around me...") //while I use my core to escape this hellscape
	SLEEP_CHECK_DEATH(30)
	say("Last time, I let my fear consume me, abandoning my allies.")
	SLEEP_CHECK_DEATH(40)
	say("Even letting Joshua die in my stead...")
	SLEEP_CHECK_DEATH(30)
	say("... Yet, I shall not run tonight.")
	SLEEP_CHECK_DEATH(30)
	say("Curse this broken core of mine, even if this will end me.")
	SLEEP_CHECK_DEATH(30)
	say("I shall not let another set of humans under my care fall...")
	SLEEP_CHECK_DEATH(50)
	say("Goodbye, my dear companions...")
	SLEEP_CHECK_DEATH(20)
	var/turf/target_turf
	var/turf/T
	var/i
	var/used_dir = get_dir(src, execute_target)
	for(i = 0, i <= 10, i++)
		target_turf = get_step(get_turf(execute_target), used_dir)
		dash(src, target_turf)
		T = get_turf(execute_target)
		new /obj/effect/temp_visual/smash_effect(T)
		if(i <= 8)
			playsound(src, 'sound/weapons/black_silence/shortsword.ogg', 100, 1)
			sleep(1)
		if(i <= 10)
			playsound(src, 'sound/weapons/black_silence/axe.ogg', 100, 1)
			sleep(3)
	SLEEP_CHECK_DEATH(5)
	new /obj/effect/temp_visual/justitia_effect(get_turf(execute_target))
	new /obj/item/keycard/motus_treasure(get_turf(execute_target))
	execute_target.gib()
	playsound(src, 'sound/weapons/black_silence/durandal_strong.ogg', 100, 1)
	SLEEP_CHECK_DEATH(30)
	say("Are you... At peace now?")
	SLEEP_CHECK_DEATH(20)
	say("Joshua?")
	SLEEP_CHECK_DEATH(20)
	gib()

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/dash(turf/target_turf)
	var/list/line_turfs = list(get_turf(src))
	for(var/turf/T in getline(src, target_turf))
		line_turfs += T
	forceMove(target_turf)
	// "Movement" effect
	for(var/i = 1 to line_turfs.len)
		var/turf/T = line_turfs[i]
		if(!istype(T))
			continue
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, src)
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 2 + i*2)
