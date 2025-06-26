/obj/structure/altrefiner/weapon
	name = "EGO Refinery"
	desc = "A machine used by the Extraction Officer to automatically melt EGO and potentially spit out a refined PE."
	icon_state = "dominator-green"
	requires_item = TRUE
	var/list/meltable

/obj/structure/altrefiner/weapon/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "This machine seems to be upgraded, decreasing fail chance.")

/obj/structure/altrefiner/weapon/Initialize(mapload)
	var/list/processing = list(/obj/item/ego_weapon, /obj/item/ego_weapon/ranged, /obj/item/clothing/suit/armor/ego_gear)
	var/list/banned = list(/obj/item/ego_weapon/city/ncorp_mark)
	for(var/Y in processing)
		meltable += subtypesof(Y)
	for(var/X in banned)
		meltable -= subtypesof(X)
	return ..()

/obj/structure/altrefiner/weapon/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!.)
		return

	if(!(I.type in meltable))
		to_chat(user, span_warning("Only EGO is accepted by the machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return
	var/fail_chance = 50
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		fail_chance = 30
	qdel(I)
	if(prob(fail_chance))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(user, span_warning("Refining failure. Please try again."))
		return

	to_chat(user, span_notice("Refining success."))
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	new /obj/item/refinedpe(get_turf(src))
