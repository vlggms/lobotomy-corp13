/*
 * Tremor Damage Skills (Level 2)
 * Combat skills that deal damage using the tremor status effect
 */

//=======================
// SEISMIC SLAM
//=======================

/obj/item/book/granter/action/skill/tremor/seismic_slam
	name = "Level 2: Seismic Slam"
	actionname = "Seismic Slam"
	desc = "Slam the ground dealing 20 + (combined Tremor stacks * 2) BLACK damage to all MOBs in 5x5 area. Then TremorBurst all MOBs."
	granted_action = /datum/action/cooldown/skill/seismic_slam
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/seismic_slam
	name = "Seismic Slam"
	desc = "Slam the ground dealing 20 + (combined Tremor stacks * 2) BLACK damage to all MOBs in 5x5 area. Then Tremor Burst all MOBs."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "seismic_slam"
	cooldown_time = 15 SECONDS

/datum/action/cooldown/skill/seismic_slam/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	var/turf/epicenter = get_turf(owner)

	// Ground slam animation
	owner.visible_message(span_warning("[owner] slams the ground with tremendous force!"))
	playsound(epicenter, 'sound/effects/break_stone.ogg', 100, TRUE)

	// Screen shake for everyone nearby
	for(var/mob/living/L in view(7, epicenter))
		if(L.client)
			shake_camera(L, 2, 3)

	// Earthquake visual buildup
	INVOKE_ASYNC(src, PROC_REF(do_seismic_slam), epicenter)
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/seismic_slam/proc/do_seismic_slam(turf/epicenter)
	// Create expanding cracks
	for(var/dist in 0 to 2)
		for(var/turf/T in spiral_range_turfs(dist, epicenter))
			new /obj/effect/temp_visual/ground_crack(T)
			if(prob(30))
				new /obj/effect/temp_visual/debris(T)
		sleep(1)

	// Calculate total tremor stacks
	var/total_stacks = 0
	var/list/affected_mobs = list()
	for(var/mob/living/simple_animal/hostile/M in range(2, epicenter))
		if(M.stat == DEAD)
			continue
		var/datum/status_effect/stacking/lc_tremor/tremor = M.has_status_effect(/datum/status_effect/stacking/lc_tremor)
		if(tremor)
			total_stacks += tremor.stacks
		affected_mobs += M

	var/damage = 20 + (total_stacks * 2)

	// Massive impact effect
	new /obj/effect/temp_visual/seismic_impact(epicenter)
	playsound(epicenter, 'sound/effects/meteorimpact.ogg', 75, TRUE)

	// Deal damage and TremorBurst all mobs
	for(var/mob/living/simple_animal/hostile/M in affected_mobs)
		M.apply_damage(damage, BLACK_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(M), pick(GLOB.alldirs))

		// TremorBurst
		var/datum/status_effect/stacking/lc_tremor/tremor = M.has_status_effect(/datum/status_effect/stacking/lc_tremor)
		if(tremor)
			tremor.TremorBurst()

		to_chat(M, span_userdanger("The seismic impact devastates you!"))

	to_chat(owner, span_notice("Your seismic slam deals [damage] damage to [affected_mobs.len] targets!"))

//=======================
// RESONANT STRIKE
//=======================

/obj/item/book/granter/action/skill/tremor/resonant_strike
	name = "Level 2: Resonant Strike"
	desc = "Your next attack within 5 seconds against a MOB with Tremor deals stacks * 3 bonus BLACK damage and reduces their Tremor by 50%."
	actionname = "Resonant Strike"
	granted_action = /datum/action/cooldown/skill/resonant_strike
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/resonant_strike
	name = "Resonant Strike"
	desc = "Your next attack within 5 seconds against a MOB with Tremor deals stacks * 3 bonus BLACK damage and reduces their Tremor by 50%."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "resonant_strike"
	cooldown_time = 5 SECONDS
	var/buff_duration = 5 SECONDS
	var/empowered = FALSE

/datum/action/cooldown/skill/resonant_strike/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Your next attack will resonate with tremor!"))
	empowered = TRUE

	// Add resonating effect to weapon
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		held_item.add_atom_colour("#663300", TEMPORARY_COLOUR_PRIORITY)
		var/mutable_appearance/resonance = mutable_appearance('icons/effects/effects.dmi', "electricity")
		resonance.color = "#996633"
		held_item.add_overlay(resonance)
		addtimer(CALLBACK(held_item, TYPE_PROC_REF(/atom, cut_overlay), resonance), buff_duration)

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/resonant_strike/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(!empowered || !target || target.stat == DEAD)
		return

	var/datum/status_effect/stacking/lc_tremor/tremor = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(!tremor)
		to_chat(source, span_warning("[target] has no tremor stacks!"))
		remove_buff()
		return

	var/bonus_damage = tremor.stacks * 3
	target.apply_damage(bonus_damage, BLACK_DAMAGE)

	// Reduce tremor by 50%
	var/reduction = ceil(tremor.stacks * 0.5)
	tremor.add_stacks(-reduction)

	// Resonance impact effect
	new /obj/effect/temp_visual/resonance_strike(get_turf(target))
	playsound(target, 'sound/effects/gong.ogg', 50, TRUE)
	playsound(target, 'sound/effects/break_stone.ogg', 25, TRUE)

	to_chat(target, span_userdanger("The strike resonates through your trembling body!"))
	to_chat(source, span_boldwarning("Your resonant strike deals [bonus_damage] bonus damage!"))

	remove_buff()

/datum/action/cooldown/skill/resonant_strike/proc/remove_buff()
	empowered = FALSE

	// Remove weapon effects
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		held_item.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)

	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

//=======================
// EARTHBOUND HAMMER
//=======================

/obj/item/book/granter/action/skill/tremor/earthbound_hammer
	name = "Level 2: Earthbound Hammer"
	desc = "After a short delay, teleport to target and deal your tremor stacks * 5 BLACK damage to all in 5x5 area. Reduces your tremor by 75%."
	actionname = "Earthbound Hammer"
	granted_action = /datum/action/cooldown/skill/earthbound_hammer
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/skill/earthbound_hammer
	name = "Earthbound Hammer"
	desc = "After a short delay, teleport to target and deal your tremor stacks * 5 BLACK damage to all in 5x5 area. Reduces your tremor by 75%."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "earthbound_hammer"
	cooldown_time = 20 SECONDS
	var/selecting_target = FALSE

/datum/action/cooldown/skill/earthbound_hammer/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click on a target to hammer down..."))
	selecting_target = TRUE
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/earthbound_hammer/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!target || source.stat == DEAD)
		return

	var/datum/status_effect/stacking/lc_tremor/my_tremor
	if(isliving(source))
		var/mob/living/L = source
		my_tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(!my_tremor)
		to_chat(source, span_warning("You have no tremor stacks to power the hammer!"))
		return

	// Defer the hammer strike to avoid sleep in signal handler
	INVOKE_ASYNC(src, PROC_REF(execute_hammer), source, target, my_tremor.stacks)

/datum/action/cooldown/skill/earthbound_hammer/proc/execute_hammer(mob/living/user, atom/target, tremor_stacks)
	var/turf/target_turf = get_turf(target)
	var/damage = tremor_stacks * 5

	// Charging effect
	to_chat(user, span_notice("You gather earthen power..."))
	user.visible_message(span_warning("[user] begins to glow with earthen energy!"))

	// Earth gathering visual
	new /obj/effect/temp_visual/earth_gathering(get_turf(user))
	animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
	user.pixel_z = 16
	playsound(user, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)

	sleep(10) // 1 second delay

	// Teleport with earth burst
	new /obj/effect/temp_visual/earth_burst(get_turf(user))
	user.forceMove(target_turf)
	new /obj/effect/temp_visual/earth_burst(target_turf)

	animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
	user.pixel_z = 0

	// Massive ground impact
	playsound(target_turf, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	playsound(target_turf, 'sound/effects/break_stone.ogg', 75, TRUE)

	// Screen shake
	for(var/mob/living/L in view(7, target_turf))
		if(L.client)
			shake_camera(L, 3, 4)

	// Create crater effect
	new /obj/effect/temp_visual/crater(target_turf)

	// Expanding damage waves
	for(var/dist in 0 to 2)
		for(var/turf/T in spiral_range_turfs(dist, target_turf))
			new /obj/effect/temp_visual/shockwave(T)
			for(var/mob/living/simple_animal/hostile/M in T)
				if(M.stat == DEAD)
					continue
				M.apply_damage(damage, BLACK_DAMAGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(M), get_dir(target_turf, M))
				to_chat(M, span_userdanger("The earthbound hammer crushes you!"))
		sleep(1)

	// Reduce user's tremor by 75%
	var/datum/status_effect/stacking/lc_tremor/my_tremor = user.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(my_tremor)
		var/new_stacks = max(0, my_tremor.stacks - ceil(my_tremor.stacks * 0.75))
		if(new_stacks > 0)
			my_tremor.add_stacks(new_stacks - my_tremor.stacks)
		else
			user.remove_status_effect(/datum/status_effect/stacking/lc_tremor)

	to_chat(user, span_notice("Your earthbound hammer deals [damage] damage!"))
	StartCooldown()

/datum/action/cooldown/skill/earthbound_hammer/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Earthbound hammer targeting cancelled."))

//=======================
// VISUAL EFFECTS
//=======================

// Shared visual effects for tremor skills

/obj/effect/temp_visual/ground_crack
	name = "ground crack"
	icon = 'icons/effects/effects.dmi'
	icon_state = "cracks"
	duration = 30
	color = "#663300"

/obj/effect/temp_visual/debris
	name = "debris"
	icon = 'icons/obj/mining.dmi'
	icon_state = "rock"
	duration = 20

/obj/effect/temp_visual/debris/Initialize()
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	transform = matrix() * 0.5
	animate(src, pixel_y = pixel_y + 16, alpha = 0, time = duration, easing = QUAD_EASING)

/obj/effect/temp_visual/seismic_impact
	name = "seismic impact"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "clockwork_gateway_closing"
	duration = 10
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/seismic_impact/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration, easing = CIRCULAR_EASING|EASE_OUT)

/obj/effect/temp_visual/resonance_strike
	name = "resonance"
	icon = 'icons/effects/effects.dmi'
	icon_state = "rockwarning"
	duration = 8
	color = "#996633"

/obj/effect/temp_visual/resonance_strike/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/earth_gathering
	name = "earth gathering"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	duration = 10
	color = "#663300"

/obj/effect/temp_visual/earth_gathering/Initialize()
	. = ..()
	animate(src, transform = matrix() * 2, alpha = 0, time = duration, easing = CIRCULAR_EASING|EASE_IN)

/obj/effect/temp_visual/earth_burst
	name = "earth burst"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	duration = 5
	color = "#996633"

/obj/effect/temp_visual/earth_burst/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/crater
	name = "impact crater"
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt_dug"
	layer = 2.9
	duration = 60
