// Amber dawn
/mob/living/simple_animal/hostile/ordeal/amber_bug
	name = "complete food"
	desc = "A tiny worm-like creature with tough chitin and a pair of sharp claws."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "amber_bug"
	icon_living = "amber_bug"
	icon_dead = "amber_bug_dead"
	faction = list("amber_ordeal")
	maxHealth = 80
	health = 80
	speed = 2
	rapid_melee = 2
	density = FALSE
	melee_damage_lower = 4
	melee_damage_upper = 6
	turns_per_move = 2
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/amber/dawn_attack.ogg'
	attack_sound = 'sound/effects/ordeals/amber/dawn_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL
	butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	silk_results = list(/obj/item/stack/sheet/silk/amber_simple = 1)

	/// This cooldown responds for both the burrowing and spawning in the dawns
	var/burrow_cooldown
	var/burrow_cooldown_time = 1 MINUTES

	/// If TRUE - cannot move nor attack
	var/burrowing = FALSE

	var/can_burrow_solo = TRUE // False for amber dawns spawned by dusks that are still alive
	var/can_infect = TRUE // False for the hungriest one. Maybe also set this to false for dusk spawn if it ever becomes an issue.

/mob/living/simple_animal/hostile/ordeal/amber_bug/Initialize()
	. = ..()
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y
	if(SSmaptype.maptype in SSmaptype.citymaps)
		can_infect = FALSE //We want to avoid unecessary corpse gibbing and amber proliferation for cityspawn.
	if(LAZYLEN(butcher_results)) //// It burrows in on spawn, spawned ones shouldn't
		addtimer(CALLBACK(src, PROC_REF(BurrowOut), get_turf(src)))
	if(SSmaptype == "lcorp_city")
		can_burrow_solo = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_bug/death(gibbed)
	alpha = 255
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_bug/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(can_burrow_solo && !burrowing && world.time > burrow_cooldown)
		BurrowIn()

/mob/living/simple_animal/hostile/ordeal/amber_bug/CanAttack(atom/the_target)
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_bug/Move()
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_bug/Goto(target, delay, minimum_distance)
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_bug/DestroySurroundings()
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_bug/GiveTarget(new_target)
	. = ..()
	if(. && target) //reset burrow cooldown whenever in combat
		burrow_cooldown = world.time + burrow_cooldown_time

/mob/living/simple_animal/hostile/ordeal/amber_bug/AttackingTarget(atom/attacked_target)
	if(burrowing)
		return
	. = ..()
	if(.)
		var/dir_to_target = get_dir(get_turf(src), get_turf(attacked_target))
		animate(src, pixel_y = (base_pixel_y + 18), time = 2)
		addtimer(CALLBACK(src, PROC_REF(AnimateBack)), 2)
		for(var/i = 1 to 2)
			var/turf/T = get_step(get_turf(src), dir_to_target)
			if(T.density)
				return
			if(locate(/obj/structure/window) in T.contents)
				return
			for(var/obj/machinery/door/D in T.contents)
				if(D.density)
					return
			if(ishuman(attacked_target) && can_infect)
				var/mob/living/carbon/human/H = attacked_target
				var/parasite_slot = H.getorganslot(ORGAN_SLOT_PARASITE_EGG)
				if(H.stat != CONSCIOUS && !parasite_slot) //Only infect people in crit/dead and that don't have a parasite of some kind already.
					var/obj/item/organ/amber_bug/amber_parasite = new(H)
					amber_parasite.ordeal_reference = ordeal_reference
					playsound(get_turf(src), 'sound/effects/ordeals/amber/dawn_dig_in.ogg', 25, 1)
					to_chat(H, span_danger("The bug is eating its way inside your chest!"))
					qdel(src)
			forceMove(T)
			SLEEP_CHECK_DEATH(2)

/mob/living/simple_animal/hostile/ordeal/amber_bug/proc/AnimateBack()
	animate(src, pixel_y = base_pixel_y, time = 2)
	return TRUE

/mob/living/simple_animal/hostile/ordeal/amber_bug/proc/BurrowIn(turf/T)
	if(!T)
		if(length(GLOB.xeno_spawn))
			T = pick(GLOB.xeno_spawn)

		else if(SSmaptype == "lcorp_city")
			can_burrow_solo = FALSE
			return

		else
			can_burrow_solo = FALSE
			return
	burrowing = TRUE
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dawn_dig_in.ogg', 25, 1)
	animate(src, alpha = 0, time = 5)
	SLEEP_CHECK_DEATH(5)
	BurrowOut(T)

/mob/living/simple_animal/hostile/ordeal/amber_bug/proc/BurrowOut(turf/T)
	burrowing = TRUE
	alpha = 0
	var/list/valid_turfs = list(T)
	for(var/turf/PT in RANGE_TURFS(2, T))
		if(!PT.is_blocked_turf_ignore_climbable())
			valid_turfs |= PT
	var/turf/target_turf = pick(valid_turfs)
	forceMove(target_turf)
	new /obj/effect/temp_visual/small_smoke/halfsecond(target_turf)
	animate(src, alpha = 255, time = 5)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dawn_dig_out.ogg', 25, 1)
	visible_message(span_bolddanger("[src] burrows out from the ground!"))
	SLEEP_CHECK_DEATH(5)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(target_turf, src)
	animate(D, alpha = 0, transform = matrix()*1.5, time = 5)
	for(var/mob/living/L in target_turf)
		if(!faction_check_mob(L))
			L.apply_damage(5, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	burrow_cooldown = world.time + burrow_cooldown_time
	burrowing = FALSE

//Amber dawn spawned from dusk and hungriest one.
/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned
	can_burrow_solo = FALSE
	butcher_results = list()
	guaranteed_butcher_results = list()
	var/mob/living/simple_animal/hostile/ordeal/amber_dusk/bug_mommy

/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/Initialize()
	. = ..()
	burrow_cooldown = world.time + burrow_cooldown_time

/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/Destroy()
	if(bug_mommy)
		bug_mommy.spawned_mobs -= src
	bug_mommy = null
	return ..()

//A variation of the amber dawn that will eat corpses to grow stronger.
/mob/living/simple_animal/hostile/ordeal/amber_bug/hungriest_one
	name = "Hungriest One"
	desc = "This one looks like it'll eat anything that moves."
	maxHealth = 150
	health = 150
	melee_damage_lower = 9
	melee_damage_upper = 12
	color = "#a51f08"
	can_infect = FALSE
	stat_attack = DEAD
	can_burrow_solo = FALSE
	var/feeding_count = 0
	var/max_feeding_count = 10

	//Variables dictating wow many stats the bug will get per kill. (Decimals are % based on total health)
	var/scaling_damage = 3
	var/scaling_max_health = 0.2
	var/scaling_healing = 0.2
	var/spawn_on_kill = 3
	var/count_per_kill = 1
	var/size_per_kill = 1.1

	var/spawn_on_max_feed = 15
	var/mob/mob_spawned = "/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned" //What the bug will spawn on both kills and upon reaching max feeding count.

/mob/living/simple_animal/hostile/ordeal/amber_bug/hungriest_one/Initialize()
	. = ..()
	faction = list() //Removes all original allegiances of the bug on spawn. It's everyone's problem now.

//Make the bugs spawn around the hungriest one if possible, on top of if they can't. Also makes sure they don't spawn into walls.
/mob/living/simple_animal/hostile/ordeal/amber_bug/hungriest_one/proc/SpawnBug(turf/src_turf)
	var/list/all_turfs = RANGE_TURFS(1, src_turf)
	for(var/turf/T in all_turfs)
		if(T.is_blocked_turf(exclude_mobs = TRUE) || T == src_turf)
			all_turfs -= T
	var/turf/T = pick(all_turfs)
	if(!T || T == null)
		T = src_turf
	new mob_spawned(T)

/mob/living/simple_animal/hostile/ordeal/amber_bug/hungriest_one/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!. || !isliving(attacked_target))
		return

	var/mob/living/meal = attacked_target
	if(istype(attacked_target, /mob/living/simple_animal/hostile/ordeal/amber_bug))
		meal.adjustBruteLoss(200) //Should one shot every bug, but not other hugriest one.
		visible_message(span_warning("[meal] is torn to shred by [src]!"))

	if(meal.stat != DEAD)
		return

	var/turf/src_turf = get_turf(src)
	if(ishuman(meal))
		for(var/i = 0, i < spawn_on_kill, i++)
			SpawnBug(src_turf) //Every corpse is worth as much feeding count, but human ones lets it spawn more bugs to eat.
			adjustBruteLoss(-maxHealth*0.5)
	feeding_count += count_per_kill

	if(feeding_count >= max_feeding_count)
		gib()
		var/max_spawn = clamp(length(GLOB.clients) * 4, 1, 15)
		var/amber_list
		var/bug_spawned = 0
		if(ordeal_reference)
			amber_list = ordeal_reference.ordeal_mobs
		for(var/i = 0, i < 15, i++)
			if(length(bug_spawned) > max_spawn || length(amber_list) > 50)
				return
			SpawnBug(src_turf) //TODO: Maybe a more interesting transformation. Right now it just spawns more bugs/mobs.
			bug_spawned++
	else
		setMaxHealth(maxHealth* (1 + scaling_max_health)) //Exponential growth. It should be stopped by the eventual feeding count cap.
		adjustBruteLoss(-maxHealth*scaling_healing)
		melee_damage_lower += scaling_damage
		melee_damage_upper += scaling_damage //Should go up to 40~ damage total before it explodes.

		transform = transform.Scale(size_per_kill, size_per_kill)

	meal.gib()

/* DAWN AMBER ORGAN */
/obj/item/organ/amber_bug
	name = "hungry mass"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_PARASITE_EGG
	icon_state = "tonguetied"
	color = "gold"
	var/physical_symptoms = FALSE
	var/feeding_stage = 0
	var/max_feeding_stage = 3
	var/feeding_duration
	var/total_bug_spawned = 0
	var/cured = FALSE
	var/datum/ordeal/ordeal_reference

	var/feeding_interval = 1.5 MINUTES
	var/spawn_amount = 2 //How many extra bugs spawn per feeding stage.

/obj/item/organ/amber_bug/Initialize()
	. = ..()
	if(ishuman(loc))
		feeding_duration = world.time + (feeding_interval)
		Insert(loc)

/obj/item/organ/amber_bug/on_find(mob/living/finder)
	. = ..()
	to_chat(finder, span_warning("You find something eating [owner]'s insides!"))

/obj/item/organ/amber_bug/Remove(mob/living/carbon/human/M, special = 0)
	if(M && !cured)
		visible_message(span_warning("A bug leaps out of [M]!"))
		SpawnBug(1)
	. = ..()

/obj/item/organ/amber_bug/on_life()
	. = ..()
	growProcess()

/obj/item/organ/amber_bug/on_death()
	. = ..()
	growProcess() //Keeps eating even if they're dead.

/obj/item/organ/amber_bug/proc/SpawnBug(bug_spawned)
	var/max_spawn_amount = max_feeding_stage + spawn_amount
	var/max_spawn = clamp(length(GLOB.clients) * 5, 2, max_spawn_amount) //Has a much higher cap per player than dusk at 5 bugs per client, due to the circumstances of spawn being rarer and longer.
	var/list/amber_list
	if(ordeal_reference)
		amber_list = ordeal_reference.ordeal_mobs

	var/turf/T = get_turf(owner)

	for(var/i = 0, i < spawn_amount, i++)
		var/mob/living/simple_animal/hostile/ordeal/amber_bug/bug = new(T)
		total_bug_spawned++
		if(length(total_bug_spawned) > max_spawn || length(amber_list) > 50)
			if(owner.stat == DEAD)
				owner.gib()
			qdel(src)
			return

		if(ordeal_reference)
			bug.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += bug

/obj/item/organ/amber_bug/proc/growProcess()
	if(!src || QDELETED(src))
		return //Here to fix a bug where it'd spawn two worms for some reason.

	if(!owner)
		qdel(src)
		return

	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)

	if(H?.reagents?.has_reagent(/datum/reagent/amber)) //The 'cure' is amber bug meat.
		to_chat(H, span_warning("The bug, tricked into eating the meat of its own kind, finds its way out of your body!"))
		var/mob/living/simple_animal/hostile/ordeal/amber_bug/hungriest_one/bug = new(T)
		if(ordeal_reference)
			bug.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += bug
		cured = TRUE
		qdel(src)
		return

	if(world.time <= feeding_duration)
		return

	var/bug_spawned = feeding_stage + 2 //Should go 3,4,5 bugs then explode, for a total of 12 bugs per body over 4.5 minutes.
	feeding_duration = world.time + (feeding_interval)
	feeding_stage++
	H.apply_damage(feeding_stage * 10, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	visible_message(span_danger("[feeding_stage] bugs eat their way out of [H]'s body!"))
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dawn_dig_out.ogg', 25, 1)
	if(H.stat != DEAD)
		H.emote("scream")
	SpawnBug(bug_spawned)
	if(feeding_stage >= max_feeding_stage)
		if(H.stat == DEAD)
			H.gib()
		qdel(src)

// Amber dusk
/mob/living/simple_animal/hostile/ordeal/amber_dusk
	name = "food chain"
	desc = "A big worm-like creature with jagged teeth at its front."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "amber_dusk"
	icon_living = "amber_dusk"
	icon_dead = "amber_dusk_dead"
	faction = list("amber_ordeal")
	maxHealth = 2200
	health = 2200
	speed = 4
	move_to_delay = 7
	density = FALSE
	status_flags = CANPUSH | MUST_HIT_PROJECTILE
	melee_damage_lower = 100
	melee_damage_upper = 115 // If you get hit by them it's a major skill issue
	pixel_x = -16
	base_pixel_x = -16
	butcher_results = list(/obj/item/food/meat/slab/worm = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 2)
	silk_results = list(/obj/item/stack/sheet/silk/amber_simple = 2, /obj/item/stack/sheet/silk/amber_advanced = 1)
	attack_verb_continuous = "eviscerates"
	attack_verb_simple = "eviscerate"
	attack_sound = 'sound/effects/ordeals/amber/dusk_attack.ogg'
	death_sound = 'sound/effects/ordeals/amber/dusk_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL
	should_projectile_blockers_change_orientation = TRUE
	occupied_tiles_up = 1
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = 0, "east" = -32)
	offsets_pixel_y = list("south" = 9, "north" = -20, "west" = 0, "east" = 0)

	/// This cooldown responds for both the burrowing and spawning in the dawns
	var/burrow_cooldown
	var/burrow_cooldown_time = 20 SECONDS

	/// If TRUE - cannot move nor attack
	var/burrowing = FALSE
	/// List of currently spawned dawns, so we don't create too many
	var/list/spawned_mobs = list()
	//If they can burrow or not.
	var/can_burrow = TRUE

	var/datum/looping_sound/amberdusk/soundloop

/mob/living/simple_animal/hostile/ordeal/amber_dusk/CanAttack(atom/the_target)
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Move()
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Goto(target, delay, minimum_distance)
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/DestroySurroundings()
	if(burrowing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Initialize()
	. = ..()
	setDir(WEST)
	soundloop = new(list(src), TRUE)
	if(LAZYLEN(butcher_results))
		addtimer(CALLBACK(src, PROC_REF(BurrowOut), get_turf(src)))
	if(SSmaptype == "lcorp_city")
		can_burrow = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/OnDirChange(atom/thing, dir, newdir)
	. = ..()
	if(stat == DEAD)
		return
	var/static/matrix/add_vertical_transform = matrix(0.8, 1.4, MATRIX_SCALE)
	var/static/south_north = SOUTH | NORTH
	var/static/east_west = EAST | WEST
	var/combined = dir | newdir
	if((combined & south_north) && (combined & east_west))
		if(newdir & south_north)
			transform = add_vertical_transform
		else
			transform = matrix()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Destroy()
	QDEL_NULL(soundloop)
	for(var/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/bug as anything in spawned_mobs)
		bug.bug_mommy = null
	spawned_mobs = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(can_burrow)
		if(!burrowing && world.time > burrow_cooldown)
			AttemptBirth()
			BurrowIn()

//Can only attack near the mouth
/mob/living/simple_animal/hostile/ordeal/amber_dusk/AttackCondition(atom/attack_target)
	var/relative_angle = abs(dir2angle(dir) - dir2angle(get_dir(src, attack_target)))
	relative_angle = relative_angle > 180 ? 360 - relative_angle : relative_angle
	if(relative_angle > 90)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/death(gibbed)
	if(LAZYLEN(butcher_results))
		alpha = 255
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	offsets_pixel_y = list("south" = 0, "north" = 0, "west" = 0, "east" = 0)
	transform = matrix()
	soundloop.stop()
	for(var/mob/living/simple_animal/hostile/ordeal/amber_bug/bug in spawned_mobs)
		bug.can_burrow_solo = TRUE
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/revive(full_heal, admin_revive)
	. = ..()
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = 0, "east" = -32)
	offsets_pixel_y = list("south" = 9, "north" = -20, "west" = 0, "east" = 0)
	density = TRUE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/AttemptBirth()
	var/max_spawn = clamp(length(GLOB.clients) * 2, 4, 8)
	if(length(spawned_mobs) >= max_spawn)
		return FALSE

	burrowing = TRUE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_create.ogg', 50, FALSE)
	SLEEP_CHECK_DEATH(5)
	visible_message(span_danger("Four smaller bugs emerge from [src]!"))
	for(var/i = 1 to 4)
		var/turf/Turf = get_step(get_turf(src), pick(0, NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		if(Turf.density) // Retry
			i -= 1
			continue

		var/mob/living/simple_animal/hostile/ordeal/amber_bug/spawned/bug = new(Turf)
		spawned_mobs += bug
		bug.bug_mommy = src
		if(ordeal_reference)
			bug.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += bug

	SLEEP_CHECK_DEATH(5)
	burrowing = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/BurrowIn()
	burrowing = TRUE
	var/turf/T = pick(GLOB.xeno_spawn)
	if(!T)
		T = get_turf(src)
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_dig_in.ogg', 50, 1)
	animate(src, alpha = 0, time = 10)
	SLEEP_CHECK_DEATH(5)
	for(var/mob/living/simple_animal/hostile/ordeal/amber_bug/bug as anything in spawned_mobs)
		addtimer(CALLBACK(bug, PROC_REF(BurrowIn), T))
	SLEEP_CHECK_DEATH(5)
	density = FALSE
	forceMove(T)
	BurrowOut(T)

/mob/living/simple_animal/hostile/ordeal/amber_dusk/proc/BurrowOut(turf/T)
	burrowing = TRUE
	alpha = 0
	density = FALSE
	for(var/turf/open/OT in range(1, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(OT)

	animate(src, alpha = 255, time = 5)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dusk_dig_out.ogg', 50, 1)
	visible_message(span_bolddanger("[src] burrows out from the ground!"))
	SLEEP_CHECK_DEATH(5)
	density = TRUE
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, src)
	animate(D, alpha = 0, transform = matrix()*1.5, time = 5)
	for(var/mob/living/L in view(1, src))
		if(!faction_check_mob(L))
			L.apply_damage(75, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))

	burrow_cooldown = world.time + burrow_cooldown_time
	burrowing = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned
	butcher_results = list()
	guaranteed_butcher_results = list()
	var/mob/living/simple_animal/hostile/ordeal/amber_midnight/bug_daddy

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/Initialize()
	burrow_cooldown = world.time + burrow_cooldown_time
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/Destroy()
	if(bug_daddy)
		bug_daddy.spawned_mobs -= src
	bug_daddy = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	return ..()

// Amber midnight
/mob/living/simple_animal/hostile/ordeal/amber_midnight
	name = "eternal meal"
	desc = "A giant insect-like creature with a ton of sharp rocky teeth."
	health = 15000
	maxHealth = 15000
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "ambermidnight"
	icon_living = "ambermidnight"
	icon_dead = "ambermidnight_dead"
	faction = list("amber_ordeal")

	light_color = COLOR_YELLOW
	light_range = 4
	light_power = 1

	density = FALSE
	alpha = 0
	pixel_x = -96
	base_pixel_x = -96
	pixel_y = -16
	base_pixel_y = -16
	occupied_tiles_left = 1
	occupied_tiles_right = 1
	occupied_tiles_up = 2
	offsets_pixel_x = list("south" = -96, "north" = -96, "west" = -96, "east" = -96)
	offsets_pixel_y = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	damage_effect_scale = 1.25

	blood_volume = BLOOD_VOLUME_NORMAL
	death_sound = 'sound/effects/ordeals/amber/midnight_dead.ogg'

	var/burrowing = FALSE
	var/burrow_cooldown
	var/burrow_cooldown_time = 20 SECONDS
	var/list/spawned_mobs = list()

	var/datum/looping_sound/ambermidnight/soundloop

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Initialize()
	. = ..()
	burrow_cooldown = world.time + 20 SECONDS
	soundloop = new(list(src), TRUE)
	addtimer(CALLBACK(src, PROC_REF(BurrowOut)))

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Destroy()
	QDEL_NULL(soundloop)
	for(var/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/bug as anything in spawned_mobs)
		bug.bug_daddy = null
	spawned_mobs = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/death(gibbed)
	alpha = 255
	soundloop.stop()
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!burrowing && world.time > burrow_cooldown)
		AttemptBirth()
		BurrowIn()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/AttemptBirth()
	var/max_spawn = clamp(length(GLOB.clients) * 0.6, 2, 8)
	if(length(spawned_mobs) >= max_spawn)
		return FALSE

	burrowing = TRUE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_create.ogg', 50, FALSE)
	SLEEP_CHECK_DEATH(2 SECONDS)
	visible_message(span_danger("Two large bugs emerge from [src]!"))
	for(var/i = 1 to 2)
		var/turf/T = get_step(get_turf(src), pick(GLOB.alldirs))
		var/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/bug = new(T)
		spawned_mobs += bug
		bug.bug_daddy = src
		if(ordeal_reference)
			bug.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += bug

	SLEEP_CHECK_DEATH(2 SECONDS)
	burrowing = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/BurrowIn()
	burrowing = TRUE
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(src, 'sound/effects/ordeals/amber/midnight_in.ogg', 50, FALSE, 7)
	icon_state = "ambermidnight_leave"
	new /obj/effect/temp_visual/ambermidnight_hole(get_turf(src))
	var/list/centers = GLOB.department_centers.Copy()
	centers -= get_turf(src)
	for(var/turf/T in centers)
		if(locate(type) in T) // Found another amber midnight there
			centers -= T
	SLEEP_CHECK_DEATH(9)
	animate(src, alpha = 0, time = 1)
	density = FALSE
	for(var/turf/T in centers) // We do it twice in case something changed in that time
		if(locate(type) in T)
			centers -= T
	var/turf/T = get_turf(src)
	if(LAZYLEN(centers))
		T = pick(centers)
	SLEEP_CHECK_DEATH(1)
	forceMove(T)
	BurrowOut()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/BurrowOut()
	burrowing = TRUE
	alpha = 0
	density = FALSE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out_far.ogg', 50, TRUE, 4)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out.ogg', 75, FALSE, 7)
	new /obj/effect/temp_visual/ambersmoke(get_turf(src))
	animate(src, pixel_z = 0, alpha = 255, time = 1)
	icon_state = "ambermidnight_bite"
	visible_message(span_danger("[src] burrows out from the ground!"))
	SLEEP_CHECK_DEATH(8)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out_far.ogg', 25, FALSE, 24, 2, falloff_distance = 9)
	SLEEP_CHECK_DEATH(2)
	density = TRUE
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*1.25, time = 3)
	SLEEP_CHECK_DEATH(2)
	var/alternate = TRUE // we dont need 50 smoke effects
	for(var/turf/open/T in view(7, src))
		if(alternate)
			var/obj/effect/temp_visual/small_smoke/halfsecond/SS = new(T)
			SS.color = LIGHT_COLOR_ORANGE
			alternate = FALSE
		else
			alternate = TRUE
	for(var/mob/living/L in view(7, src))
		if(faction_check_mob(L))
			continue
		var/distance_decrease = get_dist(src, L) * 85
		L.apply_damage((1000 - distance_decrease), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
		if(L.health < 0)
			L.gib()
	SLEEP_CHECK_DEATH(5)
	burrow_cooldown = world.time + burrow_cooldown_time
	burrowing = FALSE
	icon_state = icon_living

/obj/effect/temp_visual/ambersmoke
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke"
	duration = 1.5 SECONDS
	color = COLOR_ORANGE
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32

/obj/effect/temp_visual/ambermidnight_hole
	name = "hole"
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "ambermidnight_hole"
	duration = 10 SECONDS
	pixel_x = -96
	base_pixel_x = -96
	pixel_y = -16
	base_pixel_y = -16

/obj/effect/temp_visual/ambermidnight_hole/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)
