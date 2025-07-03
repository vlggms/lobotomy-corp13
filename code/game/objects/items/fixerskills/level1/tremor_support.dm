/*
 * Level 1 Tremor Support Skills
 * These skills interact with the lc_tremor status effect
 */

//=======================
// SUPPORT SKILLS
//=======================

// Aftershock - AoE tremor on attacks
/obj/item/book/granter/action/skill/tremor/aftershock
	name = "Level 1 Tremor Skill: Aftershock"
	desc = "Your next 3 melee attacks apply 5 Tremor stacks to all mobs in a 3x3 AoE centered on the target."
	actionname = "Aftershock"
	granted_action = /datum/action/cooldown/skill/aftershock
	level = 1
	remarks = list("The ground trembles with each strike...", "My attacks create ripples in the earth...", "Every blow echoes through the ground...")
	custom_premium_price = 600

/datum/action/cooldown/skill/aftershock
	name = "Aftershock"
	desc = "Your next 3 melee attacks apply 5 Tremor stacks to all mobs in a 3x3 AoE centered on the target."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "aftershock"
	cooldown_time = 15 SECONDS
	var/attacks_remaining = 0
	var/buff_duration = 5 SECONDS

/datum/action/cooldown/skill/aftershock/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Your attacks will create aftershocks!"))
	attacks_remaining = 3

	// Add earth effect to weapon
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		held_item.add_atom_colour("#663300", TEMPORARY_COLOUR_PRIORITY)

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/aftershock/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(attacks_remaining <= 0 || !target || target.stat == DEAD)
		return

	attacks_remaining--

	// Create aftershock effect
	var/turf/epicenter = get_turf(target)
	new /obj/effect/temp_visual/small_shockwave(epicenter)
	playsound(epicenter, 'sound/effects/break_stone.ogg', 50, TRUE)

	// Apply tremor in 3x3
	for(var/mob/living/simple_animal/hostile/M in range(1, epicenter))
		if(M.stat == DEAD)
			continue
		M.apply_lc_tremor(5, 55)
		new /obj/effect/temp_visual/ground_crack(get_turf(M))
		to_chat(M, span_warning("The aftershock makes you unsteady!"))

	to_chat(source, span_boldnotice("Aftershock! ([attacks_remaining] attacks remaining)"))

	if(attacks_remaining <= 0)
		remove_buff()

/datum/action/cooldown/skill/aftershock/proc/remove_buff()
	attacks_remaining = 0

	// Remove weapon color
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		held_item.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)

	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

// Seismic Wave - Piercing projectile
/obj/item/book/granter/action/skill/tremor/seismic_wave
	name = "Level 1 Tremor Skill: Seismic Wave"
	desc = "Send a piercing projectile that applies tiles traveled * 5 Tremor stacks to all it hits (max 10 tiles)."
	actionname = "Seismic Wave"
	granted_action = /datum/action/cooldown/skill/seismic_wave
	level = 1
	remarks = list("The earth ripples before me...", "I can send tremors through the ground...", "Waves of force travel through stone...")
	custom_premium_price = 600

/datum/action/cooldown/skill/seismic_wave
	name = "Seismic Wave"
	desc = "Send a piercing projectile that applies tiles traveled * 5 Tremor stacks to all it hits (max 10 tiles)."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "seismic_wave"
	cooldown_time = 10 SECONDS
	var/selecting_target = FALSE

/datum/action/cooldown/skill/seismic_wave/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click to send a seismic wave..."))
	selecting_target = TRUE
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/seismic_wave/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!target || source.stat == DEAD)
		return

	// Defer projectile firing to avoid sleep in signal handler
	INVOKE_ASYNC(src, PROC_REF(fire_wave), source, target)

/datum/action/cooldown/skill/seismic_wave/proc/fire_wave(mob/source, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	// Create seismic wave projectile
	var/obj/projectile/seismic_wave/W = new(source.loc)
	W.firer = source
	W.preparePixelProjectile(target, source)
	W.fire()

	// Ground rumble effect
	playsound(source, 'sound/effects/stonedoor_openclose.ogg', 75, TRUE)
	StartCooldown()

/datum/action/cooldown/skill/seismic_wave/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Seismic wave targeting cancelled."))

// Shattered Resentment - Launch target with animation
/obj/item/book/granter/action/skill/tremor/shattered_resentment
	name = "Level 1 Tremor Skill: Shattered Resentment"
	desc = "Trigger the target to gain 20 Tremor."
	actionname = "Shattered Resentment"
	granted_action = /datum/action/cooldown/skill/shattered_resentment
	level = 1
	remarks = list("The earth itself rejects them...", "I can shatter their stability...", "They will know the wrath of trembling ground...")
	custom_premium_price = 600

/datum/action/cooldown/skill/shattered_resentment
	name = "Shattered Resentment"
	desc = "Trigger the target to gain 20 Tremor."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "shattered_resentment"
	cooldown_time = 8 SECONDS
	var/selecting_target = FALSE

/datum/action/cooldown/skill/shattered_resentment/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click on a target to shatter their stability..."))
	selecting_target = TRUE
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/shattered_resentment/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!isliving(target) || source.stat == DEAD)
		return

	var/mob/living/L = target
	if(L.stat == DEAD)
		return

	// Launch animation with spinning
	INVOKE_ASYNC(src, PROC_REF(execute_shatter), L)
	StartCooldown()

/datum/action/cooldown/skill/shattered_resentment/proc/execute_shatter(mob/living/target)
	// Ground eruption effect
	new /obj/effect/temp_visual/kinetic_blast(get_turf(target))
	playsound(target, 'sound/effects/break_stone.ogg', 75, TRUE)
	playsound(target, 'sound/effects/bamf.ogg', 50, TRUE)

	// Launch into air with spin
	animate(target, pixel_z = 32, transform = turn(matrix(), 360), time = 5, easing = SINE_EASING)
	animate(pixel_z = 0, transform = matrix(), time = 5, easing = BOUNCE_EASING)

	// Apply tremor
	target.apply_lc_tremor(20, 55)

	// Impact effects when landing
	sleep(10)
	new /obj/effect/temp_visual/kinetic_blast(get_turf(target))
	playsound(target, 'sound/effects/meteorimpact.ogg', 50, TRUE)
	shake_camera(target, 2, 2)

	to_chat(target, span_userdanger("The earth rejects you violently!"))
	to_chat(owner, span_notice("You shatter [target]'s stability!"))

/datum/action/cooldown/skill/shattered_resentment/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Shattered resentment targeting cancelled."))

//=======================
// CONTROL SKILLS
//=======================

// Stabilizing Stance - Remove tremor and grant speed
/obj/item/book/granter/action/skill/tremor/stabilizing_stance
	name = "Level 1 Tremor Skill: Stabilizing Stance"
	desc = "Remove all Tremor from yourself and allies in 3x3 area. Allies who had tremor gain 50% speed for 3 seconds."
	actionname = "Stabilizing Stance"
	granted_action = /datum/action/cooldown/skill/stabilizing_stance
	level = 1
	remarks = list("I find balance in chaos...", "The trembling earth becomes still...", "Stability flows through me...")
	custom_premium_price = 600

/datum/action/cooldown/skill/stabilizing_stance
	name = "Stabilizing Stance"
	desc = "Remove all Tremor from yourself and allies in 3x3 area. Allies who had tremor gain 50% speed for 3 seconds."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "stabilizing_stance"
	cooldown_time = 10 SECONDS

/datum/action/cooldown/skill/stabilizing_stance/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	var/turf/center = get_turf(owner)

	// Stabilizing pulse effect
	new /obj/effect/temp_visual/stable_ground(center)
	playsound(center, 'sound/effects/podwoosh.ogg', 50, TRUE)

	// Remove tremor from allies and grant speed
	var/allies_helped = 0
	for(var/mob/living/carbon/human/H in range(1, center))
		var/datum/status_effect/stacking/lc_tremor/tremor = H.has_status_effect(/datum/status_effect/stacking/lc_tremor)
		if(tremor)
			tremor.stacks = 0
			qdel(tremor)

			// Grant speed boost
			H.add_movespeed_modifier(/datum/movespeed_modifier/stabilized)
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/stabilized), 3 SECONDS)

			// Visual feedback
			new /obj/effect/temp_visual/stable_ground(get_turf(H))
			to_chat(H, span_nicegreen("Your footing becomes steady and swift!"))
			allies_helped++

	to_chat(owner, span_notice("You stabilize [allies_helped] allies!"))
	StartCooldown()
	return TRUE

// Tectonic Shift - Difficult terrain
/obj/item/book/granter/action/skill/tremor/tectonic_shift
	name = "Level 1 Tremor Skill: Tectonic Shift"
	desc = "Create 3x3 terrain that applies 4 Tremor every 2 seconds to targets. MOBs only gain tremor if they have 15+ already."
	actionname = "Tectonic Shift"
	granted_action = /datum/action/cooldown/skill/tectonic_shift
	level = 1
	remarks = list("The plates move at my command...", "I can reshape the battlefield...", "The ground itself becomes my weapon...")
	custom_premium_price = 600

/datum/action/cooldown/skill/tectonic_shift
	name = "Tectonic Shift"
	desc = "Create 3x3 terrain that applies 4 Tremor every 2 seconds to targets. MOBs only gain tremor if they have 15+ already."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "tectonic_shift"
	cooldown_time = 20 SECONDS
	var/selecting_target = FALSE

/datum/action/cooldown/skill/tectonic_shift/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click where to create tectonic terrain..."))
	selecting_target = TRUE
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/tectonic_shift/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!target || source.stat == DEAD)
		return

	var/turf/center = get_turf(target)

	// Create tectonic terrain
	for(var/turf/T in range(1, center))
		new /obj/effect/tectonic_terrain(T, owner)

	playsound(center, 'sound/effects/break_stone.ogg', 75, TRUE)
	to_chat(source, span_notice("You shift the tectonic plates!"))

	StartCooldown()

/datum/action/cooldown/skill/tectonic_shift/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Tectonic shift targeting cancelled."))

// Repelling Motion - Knockback aura
/obj/item/book/granter/action/skill/tremor/repelling_motion
	name = "Level 1 Tremor Skill: Repelling Motion"
	desc = "For 10 seconds, every second throw all mobs in 3x3 area 3 tiles away and inflict 3 Tremor if they have less than 15."
	actionname = "Repelling Motion"
	granted_action = /datum/action/cooldown/skill/repelling_motion
	level = 1
	remarks = list("The earth itself pushes them away...", "Tremors emanate from within...", "None shall approach through these vibrations...")
	custom_premium_price = 600

/datum/action/cooldown/skill/repelling_motion
	name = "Repelling Motion"
	desc = "For 10 seconds, every second throw all mobs in 3x3 area 3 tiles away and inflict 3 Tremor if they have less than 15."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "repelling_motion"
	cooldown_time = 20 SECONDS
	var/active = FALSE

/datum/action/cooldown/skill/repelling_motion/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("You begin emanating repelling tremors!"))
	active = TRUE

	// Visual aura
	var/mutable_appearance/tremor_aura = mutable_appearance('icons/effects/effects.dmi', "forcefield")
	tremor_aura.color = "#663300"
	tremor_aura.alpha = 100
	owner.add_overlay(tremor_aura)

	// Start the repelling effect
	addtimer(CALLBACK(src, PROC_REF(repel_tick), 10, tremor_aura), 0)

	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/repelling_motion/proc/repel_tick(remaining_ticks, mutable_appearance/aura)
	if(!active || remaining_ticks <= 0 || owner.stat == DEAD)
		owner.cut_overlay(aura)
		active = FALSE
		return

	// Repelling pulse visual
	new /obj/effect/temp_visual/repelling_pulse(get_turf(owner))
	playsound(owner, 'sound/effects/space_wind.ogg', 50, TRUE)

	// Throw all mobs in range
	for(var/mob/living/simple_animal/hostile/M in range(1, owner))
		if(M.stat == DEAD)
			continue

		// Calculate throw direction (away from user)
		var/throw_dir = get_dir(owner, M)
		var/turf/throw_target = get_edge_target_turf(M, throw_dir)

		// Throw the mob
		M.throw_at(throw_target, 3, 1)

		// Apply tremor if they have less than 15
		var/datum/status_effect/stacking/lc_tremor/tremor = M.has_status_effect(/datum/status_effect/stacking/lc_tremor)
		if(!tremor || tremor.stacks < 15)
			M.apply_lc_tremor(3, 55)

		to_chat(M, span_warning("Tremors repel you away!"))

	// Continue for next tick
	addtimer(CALLBACK(src, PROC_REF(repel_tick), remaining_ticks - 1, aura), 10)

//=======================
// VISUAL EFFECTS
//=======================

/obj/effect/temp_visual/shockwave
	icon = 'icons/effects/effects.dmi'
	icon_state = "blip"
	color = "#674801"
	duration = 6

/obj/effect/temp_visual/shockwave/Initialize()
	. = ..()
	transform = matrix()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/small_shockwave
	icon = 'icons/effects/effects.dmi'
	icon_state = "blip"
	color = "#674801"
	duration = 6

/obj/effect/temp_visual/small_shockwave/Initialize()
	. = ..()
	transform = matrix() * 0.5
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/impact_crater
	icon = 'icons/effects/effects.dmi'
	icon_state = "crater"
	duration = 30

/obj/effect/temp_visual/impact_crater/Initialize()
	. = ..()
	alpha = 200
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/resonance
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity2"
	duration = 10

/obj/effect/temp_visual/resonance/Initialize()
	. = ..()
	animate(src, transform = matrix() * 1.5, alpha = 0, time = duration)

/obj/effect/temp_visual/stable_ground
	icon = 'icons/effects/effects.dmi'
	icon_state = "blip"
	duration = 6
	color = "#59ab23"

/obj/effect/temp_visual/stable_ground/Initialize()
	. = ..()
	alpha = 100
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/ground_crack
	icon = 'icons/effects/effects.dmi'
	icon_state = "yincracks"
	color = "#674801"
	duration = 13

/obj/effect/temp_visual/ground_crack/Initialize()
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	dir = pick(GLOB.alldirs)

/obj/effect/temp_visual/repelling_pulse
	icon = 'icons/effects/effects.dmi'
	icon_state = "alriune_attack"
	duration = 4.2
	color = "#8B7355"

/obj/effect/temp_visual/repelling_pulse/Initialize()
	. = ..()
	transform = matrix() * 0.5
	animate(src, transform = matrix() * 2, alpha = 0, time = duration)

//=======================
// PROJECTILES
//=======================

/obj/projectile/seismic_wave
	name = "seismic wave"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "guardian"
	color = "#8B7355"
	damage = 0
	speed = 1
	range = 10
	projectile_piercing = PASSMOB
	var/distance_traveled = 0

/obj/projectile/seismic_wave/Initialize()
	. = ..()
	transform = matrix() * 2

/obj/projectile/seismic_wave/Moved()
	. = ..()
	distance_traveled++
	if(prob(30))
		new /obj/effect/temp_visual/ground_crack(loc)

/obj/projectile/seismic_wave/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			var/tremor_stacks = min(distance_traveled * 5, 50)
			L.apply_lc_tremor(tremor_stacks, 55)
			new /obj/effect/temp_visual/small_shockwave(get_turf(L))
			to_chat(L, span_warning("The seismic wave destabilizes you!"))

//=======================
// MOVESPEED MODIFIERS
//=======================

/datum/movespeed_modifier/stabilized
	variable = TRUE
	multiplicative_slowdown = -0.5

//=======================
// TECTONIC TERRAIN
//=======================

/obj/effect/tectonic_terrain
	name = "unstable ground"
	desc = "The ground here shifts and cracks constantly."
	icon = 'icons/turf/floors.dmi'
	icon_state = "wasteland1"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER + 0.1
	var/mob/living/owner

/obj/effect/tectonic_terrain/Initialize(mapload, mob/living/caster)
	. = ..()
	owner = caster
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, 15 SECONDS)
	color = "#8B7355"
	alpha = 150

/obj/effect/tectonic_terrain/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/tectonic_terrain/process()
	// Create cracks
	if(prob(20))
		new /obj/effect/temp_visual/ground_crack(loc)

	// Apply tremor
	for(var/mob/living/L in get_turf(src))
		if(L.stat == DEAD)
			continue

		if(!isanimal(L))
			// Non-mobs always get tremor
			L.apply_lc_tremor(4, 55)
		else
			// Mobs only get tremor if they have 15+ already
			var/datum/status_effect/stacking/lc_tremor/tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
			if(tremor && tremor.stacks >= 15)
				L.apply_lc_tremor(4, 55)
