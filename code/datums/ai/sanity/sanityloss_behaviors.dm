/datum/ai_behavior/say_line/insanity_murder
	lines = list(
				"I won't die alone...",
				"You left me behind!",
				"You are the problem, YOU!!",
				"I'll destroy everything...",
				"It will end quickly, so relax. I’ll free you from this prison we call flesh."
				)

/datum/ai_behavior/say_line/insanity_suicide
	lines = list(
				"It's all my fault. It’s my responsibility...",
				"I can hear someone. It’s the sound of back home. I just can’t stop hearing it…",
				"There’s no hope left. My mind’s collapsing. Everything’s collapsing...",
				"We will all sink and perish, devoured by madness...",
				"There is no hope left...",
				"It will all end, soon..."
				)

/datum/ai_behavior/say_line/insanity_wander
	lines = list(
				"Manager?! Manager! Open the emergency door! PLEASE LET ME OUT!!",
				"HELP ME!!",
				"DON'T SEND ME IN THERE! DON’T KILL ME!!",
				"AHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA!!",
				"I will never get out of here..."
				)

/datum/ai_behavior/say_line/insanity_wander/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	var/sanity_damage = get_user_level(living_pawn) * 5
	for(var/mob/living/carbon/human/H in view(7, living_pawn))
		H.adjustWhiteLoss(sanity_damage, forced = TRUE)

/datum/ai_behavior/say_line/insanity_release
	lines = list(
				"Let us find peace from them.",
				"I’m so sorry dear friends, I’ll let you out now.",
				"We will find our redemption through the Abnormalities.",
				"Let us reach the paradise beyond death, together with the Abnormalities.",
				"Let me introduce you to my imaginary friends! They asked me to! They’re screaming to be let out!"
				)

/datum/ai_behavior/insanity_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/insanity_attack_mob/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn

	if(!target || target.stat == DEAD)
		finish_action(controller, TRUE) //Target == owned

	if(living_pawn.Adjacent(target) && isturf(target.loc) && !IS_DEAD_OR_INCAP(living_pawn))
		// check if target has a weapon
		var/obj/item/W
		for(var/obj/item/I in target.held_items)
			if(!(I.item_flags & ABSTRACT) && I.force > 5)
				W = I
				break

		// if the target has a weapon, chance to disarm them
		if(W && DT_PROB(20, delta_time))
			living_pawn.a_intent = INTENT_DISARM
			attack(controller, target, delta_time)
		else
			living_pawn.a_intent = INTENT_HARM
			attack(controller, target, delta_time)


/datum/ai_behavior/insanity_attack_mob/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	walk(living_pawn, 0)
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

/// attack using a held weapon otherwise bite the enemy, then if we are angry there is a chance we might calm down a little
/datum/ai_behavior/insanity_attack_mob/proc/attack(datum/ai_controller/controller, mob/living/target, delta_time)

	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.next_move > world.time)
		return

	living_pawn.changeNext_move(CLICK_CD_MELEE) //We play fair

	var/obj/item/weapon = locate(/obj/item) in living_pawn.held_items

	living_pawn.face_atom(target)

	// attack with weapon if we have one
	if(weapon)
		weapon.melee_attack_chain(living_pawn, target)
	else
		living_pawn.UnarmedAttack(target)

/datum/ai_behavior/insane_equip
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/insane_equip/finish_action(datum/ai_controller/controller, success)
	. = ..()

	if(!success) //Don't try again on this item if we failed
		var/list/item_blacklist = controller.blackboard[BB_INSANE_BLACKLISTITEMS]
		var/obj/item/target = controller.blackboard[BB_INSANE_PICKUPTARGET]

		item_blacklist[target] = TRUE

	controller.blackboard[BB_INSANE_PICKUPTARGET] = null

/datum/ai_behavior/insane_equip/proc/equip_item(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn

	var/obj/item/target = controller.blackboard[BB_INSANE_PICKUPTARGET]
	var/best_force = controller.blackboard[BB_INSANE_BEST_FORCE_FOUND]

	if(!isturf(living_pawn.loc))
		finish_action(controller, FALSE)
		return

	if(!target)
		finish_action(controller, FALSE)
		return

	if(target.anchored) //Can't pick it up, so stop trying.
		finish_action(controller, FALSE)
		return

	// Strong weapon
	else if(target.force > best_force)
		living_pawn.put_in_hands(target)
		controller.blackboard[BB_INSANE_BEST_FORCE_FOUND] = target.force
		finish_action(controller, TRUE)
		return

	finish_action(controller, FALSE)

/datum/ai_behavior/insane_equip/ground
	required_distance = 1

/datum/ai_behavior/insane_equip/ground/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	equip_item(controller)

/datum/ai_behavior/insanity_smash_console
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	var/list/current_path = list()

/datum/ai_behavior/insanity_smash_console/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/living_pawn = controller.pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	var/obj/machinery/computer/abnormality/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!LAZYLEN(current_path))
		current_path = get_path_to(living_pawn, get_step(target, SOUTH), /turf/proc/Distance_cardinal)
		if(!current_path) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return

	if(LAZYLEN(current_path))
		var/target_turf = current_path[1]
		step_towards(living_pawn, target_turf)
		current_path.Cut(1, 2)

	if(!istype(target) || !istype(target.datum_reference))
		finish_action(controller, FALSE)
		return
	if(DT_PROB(5, delta_time) && living_pawn.Adjacent(target) && isturf(target.loc))
		living_pawn.visible_message("<span class='danger'>[living_pawn] smashes panel on \the [target]!</span>")
		playsound(living_pawn.loc, 'sound/effects/hit_on_shattered_glass.ogg', 75, TRUE, -1)
		if(!target.finish_work(living_pawn))
			finish_action(controller, TRUE)

/datum/ai_behavior/insanity_smash_console/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
