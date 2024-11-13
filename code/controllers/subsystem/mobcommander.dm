SUBSYSTEM_DEF(mobcommander)
	name = "Mob Commander"
	flags = SS_NO_FIRE | SS_NO_INIT
	var/list/leaders = list()
	var/list/follower_list = list()

//Called by component recruit
/datum/controller/subsystem/mobcommander/proc/RecruitFollower(follower)
	if(!follower)
		return FALSE
	LAZYADD(follower_list, follower)
	return TRUE

//Called when a follower is removed from component and list.
/datum/controller/subsystem/mobcommander/proc/DismissFollower(follower)
	if(!follower)
		return FALSE
	CheckLedger()
	LAZYREMOVE(follower_list, follower)
	return TRUE

//Registers leader into the system
/datum/controller/subsystem/mobcommander/proc/AddLeader(leader)
	if(LAZYFIND(leaders, leader))
		return FALSE
	CheckLedger()
	LAZYADD(leaders, leader)
	return TRUE

//Removes leader from the ledger
/datum/controller/subsystem/mobcommander/proc/RemoveLeader(leader, followers)
	CheckLedger()
	LAZYREMOVE(leaders, leader)
	for(var/minion in followers)
		DismissFollower(minion)

//Checks to find if recruit is already in the system
/datum/controller/subsystem/mobcommander/proc/FindRecruit(follower)
	if(LAZYFIND(follower_list, follower))
		return TRUE
	return FALSE

//Does technical fixes such as remove nulls and duplicates
/datum/controller/subsystem/mobcommander/proc/CheckLedger()
	//Remove duplicates.
	var/fixed_leader_list = uniqueList(leaders)
	var/fixed_follower_list = uniqueList(follower_list)
	//Replace list with a sorted fixed version.
	leaders = sortNames(fixed_leader_list)
	follower_list = sortNames(fixed_follower_list)
	//Remove nulls.
	listclearnulls(leaders)
	listclearnulls(follower_list)
