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

/datum/ai_controller/insane/murder
	lines_type = /datum/ai_behavior/say_line/insanity_murder
	var/list/currently_scared = list()

/datum/ai_controller/insane/murder/SelectBehaviors(delta_time)
	..()
	var/mob/living/living_pawn = pawn
	var/mob/living/selected_enemy
	for(var/mob/living/possible_enemy in range(14, living_pawn))
		if(possible_enemy == living_pawn)
			continue

		selected_enemy = possible_enemy
		break

	if(selected_enemy)
		if(!selected_enemy.stat)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = selected_enemy
			current_movement_target = selected_enemy
			if(DT_PROB(50, delta_time))
				current_behaviors += GET_AI_BEHAVIOR(lines_type)
				for(var/mob/living/carbon/human/H in view(7, living_pawn))
					if(H in currently_scared)
						continue
					var/sanity_damage = (H.maxSanity * 0.1) * (get_user_level(living_pawn) - get_user_level(H))
					H.adjustSanityLoss(min(0, -sanity_damage))
					currently_scared += H
			current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_attack_mob)
			return

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
		for(var/mob/living/carbon/human/H in view(7, human_pawn))
			var/sanity_damage = (H.maxSanity * 0.25) * (get_user_level(human_pawn) - get_user_level(H))
			H.adjustSanityLoss(min(0, -sanity_damage))

/datum/ai_controller/insane/wander
	lines_type = /datum/ai_behavior/say_line/insanity_wander

/datum/ai_controller/insane/wander/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	var/sanity_damage = 5 + round(get_attribute_level(living_pawn, TEMPERANCE_ATTRIBUTE) / 10)
	if((living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	if(DT_PROB(5, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)
		for(var/mob/living/carbon/human/H in view(7, living_pawn))
			H.adjustWhiteLoss(sanity_damage, forced = TRUE)

/datum/ai_controller/insane/release
	lines_type = /datum/ai_behavior/say_line/insanity_release
	max_target_distance = 50

/datum/ai_controller/insane/release/SelectBehaviors(delta_time)
	..()
	if(istype(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET], /obj/machinery/computer/abnormality))
		return
	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/AC in GLOB.abnormality_consoles)
		if(!AC.datum_reference)
			continue
		if((AC.datum_reference.qliphoth_meter_max > 0) && (AC.datum_reference.qliphoth_meter > 0))
			potential_computers += AC
	if(LAZYLEN(potential_computers))
		var/obj/machinery/computer/abnormality/chosen = pick(potential_computers)
		current_movement_target = chosen
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_smash_console)
		if(DT_PROB(25, delta_time))
			current_behaviors += GET_AI_BEHAVIOR(lines_type)

/datum/ai_controller/insane/release/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(DT_PROB(10, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
