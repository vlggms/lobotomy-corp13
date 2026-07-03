/obj/item/ego_weapon/officer/extraction
	name = "officer ring"
	icon_state = "officer_ring"
	desc = "A black ring that can tap into a small bit of a singularity from a former G-Corp. Used by the Extraction Officer "
	force = 5
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	knockback = KNOCKBACK_MEDIUM
	attack_verb_continuous = list("punts", "bashes")
	attack_verb_simple = list("punts", "bash")
	level_to_force = list(5, 8, 12, 18, 28)
	allowed_roles = list("Extraction Officer")
	special = "This weapon has a ranged attack that will jump from targets to target.\nUse in hand to cast a shockwave that pushes back anything damaged by it."
	extra_text = "This weapon can only be wielded by the Extraction Officer. This weapon also increases in power the more ordeals are defeated."
	var/fairy_cooldown
	var/shockwave_cooldown
	var/fairy_cooldown_time = 3 SECONDS
	var/shockwave_cooldown_time = 8 SECONDS
	var/list/fairy_damage = list(15,25,40,60,100)
	var/list/shockwave_damage = list(10,20,35,50,75)
	var/charging_attack = FALSE
	var/shockwave_range = 6

/obj/item/ego_weapon/officer/extraction/attack_self(mob/living/user)
	if(!CanUseEgo(user) || charging_attack)
		return
	if(shockwave_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		charging_attack = TRUE
		playsound(user, 'sound/magic/arbiter/pillar_start.ogg', 50, TRUE)
		if(!do_after(user, 5))
			charging_attack = FALSE
			return
		charging_attack = FALSE
		var/list/turfs = circleview(proj_turf, 6)
		playsound(user, 'sound/magic/arbiter/repulse.ogg', 50, TRUE)
		for(var/i = 0 to shockwave_range)
			addtimer(CALLBACK(src, PROC_REF(shockwave), turfs,proj_turf,i, user), i)
		shockwave_cooldown = world.time + shockwave_cooldown_time
		return

/obj/item/ego_weapon/officer/extraction/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user) || charging_attack)
		return
	if(!proximity_flag && fairy_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		charging_attack = TRUE
		playsound(user, 'sound/magic/arbiter/pillar_start.ogg', 50, TRUE)
		if(!do_after(user, 3))
			charging_attack = FALSE
			return
		charging_attack = FALSE
		playsound(user, 'sound/magic/arbiter/fairy.ogg', 50, TRUE)
		fairy_cooldown = world.time + fairy_cooldown_time
		var/obj/projectile/beam/officer/F = new(proj_turf)
		F.firer = user
		F.preparePixelProjectile(target, user, clickparams)
		F.damage = fairy_damage[current_level]
		F.damage *= force_multiplier
		F.fire()
		return

/obj/item/ego_weapon/officer/extraction/proc/shockwave(list/turfs, turf/start, distance, mob/living/user)
	for(var/turf/T in turfs)
		if(get_dist_euclidian(start, T) <= distance + 0.3 && get_dist_euclidian(start, T) >= max(0,distance - 0.5))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/L in T) //knocks enemies away from you
				if(L == user || ishuman(L))
					continue
				L.apply_damage(shockwave_damage[current_level] * force_multiplier, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
				var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, start)))
				if(!L.anchored)
					var/whack_speed = 10
					L.throw_at(throw_target, 2, whack_speed, user)

/obj/item/ego_weapon/officer/extraction/refresh_stats()
	force = level_to_force[current_level]
	if(current_level > 3)
		knockback = KNOCKBACK_HEAVY

/obj/effect/projectile/tracer/laser/officer
	icon_state = "sm_arc"
	icon = 'icons/effects/beam.dmi'

/obj/projectile/beam/officer
	name = "energy blast "
	icon_state = "omnilaser"
	color = COLOR_YELLOW
	light_color = COLOR_YELLOW
	tracer_type = /obj/effect/projectile/tracer/laser/officer
	hitscan = TRUE
	speed = 0.1
	hit_stunned_targets = TRUE
	white_healing = FALSE
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB) & (~PASSCLOSEDTURF))
	hitscan_light_color_override = COLOR_YELLOW
	muzzle_flash_color_override = COLOR_YELLOW
	impact_light_color_override = COLOR_YELLOW
	wound_bonus = -100
	bare_wound_bonus = -100
	damage = 10
	range = 10 // Don't want people shooting it through the entire facility
	var/detect_range = 4

/obj/projectile/beam/officer/on_hit(atom/target, blocked = FALSE)
	if(!isliving(target))
		return
	var/mob/living/user = firer
	var/mob/living/enemy = target
	if(user.faction_check_mob(enemy))
		return
	. = ..()
	damage *= 0.8
	if(damage < 1)
		qdel(src)
		return
	for(var/mob/living/L in range(detect_range, src))
		if(user.faction_check_mob(L))
			continue
		if( L == target)
			continue
		if(L in impacted)
			continue
		if(L.stat == DEAD)
			continue
		if(L.status_flags & GODMODE)
			continue
		range = 8
		preparePixelProjectile(L, src, null)
		xo = 16
		yo = 16
		return
	qdel(src)
