/obj/projectile/ego_bullet
	damage = 10
	damage_type = RED_DAMAGE
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	wound_bonus = -100
	bare_wound_bonus = -100
	speed = 0.4
	var/smart_pass = FALSE

/obj/projectile/ego_bullet/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	if(smart_pass)
		if(isliving(target) && isliving(firer))
			var/mob/living/L = target
			var/mob/living/user = firer
			if(user.faction_check_mob(L)) // Our faction
				return
	return ..()