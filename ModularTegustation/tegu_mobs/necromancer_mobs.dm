/mob/living/simple_animal/hostile/skeleton/necromancer
	desc = "The creation of a powerful necromancer."
	faction = list("necromancer")
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 18
	melee_damage_upper = 22

/mob/living/simple_animal/hostile/skeleton/necromancer/strong
	desc = "The creation of a powerful necromancer. This one looks a bit tougher."
	maxHealth = 150
	health = 150
	melee_damage_lower = 33
	melee_damage_upper = 36

/mob/living/simple_animal/hostile/skeleton/necromancer/mage
	name = "mage skeleton"
	desc = "A skeleton with a tiny bit more magic put into its revival."
	icon_state = "skeleton_mage"
	icon_living = "skeleton_mage"
	icon_dead = "skeleton_mage"
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	maxHealth = 175
	health = 175
	ranged = 1
	ranged_cooldown_time = 40
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 24
	melee_damage_upper = 28
	retreat_distance = 2
	minimum_distance = 1

/mob/living/simple_animal/hostile/skeleton/necromancer/mage/Initialize()
	. = ..()
	set_light(2)

/mob/living/simple_animal/hostile/skeleton/necromancer/mage/OpenFire()
	var/T = get_turf(target)
	if(!isturf(T))
		return
	if(get_dist(src, T) <= 8)
		visible_message(span_warning("[src] raises its hand in the air as red light appears under [target]!"))
		ranged_cooldown = world.time + ranged_cooldown_time
		var/list/fire_zone = list()
		for(var/i = 0 to 2)
			playsound(T, 'sound/machines/clockcult/stargazer_activate.ogg', 50, 1)
			fire_zone = spiral_range_turfs(i, T) - spiral_range_turfs(i-1, T)
			for(var/turf/open/TC in fire_zone)
				new /obj/effect/temp_visual/cult/turf/floor(TC)
			SLEEP_CHECK_DEATH(1.5)
		SLEEP_CHECK_DEATH(2.5)
		for(var/i = 1 to 3)
			fire_zone = spiral_range_turfs(i, T) - spiral_range_turfs(i-1, T)
			playsound(T, 'sound/machines/clockcult/ark_damage.ogg', 50, TRUE)
			for(var/turf/open/TC in fire_zone)
				new /obj/effect/temp_visual/cult/sparks(TC)
				for(var/mob/living/L in TC)
					if("necromancer" in L.faction)
						continue
					L.apply_damage(25, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
					to_chat(L, span_userdanger("You're hit by a death field!"))
			SLEEP_CHECK_DEATH(1.5)
