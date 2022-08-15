/datum/ai_controller/insane
	continue_processing_when_client = TRUE
	blackboard = list(BB_INSANE_BEST_FORCE_FOUND = 10,\
	BB_INSANE_BLACKLISTITEMS = list(),\
	BB_INSANE_PICKUPTARGET = null,\
	BB_INSANE_CURRENT_ATTACK_TARGET = null)
	max_target_distance = 20
	var/resist_chance = 90
	var/datum/ai_behavior/say_line/lines_type = /datum/ai_behavior/say_line

/datum/ai_controller/insane/TryPossessPawn(atom/new_pawn)
	if(!ishuman(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_HAND, .proc/on_attack_hand)
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, .proc/on_bullet_act)
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, .proc/on_hitby)
	RegisterSignal(new_pawn, COMSIG_MOVABLE_CROSSED, .proc/on_Crossed)
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, .proc/on_startpulling)
	return ..() //Run parent at end

/datum/ai_controller/insane/able_to_run()
	var/mob/living/carbon/human/human_pawn = pawn

	if(IS_DEAD_OR_INCAP(human_pawn))
		return FALSE
	return ..()

/datum/ai_controller/insane/SelectBehaviors(delta_time)
	current_behaviors = list()
	var/mob/living/living_pawn = pawn

	if(SHOULD_RESIST(living_pawn) && DT_PROB(resist_chance, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/resist)
		return
	return

/datum/ai_controller/insane/proc/retaliate(mob/living/L)
	if(L != pawn)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = L
	return

/datum/ai_controller/insane/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_attack_hand(datum/source, mob/living/L)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_attack_paw(datum/source, mob/living/L)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_bullet_act(datum/source, obj/projectile/Proj)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_Crossed(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	return

/datum/ai_controller/insane/proc/on_startpulling(datum/source, atom/movable/puller, state, force)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn))
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/resist)
		return TRUE
	return FALSE

/datum/ai_controller/insane/murder
	lines_type = /datum/ai_behavior/say_line/insanity_murder
	var/list/currently_scared = list()

/datum/ai_controller/insane/murder/SelectBehaviors(delta_time)
	..()
	var/mob/living/living_pawn = pawn
	var/mob/living/selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	if(selected_enemy)
		if(!(selected_enemy in livinginrange(10, living_pawn)))
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(selected_enemy.stat != DEAD)
			current_movement_target = selected_enemy
			if(DT_PROB(50, delta_time))
				current_behaviors += GET_AI_BEHAVIOR(lines_type)
				for(var/mob/living/carbon/human/H in view(7, living_pawn))
					if(H in currently_scared)
						continue
					var/sanity_damage = (H.maxSanity * 0.15) * (get_user_level(living_pawn) - get_user_level(H))
					H.adjustSanityLoss(min(0, -sanity_damage))
					currently_scared += H
			current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_attack_mob)
			return
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
		return

	if(TryFindWeapon())
		return

	for(var/mob/living/L in view(9, living_pawn))
		if(prob(33) && (L.stat != DEAD) && (L != living_pawn))
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = L
			return

/datum/ai_controller/insane/murder/proc/TryFindWeapon()
	var/mob/living/living_pawn = pawn

	if(!locate(/obj/item) in living_pawn.held_items)
		blackboard[BB_MONKEY_BEST_FORCE_FOUND] = 10

	var/obj/item/W
	for(var/obj/item/i in view(7, living_pawn))
		if(!istype(i))
			continue
		if(blackboard[BB_INSANE_BLACKLISTITEMS][i] || i.force > blackboard[BB_INSANE_BEST_FORCE_FOUND])
			continue
		W = i
		break

	if(W)
		blackboard[BB_INSANE_PICKUPTARGET] = W
		current_movement_target = W
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insane_equip/ground)
		return TRUE
	return FALSE

/datum/ai_controller/insane/murder/on_attackby(datum/source, obj/item/I, mob/user)
	..()
	retaliate(user)
	return

/datum/ai_controller/insane/murder/on_attack_hand(datum/source, mob/living/L)
	..()
	retaliate(L)
	return

/datum/ai_controller/insane/murder/on_attack_paw(datum/source, mob/living/L)
	..()
	retaliate(L)
	return

/datum/ai_controller/insane/murder/on_bullet_act(datum/source, obj/projectile/Proj)
	..()
	if(isliving(Proj.firer))
		retaliate(Proj.firer)
	return

/datum/ai_controller/insane/murder/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	..()
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		if(I.throwforce < living_pawn.health && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			retaliate(H)
	return

/datum/ai_controller/insane/murder/on_Crossed(datum/source, atom/movable/AM)
	..()
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && ismob(AM))
		retaliate(AM)
		return
	return

/datum/ai_controller/insane/murder/on_startpulling(datum/source, atom/movable/puller, state, force)
	..()
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn))
		retaliate(living_pawn.pulledby)
		return TRUE
	return FALSE

/datum/ai_controller/insane/suicide
	resist_chance = 0 // We'll die anyway
	lines_type = /datum/ai_behavior/say_line/insanity_suicide
	var/suicide_timer = 0

/datum/ai_controller/insane/suicide/PerformIdleBehavior(delta_time)
	var/mob/living/carbon/human/human_pawn = pawn
	var/suicide_target = 6 + round(get_attribute_level(human_pawn, PRUDENCE_ATTRIBUTE) / 8)
	if(DT_PROB(10, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)
		human_pawn.jitteriness += 10
		human_pawn.do_jitter_animation(human_pawn.jitteriness)
		suicide_timer += 1
	if((suicide_timer >= suicide_target) && (human_pawn.mobility_flags & MOBILITY_MOVE))
		human_pawn.visible_message("<span class='danger'>[human_pawn] is twisting their neck, they are trying to commit suicide!</span>")
		human_pawn.adjustBruteLoss(400)
		human_pawn.jitteriness = 0
		var/sanity_damage = get_user_level(human_pawn) * 30
		for(var/mob/living/carbon/human/H in view(7, human_pawn))
			H.adjustWhiteLoss(sanity_damage)

/datum/ai_controller/insane/wander
	lines_type = /datum/ai_behavior/say_line/insanity_wander
	var/last_message

/datum/ai_controller/insane/wander/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if((living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	if(DT_PROB(10, delta_time) && world.time + 5 SECONDS > last_message)
		last_message = world.time
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

/datum/ai_controller/insane/release
	lines_type = /datum/ai_behavior/say_line/insanity_release

/datum/ai_controller/insane/release/SelectBehaviors(delta_time)
	..()
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return

	if(DT_PROB(5, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/AC in GLOB.abnormality_consoles)
		if(!AC.can_meltdown)
			continue
		if(!AC.datum_reference)
			continue
		if(!(AC.datum_reference.current.status_flags & GODMODE))
			continue
		if((AC.datum_reference.qliphoth_meter_max > 0) && (AC.datum_reference.qliphoth_meter > 0))
			if(get_dist(pawn, AC) < 40)
				potential_computers += AC
	if(LAZYLEN(potential_computers))
		var/obj/machinery/computer/abnormality/chosen = get_closest_atom(/obj/machinery/computer/abnormality, potential_computers, pawn)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_smash_console)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = chosen

/datum/ai_controller/insane/release/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(DT_PROB(25, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
