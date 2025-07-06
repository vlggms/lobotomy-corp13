// Conversion Status Effect - Applied when entering the conversion Z-level
/datum/status_effect/conversion_locked
	id = "conversion_locked"
	duration = -1 // Permanent until conversion or special removal
	alert_type = null
	status_type = STATUS_EFFECT_UNIQUE
	var/return_turf // Where to teleport them back if they try to leave

/datum/status_effect/conversion_locked/on_apply()
	. = ..()
	if(!.)
		return

	// Store their entry point
	return_turf = get_turf(owner)

	// Notify the player
	to_chat(owner, span_userdanger("Heavy factory doors slam shut behind you. There is no escape."))
	to_chat(owner, span_purple("The Tinkerer awaits. Your cure is inevitable."))

	// Make them unable to harm the Tinkerer
	ADD_TRAIT(owner, TRAIT_PACIFISM, "conversion_locked")

	// Register for teleportation attempts
	RegisterSignal(owner, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_z_change))

	return TRUE

/datum/status_effect/conversion_locked/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "conversion_locked")
	UnregisterSignal(owner, COMSIG_MOVABLE_Z_CHANGED)
	to_chat(owner, span_notice("The strange force holding you here dissipates."))
	return ..()

/datum/status_effect/conversion_locked/proc/on_z_change(datum/source, old_z, new_z)
	SIGNAL_HANDLER

	// If they somehow left the conversion Z-level, teleport them back
	var/turf/T = get_turf(owner)
	if(!is_conversion_zlevel(T.z))
		to_chat(owner, span_userdanger("An invisible force pulls you back!"))
		owner.forceMove(return_turf)

// Helper proc to check if a Z-level is the conversion Z-level (Tinkerer's factory)
/proc/is_conversion_zlevel(z_level)
	// This should be configured based on your map setup
	// For now, let's assume Z-level 3 is the factory level
	return z_level == 3 // Change this to match your actual factory Z-level

// Global proc to handle entering the conversion realm
/proc/enter_conversion_realm(mob/living/carbon/human/target)
	if(!ishuman(target))
		return FALSE

	// No checks needed - if the water brought them here, they're ready
	// The disease has progressed too far

	// Find the conversion realm spawn point
	var/turf/spawn_point = locate(50, 50, 3) // Default spawn coordinates - adjust based on your map

	// Look for a landmark if available
	for(var/obj/effect/landmark/conversion_spawn/CS in GLOB.landmarks_list)
		spawn_point = get_turf(CS)
		break

	if(!spawn_point)
		log_runtime("No conversion spawn point found!")
		return FALSE

	// Teleport them
	target.visible_message(span_warning("[target] is pulled beneath the waters!"), \
		span_userdanger("The dark waters engulf you completely!"))

	// Effects
	playsound(get_turf(target), 'sound/effects/splash.ogg', 100, TRUE)
	new /obj/effect/temp_visual/dir_setting/cult/phase/out(get_turf(target))

	// Move them
	target.forceMove(spawn_point)

	target.revive(TRUE, TRUE)

	// Arrival effects
	new /obj/effect/temp_visual/dir_setting/cult/phase(get_turf(target))
	playsound(get_turf(target), 'sound/magic/exit_blood.ogg', 100, TRUE)

	// Notify
	to_chat(target, span_purple("You find yourself in a vast factory. The smell of oil and machinery fills the air..."))

	return TRUE

// Landmark for conversion spawn points
/obj/effect/landmark/conversion_spawn
	name = "conversion spawn"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"

// City spawn points are handled by SScityevents.spawners instead
