/* Helper procs */
// Returns the datum of requested upgrade type
/proc/GetFacilityUpgrade(up_name)
	for(var/datum/facility_upgrade/F in SSlobotomy_corp.upgrades)
		if(F.name == up_name)
			return F
	return null

// Returns value of the facility upgrade.
/proc/GetFacilityUpgradeValue(up_name)
	for(var/datum/facility_upgrade/F in SSlobotomy_corp.upgrades)
		if(F.name == up_name)
			return F.value
	return 0

/* Facility upgrade datums */
/datum/facility_upgrade
	var/name = null
	var/value = 0
	var/max_value = 0
	/// How much LOB points does it cost to Upgrade
	var/cost = 1
	/// Category by which it will be displayed in the aux console.
	/// To keep it sorted by "importance", avoid creating new categories without adding them to abnormality_auxiliary.dm display list
	var/category = "Unsorted"
	/// If not empty - list of required upgrades to be available.
	var/list/requires_all_of = list()
	/// Similar to above - list of required upgrades to be available, but needs only one of them.
	var/list/requires_one_of = list()
	// A shitty way to make 1 show up as text instead of 1. If null or FALSE - will show a value as usual.
	var/display_true = null
	// Same as above, but for negative/0 values
	var/display_false = null

/// What happens when the upgrade is done
/datum/facility_upgrade/proc/Upgrade()
	SSlobotomy_corp.lob_points -= cost
	return TRUE

/datum/facility_upgrade/proc/DisplayValue()
	if(!display_true || !display_false)
		return value
	return value ? display_true : display_false

/// Return TRUE if it should be shown in the aux console
/datum/facility_upgrade/proc/CanShowUpgrade()
	// Someone forgot to set the values! Uh oh!
	if(!max_value || !name)
		return FALSE
	if(LAZYLEN(requires_all_of))
		for(var/F in requires_all_of)
			if(!GetFacilityUpgradeValue(F))
				return FALSE
		return TRUE
	if(LAZYLEN(requires_one_of))
		for(var/F in requires_one_of)
			if(GetFacilityUpgradeValue(F))
				return TRUE
		return FALSE
	return TRUE

/// Whereas you can upgrade it at all
/datum/facility_upgrade/proc/CanUpgrade()
	if(value >= max_value)
		return FALSE
	if(SSlobotomy_corp.lob_points < cost)
		return FALSE
	return TRUE

/* Bullets */
/datum/facility_upgrade/bullet
	max_value = 1
	category = "Bullets"
	display_true = "PURCHASED"
	display_false = "NOT PURCHASED" // Honestly quite weird, but whatever

/datum/facility_upgrade/bullet/Upgrade()
	value = max_value
	return ..()

/datum/facility_upgrade/bullet/hp
	name = HP_BULLET

/datum/facility_upgrade/bullet/sp
	name = SP_BULLET

/datum/facility_upgrade/bullet/red
	name = RED_BULLET

/datum/facility_upgrade/bullet/white
	name = WHITE_BULLET

/datum/facility_upgrade/bullet/black
	name = BLACK_BULLET

/datum/facility_upgrade/bullet/pale
	name = PALE_BULLET

/datum/facility_upgrade/bullet/yellow
	name = YELLOW_BULLET

// Bullet upgrades
/datum/facility_upgrade/bullet_count
	name = UPGRADE_BULLET_COUNT
	category = "Bullet Upgrades"
	value = 4
	max_value = 40
	requires_one_of = list(HP_BULLET, SP_BULLET, RED_BULLET, WHITE_BULLET, BLACK_BULLET, PALE_BULLET, YELLOW_BULLET)
	/// The cost will not go further upwards from that point on
	var/max_cost = 6

/datum/facility_upgrade/bullet_count/Upgrade()
	value = min(max_value, value + round(max_value * 0.1))
	. = ..()
	cost = min(max_cost, cost + 1)

/datum/facility_upgrade/bullet_heal_increase
	name = UPGRADE_BULLET_HEAL
	category = "Bullet Upgrades"
	value = 0.15
	max_value = 0.6
	requires_one_of = list(HP_BULLET, SP_BULLET)

/datum/facility_upgrade/bullet_heal_increase/Upgrade()
	value = min(max_value, value + 0.15)
	. = ..()
	cost += 1

/datum/facility_upgrade/bullet_heal_increase/DisplayValue()
	return "[value * 100]%"

// Upgrades for shield bullets
/datum/facility_upgrade/bullet_shield_increase
	name = UPGRADE_BULLET_SHIELD_HEALTH
	category = "Bullet Upgrades"
	value = 50
	max_value = 200
	requires_one_of = list(RED_BULLET, WHITE_BULLET, BLACK_BULLET, PALE_BULLET)

/datum/facility_upgrade/bullet_shield_increase/New()
	. = ..()
	max_value = DEFAULT_HUMAN_MAX_HEALTH + (100 * FORTITUDE_MOD)
	value = max_value * 0.25

/datum/facility_upgrade/bullet_shield_increase/Upgrade()
	value = min(max_value, value + (max_value * 0.125))
	. = ..()
	cost += 1

// Agent upgrades
/datum/facility_upgrade/agent_spawn_stats_bonus
	name = UPGRADE_AGENT_STATS
	category = "Agent"
	value = 0
	max_value = 30
	var/value_increase = 5

/datum/facility_upgrade/agent_spawn_stats_bonus/Upgrade()
	value = min(max_value, value + value_increase)
	// Applies newly purchased bonus to all living agents
	for(var/mob/living/carbon/human/H in AllLivingAgents())
		H.adjust_all_attribute_levels(value_increase)
		to_chat(H, span_notice("Facility upgrade increased your attributes by [value_increase] points!"))
	. = ..()
	cost += 1

// Abnormality upgrades
/datum/facility_upgrade/picking_abno_amount
	name = UPGRADE_ABNO_QUEUE_COUNT
	category = "Abnormalities"
	value = 2
	max_value = 4

/datum/facility_upgrade/picking_abno_amount/Upgrade()
	value = min(max_value, value + 1)
	. = ..()
	cost += 1

/datum/facility_upgrade/abno_melt_time
	name = UPGRADE_ABNO_MELT_TIME
	category = "Abnormalities"
	value = 0
	max_value = 60

/datum/facility_upgrade/abno_melt_time/Upgrade()
	value = min(max_value, value + 10)
	. = ..()
	if(value >= max_value * 0.25)
		cost += 1

/datum/facility_upgrade/abno_melt_time/DisplayValue()
	return "[value] seconds"
