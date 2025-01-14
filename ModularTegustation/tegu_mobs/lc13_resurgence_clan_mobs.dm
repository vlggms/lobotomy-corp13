/mob/living/simple_animal/hostile/clan
	name = "Clan Member..."
	desc = "You should not bee seeing this!"
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_scout"
	icon_living = "clan_scout"
	icon_dead = "clan_scout_dead"
	faction = list("resurgence_clan", "hostile")
	mob_biotypes = MOB_ROBOTIC
	gender = NEUTER
	speech_span = SPAN_ROBOT
	emote_hear = list("creaks.", "emits the sound of grinding gears.")
	maxHealth = 500
	health = 500
	death_message = "falls to their knees as their lights slowly go out..."
	melee_damage_lower = 5
	melee_damage_upper = 7
	mob_size = MOB_SIZE_HUGE
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	a_intent = INTENT_HARM
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	attack_sound = 'sound/weapons/purple_tear/stab2.ogg'
	butcher_results = list(/obj/item/food/meat/slab/robot = 1, /obj/item/food/meat/slab/sweeper = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 2, /obj/item/food/meat/slab/sweeper = 1)
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1)
	var/charge = 0
	var/max_charge = 10
	var/clan_charge_cooldown = 2 SECONDS
	var/last_charge_update = 0

/mob/living/simple_animal/hostile/clan/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/clan/proc/GainCharge()
	if(stat == DEAD)
		charge = 0
		return

	if (charge < max_charge)
		charge += 1
		new /obj/effect/temp_visual/healing/charge(get_turf(src))
		ChargeUpdated()

/mob/living/simple_animal/hostile/clan/proc/ChargeUpdated()

/mob/living/simple_animal/hostile/clan/Life()
	. = ..()

	if (last_charge_update < world.time - clan_charge_cooldown)
		last_charge_update = world.time
		GainCharge()

//Clan Member: Scout
/mob/living/simple_animal/hostile/clan/scout
	name = "Scout"
	desc = "A humanoid looking machine wielding a spear... It appears to have 'Resurgence Clan' etched on their back..."
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	var/max_speed = 1.5
	var/normal_speed = 3
	var/max_attack_speed = 4
	var/normal_attack_speed = 1
	var/scout_speech_cooldown = 8 SECONDS
	var/last_speech_update = 0

/mob/living/simple_animal/hostile/clan/scout/ChargeUpdated()
	move_to_delay = normal_speed - (normal_speed - max_speed) * charge / max_charge
	rapid_melee = normal_attack_speed + (max_attack_speed - normal_attack_speed) * charge / max_charge
	UpdateSpeed()
	var/flamelayer = layer + 0.1
	var/flame
	if(charge > 7)
		cut_overlays()
		flame = "scout_blue"
	else if(charge > 3)
		cut_overlays()
		flame = "scout_red"
	else
		cut_overlays()
		return
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, flame, flamelayer)
	add_overlay(colored_overlay)

/mob/living/simple_animal/hostile/clan/scout/AttackingTarget()
	. = ..()
	if (charge > 7 && last_speech_update < world.time - scout_speech_cooldown)
		say("Co-mmen-cing Pr-otoco-l: Ra-pid Str-ik-es")
		last_speech_update = world.time

	if (charge > 1)
		charge -= 2

/mob/living/simple_animal/hostile/clan/scout/death(gibbed)
	. = ..()
	cut_overlays()
	charge = 0

//Clan Member: Defender
/mob/living/simple_animal/hostile/clan/defender
	name = "Defender"
	desc = "A humanoid looking machine with two shields... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_48x48.dmi'
	icon_state = "defender"
	icon_living = "defender"
	icon_dead = "defender_dead"
	pixel_x = -8
	base_pixel_x = -8
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	health = 1200
	maxHealth = 1200
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	attack_sound = 'sound/weapons/purple_tear/blunt2.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 2,
						/obj/item/stack/sheet/silk/azure_advanced = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 3, /obj/item/food/meat/slab/sweeper = 2)
	melee_damage_lower = 20
	melee_damage_upper = 25

	var/max_speed = 1.5
	var/normal_speed = 3

	var/list/locked_list = list()
	var/list/locked_tiles_list = list()
	var/stunned = FALSE

/mob/living/simple_animal/hostile/clan/defender/GainCharge()
	if (!stunned)
		. = ..()

/mob/living/simple_animal/hostile/clan/defender/AttackingTarget(atom/attacked_target)
	if (stunned)  // dont attack if coiled or stunned
		return FALSE
	if (charge >= 10)
		Lock()
	. = ..()

/mob/living/simple_animal/hostile/clan/defender/Move()
	if (stunned)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/clan/defender/proc/Lock()
	stunned = TRUE
	density = FALSE
	icon_state = "defender_locked_down"
	say("Co-mmen-cing Pr-otoco-l: Lo-ckdo-wn")
	// create tiles
	for(var/turf/T in view(2, src))
		var/obj/effect/defender_field/DF = new(T)
		locked_tiles_list += DF
		DF.defender = src
		for(var/mob/living/L in T)
			ApplyLock(L)
	// add timer to unstun and release players
	addtimer(CALLBACK(src, PROC_REF(Unlock)), charge * 10)

/mob/living/simple_animal/hostile/clan/defender/death(gibbed)
	charge = 0
	var/turf/T = get_turf(src)
	if (prob(25))
		new /obj/item/tape/resurgence/first(T)

	if (stunned == TRUE)
		Unlock()

	. =  ..()


/mob/living/simple_animal/hostile/clan/defender/proc/ApplyLock(mob/living/L)
	if(!faction_check_mob(L, FALSE))
		// apply status effect
		var/datum/status_effect/locked/S = L.has_status_effect(/datum/status_effect/locked)
		if(!S)
			S = L.apply_status_effect(/datum/status_effect/locked)
		if (!S.list_of_defenders.Find(src))
			S.list_of_defenders += src
			locked_list += L
		// keep a list of everyone locked

/mob/living/simple_animal/hostile/clan/defender/ChargeUpdated()
	if (charge >= max_charge)
		move_to_delay = max_speed
	else
		move_to_delay = normal_speed


/mob/living/simple_animal/hostile/clan/defender/proc/Unlock()
	if (stat == DEAD)
		return

	icon_state = "defender"
	density = TRUE
	// clear tiles
	for(var/obj/effect/defender_field/DF in locked_tiles_list)
		if (DF.defender == src)
			qdel(DF)

	// remove status effect
	for(var/mob/living/L in locked_list)
		var/datum/status_effect/locked/S = L.has_status_effect(/datum/status_effect/locked)
		if (S)
			if (S.list_of_defenders.len == 1)
				L.remove_status_effect(/datum/status_effect/locked)
			else
				S.list_of_defenders -= src
	locked_list = list()
	locked_tiles_list = list()
	// restart charge
	charge = 0
	stunned = FALSE
	GainCharge()

/obj/effect/defender_field
	name = "Locked Down"
	icon = 'icons/turf/floors.dmi'
	icon_state = "locked_down"
	alpha = 0
	anchored = TRUE
	var/mob/living/simple_animal/hostile/clan/defender/defender

/obj/effect/defender_field/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 0.5 SECONDS)

/obj/effect/defender_field/Crossed(atom/movable/AM)
	. = ..()
	if (isliving(AM))
		var/mob/living/L = AM
		defender.ApplyLock(L)

/datum/status_effect/locked
	id = "locked"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/locked
	var/list/list_of_defenders = list()


/atom/movable/screen/alert/status_effect/locked
	name = "Locked"
	desc = "You are being locked by a Defender!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "locked"


/datum/status_effect/locked/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(Moved))


/datum/status_effect/locked/proc/Moved(mob/user, atom/new_location)
	SIGNAL_HANDLER
	var/turf/newloc_turf = get_turf(new_location)
	var/turf/oldloc_turf = get_turf(user)
	var/valid_tile = FALSE
	var/standing_on_locked = FALSE

	for(var/obj/effect/defender_field/GR in oldloc_turf.contents)
		standing_on_locked = TRUE

	if (!standing_on_locked)
		qdel(src)

	for(var/obj/effect/defender_field/GR in newloc_turf.contents)
		valid_tile = TRUE

	if(!valid_tile)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/status_effect/locked/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
	return ..()

/mob/living/simple_animal/hostile/clan/drone
	name = "Drone"
	desc = "A drone hovering above the ground... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_drone"
	icon_living = "clan_drone"
	icon_dead = "clan_drone_dead"
	faction = list("resurgence_clan", "hostile")
	emote_hear = list("creaks.", "emits the sound of grinding gears.")
	maxHealth = 1000
	health = 1000
	is_flying_animal = TRUE
	death_message = "falls down as their lights slowly go out..."
	melee_damage_lower = 10
	melee_damage_upper = 12
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	attack_sound = 'sound/weapons/emitter2.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 2,
						/obj/item/stack/sheet/silk/azure_advanced = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 3, /obj/item/food/meat/slab/sweeper = 2)
	charge = 10
	max_charge = 20
	clan_charge_cooldown = 1 SECONDS
	ranged = TRUE
	retreat_distance = 1
	minimum_distance = 2
	move_to_delay = 2
	var/overheal_threshold = 0.2
	var/heal_per_charge = 25
	var/healing_range = 6
	var/searching_range = 10
	var/datum/beam/current_beam
	var/overheal_cooldown
	var/overheal_cooldown_time = 50
	var/update_beam_timer


/mob/living/simple_animal/hostile/clan/drone/Initialize()
	. = ..()
	update_beam_timer = addtimer(CALLBACK(src, .proc/update_beam), 5 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/clan/drone/ChargeUpdated()
	var/chargelayer = layer + 0.1
	var/charge_icon
	if(charge > 19)
		cut_overlays()
		charge_icon = "clan_drone_100%"
	else if(charge > 15)
		cut_overlays()
		charge_icon = "clan_drone_75%"
	else if(charge > 10)
		cut_overlays()
		charge_icon = "clan_drone_50%"
	else if(charge > 5)
		cut_overlays()
		charge_icon = "clan_drone_25%"
	else
		cut_overlays()
		return
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, charge_icon, chargelayer)
	add_overlay(colored_overlay)

/mob/living/simple_animal/hostile/clan/drone/Life()
	. = ..()
	if (stat == DEAD)
		return

	if (istype(target, /mob))
		var/mob/M = target
		if (M && M.stat == DEAD)
			remove_beam()
			LoseTarget()
	if (current_beam && (!target || !can_see(src, target, healing_range) || (length(current_beam.elements) == 0)))
		remove_beam()
	else
		try_to_heal()
		if (current_beam && target)
			on_beam_tick(target)
			if (istype(target, /mob/living))
				var/mob/living/L = target
				if (L.health / L.maxHealth < overheal_threshold)
					var/missingHealth = L.maxHealth - L.health
					var/neededCharge = round(missingHealth / heal_per_charge)
					if (charge > 0 && overheal_cooldown < world.time)
						say("Co-mmen-cing Pr-otoco-l: E-mergency Re-pairs")
						var/mutable_appearance/overheal_overlay = mutable_appearance('icons/effects/effects.dmi', "purplesparkles")
						L.add_overlay(overheal_overlay)
						addtimer(CALLBACK(src, PROC_REF(clear_overlay), overheal_overlay, L), 2.5 SECONDS)
						overheal_cooldown = world.time + overheal_cooldown_time
						if (charge <= neededCharge)
							L.adjustBruteLoss(-1 * charge * heal_per_charge)
							charge = 0
						else
							L.adjustBruteLoss(-1 * missingHealth)
							charge -= neededCharge

/mob/living/simple_animal/hostile/clan/drone/proc/clear_overlay(mutable_appearance/overheal_overlay, mob/living/L)
	L.cut_overlay(overheal_overlay)

/mob/living/simple_animal/hostile/clan/drone/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/clan/drone/OpenFire()
	return FALSE

/mob/living/simple_animal/hostile/clan/drone/CanAttack(atom/the_target)
	if (istype(the_target, /mob))
		var/mob/M = the_target
		return faction_check_mob(M, FALSE) && M.stat != DEAD
	else
		return FALSE

/mob/living/simple_animal/hostile/clan/drone/proc/try_to_heal()
	if (target && can_see(src, target, healing_range) && !current_beam )
		create_beam(target)

/mob/living/simple_animal/hostile/clan/drone/proc/update_beam()
	var/mob/living/potential_target
	var/potential_health_missing = 0.01
	for(var/mob/living/L in view(searching_range, src))
		if(L != src && faction_check_mob(L, FALSE) && L.stat != DEAD)
			var/missing = (L.maxHealth - L.health)/L.maxHealth
			if (missing > potential_health_missing)
				potential_target = L
				potential_health_missing = missing

	if (potential_target && target && potential_target != target)
		remove_beam()
		target = potential_target
		if(ai_controller)
			ai_controller.current_movement_target = target


// Beams from Priest Code
/mob/living/simple_animal/hostile/clan/drone/proc/create_beam(mob/living/target)
	current_beam = Beam(target, icon_state="medbeam", time=INFINITY, maxdistance=healing_range * 2, beam_type=/obj/effect/ebeam/medical)

/mob/living/simple_animal/hostile/clan/drone/proc/remove_beam()
	if(current_beam)
		qdel(current_beam)
		current_beam = null

/mob/living/simple_animal/hostile/clan/drone/death(gibbed)
	. = ..()
	cut_overlays()
	remove_beam()
	deltimer(update_beam_timer)

/mob/living/simple_animal/hostile/clan/drone/proc/on_beam_tick(mob/living/target)
	if(target.health != target.maxHealth )
		new /obj/effect/temp_visual/heal(get_turf(target), "#E02D2D")
	target.adjustBruteLoss(-5)
	target.adjustFireLoss(-4)
	target.adjustToxLoss(-1)
	target.adjustOxyLoss(-1)
	if (istype(target, /mob/living/simple_animal/hostile/clan))
		var/mob/living/simple_animal/hostile/clan/C = target
		if (C.charge < C.max_charge)
			C.GainCharge()
	return
