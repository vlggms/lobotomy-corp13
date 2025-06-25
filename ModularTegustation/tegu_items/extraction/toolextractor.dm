//Tool E.G.O extractor
/obj/item/extraction/tool_extractor
	name = "Enkephalin Resonance Unit"
	desc = "A specialized tool that allows E.G.O extraction from tool Abnormalities."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tool_extractor_empty"
	var/energy = 0
	var/maximum_energy = 20
	var/ego_selection
	var/ego_array

/obj/item/extraction/tool_extractor/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "This tool seems to be upgraded, reducing the cost needed to extract by 20%.")

/obj/item/extraction/tool_extractor/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED, PROC_REF(WorkCharge))
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OrdealCharge))
	CalculateMaxNE(SSlobotomy_corp.next_ordeal_level - 2) //The math is weird on this - next_ordeal_level is the ordeal AFTER the one about to spawn, so 2 higher.

/obj/item/extraction/tool_extractor/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END)
	return ..()

/obj/item/extraction/tool_extractor/proc/WorkCharge(SSdcs, datum_reference, user, work_type)
	SIGNAL_HANDLER
	if(datum_reference)
		if(istype(datum_reference, /datum/abnormality))
			var/datum/abnormality/theref = datum_reference
			AdjustNE(theref.threat_level)
			return
	AdjustNE(1) //Somehow there wasn't a datum

/obj/item/extraction/tool_extractor/proc/OrdealCharge(datum/source, datum/ordeal/O = null)
	SIGNAL_HANDLER
	if(!istype(O))
		return
	CalculateMaxNE(O.level)
	AdjustNE(round(maximum_energy / 2))

/obj/item/extraction/tool_extractor/proc/CalculateMaxNE(num)
	switch(num)
		if(-INFINITY to 0)
			maximum_energy = 20
		if(1)
			maximum_energy = 35
		if(2)
			maximum_energy = 50
		if(3)
			maximum_energy = 100
		if(4 to INFINITY)
			maximum_energy = ((num + 2) * 20)

/obj/item/extraction/tool_extractor/proc/AdjustNE(addition)
	energy = clamp(energy + addition, 0, maximum_energy)
	update_icon()

/obj/item/extraction/tool_extractor/examine(mob/user)
	. = ..()
	. += span_notice("This tool's maximum charge increases as each ordeal is cleared.")
	. += "Currently storing [energy]/[maximum_energy] Negative Enkephalin."
	. += "This tool is recharged as agents complete work on abnormalities and defeat ordeals."

/obj/item/extraction/tool_extractor/attack_obj(obj/O, mob/living/carbon/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!tool_checks(user))
		return ..() //You can't do any special interactions
	if(!istype(O, /obj/structure/toolabnormality))//E.G.O stuff below here
		return
	var/obj/structure/toolabnormality/P = O
	ego_selection = input(user, "Which E.G.O will you extract?") as null|anything in P.ego_list
	if(!ego_selection)
		return
	var/cost_multi = 1
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		cost_multi = 0.8 // 20% cheaper
	var/datum/ego_datum/D = ego_selection
	var/enkephalin_cost = initial(D.cost) * cost_multi
	var/loot = initial(D.item_path)
	switch(alert("This E.G.O. requires [D.cost] NE to extract. Confirm Extraction?",,"Yes","No"))
		if("Yes")
			if(enkephalin_cost > energy)
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				to_chat(usr, span_warning("There is not enough NE in the device for this operation."))
				return
			new loot(get_turf(src))
			AdjustNE(-enkephalin_cost)
			to_chat(usr, span_notice("E.G.O extracted successfully!"))
		if("No")
			to_chat(usr, span_notice("You decide not to extract from the abnormality."))
	return

/obj/item/extraction/tool_extractor/update_icon()
	if(energy >= 12) //Able to extract at least ZAYINS
		icon_state = "tool_extractor"
		return
	icon_state = "tool_extractor_empty"
