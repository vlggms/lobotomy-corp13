/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A light brown, shaggy fox. It has glowing yellow eyes and in it's mouth is an closed umbrella. Stabbed on the fox's back are multiple open umbrellas."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	del_on_death = FALSE
	maxHealth = 1200
	health = 1200
	speed = 5
	move_to_delay = 6
	rapid_melee = 2
	stop_automated_movement_when_pulled = TRUE
	move_resist = MOVE_FORCE_NORMAL + 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 25, 30, 35, 40),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 0,
			)

		damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	melee_damage_lower = 15
	melee_damage_upper = 35 //has a wide range, he can critically hit you
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "slices" //TD
	attack_verb_simple = "stabs" // TD
	attack_sound = 'sound/abnormalities/porccubus/porccu_attack.ogg' // TD
	can_breach = TRUE
	start_qliphoth = 3
	threat_level = HE_LEVEL

	faction = list("hostile")
	ego_list = list(
		/datum/ego_datum/weapon/sunshower,
		/datum/ego_datum/armor/sunshower
		)
	gift_type =  /datum/ego_gifts/sunshower
	gift_message = "Luck follows only to those truly kind."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/*
Umbrella
	- Spawned simplemob which attacks nearby targets and applies black armor debuff (0.2 should suffice)
*/
/*
SpinAttack
	- Static AOE spinattack in which the fox either Fox.SpinAnimation() or does big AOE effect.. both with medium-big black damage attached
*/

	// both not finished
	var/umbrella_cooldown_time = 30 SECONDS
	var/umbrella_cooldown
	var/spinattack_cooldown_time = 15 SECONDS
	var/spinattack_cooldown

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, ATTACHMENT_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(75)))
	return ..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/OpenFire()
	if(!target)
		return
	FoxUmbrella(target)

/mob/living/simple_animal/hostile/abnormality/drifting_fox/proc/FoxUmbrella(mob/living/carbon/human/user)
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	manual_emote("whines in pain.")
	SLEEP_CHECK_DEATH(2)
		new /mob/living/simple_animal/hostile/umbrella(get_step(src, EAST))
		new /mob/living/simple_animal/hostile/umbrella(get_step(src, WEST))
	SLEEP_CHECK_DEATH(2)

/mob/living/simple_animal/hostile/umbrella
	name = "Umbrella"
	desc = "An old and worn out umbrella."
	icon_state = "umbrella"
	icon_living = "umbrella"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	maxHealth = 125
	health = 125
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
