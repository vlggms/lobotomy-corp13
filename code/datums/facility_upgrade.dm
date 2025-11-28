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
	/// Similar to above - list of upgrades to to make this one unvailable.
	var/list/requires_none_of = list()
	// A shitty way to make 1 show up as text instead of 1. If null or FALSE - will show a value as usual.
	var/display_true = null
	// Same as above, but for negative/0 values
	var/display_false = null
	// Infomation about the upgrade
	var/info

/datum/facility_upgrade/proc/PrintOutInfo()
	var/dat = "[capitalize(name)]<br><br>"
	if(LAZYLEN(info))
		dat += "Info:<br>"
		dat += "[info]<br>"
	return dat

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
	if(LAZYLEN(requires_none_of))
		for(var/F in requires_none_of)
			if(GetFacilityUpgradeValue(F))
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
	info = " - This type of bullet when fired heals the <b>HP</b> of an employee shot at."

/datum/facility_upgrade/bullet/sp
	name = SP_BULLET
	info = " - This type of bullet when fired heals the <b>SP</b> of an employee shot at.<br> - <b>WARNING</b> Doesn't work when the employee shot at is insane.<b>WARNING</b>"

/datum/facility_upgrade/bullet/dual
	max_value = 1.5
	cost = 1.5
	name = DUAL_BULLET
	requires_all_of = list(HP_BULLET, SP_BULLET)
	info = " - This type of bullet when fired heals both the <b>HP</b> and <b>SP</b> of an employee shot at.<br> - Costs 1.75 Bullets to use.<br> - <b>WARNING</b> Doesn't work when the employee shot at is insane.<b>WARNING</b>"

/datum/facility_upgrade/bullet/red
	name = RED_BULLET
	cost = 0.5
	info = " - This type of bullet when fired applies a <b>Red</b> damage blocking shield to the an employee."

/datum/facility_upgrade/bullet/white
	name = WHITE_BULLET
	cost = 0.5
	info = " - This type of bullet when fired applies a <b>White</b> damage blocking shield to the an employee."

/datum/facility_upgrade/bullet/black
	name = BLACK_BULLET
	cost = 0.5
	info = " - This type of bullet when fired applies a <b>Black</b> damage blocking shield to the an employee."

/datum/facility_upgrade/bullet/pale
	name = PALE_BULLET
	cost = 0.5
	info = " - This type of bullet when fired applies a <b>Pale</b> damage blocking shield to the an employee."

/datum/facility_upgrade/bullet/quad
	max_value = 1.5
	cost = 1.5
	name = QUAD_BULLET
	requires_all_of = list(RED_BULLET, WHITE_BULLET, BLACK_BULLET, PALE_BULLET)
	info = " - This type of bullet when fired applies a shield of an employee that blocks all <b>4</b> damage types and has twice the <b>HP</b>.<br> - Costs 3 Bullets to use."

/datum/facility_upgrade/bullet/yellow
	name = YELLOW_BULLET
	info = " - This type of bullet when fired applies a <b>Slowdown</b> debuff to an Abnormality/Ordeal."
/datum/facility_upgrade/bullet/kill
	name = KILL_BULLET
	info = " - This type of bullet when fired kills an employee."

/datum/facility_upgrade/bullet/kill/CanUpgrade()
	if(!GLOB.execution_enabled) //Failsafe in case admins turn off the bullets due to a rampaging manager
		return FALSE
	return ..()

// Bullet upgrades
/datum/facility_upgrade/bullet_count
	name = UPGRADE_BULLET_COUNT
	category = "Bullet Upgrades"
	value = 4
	max_value = 40
	requires_one_of = list(HP_BULLET, SP_BULLET, RED_BULLET, WHITE_BULLET, BLACK_BULLET, PALE_BULLET, YELLOW_BULLET, KILL_BULLET)
	/// The cost will not go further upwards from that point on
	var/max_cost = 6
	info = " - This upgrade inceases the maximum amount of <b>Bullets</b> the console can have by 4 per upgrade."

/datum/facility_upgrade/bullet_count/Upgrade()
	value = min(max_value, value + round(max_value * 0.1))
	. = ..()
	cost = min(max_cost, cost + 1)

/datum/facility_upgrade/bullet_heal_increase
	name = UPGRADE_BULLET_HEAL
	category = "Bullet Upgrades"
	value = 0.2
	max_value = 0.5
	requires_one_of = list(HP_BULLET, SP_BULLET)
	cost = 2
	info = " - This upgrade inceases the % healing of <b>HP, SP, and Dual Bullets</b> by +10% per upgrade."

/datum/facility_upgrade/bullet_heal_increase/Upgrade()
	value = min(max_value, value + 0.1)
	return ..()

/datum/facility_upgrade/bullet_heal_increase/DisplayValue()
	return "[value * 100]%"

// Upgrades for shield bullets
/datum/facility_upgrade/bullet_shield_increase
	name = UPGRADE_BULLET_SHIELD_HEALTH
	category = "Bullet Upgrades"
	value = 40
	max_value = 100
	requires_one_of = list(RED_BULLET, WHITE_BULLET, BLACK_BULLET, PALE_BULLET)
	info = " - This upgrade inceases the Health of all <b>Shield Bullets</b> by 10 HP per upgrade."

/datum/facility_upgrade/bullet_shield_increase/Upgrade()
	value = min(max_value, value + 10)
	return ..()

/datum/facility_upgrade/yellow_bullet_buff
	name = UPGRADE_YELLOW_BULLET
	max_value = 1
	cost = 2
	category = "Bullet Upgrades"
	display_true = "PURCHASED"
	display_false = "NOT PURCHASED" // Honestly quite weird, but whatever
	requires_one_of = list(YELLOW_BULLET)
	info = " - This upgrade causes Qliphoth Intervention Bullets to weaken the resistances of the Abnormality/Ordeal shot at by 20%."

/datum/facility_upgrade/yellow_bullet_buff/Upgrade()
	value = max_value
	return ..()

//Facility Upgrades
/datum/facility_upgrade/regnenerator_healing
	name = UPGRADE_REGENERATOR_HEALING
	category = "Facility"
	cost = 2
	value = 0
	max_value = 1.5
	var/value_increase = 0.5
	info = " - This upgrade inceases the healing of <b>Regenerators</b> by a flat +0.5% per upgrade.<br> - The additional healing does not get decreased when theres an <b>Abnormality/Ordeal</b> in the regenerator's deparment."

/datum/facility_upgrade/regnenerator_healing/Upgrade()
	value = min(max_value, value + value_increase)
	. = ..()
	cost += 1

/datum/facility_upgrade/regnenerator_healing/DisplayValue()
	return "+[value]% healing"

/datum/facility_upgrade/meltdown_increase
	name = UPGRADE_MELTDOWN_INCREASE
	category = "Facility"
	value = 0
	max_value = 3
	info = " - This upgrade inceases the amount of <b>Works</b> needed for a Qliphoth Meltdown by 1 per upgrade.<br> - This upgrade additionally increases the time limit of <b>Post Midnight Core Suppressions</b> by 20 Minutes per upgrade."

/datum/facility_upgrade/meltdown_increase/Upgrade()
	value = min(max_value, value + 1)
	. = ..()
	cost += 1

/datum/facility_upgrade/meltdown_increase/DisplayValue()
	if (value > 1)
		return "+[value] extra works"
	return "+[value] extra work"

/datum/facility_upgrade/agent_spawn_stats_bonus
	name = UPGRADE_AGENT_STATS
	category = "Facility"
	value = 0
	max_value = 30
	var/value_increase = 5
	info = " - This upgrade inceases the amount of stats all Agents and Officers have by +5 per upgrade."

/datum/facility_upgrade/agent_spawn_stats_bonus/DisplayValue()
	return "+[value]"

/datum/facility_upgrade/agent_spawn_stats_bonus/Upgrade()
	value = min(max_value, value + value_increase)
	// Applies newly purchased bonus to all living agents
	for(var/mob/living/carbon/human/H in AllLivingAgents(TRUE))
		H.adjust_all_attribute_levels(value_increase)
		to_chat(H, span_notice("Facility upgrade increased your attributes by [value_increase] points!"))
	. = ..()
	cost += 1

/datum/facility_upgrade/picking_abno_amount
	name = UPGRADE_ABNO_QUEUE_COUNT
	category = "Facility"
	value = 2
	max_value = 4
	info = " - This upgrade inceases the amount of <b>Abnormalities</b> the manager can select by 1 per upgrade."

/datum/facility_upgrade/picking_abno_amount/Upgrade()
	value = min(max_value, value + 1)
	. = ..()
	cost += 1

/datum/facility_upgrade/abno_melt_time
	name = UPGRADE_ABNO_MELT_TIME
	category = "Facility"
	value = 0
	max_value = 60
	info = " - This upgrade inceases the duration of an Abnormality's <b>Meltsdown Timer</b> by 10 seconds per upgrade."

/datum/facility_upgrade/abno_melt_time/Upgrade()
	value = min(max_value, value + 10)
	. = ..()
	if(value >= max_value * 0.25)
		cost += 1

/datum/facility_upgrade/abno_melt_time/DisplayValue()
	return "[value] seconds"

//Specialization//
/datum/facility_upgrade/specialization
	max_value = 1
	cost = 1.5
	category = "Higher-Up Specialization Tier 1"
	display_true = "PURCHASED"
	display_false = "NOT PURCHASED"

/datum/facility_upgrade/specialization/Upgrade()
	value = max_value
	return ..()

/datum/facility_upgrade/specialization/tier_2
	cost = 3.5
	category = "Higher-Up Specialization Tier 2"
	display_true = "PURCHASED"
	display_false = "NOT PURCHASED"

/datum/facility_upgrade/specialization/records
	name = UPGRADE_RECORDS_1
	info = " - Gives most of the Records Officer's watches a buff.<br> - Raises the Records Officer's Stat and maximum potential by 10"

/datum/facility_upgrade/specialization/records/Upgrade()
	// Applies newly purchased bonus to all living agents
	for(var/datum/job/command/J in SSjob.occupations)
		if (J.title == "Records Officer")
			J.job_attribute_limit += 10
			J.extra_starting_stats += 10
			break
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		if(H.mind.assigned_role == "Records Officer")
			H.adjust_all_attribute_levels(10)
			H.adjust_attribute_limit(10)
			to_chat(H, span_notice("You feel new potential unlock within you!"))
			break
	. = ..()

/datum/facility_upgrade/specialization/tier_2/records
	name = UPGRADE_RECORDS_2
	info = " - Increases Lob gained from Abnormality Understanding by 50%.<br> - Raises the Records Officer's Stat and maximum potential by 10"
	requires_one_of = list(UPGRADE_RECORDS_1)
	requires_none_of = list(UPGRADE_DISCIPLINARY_2, UPGRADE_EXTRACTION_2)

/datum/facility_upgrade/specialization/tier_2/records/Upgrade()
	// Applies newly purchased bonus to all living agents
	for(var/datum/job/command/J in SSjob.occupations)
		if (J.title == "Records Officer")
			J.job_attribute_limit += 10
			J.extra_starting_stats += 10
			break
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		if(H.mind.assigned_role == "Records Officer")
			H.adjust_all_attribute_levels(10)
			H.adjust_attribute_limit(10)
			to_chat(H, span_notice("You feel new potential unlock within you!"))
			break
	. = ..()

/datum/facility_upgrade/specialization/extraction
	name = UPGRADE_EXTRACTION_1
	info = " - Gives most of the Extraction Officer's tools a buff.<br> - Increases the effectiveness of all of the Extraction Officer's refineries."

/datum/facility_upgrade/specialization/tier_2/extraction
	name = UPGRADE_EXTRACTION_2
	info = " - Extraction Officer can extract EGO 15% cheaper.<br> - Makes PE selling time 3 times as fast!"
	requires_one_of = list(UPGRADE_EXTRACTION_1)
	requires_none_of = list(UPGRADE_DISCIPLINARY_2, UPGRADE_RECORDS_2)

/datum/facility_upgrade/specialization/architect
	cost = 1
	name = UPGRADE_ARCHITECT_1
	info = " - The Manager gets notified when an Abnormality breaches containment."

/datum/facility_upgrade/specialization/architect/Upgrade()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))
	return ..()

/datum/facility_upgrade/specialization/architect/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(NotifyEscape), abno), 1 SECONDS)

/datum/facility_upgrade/specialization/architect/proc/NotifyEscape(mob/living/simple_animal/hostile/abnormality/abno)
	if(QDELETED(abno) || abno.stat == DEAD || is_tutorial_level(abno.z) || istype(abno, /mob/living/simple_animal/hostile/abnormality/training_rabbit))
		return
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		if(H.mind.assigned_role == "Manager")
			to_chat(H, "<span class='warning'>WARNING! [abno] has breached containment!</span>")
			playsound(get_turf(H), 'sound/effects/alertBeep.ogg', 25, 1, -4)
			break

/datum/facility_upgrade/specialization/tier_2/architect
	cost = 2
	name = UPGRADE_ARCHITECT_2
	info = " - The Manager gets better infomation when inspecting an Abnormality or Agent."
	requires_one_of = list(UPGRADE_ARCHITECT_1)
