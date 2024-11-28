/*
* Work console upgrades.
*/
/obj/item/work_console_upgrade
	name = "chemical extraction cell upgrade"
	desc = "Attaches to the abnormality cell console of completely understood abnormalities and allows for the extraction of enkephalin-derived substances."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "abnochem_attachment"
	var/upgrade_slot = ""

/obj/item/work_console_upgrade/attack_obj(obj/O, mob/living/user)
	if(istype(O, /obj/machinery/computer/abnormality))
		var/obj/machinery/computer/abnormality/work_machine = O
		to_chat(user, span_notice("You start attaching \the [O] to \the [src]..."))
		if(!UpgradeReq(O, user))
			return
		work_machine.InstallUpgrade(src,upgrade_slot)
		src.desc += "\n[src] installation successful."
		playsound(get_turf(O), 'sound/effects/servostep.ogg', 50, TRUE)
		return
	return ..()

/obj/item/work_console_upgrade/proc/UpgradeReq(obj/machinery/computer/abnormality/A, mob/living/installer)
	if(!A)
		return FALSE
	if(A.mechanical_upgrades[upgrade_slot])
		to_chat(installer, span_notice("Theres already a upgrade of this type installed."))
		return FALSE
	return TRUE

//Upgrade Subtypes

/obj/item/work_console_upgrade/chemical_extraction_attachment
	name = "chemical extraction cell upgrade"
	desc = "Attaches to the abnormality cell console of completely understood abnormalities and allows for the extraction of enkephalin-derived substances."
	upgrade_slot = "abnochem"

/obj/item/work_console_upgrade/chemical_extraction_attachment/UpgradeReq(obj/machinery/computer/abnormality/A, mob/living/installer)
	. = ..()
	//If the root code returns FALSE just return that.
	if(!.)
		return
	if(A.datum_reference.understanding < A.datum_reference.max_understanding)
		to_chat(installer, span_notice("Abnormality is not yet fully understood."))
		return FALSE

/obj/item/work_console_upgrade/work_prediction_attachment
	name = "predictive workrate formula upgrade"
	desc = "Using information collected from employee files and security footage this upgrade allows the user to see their success rate."
	upgrade_slot = "workrate"
	color = COLOR_SOFT_RED
