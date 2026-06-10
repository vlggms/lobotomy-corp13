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
				impacted[L] = TRUE
				return
	return ..()

/obj/projectile/ego_bullet/proc/GetHomingTarget(target_range = 4)
	var/mob/living/target = null
	var/mob/living/shooter = null
	if(firer && isliving(firer))
		shooter = firer
	// We need our shooter to be a living mob for a faction check
	if(!shooter)
		return null
	var/current_dist = 0
	for(var/mob/living/L in circleview(src, target_range))
		// Make sure the mob we're checking doesnt have the same factor, nor is dead.
		if(shooter.faction_check_mob(L))
			continue
		if(L.stat == DEAD)
			continue
		if(!target)
			var/dx = (pixel_x/32) + x - L.x
			var/dy = (pixel_y/32) + y - L.y

			// We save the selected target's distance incase we need to compare it
			current_dist = dx**2 + dy**2
			target = L
		else
			var/dx = (pixel_x/32) + x - L.x
			var/dy = (pixel_y/32) + y - L.y

			var/dist = dx**2 + dy**2
			// Check if the distance of the mob is less than the current selected targets's distance or if they're the same, make it a coin flip.
			if(dist < current_dist || (dist == current_dist && prob(50)))
				current_dist = dist
				target = L
	//We dont have a target!
	if(!target)
		return null
	return target