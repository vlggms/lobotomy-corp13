#define STATUS_EFFECT_PERSISTENCE /datum/status_effect/stacking/sweeper_persistence
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
	var/datum/status_effect/stacking/sweeper_persistence/locked_in = src.has_status_effect(STATUS_EFFECT_PERSISTENCE)
	if(!locked_in)
		src.apply_status_effect(STATUS_EFFECT_PERSISTENCE)
	else
		locked_in.add_stacks(1)
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

/// This subtype moves faster, attacks faster, deals less damage per hit, and has access to a dash attack.
/// Uses the lanky sweeper sprite made by insiteparaful.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky
	health = 280
	maxHealth = 280
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "sweeper_limbus"
	icon_living = "sweeper_limbus"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands.\nThis one seems to move with far more agility than its peers."
	move_to_delay = 3.2
	rapid_melee = 2
	melee_damage_lower = 11
	melee_damage_upper = 13
	/// This shouldn't matter until it goes into evasive mode.
	dodge_prob = 40
	/// Placeholder here until the main PR for can_act and can_move is merged.
	var/can_act = TRUE
	/// Placeholder here until the main PR for can_act and can_move is merged.
	var/can_move = TRUE
	/// Holds the next moment that this mob will be allowed to dash.
	var/dash_cooldown
	/// This is the amount of time added by its dash attack (Sweep the Backstreets) on use onto its cooldown.
	/// It should be fairly long so you can bait it and have a safe window to deal with sweepers in the usual, wagie way of funneling them.
	var/dash_cooldown_time = 25 SECONDS
	/// Sweep the Backstreets ability range in tiles.
	var/dash_range = 3

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Initialize()
	. = ..()
	/// I know this is weird but I don't know how to ONLY override Initialize() for indigo_noon without getting rid of the code from simple_animal and whatnot.
	/// I have to set these things here because normal indigo_noon initialization sets them.
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_2.ogg'

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Life()
	. = ..()
	/// I know this looks weird, but I don't want to put this on AttackingTarget() because that restricts only sweepers in melee to be able to use the dash.
	/// This is bad because we could have like 3 lanky sweepers waiting to dash but they're stuck behind a chunky sweeper.
	/// This code makes them attempt to dash at targets in range. The check for distance happens in the actual proc, and only after checking cooldown.
	if(target && can_act)
		if(prob(50))
			SweepTheBackstreets(target)


/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Move(atom/newloc, dir, step_x, step_y)
	if(!can_move)
		return FALSE
	. = ..()


/// Dash attack. Similar to combat page leader rats - this is intended to linebreak through people funneling sweepers.
/// Uses the same logic as the leader rat from combat pages (BackstreetsDash proc)
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/SweepTheBackstreets(atom/target)
	if(dash_cooldown > world.time)
		return FALSE
	if(get_dist(src, target) > dash_range)
		return FALSE
	dash_cooldown = world.time + dash_cooldown_time

	var/turf/dash_start_turf = get_turf(src)
	var/turf/dash_target_turf = get_ranged_target_turf_direct(src, target, dash_range)
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
			/// We spawn some gibs and heal if the target hit is human.
			if(istype(hit_mob, /mob/living/carbon/human))
				new /obj/effect/gibspawner/generic(get_turf(hit_mob))
				src.adjustBruteLoss(-50)
				new /obj/effect/temp_visual/heal(get_turf(src), "#70f54f")
			playsound(hit_mob, attack_sound, 100)
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

/// As of June 2025 Indigo Noon is being updated to have some variants.
/// These two subtypes will show up alongside the normal old sweepers for the ordeal. They could also be reused in Dusk and Midnight.

/// This subtype moves slower, attacks slower, deals a bit more damage per hit, and has access to an empowered lifesteal attack every once in a while after being hit.
/// Uses the chunky sweeper sprite made by insiteparaful.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky
	health = 750
	maxHealth = 750
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sweeper_limbus"
	icon_living = "sweeper_limbus"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands.\nThis one has more bulk than its peers - it won't go down easy."
	/// They're slow.
	move_to_delay = 5
	/// These sweepers have a slower, but slightly stronger melee. Easier to parry if anything.
	rapid_melee = 0.8
	melee_damage_lower = 24
	melee_damage_upper = 26
	/// Holds the next moment when this sweeper can use Extract Fuel (lifesteal hit)
	var/extract_fuel_cooldown
	/// Holds the cooldown time between Extract Fuel uses
	var/extract_fuel_cooldown_time = 10 SECONDS
	/// Extract Fuel will hit for this much additional BLACK damage
	var/extract_fuel_extra_damage = 10
	/// Extract Fuel will heal the sweeper for this much health
	var/extract_fuel_healing = 100
	/// This controls whether the next hit actually sets off Extract Fuel's additional effects
	var/extract_fuel_active = FALSE
	/// We store the timer we use for cancelling Extract Fuel so we can delete it early if we've already used it
	var/extract_fuel_ongoing_timer

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/Initialize()
	. = ..()
	/// I know this is weird but I don't know how to ONLY override Initialize() for indigo_noon without getting rid of the code from simple_animal and whatnot.
	/// I have to set these things here because normal indigo_noon initialization sets them.
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'


/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	/// I'm making them only fire it off with a chance to keep players guessing, instead of having them act too predictably.
	if(extract_fuel_cooldown <= world.time && prob(60))
		PrepareExtractFuel()
		/// We're gonna sleep them because otherwise someone could hit the sweeper the DECISECOND before it's gonna attack and get slapped by a huge hit
		/// This gives them enough margin to run away or parry
		SLEEP_CHECK_DEATH(0.4 SECONDS)

/// The following few code chunks are dedicated to the Extract Fuel mechanic specific to this sweeper type. Basically, it's a lifesteal hit they can use every once in a bit.
/// When the sweeper takes a hit, if it's off cooldown, it'll buff itself for its next hit and warn the player, giving them a brief grace period to disengage or prepare.
/// If they don't get away in time, they'll be hit by an empowered attack that also heals the sweeper for a good chunk and spawns some gibs for extra flashiness.
/// The buff goes away in 2.5 seconds or after landing the hit.
/// Extract Fuel doesn't get activated by ranged hits, but like, even if it did, it'd be useless. These things are REALLY slow and easy to kite.
/// But I don't have any intention of giving them some sort of countermeasure, it's just a Noon Ordeal...

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && extract_fuel_active && istype(attacked_target, /mob/living/carbon/human))
		CancelExtractFuel(TRUE)
		new /obj/effect/gibspawner/generic(get_turf(attacked_target))
		src.adjustBruteLoss(-extract_fuel_healing)
		new /obj/effect/temp_visual/heal(get_turf(src), "#70f54f")
		visible_message(span_danger("The [src.name] tears into [attacked_target.name] and refuels itself with some of their viscera!"))

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/proc/PrepareExtractFuel()
	/// I have no idea what could cause this, but just in case
	if(extract_fuel_active)
		return FALSE
	/// Go on cooldown.
	extract_fuel_cooldown = world.time + extract_fuel_cooldown_time
	/// Make our attack scary.
	melee_damage_lower += extract_fuel_extra_damage
	melee_damage_upper += extract_fuel_extra_damage
	attack_sound = 'sound/weapons/fixer/generic/finisher1.ogg'
	extract_fuel_active = TRUE
	/// Warn the players so they can back off or get ready to parry.
	say("+38725 619.+")
	visible_message(span_danger("The [src.name] winds up for a devastating blow!"), span_info("You prepare to extract fuel from your victim."))
	animate(src, 1.5 SECONDS, color = "#FE5343")
	/// If we haven't landed the hit in the following few seconds, we will lose the buff.
	extract_fuel_ongoing_timer = addtimer(CALLBACK(src, PROC_REF(CancelExtractFuel), FALSE), 2.5 SECONDS, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/proc/CancelExtractFuel(early)
	/// Timer cleanup
	ExtractFuelTimerCleanup()

	/// We go back to normal.
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	extract_fuel_active = FALSE
	animate(src, 0.6 SECONDS, color = initial(color))
	if(!early)
		visible_message(span_danger("The [src.name] lowers its aggressive stance."), span_info("You give up on the fuel extraction attempt."))

/// This cleanup exists because if we land a hit with Extract Fuel, we want to turn it off, but there's still an ongoing timer it will call CancelExtractFuel
/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/proc/ExtractFuelTimerCleanup()
	if(extract_fuel_ongoing_timer)
		deltimer(extract_fuel_ongoing_timer)
		extract_fuel_ongoing_timer = null

/// Persistence Status Effect
/// It allows them to avoid death when struck, with some VFX/SFX indicating that it was activated
/// Every time it activates, it loses a stack, but it can also time out over a long period of time.
/// All Sweepers gain a stack of Persistence when eating corpses. Chunky Sweepers can give themselves several stacks when on low health.

/datum/status_effect/stacking/sweeper_persistence
	id = "persistence"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 30 SECONDS
	alert_type = null
	var/mutable_appearance/overlay
	stacks = 1
	max_stacks = 5
	stack_decay = 0
	consumed_on_threshold = FALSE
	var/base_chance = 30
	var/health_recovery_per_stack = 20

/// I need dead mobs to be able to have the status, so...
/datum/status_effect/stacking/sweeper_persistence/can_have_status()
	return istype(owner, /mob/living/simple_animal/hostile/ordeal/indigo_noon)

/// I am nuking the tick.
/datum/status_effect/stacking/sweeper_persistence/tick()

/datum/status_effect/stacking/sweeper_persistence/on_apply()
	. = ..()
	if(!owner)
		return
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(CheckDeath))
	owner.say("Persistence gained.")

/datum/status_effect/stacking/sweeper_persistence/add_stacks(stacks_added)
	. = ..()
	owner.say("Persistence stacks: [src.stacks]")
	/// I don't think I have to do any further cleanup, it should get qdel'd by Process() right?
	if(stacks <= 0)
		owner.remove_status_effect(STATUS_EFFECT_PERSISTENCE)

/datum/status_effect/stacking/sweeper_persistence/on_remove()
	. = ..()
	if(!owner)
		return
	UnregisterSignal(src, COMSIG_MOB_APPLY_DAMGE)
	owner.say("Persistence lost.")

/// This check was taken from Welfare Core's code. Altered to work on simplemobs instead.
/datum/status_effect/stacking/sweeper_persistence/proc/CheckDeath(datum_source, amount, damagetype, def_zone)
	SIGNAL_HANDLER

	if(!owner)
		return

	var/mob/living/simple_animal/hostile/ordeal/indigo_noon/neighbor = owner
	/// We get the resistance from the sweeper's resistances datum.
	var/damage_coefficient = neighbor.damage_coeff.getCoeff(damagetype)
	/// The original damage received is given to us by the signal we're handling.
	var/damage_taken = amount * damage_coefficient
	/// No point in doing anything if the damage wouldn't kill the sweeper.
	if(damage_taken <= 0)
		return

	/// Chance to proc Persistence is calculated here based on stacks. It can't be higher than 100 because... I don't know what happens if it's higher.
	/// Chances should be as follows (%, stack amt.): 44, 1 | 58, 2 | 72, 3 | 86, 4 | 100, 5
	var/chance = min(base_chance + stacks*14, 100)
	if(damage_taken >= neighbor.health)
		/// But it refused. Persistence goes off, we heal a tiny bit and lose a stack
		if(prob(chance))
			playsound(neighbor, 'sound/misc/compiler-failure.ogg', 60)
			src.add_stacks(-1)
			neighbor.adjustBruteLoss(-20)
			return COMPONENT_MOB_DENY_DAMAGE
		/// Tough luck neighbor. Persistence didn't go off so the sweeper dies here.
		else
			playsound(neighbor, 'sound/misc/splort.ogg', 90)
	return


//////////////////////TODO: MAKE SWEEPERHEALING() PROC TO AVOID DUPLICATE CODE!!!

#undef STATUS_EFFECT_PERSISTENCE
