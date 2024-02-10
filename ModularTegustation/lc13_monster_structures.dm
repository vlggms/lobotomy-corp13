	//Monster Nests: Wave Based Spawning and command -IP
/obj/structure/wave_spawner
	name = "malfunctioning refinery"
	desc = "Hovering over a obliterated refinery is a ominous red portal."
	icon = 'ModularTegustation/Teguicons/lc13_structures_48x48.dmi'
	icon_state = "den_refinery"
	density = TRUE
	anchored = TRUE
	pixel_x = -8
	base_pixel_x = -8
	pixel_y = -4
	base_pixel_y = -4
	max_integrity = 1000
	light_power = 3
	light_range = 1
	//Structure is resistant to White and Pale damage.
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 90, BLACK_DAMAGE = 40, PALE_DAMAGE = 90, BOMB = 0, FIRE = 50, ACID = 50)
	//Do we just send continous assaults without caring if the last assault is done.
	var/continuous_assault = FALSE
	//Cooldowns for procs.
	var/resume_cooldown = 0
	var/generate_wave_cooldown = 0
	var/generate_wave_cooldown_time = 5 SECONDS
	//Our assault target
	var/assault_target
	//Leader of the assault
	var/obj/effect/wave_commander/wave_leader
	//Max amount of mobs we can spawn
	var/max_existing_mobs = 30
	//Who did we spawn and check if they dont exist anymore.
	var/list/existing_mobs = list()
	//Faction our spawned creatures belong to
	var/list/faction = list("hostile")
	//Last wave of soldiers
	var/list/last_wave = list()
	//current wave of soldiers
	var/list/current_wave = list()
	//The wave order that wave_composition copies. The value of each type is how many are in each wave.
	var/list/wave_order = list(
		/mob/living/simple_animal/hostile/ordeal/steel_dawn = 6,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 2
		)
	var/list/wave_composition = list()

	//Varients
/obj/structure/wave_spawner/soda
	name = "unstable soda portal"
	desc = "A purple portal above a toppled soda vendor."
	icon_state = "den_wellcheers"
	wave_order = list(
		/mob/living/simple_animal/hostile/shrimp = 6,
		/mob/living/simple_animal/hostile/shrimp_soldier = 4
		)

/obj/structure/wave_spawner/garden
	name = "lush portal"
	desc = "These bushes and flowers encircle a portal."
	icon_state = "den_garden"
	wave_order = list(
		/mob/living/simple_animal/hostile/fairyswarm = 10
		)

/obj/structure/wave_spawner/dirt
	name = "dirt cave"
	desc = "A well lived in cave made of dirt."
	icon_state = "den_dirt"
	wave_order = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_noon = 6
		)

//Experimental So i dont have to use the procs all the time
/obj/structure/wave_spawner/Initialize()
	. = ..()
	if(!assault_target)
		GenerateAssaultTarget()
	BeginProcessing()

/obj/structure/wave_spawner/process(delta_time)
	//We dont have a assault target.
	if(!assault_target)
		return ..()
	if(existing_mobs.len > max_existing_mobs)
		CheckExisting()
		return
	if(last_wave.len && world.time >= resume_cooldown)
		ResumeAssault()
		resume_cooldown = world.time + (1 MINUTES)
		return
	if(world.time >= generate_wave_cooldown)
		GenerateWave()
		generate_wave_cooldown = world.time + generate_wave_cooldown_time
		return

//Hostile Mobs can move through it but players and bullets hit it.
/obj/structure/wave_spawner/CanAllowThrough(atom/movable/AM, turf/target)
	if(ishostile(AM))
		return TRUE
	..()

/obj/structure/wave_spawner/proc/BeginProcessing()
	START_PROCESSING(SSobj, src)

//For predetermining assault target.
/obj/structure/wave_spawner/proc/GenerateAssaultTarget()
	return

//Each Generation decreases the mobs value in the list by 1 and removes it from the list if it is empty.
//If the wave_composition is empty then it will send the wave out to their assault destination while the new wave is generated.
//If the last wave is still alive the second wave will remain where they are.
/obj/structure/wave_spawner/proc/GenerateWave()
	if(!wave_composition.len)
		if(assault_target)
			if(!continuous_assault && !LastWaveStatus())
				return FALSE
			return StartAssault(assault_target)
		return FALSE
	var/mob/living/W = pick(wave_composition)
	wave_composition[W] -= 1
	if(wave_composition[W] <= 0)
		wave_composition -= W
	return SpawnMob(W)

//Checks if the last wave is fully dead so that we can send in the next wave.
/obj/structure/wave_spawner/proc/LastWaveStatus()
	if(!last_wave.len)
		return TRUE
	for(var/i in last_wave)
		if(isnull(i))
			last_wave -= i
		if(ishostile(i))
			var/mob/living/simple_animal/hostile/H = i
			if(H.stat == DEAD)
				last_wave -= H

//Each time a mob is spawned it is added to current_wave.
/obj/structure/wave_spawner/proc/SpawnMob(mob/living/simple_animal/hostile/mobtype)
	var/mob/living/simple_animal/hostile/spawned_mob = new mobtype(pick(get_adjacent_open_turfs(src)))
	if(!wave_leader && LeaderQualifications(spawned_mob))
		wave_leader = spawned_mob
	current_wave += spawned_mob
	spawned_mob.faction = faction.Copy()
	visible_message("<span class='danger'>[spawned_mob] emerges from [src].</span>")

//Leader Modularization if you want to make only certain mobs leaders.
/obj/structure/wave_spawner/proc/LeaderQualifications(mob/living/simple_animal/hostile/recruit)
	if(!isliving(recruit))
		return FALSE
	if(recruit.stat == DEAD)
		return FALSE
	return TRUE

//Begin Assault and reset wave_composition for next wave.
/obj/structure/wave_spawner/proc/StartAssault(enemy_base)
	if(!enemy_base)
		return FALSE
	visible_message("<span class='danger'>[src] becomes brighter as more figures can be seen inside.</span>")
	wave_leader = new /obj/effect/wave_commander(pick(get_adjacent_open_turfs(src)))
	for(var/i in current_wave)
		if(isnull(i))
			current_wave -= i
		if(ishostile(i))
			var/mob/living/simple_animal/hostile/H = i
			if(H.stat == DEAD)
				current_wave -= H
				continue
			walk_to(H, wave_leader, rand(0,2), H.move_to_delay)
	wave_leader.DoPath(get_turf(enemy_base))
	wave_composition = LAZYCOPY(wave_order)
	last_wave = LAZYCOPY(current_wave)
	LAZYCLEARLIST(current_wave)

//Is our soldiers interrupted in their march and should we command them to go to the enemy again. This option should be used if continuous wave is not on.
/obj/structure/wave_spawner/proc/ResumeAssault()
	var/area/where_we_go = get_area(assault_target)
	for(var/mob/living/simple_animal/hostile/H in last_wave)
		if(get_area(H) != where_we_go && !H.target)
			H.patrol_to(get_turf(assault_target))

//Check how many of our spawned mobs still exist
/obj/structure/wave_spawner/proc/CheckExisting()
	for(var/mob/living/L in existing_mobs)
		if(isnull(L))
			existing_mobs -= L

//Invisible Effect only visible to ghosts. Uses a altered form of Hostile Patrol Code -IP
/obj/effect/wave_commander
	name = "wave commander"
	desc = "A incorporial force that leads a group of monsters."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "target_field"
	invisibility = 40
	var/move_tries = 0
	var/patrol_move_timer = 0
	var/list/our_path = list()

/obj/effect/wave_commander/proc/DoPath(turf/target_location = null)
	if(isnull(target_location))
		RemoveCommander()
		return FALSE
	our_path = get_path_to(src, target_location, /turf/proc/Distance_cardinal, 0, 200)
	if(our_path.len <= 0)
		RemoveCommander()
		return FALSE
	MoveInPath(our_path[our_path.len])
	return TRUE

/obj/effect/wave_commander/proc/MoveInPath(dest)
	if(!dest || !our_path || !our_path.len) //A-star failed or a path/destination was not set.
		RemoveCommander()
		return FALSE
	dest = get_turf(dest) //We must always compare turfs, so get the turf of the dest var if dest was originally something else.
	var/turf/last_node = get_turf(our_path[our_path.len]) //This is the turf at the end of the path, it should be equal to dest.
	if(get_turf(src) == dest) //We have arrived, no need to move again.
		return TRUE
	else if(dest != last_node) //The path should lead us to our given destination. If this is not true, we must stop.
		return FALSE
	if(move_tries < 5)
		StepInPath(dest)
	else
		RemoveCommander()
		return FALSE
	patrol_move_timer = addtimer(CALLBACK(src, .proc/MoveInPath, dest), 5, TIMER_STOPPABLE)
	return TRUE

/obj/effect/wave_commander/proc/StepInPath(dest)
	if(!our_path || !our_path.len)
		RemoveCommander()
		return FALSE
	if(our_path.len > 1)
		step_towards(src, our_path[1])
		if(get_turf(src) == our_path[1]) //Successful move
			if(!our_path || !our_path.len)
				return
			our_path.Cut(1, 2)
			move_tries = 0
		else
			move_tries++
			return FALSE
	else if(our_path.len == 1)
		RemoveCommander()
	return TRUE

/obj/effect/wave_commander/proc/RemoveCommander()
	if(patrol_move_timer)
		deltimer(patrol_move_timer)
	QDEL_IN(src, 5)
