/// Turns Target Into A Book
/datum/smite/claw_execute
	name = "Claw Execute"

/datum/smite/claw_execute/effect(client/user, mob/living/target)
	. = ..()
	var/turf/origin = get_turf(target)
	var/list/all_turfs = origin.GetAtmosAdjacentTurfs(1)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		new /obj/effect/temp_visual/dir_setting/claw_appears (T)
		break
	new /obj/effect/temp_visual/justitia_effect(get_turf(target))
	if(ishuman(target))
		var/mob/living/carbon/human/executed = target
		for(var/obj/item/W in executed.contents)
			if(!executed.dropItemToGround(W))
				qdel(W)
	qdel(target)
