
/// Fires an execution bullet at the player
/datum/smite/execution
	name = "An Execution Bullet"

/datum/smite/execution/effect(client/user, mob/living/target)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.unequip_everything()
		H.Stun(10)
	playsound(get_turf(target), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
	new /obj/effect/temp_visual/execute_bullet(get_turf(target))
	QDEL_IN(target, 1)
