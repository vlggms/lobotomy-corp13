/datum/ai_behavior/resist
	required_distance = 0

/datum/ai_behavior/resist/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	living_pawn.resist()
	finish_action(controller, TRUE)

/datum/ai_behavior/battle_screech
	///List of possible screeches the behavior has
	var/list/screeches

/datum/ai_behavior/battle_screech/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	INVOKE_ASYNC(living_pawn, TYPE_PROC_REF(/mob, emote), pick(screeches))
	finish_action(controller, TRUE)

/datum/ai_behavior/say_line
	///List of potential lines to say
	var/list/lines

/datum/ai_behavior/say_line/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	INVOKE_ASYNC(living_pawn, TYPE_PROC_REF(/atom/movable, say), pick(lines))
	finish_action(controller, TRUE)
