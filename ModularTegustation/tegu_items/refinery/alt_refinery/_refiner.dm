/obj/structure/altrefiner
	name = "Unknown refinery"
	desc = "Contact a coder immediately!"
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator-blue"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	/// Toggles if only extraction officers can use the alt refinery
	var/officer_only = TRUE
	/// the PE cost that the refinery consumes upon use
	var/extraction_cost = 0

/obj/structure/altrefiner/Initialize(mapload)
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/altrefiner/attack_hand(mob/living/carbon/M)
	. = ..()
	SHOULD_CALL_PARENT(TRUE) // bit akward when you forget a parent call to an object that should most definetelly have it
	if(officer_only && M?.mind?.assigned_role != "Extraction Officer")
		to_chat(M, span_warning("Only the Extraction Officer can use this machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return FALSE

	if(SSlobotomy_corp.available_box < extraction_cost)
		to_chat(M, span_warning("Not enough PE boxes stored for this operation. [extraction_cost] PE is necessary for this operation. Current PE: [SSlobotomy_corp.available_box]."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return FALSE

	SSlobotomy_corp.AdjustAvailableBoxes(-1 * extraction_cost)
	return TRUE

/obj/structure/altrefiner/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	SHOULD_CALL_PARENT(TRUE) // yeah, it is
	if(officer_only && user?.mind?.assigned_role != "Extraction Officer")
		to_chat(user, span_warning("Only the Extraction Officer can use this machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return FALSE

	if(SSlobotomy_corp.available_box < extraction_cost)
		to_chat(user, span_warning("Not enough PE boxes stored for this operation. \n[extraction_cost] PE is necessary for this operation. Current PE: [SSlobotomy_corp.available_box]."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return FALSE

	SSlobotomy_corp.AdjustAvailableBoxes(-1 * extraction_cost)
	return TRUE

/obj/structure/altrefiner/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

GLOBAL_LIST_INIT(unspawned_refiners, list(
	/obj/structure/altrefiner/blood,
	/obj/structure/altrefiner/quick,
	/obj/structure/altrefiner/timed,
	/obj/structure/altrefiner/weapon,
))

/obj/effect/landmark/refinerspawn
	name = "alt-refinery spawner"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/refinerspawn/Initialize(mapload)
	..()
	if(!LAZYLEN(GLOB.unspawned_refiners))
		return INITIALIZE_HINT_QDEL
	var/obj/structure/altrefiner/spawning = pick_n_take(GLOB.unspawned_refiners)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL


