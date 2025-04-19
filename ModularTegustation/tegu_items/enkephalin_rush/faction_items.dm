//LOBOTOMY CORPORATION - the "default" faction with a focus on E.G.O and abnormalities.

/obj/item/abno_core_injector
	name = "E.G.O solidification unit - Z"
	desc = "A single-use device that constructs an E.G.O using a sample from an abnormality core. It can extract E.G.O that cost up to 15 PE."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"
	custom_price = 50
	var/energy = 15
	var/ego_selection
	var/ego_array

/obj/item/abno_core_injector/attack_obj(obj/O, mob/living/carbon/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!istype(O, /obj/structure/abno_core))
		to_chat(user, span_warning("Your target is not an abnormality core."))
		return
	var/obj/structure/abno_core/P = O
	var/ego_selection = list()
	for(var/path in P.ego_list)
		var/datum/ego_datum/ego = path
		if(ego.cost <= energy)
			ego_selection += ego.item_path
	var/chosen_ego = input(user, "Which E.G.O will you extract?") as null|anything in ego_selection
	if(!chosen_ego)
		to_chat(user, span_warning("There are no compatible E.G.O available."))
		return
//	var/datum/ego_datum/D = chosen_ego
	switch(alert("Extracting E.G.O will destroy this device. Confirm Extraction?",,"Yes","No"))
		if("Yes")
			new chosen_ego(get_turf(src))
			to_chat(usr, span_notice("E.G.O extracted successfully!"))
			qdel(src)
		if("No")
			to_chat(usr, span_notice("You decide not to extract from the abnormality."))
	return

/obj/item/abno_core_injector/teth
	name = "E.G.O solidification unit - T"
	icon_state = "ncorp_syringe4"
	energy = 25
	custom_price = 100

/obj/item/abno_core_injector/teth/examine(mob/user)
	. = ..()
	. += span_notice("It can extract E.G.O up to the risk level TETH.")


/obj/item/abno_core_injector/he
	name = "E.G.O solidification unit - H"
	icon_state = "ncorp_syringe3"//make this unique
	energy = 45
	custom_price = 200

/obj/item/abno_core_injector/he/examine(mob/user)
	. = ..()
	. += span_notice("It can extract E.G.O up to the risk level HE.")

/obj/item/abno_core_injector/waw
	name = "E.G.O solidification unit - W"
	icon_state = "ncorp_syringe1"
	energy = 75
	custom_price = 500

/obj/item/abno_core_injector/waw/examine(mob/user)
	. = ..()
	. += span_notice("It can extract E.G.O up to the risk level WAW. Due to the exorbitant amount of energy needed to manufacture these, these are reserved for emergencies.")

//Training Manual
/obj/item/stat_equalizer/mining//do stuff to give other corporations more or less favorable stat spreads
	name = "lobotomy corp training manual"
	desc = "A source of stats, governed by the condition of the nearby facility."
	icon = 'icons/obj/library.dmi'
	icon_state = "lobotomy_book"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	custom_price = 1

/obj/item/stat_equalizer/mining/attack_self(mob/living/carbon/human/user)
	update_stats(user)
	to_chat(user, span_notice("Your attributes have been updated."))

/obj/item/stat_equalizer/mining/attack(mob/living/M, mob/user)
	return

/obj/item/stat_equalizer/mining/update_stats(mob/living/carbon/human/user)//TODO: make subtypes of this for specific corporations with stat specializations. Stuff like +20% temperance for Lobco or +20% fort (mining speed) for X corp.
	var/list/attribute_list = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)
	var/set_attribute = 20
	var/facility_full_percentage = 0
	var/repaired_machines = GLOB.lobotomy_repairs
	var/total_machines = GLOB.lobotomy_damages
	if(GLOB.lobotomy_damages) // dont divide by 0
		facility_full_percentage = 100 * (repaired_machines / total_machines)
	// % of machines repaired
	switch(facility_full_percentage)
		if(5 to 19)
			set_attribute *= 1.5
		if(19 to 34)
			set_attribute *= 2
		if(34 to 49)
			set_attribute *= 2.5
		if(49 to 59)
			set_attribute *= 3
		if(59 to 69)
			set_attribute *= 3.5
		if(69 to 100)
			set_attribute *= 4
	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS)
	for(var/A in attribute_list)
		var/processing = get_raw_level(user, A)
		if(processing <= set_attribute)//sets each attribute below set_attribute to 0, then raises them by that amount.
			user.adjust_attribute_level(A, -1*processing)
			user.adjust_attribute_level(A, set_attribute)
	to_chat(user, span_notice("You feel ready for combat."))
