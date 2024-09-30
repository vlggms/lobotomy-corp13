//LOBOTOMY CORPORATION - the "default" faction with a focus on E.G.O and abnormalities.

/obj/item/abno_core_injector
	name = "E.G.O solidification unit - Z"
	desc = "A single-use device that constructs an E.G.O using a sample from an abnormality core."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"
	custom_price = 100
	var/energy = 12
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
	energy = 20
	custom_price = 300

/obj/item/abno_core_injector/teth/examine(mob/user)
	. = ..()
	. += span_notice("It can extract E.G.O up to the risk level TETH.")


/obj/item/abno_core_injector/he
	name = "E.G.O solidification unit - H"
	icon_state = "ncorp_syringe3"//make this unique
	energy = 35
	custom_price = 500

/obj/item/abno_core_injector/he/examine(mob/user)
	. = ..()
	. += span_notice("It can extract E.G.O up to the risk level HE.")

/obj/item/abno_core_injector/waw
	name = "E.G.O solidification unit - W"
	icon_state = "ncorp_syringe1"
	energy = 50
	custom_price = 1500

/obj/item/abno_core_injector/waw/examine(mob/user)
	. = ..()
	. += span_notice("It can extract E.G.O up to the risk level WAW. Due to the exorbitant amount of energy needed to manufacture these, these are reserved for emergencies.")
