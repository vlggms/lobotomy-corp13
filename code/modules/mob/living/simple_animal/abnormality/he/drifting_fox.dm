/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A large fox with torn umbrellas lodged in its back."
	icon = 'placeholder'
	icon_state = "fox_placeholder"
	icon_living = "fox_placeholder"
	icon_dead = "fox_placeholder_dead"
	deathmessage = "collapses into a puddle of water"
	deathsound = "sound/abnormalities/drifting_fox/placeholdersplash.ogg" // Need to make a sound file for this.
	del_on_death = FALSE
	pixel_x = 0
	base_pixel_x = 0 // Need to figure out what base pixel and pixel X do.
	maxHealth = 1000
	health = 1000
	rapid_melee = 3 // Speed and health may also need adjustment, confer with others before commiting.
	move_to_delay = 2.5
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5 )
	melee_damage_lower = 15
	melee_damage_upper = 20
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = "fox_placeholder_attack" // Need to make a sound file for this as well.
	attack_verb_simple = "thwack"
	attack_verb_continuous = "thwacks"
	speak_chance = 2
	emote_see = list("*pained whine*")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 40,
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = list(60,65,70,75,85),
						ABNORMALITY_WORK_REPRESSION	= 0,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	ego_list = list(
		/datum/ego_datum/weapon/sunshower
		/datum/ego_datum/armor/sunshower
	)
	gift_type = /datum/ego_gifts/sunshower // NEED TO ACTAULLY MAKE THE GIFT / EGOS

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	// "borrowed" from forsaken murderers code to give a punishment for failing to do well.
/mob/living/simple_animal/hostile/abnormality/scarecrow/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) =< 60)
		datum_reference.qliphoth_change(-1)
	return
/mob/living/simple_animal/hostile/abnormality/drifting_fox/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/abnormality/drifting_fox/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/abnormality/drifting_fox/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/update_icon_state()
if(status_flags & GODMODE)
	// Not breaching
		icon_living = initial(icon)
		icon_state = icon_living
	else if(stat == DEAD)
		icon_state = icon_dead
	else
		icon_living = "drifting_fox_breached"
		icon_state = icon_living
