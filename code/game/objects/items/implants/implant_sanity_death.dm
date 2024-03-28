/obj/item/implant/sanity_death
	name = "R corp implant"
	desc = "And boom goes the weasel."
	icon_state = "explosive"
	actions_types = list()
	var/delay = 5

/obj/item/implant/sanity_death/proc/on_sanity_loss(datum/source, attribute)
	SIGNAL_HANDLER

	// There may be other signals that want to handle mob's death
	// and the process of activating destroys the body, so let the other
	// signal handlers at least finish. Also, the "delayed explosion"
	// uses sleeps, which is bad for signal handlers to do.
	INVOKE_ASYNC(src, PROC_REF(activate))

/obj/item/implant/sanity_death/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> R Corp Self-Destruct Implant<BR>
				<b>Life:</b> Activates upon 100% mental corruption.<BR>
				<b>Important Notes:</b> Decapitates the target<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon host achieving maximum level of mental corruption.<BR>
				"}
	return dat

/obj/item/implant/sanity_death/activate()
	. = ..()
	if(!imp_in )
		return 0
	timed_explosion()

/obj/item/implant/sanity_death/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(.)
		RegisterSignal(target, COMSIG_HUMAN_INSANE, PROC_REF(on_sanity_loss))

/obj/item/implant/sanity_death/proc/timed_explosion()
	if(!ishuman(imp_in))
		return
	var/mob/living/carbon/human/H = imp_in
	H.visible_message("<span class='warning'>Implant in [H] blares a loud alarm!</span>")
	playsound(loc, 'sound/items/sanity_implant_alert.ogg', 50, FALSE)
	sleep(delay)
	playsound(loc, 'sound/items/sanity_implant_explode.ogg', 30, TRUE)
	var/obj/item/bodypart/head/head = H.get_bodypart("head")
	if(QDELETED(head))
		H.gib()
		qdel(src)
		return
	head.dismember()
	QDEL_NULL(head)
	H.regenerate_icons()
	H.visible_message("<span class='danger'>[H]'s head explodes!</span>")
	new /obj/effect/gibspawner/generic/silent(get_turf(H))
	qdel(src)
