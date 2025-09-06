//EO Lock -- Making it a subtype saves on copypaste
/obj/item/extraction/lock
	name = "Qliphoth Locking Mechanism"
	desc = "Use on a work console to raise the qliphoth suppression field of the abnormality cell."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "lock_active"
	w_class = WEIGHT_CLASS_SMALL
	var/howtouse = "This tool can only be used on a containment cell that has reached 100% understanding. <br>This tool forcibly raises the target abnormality's Qliphoth Counter to by one. <br>\
	WARNING : This tool may not work on abnormalities with specific needs. <br>Additionally, this device has a longer cooldown when used on more powerful abnormalities."
	var/recharging = FALSE
	var/cooldown_time

/obj/item/extraction/lock/update_icon()
	if(recharging)
		icon_state = "lock"
		return
	icon_state = "lock_active"

/obj/item/extraction/lock/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice("This tool seems to be upgraded, decreasing cooldown by 20%.")
	if(recharging)
		var/time_left = round(timeleft(cooldown_time))
		. +=  span_redtext("This device is on cooldown. It will be ready in [DisplayTimeText(time_left)].")
	. += howtouse

/obj/item/extraction/lock/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(!tool_checks(user))
		return FALSE // You can't do any special interactions
	if(istype(A, /obj/machinery/computer/abnormality))
		var/obj/machinery/computer/abnormality/target = A
		if(!target.datum_reference) // Probably bugged if this happens
			to_chat(user, span_warning("If you are seeing this message, this console is not linked to an abnormality. This is likely a bug, so please report it!"))
			return TRUE
		if(!target.datum_reference.current) // Not a contained abno
			to_chat(user, span_warning("This abnormality is currently absent or respawning. Try again later."))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(!target.datum_reference.current.IsContained()) // Already breached
			to_chat(user, span_warning("Too late! This abnormality has already breached!"))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(target.datum_reference.understanding < (target.datum_reference.max_understanding)) // Understanding under 100%
			to_chat(user, span_warning("This device does not work on an abnormality that is not fully understood."))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(target.datum_reference.qliphoth_meter >= (target.datum_reference.qliphoth_meter_max)) // Not missing any Qliphoth
			to_chat(user, span_warning("This abnormality is already at its maximum Qliphoth counter."))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(recharging) // Device is on cooldown
			to_chat(user, span_warning("This tool is still recharging!"))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return FALSE
		if(istype(target.datum_reference.current, /mob/living/simple_animal/hostile/abnormality/black_swan)) // Stops certain abnos from bricking themselves.
			to_chat(user, span_warning("ERROR : Not compatiable with this abnormality!"))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		var/multiplier = target.datum_reference.current.threat_level
		var/recharge_time = (multiplier * multiplier * 30) SECONDS
		if(GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
			recharge_time *= 0.8
		cooldown_time = addtimer(CALLBACK(src, PROC_REF(Recharge)), recharge_time, TIMER_STOPPABLE)
		target.datum_reference.qliphoth_change(1)
		recharging = TRUE
		user.playsound_local(user, 'sound/magic/arbiter/pin.ogg', 35, FALSE)
		to_chat(user, span_nicegreen("Qliphoth Counter has been raised successfully!"))
		update_icon()
		return TRUE
	to_chat(user, span_warning("ERROR : Device application failure - Invalid Target!"))
	return FALSE  // Not a console - just hit the thing

/obj/item/extraction/lock/proc/Recharge()
	playsound(src, 'sound/machines/twobeep.ogg', 25, FALSE)
	recharging = FALSE
	visible_message(span_notice("The [src] lights up!"))
	update_icon()
