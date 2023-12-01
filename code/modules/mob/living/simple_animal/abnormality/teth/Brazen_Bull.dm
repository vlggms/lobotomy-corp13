#define STATUS_EFFECT_BURN /datum/status_effect/stacking/burn

/mob/living/simple_animal/hostile/abnormality/Brazen_Bull
	name = "Brazen Bull"
	desc = "A bull made of an copper and zinc alloy with someone trapped inside it"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "Bull"
	icon_living = "Bull"
	maxHealth = 950
	move_to_delay = 1.5
	health = 950
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 2)
	melee_damage_lower = 2
	melee_damage_upper = 4
	melee_damage_type = RED_DAMAGE
	rapid_melee = 2.5
	stat_attack = HARD_CRIT
	attack_sound = 'sound/items/crowbar.ogg'
	attack_verb_continuous = "smacks"
	attack_verb_simple = "smack"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(20, 20, 20, 30, 30),
						ABNORMALITY_WORK_INSIGHT = list(40, 40, 50, 50, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(20, 25, 30, 30, 35),
						ABNORMALITY_WORK_REPRESSION = list(35, 35, 40, 40, 50)
						)
	work_damage_amount = 3
	work_damage_type = RED_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/capote,
		/datum/ego_datum/armor/capote
		)
	gift_type = /datum/ego_gifts/capote

	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	/mob/living/simple_animal/hostile/abnormality/Brazen_Bull/FailureEffect(mob/living/carbon/human/user, work_type, pe)
		datum_reference.qliphoth_change(-1)

	/mob/living/simple_animal/hostile/abnormality/Brazen_Bull/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
		if(prob(60))
			datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/Brazen_Bull/AttackingTarget()
	if(prob(15))
		var/mob/living/L = target
		var/datum/status_effect/stacking/burn/G = L.has_status_effect(/datum/status_effect/stacking/burn)
		if(!G)
			L.apply_status_effect(STATUS_EFFECT_BURN)
		else
			G.add_stacks(1)


/mob/living/simple_animal/hostile/abnormality/Brazen_Bull/BreachEffect(mob/living/carbon/human/user)
		..()
		GiveTarget(user)



/datum/status_effect/stacking/burn
	id = "burn"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 60 SECONDS
	stack_decay = 1
	tick_interval = 3 SECONDS
	max_stacks = 6
	stacks = 1
	alert_type = /atom/movable/screen/alert/status_effect/burn

/datum/status_effect/stacking/burn/before_remove()
	owner.apply_damage(1 * stacks , RED_DAMAGE, null, owner.run_armor_check(null, RED_DAMAGE))

/atom/movable/screen/alert/status_effect/burn
	name = "Burn"
	desc = "You feel like you're being cooked alive"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "lc_burn"


#undef STATUS_EFFECT_BURN

