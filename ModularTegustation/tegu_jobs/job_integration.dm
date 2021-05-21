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
	if (assignment in GLOB.tegu_job_cards)
		return 'ModularTegustation/Teguicons/cards.dmi'

	else if (!linkedJobType || assignment == "Unassigned")
		return 'icons/obj/card.dmi'

	return initial(linkedJobType.id_icon)

// Used to assign the HUD icon linked to the job ID Card.
/obj/item/card/id/proc/return_icon_hud()
	if (assignment in GLOB.tegu_job_assignment)
		return 'ModularTegustation/Teguicons/teguhud.dmi'

	else if (!linkedJobType || assignment == "Unassigned")
		return 'icons/mob/hud.dmi'

	return initial(linkedJobType.hud_icon)
