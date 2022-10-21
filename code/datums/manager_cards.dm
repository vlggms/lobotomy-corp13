/datum/manager_card
	/// Short name, nothing that exactly gives away its nature
	var/name = "Bug Card"
	/// Its description that will be shown when selected on the console
	var/desc = "This card does absolutely nothing with the facility, you, or the round. \n\
	Your best option here is to notify admins and/or maintainers."
	/// Its tier. Used for timing its appearence. 1 is round-start, 2 is after dawn, so on and so on...
	var/tier = -1

/// If it returns TRUE - it can be added to the current list
/datum/manager_card/proc/Available()
	return TRUE

/// Its effect on activation
/datum/manager_card/proc/Activate(mob/user)
	return

/* Tier 1 */
/datum/manager_card/test
	name = "Boom Card"
	desc = "This card explodes your head."
	tier = 1

/datum/manager_card/test/Activate(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/head/head = H.get_bodypart("head")
	if(QDELETED(head))
		return
	head.dismember()
	QDEL_NULL(head)
	H.regenerate_icons()
	H.visible_message("<span class='danger'>[H]'s head explodes!</span>")
	new /obj/effect/gibspawner/generic/silent(get_turf(H))
	playsound(get_turf(user), 'sound/abnormalities/silentorchestra/headbomb.ogg', 50, 1)
	return

/datum/manager_card/bwoink
	name = "Bwoink Card"
	desc = "This card bwoinks you."
	tier = 1

/datum/manager_card/bwoink/Activate(mob/user)
	if(!ishuman(user))
		return
	playsound(get_turf(user), 'sound/effects/adminhelp.ogg', 50, 1)
	return
