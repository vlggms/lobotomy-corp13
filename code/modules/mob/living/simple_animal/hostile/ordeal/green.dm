// Green dawn
/mob/living/simple_animal/hostile/ordeal/green_bot
	name = "doubt"
	desc = "A slim robot with a spear in place of its hand."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "green_bot"
	icon_living = "green_bot"
	icon_dead = "green_bot_dead"
	faction = list("green_ordeal")
	maxHealth = 400
	health = 400
	speed = 2
	move_to_delay = 4
	melee_damage_lower = 22
	melee_damage_upper = 26
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/green/stab.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/robot = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/robot = 1)

	/// Can't move/attack when it's TRUE
	var/finishing = FALSE

/mob/living/simple_animal/hostile/ordeal/green_bot/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot/AttackingTarget()
	. = ..()
	if(.)
		if(!istype(target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/TH = target
		if(TH.health < 0)
			finishing = TRUE
			TH.Stun(4 SECONDS)
			forceMove(get_turf(TH))
			for(var/i = 1 to 7)
				if(!targets_from.Adjacent(TH) || QDELETED(TH)) // They can still be saved if you move them away
					finishing = FALSE
					return
				TH.attack_animal(src)
				for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
					H.apply_damage(3, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				SLEEP_CHECK_DEATH(2)
			if(!targets_from.Adjacent(TH) || QDELETED(TH))
				finishing = FALSE
				return
			playsound(get_turf(src), 'sound/effects/ordeals/green/final_stab.ogg', 50, 1)
			TH.gib()
			for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
				H.apply_damage(20, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			finishing = FALSE

//Green dawn factory spawn
/mob/living/simple_animal/hostile/ordeal/green_bot/factory
	butcher_results = list()
	guaranteed_butcher_results = list()

/mob/living/simple_animal/hostile/ordeal/green_bot/factory/death(gibbed)
		density = FALSE
		animate(src, alpha = 0, time = 5 SECONDS)
		QDEL_IN(src, 5 SECONDS)
		..()

// Green noon
/mob/living/simple_animal/hostile/ordeal/green_bot_big
	name = "process of understanding"
	desc = "A big robot with a saw and a machinegun in place of its hands."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "green_bot"
	icon_living = "green_bot"
	icon_dead = "green_bot_dead"
	faction = list("green_ordeal")
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 900
	health = 900
	speed = 3
	move_to_delay = 6
	melee_damage_lower = 22 // Full damage is done on the entire turf of target
	melee_damage_upper = 26
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/effects/ordeals/green/saw.ogg'
	ranged = 1
	rapid = 8
	rapid_fire_delay = 3
	projectiletype = /obj/projectile/bullet/c9x19mm
	projectilesound = 'sound/effects/ordeals/green/fire.ogg'
	deathsound = 'sound/effects/ordeals/green/noon_dead.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/robot = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/robot = 1)

	/// Can't move/attack when it's TRUE
	var/reloading = FALSE
	/// When at 10 - it will start "reloading"
	var/fire_count = 0

/mob/living/simple_animal/hostile/ordeal/green_bot_big/CanAttack(atom/the_target)
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/Move()
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/OpenFire(atom/A)
	if(reloading)
		return FALSE
	fire_count += 1
	if(fire_count >= 6)
		StartReloading()
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/AttackingTarget()
	. = ..()
	if(.)
		if(!istype(target, /mob/living))
			return
		var/turf/T = get_turf(target)
		for(var/i = 1 to 4)
			if(!T)
				return
			new /obj/effect/temp_visual/saw_effect(T)
			for(var/mob/living/L in T.contents)
				if(faction_check_mob(L))
					continue
				L.apply_damage(8, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/ordeal/green_bot_big/proc/StartReloading()
	reloading = TRUE
	icon_state = "green_bot_reload"
	playsound(get_turf(src), 'sound/effects/ordeals/green/cooldown.ogg', 50, FALSE)
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/green_noon_reload(get_turf(src))
		SLEEP_CHECK_DEATH(8)
	fire_count = 0
	reloading = FALSE
	icon_state = icon_living

//Green noon factory spawn
/mob/living/simple_animal/hostile/ordeal/green_bot_big/factory
	butcher_results = list()
	guaranteed_butcher_results = list()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/factory/death(gibbed)
		density = FALSE
		animate(src, alpha = 0, time = 5 SECONDS)
		QDEL_IN(src, 5 SECONDS)
		..()

// Green dusk
/mob/living/simple_animal/hostile/ordeal/green_dusk
	name = "where we must reach"
	desc = "A factory-like structure, constantly producing ancient robots."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "green_dusk"
	icon_living = "green_dusk"
	icon_dead = "green_dusk_dead"
	bound_width = 64 // 2x1
	faction = list("green_ordeal")
	maxHealth = 2500
	health = 2500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/robot = 2)

	var/spawn_progress = 10
	var/list/spawned_mobs = list()

/mob/living/simple_animal/hostile/ordeal/green_dusk/Initialize()
	..()
	update_icon()

/mob/living/simple_animal/hostile/ordeal/green_dusk/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_dusk/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_dusk/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	update_icon()
	if(length(spawned_mobs) >= 9)
		return
	if(spawn_progress < 20)
		spawn_progress += 1
		return
	flick("green_dusk_create", src)
	spawn_progress = -5 // Basically, puts us on a tiny cooldown
	visible_message("<span class='danger'>\The [src] produces a new set of robots!</span>")
	for(var/i = 1 to 3)
		var/turf/T = get_step(get_turf(src), pick(0, EAST))
		var/picked_mob = pick(/mob/living/simple_animal/hostile/ordeal/green_bot/factory, /mob/living/simple_animal/hostile/ordeal/green_bot_big/factory)
		var/mob/living/simple_animal/hostile/ordeal/nb = new picked_mob(T)
		spawned_mobs += nb
		if(ordeal_reference)
			nb.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nb

/mob/living/simple_animal/hostile/ordeal/green_dusk/update_overlays()
	. = ..()
	if(spawn_progress <= 0 || stat == DEAD)
		cut_overlays()
		return

	var/mutable_appearance/progress_overlay = mutable_appearance(icon, "progress_1")
	switch(spawn_progress)
		if(1 to 4)
			progress_overlay.icon_state = "progress_1"
		if(5 to 8)
			progress_overlay.icon_state = "progress_2"
		if(9 to 12)
			progress_overlay.icon_state = "progress_3"
		if(13 to INFINITY)
			progress_overlay.icon_state = "progress_4"

	. += progress_overlay
