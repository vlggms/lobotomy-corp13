// /*
//  * Tremor Status Skills
//  * These skills interact with the lc_tremor status effect
//  */

// //Base tremor skill book
// /obj/item/book/granter/action/skill/tremor
// 	name = "Tremor Skill Book"
// 	desc = "A book that teaches earth-shaking combat techniques."
// 	icon_state = "book3"
// 	remarks = list("The ground shakes as I read...", "I feel the earth's power...", "My movements grow heavy...")
// 	pages_to_mastery = 0

// //=======================
// // DAMAGE SKILLS
// //=======================

// // Seismic Slam - Area damage based on total tremor stacks
// /obj/item/book/granter/action/skill/tremor/seismic_slam
// 	name = "Tremor Skill: Seismic Slam"
// 	actionname = "Seismic Slam"
// 	granted_action = /datum/action/cooldown/tremor/seismic_slam
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/seismic_slam
// 	name = "Seismic Slam"
// 	desc = "Slam ground dealing 20 + (combined total Tremor stacks of all impacted MOBs * 2) BLACK damage to MOBs in 5x5 area. Then TremorBurst all MOBs."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "seismic_slam"
// 	cooldown_time = 15 SECONDS

// /datum/action/cooldown/tremor/seismic_slam/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	var/turf/center = get_turf(owner)
// 	if(!center)
// 		return FALSE

// 	// Wind up animation
// 	owner.visible_message(span_warning("[owner] raises their weapon high!"), span_notice("You prepare to slam the ground!"))
// 	if(!do_after(owner, 0.5 SECONDS, owner))
// 		return FALSE

// 	// Create shockwave effect
// 	playsound(center, 'sound/effects/meteorimpact.ogg', 100, TRUE)
// 	for(var/i in 0 to 2)
// 		for(var/turf/T in spiral_range_turfs(i, center))
// 			if(get_dist(T, center) == i)
// 				new /obj/effect/temp_visual/shockwave(T)
// 		sleep(1)

// 	// Calculate total tremor and damage
// 	var/total_tremor = 0
// 	var/list/affected_mobs = list()
// 	for(var/mob/living/L in range(2, center))
// 		if(L == owner || L.stat == DEAD)
// 			continue
// 		if(isliving(L))
// 			var/datum/status_effect/stacking/lc_tremor/tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
// 			if(tremor)
// 				total_tremor += tremor.stacks
// 		affected_mobs += L

// 	var/damage = 20 + (total_tremor * 2)

// 	// Deal damage and trigger tremor burst
// 	for(var/mob/living/L in affected_mobs)
// 		L.apply_damage(damage, BLACK_DAMAGE)
// 		new /obj/effect/temp_visual/kinetic_blast(get_turf(L))

// 		// Apply tremor burst
// 		if(ishuman(L))
// 			L.Knockdown(30)
// 			to_chat(L, span_userdanger("The seismic slam knocks you down!"))
// 		else
// 			L.apply_damage(L.has_status_effect(/datum/status_effect/stacking/lc_tremor) ? L.has_status_effect(/datum/status_effect/stacking/lc_tremor).stacks * 5 : 0, BRUTE_DAMAGE)

// 		to_chat(L, span_userdanger("The ground erupts beneath you!"))

// 	to_chat(owner, span_notice("Your seismic slam deals [damage] damage to [length(affected_mobs)] target\s!"))
// 	StartCooldown()
// 	return TRUE

// // Resonant Strike - Bonus damage based on target's tremor
// /obj/item/book/granter/action/skill/tremor/resonant_strike
// 	name = "Tremor Skill: Resonant Strike"
// 	actionname = "Resonant Strike"
// 	granted_action = /datum/action/cooldown/tremor/resonant_strike
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/resonant_strike
// 	name = "Resonant Strike"
// 	desc = "Next attack within 5 seconds against MOB with Tremor deals stacks * 3 bonus BLACK damage and then reduces their TREMOR stack by 50%."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "resonant_strike"
// 	cooldown_time = 5 SECONDS
// 	var/buff_duration = 5 SECONDS
// 	var/empowered = FALSE

// /datum/action/cooldown/tremor/resonant_strike/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	to_chat(owner, span_notice("Your next attack will resonate with trembling foes!"))
// 	empowered = TRUE

// 	// Add visual effect to weapon
// 	var/obj/item/held_item = owner.get_active_held_item()
// 	if(held_item)
// 		held_item.add_atom_colour("#4d3319", TEMPORARY_COLOUR_PRIORITY)
// 		var/mutable_appearance/tremor_overlay = mutable_appearance('icons/effects/effects.dmi', "tremor")
// 		tremor_overlay.appearance_flags = RESET_COLOR
// 		held_item.add_overlay(tremor_overlay, TRUE)

// 	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
// 	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
// 	StartCooldown()
// 	return TRUE

// /datum/action/cooldown/tremor/resonant_strike/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
// 	SIGNAL_HANDLER

// 	if(!empowered || !target || target.stat == DEAD)
// 		return

// 	var/datum/status_effect/stacking/lc_tremor/tremor = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
// 	if(!tremor)
// 		to_chat(source, span_warning("[target] has no tremor stacks!"))
// 		remove_buff()
// 		return

// 	var/bonus_damage = tremor.stacks * 3
// 	target.apply_damage(bonus_damage, BLACK_DAMAGE)

// 	// Reduce stacks by 50%
// 	var/reduction = round(tremor.stacks * 0.5)
// 	tremor.add_stacks(-reduction)

// 	// Visual effects
// 	new /obj/effect/temp_visual/resonance(get_turf(target))
// 	playsound(target, 'sound/effects/break_stone.ogg', 50, TRUE)

// 	to_chat(target, span_userdanger("The resonant strike shatters through you!"))
// 	to_chat(source, span_boldwarning("Your resonant strike deals [bonus_damage] bonus damage!"))

// 	remove_buff()

// /datum/action/cooldown/tremor/resonant_strike/proc/remove_buff()
// 	empowered = FALSE
// 	var/obj/item/held_item = owner.get_active_held_item()
// 	if(held_item)
// 		held_item.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
// 		held_item.cut_overlay("tremor", TRUE)
// 	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

// // Earthbound Hammer - Teleport and area damage based on self tremor
// /obj/item/book/granter/action/skill/tremor/earthbound_hammer
// 	name = "Tremor Skill: Earthbound Hammer"
// 	actionname = "Earthbound Hammer"
// 	granted_action = /datum/action/cooldown/tremor/earthbound_hammer
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/earthbound_hammer
// 	name = "Earthbound Hammer"
// 	desc = "After a short delay, teleport to the target deal tremor stacks on self * 5 BLACK damage to all targets in a 5x5 area around you. Then reduce your tremor by 75%."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "earthbound_hammer"
// 	cooldown_time = 20 SECONDS

// /datum/action/cooldown/tremor/earthbound_hammer/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	var/datum/status_effect/stacking/lc_tremor/self_tremor = owner.has_status_effect(/datum/status_effect/stacking/lc_tremor)
// 	if(!self_tremor || self_tremor.stacks <= 0)
// 		to_chat(owner, span_warning("You have no tremor stacks to power the hammer!"))
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click on a location to perform an earthbound hammer strike!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
// 	return TRUE

// /datum/action/cooldown/tremor/earthbound_hammer/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	var/turf/target_turf = get_turf(target)
// 	if(!target_turf)
// 		return

// 	if(get_dist(source, target_turf) > 7)
// 		to_chat(source, span_warning("That location is too far away!"))
// 		return

// 	INVOKE_ASYNC(src, PROC_REF(perform_hammer), target_turf)
// 	StartCooldown()

// /datum/action/cooldown/tremor/earthbound_hammer/proc/perform_hammer(turf/target_turf)
// 	var/datum/status_effect/stacking/lc_tremor/self_tremor = owner.has_status_effect(/datum/status_effect/stacking/lc_tremor)
// 	if(!self_tremor)
// 		return

// 	var/damage = self_tremor.stacks * 5

// 	// Wind up
// 	owner.visible_message(span_warning("[owner] leaps into the air!"), span_notice("You leap high into the air!"))
// 	animate(owner, pixel_y = 32, time = 5, easing = SINE_EASING | EASE_OUT)
// 	sleep(5)

// 	// Teleport and slam
// 	new /obj/effect/temp_visual/teleport_burst(get_turf(owner))
// 	owner.forceMove(target_turf)
// 	animate(owner, pixel_y = 0, time = 2, easing = SINE_EASING | EASE_IN)
// 	sleep(2)

// 	// Impact
// 	playsound(target_turf, 'sound/effects/meteorimpact.ogg', 100, TRUE)
// 	for(var/i in 0 to 2)
// 		for(var/turf/T in spiral_range_turfs(i, target_turf))
// 			if(get_dist(T, target_turf) == i)
// 				new /obj/effect/temp_visual/impact_crater(T)
// 		sleep(1)

// 	// Deal damage
// 	for(var/mob/living/L in range(2, target_turf))
// 		if(L == owner || L.stat == DEAD)
// 			continue
// 		L.apply_damage(damage, BLACK_DAMAGE)
// 		new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
// 		to_chat(L, span_userdanger("The earthbound hammer crushes you!"))

// 	// Reduce self tremor by 75%
// 	var/reduction = round(self_tremor.stacks * 0.75)
// 	self_tremor.add_stacks(-reduction)

// 	to_chat(owner, span_notice("Your earthbound hammer deals [damage] damage!"))

// /datum/action/cooldown/tremor/earthbound_hammer/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// //=======================
// // SUPPORT SKILLS
// //=======================

// // Aftershock - Next 3 attacks apply tremor in AoE
// /obj/item/book/granter/action/skill/tremor/aftershock
// 	name = "Tremor Skill: Aftershock"
// 	actionname = "Aftershock"
// 	granted_action = /datum/action/cooldown/tremor/aftershock
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/aftershock
// 	name = "Aftershock"
// 	desc = "Next 3 melee attacks apply 5 Tremor stacks to all mobs in a 3x3 AoE centered on the target."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "aftershock"
// 	cooldown_time = 15 SECONDS
// 	var/charges = 0
// 	var/buff_duration = 10 SECONDS

// /datum/action/cooldown/tremor/aftershock/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	to_chat(owner, span_notice("Your attacks will create aftershocks!"))
// 	charges = 3

// 	// Add visual effect to weapon
// 	var/obj/item/held_item = owner.get_active_held_item()
// 	if(held_item)
// 		held_item.add_atom_colour("#8B7355", TEMPORARY_COLOUR_PRIORITY)

// 	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
// 	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
// 	StartCooldown()
// 	return TRUE

// /datum/action/cooldown/tremor/aftershock/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
// 	SIGNAL_HANDLER

// 	if(!charges || !target || target.stat == DEAD)
// 		return

// 	var/turf/center = get_turf(target)
// 	charges--

// 	// Create aftershock
// 	for(var/turf/T in range(1, center))
// 		new /obj/effect/temp_visual/small_shockwave(T)
// 		for(var/mob/living/L in T)
// 			if(L.stat == DEAD)
// 				continue
// 			L.apply_lc_tremor(5)
// 			to_chat(L, span_warning("The aftershock makes you stumble!"))

// 	playsound(center, 'sound/effects/break_stone.ogg', 25, TRUE)
// 	to_chat(source, span_notice("Your attack creates an aftershock! ([charges] charges remaining)"))

// 	if(charges <= 0)
// 		remove_buff()

// /datum/action/cooldown/tremor/aftershock/proc/remove_buff()
// 	charges = 0
// 	var/obj/item/held_item = owner.get_active_held_item()
// 	if(held_item)
// 		held_item.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
// 	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

// // Seismic Wave - Piercing projectile that builds tremor
// /obj/item/book/granter/action/skill/tremor/seismic_wave
// 	name = "Tremor Skill: Seismic Wave"
// 	actionname = "Seismic Wave"
// 	granted_action = /datum/action/cooldown/tremor/seismic_wave
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/seismic_wave
// 	name = "Seismic Wave"
// 	desc = "Send piercing projectile towards your target, which applys tiles traveled * 5 Tremor stacks to all targets it hits. (Max distance traveled is 10)"
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "seismic_wave"
// 	cooldown_time = 10 SECONDS

// /datum/action/cooldown/tremor/seismic_wave/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click to send a seismic wave!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
// 	return TRUE

// /datum/action/cooldown/tremor/seismic_wave/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	// Fire projectile
// 	var/obj/projectile/seismic_wave/wave = new(get_turf(source))
// 	wave.preparePixelProjectile(target, source)
// 	wave.firer = source
// 	wave.fire()

// 	playsound(source, 'sound/effects/break_stone.ogg', 50, TRUE)
// 	StartCooldown()

// /datum/action/cooldown/tremor/seismic_wave/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// /obj/projectile/seismic_wave
// 	name = "seismic wave"
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "seismic_wave"
// 	speed = 2
// 	damage = 0
// 	range = 10
// 	piercing = TRUE
// 	var/mob/living/firer
// 	var/tiles_traveled = 0

// /obj/projectile/seismic_wave/Initialize()
// 	. = ..()
// 	transform = matrix() * 2

// /obj/projectile/seismic_wave/pixel_move(trajectory_multiplier, hitscanning = FALSE)
// 	. = ..()
// 	tiles_traveled = min(tiles_traveled + 1, 10)

// /obj/projectile/seismic_wave/on_hit(atom/target, blocked, pierce_hit)
// 	if(!isliving(target))
// 		return ..()

// 	var/mob/living/L = target
// 	var/tremor_stacks = tiles_traveled * 5
// 	L.apply_lc_tremor(tremor_stacks)

// 	// Visual effect
// 	new /obj/effect/temp_visual/small_shockwave(get_turf(L))
// 	to_chat(L, span_warning("The seismic wave shakes you to your core!"))

// 	return ..()

// // Shattered Resentment - Apply tremor with launch animation
// /obj/item/book/granter/action/skill/tremor/shattered_resentment
// 	name = "Tremor Skill: Shattered Resentment"
// 	actionname = "Shattered Resentment"
// 	granted_action = /datum/action/cooldown/tremor/shattered_resentment
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/shattered_resentment
// 	name = "Shattered Resentment"
// 	desc = "Trigger the target to gain 20 TREMOR. (Also play an animation of them being launched into the air and spinning)"
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "shattered_resentment"
// 	cooldown_time = 8 SECONDS

// /datum/action/cooldown/tremor/shattered_resentment/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click on a target to shatter their balance!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
// 	return TRUE

// /datum/action/cooldown/tremor/shattered_resentment/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	if(!isliving(target))
// 		to_chat(source, span_warning("You must target a living creature!"))
// 		return

// 	var/mob/living/L = target
// 	if(L == source || L.stat == DEAD)
// 		to_chat(source, span_warning("Invalid target!"))
// 		return

// 	if(get_dist(source, L) > 5)
// 		to_chat(source, span_warning("[L] is too far away!"))
// 		return

// 	// Apply tremor
// 	L.apply_lc_tremor(20)

// 	// Launch animation
// 	animate(L, pixel_y = 16, transform = turn(matrix(), 180), time = 5, easing = SINE_EASING | EASE_OUT)
// 	animate(pixel_y = 16, transform = turn(matrix(), 360), time = 5, easing = LINEAR_EASING)
// 	animate(pixel_y = 0, transform = matrix(), time = 5, easing = SINE_EASING | EASE_IN)

// 	// Effects
// 	new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
// 	playsound(L, 'sound/effects/gravhit.ogg', 50, TRUE)

// 	to_chat(L, span_userdanger("The ground rejects you violently!"))
// 	to_chat(source, span_notice("You shatter [L]'s connection to the earth!"))

// 	StartCooldown()

// /datum/action/cooldown/tremor/shattered_resentment/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// //=======================
// // CONTROL SKILLS
// //=======================

// // Stabilizing Stance - Remove tremor and grant speed
// /obj/item/book/granter/action/skill/tremor/stabilizing_stance
// 	name = "Tremor Skill: Stabilizing Stance"
// 	actionname = "Stabilizing Stance"
// 	granted_action = /datum/action/cooldown/tremor/stabilizing_stance
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/stabilizing_stance
// 	name = "Stabilizing Stance"
// 	desc = "Remove all Tremor from self and allies in 3x3 area, if those allies had tremor, they gain 50% speed for 3 seconds."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "stabilizing_stance"
// 	cooldown_time = 10 SECONDS

// /datum/action/cooldown/tremor/stabilizing_stance/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	var/turf/center = get_turf(owner)
// 	if(!center)
// 		return FALSE

// 	// Visual effect
// 	for(var/turf/T in range(1, center))
// 		new /obj/effect/temp_visual/stable_ground(T)

// 	playsound(center, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)

// 	// Remove tremor and apply speed
// 	var/helped_count = 0
// 	for(var/mob/living/L in range(1, center))
// 		if(L.stat == DEAD)
// 			continue

// 		var/datum/status_effect/stacking/lc_tremor/tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
// 		if(tremor && tremor.stacks > 0)
// 			L.remove_status_effect(/datum/status_effect/stacking/lc_tremor)
// 			L.apply_status_effect(/datum/status_effect/stable_footing)
// 			to_chat(L, span_nicegreen("Your footing becomes stable!"))
// 			helped_count++

// 	to_chat(owner, span_notice("You stabilize the ground, helping [helped_count] target\s!"))
// 	StartCooldown()
// 	return TRUE

// /datum/status_effect/stable_footing
// 	id = "stable_footing"
// 	duration = 3 SECONDS
// 	alert_type = null

// /datum/status_effect/stable_footing/on_apply()
// 	owner.add_movespeed_modifier(/datum/movespeed_modifier/stable_footing)
// 	return TRUE

// /datum/status_effect/stable_footing/on_remove()
// 	owner.remove_movespeed_modifier(/datum/movespeed_modifier/stable_footing)

// /datum/movespeed_modifier/stable_footing
// 	multiplicative_slowdown = -0.5

// // Tectonic Shift - Create difficult terrain
// /obj/item/book/granter/action/skill/tremor/tectonic_shift
// 	name = "Tremor Skill: Tectonic Shift"
// 	actionname = "Tectonic Shift"
// 	granted_action = /datum/action/cooldown/tremor/tectonic_shift
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/tectonic_shift
// 	name = "Tectonic Shift"
// 	desc = "Create 3x3 difficult terrain at selected location that applies 2 Tremor/sec to all targets on top of it for 5 seconds. If the target is a MOB, they only gain tremor if they have 15+ Tremor."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "tectonic_shift"
// 	cooldown_time = 20 SECONDS

// /datum/action/cooldown/tremor/tectonic_shift/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click on a location to create difficult terrain!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
// 	return TRUE

// /datum/action/cooldown/tremor/tectonic_shift/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	var/turf/target_turf = get_turf(target)
// 	if(!target_turf)
// 		return

// 	if(get_dist(source, target_turf) > 7)
// 		to_chat(source, span_warning("That location is too far away!"))
// 		return

// 	// Create difficult terrain
// 	for(var/turf/T in range(1, target_turf))
// 		new /obj/effect/tectonic_terrain(T, source)

// 	playsound(target_turf, 'sound/effects/break_stone.ogg', 75, TRUE)
// 	to_chat(source, span_notice("You shift the tectonic plates!"))

// 	StartCooldown()

// /datum/action/cooldown/tremor/tectonic_shift/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// /obj/effect/tectonic_terrain
// 	name = "unstable ground"
// 	desc = "The ground here shifts and cracks constantly."
// 	icon = 'icons/turf/floors.dmi'
// 	icon_state = "plating"
// 	density = FALSE
// 	anchored = TRUE
// 	layer = TURF_LAYER + 0.1
// 	var/mob/living/owner

// /obj/effect/tectonic_terrain/Initialize(mapload, mob/living/caster)
// 	. = ..()
// 	owner = caster
// 	START_PROCESSING(SSobj, src)
// 	QDEL_IN(src, 5 SECONDS)
// 	color = "#8B7355"
// 	alpha = 150

// /obj/effect/tectonic_terrain/Destroy()
// 	STOP_PROCESSING(SSobj, src)
// 	return ..()

// /obj/effect/tectonic_terrain/process()
// 	// Create cracks
// 	if(prob(20))
// 		new /obj/effect/temp_visual/ground_crack(loc)

// 	// Apply tremor
// 	for(var/mob/living/L in get_turf(src))
// 		if(L == owner || L.stat == DEAD)
// 			continue

// 		if(!isanimal(L))
// 			// Non-mobs always get tremor
// 			L.apply_lc_tremor(2)
// 		else
// 			// Mobs only get tremor if they have 15+ already
// 			var/datum/status_effect/stacking/lc_tremor/tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
// 			if(tremor && tremor.stacks >= 15)
// 				L.apply_lc_tremor(2)

// 		// Slow effect
// 		if(!(L in affected_mobs))
// 			affected_mobs += L
// 			L.add_movespeed_modifier(/datum/movespeed_modifier/tectonic_terrain)

// 	// Remove slow from those who left
// 	for(var/mob/living/L in affected_mobs)
// 		if(get_turf(L) != get_turf(src))
// 			affected_mobs -= L
// 			L.remove_movespeed_modifier(/datum/movespeed_modifier/tectonic_terrain)

// /obj/effect/tectonic_terrain/var/list/affected_mobs = list()

// /datum/movespeed_modifier/tectonic_terrain
// 	multiplicative_slowdown = 1.5

// // Repelling Motion - Push away nearby mobs
// /obj/item/book/granter/action/skill/tremor/repelling_motion
// 	name = "Tremor Skill: Repelling Motion"
// 	actionname = "Repelling Motion"
// 	granted_action = /datum/action/cooldown/tremor/repelling_motion
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/tremor/repelling_motion
// 	name = "Repelling Motion"
// 	desc = "For the next 10s, every second you throw all mobs within a 3x3 area around you 3 tiles away from you, and inflict 3 Tremor to them, if they have less then 15 Tremor."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "repelling_motion"
// 	cooldown_time = 20 SECONDS

// /datum/action/cooldown/tremor/repelling_motion/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	to_chat(owner, span_notice("You begin emanating repelling force!"))
// 	owner.apply_status_effect(/datum/status_effect/repelling_motion)

// 	StartCooldown()
// 	return TRUE

// /datum/status_effect/repelling_motion
// 	id = "repelling_motion"
// 	duration = 10 SECONDS
// 	alert_type = /atom/movable/screen/alert/status_effect/repelling_motion
// 	var/next_pulse = 0

// /datum/status_effect/repelling_motion/tick()
// 	if(world.time < next_pulse)
// 		return

// 	next_pulse = world.time + 10 // 1 second

// 	// Visual effect
// 	new /obj/effect/temp_visual/repelling_pulse(get_turf(owner))
// 	playsound(owner, 'sound/effects/space_wind.ogg', 25, TRUE)

// 	// Repel mobs
// 	for(var/mob/living/L in range(1, owner))
// 		if(L == owner || L.stat == DEAD)
// 			continue

// 		// Calculate knockback
// 		var/turf/target_turf = get_turf(L)
// 		var/turf/source_turf = get_turf(owner)
// 		var/dir_away = get_dir(source_turf, target_turf)
// 		if(!dir_away)
// 			dir_away = pick(GLOB.alldirs)

// 		var/turf/throw_target = get_edge_target_turf(target_turf, dir_away)
// 		L.throw_at(throw_target, 3, 1)

// 		// Apply tremor if they have less than 15
// 		var/datum/status_effect/stacking/lc_tremor/tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
// 		if(!tremor || tremor.stacks < 15)
// 			L.apply_lc_tremor(3)

// 		to_chat(L, span_warning("A repelling force pushes you away!"))

// /atom/movable/screen/alert/status_effect/repelling_motion
// 	name = "Repelling Motion"
// 	desc = "You are emanating a repelling force."
// 	icon_state = "repelling"

// =======================
// VISUAL EFFECTS
// =======================

// /obj/effect/temp_visual/shockwave
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "shockwave"
// 	duration = 5

// /obj/effect/temp_visual/shockwave/Initialize()
// 	. = ..()
// 	transform = matrix() * 0.5
// 	animate(src, transform = matrix() * 2, alpha = 0, time = duration)

// /obj/effect/temp_visual/small_shockwave
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "shockwave"
// 	duration = 3

// /obj/effect/temp_visual/small_shockwave/Initialize()
// 	. = ..()
// 	transform = matrix() * 0.3
// 	animate(src, transform = matrix() * 1, alpha = 0, time = duration)

// /obj/effect/temp_visual/impact_crater
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "crater"
// 	duration = 30

// /obj/effect/temp_visual/impact_crater/Initialize()
// 	. = ..()
// 	alpha = 200
// 	animate(src, alpha = 0, time = duration)

// /obj/effect/temp_visual/resonance
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "resonance"
// 	duration = 10

// /obj/effect/temp_visual/resonance/Initialize()
// 	. = ..()
// 	animate(src, transform = matrix() * 1.5, alpha = 0, time = duration)

// /obj/effect/temp_visual/stable_ground
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "forcefield1"
// 	duration = 10
// 	color = "#8B7355"

// /obj/effect/temp_visual/stable_ground/Initialize()
// 	. = ..()
// 	alpha = 100
// 	animate(src, alpha = 0, time = duration)

// /obj/effect/temp_visual/ground_crack
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "crack"
// 	duration = 20

// /obj/effect/temp_visual/ground_crack/Initialize()
// 	. = ..()
// 	pixel_x = rand(-8, 8)
// 	pixel_y = rand(-8, 8)
// 	dir = pick(GLOB.alldirs)

// /obj/effect/temp_visual/repelling_pulse
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "shield-old"
// 	duration = 10
// 	color = "#8B7355"

// /obj/effect/temp_visual/repelling_pulse/Initialize()
// 	. = ..()
// 	transform = matrix() * 0.5
// 	animate(src, transform = matrix() * 2, alpha = 0, time = duration)
