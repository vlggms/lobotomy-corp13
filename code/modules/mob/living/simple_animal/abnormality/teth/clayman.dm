/mob/living/simple_animal/hostile/abnormality/clayman
	name = "Generic Brand Modelling Clay"
	desc = "A small, rough humanoid figure made of clay."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bluro"
	icon_living = "bluro"
	icon_dead = "bluro"
	portrait = "bluro"
	del_on_death = TRUE
	maxHealth = 1000
	health = 1000
	ranged = TRUE
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 3
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_lower = 10
	melee_damage_upper = 12
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/effects/hit_kick.ogg'
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 50, 50, 50),
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 50, 50, 50),
	)
	work_damage_amount = 0
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	death_message = "loses form."
	ego_list = list(
		/datum/ego_datum/weapon/clayman,
		/datum/ego_datum/armor/clayman,
	)
	var/dashready = TRUE
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

/mob/living/simple_animal/hostile/abnormality/clayman/WorktickFailure(mob/living/carbon/human/user)
	var/list/damtypes = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	var/damage = pick(damtypes)
	work_damage_type = damage
	user.deal_damage(6, damage)
	WorkDamageEffect()

/mob/living/simple_animal/hostile/abnormality/clayman/CanAttack(atom/the_target)
	melee_damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/clayman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/clayman/proc/Skitter()
	visible_message(span_warning("[src] Skitters faster!"), span_notice("you hear the patter of hundreds of clay feet"))
	var/duration = 3 SECONDS
	TemporarySpeedChange(-2, duration)
	dashready = FALSE
	addtimer(CALLBACK(src, PROC_REF(dashreset)), 15 SECONDS)

/mob/living/simple_animal/hostile/abnormality/clayman/OpenFire(atom/A)
	if(get_dist(src, target) >= 3 && dashready)
		Skitter()

/mob/living/simple_animal/hostile/abnormality/clayman/proc/dashreset()
	dashready = TRUE
