// White ordeal mobs, other than Claw
/mob/living/simple_animal/hostile/ordeal/black_fixer
	name = "Black Fixer"
	desc = "A humanoid creature wrapped in bandages."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "fixer_b"
	icon_living = "fixer_b"
	faction = list("Head")
	maxHealth = 3000
	health = 3000
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	ranged = TRUE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.0, PALE_DAMAGE = 0.5)
	move_resist = MOVE_FORCE_OVERPOWERING
	projectiletype = /obj/projectile/black
	attack_sound = 'sound/weapons/ego/hammer.ogg'

	var/busy = FALSE
	var/pulse_cooldown
	var/pulse_cooldown_time = 15 SECONDS
	var/pulse_damage = 15 // Dealt consistently across the entire room
	var/hammer_cooldown
	var/hammer_cooldown_time = 8 SECONDS
	var/hammer_damage = 135
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/ordeal/black_fixer/Initialize()
	..()
	pulse_cooldown = world.time + pulse_cooldown_time

/mob/living/simple_animal/hostile/ordeal/black_fixer/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!busy && pulse_cooldown < world.time)
		PulseAttack()

/mob/living/simple_animal/hostile/ordeal/black_fixer/Move()
	if(busy)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/black_fixer/AttackingTarget()
	//If he doesn't attack for about 10 seconds - pulse.
	if(busy)
		return
	..()
	pulse_cooldown = world.time + (pulse_cooldown_time * 0.6)
	if(prob(30) && hammer_cooldown < world.time)
		HammerAttack(target)

/mob/living/simple_animal/hostile/ordeal/black_fixer/OpenFire()
	if(busy)
		return
	if(prob(25) && (get_dist(src, target) < 10) && (hammer_cooldown < world.time))
		HammerAttack(target)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/black_fixer/proc/PulseAttack()
	icon_state = "fixer_b_attack"
	busy = TRUE
	playsound(src, 'sound/effects/ordeals/white/black_ability_start.ogg', 100, FALSE, 10)
	SLEEP_CHECK_DEATH(6)
	playsound(src, 'sound/effects/ordeals/white/black_ability.ogg', 75, FALSE, 15)
	for(var/i = 1 to 10)
		new /obj/effect/temp_visual/black_fixer_ability(get_turf(src))
		for(var/mob/living/L in livinginview(20, src))
			if(faction_check_mob(L))
				continue
			new /obj/effect/temp_visual/revenant(get_turf(L))
			L.apply_damage(pulse_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		SLEEP_CHECK_DEATH(2.8) // In total we wait for 2.8 seconds
	playsound(src, 'sound/effects/ordeals/white/black_ability_end.ogg', 100, FALSE, 30)
	for(var/obj/machinery/computer/abnormality/A in urange(24, src))
		if(prob(66) && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-1, -2))
	icon_state = icon_living
	SLEEP_CHECK_DEATH(5)
	pulse_cooldown = world.time + pulse_cooldown_time
	busy = FALSE

/mob/living/simple_animal/hostile/ordeal/black_fixer/proc/HammerAttack(target)
	if(hammer_cooldown > world.time)
		return
	hammer_cooldown = world.time + hammer_cooldown_time
	busy = TRUE
	been_hit = list()
	visible_message("<span class='warning'>[src] raises their hammer high above the ground!</span>")
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, 14, rand(-15,15))
	var/list/turfs_to_hit = getline(src, target_turf)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		new /obj/effect/temp_visual/cult/sparks(T) // Prepare yourselves
	SLEEP_CHECK_DEATH(2)
	playsound(get_turf(src), 'sound/effects/ordeals/white/black_swing.ogg', 75, 5)
	SLEEP_CHECK_DEATH(3)
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 100, 20)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		for(var/turf/open/TT in range(1, T))
			new /obj/effect/temp_visual/small_smoke/halfsecond(TT)
			for(var/mob/living/L in TT)
				if(L in been_hit)
					continue
				if(faction_check_mob(L))
					continue
				been_hit += L
				L.apply_damage(hammer_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		sleep(1)
	SLEEP_CHECK_DEATH(4)
	busy = FALSE

/obj/projectile/black
	name = "kunai"
	icon_state = "blackfixer"
	hitsound = 'sound/effects/ordeals/white/black_kunai.ogg'
	damage = 30
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
