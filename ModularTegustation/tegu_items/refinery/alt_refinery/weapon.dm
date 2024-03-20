/obj/structure/altrefiner/weapon
	name = "EGO Refinery"
	desc = "A machine used by the Extraction Officer to automatically melt EGO and potentially spit out a refined PE."
	icon_state = "dominator-green"
	var/list/meltable

/obj/structure/altrefiner/weapon/Initialize()
	var/list/processing = list(/obj/item/ego_weapon, /obj/item/gun/ego_gun, /obj/item/clothing/suit/armor/ego_gear)
	for(var/Y in processing)
		meltable += subtypesof(Y)
	..()

/obj/structure/altrefiner/weapon/attackby(obj/item/I, mob/living/user, params)
	if(user?.mind?.assigned_role != "Extraction Officer")
		to_chat(user, span_warning("Only the Extraction Officer can use this machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	if(!(I.type in meltable))
		to_chat(user, span_warning("Only EGO is accepted by the machine."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return


	qdel(I)
	if(prob(50))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(user, span_warning("Refining failure. Please try again."))
		return

	to_chat(user, span_notice("Refining success."))
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	new /obj/item/refinedpe(get_turf(src))


