/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A light brown, shaggy fox. It has glowing yellow eyes and in it's mouth is an closed umbrella. Stabbed on the fox's back are multiple open umbrellas."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
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
	melee_damage_upper = 35 // stabby stabby into insanity
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "slices" //TD
	attack_verb_simple = "stabs" // TD
	attack_sound = 'sound/abnormalities/porccubus/porccu_attack.ogg' // TD
	can_breach = TRUE
	can_patrol = TRUE
	start_qliphoth = 3
	threat_level = HE_LEVEL

	faction = list("hostile")
	ego_list = list(
		/datum/ego_datum/weapon/sunshower, // TD
		/datum/ego_datum/armor/sunshower // TD
		)
	gift_type =  /datum/ego_gifts/sunshower // Give to the firt person who pet the abno with 40+ TEMPERANCE
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
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(75)))
	return ..()
//breach
/mob/living/simple_animal/hostile/abnormality/drifting_fox/BreachEffect(mob/living/carbon/human/user)
	..()
	playsound(src, 'sound/abnormalities/porccubus/head_explode_laugh.ogg', 50, FALSE, 4)
	icon_living = "fox"
	icon_state = icon_living
	var/turf/T = pick(GLOB.xeno_spawn)
	forceMove(T)
	umbrella_cooldown = world.time + umbrella_cooldown_time
	spinattack_cooldown = world.time + spinattack_cooldown_time

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
	umbrella_cooldown = world.time + umbrella_cooldown_time

/mob/living/simple_animal/hostile/umbrella
	name = "Umbrella"
	desc = "An old and worn out umbrella."
	icon_state = "umbrella"
	icon_living = "umbrella"
	faction = list("hostile")
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	maxHealth = 125
	health = 125
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)

	move_to_delay = 5
	melee_damage_lower = 5
	melee_damage_upper = 20
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	L.apply_status_effect(/datum/status_effect/umbrella_black_debuff)

	attack_sound = 'sound/abnormalities/porccubus/porccu_attack.ogg' // placeholder
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	a_intent = "hostile"
	move_resist = 1500

	can_patrol = TRUE

	del_on_death = FALSE

	/datum/status_effect/umbrella_black_debuff
	id = "umbrella_black_debuff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/umbrella_black_debuff

/datum/status_effect/umbrella_black_debuff/on_apply() // how do I transform this to properly work on humans?
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.black_mod /= 1.5
		return
	var/mob/living/simple_animal/M = owner
	if(M.damage_coeff[BLACK_DAMAGE] <= 0)
		qdel(src)
		return
	M.damage_coeff[BLACK_DAMAGE] += 0.5

/datum/status_effect/umbrella_black_debuff/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.black_mod *= 1.5
		return
	var/mob/living/simple_animal/M = owner
	M.damage_coeff[BLACK_DAMAGE] -= 0.5

/atom/movable/screen/alert/status_effect/umbrella_black_debuff
	name = "False Kindness"
	desc = "Your half hearted actions have made you more vulnerable to BLACK attacks."
	icon = 'icons/mob/actions/actions_ability.dmi'
	icon_state = "falsekindness"

/mob/living/simple_animal/hostile/umbrella/death(gibbed)
	visible_message("<span class='notice'>[src] falls to the ground, closing in process!</span>")
	. = ..()
	gib(TRUE, TRUE, TRUE)
	return
