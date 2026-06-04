// Copper watch
// A quick revive, but only works on intact corpses. Using it halves the user's HP.
/obj/item/records_revive
	name = "records copper watch"
	desc = "A high-tech handheld watch that restores a staff member's biological data from realtime backups at great personal expense. Requires an intact body."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'//also lmao its called teguitems there
	icon_state = "watch_copper"
	var/energy = 0
	var/maximum_energy = 40
	w_class = WEIGHT_CLASS_SMALL

/obj/item/records_revive/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("This watch seems to be upgraded, the amount of charge it gains is increased by 25%.")
	. += "Use this watch on a dead body or a dying person to revive them to full health."
	. += "This tool requires 40 NE to perform a revive."
	. += "WARNING : This watch is inherently unstable, using it will reduce your current health by half."
	. += "Currently storing [energy]/[maximum_energy] Negative Enkephalin."
	. += "This tool is recharged as agents complete work on abnormalities and defeat ordeals."

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
	maximum_energy += 10

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
	if(H == user_human)
		to_chat(user, span_warning("You cannot save yourself this way!"))
		return
	if(H.stat == CONSCIOUS)
		to_chat(user, span_warning("[H] is fine!"))
		return
	// Check cooldown
	if(energy < 40)
		to_chat(user, span_warning("The [src] does not have enough energy for this function."))
		return
	DoRevive(H, user)

/obj/item/records_revive/proc/DoRevive(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!H)
		return FALSE
	H.revive(full_heal = TRUE, admin_revive = TRUE)
	H.grab_ghost()
	AdjustNE(-40)
	playsound(user, 'sound/creatures/lc13/clockhead/rewind.ogg', 50, FALSE)
	user.apply_damage((user.health * 0.5), BRUTE)
