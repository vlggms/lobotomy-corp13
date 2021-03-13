/*
 *	This file is for any additions related to jobs to make tegu-only jobs
 *	functional with little conflict.
 *
 *
 *
 */


		//	ID CARDS	//

/obj/item/card
	var/datum/job/linkedJobType         // This is a TYPE, not a ref to a particular instance. We'll use this for finding the job and hud icon of each job.

// Used in overwrites to assign the ID card's icon.
/obj/item/card/id/proc/return_icon_job()
	if (!linkedJobType || assignment == "Deputy") // Using the global list here breaks Tegu Job's ID Card Overlays.
		return 'ModularTegustation/Teguicons/cards.dmi'

	if (!linkedJobType || assignment == "Geneticist") // Using the global list here breaks Tegu Job's ID Card Overlays.
		return 'ModularTegustation/Teguicons/cards.dmi'

	if (!linkedJobType || assignment == "Unassigned")
		return 'icons/obj/card.dmi'

	return initial(linkedJobType.id_icon)

// Used to assign the HUD icon linked to the job ID Card.
/obj/item/card/id/proc/return_icon_hud()
	if (assignment in GLOB.tegu_job_assignment)
		return 'ModularTegustation/Teguicons/teguhud.dmi'

	if (!linkedJobType || assignment == "Unassigned")
		return 'icons/mob/hud.dmi'

	return initial(linkedJobType.hud_icon)


		//	JOBS	//

/datum/job
	var/id_icon = 'icons/obj/card.dmi'	// Overlay on your ID
	var/hud_icon = 'icons/mob/hud.dmi'	// Sec Huds see this

/datum/job/tegu
	var/tegu_spawn = null //give it a room's type path to spawn there

/datum/job/tegu/after_spawn(mob/living/H, mob/M, latejoin)
	if(!latejoin && tegu_spawn)
		var/turf/T = get_tegu_spawn(tegu_spawn)
		H.Move(T)

/proc/get_tegu_spawn(area/room) // Reworked to find any empty tile
	for(var/turf/T in shuffle(get_area_turfs(room)))
		if(!T.is_blocked_turf(TRUE))
			return T
