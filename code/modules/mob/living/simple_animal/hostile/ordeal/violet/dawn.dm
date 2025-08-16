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
	butcher_results = list(/obj/item/food/meat/slab/fruit = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/fruit = 1)
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	blood_volume = BLOOD_VOLUME_NORMAL
	var/list/enemies = list() //copying retaliate code cause i dont know how else to inherit it

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(ReleaseDeathGas)), rand(60 SECONDS, 65 SECONDS))

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Found(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			return L
		else
			enemies -= L
	else if(ismecha(A))
		var/obj/vehicle/sealed/mecha/M = A
		if(LAZYLEN(M.occupants))
			return A

/mob/living/simple_animal/hostile/ordeal/violet_fruit/ListTargets()
	if(!length(enemies))
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/ordeal/violet_fruit/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS)
		Retaliate()

/mob/living/simple_animal/hostile/ordeal/violet_fruit/proc/Retaliate()
	var/list/around = view(src, vision_range)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(faction_check_mob(M) && attack_same || !faction_check_mob(M))
				enemies |= M
		else if(ismecha(A))
			var/obj/vehicle/sealed/mecha/M = A
			if(LAZYLEN(M.occupants))
				enemies |= M
				enemies |= M.occupants

/mob/living/simple_animal/hostile/ordeal/violet_fruit/AttackingTarget()
	return

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	new /obj/effect/temp_visual/small_smoke/second/fruit(get_turf(src))
	for(var/mob/living/L in view(2, src))
		if(!faction_check_mob(L))
			new /obj/effect/temp_visual/revenant(get_turf(L))
			L.apply_damage(5, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
	return TRUE

/mob/living/simple_animal/hostile/ordeal/violet_fruit/proc/ReleaseDeathGas()
	if(stat == DEAD)
		return
	var/turf/target_c = get_turf(src)
	var/list/turf_list = spiral_range_turfs(15, target_c)
	visible_message(span_danger("[src] releases a cloud of nauseating gas!"))
	playsound(target_c, 'sound/effects/ordeals/violet/fruit_suicide.ogg', 50, 1, 16)
	adjustWhiteLoss(maxHealth) // Die
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/L in livinginrange(15, target_c))
		if(faction_check_mob(L))
			continue
		L.apply_damage(33, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	for(var/obj/machinery/computer/abnormality/A in urange(15, target_c))
		if(A.can_meltdown && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-999))
