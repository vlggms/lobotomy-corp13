/obj/projectile/ego_bullet
	damage = 10
	damage_type = RED_DAMAGE
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	wound_bonus = -100
	bare_wound_bonus = -100
	speed = 0.4

/obj/projectile/ego_bullet/on_hit(target)
	var/mob/living/carbon/human/user = firer
	if(ishuman(target) && ishuman(firer) && !user.sanity_lost)
		var/list/immune = list("Sephirah", "Extraction Officer")		//These people should never be killed.
		var/mob/living/carbon/human/newtarget = target
		if(newtarget.mind)
			if(newtarget.mind.assigned_role in immune)
				return BULLET_ACT_BLOCK
	..()
