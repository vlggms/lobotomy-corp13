//////////////////////////////////////////////
//                                          //
//           SYNDICATE INFILTRATORS         //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/infiltrator
	name = "Infiltrators"
	persistent = TRUE
	antag_flag = ROLE_INFILTRATOR
	antag_datum = /datum/antagonist/traitor/infiltrator
	minimum_required_age = 7
	restricted_roles = list("AI", "Cyborg", "Prisoner","Security Officer", "Warden", "Detective", "Head of Security", "Head of Personnel", "Captain")
	required_candidates = 1
	weight = 4
	cost = 10
	scaling_cost = 10
	requirements = list(10,10,10,10,10,10,10,10,10,10)
	antag_cap = list(1,1,1,1,2,2,2,2,3,3)

/datum/dynamic_ruleset/roundstart/infiltrator/pre_execute()
	. = ..()
	var/num_traitors = antag_cap[indice_pop] * (scaled_times + 1)
	for (var/i = 1 to num_traitors)
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.special_role = ROLE_INFILTRATOR
		M.mind.restricted_roles = restricted_roles
		GLOB.pre_setup_antags += M.mind
	return TRUE
