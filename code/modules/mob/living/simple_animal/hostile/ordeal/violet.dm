// Violet dawn
/mob/living/simple_animal/hostile/ordeal/violet_fruit
	name = "fruit of understanding"
	desc = "A round purple creature. It is constantly leaking mind-damaging gas."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "violet_fruit"
	icon_living = "violet_fruit"
	icon_dead = "violet_fruit_dead"
	base_pixel_x = -8
	pixel_x = -8
	faction = list("violet_ordeal")
	maxHealth = 250
	health = 250
	speed = 4
	move_to_delay = 5
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/fruit = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/fruit = 1)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	blood_volume = BLOOD_VOLUME_NORMAL

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/ReleaseDeathGas), rand(60 SECONDS, 80 SECONDS))

/mob/living/simple_animal/hostile/ordeal/violet_fruit/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	new /obj/effect/temp_visual/revenant/cracks(get_turf(src))
	for(var/mob/living/carbon/human/H in view(7, src))
		new /obj/effect/temp_visual/revenant(get_turf(H))
		H.apply_damage(6, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
	return TRUE

/mob/living/simple_animal/hostile/ordeal/violet_fruit/proc/ReleaseDeathGas()
	if(stat == DEAD)
		return
	var/turf/target_c = get_turf(src)
	var/list/turf_list = spiral_range_turfs(24, target_c)
	visible_message("<span class='danger'>[src] releases a stream of nauseating gas!</span>")
	playsound(target_c, 'sound/effects/ordeals/violet/fruit_suicide.ogg', 50, 1, 16)
	adjustWhiteLoss(maxHealth) // Die
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/carbon/human/H in livinginrange(24, target_c))
		H.apply_damage(33, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
	for(var/obj/machinery/computer/abnormality/A in urange(24, target_c))
		if(prob(66) && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-1, -2))

// Violet noon
/mob/living/simple_animal/hostile/ordeal/violet_monolith
	name = "grant us love"
	desc = "A dark monolith structure with incomprehensible writing on it."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "violet_noon"
	icon_living = "violet_noon"
	icon_dead = "violet_noon_dead"
	base_pixel_x = -8
	pixel_x = -8
	faction = list("violet_ordeal")
	maxHealth = 1400
	health = 1400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)

	var/next_pulse = INFINITY

/mob/living/simple_animal/hostile/ordeal/violet_monolith/Initialize()
	..()
	next_pulse = world.time + 30 SECONDS
	addtimer(CALLBACK(src, .proc/FallDown))

/mob/living/simple_animal/hostile/ordeal/violet_monolith/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_monolith/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_monolith/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(icon_state != "violet_noon_attack")
		return
	if(world.time > next_pulse)
		PulseAttack()
		return
	for(var/mob/living/L in view(2, src))
		if(!faction_check_mob(L))
			L.apply_damage(9, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))

/mob/living/simple_animal/hostile/ordeal/violet_monolith/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/ordeal/violet_monolith/proc/FallDown()
	pixel_z = 128
	alpha = 0
	density = FALSE
	animate(src, pixel_z = 0, alpha = 255, time = 10)
	SLEEP_CHECK_DEATH(10)
	density = TRUE
	visible_message("<span class='danger'>[src] falls down on the ground!</span>")
	playsound(get_turf(src), 'sound/effects/ordeals/violet/monolith_down.ogg', 65, 1)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)
	for(var/turf/open/T in view(4, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in view(4, src))
		if(!faction_check_mob(L))
			var/distance_decrease = get_dist(src, L) * 20
			L.apply_damage((150 - distance_decrease), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			if(L.health < 0)
				L.gib()
	SLEEP_CHECK_DEATH(5)
	icon_state = "violet_noon_attack"

/mob/living/simple_animal/hostile/ordeal/violet_monolith/proc/PulseAttack()
	next_pulse = world.time + 15 SECONDS
	icon_state = "violet_noon_ability"
	for(var/i = 1 to 3)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 7)
		SLEEP_CHECK_DEATH(8)
	var/obj/machinery/computer/abnormality/CA
	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/A in urange(24, src))
		if(!A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			potential_computers += A
	if(LAZYLEN(potential_computers))
		CA = pick(potential_computers)
		CA.datum_reference.qliphoth_change(-1)
	icon_state = "violet_noon_attack"
