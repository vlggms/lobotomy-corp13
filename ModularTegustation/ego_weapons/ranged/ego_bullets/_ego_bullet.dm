/obj/projectile/ego_bullet
	damage = 10
	damage_type = RED_DAMAGE
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	wound_bonus = -100
	bare_wound_bonus = -100
	speed = 0.4
	var/ff_multiplier= 0.5
	var/old_mult = 0

/obj/projectile/ego_bullet/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	if(old_mult)
		damage_multiplier = old_mult
		old_mult = 0
	if(ishuman(target) && ishuman(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/carbon/human/user = firer
		if(!(user.sanity_lost || H.sanity_lost))
			if(ff_multiplier == 0)
				impacted[H] = TRUE
				return
			old_mult = damage_multiplier
			damage_multiplier *= ff_multiplier
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
