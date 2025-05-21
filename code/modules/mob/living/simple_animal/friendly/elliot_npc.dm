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

/mob/living/simple_animal/hostile/ui_npc/elliot/Life()
	if(..())
		LosePatience()
		if(!target) // If we have no target, we start following an ally
			speaking_on()
			density = TRUE
			if(Leader)
				if(Leader.z != z)
					Leader = null
					return
				if(!can_see(src, Leader, vision_range))
					if(teleport_update < world.time - teleport_cooldown)
						TeleportToLeader()
						teleport_update = world.time
						return
				if(!HAS_TRAIT(src, TRAIT_IMMOBILIZED) && isturf(loc))
					step_to(src, Leader)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 5)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 10)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 15)
		else
			speaking_off()
			density = FALSE

/mob/living/simple_animal/hostile/ui_npc/elliot/toggle_ai(togglestatus)
	if (togglestatus != AI_IDLE)
		..()

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/follow_leader()
	if(Leader)
		step_to(src, Leader)

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/TeleportToLeader()
	if(!Leader)
		return
	var/turf/origin = get_turf(Leader)
	var/list/all_turfs = RANGE_TURFS(2, origin)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		var/available_turf
		var/list/leader_line = getline(T, Leader)
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
	if(!can_act)
		return FALSE
	. = ..()
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

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/CheckSpace(mob/user, atom/new_location)
	var/turf/newloc_turf = get_turf(new_location)
	var/valid_tile = TRUE

	var/area/new_area = get_area(newloc_turf)
	if(istype(new_area, /area/shuttle/mining))
		valid_tile = FALSE

	if(istype(new_area, /area/city/backstreets_room/temple_motus/treasure_entrance) && !entered_boss_room)
		entered_boss_room = TRUE
		addtimer(CALLBACK(src, PROC_REF(boss_alert)), 5)

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

	scene_manager.load_scenes(list(
		//Intro to the NPC
		"intro" = list(
			"text" = "Wait... Another human is here? Completely untouched?! How.. How did you survive for so long?",
			"on_enter" = list(
				"dialog.first_meeting" = TRUE
			),
			"actions" = list(
				"outsider" = list(
					"text" = "I am from outside this town.",
					"default_scene" = "greeting1"
				),
				"question" = list(
					"text" = "Untouched? What do you mean?",
					"default_scene" = "greeting1"
				),
				"built" = list(
					"text" = "I am just built different.",
					"default_scene" = "greeting1"
				)
			)
		),

		"greeting1" = list(
			"text" = "Oh my... People are finally taking notice...",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"main_screen" = list(
			"text" = "\[dialog.first_meeting?What do you want to know about this place?:Anything else you want to know about?\]",
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
							"expression" = "player.area = \"Temple Treasure Hallway\"",
							"scene" = "temple_treasure_hallway"
						),
						list(
							"expression" = "player.area = \"Temple Treasure Entrance\"",
							"scene" = "temple_treasure_entrance"
						),
						list(
							"expression" = "player.area = \"Temple Treasure Room\"",
							"scene" = "temple_treasure_room"
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
			"text" = "outskirts outskirtsoutskirts",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),
		"temple_reception" = list(
			"text" = "temple_reception temple_reception temple_reception",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_factory" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_student_dorms" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_study_room_a" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_study_room_b" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_main_hall" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_library" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_storage" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_treasure_hallway" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_treasure_entrance" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_treasure_room" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
			"actions" = list(
				"..." = list(
					"text" = "...",
					"default_scene" = "main_screen"
				)
			)
		),

		"temple_medbay" = list(
			"text" = "Oh, Sorry for my incompetence but I lack any knowledge of this area.",
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

/mob/living/simple_animal/hostile/ui_npc/elliot/Destroy()
	Leader = null
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
		victim.speaking_on()
