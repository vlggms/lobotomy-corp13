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
	var/standstorm_stance_update
	var/standstorm_stance_cooldown = 20 SECONDS
	var/teleport_update
	var/teleport_cooldown = 10 SECONDS
	var/guilt = FALSE
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
	if(!do_after(M, 4 SECONDS, src) || !stunned)
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

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/CheckSpace(mob/user, atom/new_location)
	var/turf/newloc_turf = get_turf(new_location)
	var/valid_tile = TRUE

	var/area/new_area = get_area(newloc_turf)
	if(istype(new_area, /area/shuttle/mining))
		valid_tile = FALSE

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
				"ruin" = list(
					"text" = "Follow me, [src].",
					"proc_callbacks" = list(CALLBACK(src, PROC_REF(make_leader))),
					"default_scene" = "following"
				),
				"outpost" = list(
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
			)
		),
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

/mob/living/simple_animal/hostile/ui_npc/elliot/Destroy()
	Leader = null
	return ..()
