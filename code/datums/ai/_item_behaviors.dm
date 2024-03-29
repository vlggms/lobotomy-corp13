///This behavior is for obj/items, it is used to free themselves out of the hands of whoever is holding them
/datum/ai_behavior/item_escape_grasp

/datum/ai_behavior/item_escape_grasp/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/obj/item/item_pawn = controller.pawn
	var/mob/item_holder = item_pawn.loc
	if(!istype(item_holder))
		finish_action(controller, FALSE) //We're no longer beind held. abort abort!!
	item_pawn.visible_message(span_warning("[item_pawn] slips out of the hands of [item_holder]!"))
	item_holder.dropItemToGround(item_pawn, TRUE)
	finish_action(controller, TRUE)


///This behavior is for obj/items, it is used to move closer to a target and throw themselves towards them.
/datum/ai_behavior/item_move_close_and_attack
	required_distance = 3
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT
	action_cooldown = 20
	///Blackboard key for the max attempt of throws
	var/throw_count_key
	///Blackboard key for the target to hit
	var/target_key
	///Sound to use
	var/attack_sound
	///Max attemps to make
	var/max_attempts = 3


/datum/ai_behavior/item_move_close_and_attack/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/obj/item/item_pawn = controller.pawn
	var/atom/throw_target = controller.blackboard[target_key]

	item_pawn.visible_message(span_warning("[item_pawn] hurls towards [throw_target]!"))
	item_pawn.throw_at(throw_target, rand(4,5), 9)
	playsound(item_pawn.loc, attack_sound, 100, TRUE)
	controller.blackboard[throw_count_key]++
	if(controller.blackboard[throw_count_key] >= max_attempts)
		finish_action(controller, TRUE)

/datum/ai_behavior/item_move_close_and_attack/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.blackboard[throw_count_key] = 0
	controller.blackboard[target_key] = null

/datum/ai_behavior/item_move_close_and_attack/haunted
	throw_count_key = BB_HAUNTED_THROW_ATTEMPT_COUNT
	target_key = BB_HAUNT_TARGET
	attack_sound = 'sound/items/haunted/ghostitemattack.ogg'
	max_attempts = 4

/datum/ai_behavior/item_move_close_and_attack/haunted/finish_action(datum/ai_controller/controller, succeeded)
	var/atom/throw_target = controller.blackboard[target_key]
	var/list/hauntee_list = controller.blackboard[BB_TO_HAUNT_LIST]
	hauntee_list[throw_target]--
	return ..()
