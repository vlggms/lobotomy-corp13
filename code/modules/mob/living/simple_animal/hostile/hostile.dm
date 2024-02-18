#define MAX_DAMAGE_SUFFERED 250

/mob/living/simple_animal/hostile
	faction = list("hostile")
	stop_automated_movement_when_pulled = 0
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES //Bitflags. Set to ENVIRONMENT_SMASH_STRUCTURES to break closets,tables,racks, etc; ENVIRONMENT_SMASH_WALLS for walls; ENVIRONMENT_SMASH_RWALLS for rwalls
	var/atom/target
	var/ranged = FALSE
	var/rapid = 0 //How many shots per volley.
	var/rapid_fire_delay = 2 //Time between rapid fire shots

	var/dodging = FALSE
	var/approaching_target = FALSE //We should dodge now
	var/in_melee = FALSE	//We should sidestep now
	var/dodge_prob = 30
	var/sidestep_per_cycle = 1 //How many sidesteps per npcpool cycle when in melee

	var/projectiletype	//set ONLY it and NULLIFY casingtype var, if we have ONLY projectile
	var/projectilesound
	var/casingtype		//set ONLY it and NULLIFY projectiletype, if we have projectile IN CASING
	var/move_to_delay = 3 //delay for the automated movement.
	var/list/friends = list()
	var/list/emote_taunt = list()
	var/taunt_chance = 0

	var/rapid_melee = 1			 //Number of melee attacks between each npc pool tick. Spread evenly.
	var/melee_queue_distance = 4 //If target is close enough start preparing to hit them if we have rapid_melee enabled
	var/melee_reach = 1			 // The range at which a mob can make melee attacks

	var/ranged_message = "fires" //Fluff text for ranged mobs
	var/ranged_cooldown = 0 //What the current cooldown on ranged attacks is, generally world.time + ranged_cooldown_time
	var/ranged_cooldown_time = 30 //How long, in deciseconds, the cooldown of ranged attacks is
	var/ranged_ignores_vision = FALSE //if it'll fire ranged attacks even if it lacks vision on its target, only works with environment smash
	var/check_friendly_fire = 0 // Should the ranged mob check for friendlies when shooting
	var/retreat_distance = null //If our mob runs from players when they're too close, set in tile distance. By default, mobs do not retreat.
	var/minimum_distance = 1 //Minimum approach distance, so ranged mobs chase targets down, but still keep their distance set in tiles to the target, set higher to make mobs keep distance


//These vars are related to how mobs locate and target
	var/robust_searching = 0 //By default, mobs have a simple searching method, set this to 1 for the more scrutinous searching (stat_attack, stat_exclusive, etc), should be disabled on most mobs
	var/vision_range = 9 //How big of an area to search for targets in, a vision of 9 attempts to find targets as soon as they walk into screen view
	var/aggro_vision_range = 9 //If a mob is aggro, we search in this radius. Defaults to 9 to keep in line with original simple mob aggro radius
	var/search_objects = 0 //If we want to consider objects when searching around, set this to 1. If you want to search for objects while also ignoring mobs until hurt, set it to 2. To completely ignore mobs, even when attacked, set it to 3
	var/search_objects_timer_id //Timer for regaining our old search_objects value after being attacked
	var/search_objects_regain_time = 30 //the delay between being attacked and gaining our old search_objects value back
	var/list/wanted_objects = list() //A typecache of objects types that will be checked against to attack, should we have search_objects enabled
	///Mobs ignore mob/living targets with a stat lower than that of stat_attack. If set to DEAD, then they'll include corpses in their targets, if to HARD_CRIT they'll keep attacking until they kill, and so on.
	var/stat_attack = CONSCIOUS
	var/stat_exclusive = FALSE //Mobs with this set to TRUE will exclusively attack things defined by stat_attack, stat_attack DEAD means they will only attack corpses
	var/attack_same = 0 //Set us to 1 to allow us to attack our own faction
	var/atom/targets_from = null //all range/attack/etc. calculations should be done from this atom, defaults to the mob itself, useful for Vehicles and such
	var/attack_all_objects = FALSE //if true, equivalent to having a wanted_objects list containing ALL objects.
	var/lose_patience_timer_id //id for a timer to call LoseTarget(), used to stop mobs fixating on a target they can't reach
	var/lose_patience_timeout = 300 //30 seconds by default, so there's no major changes to AI behaviour, beyond actually bailing if stuck forever
	// Experimental Target Memory. Short term HATE. Things added to this list will have their accossiated values considered.
	var/list/target_memory = list()

	///When a target is found, will the mob attempt to charge at it's target?
	var/charger = FALSE
	///Tracks if the target is actively charging.
	var/charge_state = FALSE
	///In a charge, how many tiles will the charger travel?
	var/charge_distance = 3
	///How often can the charging mob actually charge? Effects the cooldown between charges.
	var/charge_frequency = 6 SECONDS
	///If the mob is charging, how long will it stun it's target on success, and itself on failure?
	var/knockdown_time = 3 SECONDS
	///Declares a cooldown for potential charges right off the bat.
	COOLDOWN_DECLARE(charge_cooldown)

	/// Patrol Code
	var/can_patrol = FALSE
	var/patrol_cooldown
	var/patrol_cooldown_time = 30 SECONDS
	var/list/patrol_path = list()
	var/patrol_tries = 0 //max of 5
	var/patrol_move_timer = null

/mob/living/simple_animal/hostile/Initialize()
	. = ..()

	if(!targets_from)
		targets_from = src
	/*Update Speed overrides set speed and sets it
		to the equivilent of move_to_delay. Basically
		move_to_delay - 2 = speed. */
	UpdateSpeed()
	wanted_objects = typecacheof(wanted_objects)

/mob/living/simple_animal/hostile/Destroy()
	targets_from = null
	return ..()

/mob/living/simple_animal/hostile/Life()
	. = ..()
	if(!.) //dead
		walk(src, 0) //stops walking
	if(!can_patrol || client)
		return
	if(target && length(patrol_path)) //if AI has acquired a target while on patrol, stop patrol
		patrol_reset()
		return
	if(CanStartPatrol())
		if(patrol_cooldown <= world.time)
			if(!patrol_path || !patrol_path.len)
				patrol_select()
				if(patrol_path.len)
					patrol_move(patrol_path[patrol_path.len])

	/*		AIStatus
	AI_ON will have the npcpool subsystem call handle_automated_action(),
	handle_automated_action(), and handle_automated_speech() one after another.
	AI_IDLE calls the creatures handle_automated_movement() and consider_wakeup()
	with a delay.
	Life() is called by the Mobs subsystem.
	*/
/mob/living/simple_animal/hostile/handle_automated_action()
	if(AIStatus == AI_OFF)
		return FALSE
	//we look around for potential targets and make it a list for later use.
	var/list/possible_targets = ListTargets()
	if(environment_smash)
		EscapeConfinement()

	if(AICanContinue(possible_targets))
		if(!QDELETED(target) && !targets_from.Adjacent(target))
			DestroyPathToTarget()
		if(!MoveToTarget(possible_targets))     //if we lose our target
			if(AIShouldSleep(possible_targets))	// we try to acquire a new one
				toggle_ai(AI_IDLE)			// otherwise we go idle
	return TRUE

/mob/living/simple_animal/hostile/handle_automated_movement()
	. = ..()
	if(dodging && target && in_melee && isturf(loc) && isturf(target.loc))
		var/datum/cb = CALLBACK(src, PROC_REF(sidestep))
		if(sidestep_per_cycle > 1) //For more than one just spread them equally - this could changed to some sensible distribution later
			var/sidestep_delay = SSnpcpool.wait / sidestep_per_cycle
			for(var/i in 1 to sidestep_per_cycle)
				addtimer(cb, (i - 1)*sidestep_delay)
		else //Otherwise randomize it to make the players guessing.
			addtimer(cb,rand(1,SSnpcpool.wait))

/mob/living/simple_animal/hostile/attacked_by(obj/item/I, mob/living/user)
	if(stat == CONSCIOUS && AIStatus != AI_OFF && !client && user)
		if(!target)
			FindTarget(list(user), 1)
		else
			var/add_aggro = 0
			var/add_damtype
			if(I)
				add_aggro = I.force
				add_damtype = I.damtype
			else
				add_aggro = user.melee_damage_upper
				if(isanimal(user))
					var/mob/living/simple_animal/A = user
					add_damtype = A.melee_damage_type
			RegisterAggroValue(user, add_aggro, add_damtype)
	return ..()

/mob/living/simple_animal/hostile/bullet_act(obj/projectile/P)
	if(stat == CONSCIOUS && AIStatus != AI_OFF && !client)
		if(!target)
			if(P.firer && get_dist(src, P.firer) <= aggro_vision_range)
				FindTarget(list(P.firer), 1)
			else
				Goto(P.starting, move_to_delay, 3)
		//If we have a target register the attacker in our memory.
		else
			if(P.firer)
				RegisterAggroValue(P.firer, P.damage, P.damage_type)
			//If the projectile had no firer then just list it as nobuddy
			if(!P.firer)
				if(target_memory["nobuddy"] > MAX_DAMAGE_SUFFERED)
					FindTarget()
			//If our damage value for that person exceeds this number then we consider targeting them.
			if(target_memory[P.firer] > MAX_DAMAGE_SUFFERED)
				FindTarget(list(P.firer), 1)
	return ..()

/mob/living/simple_animal/hostile/Move(atom/newloc, dir , step_x , step_y)
	if(dodging && approaching_target && prob(dodge_prob) && moving_diagonally == 0 && isturf(loc) && isturf(newloc))
		return dodge(newloc,dir)
	else
		return ..()

/mob/living/simple_animal/hostile/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return
	if(target == mover) // "I'm KILLING YOU, I'm KILLING YOU" - Jerma985
		return FALSE
	if(ishostile(mover))
		var/mob/living/simple_animal/hostile/H = mover
		if(H.target)
			return
		if(LAZYLEN(H.patrol_path)) // Don't block patrolling guys
			return TRUE
		return
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		if(H.sanity_lost) // Don't block crazy people
			return TRUE
	return

/mob/living/simple_animal/hostile/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(!ckey && !stat && search_objects < 3 && . > 0)//Not unconscious, and we don't ignore mobs
		if(search_objects)//Turn off item searching and ignore whatever item we were looking at, we're more concerned with fight or flight
			target = null
			LoseSearchObjects()
		if(AIStatus != AI_ON && AIStatus != AI_OFF)
			toggle_ai(AI_ON)
			FindTarget()
		else if(target != null && prob(40))//No more pulling a mob forever and having a second player attack it, it can switch targets now if it finds a more suitable one
			FindTarget()

/mob/living/simple_animal/hostile/death(gibbed)
	LoseTarget()
	..(gibbed)

/mob/living/simple_animal/hostile/update_stamina()
	. = ..()
	move_to_delay = (initial(move_to_delay) + (staminaloss * 0.06))
	UpdateSpeed()

/mob/living/simple_animal/hostile/proc/SpeedChange(amount = 0)
	move_to_delay += amount
	UpdateSpeed()

/mob/living/simple_animal/hostile/proc/TemporarySpeedChange(amount = 0, time = 0)
	if(time <= 0)
		return
	if(amount == 0)
		return
	SpeedChange(amount)
	addtimer(CALLBACK(src, PROC_REF(SpeedChange), -amount), time) // Reset the speed to previous value

/mob/living/simple_animal/hostile/attacked_by(obj/item/I, mob/living/user)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client && user)
		FindTarget(list(user), 1)
	return ..()

/mob/living/simple_animal/hostile/bullet_act(obj/projectile/P)
	if(stat == CONSCIOUS && !target && AIStatus != AI_OFF && !client)
		if(P.firer && get_dist(src, P.firer) <= aggro_vision_range)
			FindTarget(list(P.firer), 1)
		Goto(P.starting, move_to_delay, 3)

	. = ..()
	DamageEffect(P.damage, P.damage_type)

/*-------------------\
|Damage Visual Effect|
\-------------------*/

/mob/living/simple_animal/hostile/attack_threshold_check(damage, damagetype = BRUTE, armorcheck = MELEE, actuallydamage = TRUE)
	//This used to also check actually damage but turns out melee weapons in item_attack.dm dont call actually damage.
	if(stat != DEAD && (damagetype in list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)))
		//To simplify things, if you bash a abnormality with a wrench it wont show any effect.
		DamageEffect(damage, damagetype)
	return ..()

/mob/living/simple_animal/hostile/proc/DamageEffect(amount, damtype)
	//Code stolen from attack_threshold_check() in animal_defense.dm
	var/temp_damage = amount
	if(islist(damage_coeff))
		temp_damage *= damage_coeff[damtype]
	else
		temp_damage *= damage_coeff.getCoeff(damtype)

	if(temp_damage > 0)
		return FALSE
	if(temp_damage == 0)
		//Visual Effect for immunity.
		return new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
	if(temp_damage < 0)
		//Visual Effect for healing.
		return new /obj/effect/temp_visual/healing(get_turf(src))

/*Used in LC13 abnormality calculations.
	Moved here so we can use it for all hostiles.
	So this took me a while to figure out,
	player controlled mob speed is default
	2 when in running mode. The "speed" variable
	isnt actually adding it up from 0. Its a
	multiplication of a 1 that is added to the 2.
	move_to_delay is the lag in deciseconds. So
	to fix this the speed should be move_to_delay -2.
	Also this doesnt fix Stamina Update since it uses
	initial - IP*/
//Also is it frowned upon to make a proc just a single proc but with a unique var?
/mob/living/simple_animal/hostile/proc/UpdateSpeed()
	set_varspeed(move_to_delay - 2)

//////////////HOSTILE MOB TARGETTING AND AGGRESSION////////////

/mob/living/simple_animal/hostile/proc/ListTargets() //Step 1, find out what we can see
	if(!search_objects)
		. = hearers(vision_range, targets_from) - src //Remove self, so we don't suicide

		var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/vehicle/sealed/mecha))

		for(var/HM in typecache_filter_list(range(vision_range, targets_from), hostile_machines))
			if(can_see(targets_from, HM, vision_range))
				. += HM
	else
		. = oview(vision_range, targets_from)

/mob/living/simple_animal/hostile/proc/ListTargetsLazy(_Z)
	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/vehicle/sealed/mecha))
	. = list()
	for (var/I in SSmobs.clients_by_zlevel[_Z])
		var/mob/M = I
		if (get_dist(M, src) < vision_range)
			if (isturf(M.loc))
				. += M
			else if (M.loc.type in hostile_machines)
				. += M.loc

/* ListTargets() is the radar ping that gets all creatures or things around us.
	It is called routinely by handle_automated_action(). FindTarget() uses
	this proc if it has no preset list in its proc.*/

/mob/living/simple_animal/hostile/proc/FindTarget(list/possible_targets, HasTargetsList = 0)//Step 2, filter down possible targets to things we actually care about
	. = list()
	if(!HasTargetsList)
		possible_targets = ListTargets()
	for(var/pos_targ in possible_targets)
		var/atom/A = pos_targ
		if(Found(A))//Just in case people want to override targetting
			. = list(A)
			break
		if(CanAttack(A))//Can we attack it?
			. += A
			continue
	if(!LAZYLEN(.))
		return null
	var/Target = PickTarget(.)
	GiveTarget(Target)
	return Target //We now have a target

/* Essentially is the middle part of FindTarget
	but returns only a list without giving a target.*/
/mob/living/simple_animal/hostile/proc/PossibleThreats()
	. = list()
	for(var/pos_targ in ListTargets())
		var/atom/A = pos_targ
		if(Found(A))
			. = list(A)
			break
		if(CanAttack(A))
			. += A
			continue

/* Returning True on this proc means
	that only this target is listed and
	nothing more is considered. */
/mob/living/simple_animal/hostile/proc/Found(atom/A)
	return

/* If Found() does not return TRUE then this will be
	used to sort out what we can attack. Its encouraged
	that you override this for your mob instead of making
	niche conditions. In some cases using Found() will suffice.*/
/mob/living/simple_animal/hostile/CanAttack(atom/the_target)
	if(isturf(the_target) || !the_target || the_target.type == /atom/movable/lighting_object)
		// bail out on invalids
		return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE
		if(M.ckey)
			if(M.client?.is_afk()) // AFK protection
				return FALSE

	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE
	if(search_objects < 2)
		if(isliving(the_target))
			var/mob/living/L = the_target
			if(!L.CanBeAttacked(src))
				return FALSE

			var/faction_check = faction_check_mob(L)
			if(robust_searching)
				if(faction_check && !attack_same)
					return FALSE
				if(L.stat > stat_attack)
					return FALSE
				if(L in friends)
					return FALSE
			else
				if((faction_check && !attack_same) || L.stat)
					return FALSE
			return TRUE

		if(ismecha(the_target))
			var/obj/vehicle/sealed/mecha/M = the_target
			for(var/occupant in M.occupants)
				if(CanAttack(occupant))
					return TRUE

		if(istype(the_target, /obj/machinery/porta_turret))
			var/obj/machinery/porta_turret/P = the_target
			if(P.in_faction(src)) //Don't attack if the turret is in the same faction
				return FALSE
			if(P.has_cover &&!P.raised) //Don't attack invincible turrets
				return FALSE
			if(P.machine_stat & BROKEN) //Or turrets that are already broken
				return FALSE
			return TRUE

	if(isobj(the_target))
		if(attack_all_objects || is_type_in_typecache(the_target, wanted_objects))
			return TRUE

	return FALSE

/*--------------\
|Value Targeting|
\--------------*/

/* Pick Target is called after we sort
	through the things we can actually attack.*/
/mob/living/simple_animal/hostile/proc/PickTarget(list/Targets)

	/* Default to normal targeting if we only have 1 target.
		This may be changed in the future if we want to still
		value them to see if we even care about attacking. */
	if(Targets.len == 1)
		return pick(Targets)

	/* Form a list of our targets, value how much we hate
		them, and then pick the target who has the MOST hate. */
	for(var/i in Targets)
		Targets[i] = ValueTarget(i)

	. = ReturnHighestValue(Targets)

	/* If we have a target do we continue
		fighting if asked to pick again? */
	if(target)
		if(KeepTargetCondition(target, .))
			return target

/mob/living/simple_animal/hostile/proc/KeepTargetCondition(atom/old_target, atom/new_target)
	if(!new_target)
		return TRUE
	/* If new target value is more
		than our current target.*/
	if(old_target)
		if(ValueTarget(old_target) > ValueTarget(new_target))
			return TRUE

// Adds entity to THE LIST OF GRUDGES which is reset upon gaining a new target.
/mob/living/simple_animal/hostile/proc/RegisterAggroValue(atom/remembered_target, value, damage_type)
	if(!remembered_target)
		remembered_target = "nobody"
	if(!target_memory[remembered_target])
		target_memory += remembered_target
	if(damage_type)
		value *= damage_coeff.getCoeff(damage_type)
	target_memory[remembered_target] += value

/*-------------------\
|Standard Hate Levels|
|--------------------/
|Living Adjacent = 80
|Living Far = 30
|Other Adjacent = 0
|Other Far = -50
\-------------------*/
/mob/living/simple_animal/hostile/proc/ValueTarget(atom/target_thing)
	if(!target_thing)
		return
	//This is a safety net just in the case that no value is returned.
	. = 0

	//If your farther than 5 tiles from us you suffer the max 50 of hate penalty.
	. -= clamp(get_dist(targets_from, target_thing) * 10,0,50)

	//This is in order to make mobs not instantly reaggro on mobs they lost patience on.
	if(isnum(target_memory[target_thing]))
		. -= (target_memory[target_thing] / 10)

	/* This is in order to treat Mechas as living by
		instead considering their pilot for the hate value. */
	if(ismecha(target_thing))
		var/obj/vehicle/sealed/mecha/M = target_thing
		for(var/occupant in M.occupants)
			if(isliving(occupant) && CanAttack(occupant))
				. += 80

	if(isliving(target_thing))
		//Minimum starting hate for anything living is 80.
		. += 80

/mob/living/simple_animal/hostile/proc/GiveTarget(new_target)
	target = new_target
	LosePatience()
	if(target != null)
		GainPatience()
		Aggro()
		return 1

/mob/living/simple_animal/hostile/proc/LoseTarget()
	if(target_memory.len > 1)
		target_memory.Cut()
	target = null
	approaching_target = FALSE
	in_melee = FALSE
	walk(src, 0)
	LoseAggro()

/mob/living/simple_animal/hostile/proc/Aggro()
	vision_range = aggro_vision_range
	if(target && emote_taunt.len && prob(taunt_chance))
		manual_emote("[pick(emote_taunt)] at [target].")
		taunt_chance = max(taunt_chance-7,2)

/mob/living/simple_animal/hostile/proc/LoseAggro()
	stop_automated_movement = 0
	vision_range = initial(vision_range)
	taunt_chance = initial(taunt_chance)

//What we do after closing in
/mob/living/simple_animal/hostile/proc/MeleeAction(patience = TRUE)
	if(rapid_melee > 1)
		var/datum/callback/cb = CALLBACK(src, PROC_REF(CheckAndAttack))
		var/delay = SSnpcpool.wait / rapid_melee
		for(var/i in 1 to rapid_melee)
			addtimer(cb, (i - 1)*delay)
	else
		AttackingTarget()
	if(patience)
		GainPatience()

/mob/living/simple_animal/hostile/proc/CheckAndAttack()
	if(!target)
		return FALSE
	var/in_range = melee_reach > 1 ? target.Adjacent(targets_from) || (get_dist(src, target) <= melee_reach && (target in view(src, melee_reach))) : target.Adjacent(targets_from)
	if(targets_from && isturf(targets_from.loc) && in_range && !incapacitated())
		AttackingTarget()
		return TRUE
	return FALSE

	// Called by automated_action and causes the AI to go idle if it returns false. This proc is pretty big.
/mob/living/simple_animal/hostile/proc/MoveToTarget(list/possible_targets)
	stop_automated_movement = 1
	/*Stop automated movement is only used for wander code.
		The two checks after this are if we dont have a
		target and if we are currently moving towards a
		target and they suddenly or are currently something
		we dont attack.*/
	if(!target)
		if(approaching_target)
			/* Approaching target means we are currently moving menacingly
				towards something. Otherwise we are just moving and if we
				are investigating a location we dont want to be told to stand still. */
			LoseTarget()
		return FALSE
	if(!CanAttack(target))
		LoseTarget()
		return FALSE
	// The target we currently have is in our view and we must decide if we move towards it more.
	if(target in possible_targets)
		var/turf/T = get_turf(src)
		if(target.z != T.z)
			//Target is not on our Z level. How? I dont know?
			LoseTarget()
			return FALSE
		var/target_distance = get_dist(targets_from,target)
		var/in_range = melee_reach > 1 ? target.Adjacent(targets_from) || (get_dist(src, target) <= melee_reach && (target in view(src, melee_reach))) : target.Adjacent(targets_from)
		if(ranged) //We ranged? Shoot at em
			if(!in_range && ranged_cooldown <= world.time)
				//But make sure they're not in range for a melee attack and our range attack is off cooldown
				OpenFire(target)

		//This is consideration for chargers. If you are not a charger you can skip this.
		if(charger && (target_distance > minimum_distance) && (target_distance <= charge_distance))
			//Attempt to close the distance with a charge.
			enter_charge(target)
			return TRUE

		if(!Process_Spacemove()) //Drifting
			walk(src,0)
			return TRUE
		if(retreat_distance != null)
			//If we have a retreat distance, check if we need to run from our target
			if(target_distance <= retreat_distance)
				//If target's closer than our retreat distance, run
				walk_away(src,target,retreat_distance,move_to_delay)
			else
				Goto(target,move_to_delay,minimum_distance)
				//Otherwise, get to our minimum distance so we chase them
		else
			Goto(target,move_to_delay,minimum_distance)

		//This is for attacking.
		if(target)
			if(targets_from && isturf(targets_from.loc) && in_range)
				//If they're next to us, attack
				MeleeAction()
			else
				if(rapid_melee > 1 && target_distance <= melee_queue_distance)
					MeleeAction(FALSE)
				in_melee = FALSE //If we're just preparing to strike do not enter sidestep mode
			return TRUE
		return FALSE

	//Smashing code
	if(environment_smash)
		if(target.loc != null && get_dist(targets_from, target.loc) <= vision_range) //We can't see our target, but he's in our vision range still
			if(ranged_ignores_vision && ranged_cooldown <= world.time) //we can't see our target... but we can fire at them!
				OpenFire(target)
			if((environment_smash & ENVIRONMENT_SMASH_WALLS) || (environment_smash & ENVIRONMENT_SMASH_RWALLS)) //If we're capable of smashing through walls, forget about vision completely after finding our target
				Goto(target,move_to_delay,minimum_distance)
				FindHidden()
				return TRUE
			else
				if(FindHidden())
					return TRUE
	LoseTarget()
	return FALSE

//Functionally this proc is a simplier version of the core code walk_to().
/mob/living/simple_animal/hostile/proc/Goto(target, delay, minimum_distance)
	if(target == src.target)
		approaching_target = TRUE
	else
		approaching_target = FALSE
	walk_to(src, target, minimum_distance, delay)

/mob/living/simple_animal/hostile/proc/AttackingTarget(atom/attacked_target)
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	if(ismob(target))
		changeNext_move(SSnpcpool.wait / rapid_melee)
		// Wow! that's a really weird variable to base attack speed on! Yes.
		// It's because mobs typically attack once per this duration, because the subsystem calls handle_automated_movement() which then calls the attacking procs.
	return target.attack_animal(src)

//////////////END HOSTILE MOB TARGETTING AND AGGRESSION////////////

//Player firing and Player reach melee handling
/mob/living/simple_animal/hostile/RangedAttack(atom/A, params)
	. = ..()
	if(!client)
		return
	target = A
	if(CheckAndAttack(A))
		return
	if(ranged && ranged_cooldown <= world.time)
		OpenFire(A)
	return

/mob/living/simple_animal/hostile/proc/OpenFire(atom/A)
	if(CheckFriendlyFire(A))
		return
	if(!(simple_mob_flags & SILENCE_RANGED_MESSAGE))
		visible_message(span_danger("<b>[src]</b> [ranged_message] at [A]!"))


	if(rapid > 1)
		var/datum/callback/cb = CALLBACK(src, PROC_REF(Shoot), A)
		for(var/i in 1 to rapid)
			addtimer(cb, (i - 1)*rapid_fire_delay)
	else
		Shoot(A)
	ranged_cooldown = world.time + ranged_cooldown_time


/mob/living/simple_animal/hostile/proc/Shoot(atom/targeted_atom)
	if(QDELETED(targeted_atom) || targeted_atom == targets_from.loc || targeted_atom == targets_from )
		return
	if(QDELETED(targets_from) || stat == DEAD)
		return
	var/turf/startloc = get_turf(targets_from)
	if(casingtype)
		var/obj/item/ammo_casing/casing = new casingtype(startloc)
		playsound(src, projectilesound, 100, TRUE)
		casing.fire_casing(targeted_atom, src, null, null, null, ran_zone(), 0,  src)
	else if(projectiletype)
		var/obj/projectile/P = new projectiletype(startloc)
		playsound(src, projectilesound, 100, TRUE)
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.yo = targeted_atom.y - startloc.y
		P.xo = targeted_atom.x - startloc.x
		if(AIStatus != AI_ON)//Don't want mindless mobs to have their movement screwed up firing in space
			newtonian_move(get_dir(targeted_atom, targets_from))
		P.original = targeted_atom
		P.preparePixelProjectile(targeted_atom, src)
		P.fire()
		return P

/mob/living/simple_animal/hostile/proc/CheckFriendlyFire(atom/A)
	if(check_friendly_fire)
		for(var/turf/T in getline(src,A)) // Not 100% reliable but this is faster than simulating actual trajectory
			for(var/mob/living/L in T)
				if(L == src || L == A)
					continue
				if(faction_check_mob(L) && !attack_same)
					return TRUE

	/*-------------\
	|TURF/OBJ PROCS|
	\-------------*/

/mob/living/simple_animal/hostile/proc/DestroyObjectsInDirection(direction)
	var/turf/T = get_step(targets_from, direction)
	if(QDELETED(T))
		return
	if(T.Adjacent(targets_from))
		if(CanSmashTurfs(T))
			T.attack_animal(src)
			return
	for(var/obj/O in T.contents)
		if(!O.Adjacent(targets_from))
			continue
		if(IsSmashable(O))
			O.attack_animal(src)
			return

/mob/living/simple_animal/hostile/proc/CanSmashTurfs(turf/T)
	return iswallturf(T) || ismineralturf(T)

/mob/living/simple_animal/hostile/proc/IsSmashable(obj/O)
	if(ismecha(O) || ismachinery(O) || isstructure(O))
		if(O.resistance_flags & INDESTRUCTIBLE)
			return FALSE
		if(!O.density)
			return FALSE
		if(environment_smash < ENVIRONMENT_SMASH_STRUCTURES)
			return FALSE
		if(O.IsObscured())
			return FALSE
		return TRUE

/mob/living/simple_animal/hostile/proc/DestroyPathToTarget()
	if(environment_smash)
		EscapeConfinement()
		var/dir_to_target = get_dir(targets_from, target)
		var/dir_list = list()
		if(ISDIAGONALDIR(dir_to_target)) //it's diagonal, so we need two directions to hit
			for(var/direction in GLOB.cardinals)
				if(direction & dir_to_target)
					dir_list += direction
		else
			dir_list += dir_to_target
		for(var/direction in dir_list) //now we hit all of the directions we got in this fashion, since it's the only directions we should actually need
			DestroyObjectsInDirection(direction)

// for use with megafauna destroying everything around them
/mob/living/simple_animal/hostile/proc/DestroySurroundings()
	if(environment_smash)
		EscapeConfinement()
		for(var/dir in GLOB.cardinals)
			DestroyObjectsInDirection(dir)


/mob/living/simple_animal/hostile/proc/EscapeConfinement()
	if(buckled)
		buckled.attack_animal(src)
	if(!isturf(targets_from.loc) && targets_from.loc != null)//Did someone put us in something?
		var/atom/A = targets_from.loc
		A.attack_animal(src)//Bang on it till we get out


/mob/living/simple_animal/hostile/proc/FindHidden()
	if(isnull(target))
		return FALSE
	if(istype(target.loc, /obj/structure/closet) || istype(target.loc, /obj/machinery/disposal) || istype(target.loc, /obj/machinery/sleeper))
		var/atom/A = target.loc
		Goto(A,move_to_delay,minimum_distance)
		if(A.Adjacent(targets_from))
			A.attack_animal(src)
		return TRUE

	/*--------\
	|AI STATUS|
	\--------*/

/mob/living/simple_animal/hostile/consider_wakeup()
	..()
	var/list/tlist
	var/turf/T = get_turf(src)

	if (!T)
		return

	if (!length(SSmobs.clients_by_zlevel[T.z])) // It's fine to use .len here but doesn't compile on 511
		toggle_ai(AI_Z_OFF)
		return

	var/cheap_search = isturf(T) && !is_station_level(T.z)
	if (cheap_search)
		tlist = ListTargetsLazy(T.z)
	else
		tlist = ListTargets()

	if((AIStatus == AI_IDLE || AIStatus == AI_Z_OFF) && FindTarget(tlist, 1))
		if(cheap_search) //Try again with full effort
			FindTarget()
		toggle_ai(AI_ON)

/mob/living/simple_animal/hostile/proc/AICanContinue(list/possible_targets)
	switch(AIStatus)
		if(AI_ON)
			. = 1
		if(AI_IDLE)
			if(FindTarget(possible_targets, 1))
				. = 1
				toggle_ai(AI_ON) //Wake up for more than one Life() cycle.
			else
				. = 0

/mob/living/simple_animal/hostile/proc/AIShouldSleep(list/possible_targets)
	return !FindTarget(possible_targets, 1)

/* These two procs handle losing our target if we've failed to attack them for
	more than lose_patience_timeout deciseconds, which probably means we're stuck */

/mob/living/simple_animal/hostile/proc/GainPatience()
	if(lose_patience_timeout)
		LosePatience()
		lose_patience_timer_id = addtimer(CALLBACK(src, PROC_REF(LoseTarget)), lose_patience_timeout, TIMER_STOPPABLE)


/mob/living/simple_animal/hostile/proc/LosePatience()
	deltimer(lose_patience_timer_id)


//These two procs handle losing and regaining search_objects when attacked by a mob
/mob/living/simple_animal/hostile/proc/LoseSearchObjects()
	search_objects = 0
	deltimer(search_objects_timer_id)
	search_objects_timer_id = addtimer(CALLBACK(src, PROC_REF(RegainSearchObjects)), search_objects_regain_time, TIMER_STOPPABLE)


/mob/living/simple_animal/hostile/proc/RegainSearchObjects(value)
	if(!value)
		value = initial(search_objects)
	search_objects = value

	/*------------------\
	|UNCATAGORIZED PROCS|
	\------------------*/

/mob/living/simple_animal/hostile/tamed(whomst)
	. = ..()
	if(isliving(whomst) && !locate(whomst) in friends)
		var/mob/living/fren = whomst
		friends += fren
		faction = fren.faction.Copy()

/mob/living/simple_animal/hostile/proc/summon_backup(distance, exact_faction_match)
	do_alert_animation()
	playsound(loc, 'sound/machines/chime.ogg', 50, TRUE, -1)
	for(var/mob/living/simple_animal/hostile/M in oview(distance, targets_from))
		if(faction_check_mob(M, TRUE))
			if(M.AIStatus == AI_OFF)
				continue
			else
				M.Goto(src,M.move_to_delay,M.minimum_distance)

/mob/living/simple_animal/hostile/proc/dodge(moving_to,move_direction)
	//Assuming we move towards the target we want to swerve toward them to get closer
	var/cdir = turn(move_direction,45)
	var/ccdir = turn(move_direction,-45)
	dodging = FALSE
	. = Move(get_step(loc,pick(cdir,ccdir)))
	if(!.)//Can't dodge there so we just carry on
		. =  Move(moving_to,move_direction)
	dodging = TRUE

/mob/living/simple_animal/hostile/proc/sidestep()
	if(!target || !isturf(target.loc) || !isturf(loc) || stat == DEAD)
		return
	var/target_dir = get_dir(src,target)

	var/static/list/cardinal_sidestep_directions = list(-90,-45,0,45,90)
	var/static/list/diagonal_sidestep_directions = list(-45,0,45)
	var/chosen_dir = 0
	if (target_dir & (target_dir - 1))
		chosen_dir = pick(diagonal_sidestep_directions)
	else
		chosen_dir = pick(cardinal_sidestep_directions)
	if(chosen_dir)
		chosen_dir = turn(target_dir,chosen_dir)
		Move(get_step(src,chosen_dir))
		face_atom(target) //Looks better if they keep looking at you when dodging

	/*------------\
	|CHARGING CODE|
	\------------*/
/**
 * Proc that handles a charge attack windup for a mob.
 */
/mob/living/simple_animal/hostile/proc/enter_charge(atom/target)
	if(charge_state || body_position == LYING_DOWN || HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return FALSE

	if(!(COOLDOWN_FINISHED(src, charge_cooldown)) || !has_gravity() || !target.has_gravity())
		return FALSE
	Shake(15, 15, 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(handle_charge_target), target), 1.5 SECONDS, TIMER_STOPPABLE)

/**
 * Proc that throws the mob at the target after the windup.
 */
/mob/living/simple_animal/hostile/proc/handle_charge_target(atom/target)
	charge_state = TRUE
	throw_at(target, charge_distance, 1, src, FALSE, TRUE, callback = CALLBACK(src, PROC_REF(charge_end)))
	COOLDOWN_START(src, charge_cooldown, charge_frequency)
	return TRUE

/**
 * Proc that handles a charge attack after it's concluded.
 */
/mob/living/simple_animal/hostile/proc/charge_end()
	charge_state = FALSE

/**
 * Proc that handles the charge impact of the charging mob.
 */
/mob/living/simple_animal/hostile/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!charge_state)
		return ..()

	if(hit_atom)
		if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			var/blocked = FALSE
			if(ishuman(hit_atom))
				var/mob/living/carbon/human/H = hit_atom
				if(H.check_shields(src, 0, "the [name]", attack_type = LEAP_ATTACK))
					blocked = TRUE
			if(!blocked)
				L.visible_message(span_danger("[src] charges on [L]!"), span_userdanger("[src] charges into you!"))
				L.Knockdown(knockdown_time)
			else
				Stun((knockdown_time * 2), ignore_canstun = TRUE)
			charge_end()
		else if(hit_atom.density && !hit_atom.CanPass(src))
			visible_message(span_danger("[src] smashes into [hit_atom]!"))
			Stun((knockdown_time * 2), ignore_canstun = TRUE)

		if(charge_state)
			charge_state = FALSE
			update_icons()

////// Patrol Code ///////
/mob/living/simple_animal/hostile/proc/CanStartPatrol()
	return AIStatus == AI_IDLE //if AI is idle, begin checking for patrol

/mob/living/simple_animal/hostile/proc/patrol_to(turf/target_location = null)
	if(isnull(target_location)) // Sets a preset location for them to go to
		return FALSE
	patrol_reset() // Stop your current patrol for this one
	patrol_path = get_path_to(src, target_location, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
	if(patrol_path.len <= 0)
		return FALSE
	patrol_move(patrol_path[patrol_path.len])
	return TRUE

/mob/living/simple_animal/hostile/proc/patrol_select()
	//Mobs should stay unpatroled on maps where they're intended to be possessed.
	if(SSmaptype.maptype in SSmaptype.autopossess)
		return
	if(!LAZYLEN(GLOB.department_centers))
		return

	var/turf/target_center
	var/list/potential_centers = list()
	for(var/pos_targ in GLOB.department_centers)
		var/possible_center_distance = get_dist(src, pos_targ)
		if(possible_center_distance > 4 && possible_center_distance < 46)
			potential_centers += pos_targ
	if(LAZYLEN(potential_centers))
		target_center = pick(potential_centers)
	else
		target_center = pick(GLOB.department_centers)
	SEND_SIGNAL(src, COMSIG_PATROL_START, src, target_center)
	SEND_GLOBAL_SIGNAL(src, COMSIG_GLOB_PATROL_START, src, target_center)
	patrol_path = get_path_to(src, target_center, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)

/mob/living/simple_animal/hostile/proc/patrol_reset()
	patrol_path = list()
	patrol_tries = 0
	stop_automated_movement = 0
	if(patrol_move_timer)
		deltimer(patrol_move_timer) // Calling this now stops the patrol guaranteed.
	patrol_cooldown = world.time + patrol_cooldown_time

/mob/living/simple_animal/hostile/proc/patrol_move(dest)
	if(client || target || status_flags & GODMODE)
		patrol_reset()
		return FALSE
	if(!dest || !patrol_path || !patrol_path.len) //A-star failed or a path/destination was not set.
		return FALSE
	if(health <= 0) // No more moving corpses.
		return FALSE
	stop_automated_movement = 1
	dest = get_turf(dest) //We must always compare turfs, so get the turf of the dest var if dest was originally something else.
	var/turf/last_node = get_turf(patrol_path[patrol_path.len]) //This is the turf at the end of the path, it should be equal to dest.
	if(get_turf(src) == dest) //We have arrived, no need to move again.
		return TRUE
	else if(dest != last_node) //The path should lead us to our given destination. If this is not true, we must stop.
		patrol_reset()
		return FALSE
	if(patrol_tries < 5)
		patrol_step(dest)
	else
		patrol_reset()
		return FALSE
	patrol_move_timer = addtimer(CALLBACK(src, PROC_REF(patrol_move), dest), move_to_delay, TIMER_STOPPABLE)
	return TRUE

/mob/living/simple_animal/hostile/proc/patrol_step(dest)
	if(client || target  || status_flags & GODMODE || !patrol_path || !patrol_path.len)
		return FALSE
	if(health <= 0) // No more moving corpses.
		return FALSE
	if(patrol_path.len > 1)
		step_towards(src, patrol_path[1])
		if(get_turf(src) == patrol_path[1]) //Successful move
			if(!patrol_path || !patrol_path.len)
				return
			patrol_path.Cut(1, 2)
			patrol_tries = 0
		else
			patrol_tries++
			return FALSE
	else if(patrol_path.len == 1)
		step_to(src, dest)
		patrol_reset()
	return TRUE

#undef MAX_DAMAGE_SUFFERED
