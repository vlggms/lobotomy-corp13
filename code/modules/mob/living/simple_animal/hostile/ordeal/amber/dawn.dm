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
