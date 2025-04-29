//Stone Guard
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
	melee_damage_lower = 14
	melee_damage_upper = 18
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/weapons/fixer/generic/spear2.ogg'
	ranged = TRUE
	charge = 5
	max_charge = 30
	clan_charge_cooldown = 0.5 SECONDS
	var/attack_tremor = 3
	var/can_act = TRUE
	var/ability_damage = 40
	var/ability_cooldown
	var/ability_cooldown_time = 10 SECONDS
	var/ability_range = 5
	var/ability_delay = 0.5 SECONDS
	var/stun_duration = 5 SECONDS

/mob/living/simple_animal/hostile/clan/stone_guard/ChargeUpdated()
	if(charge <= 1 && can_act)
		stagger()
	if(charge >= 15)
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

/mob/living/simple_animal/hostile/clan/stone_guard/adjustHealth(amount, updating_health, forced)
	. = ..()
	if(amount > 0 && charge > 0)
		charge -= 1

/mob/living/simple_animal/hostile/clan/stone_guard/proc/stagger()
	can_act = FALSE
	playsound(src, 'sound/weapons/ego/devyat_overclock_death.ogg', 50, FALSE, 5)
	var/mutable_appearance/colored_overlay = mutable_appearance('ModularTegustation/Teguicons/tegumobs.dmi', "small_stagger", layer + 0.1)
	add_overlay(colored_overlay)
	ChangeResistances(list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.6, BLACK_DAMAGE = 2.4, PALE_DAMAGE = 3))
	SLEEP_CHECK_DEATH(stun_duration)
	charge = 15
	ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))
	cut_overlays()
	can_act = TRUE

/mob/living/simple_animal/hostile/clan/stone_guard/proc/RangedAbility(atom/target)
	if(!can_act)
		return
	if(world.time < ability_cooldown)
		return
	can_act = FALSE
	ability_cooldown = world.time + ability_cooldown_time
	var/turf/T = get_ranged_target_turf_direct(src, get_turf(target), ability_range, rand(-10,10))
	var/list/turf_list = list()
	say("Commencing Protocol: Transpierce")
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
			charge -= 5
			playsound(src, 'sound/weapons/ego/devyat_overclock.ogg', 50, FALSE, 5)
			ChargeUpdated()
	can_act = TRUE

//Mad Fly Swarm
/mob/living/simple_animal/hostile/mad_fly_swarm
	name = "mad fly swarm"
	desc = "A swarm of maddened flies... or are they mosquitoes?"
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "mad_fly_swarm"
	icon_living = "mad_fly_swarm"
	maxHealth = 300
	health = 300
	move_to_delay = 1.6
	faction = list("mad fly")
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 2)
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 2
	melee_damage_upper = 4
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg'
	del_on_death = TRUE
	var/mob/living/nesting_target
	var/devouring_cooldown
	var/devouring_cooldown_time = 2 SECONDS

/mob/living/simple_animal/hostile/mad_fly_swarm/Life()
	. = ..()
	if(world.time < devouring_cooldown)
		return
	devouring_cooldown = world.time + devouring_cooldown_time
	if(nesting_target)
		nesting_target.deal_damage(melee_damage_upper * 2, RED_DAMAGE)
		playsound(get_turf(src), 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg', 50, FALSE, 5)
		nestting_target.visible_message(span_danger("\The [src] devours [nesting_target]'s from the inside!"))

/mob/living/simple_animal/hostile/mad_fly_swarm/AttackingTarget(atom/attacked_target)
	. = ..()
	for(var/i = 1 to 4)
		attacked_target.attack_animal(src)

	var/target_turf = get_turf(attacked_target)
	forceMove(target_turf)
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/L = attacked_target
		if(L.sanity_lost && L.stat != DEAD)
			nesting_target = L
			nesting()

/mob/living/simple_animal/hostile/mad_fly_swarm/proc/nesting()
	if(nesting_target)
		visible_message(span_danger("\The [src] crawls into [nesting_target]'s skin!"))
		forceMove(nesting_target)
		RegisterSignal(nesting_target, COMSIG_LIVING_DEATH, PROC_REF(larva_burst))

/mob/living/simple_animal/hostile/mad_fly_swarm/proc/larva_burst()
	UnregisterSignal(nesting_target, COMSIG_LIVING_DEATH)
	var/target_turf = get_turf(src)
	new /obj/effect/gibspawner/generic(target_turf)
	forceMove(target_turf)
	playsound(get_turf(src), 'sound/abnormalities/fairyfestival/fairyqueen_eat.ogg', 50, FALSE, 5)
	visible_message(span_danger("\The [src] crawls out of [nesting_target]'s skin, creating a new nest!"))
	new /mob/living/simple_animal/hostile/mad_fly_nest(target_turf)
	nesting_target = null

// Mad Fly Nest
/mob/living/simple_animal/hostile/mad_fly_nest
	name = "strange nest"
	desc = "Made out of some sort of gel like substance... You can see small maggots inside of it."
	icon = 'icons/mob/alien.dmi'
	icon_state = "egg"
	icon_living = "egg"
	icon_dead = "egg_hatched"
	layer = LYING_MOB_LAYER
	faction = list("mad fly")
	gender = NEUTER
	obj_damage = 0
	maxHealth = 1000
	health = 1000
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/xeno = 3)
	death_sound = 'sound/effects/ordeals/crimson/dusk_dead.ogg'
	var/spawn_progress = 18 //spawn ready to produce flies
	var/list/spawned_mobs = list()
	var/producing = FALSE

/mob/living/simple_animal/hostile/mad_fly_nest/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/mad_fly_nest/Move()
	return FALSE

/mob/living/simple_animal/hostile/mad_fly_nest/death(gibbed)
	new /obj/effect/gibspawner/xeno/bodypartless(get_turf(src))
	. = ..()

/mob/living/simple_animal/hostile/mad_fly_nest/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	if(producing)
		return
	if(length(spawned_mobs) >= 3)
		return
	if(spawn_progress < 20)
		spawn_progress += 1
		return
	Produce()

/mob/living/simple_animal/hostile/ordeal/green_dusk/proc/Produce()
	if(producing || stat == DEAD)
		return
	producing = TRUE
	icon_state = "egg_opening"
	SLEEP_CHECK_DEATH(15)
	visible_message(span_danger("\A new swarm climbs out of [src]!"))
	for(var/i = 1 to 3)
		var/turf/T = get_step(get_turf(src), pick(0, EAST))
		var/mob/living/simple_animal/hostile/mad_fly_swarm/nb = new /mob/living/simple_animal/hostile/mad_fly_swarm(T)
		spawned_mobs += nb
		SLEEP_CHECK_DEATH(1)
	SLEEP_CHECK_DEATH(2)
	icon = initial(icon)
	producing = FALSE
	spawn_progress = -5 // Basically, puts us on a tiny cooldown
