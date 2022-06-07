/mob/living/simple_animal/hostile/abnormality
	name = "Abnormality"
	desc = "An abnormality..?"
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = DEAD
	layer = LARGE_MOB_LAYER
	del_on_death = TRUE
	/// Reference to the datum we use
	var/datum/abnormality/datum_reference = null
	/// The threat level of the abnormality. It is passed to the datum on spawn
	var/threat_level = ZAYIN_LEVEL
	/// Maximum qliphoth level, passed to datum
	var/start_qliphoth = 0
	/// Can it breach? If TRUE - zero_qliphoth() calls breach_effect()
	var/can_breach = FALSE
	/// Copy-pasted from megafauna.dm: This allows player controlled mobs to use abilities
	var/chosen_attack = 1
	/// Attack actions, sets chosen_attack to the number in the action
	var/list/attack_action_types = list()
	/// If there is a small sprite icon for players controlling the megafauna to use
	var/small_sprite_type
	/// Work types and chances
	var/list/work_chances = list(
							ABNORMALITY_WORK_INSTINCT = 30,
							ABNORMALITY_WORK_INSIGHT = 30,
							ABNORMALITY_WORK_ATTACHMENT = 30,
							ABNORMALITY_WORK_REPRESSION = 30
							)

/mob/living/simple_animal/hostile/abnormality/Initialize(mapload)
	. = ..()
	for(var/action_type in attack_action_types)
		var/datum/action/innate/abnormality_attack/attack_action = new action_type()
		attack_action.Grant(src)
	if(small_sprite_type)
		var/datum/action/small_sprite/small_action = new small_sprite_type()
		small_action.Grant(src)

/mob/living/simple_animal/hostile/abnormality/death(gibbed, list/force_grant)
	if(health > 0)
		return
	if(istype(datum_reference)) // Respawn the mob on death
		datum_reference.current = null
		addtimer(CALLBACK (datum_reference, .datum/abnormality/proc/RespawnAbno), 30 SECONDS)
	return ..()

// Modifiers for work chance
/mob/living/simple_animal/hostile/abnormality/proc/work_chance(mob/living/carbon/human/user, chance)
	return chance

// Called by datum_reference when work is done
/mob/living/simple_animal/hostile/abnormality/proc/work_complete(mob/living/carbon/human/user, work_type, pe, success_pe)
	if(pe >= success_pe)
		success_effect(user, work_type, pe)
		return
	failure_effect(user, work_type, pe)
	return

// Additional effects on work success, if any
/mob/living/simple_animal/hostile/abnormality/proc/success_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Additional effects on work failure
/mob/living/simple_animal/hostile/abnormality/proc/failure_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Effects when qliphoth reaches 0
/mob/living/simple_animal/hostile/abnormality/proc/zero_qliphoth(mob/living/carbon/human/user)
	if(can_breach)
		breach_effect(user)
	return

// Special breach effect for abnormalities with can_breach set to TRUE
/mob/living/simple_animal/hostile/abnormality/proc/breach_effect(mob/living/carbon/human/user)
	toggle_ai(AI_ON) // Run.
	status_flags &= ~GODMODE

// Actions
/datum/action/innate/abnormality_attack
	name = "Megafauna Attack"
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = ""
	var/mob/living/simple_animal/hostile/abnormality/A
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/abnormality_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/abnormality))
		A = L
		return ..()
	return FALSE

/datum/action/innate/abnormality_attack/Activate()
	A.chosen_attack = chosen_attack_num
	to_chat(A, chosen_message)
