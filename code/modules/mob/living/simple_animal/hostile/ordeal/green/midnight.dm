// Green midnight
/mob/living/simple_animal/hostile/ordeal/green_midnight
	name = "helix of the end"
	desc = "A colossal metallic structure with a large amount of laser weaponry beneath its shell."
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "greenmidnight"
	icon_living = "greenmidnight"
	icon_dead = "greenmidnight_dead"
	layer = LYING_MOB_LAYER
	pixel_x = -96
	base_pixel_x = -96
	occupied_tiles_left = 2
	occupied_tiles_right = 2
	occupied_tiles_up = 2
	faction = list("green_ordeal")
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 40000
	health = 40000
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 22)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 16)
	death_sound = 'sound/effects/ordeals/green/midnight_dead.ogg'
	offsets_pixel_x = list("south" = -96, "north" = -96, "west" = -96, "east" = -96)
	damage_effect_scale = 1.25

	var/laser_cooldown
	var/laser_cooldown_time = 23 SECONDS
	var/obj/effect/greenmidnight_shell/left_shell
	var/obj/effect/greenmidnight_shell/right/right_shell
	/// Assoc list. Effect = Target turf
	var/list/lasers = list()
	var/list/beams = list()
	var/list/hit_line = list()
	/// Amount of black damage per damage tick dealt to all living enemies
	var/laser_damage = 65
	var/max_lasers = 6
	/// Amount of damage ticks laser will do
	var/max_laser_repeats = 40
	var/firing = FALSE
	var/datum/looping_sound/greenmidnight_laser/laserloop
	var/laser_spawn_delay = 1 SECONDS
	var/laser_rotation_time = 2 SECONDS
	/// Below that health the green midnight speeds up
	var/next_health_mark = 0 // Initialize below

	//These variables control how many bots are deployed during the no-lasers-phase and how the scaling for them works.
	/// This variable represents the initial value for how large our squad of deployed bots should be.
	/// Will attempt to deploy bots until we reach this size. This increases when losing enough HP.
	var/base_squad_size = 4
	/// How many of our personally spawned bots are alive right now.
	var/active_minions = 0
	/// We will never increase squad size past this. Adjusted by scaling
	var/maximum_squad_size = 14
	/// Controls how many bots are added to a squad per 10% HP lost. Adjusted by scaling
	var/squad_size_increase_step = 1

	// I am placing these here because I don't want to calculate turfs in range 9 trillion times. These will only be calculated once,
	// then once again every time the Helix moves for some reason (like adminbus)
	var/list/microbarrage_threatened_turfs = list()
	var/list/macrolaser_threatened_turfs = list()
	var/list/danger_close_turfs = list()
	var/list/microbarrage_target_turfs = list()
	/// This variable holds the last location of the Helix. It's so we can check if it has moved since the last time it fired its lasers and update target turfs if so.
	var/entrenched_at

/mob/living/simple_animal/hostile/ordeal/green_midnight/Initialize()
	. = ..()
	left_shell = new(get_turf(src))
	right_shell = new(get_turf(src))
	laser_cooldown = world.time + 6 SECONDS
	next_health_mark = maxHealth * 0.9
	laserloop = new(list(src), FALSE)
	addtimer(CALLBACK(src, PROC_REF(OpenShell)), 5 SECONDS)
	HandleScaling()
	/// The below proc populates those turf lists in lines 59-62.
	CheckIfMoved()

/mob/living/simple_animal/hostile/ordeal/green_midnight/Destroy()
	QDEL_NULL(left_shell)
	QDEL_NULL(right_shell)
	QDEL_NULL(laserloop)
	for(var/atom/A in lasers)
		QDEL_NULL(A)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	/// Apparently these lists need to be set to null to avoid hard deletes later on, since they are referencing existing turfs
	microbarrage_threatened_turfs = null
	macrolaser_threatened_turfs = null
	danger_close_turfs = null
	microbarrage_target_turfs = null
	entrenched_at = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_midnight/death()
	QDEL_NULL(left_shell)
	QDEL_NULL(right_shell)
	QDEL_NULL(laserloop)
	for(var/atom/A in lasers)
		QDEL_NULL(A)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_midnight/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(stat == DEAD)
		return
	if(health <= next_health_mark)
		next_health_mark -= maxHealth * 0.1
		max_lasers += 2
		laser_spawn_delay = max(0.3 SECONDS, laser_spawn_delay - 0.1 SECONDS)
		laser_rotation_time = max(0.5 SECONDS, laser_rotation_time - 0.2 SECONDS)
		laser_cooldown_time = max(10 SECONDS, laser_cooldown_time - 1 SECONDS)

/mob/living/simple_animal/hostile/ordeal/green_midnight/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_midnight/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/green_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(firing)
		return FALSE
	if(world.time > laser_cooldown)
		INVOKE_ASYNC(src, PROC_REF(SetupLaser))

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/OpenShell()
	animate(left_shell, pixel_x = base_pixel_x - 24, time = 4 SECONDS, easing = QUAD_EASING)
	animate(right_shell, pixel_x = base_pixel_x + 24, time = 4 SECONDS, easing = QUAD_EASING)
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_gears.ogg', 50, FALSE, 7)

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/CloseShell()
	animate(left_shell, pixel_x = base_pixel_x, time = 2 SECONDS, easing = QUAD_EASING)
	animate(right_shell, pixel_x = base_pixel_x, time = 2 SECONDS, easing = QUAD_EASING)
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_gears_fast.ogg', 50, FALSE, 7)

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/SetupLaser()
	/// This proc is just to make sure we're actually targeting the turfs currently next to us for the macrolasers and minilasers.
	CheckIfMoved()
	firing = TRUE
	OpenShell()
	SLEEP_CHECK_DEATH(2 SECONDS)
	var/new_angle = rand(0, 360)
	for(var/i = 1 to max_lasers)
		var/obj/effect/greenmidnight_laser/L = new(get_turf(src))
		lasers[L] = get_turf_in_angle(new_angle, get_turf(src), 64)
		playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_laser_new.ogg', 50 + 5 * (i - max_lasers), FALSE)
		addtimer(CALLBACK(src, PROC_REF(PrepareLaser), L, new_angle), 0.5 SECONDS)
		var/old_angle = new_angle
		for(var/attempt = 1 to 3) // Just so that we don't get ourselves absolutely the same angle twice in a row
			new_angle = rand(0, 360)
			if((new_angle > old_angle + 15) || (new_angle < old_angle - 15))
				break
		SLEEP_CHECK_DEATH(laser_spawn_delay)
	SLEEP_CHECK_DEATH(laser_rotation_time)
	FireLaser()

// Rotate the laser and creates a warning beam
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/PrepareLaser(obj/effect/greenmidnight_laser/L, l_angle)
	if(stat == DEAD || QDELETED(L))
		return
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_gears_fast.ogg', 15, TRUE)
	animate(L, transform = turn(matrix(), l_angle), time = laser_rotation_time)
	SLEEP_CHECK_DEATH(laser_rotation_time * 0.75)
	var/turf/T = get_turf(src)
	var/datum/beam/B = T.Beam(lasers[L], "n_beam")
	beams += B
	B.visuals.alpha = 0
	animate(B.visuals, alpha = 255, time = 3)

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/FireLaser()
	if(stat == DEAD)
		return
	for(var/datum/beam/B in beams)
		B.visuals.icon_state = "sat_beam" // WARNING, YOU ARE ABOUT TO DIE!!!
		var/matrix/M = matrix()
		M.Scale(9, 1)
		animate(B.visuals, transform = M, time = 15)
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_laser_prepare.ogg', 75, FALSE, 14)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	sound_to_playing_players_on_level('sound/effects/ordeals/green/midnight_laser_warning.ogg', 75, zlevel = z)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	sound_to_playing_players_on_level('sound/effects/ordeals/green/midnight_laser_fire.ogg', 100, zlevel = z)
	var/turf/T = get_turf(src)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	hit_line = list()
	for(var/obj/effect/greenmidnight_laser/L in lasers)
		L.icon_state = "greenmidnight_laser_firing"
		var/datum/beam/B = T.Beam(lasers[L], "green_beam")
		var/matrix/M = matrix()
		M.Scale(3, 1)
		B.visuals.transform = M
		beams += B
		hit_line |= getline(T, lasers[L])
	INVOKE_ASYNC(src, PROC_REF(LaserEffect))

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/LaserEffect()
	if(stat == DEAD)
		return

	//The reason why we're calculating this list of turfs here instead of in Initialize like the rest, is because we're gonna pick and take from it
	//So we can avoid macrolasers targeting the same turfs
	var/list/macrolaser_target_turfs = list()
	for(var/turf/possible_turf in macrolaser_threatened_turfs)
		if(possible_turf.is_blocked_turf(TRUE))
			continue
		macrolaser_target_turfs += possible_turf
	macrolaser_target_turfs -= danger_close_turfs

	laserloop.start()
	for(var/i = 1 to max_laser_repeats)
		//There are 40 ticks in the laser phase. This following chunk of code basically fires a mini laser barrage on ticks 8, 16, 24 and 32. (4 barrages)
		//It follows the logic of the mini lasers raining down as the main lasers fire and continuing slightly after they've stopped (due to the timer on mini lasers)
		//We also fire a single macro laser on ticks 4, 8, 12, 16, 20, 24, 28, 32 and 36. (9 macro lasers)
		if(i % 8 == 0 && i <= max_laser_repeats * 0.80)
			FireLaserBarrage(microbarrage_target_turfs)
		if(i % 4 == 0 && i <= max_laser_repeats * 0.90)
			FireMacroLaser(pick_n_take(macrolaser_target_turfs))

		var/list/already_hit = list()
		for(var/turf/T in hit_line)
			for(var/mob/living/L in range(1, T))
				if(L.status_flags & GODMODE)
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				if(faction_check_mob(L))
					continue
				already_hit += L
				L.apply_damage(laser_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		SLEEP_CHECK_DEATH(0.25 SECONDS)
	StopLaser()

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/StopLaser()
	playsound(get_turf(src), 'sound/effects/ordeals/green/midnight_laser_end.ogg', 75, FALSE, 24)
	laserloop.stop()
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	for(var/atom/A in lasers)
		animate(A, alpha = 0, time = 1 SECONDS)
		QDEL_IN(A, (1 SECONDS))
	lasers = list()
	SLEEP_CHECK_DEATH(2 SECONDS)
	CloseShell()
	laser_cooldown = world.time + laser_cooldown_time
	firing = FALSE
	//Now that we've stopped firing, let's prepare to deploy a squad of friendlies
	DeployBotSquad()

// This proc is used to fire a barrage of mini lasers, it is called several times during the helix's lasers being active. An alternative way to do this would be
// placing it on Life() like Waxing does, but I only wanted it to happen while the Helix was firing.
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/FireLaserBarrage(list/valid_turfs)
	for(var/turf/unfortunate_turf in valid_turfs)
		if(prob(6))
			addtimer(CALLBACK(src, PROC_REF(FireMiniLaser), unfortunate_turf), rand(1, 50))


// The mini-lasers are code taken from Waxing of the Black Sun with some minor statistical tweaks.
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/FireMiniLaser(turf/target_turf)
	new /obj/effect/temp_visual/helix_minilaser(target_turf)

/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/FireMacroLaser(turf/target_turf)
	new /obj/effect/temp_visual/helix_macrolaser(target_turf)

//They are mainly a nuisance that causes people stacking in tight spots to move and shuffle and get eachother killed. Encourages not dumping BLACK armour for the ordeal
/obj/effect/temp_visual/helix_minilaser
	name = "helix of the end mini-laser"
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "pillar_strike"
	duration = 15
	color = "#7ac21f"

/obj/effect/temp_visual/helix_minilaser/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(Blowup)), 10)

/obj/effect/temp_visual/helix_minilaser/proc/Blowup()
	playsound(src, 'sound/weapons/fixer/generic/rcorp4.ogg', 15, FALSE, 4)
	for(var/mob/living/H in src.loc)
		if(!faction_check(H.faction, list("green_ordeal")))
			H.apply_damage(55, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE))
			to_chat(H, span_userdanger("You're hit by [src.name]!"))

/// This laser hits in a 3 tile radius (the epicenter and its adjacent tiles).
/// First, a warning appears. 1.6s after the warning appears, the actual laser hits.
/obj/effect/temp_visual/helix_macrolaser
	name = "helix of the end macro-laser"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "warning"
	duration = 30
	color = "#d82d21"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32

/obj/effect/temp_visual/helix_macrolaser/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(Blowup)), 16)

/obj/effect/temp_visual/helix_macrolaser/proc/Blowup()
	icon_state = "beamin"
	color = "#7ac21f"
	transform *= 2.5
	pixel_y += 80
	playsound(src, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 65, TRUE, 4)
	for(var/mob/living/H in range(3, src))
		var/distance = get_dist(src, H)
		if(distance < 2)
			if(!faction_check(H.faction, list("green_ordeal")))
				H.apply_damage(50, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE))
				to_chat(H, span_userdanger("You're hit by [src.name]!"))
			shake_camera(H, 6, 1.5)

		else
			shake_camera(H, 4, 0.7)
	var/datum/effect_system/spark_spread/explosion_sparks = new /datum/effect_system/spark_spread
	explosion_sparks.set_up(7, 0, loc)
	explosion_sparks.start()

//This proc is called to return a list with all the types that should be spawned by the next deployment. DeployBotSquad() trusts whatever list is given to it, so we
//make sure we don't generate too many mobs in this proc (else midnight could spawn infinite mobs)
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/GenerateBotSquad()
	var/list/squad = list()
	/// Increase our target squad size, but not beyond our maximum.
	var/health_lost = maxHealth - health
	var/health_thresholds_passed = floor(health_lost / (maxHealth * 0.1))
	var/squad_size = min(base_squad_size + (squad_size_increase_step * health_thresholds_passed), maximum_squad_size)
	var/remaining_spawn_budget = squad_size - active_minions
	for(var/i = 1 to remaining_spawn_budget)
		//We want the last 40% of our budget to be comprised of Green Noons. They are the priority spawn here
		if(i <= (squad_size * 0.4))
			squad += /mob/living/simple_animal/hostile/ordeal/green_bot_big/factory
		else
		//If we have budget to spare, we can get one of these I guess. Honestly by this point in the shift, they are irrelevant, EXCEPT the Syringe Bots. They are lethal.
		//These are specifically the /factory subtype because we don't want a lobillion dead bodies to be left behind.
			squad += pick(list(
				/mob/living/simple_animal/hostile/ordeal/green_bot/factory,
				/mob/living/simple_animal/hostile/ordeal/green_bot/syringe/factory,
				/mob/living/simple_animal/hostile/ordeal/green_bot/fast/factory,
			))
	return squad

//This proc will deploy the remaining spawn budget (squad size - currently active bots) through drop pods.
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/DeployBotSquad()
	/// First, check if we moved because of whatever weird stuff.
	CheckIfMoved()
	//We get the types we want to spawn in a list here
	var/list/squad = GenerateBotSquad()

	if(length(squad) <= 0)
		return //I guess we're not doing anything.

	//These are all the turfs around us.
	var/list/deployment_points = RANGE_TURFS(8, src)
	//These are the turfs especially close to us.
	var/list/danger_close_turfs = RANGE_TURFS(2, src)

	//Wait for the shells to close fully.
	SLEEP_CHECK_DEATH(2 SECONDS)
	//Animate firing the pods. This takes 1 second.
	left_shell.icon_state = "greenmidnight_casel_firingpods"
	right_shell.icon_state = "greenmidnight_caser_firingpods"
	playsound(src, 'sound/items/fultext_launch.ogg', 90, TRUE, 10)
	SLEEP_CHECK_DEATH(0.3 SECONDS)
	playsound(src, 'sound/items/fultext_launch.ogg', 90, TRUE, 10)
	SLEEP_CHECK_DEATH(0.7 SECONDS)
	//Back to the normal icon.
	left_shell.icon_state = "greenmidnight_casel"
	right_shell.icon_state = "greenmidnight_caser"


	for(var/turf/place in deployment_points)
		//Don't deploy a bot in an obstructed turf, or somewhere we can't see, or in... lava? Yes, we have maps with lava apparently.
		if(!isInSight(src, place) || place.is_blocked_turf(TRUE) || istype(place, /turf/open/lava))
			deployment_points -= place

	deployment_points -= danger_close_turfs

	for(var/mob in squad)
		//If we actually have any valid turfs left, we can pick from them. If we ran out, I guess we're dropping them right beneath us
		var/turf/chosen_deployment_point = length(deployment_points) > 0 ? pick(deployment_points) : locate(src.x, src.y-1, src.z)
		//We need a supply pod to drop our bot in. Then we'll put our minion inside
		var/obj/structure/closet/supplypod/helixpod/deployment_pod = new()
		var/mob/living/simple_animal/hostile/ordeal/minion = new mob(deployment_pod)
		//Add them to Ordeal tracking
		if(ordeal_reference)
			minion.ordeal_reference = src.ordeal_reference
			src.ordeal_reference.ordeal_mobs += minion
		//We register an active minion to prevent us from spawning a limbillion of them, and we ask them to tell us when they die so we can adjust our spawn budget
		active_minions++
		RegisterSignal(minion, COMSIG_LIVING_DEATH, PROC_REF(UnlinkMinion))
		//Make them deploy and remove their spot from the available deployment pool
		new /obj/effect/pod_landingzone(chosen_deployment_point, deployment_pod)
		deployment_points -= chosen_deployment_point
		//They shouldn't arrive all at the same time, it would feel too un-natural. This will stagger their arrival a tiny bit and make it look better
		SLEEP_CHECK_DEATH(rand())

/mob/living/simple_animal/hostile/ordeal/green_midnight/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/green_midnight/spawn_dust()
	return
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/UnlinkMinion()
	active_minions--

// This proc handles the scaling for this mob according to active agent+suppression agent count. The normal methods for handling scaling don't really work here
// AND Ordeals normally scale off of GLOB.clients which is... unideal
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/HandleScaling()
	//This list should count all living Agents and ERAs + DO. This will need to be changed when CRAs are added, probably.
	//This also doesn't account for nefarious RO/EO/Clerks that might want to "help", but I don't consider it a huge issue. AvailableAgentCount() is an alternative that
	//counts dead Agents as well.
	var/list/meaningful_enemies = AllLivingAgents(TRUE)
	//These are our "base values" but bear in mind that, if we have any agents alive as it initializes, which we should have at least 1, it will apply scaling to it.
	base_squad_size = 4
	maximum_squad_size = 9
	squad_size_increase_step = 1
	laser_cooldown_time = 25 SECONDS // You'll get more time to deal with mobs if you have less Agents

	/// SCALING AS OF LATEST UPDATE: (Agents, ERAs and DOs are factored into scaling. Agents that exist through un-natural means may not be factored)
	/// 0 Agents (huh?): 4 initial bots / 9 maximum bots / +1 bot per 10% hp missing / 25s laser CD
	/// 1 Agent: 6 initial bots / 12 maximum bots / +1 bot per 10% hp missing / 24s laser CD
	/// 2 Agents: 8 initial bots / 15 maximum bots / +1 bot per 10% hp missing / 23s laser CD
	/// 3 Agents: 10 initial bots / 18 maximum bots / +2 bots per 10% hp missing / 22s laser CD
	/// 4 Agents: 10 initial bots / 20 maximum bots / +2 bots per 10% hp missing / 21s laser CD
	/// Do remember that not all bots spawned are Noons.

	if(meaningful_enemies)
		for(var/gremlin in meaningful_enemies)
			base_squad_size += 2
			maximum_squad_size += 3
			squad_size_increase_step += 0.34
			laser_cooldown_time -= 1 SECONDS

		base_squad_size = min(base_squad_size, 10)
		maximum_squad_size = min(maximum_squad_size, 20)
		squad_size_increase_step = min(floor(squad_size_increase_step), 3)
		laser_cooldown_time = max(laser_cooldown_time, 20 SECONDS)

/// This proc is called every time the Helix is about to fire its lasers. It's responsible for populating the list of target turfs for its laser barrages.
/// Why does this exist? On the off chance someone does something EXTREMELY cursed with a W Corp teleporter OR an admin moves it somewhere forcibly.
/// This proc will ensure the Helix is always firing lasers in the correct general area, and it will also move the shell objects to it to make sure it looks right.
/mob/living/simple_animal/hostile/ordeal/green_midnight/proc/CheckIfMoved()
	if(src.loc != entrenched_at)
		entrenched_at = src.loc
		left_shell.forceMove(entrenched_at)
		right_shell.forceMove(entrenched_at)
		microbarrage_threatened_turfs = RANGE_TURFS(12, src)
		macrolaser_threatened_turfs = RANGE_TURFS(8, src)
		danger_close_turfs = RANGE_TURFS(2, src)
		microbarrage_target_turfs = microbarrage_threatened_turfs - danger_close_turfs

/obj/structure/closet/supplypod/helixpod
	name = "protocol of contemplation"
	desc = "Things are about to get heated."
	specialised = FALSE
	style = STYLE_HELIX
	bluespace = TRUE
	explosionSize = list(0,0,0,0)
	max_integrity = 5000 //I'd rather the players not instakill the mobs by destroying the pods
	delays = list(POD_TRANSIT = 3 SECONDS, POD_FALLING = 0.2 SECONDS, POD_OPENING = 2.5 SECONDS, POD_LEAVING = 0.7 SECONDS)
