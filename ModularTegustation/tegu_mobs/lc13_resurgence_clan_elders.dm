/mob/living/simple_animal/hostile/clan/tinkerer
	name = "The Tinkerer"
	desc = "A machine which is hanging from the ceiling, You can feel it's red eye gaze upon you..."
	icon = 'ModularTegustation/Teguicons/resurgence_64x96.dmi'
	icon_state = "tinker"
	icon_living = "tinker"
	icon_dead = "tinker"
	maxHealth = 5000
	health = 5000
	obj_damage = 0
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.2)
	melee_damage_lower = 0
	melee_damage_upper = 0
	speech_span = SPAN_ROBOT
	pixel_x = -16
	base_pixel_x = -16
	charge = 40
	max_charge = 40
	clan_charge_cooldown = 4 SECONDS

	var/list/attack_action_types = list(/datum/action/cooldown/tinkerer_deploy)

/mob/living/simple_animal/hostile/clan/tinkerer/Initialize(mapload)
	. = ..()
	for(var/action_type in attack_action_types)
		var/datum/action/innate/abnormality_attack/attack_action = new action_type()
		attack_action.Grant(src)

/mob/living/simple_animal/hostile/clan/tinkerer/Move()
	return incorporeal_move



/datum/action/cooldown/tinkerer_deploy
	name = "Retract/Deploy Shell"
	desc = "Switch between your deployed state, and your watcher state."
	icon_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	button_icon_state = "karma_nobg"
	var/retracted = FALSE
	cooldown_time = 3 SECONDS

/datum/action/cooldown/tinkerer_deploy/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/clan/tinkerer))
		return FALSE
	var/mob/living/simple_animal/hostile/clan/tinkerer/T = owner
	StartCooldown()
	if (retracted)
		retracted = FALSE
		T.Deploy()
	else
		retracted = TRUE
		T.Retract()

// Procedure to start the retract
/mob/living/simple_animal/hostile/clan/tinkerer/proc/Retract()
	visible_message(span_warning("[src] retracts into the ceiling!"))
	icon_state = "tinker_u"
	density = FALSE
	SLEEP_CHECK_DEATH(14)
	ChangeResistances(list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	icon_state = "none"
	is_flying_animal = TRUE
	incorporeal_move = TRUE

/mob/living/simple_animal/hostile/clan/tinkerer/proc/Deploy()
	visible_message(span_warning("[src] drops down from the ceiling!"))
	ChangeResistances(list(BRUTE = 1, RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.2))
	icon_state = "tinker_d"
	is_flying_animal = FALSE
	density = TRUE
	incorporeal_move = FALSE
	SLEEP_CHECK_DEATH(14)
	icon_state = "tinker"
