/*
 * Bleed Damage Skills (Level 2)
 * Combat skills that deal damage using the bleed status effect
 */

//=======================
// HEMORRHAGE
//=======================

/obj/item/book/granter/action/skill/bleed/hemorrhage
	name = "Level 2: Hemorrhage"
	desc = "Teleport to a selected target and instantly trigger stacks * 10 RED damage, removing all Bleed stacks."
	actionname = "Hemorrhage"
	granted_action = /datum/action/cooldown/skill/hemorrhage
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/hemorrhage
	name = "Hemorrhage"
	desc = "Teleport to a selected target and instantly trigger stacks * 10 RED damage, removing all Bleed stacks."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "hemorrhage"
	cooldown_time = 15 SECONDS
	var/selecting_target = FALSE

/datum/action/cooldown/skill/hemorrhage/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click on a target to hemorrhage them..."))
	selecting_target = TRUE
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/hemorrhage/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!isliving(target) || source.stat == DEAD)
		return

	var/mob/living/L = target
	if(L == source || L.stat == DEAD)
		return

	// Defer the teleport and damage to avoid sleep in signal handler
	INVOKE_ASYNC(src, PROC_REF(execute_hemorrhage), source, L)

/datum/action/cooldown/skill/hemorrhage/proc/execute_hemorrhage(mob/living/user, mob/living/target)
	var/datum/status_effect/stacking/lc_bleed/bleed = target.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(!bleed)
		to_chat(user, span_warning("[target] has no bleed stacks!"))
		return

	var/damage = bleed.stacks * 10
	var/turf/T = get_turf(target)

	// Blood vortex effect at user's location
	new /obj/effect/temp_visual/blood_vortex(get_turf(user))
	playsound(user, 'sound/magic/wand_teleport.ogg', 50, TRUE)

	// Teleport behind target
	var/turf/behind = get_step(target, turn(target.dir, 180))
	if(behind && !behind.density)
		user.forceMove(behind)
	else
		user.forceMove(T)

	// Blood explosion effect
	new /obj/effect/temp_visual/blood_explosion(T)
	playsound(T, 'sound/effects/splat.ogg', 75, TRUE)
	playsound(T, 'sound/effects/wounds/blood3.ogg', 50, TRUE)

	// Deal damage and remove bleed
	target.apply_damage(damage, RED_DAMAGE)
	bleed.stacks = 0
	qdel(bleed)

	// Blood splatter in all directions
	for(var/dir in GLOB.alldirs)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, dir)

	to_chat(target, span_userdanger("Your blood violently erupts from your wounds!"))
	to_chat(user, span_boldwarning("You trigger a hemorrhage in [target], dealing [damage] damage!"))

	StartCooldown()

/datum/action/cooldown/skill/hemorrhage/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Hemorrhage targeting cancelled."))

//=======================
// CRIMSON CLEAVE
//=======================

/obj/item/book/granter/action/skill/bleed/crimson_cleave
	name = "Level 2: Crimson Cleave"
	desc = "Teleport to a selected target and instantly trigger stacks * 10 RED damage, removing all Bleed stacks."
	actionname = "Crimson Cleave"
	granted_action = /datum/action/cooldown/skill/crimson_cleave
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/crimson_cleave
	name = "Crimson Cleave"
	desc = "Teleport to a selected target and instantly trigger stacks * 10 RED damage, removing all Bleed stacks."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "crimson_cleave"
	cooldown_time = 10 SECONDS

/datum/action/cooldown/skill/crimson_cleave/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	var/turf/T = get_turf(owner)
	var/facing = owner.dir

	// Crimson slash visual
	new /obj/effect/temp_visual/crimson_slash(T, facing)
	playsound(T, 'sound/weapons/bladeslice.ogg', 75, TRUE)
	playsound(T, 'sound/effects/wounds/blood1.ogg', 50, TRUE)

	// Get all turfs in frontal cone
	var/list/affected_turfs = list()
	for(var/turf/check_turf in view(2, T))
		var/dir_to = get_dir(T, check_turf)
		if(dir_to == facing || turn(dir_to, 45) == facing || turn(dir_to, -45) == facing)
			affected_turfs += check_turf

	// Hit all mobs in cone
	var/targets_hit = 0
	for(var/turf/affect_turf in affected_turfs)
		new /obj/effect/temp_visual/blood_slash(affect_turf)
		for(var/mob/living/simple_animal/hostile/L in affect_turf)
			if(L.stat == DEAD)
				continue

			var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
			var/bonus_damage = bleed ? bleed.stacks * 10 : 0
			var/total_damage = 30 + bonus_damage

			L.apply_damage(total_damage, RED_DAMAGE)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), get_dir(T, L))

			if(bleed)
				bleed.add_stacks(-5)

			to_chat(L, span_userdanger("The crimson blade tears through you!"))
			targets_hit++

	to_chat(owner, span_notice("Your crimson cleave strikes [targets_hit] targets!"))
	StartCooldown()
	return TRUE

//=======================
// BLOOD SPIKE
//=======================

/obj/item/book/granter/action/skill/bleed/blood_spike
	name = "Level 2: Blood Spike"
	desc = "Launch a projectile that deals 10 + (target's bleed stacks * 5) RED damage in a 3x3 area, then clears all bleed from the hit target."
	actionname = "Blood Spike"
	granted_action = /datum/action/cooldown/skill/blood_spike
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/blood_spike
	name = "Blood Spike"
	desc = "Launch a projectile that deals 10 + (target's bleed stacks * 5) RED damage in a 3x3 area, then clears all bleed from the hit target."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "blood_spike"
	cooldown_time = 8 SECONDS
	var/selecting_target = FALSE

/datum/action/cooldown/skill/blood_spike/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click on a target to launch a blood spike..."))
	selecting_target = TRUE
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/blood_spike/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!target || source.stat == DEAD)
		return

	// Defer projectile firing to avoid sleep in signal handler
	INVOKE_ASYNC(src, PROC_REF(fire_projectile), source, target)

/datum/action/cooldown/skill/blood_spike/proc/fire_projectile(mob/source, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	// Create blood spike projectile
	var/obj/projectile/blood_spike/P = new(source.loc)
	P.firer = source
	P.preparePixelProjectile(target, source)
	P.fire()

	playsound(source, 'sound/effects/wounds/blood3.ogg', 50, TRUE)
	StartCooldown()

/datum/action/cooldown/skill/blood_spike/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Blood spike targeting cancelled."))

/obj/projectile/blood_spike
	name = "blood spike"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ochre"
	damage = 0
	speed = 0.8
	range = 10

/obj/projectile/blood_spike/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/L = target
		var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
		var/base_damage = 10
		var/bleed_damage = bleed ? bleed.stacks * 5 : 0
		var/total_damage = base_damage + bleed_damage

		// AoE explosion
		var/turf/T = get_turf(target)
		new /obj/effect/temp_visual/blood_eruption(T)
		playsound(T, 'sound/effects/splat.ogg', 75, TRUE)

		// Deal damage in 3x3
		for(var/turf/affected_turf in range(1, T))
			new /obj/effect/decal/cleanable/blood(affected_turf)
			for(var/mob/living/victim in affected_turf)
				if(victim.stat == DEAD)
					continue
				victim.apply_damage(total_damage, RED_DAMAGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(victim), pick(GLOB.alldirs))
				to_chat(victim, span_userdanger("The blood spike explodes!"))

		// Clear bleed from primary target
		if(bleed)
			bleed.stacks = 0
			qdel(bleed)

//=======================
// VISUAL EFFECTS
//=======================

// Shared visual effects for bleed skills

/obj/effect/temp_visual/blood_vortex
	name = "blood vortex"
	icon = 'icons/effects/effects.dmi'
	icon_state = "cleavesprite"
	duration = 5
	color = "#8B0000"

/obj/effect/temp_visual/blood_vortex/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration, easing = CIRCULAR_EASING|EASE_IN)

/obj/effect/temp_visual/blood_explosion
	name = "blood explosion"
	icon = 'icons/effects/effects.dmi'
	icon_state = "purplecrack"
	duration = 5
	color = "#8B0000"

/obj/effect/temp_visual/crimson_slash
	name = "crimson slash"
	icon = 'icons/effects/effects.dmi'
	icon_state = "cleave"
	duration = 5
	color = "#8B0000"

/obj/effect/temp_visual/crimson_slash/Initialize(mapload, set_dir)
	. = ..()
	dir = set_dir
	transform = matrix() * 2

/obj/effect/temp_visual/blood_slash
	name = "blood slash"
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	duration = 10
	color = "#660000"
	alpha = 150

/obj/effect/temp_visual/blood_eruption
	name = "blood eruption"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	duration = 8
	color = "#8B0000"

/obj/effect/temp_visual/blood_eruption/Initialize()
	. = ..()
	transform = matrix() * 3
	animate(src, alpha = 0, time = duration)
