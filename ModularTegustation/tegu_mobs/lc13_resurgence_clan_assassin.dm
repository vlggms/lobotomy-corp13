/mob/living/simple_animal/hostile/clan/assassin
	name = "Assassin"
	desc = "A sleek humanoid machine with blade-like appendages... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_assassin"
	icon_living = "clan_assassin"
	icon_dead = "clan_assassin_dead"
	health = 800
	maxHealth = 800
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	attack_sound = 'sound/weapons/bladeslice.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1,
						/obj/item/stack/sheet/silk/azure_advanced = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	melee_damage_lower = 10
	melee_damage_upper = 15
	robust_searching = TRUE
	vision_range = 12
	aggro_vision_range = 12
	move_to_delay = 2.5
	charge = 0
	max_charge = 10
	clan_charge_cooldown = 3 SECONDS
	teleport_away = TRUE

	// Assassin specific vars
	var/stealth_mode = FALSE
	var/stealth_alpha = 25
	var/stealth_speed_modifier = 0.7
	var/backstab_damage = 150
	var/backstab_damage_type = RED_DAMAGE
	var/charge_cost_stealth_hit = 5
	var/charge_cost_backstab = 10
	var/stun_duration_on_hit = 1.5 SECONDS
	var/isolation_check_range = 3
	var/z_level_hunt_mode = FALSE
	var/hunt_target = null

/mob/living/simple_animal/hostile/clan/assassin/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_SHOE, 1, -6)

/mob/living/simple_animal/hostile/clan/assassin/Life()
	. = ..()
	if(!.)
		return

	// Charge management for stealth
	if(charge >= max_charge && !stealth_mode && !client)
		EnterStealth()
	else if(stealth_mode && charge <= 0)
		ExitStealth()

	// Update charge
	ChargeGain()

/mob/living/simple_animal/hostile/clan/assassin/proc/ChargeGain()
	if(last_charge_update < world.time - clan_charge_cooldown)
		if(stealth_mode)
			// No charge gain in stealth
			return
		else
			// Faster charge gain when not in stealth
			charge = min(charge + 2, max_charge)
			last_charge_update = world.time

/mob/living/simple_animal/hostile/clan/assassin/proc/EnterStealth()
	if(stealth_mode)
		return

	stealth_mode = TRUE
	alpha = stealth_alpha
	add_movespeed_modifier(/datum/movespeed_modifier/assassin_stealth)
	visible_message(span_warning("[src] fades into the shadows!"))
	playsound(src, 'sound/effects/curse5.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/assassin/proc/ExitStealth()
	if(!stealth_mode)
		return

	stealth_mode = FALSE
	alpha = 255
	remove_movespeed_modifier(/datum/movespeed_modifier/assassin_stealth)
	visible_message(span_danger("[src] emerges from the shadows!"))
	playsound(src, 'sound/effects/curse2.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/assassin/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stealth_mode) // Took damage while in stealth
		charge = max(0, charge - charge_cost_stealth_hit)
		Stun(stun_duration_on_hit)
		ExitStealth()

/mob/living/simple_animal/hostile/clan/assassin/AttackingTarget(atom/attacked_target)
	if(!attacked_target)
		attacked_target = target

	// Assassins cannot damage objects
	if(isobj(attacked_target))
		// Handle object climbing while in stealth
		if(stealth_mode && (istype(attacked_target, /obj/structure/table) || istype(attacked_target, /obj/structure/barricade)))
			ClimbOver(attacked_target)
		return

	// Handle backstab
	if(stealth_mode && isliving(attacked_target))
		var/mob/living/L = attacked_target
		PerformBackstab(L)
		return

	return ..()

/mob/living/simple_animal/hostile/clan/assassin/proc/ClimbOver(obj/structure/S)
	if(!stealth_mode || !S || !isturf(S.loc))
		return

	var/turf/destination = get_step(S, get_dir(src, S))
	if(destination && !destination.density)
		forceMove(destination)
		playsound(src, 'sound/effects/footstep/hardbarefoot1.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/assassin/proc/PerformBackstab(mob/living/L)
	if(!stealth_mode || !L || charge < charge_cost_backstab)
		return

	// Announce the backstab
	say("Behind you.")
	SLEEP_CHECK_DEATH(7)

	// Exit stealth dramatically
	ExitStealth()
	SLEEP_CHECK_DEATH(3)

	// Perform the backstab if still in range
	if(L in range(1, src))
		visible_message(span_userdanger("[src] rips out [L]'s guts!"))
		playsound(L, 'sound/weapons/bladeslice.ogg', 100, TRUE)
		new /obj/effect/gibspawner/generic(get_turf(L))
		L.deal_damage(backstab_damage, backstab_damage_type)
		charge -= charge_cost_backstab

		// Re-enter stealth after a delay
		SLEEP_CHECK_DEATH(20)
		if(charge >= 2) // Need some charge to re-stealth
			EnterStealth()

		// Find new target
		LoseTarget()
		FindTarget()
	else
		// Target moved away, regular attack
		return

/mob/living/simple_animal/hostile/clan/assassin/PickTarget(list/Targets)
	if(!length(Targets))
		return null

	// Find the most isolated target
	var/mob/living/best_target = null
	var/best_isolation_score = -1

	for(var/mob/living/L in Targets)
		if(!isliving(L))
			continue

		var/isolation_score = GetIsolationScore(L)
		if(isolation_score > best_isolation_score)
			best_isolation_score = isolation_score
			best_target = L

	return best_target

/mob/living/simple_animal/hostile/clan/assassin/proc/GetIsolationScore(mob/living/L)
	if(!L)
		return 0

	var/nearby_allies = 0
	for(var/mob/living/potential_ally in view(isolation_check_range, L))
		if(potential_ally == L)
			continue
		if(L.faction_check_mob(potential_ally))
			nearby_allies++

	// Higher score = more isolated
	return 10 - nearby_allies

/mob/living/simple_animal/hostile/clan/assassin/MoveToTarget(list/possible_targets)
	if(stealth_mode && !target)
		// Don't break stealth just to acquire a target
		return TRUE

	if(!stealth_mode && target && get_dist(src, target) > 3)
		// Run away when not in stealth and target is close
		walk_away(src, target, 7, move_to_delay)
		return TRUE

	return ..()

// Z-level hunting mode
/mob/living/simple_animal/hostile/clan/assassin/proc/ActivateHuntMode()
	if(z_level_hunt_mode)
		return

	z_level_hunt_mode = TRUE
	var/mob/living/carbon/human/most_isolated = null
	var/best_isolation = -1

	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
		if(H.z != z || H.stat == DEAD)
			continue

		// Check if we can path to them
		var/list/path = get_path_to(src, H, /turf/proc/Distance_cardinal, 0, 200)
		if(!length(path))
			continue

		var/isolation = GetIsolationScore(H)
		if(isolation > best_isolation)
			best_isolation = isolation
			most_isolated = H

	if(most_isolated)
		hunt_target = most_isolated
		target = hunt_target
		visible_message(span_warning("[src]'s eyes glow as it locks onto a distant target!"))

/datum/movespeed_modifier/assassin_stealth
	multiplicative_slowdown = 2.5
