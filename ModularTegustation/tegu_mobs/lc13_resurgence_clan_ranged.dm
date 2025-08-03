// Resurgence Clan Ranged Units and Special Mobs

// Base ranged clan mob
/mob/living/simple_animal/hostile/clan/ranged
	name = "Clan Ranged Unit"
	desc = "A ranged combat unit of the Resurgence Clan."
	icon_state = "clan_scout"
	icon_living = "clan_scout"
	icon_dead = "clan_scout_dead"
	ranged = TRUE
	retreat_distance = 5
	minimum_distance = 4
	ranged_cooldown_time = 30
	projectiletype = /obj/projectile/clan_bullet
	projectilesound = 'sound/weapons/laser2.ogg'
	check_friendly_fire = TRUE
	charge = 10
	max_charge = 20
	var/special_attack_cost = 5
	var/special_attack_cooldown = 0
	var/special_attack_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/clan/ranged/OpenFire(atom/A)
	if(charge >= special_attack_cost && world.time > special_attack_cooldown)
		if(prob(30))
			SpecialAttack(A)
			return
	return ..()

/mob/living/simple_animal/hostile/clan/ranged/proc/SpecialAttack(atom/target)
	return

// Clan Sniper - Long range, high damage, slow fire rate
/mob/living/simple_animal/hostile/clan/ranged/sniper
	name = "Clan Sniper"
	desc = "A long-range precision unit equipped with a high-powered energy rifle."
	icon_state = "clan_scout"
	maxHealth = 400
	health = 400
	vision_range = 15
	aggro_vision_range = 15
	ranged_cooldown_time = 50
	retreat_distance = 10
	minimum_distance = 8
	projectiletype = /obj/projectile/clan_bullet/sniper
	move_to_delay = 5
	melee_damage_lower = 5
	melee_damage_upper = 10

/mob/living/simple_animal/hostile/clan/ranged/sniper/SpecialAttack(atom/target)
	if(charge < special_attack_cost || world.time < special_attack_cooldown)
		return

	charge -= special_attack_cost
	special_attack_cooldown = world.time + special_attack_cooldown_time

	visible_message(span_danger("[src] charges up a powerful shot!"))
	playsound(src, 'sound/weapons/beam_sniper.ogg', 100, TRUE)

	// Visual effect
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc, src)
	animate(D, alpha = 0, time = 10)

	// Fire piercing shot after brief delay
	addtimer(CALLBACK(src, PROC_REF(FirePiercingShot), target), 1 SECONDS)

/mob/living/simple_animal/hostile/clan/ranged/sniper/proc/FirePiercingShot(atom/target)
	if(stat == DEAD || !target)
		return

	var/turf/startloc = get_turf(src)
	var/obj/projectile/clan_bullet/piercing/P = new(startloc)
	P.preparePixelProjectile(target, src)
	P.firer = src
	P.fire()
	playsound(src, 'sound/weapons/laser3.ogg', 100, TRUE)

// Clan Gunner - Medium range, balanced
/mob/living/simple_animal/hostile/clan/ranged/gunner
	name = "Clan Gunner"
	desc = "A standard ranged combat unit with a rapid-fire energy weapon."
	icon_state = "clan_scout"
	maxHealth = 600
	health = 600
	vision_range = 10
	aggro_vision_range = 10
	ranged_cooldown_time = 20
	retreat_distance = 6
	minimum_distance = 4
	projectiletype = /obj/projectile/clan_bullet/medium
	move_to_delay = 3

/mob/living/simple_animal/hostile/clan/ranged/gunner/SpecialAttack(atom/target)
	if(charge < special_attack_cost || world.time < special_attack_cooldown)
		return

	charge -= special_attack_cost
	special_attack_cooldown = world.time + special_attack_cooldown_time

	visible_message(span_danger("[src] unleashes a burst of fire!"))
	playsound(src, 'sound/weapons/fixer/generic/energy1.ogg', 75, TRUE)

	// Fire 3 shots in quick succession
	for(var/i in 1 to 3)
		addtimer(CALLBACK(src, PROC_REF(BurstFire), target), i * 2)

/mob/living/simple_animal/hostile/clan/ranged/gunner/proc/BurstFire(atom/target)
	if(stat == DEAD || !target)
		return

	var/turf/startloc = get_turf(src)
	var/obj/projectile/clan_bullet/medium/P = new(startloc)
	P.preparePixelProjectile(target, src)
	P.firer = src
	P.fire()
	playsound(src, projectilesound, 50, TRUE)

// Clan Rapid Drone - Short range, fast fire rate, low damage
/mob/living/simple_animal/hostile/clan/ranged/rapid_drone
	name = "Clan Rapid Drone"
	desc = "A small, agile drone equipped with twin micro-blasters."
	icon_state = "clan_scout"
	maxHealth = 300
	health = 300
	vision_range = 7
	aggro_vision_range = 7
	ranged_cooldown_time = 10
	retreat_distance = 4
	minimum_distance = 2
	projectiletype = /obj/projectile/clan_bullet/rapid
	move_to_delay = 2
	move_resist = MOVE_FORCE_NORMAL
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/hostile/clan/ranged/rapid_drone/SpecialAttack(atom/target)
	if(charge < special_attack_cost || world.time < special_attack_cooldown)
		return

	charge -= special_attack_cost
	special_attack_cooldown = world.time + special_attack_cooldown_time

	visible_message(span_danger("[src] overclocks its weapons!"))
	playsound(src, 'sound/machines/buzz-two.ogg', 75, TRUE)

	// Temporarily increase fire rate
	ranged_cooldown_time = 5
	addtimer(CALLBACK(src, PROC_REF(ResetFireRate)), 5 SECONDS)

/mob/living/simple_animal/hostile/clan/ranged/rapid_drone/proc/ResetFireRate()
	ranged_cooldown_time = initial(ranged_cooldown_time)
	visible_message(span_notice("[src]'s weapons return to normal."))

// Projectile types
/obj/projectile/clan_bullet
	name = "energy bolt"
	icon_state = "laser"
	damage = 15
	damage_type = RED_DAMAGE

/obj/projectile/clan_bullet/sniper
	name = "high-energy bolt"
	damage = 60
	speed = 0.3

/obj/projectile/clan_bullet/piercing
	name = "piercing energy bolt"
	damage = 80
	speed = 0.3
	movement_type = PHASING

/obj/projectile/clan_bullet/medium
	damage = 25

/obj/projectile/clan_bullet/rapid
	name = "micro energy bolt"
	damage = 10
	speed = 0.5

// Bomber Spider
/mob/living/simple_animal/hostile/clan/bomber_spider
	name = "Clan Bomber Spider"
	desc = "A tiny mechanical spider packed with explosives. It seems to be targeting structures..."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_repair_hacked"
	icon_living = "drone_repair_hacked"
	icon_dead = "drone_repair_hacked_dead"
	maxHealth = 100
	health = 100
	melee_damage_lower = 5
	melee_damage_upper = 10
	move_to_delay = 5
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	guaranteed_butcher_results = list()
	search_objects = 2
	wanted_objects = list(/obj/structure/barricade, /obj/machinery/manned_turret/rcorp)
	del_on_death = TRUE
	var/primed = FALSE
	var/explosion_damage = 300
	var/explosion_range = 1

/mob/living/simple_animal/hostile/clan/bomber_spider/Life()
	. = ..()
	if(!.)
		return

	// Try to hide under other mobs
	if(!primed)
		for(var/mob/living/L in loc)
			if(L != src && L.density)
				layer = L.layer - 0.1
				return

/mob/living/simple_animal/hostile/clan/bomber_spider/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!. || primed)
		return

	if(isstructure(attacked_target) || ismachinery(attacked_target))
		Prime()

/mob/living/simple_animal/hostile/clan/bomber_spider/proc/Prime()
	if(primed)
		return

	primed = TRUE
	visible_message(span_userdanger("[src] begins to swell and glow!"))

	walk_to(src, 0)
	say("De-etona-ate...")
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)

	// Explode after delay
	addtimer(CALLBACK(src, PROC_REF(Detonate)), 1.5 SECONDS)

/mob/living/simple_animal/hostile/clan/bomber_spider/proc/Detonate()
	visible_message(span_userdanger("[src] detonates!"))

	// Deal massive damage to structures in range
	for(var/turf/T in view(explosion_range, src))
		for(var/atom/A in T)
			if(isstructure(A) || ismachinery(A))
				if(istype(A, /obj/structure))
					var/obj/structure/S = A
					S.take_damage(explosion_damage, RED_DAMAGE, "bomb", 0)
				else if(istype(A, /obj/machinery))
					var/obj/machinery/M = A
					M.take_damage(explosion_damage, RED_DAMAGE, "bomb", 0)

	// Visual explosion
	playsound(loc, 'sound/effects/explosion1.ogg', 50, TRUE)
	new /obj/effect/temp_visual/explosion(loc)

	// Die
	death()

// Artillery Cannon
/mob/living/simple_animal/hostile/clan/artillery
	name = "Clan Artillery Cannon"
	desc = "A massive, slow-moving artillery unit. It seems to be collecting something..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "large_engine"
	icon_living = "large_engine"
	icon_dead = "large_engine"
	teleport_away = TRUE
	maxHealth = 2000
	health = 2000
	pixel_x = -32
	base_pixel_x = -32
	move_to_delay = 10
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	melee_damage_lower = 30
	melee_damage_upper = 40
	retreat_distance = 0
	minimum_distance = 0
	mob_size = MOB_SIZE_LARGE
	var/list/stored_mobs = list()
	var/max_stored_mobs = 5
	var/collection_range = 8
	var/launch_range = 12
	var/last_collection_time = 0
	var/collection_cooldown = 5 SECONDS

/mob/living/simple_animal/hostile/clan/artillery/Initialize()
	. = ..()
	SetOccupiedTiles(1, 1, 1, 1)
	START_PROCESSING(SSobj, src)

/mob/living/simple_animal/hostile/clan/artillery/Destroy()
	// Release all stored mobs
	for(var/mob/living/L in stored_mobs)
		L.forceMove(loc)
	stored_mobs.Cut()
	STOP_PROCESSING(SSobj, src)
	return ..()

/mob/living/simple_animal/hostile/clan/artillery/process()
	if(stat == DEAD)
		return

	// Try to collect mobs
	if(world.time > last_collection_time + collection_cooldown && length(stored_mobs) < max_stored_mobs)
		CollectMob()

	// Launch when full
	if(length(stored_mobs) >= max_stored_mobs - 1)
		LaunchMobs()

/mob/living/simple_animal/hostile/clan/artillery/proc/CollectMob()
	var/list/potential_targets = list()

	for(var/mob/living/L in view(collection_range, src))
		if(L == src || L.stat == DEAD)
			continue
		if(!faction_check_mob(L))
			continue
		if(L in stored_mobs)
			continue
		potential_targets += L

	if(!length(potential_targets))
		return

	var/mob/living/target = pick(potential_targets)

	// Teleport effect
	playsound(target, 'sound/effects/phasein.ogg', 50, TRUE)
	new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target))

	// Store the mob
	target.forceMove(src)
	stored_mobs += target
	last_collection_time = world.time

	visible_message(span_warning("[src] absorbs [target]!"))

/mob/living/simple_animal/hostile/clan/artillery/proc/LaunchMobs()
	if(!length(stored_mobs))
		return

	// Find target
	var/list/potential_targets = list()
	for(var/mob/living/carbon/C in view(launch_range, src))
		if(faction_check_mob(C))
			continue
		potential_targets += C

	if(!length(potential_targets))
		// No targets, just dump mobs
		for(var/mob/living/L in stored_mobs)
			L.forceMove(get_turf(src))
		stored_mobs.Cut()
		return

	var/mob/living/launch_target = pick(potential_targets)
	var/turf/target_turf = get_turf(launch_target)

	visible_message(span_userdanger("[src] aims at [launch_target] and fires!"))
	playsound(src, 'sound/vehicles/carcannon1.ogg', 100, TRUE)

	// Launch all mobs in a burst pattern
	var/list/turfs_near_target = list()
	for(var/turf/T in view(2, target_turf))
		if(!T.density)
			turfs_near_target += T

	for(var/mob/living/L in stored_mobs)
		var/turf/landing_turf = length(turfs_near_target) ? pick(turfs_near_target) : target_turf

		// Create launch effect
		L.forceMove(loc)
		L.throw_at(landing_turf, 10, 2)

		// Stun on landing
		addtimer(CALLBACK(src, PROC_REF(StunOnLanding), L), 1 SECONDS)

		// Visual effect
		new /obj/effect/temp_visual/teleport_abductor(get_turf(L))

	stored_mobs.Cut()

/mob/living/simple_animal/hostile/clan/artillery/proc/StunOnLanding(mob/living/L)
	if(!L || L.stat == DEAD)
		return
	L.Paralyze(20)
	playsound(L, 'sound/effects/meteorimpact.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/clan/artillery/examine(mob/user)
	. = ..()
	. += span_notice("Stored mobs: [length(stored_mobs)]/[max_stored_mobs]")

// Siege Walker - Massive crushing unit that collects mobs
/mob/living/simple_animal/hostile/clan/siege_walker
	name = "Clan Siege Walker"
	desc = "A colossal mechanical war machine, designed to crush everything in its path. Its grinding treads leave nothing but destruction."
	icon = 'icons/obj/bike.dmi'
	icon_state = "speedwagon"
	icon_living = "speedwagon"
	icon_dead = "speedwagon"
	pixel_x = -48
	pixel_y = -48
	base_pixel_x = -48
	base_pixel_y = -48
	maxHealth = 4000
	health = 4000
	move_to_delay = 30 // Very slow
	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
	melee_damage_lower = 50
	melee_damage_upper = 70
	mob_size = MOB_SIZE_HUGE
	layer = LARGE_MOB_LAYER
	stat_attack = DEAD
	del_on_death = FALSE
	robust_searching = FALSE
	AIStatus = AI_OFF // We control movement manually
	
	// Path and movement vars
	var/list/movement_path = list()
	var/moving = FALSE
	var/turf/target_destination
	var/crush_damage = 500
	var/move_delay = 2 SECONDS
	var/last_path_highlight = 0
	var/path_highlight_interval = 20 SECONDS
	
	// Collection system
	var/list/stored_mobs = list()
	var/max_stored_mobs = 8
	var/collection_range = 4
	var/collecting_enabled = TRUE
	var/collection_cooldown = 0
	var/collection_disable_time = 10 SECONDS
	
	// Dropping system
	var/last_drop_time = 0
	var/drop_cooldown = 5 SECONDS
	var/mobs_per_drop = 2

/mob/living/simple_animal/hostile/clan/siege_walker/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_MOVE_PHASING, INNATE_TRAIT) // Can move through dense objects
	// Add the speedwagon cover overlay
	var/mutable_appearance/overlay = mutable_appearance(icon, "speedwagon_cover", ABOVE_MOB_LAYER)
	add_overlay(overlay)

/mob/living/simple_animal/hostile/clan/siege_walker/Life()
	. = ..()
	if(!.)
		return
		
	// Re-enable collection after cooldown
	if(!collecting_enabled && world.time > collection_cooldown)
		collecting_enabled = TRUE
		visible_message(span_notice("[src]'s collection systems reactivate."))
	
	// Collect nearby mobs if enabled
	if(collecting_enabled && moving && length(stored_mobs) < max_stored_mobs)
		CollectNearbyMobs()
		
	// Re-highlight path periodically
	if(moving && world.time > last_path_highlight + path_highlight_interval)
		HighlightPath()
		priority_announce("WARNING: Siege Walker still active! Evacuate from highlighted areas!", "SIEGE WALKER UPDATE", 'sound/misc/notice2.ogg')
		
	// Auto-target nearest enemy structure if not moving
	if(!moving && prob(10))
		var/list/potential_targets = list()
		for(var/obj/structure/S in view(15, src))
			if(S.density && !istype(S, /obj/structure/barricade/clan))
				potential_targets += S
		for(var/obj/machinery/M in view(15, src))
			if(M.density)
				potential_targets += M
				
		if(length(potential_targets))
			var/atom/target = pick(potential_targets)
			SetDestination(get_turf(target))

/mob/living/simple_animal/hostile/clan/siege_walker/Destroy()
	// Release all stored mobs
	for(var/mob/living/L in stored_mobs)
		L.forceMove(get_turf(src))
	stored_mobs.Cut()
	return ..()

/mob/living/simple_animal/hostile/clan/siege_walker/examine(mob/user)
	. = ..()
	. += span_notice("Stored mobs: [length(stored_mobs)]/[max_stored_mobs]")
	if(!collecting_enabled)
		. += span_warning("Collection systems disabled for [round((collection_cooldown - world.time) / 10)] seconds.")
	if(moving)
		. += span_boldnotice("Currently moving towards its destination.")

/mob/living/simple_animal/hostile/clan/siege_walker/proc/SetDestination(turf/T)
	if(!T || moving)
		return FALSE
		
	target_destination = T
	StartPathing()
	return TRUE

/mob/living/simple_animal/hostile/clan/siege_walker/proc/StartPathing()
	if(!target_destination || moving)
		return
		
	// Create path ignoring density
	movement_path = get_path_to(src, target_destination, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200, 1, TYPE_PROC_REF(/turf, TurfBlockedNoDensity))
	
	if(!length(movement_path))
		visible_message(span_warning("[src] cannot find a path to its destination!"))
		return
		
	// Global announcement
	priority_announce("EMERGENCY: Massive siege unit detected! All personnel evacuate from marked areas immediately! The unit will crush everything in its path!", "SIEGE WALKER ALERT", 'sound/machines/alarm.ogg')
	
	// Visual warning
	visible_message(span_userdanger("[src] begins plotting its destructive path!"))
	playsound(src, 'sound/mecha/mechstep.ogg', 100, TRUE)
	
	// Show the path with glowing effect
	HighlightPath()
		
	// Countdown warnings
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(priority_announce), "Siege Walker advancing in 3 seconds!", "FINAL WARNING", 'sound/misc/notice1.ogg'), 0)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, visible_message), span_boldwarning("SIEGE WALKER ADVANCING IN 2...")), 1 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, visible_message), span_boldwarning("SIEGE WALKER ADVANCING IN 1...")), 2 SECONDS)
		
	// Start moving after a delay
	addtimer(CALLBACK(src, PROC_REF(StartMoving)), 3 SECONDS)

/mob/living/simple_animal/hostile/clan/siege_walker/proc/StartMoving()
	if(!length(movement_path))
		return
		
	moving = TRUE
	visible_message(span_userdanger("[src] begins its inexorable advance!"))
	playsound(src, 'sound/mecha/mechstep.ogg', 100, TRUE)
	
	ProcessMovement()

/mob/living/simple_animal/hostile/clan/siege_walker/proc/ProcessMovement()
	if(!moving || !length(movement_path))
		StopMoving()
		return
		
	var/turf/next_turf = movement_path[1]
	movement_path.Cut(1, 2)
	
	// Face the direction we're moving
	face_atom(next_turf)
	
	// Crush everything in the destination
	CrushTurf(next_turf)
	
	// Move to the turf
	forceMove(next_turf)
	playsound(src, 'sound/mecha/mechmove04.ogg', 75, TRUE)
	
	// Shake nearby turfs
	for(var/turf/T in range(2, src))
		if(prob(50))
			new /obj/effect/temp_visual/decoy/fading(T)
			
	// Continue moving
	if(length(movement_path))
		addtimer(CALLBACK(src, PROC_REF(ProcessMovement)), move_delay)
	else
		StopMoving()

/mob/living/simple_animal/hostile/clan/siege_walker/proc/StopMoving()
	moving = FALSE
	movement_path = list()
	visible_message(span_notice("[src] comes to a grinding halt."))
	priority_announce("Siege Walker has reached its destination and stopped moving. Threat level reduced.", "Siege Walker Status", 'sound/misc/notice2.ogg')

/mob/living/simple_animal/hostile/clan/siege_walker/proc/HighlightPath()
	if(!length(movement_path))
		return
		
	last_path_highlight = world.time
	
	// Create glowing effect on path
	for(var/turf/T in movement_path)
		// Create multiple effects for a more dramatic warning
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, pick(GLOB.alldirs))
		new /obj/effect/temp_visual/cult/sparks(T)
		
		// Add a glowing overlay that lasts longer
		var/obj/effect/overlay/O = new(T)
		O.icon = 'icons/effects/effects.dmi'
		O.icon_state = "shield-old"
		O.color = "#FF0000"
		O.alpha = 100
		animate(O, alpha = 0, time = 30, easing = QUAD_EASING)
		QDEL_IN(O, 3 SECONDS)
		
	// Warning sound along the path
	for(var/mob/living/L in range(7, src))
		if(L.client)
			L.playsound_local(L, 'sound/machines/warning-buzzer.ogg', 50, FALSE)

/mob/living/simple_animal/hostile/clan/siege_walker/proc/CrushTurf(turf/T)
	// Destroy all dense objects
	for(var/obj/structure/S in T)
		if(S.density)
			visible_message(span_boldwarning("[src] crushes [S]!"))
			if(istype(S, /obj/structure/barricade))
				S.take_damage(crush_damage * 2, BRUTE, "melee", 0) // Extra damage to barricades
			else
				S.take_damage(crush_damage, BRUTE, "melee", 0)
				
	for(var/obj/machinery/M in T)
		if(M.density)
			visible_message(span_boldwarning("[src] crushes [M]!"))
			M.take_damage(crush_damage, BRUTE, "melee", 0)
			
	// Open or destroy doors
	for(var/obj/machinery/door/D in T)
		if(D.density)
			if(prob(70))
				D.open()
			else
				visible_message(span_boldwarning("[src] smashes through [D]!"))
				D.take_damage(crush_damage, BRUTE, "melee", 0)
				
	// Damage mobs
	for(var/mob/living/L in T)
		if(L == src)
			continue
		if(faction_check_mob(L) && !ismecha(L))
			continue
		visible_message(span_userdanger("[src] runs over [L]!"))
		playsound(L, 'sound/effects/blobattack.ogg', 75, TRUE)
		L.apply_damage(100, BRUTE, spread_damage = TRUE)
		L.Paralyze(30)
		new /obj/effect/temp_visual/kinetic_blast(T)

/mob/living/simple_animal/hostile/clan/siege_walker/proc/CollectNearbyMobs()
	for(var/mob/living/L in range(collection_range, src))
		if(L == src || L.stat == DEAD)
			continue
		if(!faction_check_mob(L))
			continue
		if(L in stored_mobs)
			continue
		if(length(stored_mobs) >= max_stored_mobs)
			break
			
		// Collect the mob
		visible_message(span_warning("[src] scoops up [L]!"))
		playsound(L, 'sound/effects/phasein.ogg', 50, TRUE)
		L.forceMove(src)
		stored_mobs += L
		new /obj/effect/temp_visual/dir_setting/ninja(get_turf(L))

/mob/living/simple_animal/hostile/clan/siege_walker/proc/DropMobs()
	if(world.time < last_drop_time + drop_cooldown || !length(stored_mobs))
		return
		
	last_drop_time = world.time
	var/mobs_to_drop = min(mobs_per_drop, length(stored_mobs))
	
	visible_message(span_warning("[src] deploys stored units!"))
	playsound(src, 'sound/mecha/mechstep.ogg', 75, TRUE)
	
	for(var/i in 1 to mobs_to_drop)
		if(!length(stored_mobs))
			break
		var/mob/living/L = pick(stored_mobs)
		stored_mobs -= L
		
		// Find a nearby turf to drop them
		var/list/possible_turfs = list()
		for(var/turf/T in range(2, src))
			if(!T.density)
				possible_turfs += T
				
		if(length(possible_turfs))
			var/turf/drop_turf = pick(possible_turfs)
			L.forceMove(drop_turf)
			L.Paralyze(20) // Brief stun
			new /obj/effect/temp_visual/teleport_abductor(drop_turf)

/mob/living/simple_animal/hostile/clan/siege_walker/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	// Disable collection and drop mobs when attacked
	if(collecting_enabled)
		collecting_enabled = FALSE
		collection_cooldown = world.time + collection_disable_time
		visible_message(span_warning("[src]'s collection systems malfunction from the damage!"))
		playsound(src, 'sound/machines/warning-buzzer.ogg', 75, TRUE)
		
	DropMobs()

/mob/living/simple_animal/hostile/clan/siege_walker/bullet_act(obj/projectile/P)
	. = ..()
	// Same as melee attacks
	if(collecting_enabled)
		collecting_enabled = FALSE
		collection_cooldown = world.time + collection_disable_time
		visible_message(span_warning("[src]'s collection systems malfunction from the damage!"))
		playsound(src, 'sound/machines/warning-buzzer.ogg', 75, TRUE)
		
	DropMobs()

// Custom pathfinding proc that ignores density
/turf/proc/TurfBlockedNoDensity(caller)
	return FALSE // Never blocked, we crush through everything
