#define BIGBIRD_HYPNOSIS_COOLDOWN (20 SECONDS)
/mob/living/simple_animal/hostile/abnormality/big_bird
	name = "Big Bird"
	desc = "A large, many-eyed bird that patrols the dark forest with an everlasting lamp. \
	Unlike regular birds, it lacks wings and instead has long arms with which it can pick things up."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "big_bird"
	icon_living = "big_bird"
	core_icon = "bigbird_egg"
	portrait = "big_bird"
	faction = list("hostile", "Apocalypse")
	speak_emote = list("chirps")

	pixel_x = -16
	base_pixel_x = -16

	ranged = TRUE
	maxHealth = 1600
	health = 1600
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	see_in_dark = 10
	stat_attack = HARD_CRIT

	move_to_delay = 5
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 45, 45, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = list(40, 45, 50, 55, 55),
		ABNORMALITY_WORK_REPRESSION = list(25, 20, 15, 10, 0),
	)
	work_damage_upper = 6
	work_damage_lower = 2
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	max_boxes = 20

	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7

	patrol_cooldown_time = 5 SECONDS
	melee_damage_type = RED_DAMAGE//It bites
	melee_damage_lower = 35
	melee_damage_upper = 50
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/abnormalities/bigbird/bite.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/lamp,
		/datum/ego_datum/armor/lamp,
	)
	gift_type =  /datum/ego_gifts/lamp
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/judgement_bird = 3,
		/mob/living/simple_animal/hostile/abnormality/punishing_bird = 3,
	)

	observation_prompt = "Dozens of blazing eyes are looking at one place. <br>\
		The bird that lived in the forest didn't like creatures being eaten by monsters. <br>\
		\"If I kill creatures first, no creatures will be killed by the monster.\" <br>\
		Every time the bird saved a life, it got an eye. <br>The big bird could not close those eyes no matter how tired it got. <br>\
		For monsters could come, hurting creatures at any time. <br>By the time eyes covered the whole body of the big bird, no one was around for it to protect. <br>\
		To shine the light in this dark forest, the big bird burned every single feather it had to make an everlasting lamp. <br>\
		The big bird now could hardly be called a bird now, it has no feathers at all."
	observation_choices = list(
		"Pet it" = list(TRUE, "It was not soft actually, it gave you chills. <br>You felt eyes looking at you with curiosity. <br>\
			Eyes started closing as you pet the bird. <br>The big bird, for the first time in a very long time, peacefully fell asleep."),
		"Don't pet it" = list(FALSE, "The bird could get angry and bite you. <br>You ran out of the room in fear."),
	)

	var/bite_cooldown
	var/bite_cooldown_time = 5 SECONDS
	var/can_act = TRUE
	var/hypnosis_cooldown
	var/hypnosis_cooldown_time = 16 SECONDS

	var/list/hypno_1 = list()
	var/list/hypno_2 = list()
	var/list/enchanted_list = list()
	var/omw_to_apoc = FALSE

	//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/cooldown/big_bird_hypnosis)

/datum/action/cooldown/big_bird_hypnosis
	name = "Dazzle"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "big_bird"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = BIGBIRD_HYPNOSIS_COOLDOWN //16 seconds

/datum/action/cooldown/big_bird_hypnosis/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/big_bird))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/big_bird/big_bird = owner
	if(big_bird.IsContained()) // No more using cooldowns while contained
		return FALSE
	if(!big_bird.can_act || big_bird.omw_to_apoc)
		return FALSE
	StartCooldown()
	big_bird.hypnotize()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/big_bird/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/Life()
	. = ..()
	if(target)
		if(!CanBeFinished(target))
			LoseTarget()
	if(client)
		return
	if(IsContained())
		return
	if(hypnosis_cooldown <= world.time && can_act && !omw_to_apoc)
		hypnotize()

/mob/living/simple_animal/hostile/abnormality/big_bird/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

/mob/living/simple_animal/hostile/abnormality/big_bird/Destroy()
	for(var/atom/movable/AM in src) //Here, have your friend's heads back!
		AM.forceMove(loc)
	for(var/mob/living/carbon/human/H in enchanted_list)
		EndEnchant(H)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/Moved()
	. = ..()
	if(!(status_flags & GODMODE)) // Whitaker nerf
		playsound(get_turf(src), 'sound/abnormalities/bigbird/step.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/big_bird/CanAttack(atom/the_target)
	if(ishuman(the_target))
		if(bite_cooldown > world.time)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/CanBeFinished(mob/living/carbon/human/H)
	if(!ishuman(H))
		return FALSE
	var/datum/status_effect/big_enchant/B = H.has_status_effect(/datum/status_effect/big_enchant)
	. = (!(H.status_flags & GODMODE) && (B || H.health < H.maxHealth*0.3 || (H in enchanted_list) || H.sanity_lost))

//targetting
/mob/living/simple_animal/hostile/abnormality/big_bird/PickTarget(list/Targets) //Stolen from Jangsan
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(CanBeFinished(H))
				highest_priority += H//We only want to attack people that are under the abnormality's effects or are panicking or are close to dying
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/get_sweep_turfs(atom/target)
	var/target_turf = get_step_towards(src, target)
	var/start = WEST
	var/end = EAST

	switch(get_dir(src, target))
		if(NORTH)
			start = EAST
			end = WEST
		if(SOUTH)
			start = WEST
			end = EAST
		if(EAST)
			start = SOUTH
			end = NORTH
		if(WEST)
			start = NORTH
			end = SOUTH
		if(NORTHEAST)
			start = SOUTH
			end = WEST
		if(NORTHWEST)
			start = EAST
			end = SOUTH
		if(SOUTHEAST)
			start = WEST
			end = NORTH
		if(SOUTHWEST)
			start = NORTH
			end = EAST

	. = list(get_step(target_turf, start), target_turf, get_step(target_turf, end))

	return

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/PickBiteVictim(list/Targets, atom/target, check_lower = FALSE) // We pick non hypnoed people directly infront or ontop of bb first
	var/list/highest_priority = list()
	var/list/higher_priority = list()
	var/list/lower_priority = list()
	var/list/lowest_priority = list()
	var/target_turf = get_step_towards(src, target)
	for(var/mob/living/L in Targets)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(CanBeFinished(H))
				if((H in target_turf) || (H in get_turf(src)))
					lower_priority += H
				else
					lowest_priority += H
			else
				if(L in target_turf || (L in get_turf(src)))
					highest_priority += L
				else
					higher_priority += L
		else
			if(L in target_turf || (L in get_turf(src)))
				lower_priority += L
			else
				lowest_priority += L
	if(LAZYLEN(highest_priority))
		return . = pick(highest_priority)
	if(LAZYLEN(higher_priority))
		return . = pick(higher_priority)
	if(check_lower)
		if(LAZYLEN(lower_priority))
			return . = pick(lower_priority)
		if(LAZYLEN(lowest_priority))
			return . = pick(lowest_priority)
	return null

/mob/living/simple_animal/hostile/abnormality/big_bird/AttackingTarget(atom/attacked_target)
	if(omw_to_apoc)
		return
	if(!isliving(attacked_target))
		return ..()
	if(client)
		if(target == src)
			to_chat(src, span_warning("You almost attack yourself, but then decide against it."))
			return
		if(SSmaptype.maptype == "rcorp" && faction_check_mob(target, FALSE))
			to_chat(src, span_warning("You almost attack your teammate, but then decide against it."))
			return
	if(!can_act)
		return
	var/bite_of_87 = FALSE
	var/new_dir = get_dir(src, attacked_target)
	dir = new_dir
	can_act = FALSE
	var/mob/living/carbon/current_guy = null
	if(ishuman(attacked_target))
		current_guy = attacked_target
	var/turf/T = get_step(src,dir)
	var/list/hit_turfs = get_sweep_turfs(T)
	for(var/turf/TF in hit_turfs)
		var/obj/effect/temp_visual/cult/sparks/C = new(TF)
		C.duration = 8 SECONDS
	icon_state = "big_bird_chomp"
	SLEEP_CHECK_DEATH(8.5)
	for(var/turf/TF in hit_turfs)
		var/obj/effect/temp_visual/beakbite/B = new(TF)
		B.color = COLOR_BLACK

	hit_turfs += get_turf(src)
	var/list/potential_targets = list()
	for(var/turf/TT in hit_turfs)
		for(var/mob/living/L in TT)
			if(L.stat == DEAD)
				continue
			if(faction_check_mob(L, FALSE))
				continue
			if(istype(L, /mob/living/simple_animal/projectile_blocker_dummy))
				var/mob/living/simple_animal/projectile_blocker_dummy/pbd = L
				L = pbd.parent
			potential_targets |= L
	potential_targets -= src

	var/mob/to_bite_some = PickBiteVictim(potential_targets, T)
	if(to_bite_some)
		attacked_target = to_bite_some
	if(!(attacked_target in hit_turfs[1]) && !(attacked_target in hit_turfs[2]) && !(attacked_target in hit_turfs[3]) && !(attacked_target in get_turf(src)))
		target = null

		var/mob/to_bite = PickBiteVictim(potential_targets, T, TRUE)

		if(!to_bite)
			visible_message(span_danger("\The [src] bite the air!"))
			to_chat(src, span_danger("You missed your attack!"))
			playsound(loc, attack_sound, 50, TRUE, TRUE)
			do_attack_animation(T)
			attack_cooldown = max(attack_cooldown, 1)
			changeNext_move(attack_cooldown/2)
			SLEEP_CHECK_DEATH(0.5 SECONDS)
			icon_state = icon_living
			can_act = TRUE
			bite_cooldown = world.time + bite_cooldown_time/2
			for(var/mob/living/carbon/human/H in view(4, src))
				EndEnchant(H)
			return
		else
			attacked_target = to_bite
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		var/datum/status_effect/big_enchant/B = H.has_status_effect(/datum/status_effect/big_enchant)
		if(CanBeFinished(H))
			bite_of_87 = TRUE
			if(B)
				H.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted", -HALO_LAYER))
				H.remove_status_effect(/datum/status_effect/big_enchant)
			var/obj/item/bodypart/head/head = H.get_bodypart("head")
			EndEnchant(H, FALSE)
			if(!QDELETED(head))
				head.dismember()
				NestedItems(src, head)
				H.regenerate_icons()
				visible_message(span_danger("\The [src] bites [H]'s head off!"))
	if(current_guy)
		EndEnchant(current_guy)
	. = ..()
	dir = new_dir
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	icon_state = icon_living
	can_act = TRUE
	if(!bite_of_87)
		bite_cooldown = world.time + bite_cooldown_time
		for(var/mob/living/carbon/human/H in view(4, src))
			EndEnchant(H)
	return

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/NestedItems(mob/living/simple_animal/hostile/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

/mob/living/simple_animal/hostile/abnormality/big_bird/MobBump(mob/M)
	if(omw_to_apoc)
		return ..()
	if(!ishuman(M)) //We want to attack people in the way
		return ..()
	if(client)
		return ..()
	var/mob/living/L = M
	if(!LAZYLEN(patrol_path))
		return ..()
	if(L.stat == DEAD)
		return ..()
	if(faction_check_mob(L, FALSE))
		return ..()
	if(!(L in patrol_path[1]))
		return ..()
	if(!CanAttack(L))
		return ..()
	if(L.a_intent == INTENT_HELP)
		return ..()
	AttackingTarget(L)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/big_bird/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(target != null) // BB cannot be blocked by mobs when it's moving towards its target
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/hypnotize()
	if(hypnosis_cooldown > world.time)
		return
	var/list/hypno_1_old = hypno_1
	var/list/hypno_2_old = hypno_2
	hypno_1 = list()
	hypno_2 = list()
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/bigbird/hypnosis.ogg', 50, 1, 2)
	var/list/hypnotize_list = list()
	for(var/mob/living/carbon/C in view(8, src))
		if(faction_check_mob(C, FALSE))
			continue
		if(!CanAttack(C))
			continue
		if(C in enchanted_list)
			hypno_2 += C
			continue
		if(ismoth(C))
			pick(C.emote("scream"), C.visible_message(span_boldwarning("[C] lunges for the light!")))
			C.throw_at((src), 10, 2)
		if(prob(66) || (C in hypno_1_old) || (C in hypno_2_old))
			var/new_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted", -HALO_LAYER)
			if((C in hypno_1_old) || (C in hypno_2_old))
				to_chat(C, span_warning("The light..."))
				new_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted_red", -HALO_LAYER)
			else
				to_chat(C, span_warning("You feel tired..."))
			C.blur_eyes(5)
			hypnotize_list += C
			C.add_overlay(new_overlay)
			addtimer(CALLBACK (C, TYPE_PROC_REF(/atom, cut_overlay), new_overlay), 1.9 SECONDS)
	SLEEP_CHECK_DEATH(2 SECONDS)
	for(var/mob/living/carbon/C in hypnotize_list)
		if(!(C in view(12, src)))
			continue
		C.blind_eyes(2)
		if((C in hypno_1_old) || (C in hypno_2_old))
			hypno_2 += C
			C.ai_controller = /datum/ai_controller/insane/big_bird
			C.InitializeAIController()
			enchanted_list.Add(C)
			C.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted_red", -HALO_LAYER))
			addtimer(CALLBACK(src, PROC_REF(EndEnchant), C), 30 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
		else
			hypno_1 += C
			C.Stun(3 SECONDS)
			var/new_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted", -HALO_LAYER)
			C.add_overlay(new_overlay)
			addtimer(CALLBACK (C, TYPE_PROC_REF(/atom, cut_overlay), new_overlay), 12 SECONDS)
			C.apply_status_effect(/datum/status_effect/big_enchant)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	patrol_reset()
	FindTarget()
	hypnosis_cooldown = world.time + hypnosis_cooldown_time
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	return TRUE

/mob/living/simple_animal/hostile/abnormality/big_bird/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/big_bird/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/big_bird/FindTarget(list/possible_targets, HasTargetsList)
	if(omw_to_apoc) // Nah I'd Walk
		return
	. = ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/ListTargets()
	if(omw_to_apoc) // I have places to be
		return list()
	else
		return ..()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/BreachEffect(mob/living/carbon/human/user, breach_type)
	omw_to_apoc = FALSE
	docile_confinement = FALSE
	. = ..()
	return

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/EndEnchant(mob/living/carbon/human/victim, Snapped = TRUE)
	if(victim in enchanted_list)
		enchanted_list.Remove(victim)
		victim.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted_red", -HALO_LAYER))
		if(istype(victim.ai_controller,/datum/ai_controller/insane/big_bird))
			if(Snapped)
				to_chat(victim, "<span class='boldwarning'>You snap out of your trance!")
			qdel(victim.ai_controller)

/datum/ai_controller/insane/big_bird
	lines_type = /datum/ai_behavior/say_line/insanity_enchanted
	var/last_message = 0

/datum/ai_controller/insane/big_bird/SelectBehaviors(delta_time)
	..()
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return

	var/mob/living/simple_animal/hostile/abnormality/big_bird/bird
	for(var/mob/living/simple_animal/hostile/abnormality/big_bird/M in GLOB.mob_living_list)
		if(!istype(M))
			continue
		bird = M
	if(bird)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/big_bird_move)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = bird

/datum/ai_controller/insane/big_bird/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(DT_PROB(80, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	if(DT_PROB(25, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

/datum/ai_behavior/big_bird_move

/datum/ai_behavior/big_bird_move/perform(delta_time, datum/ai_controller/insane/big_bird/controller)
	. = ..()

	var/mob/living/carbon/human/living_pawn = controller.pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	var/mob/living/simple_animal/hostile/abnormality/big_bird/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!istype(target))
		finish_action(controller, FALSE)
		return

	if(!LAZYLEN(controller.current_path))
		controller.current_path = get_path_to(living_pawn, target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 80)
		if(!controller.current_path.len) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
		controller.current_path.Remove(controller.current_path[1])
		Movement(controller)

/datum/ai_behavior/big_bird_move/proc/Movement(datum/ai_controller/insane/big_bird/controller)
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/big_bird/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	if(world.time > controller.last_message + 10 SECONDS)
		controller.last_message = world.time
		controller.current_behaviors += GET_AI_BEHAVIOR(controller.lines_type)

	if(LAZYLEN(controller.current_path) && !IS_DEAD_OR_INCAP(living_pawn))
		var/target_turf = controller.current_path[1]
		if(target_turf && get_dist(living_pawn, target_turf) < 3)
			if(!step_towards(living_pawn, target_turf))
				controller.pathing_attempts++
			if(controller.pathing_attempts >= MAX_PATHING_ATTEMPTS)
				finish_action(controller, FALSE)
				return FALSE
			else
				if(get_turf(living_pawn) == target_turf)
					controller.current_path.Remove(target_turf)
					controller.pathing_attempts = 0
					if(isturf(target.loc) && (target in view(1,living_pawn)))
						living_pawn.Stun(2 SECONDS)
						return
				else
					controller.pathing_attempts++
			var/move_delay = living_pawn.cached_multiplicative_slowdown + 0.1
			addtimer(CALLBACK(src, PROC_REF(Movement), controller), move_delay)
			return TRUE
	finish_action(controller, FALSE)
	return FALSE

/datum/ai_behavior/big_bird_move/finish_action(datum/ai_controller/insane/big_bird/controller, succeeded)
	. = ..()
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/big_bird/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	controller.pathing_attempts = 0
	controller.current_path = list()
	if(succeeded)
		target.EndEnchant(living_pawn)
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

/datum/status_effect/big_enchant
	id = "big_bird_enchantment"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 12 SECONDS

#undef BIGBIRD_HYPNOSIS_COOLDOWN
