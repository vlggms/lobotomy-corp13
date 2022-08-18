/obj/projectile/ego_bullet
	damage = 10
	damage_type = RED_DAMAGE
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	wound_bonus = -100
	bare_wound_bonus = -100

/obj/projectile/ego_bullet/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if (!istype(target, /mob/living/))
		return
	if(istype(target, /mob/living/simple_animal/hostile/ordeal))
		var/mob/living/simple_animal/hostile/ordeal/cooler_target = target
		if (cooler_target.stat != DEAD && !(firer in cooler_target.contributers))
			cooler_target.contributers += firer
		return


