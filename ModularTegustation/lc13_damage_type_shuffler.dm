GLOBAL_DATUM_INIT(damage_type_shuffler, /datum/damage_type_shuffler, new /datum/damage_type_shuffler())

//How it works:
//since damage types are often hardcoded for various attacks, some weapons have damage switching features
//and very often apply_damage is being called directly with damage type passed as a constant
//damage type switcharoo happens inside apply_damage before any logic, weapons and mobs keep their original damage type vars
//For armor and damage_coeffs the switcharoo happens at armor datum initialization
//Usually when armor is being changed from code a brand new armor datum is created so it works out
//But any runtime changes to the mapping_defense wont affect existing armor.
//It is ensured that at most only 1 color maps into itself.
/datum/damage_type_shuffler
	var/is_enabled = FALSE
	///Maps (original damage type) => (new damage type), can be changed at any time.
	var/list/mapping_offense = list(RED_DAMAGE = RED_DAMAGE, WHITE_DAMAGE = WHITE_DAMAGE, BLACK_DAMAGE = BLACK_DAMAGE, PALE_DAMAGE = PALE_DAMAGE)
	///Gives (this color) => (that color)'s armor value, only applies when armor/damage_coeff datum is created.
	var/list/mapping_defense = list(RED_DAMAGE = RED_DAMAGE, WHITE_DAMAGE = WHITE_DAMAGE, BLACK_DAMAGE = BLACK_DAMAGE, PALE_DAMAGE = PALE_DAMAGE)
	var/list/reverse_mapping_defense = list(RED_DAMAGE = RED_DAMAGE, WHITE_DAMAGE = WHITE_DAMAGE, BLACK_DAMAGE = BLACK_DAMAGE, PALE_DAMAGE = PALE_DAMAGE)
	///If a non pale damage type became pale then all new pale damage will be multiplied by this for a lil bit of balance.
	var/pale_debuff = 0.75

/datum/damage_type_shuffler/New()
	. = ..()
	ReshuffleAll()

/datum/damage_type_shuffler/proc/Reshuffle(list/mapping)
	var/list/sources = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	var/list/targets = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	for(var/i in 1 to 3)
		MapNeverSelf(mapping, sources, targets)
	MapAllowSelf(mapping, sources, targets)

/datum/damage_type_shuffler/proc/MapNeverSelf(list/mapping, list/sources, list/targets)
	var/source = pick_n_take(sources)
	var/target = pick(targets - source)
	if(!source || !target)
		stack_trace("damage shuffler/MapNeverSelf: failed to map from [sources] to [targets].")
		return FALSE
	targets -= target
	mapping[source] = target
	return TRUE

/datum/damage_type_shuffler/proc/MapAllowSelf(list/mapping, list/sources, list/targets)
	var/source = pick_n_take(sources)
	var/target = pick_n_take(targets)
	if(!source || !target)
		stack_trace("damage shuffler/MapAllowSelf: failed to map from [sources] to [targets].")
		return FALSE
	mapping[source] = target
	return TRUE

/datum/damage_type_shuffler/proc/ReshuffleAll()
	Reshuffle(mapping_offense)
	Reshuffle(mapping_defense)
	for(var/mapping in mapping_defense)
		reverse_mapping_defense[mapping_defense[mapping]] = mapping

/proc/IsColorDamageType(damage_type)
	var/static/list/color_damage_types = list(RED_DAMAGE = TRUE, WHITE_DAMAGE = TRUE, BLACK_DAMAGE = TRUE, PALE_DAMAGE = TRUE)
	return color_damage_types[damage_type]
