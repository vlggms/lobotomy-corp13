//Clan Member: Scout
/mob/living/simple_animal/hostile/clan/stone_guard
	name = "stone statue"
	desc = "A humanoid looking statue wielding a spear... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "stone_guard"
	icon_living = "stone_guard"
	icon_dead = "stone_guard_dead"
	maxHealth = 1000
	health = 1000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	ranged = TRUE
	var/attack_tremor = 3
	var/can_act = TRUE
	var/ability_damage = 40
	var/ability_cooldown
	var/ability_cooldown_time = 10 SECONDS
	var/ability_range = 5
	var/ability_delay = 0.5 SECONDS

/mob/living/simple_animal/hostile/clan/stone_guard/ChargeUpdated()
	if(charge > 6)
		ChangeResistances(list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.8))
	else
		ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))
		return

/mob/living/simple_animal/hostile/clan/stone_guard/Move()
	if(!can_act)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/clan/stone_guard/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	. = ..()
	if(isliving(target))
		var/mob/living/victim = target
		victim.apply_lc_tremor(attack_tremor, 55)
	if(world.time > ability_cooldown)
		var/turf/target_turf = get_turf(attacked_target)
		for(var/i = 1 to ability_range - 2)
			target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
		RangedAbility(target_turf)

/mob/living/simple_animal/hostile/clan/stone_guard/OpenFire()
	if(!can_act)
		return
	if(get_dist(get_turf(src), get_turf(target)) > (ability_range - 1))
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	dir = dir_to_target
	RangedAbility(target)

/mob/living/simple_animal/hostile/clan/stone_guard/proc/RangedAbility(atom/target)
	if(!can_act)
		return
	if(world.time < ability_cooldown)
		return
	can_act = FALSE
	ability_cooldown = world.time + ability_cooldown_time
	var/turf/T = get_ranged_target_turf_direct(src, get_turf(target), ability_range, rand(-10,10))
	var/list/turf_list = list()
	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, FALSE, 5)
	for(var/turf/TT in getline(src, T))
		if(TT.density)
			break
		new /obj/effect/temp_visual/cult/sparks(TT)
		turf_list += TT
		T = TT
	if(!LAZYLEN(turf_list))
		can_act = TRUE
		return
	for(var/i = 1 to 3)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		D.alpha = 100
		D.pixel_x = base_pixel_x + rand(-8, 8)
		D.pixel_y = base_pixel_y + rand(-8, 8)
		animate(D, alpha = 0, transform = matrix()*1.2, time = 8)
		SLEEP_CHECK_DEATH(0.15 SECONDS)
	SLEEP_CHECK_DEATH(ability_delay)
	playsound(src, 'sound/weapons/fixer/hana_pierce.ogg', 75, FALSE, 5)
	for(var/turf/TT in turf_list)
		var/obj/effect/temp_visual/thrust/AoE = new(T, COLOR_GRAY)
		var/matrix/M = matrix(AoE.transform)
		M.Turn(Get_Angle(src, T)-90)
		AoE.transform = M
		var/hit_target = FALSE
		for(var/mob/living/L in HurtInTurf(TT, list(), ability_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE))
			hit_target = TRUE
			var/datum/status_effect/stacking/lc_tremor/tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
			if(tremor)
				tremor.TremorBurst()
		if(!hit_target)
			charge = 0
			ChargeUpdated()
	can_act = TRUE
