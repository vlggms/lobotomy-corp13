/mob/living/simple_animal/hostile/ordeal/green_bot_big
	name = "process of understanding"
	desc = "A big robot with a saw and a machine gun in place of its hands."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "green_bot"
	icon_living = "green_bot"
	icon_dead = "green_bot_dead"
	faction = list("green_ordeal")
	pixel_x = -8
	base_pixel_x = -8
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 300
	health = 300
	speed = 3
	move_to_delay = 6
	melee_damage_lower = 8 // Full damage is done on the entire turf of target
	melee_damage_upper = 10
	attack_verb_continuous = "saws"
	attack_verb_simple = "saw"
	attack_sound = 'sound/effects/ordeals/green/saw.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	ranged = 1
	rapid = 5
	rapid_fire_delay = 2
	ranged_cooldown_time = 15
	check_friendly_fire = TRUE //stop shooting each other
	projectiletype = /obj/projectile/bullet/c9x19mm/greenbot
	projectilesound = 'sound/effects/ordeals/green/fire.ogg'
	death_sound = 'sound/effects/ordeals/green/noon_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	silk_results = list(/obj/item/stack/sheet/silk/green_advanced = 1,
						/obj/item/stack/sheet/silk/green_simple = 2)

	/// Can't move/attack when it's TRUE
	var/reloading = FALSE
	var/firing_time = 0
	var/firing_cooldown = 1.2
	/// When at 12 - it will start "reloading"
	var/fire_count = 0

/mob/living/simple_animal/hostile/ordeal/green_bot_big/CanAttack(atom/the_target)
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/Move()
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/Goto(target, delay, minimum_distance)
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/DestroySurroundings()
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/OpenFire(atom/A)
	if(reloading)
		return FALSE
	firing_time = world.time
	fire_count += 1
	if(fire_count >= 12)
		StartReloading()
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot_big/AttackingTarget(atom/attacked_target)
	if(reloading)
		return FALSE
	if(world.time < firing_time + firing_cooldown SECONDS)
		return FALSE
	. = ..()
	if(.)
		if(!istype(attacked_target, /mob/living))
			return
		var/turf/T = get_turf(attacked_target)
		if(!T)
			return
		for(var/i = 1 to 4)
			if(!T)
				return
			new /obj/effect/temp_visual/saw_effect(T)
			HurtInTurf(T, list(), 4, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
			SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/ordeal/green_bot_big/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/green_bot_big/spawn_dust()
	return

/mob/living/simple_animal/hostile/ordeal/green_bot_big/proc/StartReloading()
	reloading = TRUE
	icon_state = "green_bot_reload"
	playsound(get_turf(src), 'sound/effects/ordeals/green/cooldown.ogg', 50, FALSE)
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/green_noon_reload(get_turf(src))
		SLEEP_CHECK_DEATH(6)
	fire_count = 0
	reloading = FALSE
	icon_state = icon_living
