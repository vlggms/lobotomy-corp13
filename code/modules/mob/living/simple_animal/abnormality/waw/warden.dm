/mob/living/simple_animal/hostile/abnormality/warden
	name = "The Warden"
	desc = "An abnormality that takes the form of a fleshy stick wearing a dress and eyes. You don't want to know what's under that dress."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "warden"
	icon_living = "warden"
	icon_dead = "warden_dead"
	portrait = "warden"
	maxHealth = 2100
	health = 2100
	pixel_x = -8
	base_pixel_x = -8
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5)

	move_to_delay = 4
	melee_damage_lower = 70
	melee_damage_upper = 70
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claws"
	del_on_death = FALSE
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 15,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/correctional,
		/datum/ego_datum/armor/correctional,
	)
	gift_type =  /datum/ego_gifts/correctional
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK
	var/finishing = FALSE

/mob/living/simple_animal/hostile/abnormality/warden/AttackingTarget()
	. = ..()
	if(.)
		if(finishing)
			return FALSE
		if(!istype(target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = target

		if(H.health < 0)

			finishing = TRUE
			icon_state = "warden_attack"
			playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 50, 1)
			SLEEP_CHECK_DEATH(5)

			//Takes your skin and leaves your bone. You are now a flesh servant under her skirt in GBJ
			H.dust()

			// it gets faster.
			if(move_to_delay>1)
				SpeedChange(-move_to_delay*0.25)
				if(melee_damage_lower > 30)
					melee_damage_lower -=5

			adjustBruteLoss(-(maxHealth*0.2)) // Heals 20% HP, fuck you that's why. Still not as bad as judgement or big bird
			update_simplemob_varspeed()

			finishing = FALSE
			icon_state = "warden"

/mob/living/simple_animal/hostile/abnormality/warden/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/warden/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/warden/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/warden/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/warden/bullet_act(obj/projectile/P)
	visible_message(span_userdanger("[src] is unfazed by \the [P]!"))
	P.Destroy()
