/*
 * Overheat Damage Skills (Level 2)
 * Combat skills that deal damage using the overheat status effect
 */

//=======================
// THERMAL DETONATION
//=======================

/obj/item/book/granter/action/skill/overheat/overheat_detonation
	name = "Level 2: Thermal Detonation"
	desc = "Your next melee attack within 5 seconds will consume all Overheat stacks on the target to deal WHITE damage based on their overheat stack in a 3x3 area."
	actionname = "Thermal Detonation"
	granted_action = /datum/action/cooldown/skill/overheat_detonation
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/overheat_detonation
	name = "Thermal Detonation"
	desc = "Your next melee attack within 5 seconds will consume all Overheat stacks on the target to deal WHITE damage based on their overheat stack in a 3x3 area."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "thermal_detonation"
	cooldown_time = 20 SECONDS
	var/buff_duration = 5 SECONDS
	var/empowered = FALSE
	var/obj/effect/weapon_glow/current_glow

/datum/action/cooldown/skill/overheat_detonation/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Your next attack will trigger a thermal detonation!"))
	empowered = TRUE

	// Add weapon glow effect
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		current_glow = new(held_item.loc)
		current_glow.layer = held_item.layer - 0.01
		current_glow.plane = held_item.plane
		held_item.vis_contents += current_glow
		animate(current_glow, alpha = 200, time = 2, loop = -1)
		animate(alpha = 100, time = 2)

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/overheat_detonation/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(!empowered || !target || target.stat == DEAD)
		return

	var/datum/status_effect/stacking/lc_overheat/overheat = target.has_status_effect(/datum/status_effect/stacking/lc_overheat)
	if(!overheat)
		to_chat(source, span_warning("[target] has no overheat stacks!"))
		remove_buff()
		return

	var/damage = overheat.stacks * 10
	var/turf/T = get_turf(target)

	// Pre-explosion buildup
	to_chat(target, span_userdanger("The heat inside you reaches critical mass!"))
	INVOKE_ASYNC(src, PROC_REF(detonate), T, damage)
	remove_buff()

/datum/action/cooldown/skill/overheat_detonation/proc/detonate(turf/epicenter, damage)
	// Visual buildup
	for(var/i in 1 to 3)
		new /obj/effect/temp_visual/ring_of_fire(epicenter)
		sleep(1)

	// Main explosion
	new /obj/effect/temp_visual/explosion(epicenter)
	playsound(epicenter, 'sound/effects/explosion1.ogg', 75, TRUE)
	playsound(epicenter, 'sound/magic/fireball.ogg', 50, TRUE)

	// Expanding fire ring
	for(var/dist in 0 to 1)
		for(var/turf/ring_turf in spiral_range_turfs(dist, epicenter))
			new /obj/effect/temp_visual/fire(ring_turf)
		sleep(1)

	// Deal damage in 3x3
	for(var/turf/affected_turf in range(1, epicenter))
		// Leave burning ground
		new /obj/effect/temp_visual/burning_ground(affected_turf)

		for(var/mob/living/victim in affected_turf)
			if(victim.stat == DEAD)
				continue
			if(ishuman(victim))
				continue // Don't hurt humans
			victim.apply_damage(damage, WHITE_DAMAGE)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(victim), get_dir(epicenter, victim))
			to_chat(victim, span_userdanger("You are caught in the thermal detonation!"))

/datum/action/cooldown/skill/overheat_detonation/proc/remove_buff()
	empowered = FALSE
	if(current_glow)
		var/obj/item/held_item = owner.get_active_held_item()
		if(held_item)
			held_item.vis_contents -= current_glow
		qdel(current_glow)
		current_glow = null
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

//=======================
// MOLTEN STRIKE
//=======================

/obj/item/book/granter/action/skill/overheat/molten_strike
	name = "Level 2: Molten Strike"
	desc = "Your next melee attack within 5 seconds deals bonus WHITE damage based on target's Overheat stacks and reduces their stacks by 5."
	actionname = "Molten Strike"
	granted_action = /datum/action/cooldown/skill/molten_strike
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/molten_strike
	name = "Molten Strike"
	desc = "Your next melee attack within 5 seconds deals bonus WHITE damage based on target's Overheat stacks and reduces their stacks by 5."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "molten_strike"
	cooldown_time = 10 SECONDS
	var/buff_duration = 5 SECONDS
	var/empowered = FALSE
	var/obj/effect/molten_drip/drip_effect

/datum/action/cooldown/skill/molten_strike/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Your weapon glows with molten heat!"))
	empowered = TRUE

	// Add molten dripping effect
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		drip_effect = new(owner.loc)
		drip_effect.follow_target = owner

	// Weapon glow effect
	if(held_item)
		held_item.add_atom_colour("#ff3300", TEMPORARY_COLOUR_PRIORITY)

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/molten_strike/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(!empowered || !target || target.stat == DEAD)
		return

	var/datum/status_effect/stacking/lc_overheat/overheat = target.has_status_effect(/datum/status_effect/stacking/lc_overheat)
	if(!overheat)
		to_chat(source, span_warning("[target] has no overheat stacks!"))
		remove_buff()
		return

	var/bonus_damage = overheat.stacks * 5
	target.apply_damage(bonus_damage, WHITE_DAMAGE)

	// Reduce stacks
	overheat.add_stacks(-5)

	// Lava splash effect
	new /obj/effect/temp_visual/lava_splash(get_turf(target))

	// Molten footprint
	new /obj/effect/decal/cleanable/molten_footprint(get_turf(target))

	// Sizzling sounds
	playsound(target, 'sound/items/welder.ogg', 50, TRUE)
	playsound(target, 'sound/items/welder2.ogg', 25, TRUE)

	to_chat(target, span_userdanger("The molten strike burns through you!"))
	to_chat(source, span_boldwarning("Your molten weapon sears [target] for [bonus_damage] bonus damage!"))

	remove_buff()

/datum/action/cooldown/skill/molten_strike/proc/remove_buff()
	empowered = FALSE

	// Remove weapon color
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		held_item.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)

	// Remove drip effect
	if(drip_effect)
		qdel(drip_effect)
		drip_effect = null

	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

//=======================
// INFERNO DASH
//=======================

/obj/item/book/granter/action/skill/overheat/inferno_dash
	name = "Level 2: Inferno Dash"
	desc = "Dash forward dealing 30 WHITE damage. If you hit a target with 15+ Overheat, reduce their stacks by 10 and refresh cooldown."
	actionname = "Inferno Dash"
	granted_action = /datum/action/cooldown/skill/inferno_dash
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/inferno_dash
	name = "Inferno Dash"
	desc = "Dash forward dealing 50 WHITE damage. If you hit a target with 15+ Overheat, reduce their stacks by 10 and refresh cooldown."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "inferno_dash"
	cooldown_time = 30 SECONDS
	var/dash_range = 5
	var/damage = 50
	var/stack_requirement = 15
	var/stack_reduction = 10
	var/list/been_hit = list()
	var/hit_high_overheat = FALSE
	var/already_reduced_overheat = FALSE

/datum/action/cooldown/skill/inferno_dash/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	var/dir_to_dash = owner.dir
	var/turf/T = get_turf(owner)

	// Check if there's enough space to dash
	for(var/i = 1 to dash_range)
		T = get_step(T, dir_to_dash)
		if(T.density)
			if(i < 3) // Too close to wall, cancel dash
				to_chat(owner, span_warning("Not enough space to dash!"))
				return FALSE
			break

	// Reset tracking variables
	been_hit = list()
	hit_high_overheat = FALSE
	already_reduced_overheat = FALSE

	// Start dash immediately
	playsound(get_turf(owner), 'sound/magic/fireball.ogg', 75, TRUE)
	DoDash(dir_to_dash, 0)
	return TRUE

/datum/action/cooldown/skill/inferno_dash/proc/DoDash(move_dir, times_ran)
	var/stop_dash = FALSE
	if(times_ran >= dash_range)
		stop_dash = TRUE

	var/turf/T = get_step(get_turf(owner), move_dir)
	if(!T)
		finish_dash()
		return

	if(T.density)
		stop_dash = TRUE

	// Break windows in the way
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("inferno")

	// Open doors
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK(D, TYPE_PROC_REF(/obj/machinery/door, open)))

	if(stop_dash)
		finish_dash()
		return

	owner.forceMove(T)

	// Create fire effects and damage enemies
	for(var/turf/affected_turf in view(1, T))
		new /obj/effect/temp_visual/fire/fast(affected_turf)
		for(var/mob/living/L in affected_turf)
			if(L == owner || (L in been_hit) || L.stat == DEAD)
				continue

			L.apply_damage(damage, WHITE_DAMAGE)
			new /obj/effect/temp_visual/cleave(get_turf(L))
			been_hit += L

			var/datum/status_effect/stacking/lc_overheat/overheat = L.has_status_effect(/datum/status_effect/stacking/lc_overheat)
			if(overheat && overheat.stacks >= stack_requirement && !already_reduced_overheat)
				overheat.add_stacks(-stack_reduction)
				hit_high_overheat = TRUE
				already_reduced_overheat = TRUE
				to_chat(L, span_userdanger("The inferno dash burns away your heat!"))
				to_chat(owner, span_boldwarning("You blaze through [L]!"))

	addtimer(CALLBACK(src, PROC_REF(DoDash), move_dir, (times_ran + 1)), 1) // Continue dash

/datum/action/cooldown/skill/inferno_dash/proc/finish_dash()
	if(hit_high_overheat)
		to_chat(owner, span_notice("Hitting a superheated target refreshes your dash!"))
		cooldown_time = 0 // Reset cooldown
		StartCooldown()
		cooldown_time = 30 SECONDS // Restore normal cooldown
	else
		StartCooldown()

//=======================
// VISUAL EFFECTS
//=======================

// Shared visual effects for overheat skills

/obj/effect/weapon_glow
	name = "weapon glow"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	color = "#ff6600"
	alpha = 100

/obj/effect/temp_visual/ring_of_fire
	name = "ring of fire"
	icon = 'icons/effects/effects.dmi'
	icon_state = "visual_fire"
	duration = 7

/obj/effect/temp_visual/ring_of_fire/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/burning_ground
	name = "burning ground"
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	duration = 30
	color = "#ff6600"
	alpha = 150

/obj/effect/temp_visual/burning_ground/Initialize()
	. = ..()
	icon_state = pick("1", "2", "3")
	animate(src, alpha = 0, time = duration)

/obj/effect/molten_drip
	name = "molten drip"
	icon = 'icons/effects/footprints.dmi'
	icon_state = "blood1" // TODO: Icon state "blood1" needs to be added to footprints.dmi
	color = "#ff7b00"
	alpha = 200
	var/mob/follow_target

/obj/effect/molten_drip/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/molten_drip/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/molten_drip/process()
	if(!follow_target || QDELETED(follow_target))
		qdel(src)
		return

	loc = follow_target.loc
	dir = follow_target.dir

	// Create drip particles
	if(prob(30))
		new /obj/effect/temp_visual/molten_particle(loc)

/obj/effect/temp_visual/molten_particle
	name = "molten metal"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	duration = 10
	color = "#ff6600"

/obj/effect/temp_visual/molten_particle/Initialize()
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	animate(src, pixel_y = pixel_y - 16, alpha = 0, time = duration)

/obj/effect/temp_visual/lava_splash
	name = "lava splash"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	duration = 8
	color = "#ff3300"

/obj/effect/temp_visual/lava_splash/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/decal/cleanable/molten_footprint
	name = "molten footprint"
	desc = "A scorched mark left by molten metal."
	icon = 'icons/effects/blood.dmi'
	icon_state = "tracks"
	color = "#331100"
