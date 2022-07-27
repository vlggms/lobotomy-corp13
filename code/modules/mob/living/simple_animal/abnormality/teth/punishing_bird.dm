/mob/living/simple_animal/hostile/abnormality/punishing_bird
	name = "Punishing Bird"
	desc = "A white bird with tiny beak. Looks harmless."
	icon = 'icons/mob/punishing_bird.dmi'
	icon_state = "pbird"
	icon_living = "pbird"
	icon_dead = "pbird_dead"
	turns_per_move = 2
	response_help_continuous = "brushes aside"
	response_help_simple = "brush aside"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	density = FALSE
	is_flying_animal = TRUE
	maxHealth = 600
	health = 600
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 2, WHITE_DAMAGE = 2, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	see_in_dark = 10
	harm_intent_damage = 10
	melee_damage_lower = 1
	melee_damage_upper = 2
	rapid_melee = 2
	stat_attack = SOFT_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	pass_flags = PASSTABLE
	faction = list("hostile")
	attack_sound = 'sound/weapons/pbird_bite.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_TINY
	is_flying_animal = TRUE
	speak_emote = list("chirps")
	vision_range = 14
	aggro_vision_range = 28
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(40, 40, 40, 45, 45),
						ABNORMALITY_WORK_INSIGHT = 60,
						ABNORMALITY_WORK_ATTACHMENT = list(55, 55, 50, 50, 50),
						ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0)
						)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/armor/beak
		)

	var/list/enemies = list()
	var/list/already_punished = list()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/TransformRed()
	visible_message("<span class='danger'>\The [src] turns its insides out as a giant bloody beak appears!</span>")
	icon_state = "pbird_red"
	icon_living = "pbird_red"
	attack_verb_continuous = "eviscerates"
	attack_verb_simple = "eviscerate"
	melee_damage_lower = 175
	melee_damage_upper = 225
	obj_damage = 500
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	stat_attack = DEAD
	update_icon()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/TransformBack()
	visible_message("<span class='notice'>\The [src] turns back into a fuzzy looking bird!</span>")
	icon_state = initial(icon_state)
	icon_living = initial(icon_living)
	attack_verb_continuous = initial(attack_verb_continuous)
	attack_verb_simple = initial(attack_verb_simple)
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	obj_damage = initial(obj_damage)
	environment_smash = initial(environment_smash)
	stat_attack = initial(stat_attack)
	adjustHealth(-maxHealth) // Full restoration
	update_icon()

/mob/living/simple_animal/hostile/abnormality/punishing_bird/Life()
	if(..())
		if(obj_damage > 0) // Already transformed
			return
		if(prob(4))
			var/list/around = view(src, vision_range)
			var/list/potential_mobs = list()
			for(var/mob/living/carbon/C in around)
				if(C.ckey && C.client && !faction_check_mob(C) && !(C in already_punished))
					potential_mobs += C
			if(potential_mobs.len)
				var/mob/living/carbon/le_target = pick(potential_mobs)
				enemies |= le_target

/mob/living/simple_animal/hostile/abnormality/punishing_bird/AttackingTarget()
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(obj_damage <= 0) // Not transformed
			if(prob(10) && (L in enemies))
				enemies -= L
				already_punished |= L
				target = null
		else if(L.health <= HEALTH_THRESHOLD_FULLCRIT)
			visible_message("<span class='danger'>\The [src] devours [L]!</span>")
			L.gib()
			TransformBack()

// Disgusting, godless copypaste from retaliate.dm
/mob/living/simple_animal/hostile/abnormality/punishing_bird/Found(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		return L
	else if(ismecha(A))
		var/obj/vehicle/sealed/mecha/M = A
		if(LAZYLEN(M.occupants))
			return A

/mob/living/simple_animal/hostile/abnormality/punishing_bird/ListTargets()
	if(!enemies.len)
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/abnormality/punishing_bird/proc/Retaliate()
	var/list/around = view(src, vision_range)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(faction_check_mob(M) && attack_same || !faction_check_mob(M))
				enemies |= M
		else if(ismecha(A))
			var/obj/vehicle/sealed/mecha/M = A
			if(LAZYLEN(M.occupants))
				enemies |= M
				enemies |= M.occupants

/mob/living/simple_animal/hostile/abnormality/punishing_bird/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS)
		Retaliate()
		if(enemies.len && (health < maxHealth * 0.9) && (obj_damage <= 0))
			TransformRed()

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/punishing_bird/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/punishing_bird/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(1)
	manual_emote("chirps!")
	return

/mob/living/simple_animal/hostile/abnormality/punishing_bird/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/punishing_bird/breach_effect(mob/living/carbon/human/user)
	..()
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/H in range(32)) // Find random target to annoy
		potential_targets += H
	FindTarget(potential_targets, TRUE)
