/obj/item/organ/cyberimp/chest/resurgence_core
	name = "Resurgence Clan Augment: Echo Step"
	desc = "An augment designed by the resurgence clan, which lets the user teleport a short distance a the cost of their sanity."
	syndicate_implant = TRUE
	actions_types = list(/datum/action/item_action/organ_action/use/resurgence_core)
	implant_overlay = "chest_resurgence_core"

/datum/action/item_action/organ_action/use/resurgence_core
	var/tp_distance = 2

/datum/action/item_action/organ_action/use/resurgence_core/Trigger()
	if(!IsAvailable())
		return
	get_teleport_loc()
	var/turf/T
	if(owner.dir == 1)
		T = get_teleport_loc(owner.loc, owner, tp_distance, FALSE, 0, 0, 0, tp_distance)
	if(owner.dir == 2)
		T = get_teleport_loc(owner.loc, owner, tp_distance, FALSE, 0, 0, 0, (-1 * tp_distance))
	if(owner.dir == 4)
		T = get_teleport_loc(owner.loc, owner, tp_distance, FALSE, 0, 0, tp_distance, 0)
	if(owner.dir == 8)
		T = get_teleport_loc(owner.loc, owner, tp_distance, FALSE, 0, 0, (-1 * tp_distance), 0)
	if(T.density)
		to_chat(owner, span_danger("ERROR: Dense object detected in Echo Step destination."))
		return
	if(T.x>world.maxx || T.x<1)
		to_chat(owner, span_danger("ERROR: Dense object detected in Echo Step destination."))
		return
	if(T.y>world.maxy || T.y<1)
		to_chat(owner, span_danger("ERROR: Dense object detected in Echo Step destination."))
		return
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		playsound(owner, 'sound/effects/contractorbatonhit.ogg', 20, FALSE, 9)
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(owner))
		if (T in view(tp_distance, owner))
			human.adjustSanityLoss(human.maxSanity * 0.025)
		else
			human.adjustSanityLoss(human.maxSanity * 0.25)
			to_chat(human, span_danger("WARNING: Echo Step destination is not visible, increasing power usage by 1000%."))
		human.loc = T
		new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(owner))
