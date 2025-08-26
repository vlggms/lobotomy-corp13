//Violet noon
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
	maxHealth = 440
	health = 440
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)

	var/next_pulse = INFINITY

/mob/living/simple_animal/hostile/ordeal/violet_monolith/Initialize()
	. = ..()
	next_pulse = world.time + 30 SECONDS
	addtimer(CALLBACK(src, PROC_REF(FallDown)))

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
			new /obj/effect/temp_visual/revenant(get_turf(L))
			L.apply_damage(3, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))

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
	visible_message(span_danger("[src] drops down from the ceiling!"))
	playsound(get_turf(src), 'sound/effects/ordeals/violet/monolith_down.ogg', 65, 1)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)
	for(var/turf/open/T in view(4, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in view(4, src))
		if(!faction_check_mob(L))
			var/distance_decrease = get_dist(src, L) * 10
			L.apply_damage((60 - distance_decrease), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
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
		if(A.can_meltdown && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			potential_computers += A
	if(LAZYLEN(potential_computers))
		CA = pick(potential_computers)
		CA.datum_reference.qliphoth_change(-1)
	icon_state = "violet_noon_attack"
