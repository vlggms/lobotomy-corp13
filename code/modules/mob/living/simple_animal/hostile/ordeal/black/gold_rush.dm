//Gold Rush
/mob/living/simple_animal/hostile/ordeal/echo/gold
	icon_state = "goldrush_echo"
	icon_living = "goldrush_echo"
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 322
	melee_damage_upper = 322
	rapid_melee = 1
	ranged = TRUE
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1)

	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	attack_sound = 'sound/weapons/fixer/generic/gen2.ogg'

/mob/living/simple_animal/hostile/ordeal/echo/gold/MeleeAction()
	Stun(5)
	SLEEP_CHECK_DEATH(5)
	if(!Adjacent(target))
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/echo/gold/ComponentInitialize()
	..()
	AddComponent(/datum/component/knockback, 3, FALSE, FALSE)


/mob/living/simple_animal/hostile/ordeal/echo/gold/OpenFire()
	var/obj/effect/qoh_sygil/kog/B = new(get_turf(src))
	SLEEP_CHECK_DEATH(10)
	var/obj/effect/qoh_sygil/kog/C = new(get_turf(target))
	forceMove(get_turf(C))
	playsound(src, 'sound/abnormalities/hatredqueen/gun.ogg', 65, FALSE, 10)
	SLEEP_CHECK_DEATH(5)

	qdel(B)
	qdel(C)
