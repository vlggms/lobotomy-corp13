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
	a_intent_change(INTENT_HELP)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	if(SSmaptype.maptype in SSmaptype.citymaps)
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
		for(var/mob/living/simple_animal/hostile/ordeal/indigo_noon/sweeper in ohearers(7, src)) // And there is no sweepers even more damaged than us
			if(sweeper.stat != DEAD && (health > sweeper.health))
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

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky
	health = 250
	maxHealth = 250
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "sweeper_limbus"
	icon_living = "sweeper_limbus"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands.\nThis one seems to move with far more agility than its peers."
	move_to_delay = 2.7
	rapid_melee = 2
	melee_damage_lower = 11
	melee_damage_upper = 13
	/// This shouldn't matter until it goes into evasive mode.
	dodge_prob = 40
	/// Placeholder here until the main PR for can_act and can_move is merged.
	var/can_act = TRUE
	/// Placeholder here until the main PR for can_act and can_move is merged.
	var/can_move = TRUE
	/// Holds the next moment that this mob will be allowed to dash
	var/dash_cooldown
	/// This is the amount of time added by its dash attack (Sweep the Backstreets) on use onto its cooldown
	var/dash_cooldown_time = 12 SECONDS

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Initialize()
	. = ..()
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_2.ogg'

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	/// Okay so. I want them to attempt to dash whenever it's off cooldown, but if we call the parent proc before this, it'll queue up a hit that lands at any range.
	/// So we'll try to dash. If the dash actually goes through, we return false here because we don't want to land an auto-hit on the target. Otherwise we proceed as usual.
	if (SweepTheBackstreets(attacked_target))
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Move(atom/newloc, dir, step_x, step_y)
	if(!can_move)
		return FALSE
	. = ..()


/// Dash attack. Similar to combat page leader rats - this is intended to linebreak through people funneling sweepers.
/// Uses the same logic as the leader rat from combat pages (BackstreetsDash proc)
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/SweepTheBackstreets(atom/target)
	if(dash_cooldown > world.time)
		return FALSE
	dash_cooldown = world.time + dash_cooldown_time

	var/turf/dash_start_turf = get_turf(src)
	var/turf/dash_target_turf = get_ranged_target_turf_direct(src, target, 3)
	var/list/dash_turfs_hit_line = getline(dash_start_turf, dash_target_turf)
	can_act = FALSE
	can_move = FALSE
	/// Following section is for telegraphing the attack.
	face_atom(target)
	say("+2653 753 842396.+")
	for(var/turf/threatened_turf in dash_turfs_hit_line)
		new /obj/effect/temp_visual/cult/sparks/sweeper(threatened_turf)
	SLEEP_CHECK_DEATH(0.6 SECONDS)
	/// This section is for the actual hit happening.
	forceMove(dash_target_turf)
	for(var/turf/hit_turf in dash_turfs_hit_line)
		for(var/mob/living/hit_mob in HurtInTurf(hit_turf, list(), melee_damage_upper * 1.5, melee_damage_type, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE))
			to_chat(hit_mob, span_userdanger("The [src.name] viciously slashes you as it dashes past!"))
			new /obj/effect/gibspawner/generic(get_turf(hit_mob))
			playsound(hit_mob, attack_sound, 100)
			src.adjustBruteLoss(-50)
			new /obj/effect/temp_visual/heal(get_turf(src), "#70f54f")
	/// This part is for some visual/audio feedback.
	var/datum/beam/really_temporary_beam = dash_start_turf.Beam(dash_target_turf, icon_state = "1-full", time = 3)
	really_temporary_beam.visuals.color = "#FE5343"
	playsound(src, 'sound/weapons/fixer/generic/knife3.ogg', 100, FALSE, 4)
	/// Give the players a tiny bit of time to not instantly get double hit from the dash.
	SLEEP_CHECK_DEATH(0.3 SECONDS)
	can_act = TRUE
	can_move = TRUE
	/// We'll have them sometimes enter Evasive Mode after this dash.
	if(prob(40))
		EvasiveMode()

	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/EvasiveMode()
	addtimer(CALLBACK(src, PROC_REF(DisableEvasiveMode)), 4 SECONDS)
	dodging = TRUE
	minimum_distance = 1
	retreat_distance = 2
	move_to_delay = 1.5
	sidestep_per_cycle = 2

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/DisableEvasiveMode()
	dodging = initial(dodging)
	minimum_distance = initial(minimum_distance)
	retreat_distance = initial(retreat_distance)
	move_to_delay = initial(move_to_delay)
	sidestep_per_cycle = initial(sidestep_per_cycle)

/// I just want to make the telegraphing match properly, so we need a different duration for these than the normal 10 deciseconds
/obj/effect/temp_visual/cult/sparks/sweeper
	duration = 0.6 SECONDS
	color = "#FE5343"

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky
	health = 600
	maxHealth = 600
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sweeper_limbus"
	icon_living = "sweeper_limbus"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands.\nThis one has more bulk than its peers - it wouldn't be difficult for it to pin you down."
	move_to_delay = 5
	rapid_melee = 0.8

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/Initialize()
	. = ..()
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
