// Records Officer Agent Preservation Tool
// A handheld device that can store one Lcorp guys's data and revives them. It works like some of Eo's tools where they need to charge up but this one's cost increases the more you use it
//Ported by Crabby, note it was meant to be something else at one point and not related to a watch, might as well fix it.
/obj/item/records_revive
	name = "records copper watch"
	desc = "A high-tech handheld watch that can store a digital backup of an staff member's biological data. Can restore them after death when fully charged."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'//also lmao its called teguitems there
	icon_state = "watch_copper"
	w_class = WEIGHT_CLASS_SMALL
	var/list/stored_agent_data = list()
	var/scan_cooldown = 0
	var/scan_cooldown_time = 3 SECONDS
	var/is_loaded = FALSE
	var/energy = 0
	var/maximum_energy = 40

/obj/item/records_revive/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("This watch seems to be upgraded, the amount of charge it gains is increased by 25%.")
	. += span_notice("This tool's maximum charge increases each time you revive someone.")
	. += "Currently storing [energy]/[maximum_energy] Negative Enkephalin."
	. += "This tool is recharged as agents complete work on abnormalities and defeat ordeals."
	. += "This tool requires a full charge of NE to perform a revive."
	if(is_loaded)
		. += span_notice("Device is loaded with agent data for: [stored_agent_data["real_name"]]")
	else
		. += span_notice("Device is empty. Use on a living staff member to store their data.")


/obj/item/records_revive/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED, PROC_REF(WorkCharge))
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OrdealCharge))

/obj/item/records_revive/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END)
	return ..()

/obj/item/records_revive/proc/WorkCharge(SSdcs, datum_reference, user, work_type)
	SIGNAL_HANDLER
	AdjustNE(1) //Somehow there wasn't a datum

/obj/item/records_revive/proc/OrdealCharge(datum/source, datum/ordeal/O = null)
	SIGNAL_HANDLER
	if(!istype(O))
		return
	AdjustNE(round(maximum_energy / 2))

/obj/item/records_revive/proc/AdjustNE(addition)
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		addition *= 1.25
	energy = clamp(energy + addition, 0, maximum_energy)

/obj/item/records_revive/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	if(!ishuman(target))
		return

	// Check if user is Records Officer
	if(!ishuman(user))
		to_chat(user, span_warning("You cannot use this!"))
		return

	var/mob/living/carbon/human/user_human = user
	if(user_human.mind?.assigned_role != "Records Officer")
		to_chat(user, span_warning("You cannot use this!"))
		return

	var/mob/living/carbon/human/H = target

	// Check if target is an agent (allow mindless for debugging)
	if(H.mind && !(H.mind.assigned_role in list("Records Officer", "Disciplinary Officer", "Manager", "Extraction Officer","Training Officer", "Agent", "Senior Agent", "Captain", "Lieutenant", "Officer", "Clerk")))
		to_chat(user, span_warning("This device only works on L-Corp staff!"))
		return

	// Check if target is alive
	if(H.stat == DEAD)
		to_chat(user, span_warning("Cannot scan dead agents!"))
		return

	// Check cooldown
	if(world.time < scan_cooldown)
		to_chat(user, span_warning("Device is recharging... ([round((scan_cooldown - world.time)/10)] seconds remaining)"))
		return

	// Check if already loaded
	if(is_loaded)
		to_chat(user, span_warning("Device already contains data! Clear it first or use it to check status."))
		return

	// Scan the agent
	scan_agent(H, user)

/obj/item/records_revive/proc/scan_agent(mob/living/carbon/human/H, mob/user)
	if(!H)
		return FALSE

	to_chat(user, span_notice("Scanning [H.real_name]..."))
	playsound(src, 'sound/machines/beep.ogg', 50, TRUE)

	// Store agent data
	stored_agent_data = list()
	stored_agent_data["ref"] = REF(H)
	stored_agent_data["ckey"] = H.ckey
	stored_agent_data["real_name"] = H.real_name
	stored_agent_data["species"] = H.dna.species.type
	stored_agent_data["gender"] = H.gender
	stored_agent_data["assigned_role"] = H.mind?.assigned_role || "Agent"
	stored_agent_data["underwear"] = H.underwear
	stored_agent_data["underwear_color"] = H.underwear_color

	// Store DNA
	var/datum/dna/D = new /datum/dna
	H.dna.copy_dna(D)
	stored_agent_data["dna"] = D

	// Store attributes
	var/list/attributes = list()
	for(var/type in GLOB.attribute_types)
		if(ispath(type, /datum/attribute))
			var/datum/attribute/atr = new type
			attributes[atr.name] = atr
			var/datum/attribute/old_atr = H.attributes[atr.name]
			atr.level = old_atr.level
	stored_agent_data["attributes"] = attributes

	// Store skills
	stored_agent_data["skills"] = serialize_skills(H.mind?.known_skills)

	// Store actions
	var/list/action_types = list()
	for(var/datum/action/A in H.actions)
		if(istype(A, /datum/action/item_action))
			continue
		if(istype(A, /datum/action/spell_action))
			continue
		action_types += A.type
	stored_agent_data["action_types"] = action_types

	is_loaded = TRUE
	scan_cooldown = world.time + scan_cooldown_time

	to_chat(user, span_notice("Staff member data stored successfully!"))
	to_chat(H, span_notice("Your biological data has been backed up to [user]'s preservation device."))

	// Visual effect
	H.visible_message(span_notice("[H] glows briefly as their data is scanned."))

	return TRUE

/obj/item/records_revive/attack_self(mob/user)
	. = ..()

	// Check if user is Records Officer
	if(!ishuman(user))
		to_chat(user, span_warning("You cannot use this!"))
		return

	var/mob/living/carbon/human/user_human = user
	if(user_human.mind?.assigned_role != "Records Officer")
		to_chat(user, span_warning("You cannot use this!"))
		return
	if(energy < maximum_energy)
		to_chat(user, span_warning("The [src] isn't fully charged!"))
		return
	if(!is_loaded)
		to_chat(user, span_warning("No staff member data stored. Use on a living agent to scan them."))
		return

	// Check agent status
	var/agent_name = stored_agent_data["real_name"]
	var/mob/living/carbon/human/original = locate(stored_agent_data["ref"])

	var/dat = "<b>Copper Watch</b><br>"
	dat += "<hr>"
	dat += "<b>Stored Agent:</b> [agent_name]<br>"
	dat += "<b>Status:</b> "

	if(original && original.stat != DEAD)
		dat += "<span style='color:green'>ALIVE</span><br>"
		dat += "<i>Staff member is still alive. Revival not available.</i><br>"
	else
		dat += "<span style='color:red'>DECEASED</span><br>"
		dat += "<a href='byond://?src=[REF(src)];revive=1'>INITIATE REVIVAL PROTOCOL</a><br>"

	dat += "<hr>"
	dat += "<a href='byond://?src=[REF(src)];clear=1'>Clear Stored Data</a><br>"

	var/datum/browser/popup = new(user, "preservation_device", "Copper Watch", 400, 300)
	popup.set_content(dat)
	popup.open()

/obj/item/records_revive/Topic(href, href_list)
	if(..())
		return

	// Check if user is Records Officer
	if(!ishuman(usr))
		to_chat(usr, span_warning("You cannot use this!"))
		return

	var/mob/living/carbon/human/user_human = usr
	if(user_human.mind?.assigned_role != "Records Officer")
		to_chat(usr, span_warning("You cannot use this!"))
		return

	if(href_list["revive"])
		if(!is_loaded)
			return

		var/agent_ckey = stored_agent_data["ckey"]
		// Find ghost
		var/mob/dead/observer/ghost = find_agent_ghost(stored_agent_data["real_name"], agent_ckey)
		if(!ghost)
			to_chat(usr, span_warning("Cannot find staff member's spirit. They may have respawned elsewhere or disconnected."))
			return

		var/response = alert(ghost, "Do you want to be revived by the Copper Watch?", "Revival Offer", "Yes", "No")
		if(response == "Yes")
			revive_agent(usr)

	if(href_list["clear"])
		stored_agent_data = list()
		is_loaded = FALSE
		to_chat(usr, span_notice("Agent data cleared."))

	updateUsrDialog()

/obj/item/records_revive/proc/find_agent_ghost(real_name, ckey)
	for(var/mob/dead/observer/O in GLOB.dead_mob_list)
		if(O.real_name == real_name || O.ckey == ckey)
			return O
	return null

/obj/item/records_revive/proc/revive_agent(mob/user)
	if(!is_loaded || !stored_agent_data)
		return FALSE

	var/agent_ckey = stored_agent_data["ckey"]

	// Find the ghost again
	var/mob/dead/observer/ghost = find_agent_ghost(stored_agent_data["real_name"], agent_ckey)
	if(!ghost || !ghost.client)
		to_chat(user, span_warning("Agent's spirit is not available!"))
		return FALSE

	to_chat(user, span_notice("Initiating revival protocol..."))
	playsound(src, 'sound/effects/phasein.ogg', 50, TRUE)

	// Create new body at tool location
	var/mob/living/carbon/human/new_body = new(get_turf(src))

	// Set up identity
	new_body.real_name = stored_agent_data["real_name"]
	new_body.gender = stored_agent_data["gender"]

	// Transfer DNA
	if(istype(stored_agent_data["dna"], /datum/dna))
		var/datum/dna/stored_dna = stored_agent_data["dna"]
		stored_dna.transfer_identity(new_body)

	// Set species
	var/species_type = stored_agent_data["species"]
	if(ispath(species_type, /datum/species))
		new_body.set_species(species_type)

	// Set attributes
	var/list/stored_attributes = stored_agent_data["attributes"]
	if(islist(stored_attributes))
		new_body.attributes = stored_attributes

	// Set appearance
	if(stored_agent_data["underwear"])
		new_body.underwear = stored_agent_data["underwear"]
	if(stored_agent_data["underwear_color"])
		new_body.underwear_color = stored_agent_data["underwear_color"]

	// Revive and transfer player
	new_body.revive(full_heal = TRUE, admin_revive = FALSE)
	new_body.updateappearance()
	new_body.ckey = ghost.ckey

	// Restore role
	if(stored_agent_data["assigned_role"])
		new_body.mind.assigned_role = stored_agent_data["assigned_role"]
		// Equip appropriate outfit based on role
		switch(stored_agent_data["assigned_role"])
			if("Agent")
				new_body.equipOutfit(/datum/outfit/job/agent)
			if("Clerk")
				new_body.equipOutfit(/datum/outfit/job/staff)
			if("Captain")
				new_body.equipOutfit(/datum/outfit/job/agent/captain)
			if("Lieutenant")
				new_body.equipOutfit(/datum/outfit/job/agent)
			if("Manager")
				new_body.equipOutfit(/datum/outfit/job/officer)
			else
				new_body.equipOutfit(/datum/outfit/job/agent) // Default to agent for officers, just to prevent them from getting multiples of their gear

	// Restore skills
	if(stored_agent_data["skills"])
		new_body.mind.known_skills = deserialize_skills(stored_agent_data["skills"])

	// Restore actions
	var/list/stored_action_types = stored_agent_data["action_types"]
	if(islist(stored_action_types))
		for(var/T in stored_action_types)
			var/datum/action/G = new T()
			G.Grant(new_body)


	// Clear stored data
	stored_agent_data = list()
	is_loaded = FALSE

	// Effects and messages
	new_body.visible_message(span_notice("[new_body] materializes in a flash of light!"))
	to_chat(new_body, span_userdanger("You have been revived by an Copper Watch!"))
	to_chat(user, span_notice("Revival successful! Device memory cleared."))

	energy = 0
	maximum_energy = min(400,round(maximum_energy * 1.5,10))//makes the next revive more costly up to a point
	playsound(get_turf(new_body), 'sound/effects/hokma_meltdown.ogg', 50, TRUE)

	return TRUE

// Helper procs for skills serialization
/obj/item/records_revive/proc/serialize_skills(list/known_skills)
	var/list/serializable = list()
	for(var/datum/skill/S as anything in known_skills)
		serializable["[S.type]"] = known_skills[S]
	return json_encode(serializable)

/obj/item/records_revive/proc/deserialize_skills(text)
	var/list/known_skills = list()
	var/list/decoded = json_decode(text)
	for(var/type_text in decoded)
		var/skill_type = text2path(type_text)
		if(!ispath(skill_type, /datum/skill))
			continue
		known_skills[skill_type] = decoded[type_text]
	return known_skills
