//Sound of a Star
/mob/living/simple_animal/hostile/ordeal/echo/star
	icon_state = "star_echo"
	icon_living = "star_echo"
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 80
	melee_damage_upper = 80
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.6)

	rapid = 5
	rapid_fire_delay = 2
	ranged_cooldown_time = 5
	retreat_distance = 4
	minimum_distance = 1
	ranged = TRUE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	projectiletype = /obj/projectile/ego_bullet/ego_star/echo
	projectilesound = 'sound/weapons/ego/star.ogg'
	attack_sound = 'sound/weapons/ego/hammer.ogg'

/mob/living/simple_animal/hostile/ordeal/echo/star/OpenFire(target)
	..()
	if(prob(20))
		Ding()
		return

/mob/living/simple_animal/hostile/ordeal/echo/star/proc/Ding()
	icon_state = "star_echo_ding"
	can_act = FALSE
	SLEEP_CHECK_DEATH(3 SECONDS)
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 100, FALSE, 40, falloff_distance = 10)
	for(var/mob/living/carbon/human/H in range(10, src))
		H.apply_damage(80, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		if(H.sanity_lost)
			H.death()
			animate(H, transform = H.transform*0.01, time = 5)
			QDEL_IN(H, 5)
	icon_state = "star_echo"
	can_act = TRUE

/obj/projectile/ego_bullet/ego_star/echo
	damage = 40 // Big damage

/obj/projectile/ego_bullet/ego_star/echo/on_hit(target)
	..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.sanity_lost)
		H.death()
		animate(H, transform = H.transform*0.01, time = 5)
		QDEL_IN(H, 5)

