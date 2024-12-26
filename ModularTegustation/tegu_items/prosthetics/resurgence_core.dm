/obj/item/organ/cyberimp/chest/resurgence_core
	name = "Resurgence Core"
	desc = "Resurgence Core"
	syndicate_implant = TRUE
	actions_types = list(/datum/action/item_action/organ_action/use/resurgence_core)


/datum/action/item_action/organ_action/use/resurgence_core
	var/tp_distance = 2

/datum/action/item_action/organ_action/use/resurgence_core/Trigger()
	if(!IsAvailable())
		return

	var/turf/T
	if(owner.dir == 1)
		T = locate(owner.x, owner.y + tp_distance, owner.z)
	if(owner.dir == 2)
		T = locate(owner.x, owner.y - tp_distance, owner.z)
	if(owner.dir == 4)
		T = locate(owner.x + tp_distance, owner.y, owner.z)
	if(owner.dir == 8)
		T = locate(owner.x - tp_distance, owner.y, owner.z)

	if(T.density)
		to_chat(owner, "Cannot teleport there")
		return
	if(T.x>world.maxx || T.x<1)
		to_chat(owner, "Cannot teleport there")
		return
	if(T.y>world.maxy || T.y<1)
		to_chat(owner, "Cannot teleport there")
		return
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner

		human.adjustSanityLoss(human.maxSanity * 0.05)
		human.loc = T
