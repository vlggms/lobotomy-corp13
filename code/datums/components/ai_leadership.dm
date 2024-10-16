/* Component for AI leadership. Ai will leader
	other mobs of the listed type. */

/datum/component/ai_leadership
	dupe_mode = COMPONENT_DUPE_UNIQUE
	//Cooldowns for recruitment
	var/recruit_cooldown = 0
	var/recruit_delay = 1 SECONDS
	//Cooldowns for headcount
	var/headcount_cooldown = 0
	var/headcount_delay = 15 SECONDS
	//Amount of allowed followers
	var/unit_amount
	//If the team should only have a certain amount of type.
	var/unique_team
	//If followers will return to a base when disbanded
	var/return_to_fob
	//Allowed types of followers
	var/list/possible_followers = list()
	//This components current followers.
	var/list/followers = list()

/* This could use some improvement.
	Or a full on replacement. */
/datum/component/ai_leadership/Initialize(allowed_types, amount = 6, unique = FALSE, forwardbase = FALSE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	var/atom/L = parent

	return_to_fob = forwardbase
	unique_team = unique
	unit_amount = amount
	possible_followers += allowed_types

	SSmobcommander.AddLeader(L)
	ScanLocation()
	START_PROCESSING(SSdcs, src)

/datum/component/ai_leadership/RegisterWithParent()
	if(isliving(parent))
		RegisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_PARENT_QDELETING), PROC_REF(RemoveLeader))
		if(ishostile(parent))
			RegisterSignal(parent, COMSIG_PATROL_START, PROC_REF(HeadCount))

/datum/component/ai_leadership/UnregisterFromParent()
	if(isliving(parent))
		UnregisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_PARENT_QDELETING))
		if(ishostile(parent))
			UnregisterSignal(parent, COMSIG_PATROL_START)

//On death remove this component and disband their followers.
/datum/component/ai_leadership/proc/RemoveLeader()
	SIGNAL_HANDLER

	SSmobcommander.RemoveLeader(parent, followers)
	STOP_PROCESSING(SSdcs, src)
	qdel(src)

/datum/component/ai_leadership/process()
	//If not a hostile then it would not get a signal.
	if(!ishostile(parent) && world.time > headcount_cooldown && followers.len)
		HeadCount(parent)
	if(world.time > recruit_cooldown && followers.len < unit_amount)
		ScanLocation()

	/*-----------------------
	|~ Main Function Procs ~|
	-----------------------*/

/*Scan proc for leader. Originally this was a proc
	in the hostile found since their targeting
	system scans everything all the time. */
/datum/component/ai_leadership/proc/ScanLocation()
	for(var/mob/living/L in view(7, parent))
		if(followers.len >= unit_amount)
			break
		if(Recruitable(L))
			Recruit(L)
	recruit_cooldown = world.time + recruit_delay

/*Checks the group of creatures to see if anyone is missing.
	Anyone missing will be removed from the group so that
	another team can recruit them.*/
/datum/component/ai_leadership/proc/HeadCount(atom/U)
	if(world.time < headcount_cooldown || !followers.len)
		return
	var/turf/fob
	var/list/whosehere = list()
	followers = uniqueList(followers)

	for(var/mob/living/L in followers)
		if(L.stat != DEAD && !L.client && L.z == U.z && get_dist(U, L) < 10)
			whosehere += L

	var/list/absent_troops = difflist(followers, whosehere ,1)
	if(absent_troops.len)
		if(return_to_fob)
			//Only run this once.
			fob = get_turf(FindForwardBase())
		for(var/mob/living/S in absent_troops)
			Disband(S)
			if(ishostile(S))
				var/mob/living/simple_animal/hostile/R = S
				if(fob && R.stat != DEAD && !R.target)
					walk(R, 0)
					R.patrol_to(fob)
	headcount_cooldown = world.time + headcount_delay
	Regroup()

	/*---------------------
	|~ Follower Commands ~|
	---------------------*/

//Command follower to follow leader.
/datum/component/ai_leadership/proc/FollowLeader(mob/living/L)
	if(ishostile(parent))
		var/mob/living/simple_animal/hostile/H = parent
		walk_to(L, parent, 2, H.move_to_delay - 1.5)
	//Following Logic for carbons and hostiles.
	if(iscarbon(parent))
		var/mob/living/carbon/H = parent
		walk_to(L, parent, 2, H.cached_multiplicative_slowdown - 1.5)
	else if(ishostile(L))
		var/mob/living/simple_animal/hostile/R = L
		if(!R.target)
			walk_to(R, parent, 2, R.move_to_delay)
	else
		return FALSE
	return TRUE

//Orders all troops to follow the leader.
/datum/component/ai_leadership/proc/Regroup()
	for(var/i in followers)
		FollowLeader(i)

	/*-----------------
	|~ System Checks ~|
	-----------------*/

/*Determines if the creature is recruitable
	based on their current status and faction.*/
/datum/component/ai_leadership/proc/Recruitable(mob/living/L)
	//Are we at maximum followers
	if(followers.len >= unit_amount)
		return FALSE
	//Are they dead?
	if(L.stat == DEAD)
		return FALSE
	//Player controlled, they do not recognize our authroity.
	if(L.client)
		return FALSE
	//If we are a hostile do these checks
	if(ishostile(parent))
		var/mob/living/simple_animal/hostile/H = parent
		//Are they the same faction as us?
		if(!H.faction_check_mob(L))
			return FALSE
		//If they currently have a target let them finish up.
		if(H.target)
			return FALSE
	//Are they a type in our possible follower types?
	if(!CheckUnitType(possible_followers, L))
		return FALSE
	//If we only have the command capacity to command more than one of them.
	if(unique_team)
		if(!TeamCheck(L.type))
			return FALSE
	//Are they already a follower of another leader?
	if(FollowerCheck(L))
		return FALSE
	return TRUE

//Register recruit with the system
/datum/component/ai_leadership/proc/Recruit(mob/living/L)
	followers += L
	SSmobcommander.RecruitFollower(L)
	FollowLeader(L)

//Releases the recruit from our command
/datum/component/ai_leadership/proc/Disband(mob/living/L)
	followers -= L
	SSmobcommander.DismissFollower(L)

//Is the recruit already recruited in the system?
/datum/component/ai_leadership/proc/FollowerCheck(mob/living/recruit)
	if(SSmobcommander.FindRecruit(recruit))
		return TRUE
	return FALSE

//Check the type system
/datum/component/ai_leadership/proc/CheckUnitType(list/type_list, mob/living/unit_type)
	if(unit_type.type in type_list)
		return unit_type.type
	return FALSE

/* Checks if theres any room for this unit in the team.
	Possible followers is a list of essentially "typepath = 1"
	the 1 is the max amount of this follower we can have and
	the typepath is the type of creature. This proc essentially
	finds the input typepath in the list and checks how many of
	that creature we have. The purpose of this system is to avoid
	armies of 10 artillery when its supposed to be 1 artillery
	and 5 infantry.*/
/datum/component/ai_leadership/proc/TeamCheck(recruit_typepath)
	var/many_we_have = CountByTroopType(recruit_typepath)
	var/our_capacity = 0
	for(var/i in possible_followers)
		if(recruit_typepath == i)
			our_capacity = possible_followers[i]
			break
	if(many_we_have >= our_capacity )
		return FALSE
	return TRUE

/* Input: The typepath of the creature we are reviewing
	for recruitment.
	Output: How many of that creature we currently have
	in service.*/
/datum/component/ai_leadership/proc/CountByTroopType(mob_typepath)
	if(!mob_typepath)
		return 0
	var/counting_dudes = 0
	for(var/mob/living/dude in followers)
		if(dude.type == mob_typepath)
			counting_dudes++
	return counting_dudes

//Calculate a base to return to, usually is a department.
/datum/component/ai_leadership/proc/FindForwardBase()
	var/mob/living/L = parent
	var/turf/second_choice
	if(!GLOB.department_centers.len)
		return FALSE
	for(var/turf/T in GLOB.department_centers)
		if(T.z != L.z)
			continue
		second_choice = T
		if(istype(get_area(T), /area/department_main/command))
			return T
	return second_choice
