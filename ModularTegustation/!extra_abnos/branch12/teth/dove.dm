//Very simple, funny little guy.
/mob/living/simple_animal/hostile/abnormality/branch12/dove
	name = "Vow of a Dove"
	desc = "What seems to be a short squat bird."
	icon = 'ModularTegustation/Teguicons/branch12/64x64.dmi'
	icon_state = "dove"
	icon_living = "dove"
	pixel_x = -16
	base_pixel_x = -16
	del_on_death = TRUE
	maxHealth = 1000	//should be a little tankier as it's a bit slow
	health = 1000
	rapid_melee = 2
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 14
	melee_damage_upper = 14
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bites"
	attack_sound = 'sound/abnormalities/cleave.ogg'
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 25, 30, 30),
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 55, 60),
	)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/departure,
		/datum/ego_datum/armor/branch12/departure,
	)
	//gift_type =  /datum/ego_gifts/departure
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


/mob/living/simple_animal/hostile/abnormality/branch12/dove/AttackingTarget(atom/attacked_target)
	. = ..()
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/L = attacked_target
		L.apply_lc_bleed(15)

/mob/living/simple_animal/hostile/abnormality/branch12/dove/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) <40)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/dove/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return
