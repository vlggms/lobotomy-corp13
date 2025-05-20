GLOBAL_DATUM_INIT(damage_type_shuffler, /datum/damage_type_shuffler, new /datum/damage_type_shuffler())

//How it works:
//since damage types are often hardcoded for various attacks, some weapons have damage switching features
//and very often apply_damage is being called directly with damage type passed as a constant
//damage type switcharoo happens inside apply_damage before any logic, weapons and mobs keep their original damage type vars
//same with armor they keep original values but use mapped values when calculating damage for simple animals in adjust[Color] procs
//for humans in getArmor proc
//It is ensured that at most only 1 color maps into itself.
/datum/damage_type_shuffler
	var/is_enabled = FALSE
	///Maps (original damage type) => (new damage type).
	var/list/mapping_offense = list(RED_DAMAGE = RED_DAMAGE, WHITE_DAMAGE = WHITE_DAMAGE, BLACK_DAMAGE = BLACK_DAMAGE, PALE_DAMAGE = PALE_DAMAGE)
	///Gives (this color) => (that color)'s armor value.
	var/list/mapping_defense = list(RED_DAMAGE = RED_DAMAGE, WHITE_DAMAGE = WHITE_DAMAGE, BLACK_DAMAGE = BLACK_DAMAGE, PALE_DAMAGE = PALE_DAMAGE)
	///If a non pale damage type became pale then all new pale damage will be multiplied by this for a lil bit of balance.
	///If pale damage turned into non pale damage it will be divided by this value.
	var/pale_debuff = 0.55

/datum/damage_type_shuffler/New()
	. = ..()
	ReshuffleAll()

/datum/damage_type_shuffler/proc/Reshuffle(list/mapping)
	//Hard coding these is the best way I could figure out to get a uniform distribution of mappings.
	//all 17 possible mappings with up to 1 self mapped type.
	var/static/list/all_mappings = list(
		list(RED_DAMAGE = RED_DAMAGE, WHITE_DAMAGE = BLACK_DAMAGE, BLACK_DAMAGE = PALE_DAMAGE, PALE_DAMAGE = WHITE_DAMAGE),
		list(RED_DAMAGE = RED_DAMAGE, WHITE_DAMAGE = PALE_DAMAGE, BLACK_DAMAGE = WHITE_DAMAGE, PALE_DAMAGE = BLACK_DAMAGE),

		list(RED_DAMAGE = BLACK_DAMAGE, WHITE_DAMAGE = WHITE_DAMAGE, BLACK_DAMAGE = PALE_DAMAGE, PALE_DAMAGE = RED_DAMAGE),
		list(RED_DAMAGE = PALE_DAMAGE, WHITE_DAMAGE = WHITE_DAMAGE, BLACK_DAMAGE = RED_DAMAGE, PALE_DAMAGE = BLACK_DAMAGE),

		list(RED_DAMAGE = WHITE_DAMAGE, WHITE_DAMAGE = PALE_DAMAGE, BLACK_DAMAGE = BLACK_DAMAGE, PALE_DAMAGE = RED_DAMAGE),
		list(RED_DAMAGE = PALE_DAMAGE, WHITE_DAMAGE = RED_DAMAGE, BLACK_DAMAGE = BLACK_DAMAGE, PALE_DAMAGE = WHITE_DAMAGE),

		list(RED_DAMAGE = WHITE_DAMAGE, WHITE_DAMAGE = BLACK_DAMAGE, BLACK_DAMAGE = RED_DAMAGE, PALE_DAMAGE = PALE_DAMAGE),
		list(RED_DAMAGE = BLACK_DAMAGE, WHITE_DAMAGE = RED_DAMAGE, BLACK_DAMAGE = WHITE_DAMAGE, PALE_DAMAGE = PALE_DAMAGE),

		list(RED_DAMAGE = WHITE_DAMAGE, WHITE_DAMAGE = RED_DAMAGE, BLACK_DAMAGE = PALE_DAMAGE, PALE_DAMAGE = BLACK_DAMAGE),
		list(RED_DAMAGE = WHITE_DAMAGE, WHITE_DAMAGE = BLACK_DAMAGE, BLACK_DAMAGE = PALE_DAMAGE, PALE_DAMAGE = RED_DAMAGE),
		list(RED_DAMAGE = WHITE_DAMAGE, WHITE_DAMAGE = PALE_DAMAGE, BLACK_DAMAGE = RED_DAMAGE, PALE_DAMAGE = BLACK_DAMAGE),

		list(RED_DAMAGE = BLACK_DAMAGE, WHITE_DAMAGE = RED_DAMAGE, BLACK_DAMAGE = PALE_DAMAGE, PALE_DAMAGE = WHITE_DAMAGE),
		list(RED_DAMAGE = BLACK_DAMAGE, WHITE_DAMAGE = PALE_DAMAGE, BLACK_DAMAGE = RED_DAMAGE, PALE_DAMAGE = WHITE_DAMAGE),
		list(RED_DAMAGE = BLACK_DAMAGE, WHITE_DAMAGE = PALE_DAMAGE, BLACK_DAMAGE = WHITE_DAMAGE, PALE_DAMAGE = RED_DAMAGE),

		list(RED_DAMAGE = PALE_DAMAGE, WHITE_DAMAGE = RED_DAMAGE, BLACK_DAMAGE = WHITE_DAMAGE, PALE_DAMAGE = BLACK_DAMAGE),
		list(RED_DAMAGE = PALE_DAMAGE, WHITE_DAMAGE = BLACK_DAMAGE, BLACK_DAMAGE = RED_DAMAGE, PALE_DAMAGE = WHITE_DAMAGE),
		list(RED_DAMAGE = PALE_DAMAGE, WHITE_DAMAGE = BLACK_DAMAGE, BLACK_DAMAGE = WHITE_DAMAGE, PALE_DAMAGE = RED_DAMAGE),
	)
	var/list/picked_mapping = pick(all_mappings)
	for(var/i in picked_mapping)
		mapping[i] = picked_mapping[i]

/datum/damage_type_shuffler/proc/ReshuffleAll()
	Reshuffle(mapping_offense)
	Reshuffle(mapping_defense)

/proc/IsColorDamageType(damage_type)
	var/static/list/color_damage_types = list(RED_DAMAGE = TRUE, WHITE_DAMAGE = TRUE, BLACK_DAMAGE = TRUE, PALE_DAMAGE = TRUE)
	return color_damage_types[damage_type]
