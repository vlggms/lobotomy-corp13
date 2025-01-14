#define MEMORY_DEBUFF /datum/status_effect/display/better_memories_curse
#define CAMERAFLASH_RANGE 7

/mob/living/simple_animal/hostile/abnormality/better_memories
	name = "Memories from a Better Time"
	desc = "A gate of pipes or wires that hold a old TV ontop of it. \
		Piled on the floor around the gate is birthday cards, old envelopes, \
		and worn photographs. The inside of the gate is a dark void with a \
		distant pink light."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "better_memories"
	core_icon = "memories_egg"
	portrait = "better_memories"
	pixel_x = -16
	base_pixel_x = -16
	threat_level = HE_LEVEL
	melee_damage_type = RED_DAMAGE
	retreat_distance = 3
	minimum_distance = 3
	ranged = TRUE
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 20,
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 20, 40, 50, 50),
		ABNORMALITY_WORK_REPRESSION = list(60, 65, 40, 20, 20)
		)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/morii,
		/datum/ego_datum/armor/morii,
	)
	gift_type = /datum/ego_gifts/morii
	//Abnormality Jam Submission
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "In the pile around the abnormality, you find a old card. <br>You almost forgot about them. <br>\
		A pink light grows and you feel a tug on your memory."
	observation_choices = list(
		"Let go" = list(TRUE, "You let go of the memory forever. <br>You look forward to the day you can make a memory like that again."),
		"Hold on" = list(FALSE, "You pull the letter back from the pink light inside the abnormality's gate. <br>\
			The memory becomes more and more vivid as if its happening now... <br>when you finally break free you cannot recall what you fought so hard for."),
	)

	var/minions = 0

/mob/living/simple_animal/hostile/abnormality/better_memories/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>Memories of a Better Time produces a minion when it reaches ZeroQliphoth. \
		Your mind will be automatically sent to this minion on breach. \
		The minion is a fast moving entity with a weak red damage stab. Its real power comes \
		from its ability to apply prudence debuffs to humanoids using its flash ability. \
		While using your ability your immobilized for 1.5 seconds. It is suggested to use a \
		hit and run playstyle.</b>")

// Those with low temperance will find a memory in the pile.
/mob/living/simple_animal/hostile/abnormality/better_memories/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
		user.apply_status_effect(MEMORY_DEBUFF)

// Better memories can have 3 seperate minions who will terroize the facility. Code modified from luna.dm
/mob/living/simple_animal/hostile/abnormality/better_memories/ZeroQliphoth(mob/living/carbon/human/user)
	if(minions >= 3)
		return FALSE
	var/mob/living/breaching_minion
	//Normal breach
	if(!IsCombatMap())
		var/turf/W = pick(GLOB.department_centers)
		breaching_minion = SpawnMinion(get_turf(W))
		datum_reference.qliphoth_change(2)

	//--Side Gamemodes stuff--
	else
		SpawnMinion(get_turf(src)) // Spawns 2 minions on Rcorp.
		breaching_minion = SpawnMinion(get_turf(src))
		core_enabled = FALSE // Normally in RCA it would drop a core the moment it spawns. Since the minions are not the abnormality, this may require a proper implementation later. -Mr. H
		QDEL_IN(src, 1 SECONDS) //Destroys the core, as it is unecessary in Rcorp.

	if(client)
		mind.transfer_to(breaching_minion) //For playable abnormalities, directly lets the playing currently controlling core get control of the spawned mob
	return

//Side Gamemodes stuff, should only ever be called outside of the main gamemode
/mob/living/simple_animal/hostile/abnormality/better_memories/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(!IsCombatMap())
		return FALSE
	ZeroQliphoth()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/better_memories/proc/SpawnMinion(turf/spawn_turf)
	var/mob/living/simple_animal/hostile/better_memories_minion/spawningmonster = new(spawn_turf)
	RegisterSignal(spawningmonster, COMSIG_PARENT_QDELETING, PROC_REF(MinionSlain))
	minions++
	return spawningmonster

/mob/living/simple_animal/hostile/abnormality/better_memories/proc/MinionSlain()
	SIGNAL_HANDLER
	minions--


//Minion Spawn
/mob/living/simple_animal/hostile/better_memories_minion
	name = "Memories from a Better Time"
	desc = "A human with a old styled camera for a head and 8 slender spider legs."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "better_memories_a"
	base_pixel_x = -16
	pixel_x = -16
	health = 1000
	maxHealth = 1000
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	melee_damage_lower = 4
	melee_damage_upper = 8
	rapid_melee = 2
	move_to_delay = 2
	robust_searching = TRUE
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "jabs"
	attack_verb_simple = "jab"
	can_patrol = TRUE
	patrol_cooldown_time = 10 SECONDS
	var/can_act = TRUE
	//For when the creature is fleeing
	var/fleeing_now = FALSE
	//Variables used to keep track of who each memory is hunting
	var/current_target
	var/list/static/hunt_targets = list()

/mob/living/simple_animal/hostile/abnormality/better_memories/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>You are a minion of Memories from a Better Time. \
		What you actually are is up for debate, but you do know that \
		you function best as a hit and run fighter using your camera \
		flash attack to reduce the work success rate, temperance, and \
		prudence of any agents caught in its sight. Your natural AI \
		would seek out those who were working on abnormalities and \
		snap a picture of them.</b>")

/mob/living/simple_animal/hostile/better_memories_minion/Move()
	if(!can_act)
		return FALSE
	return ..()

//The creature can walk over entities that are human sized or smaller.
/mob/living/simple_animal/hostile/better_memories_minion/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(isliving(blocker))
		var/mob/living/M = blocker
		if(M.mob_size <= MOB_SIZE_HUMAN || (patrol_path.len && M.type == type))
			return TRUE
	return ..()

//Directional Cone Flash Attack that applies a work success and stat debuff.
/mob/living/simple_animal/hostile/better_memories_minion/OpenFire()
	if(!can_act)
		return FALSE
	if(ranged_cooldown > world.time)
		return FALSE
	//Measure once.
	var/targ_dist = get_dist(src, target)
	if(targ_dist >= (CAMERAFLASH_RANGE - 1))
		return FALSE
	if(!AngleCamera(target))
		if(!client)
			retreat_distance = null
			minimum_distance = 1
		return FALSE
	can_act = FALSE
	CameraFlash(src)
	ranged_cooldown = world.time + ranged_cooldown_time
	can_act = TRUE
	if(!client)
		FleeNow(FindWorking())

/*
* If patrolling only target people who are working because your
* most likely hunting a working employee. If the target has the
* debuff ignore them unless they have done more than 50 damage
* to you.
*/
/mob/living/simple_animal/hostile/better_memories_minion/CanAttack(atom/the_target)
	. = ..()
	if(!ishuman(the_target))
		return
	var/mob/living/carbon/human/H = the_target
	if(patrol_path.len)
		if(!H.is_working)
			return FALSE
		if(target_memory[the_target] <= 100)
			return FALSE
	if(H.has_status_effect(MEMORY_DEBUFF))
		//You have inflicted 100 damage to us. Get jabbed.
		if(target_memory[the_target] <= 100)
			return FALSE

/mob/living/simple_animal/hostile/better_memories_minion/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(!client)
		if(ishuman(attacked_target))
			var/mob/living/carbon/human/H = attacked_target
			/* Dont jab those standing
			still for their picture.
			Death is not our goal */
			if(H.is_working)
				OpenFire()
				return
		if(OpenFire())
			return
	return ..()

//Experiment with construct.dm code where the artificers have a melee range condition.
/mob/living/simple_animal/hostile/better_memories_minion/MoveToTarget(list/possible_targets)
	..()
	//If not human then attack with jabs
	if(!ishuman(target))
		retreat_distance = null
		minimum_distance = 1
		return
	else
		var/mob/living/carbon/human/H = target
		//If your working and cannot move or are adjacent to me or my health is below 30%. Im going to jab you.
		if((!H.is_working && ((get_dist(get_turf(src), get_turf(target)) <= 1)) || health < maxHealth * 0.3))
			retreat_distance = null
			minimum_distance = 1
			return
	retreat_distance = 4
	minimum_distance = 4

/mob/living/simple_animal/hostile/better_memories_minion/patrol_select()
	//Due to some weird thing the values in hunt_target become null so this empty's the list out before it gets too long.
	if(hunt_targets.len > 5)
		hunt_targets.Cut()
	var/turf/target_turf
	if(ranged_cooldown <= world.time)
		target_turf = FindWorking()
		current_target = target_turf
		hunt_targets += target_turf

	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, /turf/proc/Distance_cardinal, 0, 200)
		return
	return ..()

/mob/living/simple_animal/hostile/better_memories_minion/patrol_reset()
	. = ..()
	FindTarget()
	if(current_target)
		hunt_targets -= current_target
		current_target = null

/*
* This is embarrassing code i had 2 choices and it was to add
* a overridable proc in line 169 of hostile.dm to override the
* goto that i had put there or create this monster of a code.
* -IP
*/
/mob/living/simple_animal/hostile/better_memories_minion/bullet_act(obj/projectile/P)
	if(fleeing_now == TRUE)
		if(prob(50))
			visible_message(span_userdanger("[src] dodges the [P]!"))
			return BULLET_ACT_FORCE_PIERCE
		//Stop ignoring damage
		StopFleeing()
	if(patrol_path.len && stat == CONSCIOUS && AIStatus != AI_OFF && !client)
		var/secondarmor = run_armor_check(null, P.damage_type, "","",P.armour_penetration)
		var/second_on_hit_state = P.on_hit(src, secondarmor)
		if(!P.nodamage && second_on_hit_state != BULLET_ACT_BLOCK)
			apply_damage(P.damage, P.damage_type, null, secondarmor)
			apply_effects(P.stun, P.knockdown, P.unconscious, P.irradiate, P.slur, P.stutter, P.eyeblur, P.drowsy, secondarmor, P.stamina, P.jitter, P.paralyze, P.immobilize)
			if(P.firer)
				RegisterAggroValue(P.firer, P.damage, P.damage_type)
			//If the projectile had no firer then just list it as nobuddy
			if(!P.firer)
				if(target_memory["nobuddy"] > 100)
					patrol_reset()
			//If our damage value for that person exceeds this number then we consider targeting them.
			if(target_memory[P.firer] > 100)
				FindTarget(list(P.firer), 1)
		return second_on_hit_state
	return ..()

/mob/living/simple_animal/hostile/better_memories_minion/attacked_by(obj/item/I, mob/living/L)
	//Stolen MOSB code.
	if(!client && LAZYLEN(patrol_path) && CanAttack(L))
		L.attack_animal(src)
	if(fleeing_now == TRUE && prob(50))
		StopFleeing()
	return ..()

/mob/living/simple_animal/hostile/better_memories_minion/CanStartPatrol()
	if(!fleeing_now)
		return !(status_flags & GODMODE)
	return ..()

//Prevents accumulation of hate when actively fleeing.
/mob/living/simple_animal/hostile/better_memories_minion/RegisterAggroValue(atom/remembered_target, value, damage_type)
	if(fleeing_now || !can_act)
		return
	..()

/*
* Modified patrol code since due to it not returning a location i cant
* use it for flee now() and i dont know if i have the authority to
* change any of that code since it goes outside the purpose of this.
* -IP
*/

/mob/living/simple_animal/hostile/better_memories_minion/proc/FleeDest()
	//Mobs should stay unpatroled on maps where they're intended to be possessed.
	if(SSmaptype.maptype in SSmaptype.autopossess)
		return
	//Due to some weird thing the values in hunt_target become null so this empty's the list out before it gets too long.
	if(hunt_targets.len > 5)
		hunt_targets.Cut()

	var/turf/target_turf
	if(ranged_cooldown <= world.time)
		target_turf = FindWorking()
		current_target = target_turf
		hunt_targets += target_turf

	if(istype(target_turf))
		return target_turf

	//Return Department Center instead.
	if(!LAZYLEN(GLOB.department_centers))
		return
	var/list/potential_centers = list()
	for(var/pos_targ in GLOB.department_centers)
		var/possible_center_distance = get_dist(src, pos_targ)
		if(possible_center_distance > 4 && possible_center_distance < 46)
			potential_centers += pos_targ
	if(LAZYLEN(potential_centers))
		return get_turf(pick(potential_centers))

/*
* Modified big_wolf flee code. This creature focuses only on
* escaping, ignoring all hostiles and attacks for 1.5 seconds.
*/
/mob/living/simple_animal/hostile/better_memories_minion/proc/FleeNow(turf/target_dest)
	if(health < maxHealth * 0.2)
		return
	toggle_ai(AI_OFF)
	walk_to(src, 0)
	TemporarySpeedChange(-1, 1.5 SECONDS)
	fleeing_now = TRUE
	target_memory.Cut()
	target = null
	//Eh whatever make them not instantly patrol again upon reaching their destination.
	patrol_cooldown = world.time + patrol_cooldown_time
	if(patrol_to(FleeDest()))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/hostile/better_memories_minion, StopFleeing)), 1.5 SECONDS)
		return
	StopFleeing()

/mob/living/simple_animal/hostile/better_memories_minion/proc/StopFleeing()
	fleeing_now = FALSE
	toggle_ai(AI_ON)

//This proc is for preventing the camera from firing at a target that is in its blind spot.
/mob/living/simple_animal/hostile/better_memories_minion/proc/AngleCamera(atom/cam_focus)
	switch(Get_Angle(src, cam_focus))
		//North 0 angle
		if(340 to 360)
			return TRUE
		if(0 to 20)
			return TRUE
		//South 180 angle
		if(160 to 200)
			return TRUE
		//East 90 angle
		if(70 to 110)
			return TRUE
		//West 270 angle
		if(250 to 290)
			return TRUE

	/*Attack code stolen from cone_spells.dm
	This proc creates a list of turfs that are hit by the cone */
/mob/living/simple_animal/hostile/better_memories_minion/proc/CameraFlash(mob/living/user)
	var/blind_direction
	if(client)
		blind_direction = user.dir
	else
		blind_direction = get_cardinal_dir(get_turf(src), get_turf(target))
	var/list/cone_turfs = ConeHelper(get_turf(user), blind_direction)
	for(var/list/turf_list in cone_turfs)
		DoConeEffects(turf_list, user, TRUE)

	playsound(loc, 'sound/weapons/armbomb.ogg', 75, TRUE, -3)
	if(do_after(user, 1.5 SECONDS, target = user))
		for(var/list/turf_list in cone_turfs)
			DoConeEffects(turf_list, user, FALSE)
		playsound(loc, 'sound/effects/pop_expl.ogg', 75, TRUE, -3)

/mob/living/simple_animal/hostile/better_memories_minion/proc/ConeHelper(turf/starter_turf, dir_to_use, cone_levels = CAMERAFLASH_RANGE)
	var/list/turfs_to_return = list()
	var/turf/turf_to_use = starter_turf
	var/turf/left_turf
	var/turf/right_turf
	var/right_dir
	var/left_dir
	switch(dir_to_use)
		if(NORTH)
			left_dir = WEST
			right_dir = EAST
		if(SOUTH)
			left_dir = EAST
			right_dir = WEST
		if(EAST)
			left_dir = NORTH
			right_dir = SOUTH
		if(WEST)
			left_dir = SOUTH
			right_dir = NORTH

	for(var/i in 1 to cone_levels)
		if(i == 1)
			continue
		var/list/level_turfs = list()
		turf_to_use = get_step(turf_to_use, dir_to_use)
		level_turfs += turf_to_use
		if(i != 1)
			left_turf = get_step(turf_to_use, left_dir)
			level_turfs += left_turf
			right_turf = get_step(turf_to_use, right_dir)
			level_turfs += right_turf
			for(var/left_i in 1 to i -CalculateConeShape(i))
				if(left_turf.density)
					break
				left_turf = get_step(left_turf, left_dir)
				level_turfs += left_turf
			for(var/right_i in 1 to i -CalculateConeShape(i))
				if(right_turf.density)
					break
				right_turf = get_step(right_turf, right_dir)
				level_turfs += right_turf
		turfs_to_return += list(level_turfs)
		if(i == cone_levels)
			continue
		if(turf_to_use.density)
			break
	return turfs_to_return

	///This proc does obj, mob and turf cone effects on all targets in a list
/mob/living/simple_animal/hostile/better_memories_minion/proc/DoConeEffects(list/target_turf_list, mob/user, telegraph)
	for(var/target_turf in target_turf_list)
		//if turf is no longer there
		if(!target_turf)
			continue
		if(telegraph)
			DoConeTurfEffects(target_turf, 1)
		if(!telegraph)
			DoConeTurfEffects(target_turf, 2)
			if(isopenturf(target_turf))
				var/turf/open/open_turf = target_turf
				for(var/mob/living/movable_content in open_turf)
					if(isliving(movable_content))
						DoConeMobEffect(movable_content)

	///This proc deterimines how the spell will affect turfs.
/mob/living/simple_animal/hostile/better_memories_minion/proc/DoConeTurfEffects(turf/target_turf, type)
	if(type == 1)
		new /obj/effect/temp_visual/sparkles/purple(target_turf)
	if(type == 2)
		new /obj/effect/temp_visual/dir_setting/ninja/phase(target_turf)

	///This proc deterimines how the spell will affect mobs.
/mob/living/simple_animal/hostile/better_memories_minion/proc/DoConeMobEffect(mob/living/target_mob)
	if(ishuman(target_mob))
		target_mob.flash_act()
		target_mob.apply_status_effect(MEMORY_DEBUFF)

	///This proc adjusts the cones width depending on the level.
/mob/living/simple_animal/hostile/better_memories_minion/proc/CalculateConeShape(current_level)
	var/end_taper_start = round(CAMERAFLASH_RANGE * 0.8)
	if(current_level > end_taper_start)
		//someone more talented and probably come up with a better formula.
		return (current_level % end_taper_start) * 2
	else
		return 2

//Returns the location of a employee who is currently working.
/mob/living/simple_animal/hostile/better_memories_minion/proc/FindWorking()
	var/list/low_priority_turfs = list()
	var/list/medium_priority_turfs = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		var/turf/temp_turf_memory
		if(H.z != z)
			continue
		if(get_dist(src, H) < 8)
			continue
		if(H.stat == DEAD)
			continue
		if(H.has_status_effect(MEMORY_DEBUFF))
			continue
		if(H.is_working)
			if(get_dist(src, H) > 24) // Way too far
				temp_turf_memory = locate(H.x, H.y - 1, z)
				//Dont go to a turf someone is already going to
				if(temp_turf_memory in hunt_targets)
					continue
				low_priority_turfs += temp_turf_memory
				continue
			temp_turf_memory = locate(H.x, H.y - 1, z)
			//Dont go to a turf someone is already going to
			if(temp_turf_memory in hunt_targets)
				continue
			medium_priority_turfs += temp_turf_memory

	if(LAZYLEN(medium_priority_turfs))
		. = get_closest_atom(/turf/open, medium_priority_turfs, src)
	else if(LAZYLEN(low_priority_turfs))
		. = get_closest_atom(/turf/open, low_priority_turfs, src)

//Debuff Status Effect
/datum/status_effect/display/better_memories_curse
	id = "better_memories_curse"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	tick_interval = 50
	alert_type = null
	display_name = "down_arrow"

/datum/status_effect/display/better_memories_curse/on_apply()
	. = ..()
	var/mob/living/carbon/human/L = owner
	L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -30)
	L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -30)
	L.physiology.work_success_mod -= 0.25
	to_chat(owner, span_warning("You're distracted by memories of your past."))

/datum/status_effect/display/better_memories_curse/tick()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/L = owner
	if(L.sanity_lost || L.stat == DEAD)
		qdel(src)
	L.deal_damage(10, WHITE_DAMAGE)
	//Unsure if these statements explain what is happening to your character but its enough. -IP
	to_chat(owner, pick(
		span_warning("You have trouble recalling your life before this job."),
		span_warning("You forget your happiest moments."),
		span_warning("You wonder why your face is wet with tears."),
		span_warning("You try your best to hold onto the memory of your loved ones."),
		span_warning("You're forced to reminiscence on a happier time, then its gone."),
		))

/datum/status_effect/display/better_memories_curse/on_remove()
	var/mob/living/carbon/human/L = owner
	L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 30)
	L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 30)
	L.physiology.work_success_mod += 0.25
	return ..()

#undef MEMORY_DEBUFF
#undef CAMERAFLASH_RANGE
