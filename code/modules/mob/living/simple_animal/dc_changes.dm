
/// 0.8x, Maroon Soldier (used for steel???) damage_coeff changes
/datum/dc_change/maroon_buff
	potency = 0.8
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/// 1.2x Rends, used for various EGO
/datum/dc_change/rend
	potency = 1.2

/datum/dc_change/rend/red
	damage_type = RED_DAMAGE

/datum/dc_change/rend/white
	damage_type = WHITE_DAMAGE

/datum/dc_change/rend/black
	damage_type = BLACK_DAMAGE

/datum/dc_change/rend/pale // Unused atm
	damage_type = PALE_DAMAGE

/// 1.2x modifiers, used by Salvation
/datum/dc_change/salvation
	potency = 1.2
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/// 1.5x Black modifier, used by Laughter
/datum/dc_change/mosb_black
	potency = 1.5
	damage_type = BLACK_DAMAGE

/// +0.5 Pale modifier, used by Head of God
/datum/dc_change/godhead
	additive = TRUE
	potency = 0.5
	damage_type = PALE_DAMAGE

/// +0.1 Universal modifier, self-inflicted by Doomsday calender
/datum/dc_change/sacrificed
	additive = TRUE
	potency = 0.1
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/// Universal x2 modifer, inflicted by PT
/datum/dc_change/lacerated
	potency = 2
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/// x1.05 - x2 Red Modifier, inflicted by Naked Nest Realization
/datum/dc_change/infested
	potency = 1.05
	damage_type = RED_DAMAGE

/// x1.1 universal modifier, inflicted by Deep Scanner
/datum/dc_change/scanned
	potency = 1.1
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/// x1,5 universal modifier, inflicted by Road Of Gold
/datum/dc_change/gold_staggered
	potency = 1.5
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/// up to 2.16x damage, My Form Empties
/datum/dc_change/karma
	potency = 1.1
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/// Stacking Protection/Fragile, used for Protection/Fragile status effects
/datum/dc_change/protection
	potency = 1
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/datum/dc_change/red_protection
	potency = 1
	damage_type = list(RED_DAMAGE)

/datum/dc_change/white_protection
	potency = 1
	damage_type = list(WHITE_DAMAGE)

/datum/dc_change/black_protection
	potency = 1
	damage_type = list(BLACK_DAMAGE)

/datum/dc_change/pale_protection
	potency = 1
	damage_type = list(PALE_DAMAGE)

/datum/dc_change/fragility
	potency = 1
	damage_type = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/datum/dc_change/red_fragility
	potency = 1
	damage_type = list(RED_DAMAGE)

/datum/dc_change/white_fragility
	potency = 1
	damage_type = list(WHITE_DAMAGE)

/datum/dc_change/black_fragility
	potency = 1
	damage_type = list(BLACK_DAMAGE)

/datum/dc_change/pale_fragility
	potency = 1
	damage_type = list(PALE_DAMAGE)
