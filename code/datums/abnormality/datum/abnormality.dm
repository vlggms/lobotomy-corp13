/datum/abnormality
	var/name = "Abnormality"
	var/desc = "An abnormality of unknown type."
	/// The threat level of the abnormality
	var/threat_level = ZAYIN_LEVEL
	/// Current state of the qliphoth
	var/qliphoth_meter = 0
	/// Maximum level of qliphoth. If 0 or below - it has no effects
	var/qliphoth_meter_max = 0
	/// Path of the mob it contains
	var/mob/living/simple_animal/hostile/abnormality/abno_path
	/// Reference to current mob, if alive
	var/mob/living/simple_animal/hostile/abnormality/current
	/// Reference to respawn landmark
	var/obj/effect/landmark/abnormality_spawn/landmark
	///Abnormality's computer console
	var/obj/machinery/computer/abnormality/console

	/// Available work types with their success chances per level. Used in console
	var/list/available_work = list(
							ABNORMALITY_WORK_INSTINCT = 0,
							ABNORMALITY_WORK_INSIGHT = 0,
							ABNORMALITY_WORK_ATTACHMENT = 0,
							ABNORMALITY_WORK_REPRESSION = 0
							)
	/// How much PE it produces. Also responsible for work time
	var/max_boxes = 0
	/// How much PE you have to produce for good result.
	var/success_boxes = 0
	/// How much PE you have to produce for neutral result.
	var/neutral_boxes = 0
	/// List of available EGO for purchase
	var/list/ego_datums = list()
	/// Currently purchased EGO gear, so we don't go over the limit
	var/list/current_ego = list()
	/// How many PE boxes we have available for use on EGO purchase
	var/stored_boxes = 0
	/// Associative list of ckey = overload chance; It is reset each meltdown.
	var/list/overload_chance = list()
	/// Amount of reduction applied on each work session
	var/overload_chance_amount = 0
	/// Limit on overload_chance; By default equal to amount * 10
	var/overload_chance_limit = 100
	/// Simulated Observation Bonuses
	var/understanding = 0
	var/max_understanding = 0
	/// The limit for maximum attribute level you can achieve working on this abnormality
	var/maximum_attribute_level = 0
	/// A list of performed works on it
	var/list/work_logs = list()
	/// A list of agents that have ever worked on it
	var/list/work_stats = list()
	/*
	* Moved this variable from work Console for a two reasons
	* First, this allows both the console AND the abnormality to check on the current working status. Useful overall.
	* Second, there's no real reason for it to NOT be here unless we SOMEHOW, for SOME REASON, get duplicate abnormalities. Even then I don't know if that'd conflict.
	*/
	var/working = FALSE
	///a list of variable the abno wants to remember after death
	var/list/transferable_var
	///if the abno spawns with a slime radio or not
	var/abno_radio = FALSE

/datum/abnormality/New(obj/effect/landmark/abnormality_spawn/new_landmark, mob/living/simple_animal/hostile/abnormality/new_type = null)
	if(!istype(new_landmark))
		CRASH("Abnormality datum was created without reference to landmark.")
	if(!ispath(new_type))
		CRASH("Abnormality datum was created without a path to the mob.")
	landmark = new_landmark
	abno_path = new_type
	name = initial(abno_path.name)
	desc = initial(abno_path.desc)
	RespawnAbno()
	FillEgoList()

/datum/abnormality/Destroy()
	SSlobotomy_corp.all_abnormality_datums -= src
	for(var/datum/ego_datum/ED in ego_datums)
		qdel(ED)
	QDEL_NULL(landmark)
	QDEL_NULL(current)
	ego_datums = null
	landmark = null
	current = null
	..()

/datum/abnormality/proc/RespawnAbno()
	if(!ispath(abno_path))
		CRASH("Abnormality tried to respawn a mob, but abnormality path wasn't valid.")
	if(!istype(landmark))
		CRASH("Couldn't respawn an abnormality [initial(abno_path.name)] due to missing landmark.")
	if(istype(current))
		return
	var/turf/T = get_turf(landmark)
	current = new abno_path(T)
	current.datum_reference = src
	current.toggle_ai(AI_OFF)
	current.status_flags |= GODMODE
	current.setDir(EAST)
	threat_level = current.threat_level
	qliphoth_meter_max = current.start_qliphoth
	qliphoth_meter = qliphoth_meter_max
	maximum_attribute_level = THREAT_TO_ATTRIBUTE_LIMIT[threat_level]
	if(!current.max_boxes)
		max_boxes = threat_level * 6
	else
		max_boxes = current.max_boxes
	if(!current.success_boxes)
		success_boxes = round(max_boxes * 0.7)
	else
		success_boxes = current.success_boxes
	if(!current.neutral_boxes)
		neutral_boxes = round(max_boxes * 0.4)
	else
		neutral_boxes = current.neutral_boxes
	available_work = current.work_chances
	switch(threat_level)
		if(ZAYIN_LEVEL)
			max_understanding = 10
		if(TETH_LEVEL)
			max_understanding = 10
		if(HE_LEVEL)
			max_understanding = 8
		if(WAW_LEVEL)
			overload_chance_amount = -4
			max_understanding = 6
		if(ALEPH_LEVEL)
			overload_chance_amount = -6
			max_understanding = 6
	if(understanding == max_understanding && max_understanding > 0)
		current.gift_chance *= 1.5
	overload_chance_limit = overload_chance_amount * 10
	if(abno_radio)
		current.AbnoRadio()
	current.PostSpawn()

/datum/abnormality/proc/FillEgoList()
	if(!current || !current.ego_list)
		return FALSE
	for(var/thing in current.ego_list)
		var/datum/ego_datum/ED = new thing(src)
		ego_datums += ED
		GLOB.ego_datums["[ED.name][ED.item_category]"] = ED
	return TRUE


/datum/abnormality/proc/work_complete(mob/living/carbon/human/user, work_type, pe, work_time, was_melting, canceled)
	current.WorkComplete(user, work_type, pe, work_time, canceled) // Cross-referencing gone wrong
	if(!console?.recorded && !console?.tutorial) //only training rabbit should not train stats
		return
	var/attribute_type = "N/A"
	var/attribute_given = 0
	if(pe > 0) // Work did not fail
		attribute_type = current.work_attribute_types[work_type]
		var/datum/attribute/user_attribute = user.attributes[attribute_type]
		if(user_attribute) //To avoid runtime if it's a custom work type like "Release".
			var/user_attribute_level = max(1, user_attribute.level)
			attribute_given = clamp(((maximum_attribute_level / (user_attribute_level * 0.25)) * (0.25 + (pe / max_boxes))), 0, 16)
			if((user_attribute_level + attribute_given + 1) >= maximum_attribute_level) // Already/Will/Should be at maximum.
				attribute_given = max(0, maximum_attribute_level - user_attribute_level)
			if(attribute_given == 0)
				if(was_melting)
					attribute_given = threat_level //pity stats on meltdowns
				else
					to_chat(user, "<span class='warning'>You don't feel like you've learned anything from this!</span>")
			user.adjust_attribute_level(attribute_type, attribute_given)
	if(console?.tutorial) //don't run logging-related code if tutorial console
		return
	var/user_job_title = "Unidentified Employee"
	var/obj/item/card/id/W = user.get_idcard()
	if(istype(W))
		user_job_title = W.assignment
	work_logs += "\[[worldtime2text()]\] [user_job_title] [user.real_name] (LV [user.get_text_level()]): Performed [work_type], [pe]/[max_boxes] PE."
	AddWorkStats(user, pe, attribute_type, attribute_given)
	SSlobotomy_corp.work_logs += "\[[worldtime2text()]\] [name]: [user_job_title] [user.real_name] (LV [user.get_text_level()]): Performed [work_type], [pe]/[max_boxes] PE."
	if (pe >= success_boxes) // If they got a good result, adds 10% understanding, up to 100%
		UpdateUnderstanding(10)
	else if (pe >= neutral_boxes) // Otherwise if they got a Neutral result, adds 5% understanding up to 100%
		UpdateUnderstanding(5)
	stored_boxes += round(pe * SSlobotomy_corp.box_work_multiplier)
	overload_chance[user.ckey] = max(overload_chance[user.ckey] + overload_chance_amount, overload_chance_limit)

/datum/abnormality/proc/UpdateUnderstanding(percent)
	if (understanding != max_understanding) // This should render "full_understood" not required.
		understanding = clamp((understanding + (max_understanding*percent/100)), 0, max_understanding)
		if (understanding == max_understanding) // Checks for max understanding after the fact
			current.gift_chance *= 1.5
			SSlobotomy_corp.understood_abnos++
	else if(understanding == max_understanding && percent < 0) // If we're max and we reduce, undo the count.
		understanding = clamp((understanding + (max_understanding*percent/100)), 0, max_understanding)
		if (understanding != max_understanding) // Checks for max understanding after the fact
			current.gift_chance /= 1.5
			SSlobotomy_corp.understood_abnos--

/datum/abnormality/proc/qliphoth_change(amount, user)
	var/pre_qlip = qliphoth_meter
	qliphoth_meter = clamp(qliphoth_meter + amount, 0, qliphoth_meter_max)
	if((qliphoth_meter_max > 0) && (qliphoth_meter <= 0) && (pre_qlip > 0))
		current?.ZeroQliphoth(user)
		current?.visible_message("<span class='danger'>Warning! Qliphoth level reduced to 0!")
		playsound(get_turf(current), 'sound/effects/alertbeep.ogg', 50, FALSE)
		work_logs += "\[[worldtime2text()]\]: Qliphoth counter reduced to 0!"
		if(console?.recorded)
			SSlobotomy_corp.work_logs += "\[[worldtime2text()]\] [name]: Qliphoth counter reduced to 0!"
		return
	if(pre_qlip != qliphoth_meter)
		if(pre_qlip < qliphoth_meter) // Alerts on change of counter. It's just nice to know instead of inspecting the console every time. Also helps for those nearby if something goes to shit.
			current?.visible_message("<span class='notice'>Qliphoth level increased by [qliphoth_meter-pre_qlip]!</span>")
			playsound(get_turf(current), 'sound/machines/synth_yes.ogg', 50, FALSE)
		else
			current?.visible_message("<span class='warning'>Qliphoth level decreased by [pre_qlip-qliphoth_meter]!</span>")
			playsound(get_turf(current), 'sound/machines/synth_no.ogg', 50, FALSE)
		current?.OnQliphothChange(user, amount, pre_qlip)
	if(console?.recorded)
		work_logs += "\[[worldtime2text()]\]: Qliphoth counter [pre_qlip < qliphoth_meter ? "increased" : "reduced"] to [qliphoth_meter]!"
		SSlobotomy_corp.work_logs += "\[[worldtime2text()]\] [name]: Qliphoth counter [pre_qlip < qliphoth_meter ? "increased" : "reduced"] to [qliphoth_meter]!"

/datum/abnormality/proc/get_work_chance(workType, mob/living/carbon/human/user)
	if(!istype(user))
		return 0
	var/acquired_chance = available_work[workType]
	if(islist(acquired_chance))
		var/work_level = clamp(round(get_attribute_level(user, WORK_TO_ATTRIBUTE[workType])/20), 1, 5)
		acquired_chance = acquired_chance[work_level]
	if(current)
		acquired_chance = current.WorkChance(user, acquired_chance, workType)
	switch(workType)
		if(ABNORMALITY_WORK_INSTINCT)
			acquired_chance += user.physiology.instinct_success_mod
		if(ABNORMALITY_WORK_INSIGHT)
			acquired_chance += user.physiology.insight_success_mod
		if(ABNORMALITY_WORK_ATTACHMENT)
			acquired_chance += user.physiology.attachment_success_mod
		if(ABNORMALITY_WORK_REPRESSION)
			acquired_chance += user.physiology.repression_success_mod
	acquired_chance *= user.physiology.work_success_mod
	acquired_chance += get_modified_attribute_level(user, TEMPERANCE_ATTRIBUTE) * TEMPERANCE_SUCCESS_MOD
	acquired_chance += understanding // Adds up to 6-10% [Threat Based] work chance based off works done on it. This simulates Observation Rating which we lack ENTIRELY and as such has inflated the overall failure rate of abnormalities.
	if(overload_chance[user.ckey])
		acquired_chance += overload_chance[user.ckey]
	return clamp(acquired_chance, 0, 100)

/datum/abnormality/proc/AddWorkStats(mob/living/carbon/human/user, pe = 0, attribute_type = "N/A", attribute_given = 0)
	var/user_name = "[user.real_name] ([user.ckey])"
	if(!(user_name in work_stats))
		work_stats[user_name] = list("name" = user.real_name,"works" = 0, "pe" = 0, "gain" = list())
	work_stats[user_name]["works"] += 1
	if(pe)
		work_stats[user_name]["pe"] += pe
	if(attribute_type != "N/A" && attribute_given)
		work_stats[user_name]["gain"][attribute_type] += attribute_given

	// Global agent stats
	if(!(user_name in SSlobotomy_corp.work_stats))
		SSlobotomy_corp.work_stats[user_name] = list("name" = user.real_name, "works" = 0, "pe" = 0, "gain" = list())
	SSlobotomy_corp.work_stats[user_name]["works"] += 1
	if(pe)
		SSlobotomy_corp.work_stats[user_name]["pe"] += pe
	if(attribute_type != "N/A" && attribute_given)
		SSlobotomy_corp.work_stats[user_name]["gain"][attribute_type] += attribute_given

/datum/abnormality/proc/GetName()
	if(current)
		return current.GetName()
	return name

/datum/abnormality/proc/GetRiskLevel()
	if(current)
		return current.GetRiskLevel()
	return threat_level
