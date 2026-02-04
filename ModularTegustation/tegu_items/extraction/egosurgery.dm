//EO E.G.O. Upgrade tool
/obj/item/extraction/upgrade_tool
	name = "E.G.O. Interface Unit"
	desc = "A seemingly endless switchtool used to upgrade E.G.O. weapons, only usable by the extraction officer."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ego_surgery_empty"
	w_class = WEIGHT_CLASS_TINY
	var/energy = 0
	var/maximum_energy = 5
	var/target_item = null
	var/current_progress = 0
	var/random_sound_list = list( // Random surgery sound for every step
		'sound/items/jaws_pry.ogg',
		'sound/items/drill_use.ogg',
		'sound/items/welder.ogg',
		'sound/items/ratchet.ogg',
		'sound/items/zip.ogg',
		'sound/weapons/circsawhit.ogg',
		'sound/weapons/blade1.ogg',
		'sound/weapons/sear.ogg',
	)

/obj/item/extraction/upgrade_tool/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice("This tool seems to be upgraded, increases the total damage gain to +20%.")

/obj/item/extraction/upgrade_tool/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED, PROC_REF(WorkCharge))
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OrdealCharge))
	if(SSlobotomy_corp.next_ordeal_level > 2) // next_ordeal_level is 2 at roundstart
		maximum_energy = (5 + (5 * (SSlobotomy_corp.next_ordeal_level - 2))) // The math is weird on this - next_ordeal_level is the ordeal AFTER the one about to spawn, so 2 higher.

/obj/item/extraction/upgrade_tool/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END)
	return ..()

/obj/item/extraction/upgrade_tool/proc/WorkCharge()
	SIGNAL_HANDLER
	AdjustEnkephalin(0.25)

/obj/item/extraction/upgrade_tool/proc/OrdealCharge(datum/source, datum/ordeal/O = null)
	SIGNAL_HANDLER
	if(!istype(O))
		return
	maximum_energy = (5 + (5 * O.level))
	AdjustEnkephalin(floor(maximum_energy / 2))

/obj/item/extraction/upgrade_tool/proc/AdjustEnkephalin(addition)
	energy = clamp(energy + addition, 0, maximum_energy)
	update_icon()

/obj/item/extraction/upgrade_tool/examine(mob/user)
	. = ..()
	. += span_notice("This tool's maximum charge increases as each ordeal is cleared.")
	. += "Currently storing [energy]/[maximum_energy] Negative Enkephalin."
	. += "This tool is recharged as agents complete work on abnormalities and defeat ordeals."
	if(energy < 5)
		. += "This tool requires a minimum of 5 NE to perform a successful modification."


/obj/item/extraction/upgrade_tool/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(!tool_checks(user))
		return FALSE // You can't do any special interactions
	if(energy < 1)
		to_chat(user, span_warning("The [src] is out of energy!"))
		return FALSE
	if(target_item)
		if(A != target_item)
			to_chat(user, span_notice("You decide to stop operating on [target_item]."))
			target_item = null
			return

		if(current_progress < 4)
			ToolAttempt(user)
			if(!do_after(user, 50, A))
				ToolFailure(user)
				return
			ToolProgress(user)
			return

		else // they got it
			ToolAttempt(user)
			if(!do_after(user, 50, A))
				ToolFailure(user)
				return
			ToolComplete(user)
			return
	var/multiplier_cap = 1.10
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		multiplier_cap = 1.20
	if(is_ego_melee_weapon(A))
		var/obj/item/ego_weapon/theweapon = A
		if(theweapon.force_multiplier >= multiplier_cap)
			to_chat(user, span_warning("You can't modify this any further!"))
			return
		target_item = theweapon
		ToolPrepare(user)

	else if(is_ego_weapon(A))
		var/obj/item/ego_weapon/ranged/thegun = A
		if(thegun.projectile_damage_multiplier >= multiplier_cap)
			to_chat(user, span_warning("You can't modify this any further!"))
			return
		target_item = thegun
		ToolPrepare(user)

	return FALSE

/obj/item/extraction/upgrade_tool/proc/ToolPrepare(mob/user)
	if(!target_item)
		return
	to_chat(user, span_warning("You prepare [target_item] for modification!"))
	playsound(get_turf(user), 'sound/weapons/bladeslice.ogg', 50, TRUE)
	if(!do_after(user, 50, target_item))
		ToolFailure(user)
		return
	ToolProgress(user)

/obj/item/extraction/upgrade_tool/proc/ToolAttempt(mob/user)
	if(!target_item)
		return
	to_chat(user, span_warning("You continue to attempt to modify [target_item]!"))
	playsound(get_turf(user), "[pick(random_sound_list)]", 50, TRUE) // I should probably give each sound custom text but its funnier to leave it to the player's imagination

/obj/item/extraction/upgrade_tool/proc/ToolProgress(mob/user)
	if(!target_item)
		return
	to_chat(user, span_warning("You successfully proceed through the modification process!"))
	AdjustEnkephalin(-1)
	current_progress += 1

/obj/item/extraction/upgrade_tool/proc/ToolFailure(mob/user)
	if(!target_item)
		return
	to_chat(user, span_warning("You botch the improvement, losing NE and all progress!"))
	AdjustEnkephalin(-1)
	current_progress = 0
	target_item = null

/obj/item/extraction/upgrade_tool/proc/ToolComplete(user)
	if(!target_item)
		return
	var/multiplier_cap = 1.10
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		multiplier_cap = 1.20
	if(is_ego_melee_weapon(target_item))
		var/obj/item/ego_weapon/weapon = target_item
		weapon.force_multiplier = min(round(weapon.force_multiplier + 0.05, 0.01), multiplier_cap) // Add 5% to the force multiplier

	else if(is_ego_weapon(target_item))
		var/obj/item/ego_weapon/ranged/gun = target_item
		var/old_multiplier = gun.force_multiplier
		gun.force_multiplier = min(round(gun.force_multiplier + 0.05, 0.01), multiplier_cap)
		var/difference = gun.force_multiplier - old_multiplier
		if(difference > 0)
			gun.projectile_damage_multiplier *= (1 + difference) // Sure we COULD just set it equal to force_multiplier but that would break some guns

	to_chat(user, span_warning("You successfully improve [target_item]!"))
	target_item = null
	current_progress = 0
	AdjustEnkephalin(-1)
	playsound(get_turf(user), 'sound/machines/ding.ogg', 50, TRUE)

/obj/item/extraction/upgrade_tool/update_icon()
	if(energy >= (5 - current_progress)) //Able to complete at least one procedure
		icon_state = "ego_surgery"
		return

	icon_state = "ego_surgery_empty"
