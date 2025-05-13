/mob/living/simple_animal/hostile/ui_npc/elliot
	name = "Joshua"
	desc = "A strange explorer wearing a hood, they appear to be carrying a blade."
	gender = NEUTER
	health = 800
	maxHealth = 800
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
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
	var/can_act = TRUE
	var/mob/living/Leader = null // AI variable - tells the slime to follow this person
	var/holding_still = 0
	var/attack_tremor = 3
	var/last_staying_update
	var/staying_cooldown = 20 SECONDS

/mob/living/simple_animal/hostile/ui_npc/elliot/Life()
	if(..())
		if(!target) // If we have no target, we start following an ally
			density = TRUE
			if(Leader)
				if(Leader.z != z)
					Leader = null
					return
				// if(holding_still)
				// 	holding_still = max(holding_still - 1, 0)
				if(!HAS_TRAIT(src, TRAIT_IMMOBILIZED) && isturf(loc))
					step_to(src, Leader)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 5)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 10)
					addtimer(CALLBACK(src, PROC_REF(follow_leader)), 15)
		else
			density = FALSE

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/follow_leader()
	step_to(src, Leader)

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

/mob/living/simple_animal/hostile/ui_npc/elliot/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ui_npc/elliot/death(gibbed)
	if(ending)
		return ..()
	INVOKE_ASYNC(src, PROC_REF(Downed))
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/Downed()
	can_act = FALSE
	status_flags |= GODMODE
	say("Dammit... I have taken too many hits.")
	visible_message(span_warning("[src] falls down!"))
	icon_state = "elliot_down"
	density = FALSE
	SLEEP_CHECK_DEATH(15 SECONDS)
	density = TRUE
	status_flags &= ~GODMODE
	icon_state = icon_living
	adjustBruteLoss(-maxHealth, forced = TRUE)
	say("Alright... Back into the fight.")
	visible_message(span_warning("[src] gets back up!"))
	can_act = TRUE

/mob/living/simple_animal/hostile/ui_npc/elliot/proc/StandstormStance()
	for(var/mob/living/carbon/human/L in orange(5, get_turf(src)))

/datum/status_effect/standstorm_stance // MAYBE the black sunder shti works this time.
	id = "standstorm_stance"
	duration = 10 SECONDS //lasts 2 seconds becuase this is for an AI that attacks fast as shit, its not meant to fuck you up with other things.
	alert_type = /atom/movable/screen/alert/status_effect/standstorm_stance
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/standstorm_stance
	name = "Standstorm Stance"
	desc = "You feel the sand move with you, your attacks now inflict 2 Tremor on hit."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "false_kindness"

/datum/status_effect/standstorm_stance/on_apply() //" Borrowed " from Ptear blade, courtesy of gong.
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner //Stolen from Ptear Blade, MAYBE works on people?
	to_chat(status_holder, span_nicegreen("You feel the sands move with you!"))

/datum/status_effect/standstorm_stance/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_userdanger("You feel as though its gaze has lifted.")) //stolen from PT wep, but I asked so this 100% ok.
	status_holder.physiology.black_mod /= 1.3

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

/mob/living/simple_animal/hostile/ui_npc/elliot/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(CheckSpace))

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
					"text" = "Why are you out here?",
					"default_scene" = "greeting1"
				),
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
