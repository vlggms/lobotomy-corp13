#define SWEEPER_TYPES /mob/living/simple_animal/hostile/ordeal/indigo_dawn || /mob/living/simple_animal/hostile/ordeal/indigo_noon || /mob/living/simple_animal/hostile/ordeal/indigo_dusk || /mob/living/simple_animal/hostile/ordeal/indigo_midnight

/mob/living/simple_animal/hostile/ordeal/indigo_dawn
	name = "unknown scout"
	desc = "A tall humanoid with a walking cane. It's wearing indigo armor."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "indigo_dawn"
	icon_living = "indigo_dawn"
	icon_dead = "indigo_dawn_dead"
	faction = list("indigo_ordeal")
	maxHealth = 110
	health = 110
	move_to_delay = 1.3	//Super fast, but squishy and weak.
	stat_attack = DEAD
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 12
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)
	blood_volume = BLOOD_VOLUME_NORMAL
	silk_results = list(/obj/item/stack/sheet/silk/indigo_simple = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dawn/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_dawn/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	if(SSmaptype.maptype == "city")
		return FALSE
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	if(istype(L, SWEEPER_TYPES))
		//Would have made it based on biotypes but that has its own issues.
		adjustBruteLoss(-20)
	else
		adjustBruteLoss(-(maxHealth/2))
	L.gib()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_noon
	name = "sweeper"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "sweeper_1"
	icon_living = "sweeper_1"
	icon_dead = "sweeper_dead"
	faction = list("indigo_ordeal")
	maxHealth = 500
	health = 500
	move_to_delay = 4
	stat_attack = DEAD
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 24
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)
	blood_volume = BLOOD_VOLUME_NORMAL
	silk_results = list(/obj/item/stack/sheet/silk/indigo_advanced = 1,
						/obj/item/stack/sheet/silk/indigo_simple = 2)
	var/leader //used by indigo dusk to recruit sweepers

/mob/living/simple_animal/hostile/ordeal/indigo_noon/Initialize()
	. = ..()
	attack_sound = "sound/effects/ordeals/indigo/stab_[pick(1,2)].ogg"
	icon_living = "sweeper_[pick(1,2)]"
	icon_state = icon_living

/mob/living/simple_animal/hostile/ordeal/indigo_noon/Aggro()
	. = ..()
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/LoseAggro()
	. = ..()
	if(leader)
		a_intent_change(INTENT_HELP)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	if(SSmaptype.maptype == "city")
		return FALSE
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	if(istype(L, SWEEPER_TYPES))
		adjustBruteLoss(-20)
	else
		adjustBruteLoss(-(maxHealth/2))
	L.gib()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_noon/PickTarget(list/Targets)
	if(health <= maxHealth * 0.6) // If we're damaged enough
		for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/sweeper in view(7, src)) // And there is no sweepers even more damaged than us
			if(sweeper.stat != DEAD && (health > sweeper.health))
				sweeper.PickTarget(Targets) // Let this sweeper see the same targets as we do
				return ..()
		var/list/highest_priority = list()
		for(var/mob/living/L in Targets)
			if(!CanAttack(L))
				continue
			if(L.health < 0 || L.stat == DEAD)
				highest_priority += L
		if(LAZYLEN(highest_priority))
			return pick(highest_priority)
	var/list/lower_priority = list() // We aren't exactly damaged, but it'd be a good idea to finish the wounded first
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(L.health < L.maxHealth*0.5 && (L.stat < UNCONSCIOUS))
			lower_priority += L
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/ordeal/indigo_dusk
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_dead = "sweeper_dead"
	faction = list("indigo_ordeal")
	maxHealth = 1500
	health = 1500
	stat_attack = DEAD
	melee_damage_type = RED_DAMAGE
	rapid_melee = 1
	melee_damage_lower = 13
	melee_damage_upper = 17
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	silk_results = list(/obj/item/stack/sheet/silk/indigo_elegant = 1,
						/obj/item/stack/sheet/silk/indigo_advanced = 2,
						/obj/item/stack/sheet/silk/indigo_simple = 4)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	blood_volume = BLOOD_VOLUME_NORMAL
	can_patrol = TRUE
	var/order_cooldown = 0
	var/list/troops = list()

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white
	name = "\proper Commander Adelheide"
	maxHealth = 2100
	health = 2100
	desc = "A tall humanoid with a white greatsword."
	icon_state = "adelheide"
	icon_living = "adelheide"
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 42
	melee_damage_upper = 55
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.7)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white/CanAttack(atom/the_target)
	if(ishuman(the_target))
		var/mob/living/carbon/human/L = the_target
		if(L.sanity_lost && L.stat != DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black
	name = "\proper Commander Maria"
	desc = "A tall humanoid with a large black hammer."
	icon_state = "maria"
	icon_living = "maria"
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 42
	melee_damage_upper = 55
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red
	name = "\proper Commander Jacques"
	desc = "A tall humanoid with red claws."
	icon_state = "jacques"
	icon_living = "jacques"
	rapid_melee = 4
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.7)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale
	name = "\proper Commander Silvina"
	desc = "A tall humanoid with glowing pale fists."
	icon_state = "silvina"
	icon_living = "silvina"
	rapid_melee = 2
	melee_damage_type = PALE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.5)


/mob/living/simple_animal/hostile/ordeal/indigo_dusk/Found(atom/A) //every time she finds a sweeper that sweeper is compelled to follow her as family
	if(istype(A, /mob/living/simple_animal/hostile/ordeal/indigo_noon) && troops.len < 6)
		var/mob/living/simple_animal/hostile/ordeal/indigo_noon/S = A
		if(S.stat != DEAD && !S.leader && !S.target && !S.client) //are you dead? do you have a leader? are you currently fighting? Are you a player?
			S.Goto(src,S.move_to_delay,1)
			S.leader = src
			troops += S

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/Aggro()
	a_intent_change(INTENT_HARM)
	..()
	if(order_cooldown < world.time && troops.len)
		order_cooldown = world.time + (10 SECONDS)
		var/mob/living/simple_animal/hostile/ordeal/overachiver = locate(/mob/living/simple_animal/hostile/ordeal/indigo_noon) in troops
		if(overachiver)
			overachiver.TemporarySpeedChange(amount = -2, time = 5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/LoseAggro()
	. = ..()
	if(troops.len)
		a_intent_change(INTENT_HELP) //so that they dont get body blocked by their kin outside of combat

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/patrol_select()
	if(troops.len)
		headcount()
		for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/family in troops)
			if(family.stat == DEAD || family.client) //if you are dead or are a player your no longer active in the family.
				troops -= family
			Goto(src , 2, 1) //had to change it to 2 because the 3 "move to delay" leader would keep outrunning the 4 "move to delay" followers
	..()

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/death()
	for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/S in troops) //The leader can no longer lead their troops into battle.
		if(S)
			S.leader = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/proc/headcount()
	var/list/whosehere = list()
	for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/soldier in oview(src, 10))
		whosehere += soldier
	var/list/absent_troops = difflist(troops, whosehere ,1)
	if(absent_troops.len)
		for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/s in absent_troops)
			s.leader = null
			troops -= s

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	if(istype(L, SWEEPER_TYPES))
		adjustBruteLoss(-20)
	else
		adjustBruteLoss(-(maxHealth/2))
	L.gib()
	return TRUE


/mob/living/simple_animal/hostile/ordeal/indigo_midnight
	name = "Matriarch"
	desc = "A humanoid creature wearing metallic armor. The Queen of sweepers."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "matriarch"
	icon_living = "matriarch"
	icon_dead = "matriarch_dead"
	faction = list("indigo_ordeal")
	maxHealth = 5000
	health = 5000
	stat_attack = DEAD
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_type = BLACK_DAMAGE
	move_to_delay = 3
	speed = 3
	rapid_melee = 2
	melee_damage_lower = 60
	melee_damage_upper = 60
	ranged = TRUE
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 4)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 3)
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.5)
	blood_volume = BLOOD_VOLUME_NORMAL
	move_resist = MOVE_FORCE_OVERPOWERING
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	can_patrol = TRUE

	//How many people has she eaten
	var/belly = 0
	//How mad is she?
	var/phase = 1

	//How often does she slam?
	var/slam_cooldown = 3
	var/slam_current = 3
	var/slam_damage = 100
	var/slamming = FALSE

	var/pulse_cooldown
	var/pulse_cooldown_time = 10 SECONDS
	var/pulse_damage = 10 // More over time

	//Spawning sweepers
	var/pissed_count
	var/pissed_threshold = 16

	//phase speedchange
	var/phasespeedchange = -0.6


/mob/living/simple_animal/hostile/ordeal/indigo_midnight/Move()
	if(slamming) //slammin B)
		return FALSE
	..()

//Prototype Complex Targeting -IP
/mob/living/simple_animal/hostile/ordeal/indigo_midnight/CanAttack(atom/the_target)
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(stat == DEAD && !faction_check_mob(L))
			return TRUE
	return ..()

//Remind me to return to this and make complex targeting a option for all creatures. I may make it a TRUE FALSE var.
/mob/living/simple_animal/hostile/ordeal/indigo_midnight/ValueTarget(atom/target_thing)
	//Higher brain functions have been turned off.
	if(phase >= 3)
		return ..()

	. = ..()

	if(isliving(target_thing))
		var/mob/living/L = target_thing
		//Hate for corpses since we eats them.
		if(L.stat == DEAD)
			. += 10
		//Highest possible addition is + 9.9
		if(iscarbon(L))
			if(L.stat != DEAD && L.health <= (L.maxHealth * 0.6))
				var/upper = L.maxHealth - HEALTH_THRESHOLD_DEAD
				var/lower = L.health - HEALTH_THRESHOLD_DEAD
				. += min( 2 * ( 1 / ( max( lower, 1 ) / upper ) ), 20)

	/*
	Priority from greatest to least:
	dead close: 90
	close: 80
	dead far: 40
	far: 30
	*/

//Stolen MOSB patrol code
/mob/living/simple_animal/hostile/ordeal/indigo_midnight/CanStartPatrol()
	return !(status_flags & GODMODE) && !target

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/patrol_reset()
	. = ..()
	FindTarget() // Start eating corpses IMMEDIATELLY

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/patrol_select()
	var/list/low_priority_turfs = list() // Oh, you're wounded, how nice.
	var/list/medium_priority_turfs = list() // You're about to die and you are close? Splendid.
	var/list/high_priority_turfs = list() // IS THAT A DEAD BODY?
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4) // Way too close
			continue
		if(H.stat != DEAD) // Not dead people
			if(H.health < H.maxHealth*0.5)
				if(get_dist(src, H) > 24) // Way too far
					low_priority_turfs += get_turf(H)
					continue
				medium_priority_turfs += get_turf(H)
			continue
		if(get_dist(src, H) > 24) // Those are dead people
			medium_priority_turfs += get_turf(H)
			continue
		high_priority_turfs += get_turf(H)

	var/turf/target_turf
	if(LAZYLEN(high_priority_turfs))
		target_turf = get_closest_atom(/turf/open, high_priority_turfs, src)
	else if(LAZYLEN(medium_priority_turfs))
		target_turf = get_closest_atom(/turf/open, medium_priority_turfs, src)
	else if(LAZYLEN(low_priority_turfs))
		target_turf = get_closest_atom(/turf/open, low_priority_turfs, src)

	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return TRUE
	//unsure if this patrol reset will cause the patrol cooldown even if there is not patrol path.
	patrol_reset()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

	slam_current-=1
	if(slam_current == 0)
		slamming = TRUE
		slam_current = slam_cooldown
		aoe(2, 1)

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	if(istype(L, SWEEPER_TYPES))
		adjustBruteLoss(-20)
	else
		adjustBruteLoss(-(maxHealth*0.3))
	L.gib()
	//Increase the Vore counter by 1
	belly += 1
	pulse_damage += 2
	//She gets faster but not as protected or as strong
	if(belly == 5 && phase == 1)
		phase2()
	if(belly == 10 && phase == 2)
		phase3()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/bullet_act(obj/projectile/P)
	..()
	pissed_count += 1
	if(pissed_count >= pissed_threshold)
		pissed_count = 0
		for(var/turf/T in orange(1, src))
			if(T.density)
				continue
			if(prob(20))
				new /obj/effect/sweeperspawn(T)

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(pulse_cooldown < world.time)
		BlackPulse()
		//Putting this here so that it doesn't look weird
		if(health == maxHealth/2 && phase == 1)
			phase2()
		if(health == maxHealth/4 && phase == 2)
			phase3()

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/BlackPulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/weapons/resonator_blast.ogg', 100, FALSE, 90)
	for(var/mob/living/L in urange(90, src))
		if(faction_check_mob(L))
			continue
		//don't kill if you're too close.
		var/distance = round(get_dist(src, L))
		if(distance <= 10)
			continue
		L.apply_damage(((pulse_damage + distance - 10)*0.5), BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/phase2()
	icon_state = "phasechange"
	SLEEP_CHECK_DEATH(5)

	maxHealth = 4000
	ChangeResistances(list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.25, PALE_DAMAGE = 0.8))
	SpeedChange(phasespeedchange)
	rapid_melee +=1
	melee_damage_lower -= 10
	melee_damage_upper -= 10

	pulse_cooldown_time = 6 SECONDS
	slam_cooldown = 5
	icon_state = "matriarch_slim"
	icon_living = "matriarch_slim"
	phase = 2


/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/phase3()
	icon_state = "sicko_mode"
	SLEEP_CHECK_DEATH(5)

	maxHealth = 3000
	ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1))
	SpeedChange(phasespeedchange)
	rapid_melee += 2
	melee_damage_lower -= 15
	melee_damage_upper -= 15

	pulse_cooldown_time = 4 SECONDS
	slam_cooldown = 10
	icon_state = "matriarch_fast"
	icon_living = "matriarch_fast"
	phase = 3


/// cannibalized from wendigo
/mob/living/simple_animal/hostile/ordeal/indigo_midnight/proc/aoe(range, delay)
	for(var/turf/W in range(range, src))
		new /obj/effect/temp_visual/guardian/phase(W)
	sleep(10)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(range, orgin)
	for(var/i = 0 to range)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			playsound(T,'sound/effects/bamf.ogg', 60, TRUE, 10)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/carbon/human/L in T)
				if(L == src || L.throwing)
					continue
				to_chat(L, span_userdanger("[src]'s ground slam shockwave sends you flying!"))
				var/turf/thrownat = get_ranged_target_turf_direct(src, L, 8, rand(-10, 10))
				L.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
				L.apply_damage(slam_damage, RED_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				shake_camera(L, 2, 1)
			all_turfs -= T
		sleep(delay)
	slamming = FALSE

#undef SWEEPER_TYPES

/obj/effect/sweeperspawn
	name = "bloodpool"
	desc = "A target warning you of incoming pain"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "bloodin"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/sweeperspawn/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(spawnscout)), 6)

/obj/effect/sweeperspawn/proc/spawnscout()
	new /mob/living/simple_animal/hostile/ordeal/indigo_spawn(get_turf(src))
	qdel(src)

/mob/living/simple_animal/hostile/ordeal/indigo_spawn
	name = "sweeper scout"
	desc = "A tall humanoid with a walking cane. It's wearing indigo armor."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "indigo_dawn"
	icon_living = "indigo_dawn"
	icon_dead = "indigo_dawn_dead"
	faction = list("indigo_ordeal")
	maxHealth = 110
	health = 110
	move_to_delay = 1.3	//Super fast, but squishy and weak.
	stat_attack = HARD_CRIT
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 21
	melee_damage_upper = 24
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)
	blood_volume = BLOOD_VOLUME_NORMAL
