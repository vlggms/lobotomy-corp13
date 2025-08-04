// Resurgence Clan Ranged Units and Special Mobs

// Base ranged clan mob - provides charge system and special attack framework
// All ranged clan units can build up charge over time and spend it on special abilities
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
	projectilesound = 'sound/weapons/laser.ogg'
	charge = 10
	max_charge = 20
	teleport_away = TRUE
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

// Clan Sniper - Long range precision unit
// - Shows a 3-second aiming laser before firing (like last_shot abnormality)
// - Special ability: Piercing shot that goes through all targets in a line
// - High damage, slow fire rate, maintains long distance from targets
/mob/living/simple_animal/hostile/clan/ranged/sniper
	name = "sniper unit"
	desc = "A long-range precision unit equipped with a high-powered energy rifle."
	icon_state = "clan_sniper"
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
	var/can_act = TRUE
	var/datum/beam/current_beam = null
	var/aiming = FALSE

/mob/living/simple_animal/hostile/clan/ranged/sniper/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/clan/ranged/sniper/AttackingTarget()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/clan/ranged/sniper/OpenFire(atom/A)
	if(!can_act || aiming)
		return FALSE
	if(PrepareToFire(A))
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/clan/ranged/sniper/proc/PrepareToFire(atom/A)
	// Start aiming sequence
	aiming = TRUE
	can_act = FALSE
	visible_message(span_danger("[src] takes aim at [A]!"))
	playsound(src, 'sound/weapons/beam_sniper.ogg', 75, TRUE)

	// Create aiming beam
	current_beam = Beam(A, icon_state="blood", time = 3 SECONDS)

	// Wait for aim time
	SLEEP_CHECK_DEATH(30)

	// Clean up beam
	if(current_beam)
		QDEL_NULL(current_beam)

	// Check if target is still valid
	if(stat == DEAD)
		can_act = TRUE
		aiming = FALSE
		return FALSE

	can_act = TRUE
	aiming = FALSE
	return TRUE

/mob/living/simple_animal/hostile/clan/ranged/sniper/SpecialAttack(atom/target)
	if(charge < special_attack_cost || world.time < special_attack_cooldown || !can_act || aiming)
		return

	charge -= special_attack_cost
	special_attack_cooldown = world.time + special_attack_cooldown_time

	// Fire piercing shot immediately (no additional delay since we already aimed)
	FirePiercingShot(target)

/mob/living/simple_animal/hostile/clan/ranged/sniper/proc/FirePiercingShot(atom/target)
	if(stat == DEAD || !target)
		return

	visible_message(span_danger("[src] fires a piercing shot!"))
	var/turf/startloc = get_turf(src)
	var/obj/projectile/clan_bullet/piercing/P = new(startloc)
	P.preparePixelProjectile(target, src)
	P.firer = src
	P.fire()
	playsound(src, 'sound/weapons/laser3.ogg', 100, TRUE)

// Clan Gunner - Balanced combat unit
// - Standard ranged attacker with good damage output
// - Special ability: Burst fire that shoots 3 projectiles rapidly
// - Fires twice as fast with half damage per shot
/mob/living/simple_animal/hostile/clan/ranged/gunner
	name = "gunner unit"
	desc = "A standard ranged combat unit with a rapid-fire energy weapon."
	icon_state = "clan_gunner"
	maxHealth = 600
	health = 600
	vision_range = 10
	aggro_vision_range = 10
	ranged_cooldown_time = 10
	retreat_distance = 8
	minimum_distance = 5
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

// Clan Rapid Drone - Suppression fire specialist
// - Fires in volleys of multiple shots (like green noon ordeal)
// - Special ability: Overdrive mode with extremely fast fire rate
// - Low damage per shot but high volume of fire
/mob/living/simple_animal/hostile/clan/ranged/rapid
	name = "rapid unit"
	desc = "A agile unit equipped with a micro-blasters."
	icon_state = "clan_rapid"
	maxHealth = 300
	health = 300
	vision_range = 7
	aggro_vision_range = 7
	ranged_cooldown_time = 15 // Time between volleys
	retreat_distance = 6
	minimum_distance = 4
	projectiletype = /obj/projectile/clan_bullet/rapid
	move_to_delay = 2
	move_resist = MOVE_FORCE_NORMAL
	rapid = 3 // Fires 3 shots per volley
	rapid_fire_delay = 2 // 0.2 seconds between shots in volley

/mob/living/simple_animal/hostile/clan/ranged/rapid/SpecialAttack(atom/target)
	if(charge < special_attack_cost || world.time < special_attack_cooldown)
		return

	charge -= special_attack_cost
	special_attack_cooldown = world.time + special_attack_cooldown_time

	visible_message(span_danger("[src] overclocks its weapons!"))
	playsound(src, 'sound/machines/buzz-two.ogg', 75, TRUE)

	// Temporarily increase volley size and decrease cooldown
	rapid = 5 // Fire 5 shots instead of 3
	ranged_cooldown_time = 8 // Faster volleys
	addtimer(CALLBACK(src, PROC_REF(ResetFireRate)), 5 SECONDS)

/mob/living/simple_animal/hostile/clan/ranged/rapid/proc/ResetFireRate()
	rapid = initial(rapid)
	ranged_cooldown_time = initial(ranged_cooldown_time)
	visible_message(span_notice("[src]'s weapons return to normal."))

// Projectile types
/obj/projectile/clan_bullet
	name = "energy bolt"
	icon_state = "laser"
	damage = 15
	damage_type = RED_DAMAGE
	projectile_piercing = PASSMOB
	var/passed_faction_mobs = 0

/obj/projectile/clan_bullet/on_hit(atom/target, blocked = FALSE)
	if(isliving(target) && isliving(firer))
		var/mob/living/L = target
		var/mob/living/shooter = firer
		if(shooter.faction_check_mob(L))
			passed_faction_mobs++
			return BULLET_ACT_FORCE_PIERCE
	..()

/obj/projectile/clan_bullet/prehit_pierce(atom/A)
	if(isliving(A) && isliving(firer))
		var/mob/living/L = A
		var/mob/living/shooter = firer
		if(shooter.faction_check_mob(L))
			return PROJECTILE_PIERCE_HIT
	return ..()

/obj/projectile/clan_bullet/sniper
	name = "high-energy bolt"
	damage = 50
	speed = 0.3

/obj/projectile/clan_bullet/piercing
	name = "piercing energy bolt"
	damage = 60
	speed = 0.3
	movement_type = PHASING

/obj/projectile/clan_bullet/medium
	damage = 15

/obj/projectile/clan_bullet/rapid
	name = "micro energy bolt"
	damage = 5
	speed = 0.5

/obj/projectile/clan_bullet/warper
	name = "void bolt"
	icon_state = "purplelaser"
	damage = 20
	damage_type = BLACK_DAMAGE
	speed = 0.8

// Clan Bomber Spider - Suicide unit
// - Rushes toward targets and explodes on contact
// - 5 second countdown with rapid beeping before explosion
// - Deals 500 damage to objects, making it effective against barricades
// - Self-destructs after exploding
/mob/living/simple_animal/hostile/clan/bomber_spider
	name = "bomber spider"
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
	teleport_away = TRUE
	var/primed = FALSE
	var/explosion_damage = 500
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
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 50)

	// Start rapid beeping
	RapidBeep()

	// Explode after delay
	addtimer(CALLBACK(src, PROC_REF(Detonate)), 5 SECONDS)

/mob/living/simple_animal/hostile/clan/bomber_spider/proc/RapidBeep()
	if(stat == DEAD || !primed)
		return

	playsound(loc, 'sound/items/timer.ogg', 50, 3, 3)

	// Continue beeping every 0.2 seconds
	addtimer(CALLBACK(src, PROC_REF(RapidBeep)), 2)

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

// Clan Artillery - Mobile drop pod launcher
// - Collects up to 4 hostile mobs by stunning and storing them
// - Once full, launches all stored mobs via drop pods at a target location
// - Uses gondola sprite with animated overlay when firing
// - Runs away from enemies instead of engaging directly
// - Makes cartoon pop sound when collecting mobs
/mob/living/simple_animal/hostile/artillery
	name = "cannon gondola?!"
	desc = "A massive, slow-moving artillery unit... Wait, are you sure this is the right way to call this thing?"
	icon = 'icons/obj/supplypods.dmi'
	icon_state = "gondola"
	icon_living = "gondola"
	pixel_x = -16//2x2 sprite
	maxHealth = 2000
	health = 2000
	move_to_delay = 10
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	melee_damage_lower = 0
	melee_damage_upper = 0
	retreat_distance = 8
	minimum_distance = 8
	ranged = TRUE // This makes it retreat without attacking
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	ranged_message = null
	vision_range = 10
	aggro_vision_range = 10
	mob_size = MOB_SIZE_LARGE
	var/list/stored_mobs = list()
	var/max_stored_mobs = 4
	var/collection_range = 8
	var/launch_range = 12
	var/last_collection_time = 0
	var/collection_cooldown = 5 SECONDS
	var/mutable_appearance/gondola_overlay
	var/list/stored_mob_data = list() // Stores original values for restoration

/mob/living/simple_animal/hostile/artillery/Initialize()
	. = ..()
	SetOccupiedTiles(1, 1, 1, 1)
	START_PROCESSING(SSobj, src)
	// Add the gondola_open overlay
	gondola_overlay = mutable_appearance('icons/obj/supplypods.dmi', "gondola_open")
	gondola_overlay.pixel_x = pixel_x
	gondola_overlay.pixel_y = pixel_y
	add_overlay(gondola_overlay)

/mob/living/simple_animal/hostile/artillery/Destroy()
	// Release all stored mobs
	for(var/mob/living/L in stored_mobs)
		// Re-enable the mob before releasing
		L.SetStun(0)
		L.SetImmobilized(0)
		REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, "artillery_stored")
		// Re-enable AI
		if(istype(L, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = L
			SA.AIStatus = AI_ON
			REMOVE_TRAIT(SA, TRAIT_IMMOBILIZED, "artillery_stored")
			// Restore original values
			if(stored_mob_data[SA])
				SA.melee_damage_lower = stored_mob_data[SA]["melee_damage_lower"]
				SA.melee_damage_upper = stored_mob_data[SA]["melee_damage_upper"]
				SA.faction = stored_mob_data[SA]["original_faction"]
				stored_mob_data -= SA
		L.forceMove(loc)
	stored_mobs.Cut()
	stored_mob_data.Cut()
	STOP_PROCESSING(SSobj, src)
	return ..()

/mob/living/simple_animal/hostile/artillery/process()
	if(stat == DEAD)
		return

	// Try to collect mobs
	if(world.time > last_collection_time + collection_cooldown && length(stored_mobs) < max_stored_mobs)
		CollectMob()

	// Launch when we have exactly 4 mobs AND can find a target
	if(length(stored_mobs) == 4)
		CheckForLaunchTarget()

/mob/living/simple_animal/hostile/artillery/proc/CollectMob()
	var/list/potential_targets = list()

	for(var/mob/living/L in range(collection_range, src))
		if(L == src || L.stat == DEAD)
			continue
		if(!faction_check_mob(L))
			continue
		if(L in stored_mobs)
			continue
		// Check line of sight
		if(!can_see(src, L, collection_range))
			continue
		potential_targets += L

	if(!length(potential_targets))
		return

	var/mob/living/target = pick(potential_targets)

	// Teleport effect
	playsound(src, 'sound/effects/cartoon_pop.ogg', 50, TRUE)
	new /obj/effect/temp_visual/dir_setting/ninja/phase/out(get_turf(target))

	// Store the mob
	target.forceMove(src)
	stored_mobs += target
	last_collection_time = world.time

	// Disable the mob while stored
	if(isliving(target))
		var/mob/living/L = target
		L.SetStun(INFINITY)
		L.SetImmobilized(INFINITY)
		ADD_TRAIT(L, TRAIT_HANDS_BLOCKED, "artillery_stored")
		// Disable AI to prevent attacking from inside
		if(istype(L, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = L
			SA.AIStatus = AI_OFF
			// Store original damage values for later restoration
			stored_mob_data[SA] = list(
				"melee_damage_lower" = SA.melee_damage_lower,
				"melee_damage_upper" = SA.melee_damage_upper,
				"original_faction" = SA.faction.Copy()
			)
			// Set damage to 0
			SA.melee_damage_lower = 0
			SA.melee_damage_upper = 0
			// Add neutral faction to prevent targeting
			SA.faction |= "neutral"
			if(istype(SA, /mob/living/simple_animal/hostile))
				var/mob/living/simple_animal/hostile/H = SA
				H.target = null
				H.LoseTarget()
			// Add trait to prevent movement
			ADD_TRAIT(SA, TRAIT_IMMOBILIZED, "artillery_stored")
			// Force stop all actions
			SA.stop_pulling()
			walk(SA, 0)

	visible_message(span_warning("[src] absorbs [target]!"))

/mob/living/simple_animal/hostile/artillery/proc/CheckForLaunchTarget()
	if(length(stored_mobs) < 4)
		return

	// Look for enemy targets (can fire through walls)
	var/list/potential_targets = list()
	for(var/mob/living/carbon/C in range(launch_range, src))
		if(faction_check_mob(C))
			continue
		potential_targets += C

	// Only launch if we have targets
	if(length(potential_targets))
		LaunchMobs(pick(potential_targets))

/mob/living/simple_animal/hostile/artillery/proc/LaunchMobs(mob/living/launch_target)
	if(!length(stored_mobs) || !launch_target)
		return

	var/turf/target_turf = get_turf(launch_target)

	visible_message(span_userdanger("[src] aims at [launch_target] and fires!"))
	playsound(src, 'sound/vehicles/carcannon1.ogg', 100, TRUE)

	// Firing animation - shake and flash
	var/old_x = pixel_x
	var/old_y = pixel_y
	animate(src, pixel_x = old_x + 2, pixel_y = old_y + 2, time = 1)
	animate(pixel_x = old_x - 2, pixel_y = old_y - 2, time = 1)
	animate(pixel_x = old_x + 2, pixel_y = old_y - 2, time = 1)
	animate(pixel_x = old_x - 2, pixel_y = old_y + 2, time = 1)
	animate(pixel_x = old_x, pixel_y = old_y, time = 2)

	// Visual feedback when firing - remove and re-add overlay for flicker effect
	cut_overlay(gondola_overlay)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, add_overlay), gondola_overlay), 2)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, cut_overlay), gondola_overlay), 4)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, add_overlay), gondola_overlay), 6)

	// Reset collection cooldown to prevent immediate re-collection
	last_collection_time = world.time

	// Launch all mobs in a burst pattern
	var/list/turfs_near_target = list()
	for(var/turf/T in view(2, target_turf))
		if(!T.density)
			turfs_near_target += T

	for(var/mob/living/L in stored_mobs)
		var/turf/landing_turf = length(turfs_near_target) ? pick(turfs_near_target) : target_turf

		// Re-enable the mob before launching
		L.SetStun(0)
		L.SetImmobilized(0)
		REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, "artillery_stored")
		// Re-enable AI
		if(istype(L, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = L
			SA.AIStatus = AI_ON
			REMOVE_TRAIT(SA, TRAIT_IMMOBILIZED, "artillery_stored")
			// Restore original values
			if(stored_mob_data[SA])
				SA.melee_damage_lower = stored_mob_data[SA]["melee_damage_lower"]
				SA.melee_damage_upper = stored_mob_data[SA]["melee_damage_upper"]
				SA.faction = stored_mob_data[SA]["original_faction"]
				stored_mob_data -= SA

		// Create drop pod with mob inside
		var/obj/structure/closet/supplypod/extractionpod/pod = new()
		pod.explosionSize = list(0,0,0,0)
		pod.icon_state = "orange"
		pod.door = "orange_door"
		pod.decal = "none"
		L.forceMove(pod)

		// Create landing zone
		new /obj/effect/pod_landingzone(landing_turf, pod)

		// Stun on landing
		addtimer(CALLBACK(src, PROC_REF(StunOnLanding), L), 2 SECONDS)

	stored_mobs.Cut()
	stored_mob_data.Cut()

/mob/living/simple_animal/hostile/artillery/proc/StunOnLanding(mob/living/L)
	if(!L || L.stat == DEAD)
		return
	L.Paralyze(10)
	playsound(L, 'sound/effects/meteorimpact.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/artillery/examine(mob/user)
	. = ..()
	. += span_notice("Stored mobs: [length(stored_mobs)]/[max_stored_mobs]")
	if(length(stored_mobs) >= max_stored_mobs)
		. += span_warning("Artillery is fully loaded and searching for targets!")

// Clan Warper - Area teleportation specialist
// - Marks a target location and channels for 10 seconds
// - Creates a 5x5 area around itself marked for teleportation
// - Teleports all mobs (except self) in the area to the marked location
// - Shows a magic circle effect while casting (uses fellcircle sprite)
// - Only uses ability when allies are nearby to teleport
/mob/living/simple_animal/hostile/clan/ranged/warper
	name = "warper unit"
	desc = "A specialized unit with spatial manipulation technology."
	icon_state = "clan_warper"
	maxHealth = 500
	health = 500
	vision_range = 12
	aggro_vision_range = 12
	ranged_cooldown_time = 60 // Long cooldown for powerful ability
	retreat_distance = 10
	minimum_distance = 8
	projectiletype = /obj/projectile/clan_bullet/warper
	move_to_delay = 4
	melee_damage_lower = 5
	melee_damage_upper = 10
	special_attack_cost = 10 // Costs more charge
	special_attack_cooldown_time = 30 SECONDS
	var/obj/effect/warper_mark/current_mark
	var/casting = FALSE
	var/list/obj/effect/temp_visual/warper_area/area_markers = list()
	var/obj/effect/clan_magic_circle/magic_circle

/mob/living/simple_animal/hostile/clan/ranged/warper/Move()
	if(casting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/clan/ranged/warper/CanAttack(atom/the_target)
	if(casting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/clan/ranged/warper/OpenFire(atom/A)
	if(casting)
		return FALSE
	if(charge >= special_attack_cost && world.time > special_attack_cooldown)
		if(prob(50)) // Higher chance to use special
			SpecialAttack(A)
			return
	return ..()

/mob/living/simple_animal/hostile/clan/ranged/warper/SpecialAttack(atom/target)
	if(charge < special_attack_cost || world.time < special_attack_cooldown || casting || !isliving(target))
		return

	// Check if there are any ally mobs in range to teleport
	var/found_allies = FALSE
	for(var/mob/living/L in range(1, src))
		if(L == src)
			continue
		if(faction_check_mob(L))
			found_allies = TRUE
			break

	if(!found_allies)
		return // Don't waste charge if no allies to teleport

	charge -= special_attack_cost
	special_attack_cooldown = world.time + special_attack_cooldown_time

	// Place mark at target
	var/turf/target_turf = get_turf(target)
	visible_message(span_danger("[src] marks [target] for spatial displacement!"))
	playsound(src, 'sound/magic/blind.ogg', 75, TRUE)

	// Create the destination mark
	if(current_mark)
		qdel(current_mark)
	current_mark = new /obj/effect/warper_mark(target_turf)

	// Start casting
	casting = TRUE

	// Create magic circle visual effect
	magic_circle = new /obj/effect/clan_magic_circle(get_turf(src))
	magic_circle.icon_state = "fellcircle"

	// Adjust circle position and orientation similar to dragonskull
	var/matrix/M = matrix(magic_circle.transform)
	M.Translate(0, 16)
	var/rot_angle = Get_Angle(get_turf(src), target_turf)
	M.Turn(rot_angle)
	switch(dir)
		if(EAST)
			M.Scale(0.5, 1)
		if(WEST)
			M.Scale(0.5, 1)
		if(NORTH)
			magic_circle.layer -= 0.2
	magic_circle.transform = M

	// Create area markers in 5x5 around us
	var/turf/center = get_turf(src)
	for(var/turf/T in range(2, center))
		var/obj/effect/temp_visual/warper_area/W = new(T)
		area_markers += W

	visible_message(span_userdanger("[src] begins channeling a mass teleportation!"))
	playsound(src, 'sound/magic/charge.ogg', 100, TRUE)

	// Channel for 10 seconds
	addtimer(CALLBACK(src, PROC_REF(CompleteTeleport), center), 10 SECONDS)

/mob/living/simple_animal/hostile/clan/ranged/warper/proc/CompleteTeleport(turf/center)
	if(stat == DEAD || !current_mark)
		CancelTeleport()
		return

	// Get all mobs in 5x5 area
	var/list/teleport_targets = list()
	for(var/mob/living/L in range(2, center))
		if(L == src) // Don't teleport self
			continue
		teleport_targets += L

	// Teleport effects
	visible_message(span_hierophant_warning("[src] completes the spatial displacement!"))
	playsound(src, 'sound/magic/wand_teleport.ogg', 100, TRUE)
	playsound(current_mark, 'sound/magic/wand_teleport.ogg', 100, TRUE)

	// Teleport each mob
	var/turf/destination = get_turf(current_mark)
	for(var/mob/living/L in teleport_targets)
		INVOKE_ASYNC(src, PROC_REF(TeleportMob), L, destination)

	// Cleanup
	CancelTeleport()

/mob/living/simple_animal/hostile/clan/ranged/warper/proc/TeleportMob(mob/living/L, turf/destination)
	// Fade out effect
	new /obj/effect/temp_visual/dir_setting/cult/phase/out(get_turf(L), L)
	animate(L, alpha = 0, time = 5, easing = EASE_OUT)
	sleep(5)

	if(!L || L.stat == DEAD)
		return

	// Move mob
	L.forceMove(destination)

	// Fade in effect
	new /obj/effect/temp_visual/dir_setting/cult/phase(destination, L)
	animate(L, alpha = 255, time = 5, easing = EASE_IN)

	// Stun on arrival
	L.Paralyze(20)

/mob/living/simple_animal/hostile/clan/ranged/warper/proc/CancelTeleport()
	casting = FALSE

	// Clean up magic circle
	if(magic_circle)
		qdel(magic_circle)
		magic_circle = null

	// Clean up markers
	for(var/obj/effect/E in area_markers)
		qdel(E)
	area_markers.Cut()

	if(current_mark)
		qdel(current_mark)
		current_mark = null

/mob/living/simple_animal/hostile/clan/ranged/warper/death()
	CancelTeleport()
	return ..()

// Visual effects for the warper
/obj/effect/warper_mark
	name = "spatial mark"
	desc = "A glowing mark indicating a teleportation destination."
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "blood_cloud_swirl"
	layer = BELOW_MOB_LAYER

/obj/effect/warper_mark/Initialize()
	. = ..()
	animate(src, alpha = 100, time = 5, loop = -1)
	animate(alpha = 255, time = 5)
	QDEL_IN(src, 11 SECONDS)

/obj/effect/temp_visual/warper_area
	name = "displacement field"
	desc = "Space seems to warp and bend here."
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "floorglow_looping"
	layer = BELOW_MOB_LAYER
	duration = 11 SECONDS
	alpha = 100

/obj/effect/temp_visual/warper_area/Initialize()
	. = ..()
	animate(src, alpha = 50, time = 10, loop = -1)
	animate(alpha = 150, time = 10)

// Magic circle effect for warper
/obj/effect/clan_magic_circle
	name = "magic circle"
	desc = "A circle of red magic featuring a six-pointed star"
	icon = 'icons/effects/effects.dmi'
	icon_state = "fellcircle"
	pixel_x = 8
	base_pixel_x = 8
	pixel_y = 8
	base_pixel_y = 8
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

// Clan Harpooner - Chain specialist that captures and drags targets
// - Fires chain harpoons at human targets
// - Chained targets cannot move away and are pulled 1 tile/second
// - Drags victims for 15 seconds before violently dropping them
// - Final drop deals 50 RED damage and knocks down for 3 seconds
// - Chain breaks if target dies or breaks line of sight
// - Can only chain one target at a time
/mob/living/simple_animal/hostile/clan/ranged/harpooner
	name = "harpooner unit"
	desc = "A specialized ranged unit equipped with chain harpoons for capturing targets."
	icon_state = "clan_harpooner"
	maxHealth = 600
	health = 600
	vision_range = 10
	aggro_vision_range = 10
	ranged_cooldown_time = 8
	retreat_distance = 6
	minimum_distance = 5
	projectiletype = /obj/projectile/clan_bullet/medium
	move_to_delay = 3
	melee_damage_lower = 10
	melee_damage_upper = 15
	teleport_away = TRUE

	// Chain variables
	var/mob/living/carbon/human/chained_target = null
	var/datum/beam/chain_beam
	var/chain_pull_timer
	var/chain_start_time
	var/chain_duration = 15 SECONDS
	var/pull_delay = 10 // 1 second between pulls
	var/harpoon_cooldown = 0
	var/harpoon_cooldown_time = 20 SECONDS
	var/final_damage = 50 // RED damage on drop

/mob/living/simple_animal/hostile/clan/ranged/harpooner/OpenFire(atom/A)
	if(chained_target)
		return FALSE // Can't shoot while pulling someone

	// Use harpoon on humans, regular shots on others
	if(ishuman(A) && world.time > harpoon_cooldown)
		FireHarpoon(A)
		return

	return ..()

/mob/living/simple_animal/hostile/clan/ranged/harpooner/proc/FireHarpoon(atom/target)
	if(chained_target || world.time < harpoon_cooldown)
		return

	visible_message(span_danger("[src] fires a chain harpoon at [target]!"))
	playsound(src, 'sound/weapons/chainhit.ogg', 75, TRUE)

	var/obj/projectile/clan_bullet/harpoon/H = new(get_turf(src))
	H.firer = src
	H.preparePixelProjectile(target, src)
	H.fire()

	harpoon_cooldown = world.time + harpoon_cooldown_time

/mob/living/simple_animal/hostile/clan/ranged/harpooner/proc/BeginChainPull(mob/living/carbon/human/target)
	if(chained_target)
		return

	chained_target = target
	chain_start_time = world.time

	// Apply chained status
	var/datum/status_effect/harpooner_chained/C = chained_target.has_status_effect(/datum/status_effect/harpooner_chained)
	if(!C)
		C = chained_target.apply_status_effect(/datum/status_effect/harpooner_chained)
		C.harpooner = src

	visible_message(span_warning("[src] has caught [chained_target] with their harpoon!"))

	UpdateChainVisuals()
	PullLoop()

/mob/living/simple_animal/hostile/clan/ranged/harpooner/proc/PullLoop()
	if(!chained_target || chained_target.stat == DEAD || !can_see(src, chained_target, 14))
		ReleaseTarget()
		return

	// Check if 15 seconds have passed
	if(world.time >= chain_start_time + chain_duration)
		DropTarget()
		return

	// Check distance
	var/dist = get_dist(src, chained_target)
	if(dist < 2)
		DropTarget()
		return

	// Pull the target
	var/turf/T = get_turf(src)
	chained_target.throw_at(T, 1, 2, src)
	playsound(chained_target, 'sound/weapons/chainhit.ogg', 40, TRUE)

	UpdateChainVisuals()

	// Schedule next pull
	chain_pull_timer = addtimer(CALLBACK(src, PROC_REF(PullLoop)), pull_delay, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/clan/ranged/harpooner/proc/DropTarget()
	if(!chained_target)
		return

	visible_message(span_danger("[src] violently drops [chained_target]!"))
	playsound(chained_target, 'sound/effects/meteorimpact.ogg', 75, TRUE)

	// Deal damage and knockdown
	chained_target.apply_damage(final_damage, RED_DAMAGE, null, chained_target.run_armor_check(null, RED_DAMAGE))
	chained_target.Knockdown(30)

	// Visual effect
	new /obj/effect/temp_visual/kinetic_blast(get_turf(chained_target))

	ReleaseTarget()

/mob/living/simple_animal/hostile/clan/ranged/harpooner/proc/UpdateChainVisuals()
	if(!chained_target)
		if(chain_beam)
			QDEL_NULL(chain_beam)
		return

	if(!chain_beam)
		chain_beam = Beam(chained_target, icon_state = "chain")

/mob/living/simple_animal/hostile/clan/ranged/harpooner/proc/ReleaseTarget()
	if(!chained_target)
		return

	chained_target.remove_status_effect(/datum/status_effect/harpooner_chained)
	chained_target = null
	UpdateChainVisuals()

	if(chain_pull_timer)
		deltimer(chain_pull_timer)
		chain_pull_timer = null

/mob/living/simple_animal/hostile/clan/ranged/harpooner/death()
	ReleaseTarget()
	return ..()

/mob/living/simple_animal/hostile/clan/ranged/harpooner/Destroy()
	ReleaseTarget()
	return ..()

// Harpoon projectile
/obj/projectile/clan_bullet/harpoon
	name = "chain harpoon"
	icon_state = "chain_bolt"
	damage = 20
	damage_type = RED_DAMAGE
	speed = 0.5
	var/chain

/obj/projectile/clan_bullet/harpoon/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "chain")
	..()

/obj/projectile/clan_bullet/harpoon/Destroy()
	qdel(chain)
	return ..()

/obj/projectile/clan_bullet/harpoon/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/mob/living/simple_animal/hostile/clan/ranged/harpooner/harpooner = firer
		if(istype(harpooner) && get_dist(target, firer) < 15)
			harpooner.BeginChainPull(H)

// Status effect for chained targets
/datum/status_effect/harpooner_chained
	id = "harpooner_chained"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/harpooner_chained
	var/mob/living/simple_animal/hostile/clan/ranged/harpooner/harpooner
	var/view_range = 7

/atom/movable/screen/alert/status_effect/harpooner_chained
	name = "Harpooned"
	desc = "You've been caught by a clan harpooner! You can't run away!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "locked"

/datum/status_effect/harpooner_chained/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_movement))
	to_chat(owner, span_userdanger("You've been harpooned! You can't escape!"))

/datum/status_effect/harpooner_chained/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
	to_chat(owner, span_notice("The harpoon releases you."))
	. = ..()

/datum/status_effect/harpooner_chained/proc/check_movement(mob/living/carbon/human/H, turf/NewLoc)
	SIGNAL_HANDLER

	if(!istype(H) || !harpooner)
		return

	// Check if still in view
	if(!(H in view(view_range, harpooner)))
		H.remove_status_effect(/datum/status_effect/harpooner_chained)
		return

	// Prevent moving away
	var/current_dist = get_dist(harpooner, H)
	var/new_dist = get_dist(harpooner, NewLoc)

	if(new_dist > current_dist)
		to_chat(H, span_warning("The chain prevents you from moving further away!"))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

// // Siege Walker - Massive crushing unit that collects mobs
// /mob/living/simple_animal/hostile/clan/siege_walker
// 	name = "Clan Siege Walker"
// 	desc = "A colossal mechanical war machine, designed to crush everything in its path. Its grinding treads leave nothing but destruction."
// 	icon = 'icons/obj/bike.dmi'
// 	icon_state = "speedwagon"
// 	icon_living = "speedwagon"
// 	icon_dead = "speedwagon"
// 	pixel_x = -15
// 	pixel_y = -15
// 	base_pixel_x = -15
// 	base_pixel_y = -15
// 	maxHealth = 4000
// 	health = 4000
// 	move_to_delay = 30 // Very slow
// 	damage_coeff = list(BRUTE = 0.8, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
// 	melee_damage_lower = 50
// 	melee_damage_upper = 70
// 	mob_size = MOB_SIZE_HUGE
// 	layer = LARGE_MOB_LAYER
// 	stat_attack = DEAD
// 	del_on_death = FALSE
// 	robust_searching = FALSE
// 	AIStatus = AI_OFF // We control movement manually

// 	// Path and movement vars
// 	var/list/movement_path = list()
// 	var/moving = FALSE
// 	var/turf/target_destination
// 	var/crush_damage = 500
// 	var/move_delay = 2 SECONDS
// 	var/last_path_highlight = 0
// 	var/path_highlight_interval = 20 SECONDS

// 	// Collection system
// 	var/list/stored_mobs = list()
// 	var/max_stored_mobs = 8
// 	var/collection_range = 4
// 	var/collecting_enabled = TRUE
// 	var/collection_cooldown = 0
// 	var/collection_disable_time = 10 SECONDS

// 	// Dropping system
// 	var/last_drop_time = 0
// 	var/drop_cooldown = 5 SECONDS
// 	var/mobs_per_drop = 2

// /mob/living/simple_animal/hostile/clan/siege_walker/Initialize()
// 	. = ..()
// 	ADD_TRAIT(src, TRAIT_MOVE_PHASING, INNATE_TRAIT) // Can move through dense objects
// 	// Add the speedwagon cover overlay
// 	var/mutable_appearance/overlay = mutable_appearance(icon, "speedwagon_cover", ABOVE_MOB_LAYER)
// 	add_overlay(overlay)

// /mob/living/simple_animal/hostile/clan/siege_walker/Life()
// 	. = ..()
// 	if(!.)
// 		return

// 	// Re-enable collection after cooldown
// 	if(!collecting_enabled && world.time > collection_cooldown)
// 		collecting_enabled = TRUE
// 		visible_message(span_notice("[src]'s collection systems reactivate."))

// 	// Collect nearby mobs if enabled
// 	if(collecting_enabled && moving && length(stored_mobs) < max_stored_mobs)
// 		CollectNearbyMobs()

// 	// Re-highlight path periodically
// 	if(moving && world.time > last_path_highlight + path_highlight_interval)
// 		HighlightPath()
// 		priority_announce("WARNING: Siege Walker still active! Evacuate from highlighted areas!", "SIEGE WALKER UPDATE", 'sound/misc/notice2.ogg')

// 	// Auto-target nearest enemy structure if not moving
// 	if(!moving && prob(10))
// 		var/list/potential_targets = list()
// 		for(var/obj/structure/S in view(15, src))
// 			if(S.density && !istype(S, /obj/structure/barricade/clan))
// 				potential_targets += S
// 		for(var/obj/machinery/M in view(15, src))
// 			if(M.density)
// 				potential_targets += M

// 		if(length(potential_targets))
// 			var/atom/target = pick(potential_targets)
// 			SetDestination(get_turf(target))

// /mob/living/simple_animal/hostile/clan/siege_walker/Destroy()
// 	// Release all stored mobs
// 	for(var/mob/living/L in stored_mobs)
// 		L.forceMove(get_turf(src))
// 	stored_mobs.Cut()
// 	return ..()

// /mob/living/simple_animal/hostile/clan/siege_walker/examine(mob/user)
// 	. = ..()
// 	. += span_notice("Stored mobs: [length(stored_mobs)]/[max_stored_mobs]")
// 	if(!collecting_enabled)
// 		. += span_warning("Collection systems disabled for [round((collection_cooldown - world.time) / 10)] seconds.")
// 	if(moving)
// 		. += span_boldnotice("Currently moving towards its destination.")

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/SetDestination(turf/T)
// 	if(!T || moving)
// 		return FALSE

// 	target_destination = T
// 	StartPathing()
// 	return TRUE

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/StartPathing()
// 	if(!target_destination || moving)
// 		return

// 	// Create path ignoring density
// 	movement_path = get_path_to(src, target_destination, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200, 1, TYPE_PROC_REF(/turf, TurfBlockedNoDensity))

// 	if(!length(movement_path))
// 		visible_message(span_warning("[src] cannot find a path to its destination!"))
// 		return

// 	// Global announcement
// 	priority_announce("EMERGENCY: Massive siege unit detected! All personnel evacuate from marked areas immediately! The unit will crush everything in its path!", "SIEGE WALKER ALERT", 'sound/machines/alarm.ogg')

// 	// Visual warning
// 	visible_message(span_userdanger("[src] begins plotting its destructive path!"))
// 	playsound(src, 'sound/mecha/mechstep.ogg', 100, TRUE)

// 	// Show the path with glowing effect
// 	HighlightPath()

// 	// Countdown warnings
// 	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(priority_announce), "Siege Walker advancing in 3 seconds!", "FINAL WARNING", 'sound/misc/notice1.ogg'), 0)
// 	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, visible_message), span_boldwarning("SIEGE WALKER ADVANCING IN 2...")), 1 SECONDS)
// 	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, visible_message), span_boldwarning("SIEGE WALKER ADVANCING IN 1...")), 2 SECONDS)

// 	// Start moving after a delay
// 	addtimer(CALLBACK(src, PROC_REF(StartMoving)), 3 SECONDS)

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/StartMoving()
// 	if(!length(movement_path))
// 		return

// 	moving = TRUE
// 	visible_message(span_userdanger("[src] begins its inexorable advance!"))
// 	playsound(src, 'sound/mecha/mechstep.ogg', 100, TRUE)

// 	ProcessMovement()

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/ProcessMovement()
// 	if(!moving || !length(movement_path))
// 		StopMoving()
// 		return

// 	var/turf/next_turf = movement_path[1]
// 	movement_path.Cut(1, 2)

// 	// Face the direction we're moving
// 	face_atom(next_turf)

// 	// Crush everything in the destination
// 	CrushTurf(next_turf)

// 	// Move to the turf
// 	forceMove(next_turf)
// 	playsound(src, 'sound/mecha/mechmove04.ogg', 75, TRUE)

// 	// Shake nearby turfs
// 	for(var/turf/T in range(2, src))
// 		if(prob(50))
// 			new /obj/effect/temp_visual/decoy/fading(T)

// 	// Continue moving
// 	if(length(movement_path))
// 		addtimer(CALLBACK(src, PROC_REF(ProcessMovement)), move_delay)
// 	else
// 		StopMoving()

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/StopMoving()
// 	moving = FALSE
// 	movement_path = list()
// 	visible_message(span_notice("[src] comes to a grinding halt."))
// 	priority_announce("Siege Walker has reached its destination and stopped moving. Threat level reduced.", "Siege Walker Status", 'sound/misc/notice2.ogg')

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/HighlightPath()
// 	if(!length(movement_path))
// 		return

// 	last_path_highlight = world.time

// 	// Create glowing effect on path
// 	for(var/turf/T in movement_path)
// 		// Create multiple effects for a more dramatic warning
// 		new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, pick(GLOB.alldirs))
// 		new /obj/effect/temp_visual/cult/sparks(T)

// 		// Add a glowing overlay that lasts longer
// 		var/obj/effect/overlay/O = new(T)
// 		O.icon = 'icons/effects/effects.dmi'
// 		O.icon_state = "shield-old"
// 		O.color = "#FF0000"
// 		O.alpha = 100
// 		animate(O, alpha = 0, time = 30, easing = QUAD_EASING)
// 		QDEL_IN(O, 3 SECONDS)

// 	// Warning sound along the path
// 	for(var/mob/living/L in range(7, src))
// 		if(L.client)
// 			L.playsound_local(L, 'sound/machines/warning-buzzer.ogg', 50, FALSE)

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/CrushTurf(turf/T)
// 	// Destroy all dense objects
// 	for(var/obj/structure/S in T)
// 		if(S.density)
// 			visible_message(span_boldwarning("[src] crushes [S]!"))
// 			if(istype(S, /obj/structure/barricade))
// 				S.take_damage(crush_damage * 2, BRUTE, "melee", 0) // Extra damage to barricades
// 			else
// 				S.take_damage(crush_damage, BRUTE, "melee", 0)

// 	for(var/obj/machinery/M in T)
// 		if(M.density)
// 			visible_message(span_boldwarning("[src] crushes [M]!"))
// 			M.take_damage(crush_damage, BRUTE, "melee", 0)

// 	// Open or destroy doors
// 	for(var/obj/machinery/door/D in T)
// 		if(D.density)
// 			if(prob(70))
// 				D.open()
// 			else
// 				visible_message(span_boldwarning("[src] smashes through [D]!"))
// 				D.take_damage(crush_damage, BRUTE, "melee", 0)

// 	// Damage mobs
// 	for(var/mob/living/L in T)
// 		if(L == src)
// 			continue
// 		if(faction_check_mob(L) && !ismecha(L))
// 			continue
// 		visible_message(span_userdanger("[src] runs over [L]!"))
// 		playsound(L, 'sound/effects/blobattack.ogg', 75, TRUE)
// 		L.apply_damage(100, BRUTE, spread_damage = TRUE)
// 		L.Paralyze(30)
// 		new /obj/effect/temp_visual/kinetic_blast(T)

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/CollectNearbyMobs()
// 	for(var/mob/living/L in range(collection_range, src))
// 		if(L == src || L.stat == DEAD)
// 			continue
// 		if(!faction_check_mob(L))
// 			continue
// 		if(L in stored_mobs)
// 			continue
// 		if(length(stored_mobs) >= max_stored_mobs)
// 			break

// 		// Collect the mob
// 		visible_message(span_warning("[src] scoops up [L]!"))
// 		playsound(L, 'sound/effects/phasein.ogg', 50, TRUE)
// 		L.forceMove(src)
// 		stored_mobs += L
// 		new /obj/effect/temp_visual/dir_setting/ninja(get_turf(L))

// /mob/living/simple_animal/hostile/clan/siege_walker/proc/DropMobs()
// 	if(world.time < last_drop_time + drop_cooldown || !length(stored_mobs))
// 		return

// 	last_drop_time = world.time
// 	var/mobs_to_drop = min(mobs_per_drop, length(stored_mobs))

// 	visible_message(span_warning("[src] deploys stored units!"))
// 	playsound(src, 'sound/mecha/mechstep.ogg', 75, TRUE)

// 	for(var/i in 1 to mobs_to_drop)
// 		if(!length(stored_mobs))
// 			break
// 		var/mob/living/L = pick(stored_mobs)
// 		stored_mobs -= L

// 		// Find a nearby turf to drop them
// 		var/list/possible_turfs = list()
// 		for(var/turf/T in range(2, src))
// 			if(!T.density)
// 				possible_turfs += T

// 		if(length(possible_turfs))
// 			var/turf/drop_turf = pick(possible_turfs)
// 			L.forceMove(drop_turf)
// 			L.Paralyze(20) // Brief stun
// 			new /obj/effect/temp_visual/teleport_abductor(drop_turf)

// /mob/living/simple_animal/hostile/clan/siege_walker/attacked_by(obj/item/I, mob/living/user)
// 	. = ..()
// 	// Disable collection and drop mobs when attacked
// 	if(collecting_enabled)
// 		collecting_enabled = FALSE
// 		collection_cooldown = world.time + collection_disable_time
// 		visible_message(span_warning("[src]'s collection systems malfunction from the damage!"))
// 		playsound(src, 'sound/machines/warning-buzzer.ogg', 75, TRUE)

// 	DropMobs()

// /mob/living/simple_animal/hostile/clan/siege_walker/bullet_act(obj/projectile/P)
// 	. = ..()
// 	// Same as melee attacks
// 	if(collecting_enabled)
// 		collecting_enabled = FALSE
// 		collection_cooldown = world.time + collection_disable_time
// 		visible_message(span_warning("[src]'s collection systems malfunction from the damage!"))
// 		playsound(src, 'sound/machines/warning-buzzer.ogg', 75, TRUE)

// 	DropMobs()

// // Custom pathfinding proc that ignores density
// /turf/proc/TurfBlockedNoDensity(caller)
// 	return FALSE // Never blocked, we crush through everything
