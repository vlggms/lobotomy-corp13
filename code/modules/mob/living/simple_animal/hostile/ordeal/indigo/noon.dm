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
	if(faction_check_mob(L))
		adjustBruteLoss(-40)
	else
		adjustBruteLoss(-(maxHealth/2))
		GainPersistence(1)
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

/// This may or may not be expensive but it's the most orderly way I could think of to allow them to eat dead sweeper corpses.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/PossibleThreats(max_range, consider_attack_condition)
	. = ..()
	if(health <= maxHealth * 0.8)
		for(var/turf/adjacent_turf in orange(1, src))
			for(var/mob/maybe_sweeper_corpse in adjacent_turf)
				if(faction_check_mob(maybe_sweeper_corpse) && maybe_sweeper_corpse.stat == DEAD)
					. |= maybe_sweeper_corpse

/// These two procs are being added in June 2025 as part of an Indigo Noon update, not part of original Indigo Noon code.
/// This one is called whenever a sweeper has to gain X amount of Persistence stacks, because I didn't want to duplicate the code checking if they already had it a bunch of times.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/proc/GainPersistence(stacks_gained)
	var/datum/status_effect/stacking/sweeper_persistence/locked_in = src.has_status_effect(STATUS_EFFECT_PERSISTENCE)
	if(!locked_in)
		src.apply_status_effect(STATUS_EFFECT_PERSISTENCE)
		if(stacks_gained>1)
			var/datum/status_effect/stacking/sweeper_persistence/just_applied = src.has_status_effect(STATUS_EFFECT_PERSISTENCE)
			just_applied.add_stacks(stacks_gained - 1)

	else
		locked_in.add_stacks(stacks_gained)

/// I use this logic a couple times in the subtypes so I'm just generalizing it here.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/proc/SweeperHealing(amount)
	src.adjustBruteLoss(-amount)
	new /obj/effect/temp_visual/heal(get_turf(src), "#70f54f")

/// As of June 2025 Indigo Noon is being updated to have some variants.
/// These two subtypes will show up alongside the normal old sweepers for the ordeal. They could also be reused in Dusk and Midnight.

/// This subtype moves faster, attacks faster, deals less damage per hit, and has access to a dash attack.
/// Uses the lanky sweeper sprite made by insiteparaful.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky
	health = 300
	maxHealth = 300
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "sweeper_limbus"
	icon_living = "sweeper_limbus"
	desc = "A humanoid creature wearing metallic armor. It has bloodied hooks in its hands.\nThis one seems to move with far more agility than its peers."
	move_to_delay = 2.7
	rapid_melee = 2
	melee_damage_lower = 11
	melee_damage_upper = 13
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	/// This shouldn't matter until it goes into evasive mode.
	dodge_prob = 40
	/// I want it to be ranged so it'll use OpenFire() on targets it's not in melee with, which I am overriding with an attempt to use the dash attack. That being said it isn't a real ranged unit.
	ranged = TRUE
	projectiletype = null
	/// Placeholder here until the main PR for can_act and can_move is merged.
	var/can_act = TRUE
	/// Holds the next moment that this mob will be allowed to dash.
	var/dash_cooldown
	/// This is the amount of time added by its dash attack (Sweep the Backstreets) on use onto its cooldown.
	/// While the cooldown may seem fairly short, every human it hits will increase it by a fair bit.
	var/dash_cooldown_time = 4 SECONDS
	/// Sweep the Backstreets ability range in tiles.
	var/dash_range = 3
	/// Sweep the Backstreets healing per human hit.
	var/dash_healing = 80
	/// Are we currently during the dash windup phase?
	var/dash_preparing = FALSE
	/// Are we currently dashing?
	var/dash_dashing = FALSE
	/// The speed at which we dash in deciseconds.
	var/dash_speed = 0.4
	/// The windup duration for the dash.
	var/dash_windup = 0.7 SECONDS
	/// We need this to not hit multiple people due to the implementation I used for the dash. Stores every mob hit by the dash, cleared on each dash.
	var/list/dash_hitlist = list()
	/// This one is so we can hit all the turfs with the dash at once, to avoid people dodging it by moving inside of it.
	var/list/dash_hitlist_turfs = list()

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Initialize()
	. = ..()
	/// I know this is weird but I don't know how to ONLY override Initialize() for indigo_noon without getting rid of the code from simple_animal and whatnot.
	/// I have to set these things here because normal indigo_noon initialization sets them.
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_2.ogg'

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Destroy()
	/// To avoid a hard delete.
	dash_hitlist = null
	dash_hitlist_turfs = null
	. = ..()

/// When meleeing a target, will attempt to dash if it's available (and has some RNG thrown into it to keep them less predictable). Won't dash on melee if it's a possessed sweeper.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(dash_cooldown > world.time || dash_dashing || dash_preparing)
		return ..()
	if(!client && prob(60))
		SweepTheBackstreets(attacked_target)
		return
	. = ..()

/// OpenFire() is gonna be called fairly often since it's set as a ranged unit, we want this so they'll dash even if they're stuck behind other sweepers in a "traffic jam". Also lets possessed sweepers dash at will.
/// Whole proc is overridden.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/OpenFire(atom/A)
	if(dash_cooldown > world.time || dash_dashing || dash_preparing)
		return
	if(client)
		SweepTheBackstreets(A)
		return
	else if(prob(50))
		SweepTheBackstreets(A)
		return

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/Move(atom/newloc, dir, step_x, step_y)
	if(dash_preparing)
		return FALSE
	. = ..()
	if(!.)
		CancelDash()
	/// While we're dashing, all turfs we move into will be added into the list of turfs hit by our dash. Final turf is added manually in SweepTheBackstreets().
	if(dash_dashing)
		dash_hitlist_turfs |= get_turf(newloc)

/// Dash attack. Calls PrepareDash(), BeginDash(), CancelDash() and SweepTheBackstreetsHit() in that order.
/// Sequence of events:
/// 1. Checks passed, sweeper goes on cooldown, target turf is telegraphed and the sweeper says something to warn players. Sweeper then sleeps for var/dash_windup.
/// 2. Sweeper begins dashing, walking towards the target turf. Slept for the duration of the movement, and it can't move or act normally during this.
/// 3. After the movement is over, a red-coloured beam is drawn between the starting point and the sweeper, and a sound is played. All turfs the sweeper moved through are hit by the attack at the same time.
/// During the dash, the sweeper can go through mobs and tables. But not railings.
/// The first turf the sweeper moves into will be ignored for diagonal dashing because of how weird it feels to be hit in certain gameplay situations.
/// Any humans hit will heal the sweeper for var/dash_healing, and give it a stack of persistence.
/// Hitting a human will up the cooldown on the dash. Missing entirely means the dash comes off cooldown sooner.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/SweepTheBackstreets(atom/prospective_fuel = target)
	if(stat == DEAD || !can_act)
		return FALSE
	if(dash_cooldown > world.time || dash_dashing || dash_preparing)
		return FALSE
	if(get_dist(src, prospective_fuel) > dash_range)
		return FALSE
	var/turf/dash_start_turf = get_turf(src)
	var/turf/dash_target_turf = get_ranged_target_turf_direct(src, prospective_fuel, dash_range)
	if(!dash_target_turf)
		return FALSE
	/// We got those checks out of the way - prepare to dash.
	dash_cooldown = world.time + dash_cooldown_time
	PrepareDash()
	LoseTarget()
	/// This section is for telegraphing the attack.
	face_atom(prospective_fuel)
	say("+2653 753 842396.+")
	new /obj/effect/temp_visual/cult/sparks/sweeper(dash_target_turf)
	SLEEP_CHECK_DEATH(dash_windup)
	/// We're now dashing.
	BeginDash()
	walk_towards(src, dash_target_turf, dash_speed)
	SLEEP_CHECK_DEATH(get_dist(src, dash_target_turf) * dash_speed)

	/// This part is for some visual/audio feedback.
	var/datum/beam/really_temporary_beam = dash_start_turf.Beam(src, icon_state = "1-full", time = 3)
	really_temporary_beam.visuals.color = "#FE5343"
	playsound(src, 'sound/weapons/fixer/generic/knife3.ogg', 100, FALSE, 4)

	/// We're done dashing. Hit all the affected turfs at the same time (to avoid people dodging it by moving into it).
	/// Also, if we're dashing diagonally we're not hitting the first turf. Because it feels really weird from playtesting.
	/// I don't know a more elegant way to do it, but the following code will remove the first turf from the hit turfs list if we dashed diagonally.
	/// The alternative is that, for example, a player standing directly south of a sweeper dashing southwest will be hit by the dash. Which is really weird.
	var/moved_cardinals = FALSE
	var/direction_moved = get_dir(src, dash_start_turf)
	/// I know there's a define called ALL_CARDINALS but it's not a list and I don't really know how to use it.
	if(direction_moved == NORTH || direction_moved == SOUTH || direction_moved == WEST || direction_moved == EAST)
		moved_cardinals = TRUE
	if(!moved_cardinals)
		if(length(dash_hitlist_turfs) > 0)
			dash_hitlist_turfs -= dash_hitlist_turfs[1]
	/// The Sweeper won't have added the final turf onto its hit list, so we add it here.
	/// Yes it needs to get slept for 0.1 second here because... it hasn't finished moving or something. I've tested it. Trust me.
	SLEEP_CHECK_DEATH(0.1 SECONDS)
	CancelDash()
	dash_hitlist_turfs |= get_turf(src)
	SweepTheBackstreetsHit(dash_hitlist_turfs)
	/// Give the players a tiny bit of time to not instantly get auto hit by the sweeper after it dashes.
	SLEEP_CHECK_DEATH(0.4 SECONDS)
	/// We'll have them enter Evasive Mode after this dash.
	EvasiveMode()

	/// Re-target our old target.
	if(!client)
		GiveTarget(prospective_fuel)
	can_act = TRUE
	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/SweepTheBackstreetsHit(list/turfs)
	for(var/hit_turf in turfs)
		for(var/mob/living/hit_mob in HurtInTurf(hit_turf, dash_hitlist, melee_damage_upper * 1.5, melee_damage_type, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE))
			to_chat(hit_mob, span_userdanger("The [src.name] viciously slashes you as it dashes past!"))
			/// We spawn some gibs and heal if the target hit is human.
			if(istype(hit_mob, /mob/living/carbon/human))
				new /obj/effect/gibspawner/generic(get_turf(hit_mob))
				SweeperHealing(dash_healing)
				GainPersistence(1)
				playsound(hit_mob, attack_sound, 100)
				/// Dash will come off cooldown faster if it doesn't hit anyone.
				/// This sounds counter intuitive but I want it to be used more often if players bait them into wasting it early.
				dash_cooldown += 6 SECONDS

/// Called when we're entering a dash (passed all the checks).
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/PrepareDash()
	dash_preparing = TRUE
	dash_dashing = FALSE
	/// Can't attack.
	can_act = FALSE
	/// Can't get pushed away during this.
	anchored = TRUE
	/// Reset our hit lists.
	dash_hitlist = list()
	dash_hitlist_turfs = list()

/// Called to begin dashing properly.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/BeginDash()
	dash_preparing = FALSE
	/// All turfs we move into while dashing as long as this variable is TRUE will be registered by Move() to be passed onto SweepTheBackstreetsHit() by SweepTheBackstreets().
	dash_dashing = TRUE
	/// We can't attack.
	can_act = FALSE
	/// We can move again.
	anchored = FALSE
	/// We can move through mobs and tables.
	pass_flags = PASSMOB | PASSTABLE
	density = FALSE

/// This is called when the dash is cancelled early by a failed movement or when the dash reached its destination. It just resets us back to our base state.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/CancelDash()
	dash_dashing = FALSE
	dash_preparing = FALSE
	pass_flags = initial(pass_flags)
	density = TRUE

/// Sweeper will sometimes enter Evasive Mode after a dash. Just a big mobility steroid and makes unpossessed sweepers move erratically - kind of like GWSS.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/lanky/proc/EvasiveMode()
	addtimer(CALLBACK(src, PROC_REF(DisableEvasiveMode)), 3 SECONDS)
	if(!client)
		dodging = TRUE
		minimum_distance = 1
		retreat_distance = 2
		sidestep_per_cycle = 2
		move_to_delay = 2.2
	/// Possessed sweepers get a smaller movement speed buff.
	else
		move_to_delay = 2.4

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
	var/extract_fuel_extra_damage = 15
	/// Extract Fuel will heal the sweeper for this much health
	var/extract_fuel_healing = 100
	/// This controls whether the next hit actually sets off Extract Fuel's additional effects
	var/extract_fuel_active = FALSE
	/// We store the timer we use for cancelling Extract Fuel so we can delete it early if we've already used it
	var/extract_fuel_ongoing_timer
	/// If we've already used 333... 1973 before, we don't want to use it ever again
	var/used_last_stand = FALSE

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/Initialize()
	. = ..()
	/// I know this is weird but I don't know how to ONLY override Initialize() for indigo_noon without getting rid of the code from simple_animal and whatnot.
	/// I have to set these things here because normal indigo_noon initialization sets them.
	icon_living = "sweeper_limbus"
	icon_state = icon_living
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	/// If we've dropped to or below 40% health, we may gain Persistence because we are evil and tough to put down.
	if(!used_last_stand && health <= maxHealth * 0.40 && prob(60))
		LastStand()
		return
	/// Next is the Extract Fuel trigger. I don't want them both to happen on the same hit so there's an early return in the previous block.
	/// I'm making them only fire it off with a chance to keep players guessing, instead of having them act too predictably.
	if(extract_fuel_cooldown <= world.time && prob(60))
		PrepareExtractFuel()

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/bullet_act(obj/projectile/P)
	. = ..()
	if(!used_last_stand && health <= maxHealth * 0.40 && prob(60))
		LastStand()
		return

/// This ability is basically "333... 1973". It gives the chunky sweeper 3 persistence stacks, that's all.
/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/proc/LastStand()
	if(stat == DEAD)
		return FALSE
	used_last_stand = TRUE
	say("+333... 1973.+")
	GainPersistence(3)

/// The following few code chunks are dedicated to the Extract Fuel mechanic specific to this sweeper type. Basically, it's a lifesteal hit they can use every once in a bit.
/// When the sweeper takes a hit, if it's off cooldown, it'll buff itself for its next hit and warn the player, giving them a brief grace period to disengage or prepare.
/// If they don't get away in time, they'll be hit by an empowered attack that gives persistence, heals the sweeper for a good chunk and spawns some gibs as VFX.
/// The buff goes away in 2.5 seconds or after landing the hit.
/// Extract Fuel doesn't get activated by ranged hits, but like, even if it did, it'd be useless. These things are REALLY slow and easy to kite.
/// But I don't have any intention of giving them some sort of countermeasure, it's just a Noon Ordeal...

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && extract_fuel_active && istype(attacked_target, /mob/living/carbon/human))
		CancelExtractFuel(TRUE)
		new /obj/effect/gibspawner/generic(get_turf(attacked_target))
		SweeperHealing(extract_fuel_healing)
		GainPersistence(1)
		visible_message(span_danger("The [src.name] tears into [attacked_target.name] and refuels itself with some of their viscera!"))

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/proc/PrepareExtractFuel()
	/// I have no idea what could cause this, but just in case
	if(extract_fuel_active)
		return FALSE
	if(stat == DEAD)
		return FALSE
	/// Go on cooldown.
	extract_fuel_cooldown = world.time + extract_fuel_cooldown_time
	/// Warn the players so they can back off or get ready to parry.
	say("+38725 619.+")
	animate(src, 2 SECONDS, color = "#FE5343")
	visible_message(span_danger("The [src.name] winds up for a devastating blow!"), span_info("You prepare to extract fuel from your victim."))
	/// We're gonna sleep them because otherwise someone could hit the sweeper the DECISECOND before it's gonna attack and get slapped by a huge hit
	/// This gives them enough margin to run away or parry
	SLEEP_CHECK_DEATH(0.6 SECONDS)
	/// Make our attack scary.
	melee_damage_lower += extract_fuel_extra_damage
	melee_damage_upper += extract_fuel_extra_damage
	attack_sound = 'sound/weapons/fixer/generic/finisher1.ogg'
	extract_fuel_active = TRUE
	/// If we haven't landed the hit in the following few seconds, we will lose the buff.
	extract_fuel_ongoing_timer = addtimer(CALLBACK(src, PROC_REF(CancelExtractFuel), FALSE), 2.6 SECONDS, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/ordeal/indigo_noon/chunky/proc/CancelExtractFuel(early)
	/// Timer cleanup
	ExtractFuelTimerCleanup()
	/// We go back to normal.
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	extract_fuel_active = FALSE
	animate(src, 0.5 SECONDS, color = initial(color))
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
	duration = 35 SECONDS
	alert_type = null
	var/mutable_appearance/overlay
	stacks = 1
	max_stacks = 3
	stack_decay = 0
	consumed_on_threshold = FALSE
	var/base_chance = 25
	var/health_recovery_per_stack = 40

/// I don't really want it to decay, so
/datum/status_effect/stacking/sweeper_persistence/tick()
	if(!can_have_status())
		qdel(src)

/datum/status_effect/stacking/sweeper_persistence/on_apply()
	. = ..()

	if(!owner)
		return
	var/icon/sweepericon = icon(owner.icon, owner.icon_state, owner.dir)
	var/icon_height = sweepericon.Height()
	overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "sweeper_persistence", -MUTATIONS_LAYER)
	overlay.pixel_x = 4
	overlay.pixel_y = icon_height - 28
	if(icon_height == 32)
		overlay.transform *= 0.80
	owner.add_overlay(overlay)
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(CheckDeath))

/datum/status_effect/stacking/sweeper_persistence/add_stacks(stacks_added)
	. = ..()
	/// I don't think I have to do any further cleanup, it should get qdel'd by Process() right?
	if(stacks <= 0)
		if(owner)
			owner.remove_status_effect(STATUS_EFFECT_PERSISTENCE)
		return
	/// Refresh the duration on Persistence after gaining or losing a stack.
	duration = initial(duration) + world.time

/datum/status_effect/stacking/sweeper_persistence/on_remove()
	. = ..()
	if(!owner)
		return
	owner.cut_overlay(overlay)
	UnregisterSignal(src, COMSIG_MOB_APPLY_DAMGE)

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
	/// This stores "overkill" damage to reduce the chance of Persistence proccing (60 health takes 100 damage is 40 overkill damage)
	var/overkill_damage = damage_taken - neighbor.health
	/// Chance to proc Persistence is calculated here based on stacks. It can't be higher than 100 because... I don't know what happens if it's higher.
	/// Chances should be as follows (%, stack amt.): 50, 1 | 75, 2 | 100, 3
	/// Chance is lowered by Overkill damage to make using slower weapons less of a pain.
	var/chance = min(base_chance + stacks*25, 100)
	/// This can result in negative chances but it hasn't runtimed in my testing so all's fine right?
	var/final_chance = overkill_damage ? chance - (floor(overkill_damage / 5)) : chance

	var/trigger_healing = health_recovery_per_stack*stacks
	if(damage_taken >= neighbor.health)
		/// But it refused. Persistence goes off, we heal a tiny bit and lose a stack
		if(prob(final_chance))
			playsound(neighbor, 'sound/effects/ordeals/indigo_start.ogg', 33)
			INVOKE_ASYNC(neighbor, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ordeal/indigo_noon, SweeperHealing), trigger_healing)
			INVOKE_ASYNC(neighbor, TYPE_PROC_REF(/atom, visible_message), span_danger("The [neighbor.name] endures a fatal hit, some of the fuel being drained from its tank!"), span_userdanger("You suffer a lethal strike, losing some of your fuel!"))
			src.add_stacks(-1)
			return COMPONENT_MOB_DENY_DAMAGE
		/// Tough luck neighbor. Persistence didn't go off so the sweeper dies here. Status should get cleaned up next time it ticks.
		else
			playsound(neighbor, 'sound/misc/splort.ogg', 100)
			owner.cut_overlay(overlay)

	return

#undef STATUS_EFFECT_PERSISTENCE
