//Mimicry
//Overview:
//The mimicry echo does good damage, has good resistances.
//Generally it tends to heal over time as well as can Goodbye


/mob/living/simple_animal/hostile/ordeal/echo/mimicry
	icon_state = "mimicry_echo"
	icon_living = "mimicry_echo"
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 100
	melee_damage_upper = 100
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.4)

	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	attack_sound =  'sound/abnormalities/nothingthere/attack.ogg'
	var/goodbye_damage = 300

/mob/living/simple_animal/hostile/ordeal/echo/mimicry/AttackingTarget()
	if(prob(20))
		Goodbye()
		return
	. = ..()
	if(isliving(target))
		adjustBruteLoss(-(maxHealth/5))

/mob/living/simple_animal/hostile/ordeal/echo/mimicry/proc/Goodbye()	//Just a simple goodbye.
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, 0, 5)
	icon_state = "mimicry_echo_goodbye"
	can_act = FALSE
	SLEEP_CHECK_DEATH(2 SECONDS)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/nt_goodbye(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(goodbye_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			if(L.health < 0)
				L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 7)
	SLEEP_CHECK_DEATH(2 SECONDS)
	can_act = TRUE
	icon_state = "mimicry_echo"

/mob/living/simple_animal/hostile/ordeal/echo/mimicry/Life()
	..()
	adjustBruteLoss(-1) //Heals slightly

