/*
 * Overheat Support Skills (Level 1)
 * Support and control skills that use the overheat status effect
 */

//=======================
// SUPPORT SKILLS
//=======================

// Heat Transfer - Transfer stacks between enemies
/obj/item/book/granter/action/skill/overheat/heat_transfer
	name = "Level 1: Heat Transfer"
	actionname = "Heat Transfer"
	desc = "After activating this skill, for the next 5 seconds, the first target you hit, you gain up to 15 Overheat from the target, then the next target you hit, transfer up to 15 Overheat to them."
	granted_action = /datum/action/cooldown/skill/heat_transfer
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/skill/heat_transfer
	name = "Heat Transfer"
	desc = "After activating this skill, for the next 5 seconds, the first target you hit, you gain up to 15 Overheat from the target, then the next target you hit, transfer up to 15 Overheat to them."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "heat_transfer"
	cooldown_time = 15 SECONDS
	var/buff_duration = 5 SECONDS
	var/empowered = FALSE
	var/stage = 0 // 0 = inactive, 1 = ready to absorb, 2 = ready to transfer
	var/stored_overheat = 0

/datum/action/cooldown/skill/heat_transfer/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("You prepare to absorb and transfer heat! First hit absorbs, second hit transfers."))
	empowered = TRUE
	stage = 1
	stored_overheat = 0
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/heat_transfer/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(!empowered || !target || target.stat == DEAD)
		return

	// Stage 1: Absorb heat from target
	if(stage == 1)
		var/datum/status_effect/stacking/lc_overheat/overheat = target.has_status_effect(/datum/status_effect/stacking/lc_overheat)
		if(!overheat || overheat.stacks <= 0)
			to_chat(source, span_warning("[target] has no overheat stacks to absorb!"))
			return

		// Absorb up to 15 stacks
		stored_overheat = min(overheat.stacks, 15)
		overheat.add_stacks(-stored_overheat)

		// Visual effects for absorption
		new /obj/effect/temp_visual/heat_mirage(get_turf(target))
		new /obj/effect/temp_visual/heat_mirage(get_turf(source))

		// Particle flow from target to user
		for(var/i in 1 to 3)
			addtimer(CALLBACK(src, PROC_REF(create_transfer_particle), target, source), i * 2)

		// Energy absorption sounds
		playsound(target, 'sound/magic/lightningbolt.ogg', 30, TRUE)
		playsound(source, 'sound/items/welder2.ogg', 40, TRUE)

		// Apply overheat to self
		source.apply_lc_overheat(stored_overheat)

		to_chat(source, span_boldnotice("You absorb [stored_overheat] overheat stacks from [target]! Hit another target to transfer it."))
		to_chat(target, span_nicegreen("You feel heat being drawn from your body!"))

		stage = 2
		return

	// Stage 2: Transfer stored heat to new target
	if(stage == 2)
		if(stored_overheat <= 0)
			to_chat(source, span_warning("You have no stored heat to transfer!"))
			remove_buff()
			return

		// Transfer the stored overheat
		target.apply_lc_overheat(stored_overheat)

		// Remove the overheat from self
		var/datum/status_effect/stacking/lc_overheat/self_overheat = source.has_status_effect(/datum/status_effect/stacking/lc_overheat)
		if(self_overheat)
			self_overheat.add_stacks(-stored_overheat)

		// Create transfer beam effect
		new /obj/effect/temp_visual/heat_transfer_beam(source, target)

		// Heat mirage effects
		new /obj/effect/temp_visual/heat_mirage(get_turf(source))
		new /obj/effect/temp_visual/heat_mirage(get_turf(target))

		// Energy transfer sounds
		playsound(source, 'sound/magic/lightningbolt.ogg', 50, TRUE)
		playsound(target, 'sound/magic/fireball.ogg', 50, TRUE)

		// Particle flow effect
		for(var/i in 1 to 5)
			addtimer(CALLBACK(src, PROC_REF(create_transfer_particle), source, target), i * 2)

		// Heat waves rising from new target
		new /obj/effect/temp_visual/heat_waves(get_turf(target))

		to_chat(source, span_notice("You transfer [stored_overheat] overheat stacks to [target]!"))
		to_chat(target, span_userdanger("Burning heat suddenly floods into you!"))

		remove_buff()

/datum/action/cooldown/skill/heat_transfer/proc/create_transfer_particle(atom/start, atom/end)
	new /obj/effect/temp_visual/heat_particle(get_turf(start), get_turf(end))

/datum/action/cooldown/skill/heat_transfer/proc/remove_buff()
	empowered = FALSE
	stage = 0
	stored_overheat = 0
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

// Ignition Burst - AoE stack application
/obj/item/book/granter/action/skill/overheat/ignition_burst
	name = "Level 1: Ignition Burst"
	desc = "Apply 15 Overheat stacks to all enemies in a 3x3 area around you."
	actionname = "Ignition Burst"
	granted_action = /datum/action/cooldown/skill/ignition_burst
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/skill/ignition_burst
	name = "Ignition Burst"
	desc = "Apply 15 Overheat stacks to all enemies in a 3x3 area around you."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "ignition_burst"
	cooldown_time = 10 SECONDS
	var/stack_amount = 15
	var/range = 2

/datum/action/cooldown/skill/ignition_burst/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	var/turf/T = get_turf(owner)

	// Create flame pillar effect at user location
	new /obj/effect/temp_visual/flame_pillar(T)

	// Shockwave expanding outward
	INVOKE_ASYNC(src, PROC_REF(create_shockwave), T)

	// Thunderous ignition sound
	playsound(T, 'sound/magic/fireball.ogg', 100, TRUE)
	playsound(T, 'sound/effects/bamf.ogg', 75, TRUE)

	// Apply overheat with visual feedback
	var/targets_hit = 0
	for(var/mob/living/simple_animal/hostile/M in range(range, owner))
		if(M.stat == DEAD)
			continue
		M.apply_lc_overheat(stack_amount)
		// Stun visual effect
		new /obj/effect/temp_visual/fire_stun(get_turf(M))
		targets_hit++

	to_chat(owner, span_notice("You release a burst of igniting heat, affecting [targets_hit] targets!"))
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/ignition_burst/proc/create_shockwave(turf/epicenter)
	// Expanding shockwave rings
	for(var/dist in 0 to range)
		for(var/turf/ring_turf in spiral_range_turfs(dist, epicenter))
			new /obj/effect/temp_visual/shockwave_segment(ring_turf)
		sleep(1)

// Flame Lance - Targeted projectile
/obj/item/book/granter/action/skill/overheat/flame_lance
	name = "Level 1: Flame Lance"
	desc = "Fire a piercing projectile toward a selected target that applies 20 Overheat stacks to all enemies hit."
	actionname = "Flame Lance"
	granted_action = /datum/action/cooldown/skill/flame_lance
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/skill/flame_lance
	name = "Flame Lance"
	desc = "Fire a piercing projectile toward a selected target that applies 20 Overheat stacks to all enemies hit."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "flame_lance"
	cooldown_time = 10 SECONDS
	var/selecting_target = FALSE
	var/obj/effect/temp_visual/flame_reticle/current_reticle

/datum/action/cooldown/skill/flame_lance/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click on a target to fire your flame lance..."))
	selecting_target = TRUE

	// Create charging reticle
	current_reticle = new(owner.loc)
	current_reticle.follow_target = owner

	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/flame_lance/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!target || source.stat == DEAD)
		return

	// Defer the projectile firing to avoid sleep in signal handler
	INVOKE_ASYNC(src, PROC_REF(fire_projectile), source, target)

/datum/action/cooldown/skill/flame_lance/proc/fire_projectile(mob/source, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	// Muzzle flash effect
	new /obj/effect/temp_visual/muzzle_flash(get_turf(source))

	// Create enhanced projectile
	var/obj/projectile/flame_lance/P = new(source.loc)
	P.firer = source
	P.preparePixelProjectile(target, source)
	P.fire()

	// Enhanced sounds
	playsound(source, 'sound/magic/fireball.ogg', 75, TRUE)
	playsound(source, 'sound/weapons/lasercannonfire.ogg', 50, TRUE)
	StartCooldown()

/datum/action/cooldown/skill/flame_lance/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		if(current_reticle)
			qdel(current_reticle)
			current_reticle = null
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Flame lance targeting cancelled."))

/obj/projectile/flame_lance
	name = "flame lance"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "fireball"
	projectile_piercing = PASSMOB
	damage = 0
	speed = 0.5
	range = 15
	light_range = 3
	light_power = 2
	light_color = "#ff6600"

/obj/projectile/flame_lance/Initialize()
	. = ..()
	transform = transform.Scale(1.5, 1.5)

/obj/projectile/flame_lance/Moved()
	. = ..()
	// Leave burning trail
	if(prob(80))
		new /obj/effect/temp_visual/flame_trail(loc)

/obj/projectile/flame_lance/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			L.apply_lc_overheat(20)
			to_chat(L, span_userdanger("The flame lance sears through you!"))
			// Impact explosion
			new /obj/effect/temp_visual/flame_impact(get_turf(target))
			// Piercing sound
			playsound(target, 'sound/weapons/sear.ogg', 50, TRUE)
	else if(isturf(target) || isobj(target))
		// Leave scorch mark on walls/floors
		new /obj/effect/decal/cleanable/ash(get_turf(target))

//=======================
// CONTROL SKILLS
//=======================

// Cauterize - Targeted healing
/obj/item/book/granter/action/skill/overheat/cauterize
	name = "Level 1: Cauterize"
	desc = "Remove all Overheat from a selected target and heal them based on stacks removed."
	actionname = "Cauterize"
	granted_action = /datum/action/cooldown/skill/cauterize
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/skill/cauterize
	name = "Cauterize"
	desc = "Remove all Overheat from a selected target and heal them based on stacks removed."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "cauterize"
	cooldown_time = 10 SECONDS
	var/selecting_target = FALSE

/datum/action/cooldown/skill/cauterize/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Click on a target to cauterize their wounds..."))
	selecting_target = TRUE
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_target_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/skill/cauterize/proc/on_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	if(!selecting_target)
		return

	cancel_targeting()

	if(!isliving(target) || source.stat == DEAD)
		return

	var/mob/living/L = target
	var/datum/status_effect/stacking/lc_overheat/overheat = L.has_status_effect(/datum/status_effect/stacking/lc_overheat)

	if(!overheat)
		to_chat(source, span_warning("[target] has no overheat to cauterize!"))
		return

	var/heal_amount = overheat.stacks * 5

	// Healing flame aura
	new /obj/effect/temp_visual/healing_flame_aura(get_turf(target))

	// Remove overheat with visual effect
	overheat.stacks = 0
	overheat.fadeout_effect()
	qdel(overheat)

	// Steam effects from cauterization
	for(var/i in 1 to 3)
		addtimer(CALLBACK(src, PROC_REF(create_steam), target), i * 3)

	// Heal target
	L.adjustBruteLoss(-heal_amount)
	L.adjustFireLoss(-heal_amount)

	// Golden glow overlay
	var/mutable_appearance/golden_glow = mutable_appearance('icons/effects/effects.dmi', "shield-old")
	golden_glow.alpha = 100
	golden_glow.color = "#ffcc00"
	L.add_overlay(golden_glow)
	addtimer(CALLBACK(L, TYPE_PROC_REF(/atom, cut_overlay), golden_glow), 10)

	// Ascending healing particles
	for(var/i in 1 to 5)
		new /obj/effect/temp_visual/healing_particle(get_turf(target))

	// Combined sounds
	playsound(L, 'sound/magic/staff_healing.ogg', 50, TRUE)
	playsound(L, 'sound/items/welder2.ogg', 25, TRUE)

	to_chat(source, span_notice("You cauterize [L]'s wounds with healing flames, restoring [heal_amount] health!"))
	to_chat(L, span_nicegreen("Healing flames seal your wounds as the burning heat is drawn away!"))

	StartCooldown()

/datum/action/cooldown/skill/cauterize/proc/create_steam(atom/target)
	new /obj/effect/temp_visual/steam_puff(get_turf(target))

/datum/action/cooldown/skill/cauterize/proc/cancel_targeting()
	if(selecting_target)
		selecting_target = FALSE
		UnregisterSignal(owner, COMSIG_MOB_CLICKON)
		to_chat(owner, span_notice("Cauterize targeting cancelled."))

// Spreading Ashes - Area denial
/obj/item/book/granter/action/skill/overheat/spreading_ashes
	name = "Level 1: Spreading Ashes"
	desc = "Create a 3x3 area that slows enemies and applies 5 Overheat to those with 15+ stacks for 10 seconds."
	actionname = "Spreading Ashes"
	granted_action = /datum/action/cooldown/skill/spreading_ashes
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/skill/spreading_ashes
	name = "Spreading Ashes"
	desc = "Create a 3x3 area that slows enemies and applies 5 Overheat to those with 15+ stacks for 10 seconds."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "spreading_ashes"
	cooldown_time = 20 SECONDS
	var/effect_duration = 10 SECONDS

/datum/action/cooldown/skill/spreading_ashes/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	var/turf/center = get_turf(owner)

	// Spreading animation
	for(var/dist in 0 to 1)
		for(var/turf/T in spiral_range_turfs(dist, center))
			new /obj/effect/temp_visual/ash_field(T, effect_duration)
		sleep(2)

	// Multiple sound layers
	playsound(center, 'sound/effects/smoke.ogg', 75, TRUE)
	playsound(center, 'sound/items/welder.ogg', 25, TRUE)

	to_chat(owner, span_notice("You spread burning ashes in a choking cloud around you!"))

	StartCooldown()
	return TRUE

/obj/effect/temp_visual/ash_field
	name = "burning ashes"
	desc = "A field of smoldering ashes."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	color = "#663300"
	alpha = 128
	duration = 20 SECONDS
	var/next_damage = 0
	var/next_particle = 0
	var/sound_loop

/obj/effect/temp_visual/ash_field/Initialize(mapload, duration)
	. = ..()
	QDEL_IN(src, duration)
	START_PROCESSING(SSobj, src)

	// Swirling animation
	animate(src, transform = turn(transform, 360), time = 40, loop = -1)

	// Ambient crackling sound
	sound_loop = addtimer(CALLBACK(src, PROC_REF(ambient_sound)), 0, TIMER_STOPPABLE|TIMER_LOOP)

/obj/effect/temp_visual/ash_field/proc/ambient_sound()
	if(prob(30))
		playsound(loc, pick('sound/effects/comfyfire.ogg', 'sound/items/welder.ogg'), 15, TRUE)

/obj/effect/temp_visual/ash_field/Destroy()
	if(sound_loop)
		deltimer(sound_loop)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/temp_visual/ash_field/process()
	// Ember particles
	if(world.time >= next_particle)
		next_particle = world.time + rand(5, 15)
		if(prob(40))
			new /obj/effect/temp_visual/ash_ember(loc)

	// Occasional flare-ups
	if(prob(5))
		new /obj/effect/temp_visual/small_fire_flare(loc)

	if(world.time < next_damage)
		return

	next_damage = world.time + 10 // 1 second

	for(var/mob/living/simple_animal/hostile/M in loc)
		if(M.stat == DEAD)
			continue

		// Slow effect with visual feedback
		M.add_movespeed_modifier(/datum/movespeed_modifier/ash_field)
		addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/ash_field), 2 SECONDS)

		// Footprint effect
		if(prob(50))
			new /obj/effect/temp_visual/ash_footprint(loc)

		// Coughing effect
		if(prob(30))
			M.emote("cough")

		// Apply overheat if they have 15+ stacks
		var/datum/status_effect/stacking/lc_overheat/overheat = M.has_status_effect(/datum/status_effect/stacking/lc_overheat)
		if(overheat && overheat.stacks >= 15)
			M.apply_lc_overheat(5)
			new /obj/effect/temp_visual/small_smoke(get_turf(M))

/datum/movespeed_modifier/ash_field
	variable = TRUE
	multiplicative_slowdown = 0.5

// Feeding the Embers - Conditional stack application
/obj/item/book/granter/action/skill/overheat/feeding_embers
	name = "Level 1: Feeding the Embers"
	desc = "Your next melee attack within 5 seconds inflicts 25 Overheat if the target has 15+ stacks. Otherwise, inflict only 5 Overheat"
	actionname = "Feeding the Embers"
	granted_action = /datum/action/cooldown/skill/feeding_embers
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/skill/feeding_embers
	name = "Feeding the Embers"
	desc = "Your next melee attack within 5 seconds inflicts 25 Overheat if the target has 15+ stacks. Otherwise, inflict only 5 Overheat"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "feeding_embers"
	cooldown_time = 15 SECONDS
	var/buff_duration = 5 SECONDS
	var/empowered = FALSE
	var/obj/effect/ember_glow/weapon_glow

/datum/action/cooldown/skill/feeding_embers/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("You prepare to feed the embers!"))
	empowered = TRUE

	// Weapon ember glow
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		weapon_glow = new(held_item.loc)
		weapon_glow.layer = held_item.layer - 0.01
		held_item.vis_contents += weapon_glow

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/skill/feeding_embers/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(!empowered || !target || target.stat == DEAD)
		return

	// Ignition spark check
	new /obj/effect/temp_visual/ignition_spark(get_turf(target))

	var/datum/status_effect/stacking/lc_overheat/overheat = target.has_status_effect(/datum/status_effect/stacking/lc_overheat)

	if(!overheat || overheat.stacks < 15)
		// Lesser effect
		to_chat(source, span_warning("[target] doesn't have enough heat to properly feed the embers!"))
		target.apply_lc_overheat(5)
		new /obj/effect/temp_visual/small_smoke(get_turf(target))
		playsound(target, 'sound/items/match_strike.ogg', 30, TRUE)
		remove_buff()
		return

	// Full effect - Apply additional overheat
	target.apply_lc_overheat(25)

	// Flame burst effect
	new /obj/effect/temp_visual/ember_burst(get_turf(target))

	// Ember particles from target to user
	for(var/i in 1 to 3)
		addtimer(CALLBACK(src, PROC_REF(create_ember_flow), target, source), i * 2)

	// Kindle sounds
	playsound(target, 'sound/items/welder2.ogg', 50, TRUE)
	playsound(target, 'sound/magic/fireball.ogg', 30, TRUE)

	to_chat(target, span_userdanger("The embers within you burst into roaring flames!"))
	to_chat(source, span_boldnotice("You successfully feed the embers, igniting [target] with 20 overheat stacks!"))

	// Brief flame aura on user
	var/mutable_appearance/flame_aura = mutable_appearance('icons/mob/OnFire.dmi', "Standing")
	flame_aura.alpha = 100
	flame_aura.color = "#ff6600"
	source.add_overlay(flame_aura)
	addtimer(CALLBACK(source, TYPE_PROC_REF(/atom, cut_overlay), flame_aura), 5)

	remove_buff()

/datum/action/cooldown/skill/feeding_embers/proc/create_ember_flow(atom/start, atom/end)
	new /obj/effect/temp_visual/ember_particle_flow(get_turf(start), get_turf(end))

/datum/action/cooldown/skill/feeding_embers/proc/remove_buff()
	empowered = FALSE

	// Remove weapon glow
	if(weapon_glow)
		var/obj/item/held_item = owner.get_active_held_item()
		if(held_item)
			held_item.vis_contents -= weapon_glow
		qdel(weapon_glow)
		weapon_glow = null

	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

//=======================
// VISUAL EFFECTS
//=======================

// Shared visual effects for overheat support skills

/obj/effect/temp_visual/heat_transfer_beam
	name = "heat transfer"
	icon = 'icons/effects/effects.dmi'
	icon_state = "lightning"
	duration = 10
	color = "#ff6600"

/obj/effect/temp_visual/heat_transfer_beam/Initialize(mapload, atom/end_target)
	. = ..()
	if(end_target)
		var/turf/start_turf = get_turf(src)
		var/turf/end_turf = get_turf(end_target)
		var/angle = Get_Angle(start_turf, end_turf)
		transform = turn(transform, angle)
		var/distance = get_dist(start_turf, end_turf)
		transform = transform.Scale(distance, 1)
		animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/heat_mirage
	name = "heat mirage"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	duration = 15
	color = "#ff9900"
	alpha = 100

/obj/effect/temp_visual/heat_mirage/Initialize()
	. = ..()
	animate(src, transform = matrix() * 1.5, alpha = 0, time = duration, easing = SINE_EASING)

/obj/effect/temp_visual/heat_particle
	name = "heat particle"
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	duration = 10
	color = "#ff6600"

/obj/effect/temp_visual/heat_particle/Initialize(mapload, turf/target_turf)
	. = ..()
	if(target_turf)
		animate(src, pixel_x = target_turf.x - x, pixel_y = target_turf.y - y, time = duration, easing = QUAD_EASING)
		animate(alpha = 0, time = 2)

/obj/effect/temp_visual/heat_waves
	name = "heat waves"
	icon = 'icons/effects/effects.dmi'
	icon_state = "mech_fire"
	duration = 20
	color = "#ff3300"
	alpha = 150

/obj/effect/temp_visual/heat_waves/Initialize()
	. = ..()
	animate(src, pixel_y = pixel_y + 16, alpha = 0, time = duration)

// Flame pillar effect
/obj/effect/temp_visual/flame_pillar
	name = "flame pillar"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion"
	duration = 10
	color = "#ff6600"

/obj/effect/temp_visual/flame_pillar/Initialize()
	. = ..()
	transform = matrix() * 2
	animate(src, alpha = 0, time = duration)

// Shockwave segment
/obj/effect/temp_visual/shockwave_segment
	name = "shockwave"
	icon = 'icons/effects/effects.dmi'
	icon_state = "mech_fire"
	duration = 5
	color = "#ff9900"
	alpha = 150

/obj/effect/temp_visual/shockwave_segment/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

// Fire stun visual
/obj/effect/temp_visual/fire_stun
	name = "fire stun"
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	duration = 5

/obj/effect/temp_visual/fire_stun/Initialize()
	. = ..()
	animate(src, pixel_y = pixel_y + 8, alpha = 0, time = duration)

// Flame lance visual effects
/obj/effect/temp_visual/flame_reticle
	name = "targeting reticle"
	icon = 'icons/effects/effects.dmi'
	icon_state = "emfield_s3"
	color = "#ff3300"
	alpha = 150
	var/mob/follow_target

/obj/effect/temp_visual/flame_reticle/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	animate(src, transform = matrix() * 1.2, alpha = 200, time = 5, loop = -1)
	animate(transform = matrix() * 0.8, alpha = 100, time = 5)

/obj/effect/temp_visual/flame_reticle/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/temp_visual/flame_reticle/process()
	if(!follow_target || QDELETED(follow_target))
		qdel(src)
		return
	loc = follow_target.loc

/obj/effect/temp_visual/muzzle_flash
	name = "muzzle flash"
	icon = 'icons/effects/effects.dmi'
	icon_state = "quantum_sparks"
	duration = 3
	color = "#ff6600"

/obj/effect/temp_visual/flame_trail
	name = "flame trail"
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	duration = 10
	color = "#ff9900"
	alpha = 150

/obj/effect/temp_visual/flame_trail/Initialize()
	. = ..()
	icon_state = pick("1", "2", "3")
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/flame_impact
	name = "flame impact"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	duration = 5
	color = "#ff6600"

// Cauterize visual effects
/obj/effect/temp_visual/healing_flame_aura
	name = "healing flames"
	icon = 'icons/effects/effects.dmi'
	icon_state = "forcefield"
	duration = 15
	color = "#ffcc00"
	alpha = 150

/obj/effect/temp_visual/healing_flame_aura/Initialize()
	. = ..()
	animate(src, transform = matrix() * 1.5, alpha = 0, time = duration, easing = SINE_EASING)

/obj/effect/temp_visual/healing_particle
	name = "healing spark"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	duration = 20
	color = "#ffcc00"

/obj/effect/temp_visual/healing_particle/Initialize()
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	animate(src, pixel_y = pixel_y + 24, alpha = 0, time = duration, easing = SINE_EASING)

/obj/effect/temp_visual/steam_puff
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	duration = 10
	color = "#ffffff"
	alpha = 150

/obj/effect/temp_visual/steam_puff/Initialize()
	. = ..()
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)
	animate(src, pixel_y = pixel_y + 12, alpha = 0, transform = matrix() * 1.5, time = duration)

// Ash field visual effects
/obj/effect/temp_visual/ash_ember
	name = "floating ember"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	duration = 20
	color = "#ff6600"

/obj/effect/temp_visual/ash_ember/Initialize()
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	animate(src, pixel_y = pixel_y + 16, alpha = 0, time = duration, easing = SINE_EASING)

/obj/effect/temp_visual/small_fire_flare
	name = "fire flare"
	icon = 'icons/effects/fire.dmi'
	icon_state = "2"
	duration = 5
	color = "#ff9900"

/obj/effect/temp_visual/small_fire_flare/Initialize()
	. = ..()
	transform = matrix() * 0.5
	animate(src, transform = matrix() * 1.2, alpha = 0, time = duration)

/obj/effect/temp_visual/ash_footprint
	name = "ashy footprint"
	icon = 'icons/effects/blood.dmi'
	icon_state = "tracks"
	duration = 30
	color = "#333333"
	alpha = 100

/obj/effect/temp_visual/ash_footprint/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	animate(src, alpha = 0, time = duration)

// Ember glow effect
/obj/effect/ember_glow
	name = "ember glow"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	color = "#ff6600"
	alpha = 100

/obj/effect/ember_glow/Initialize()
	. = ..()
	animate(src, alpha = 150, time = 5, loop = -1)
	animate(alpha = 50, time = 5)

// Ignition spark
/obj/effect/temp_visual/ignition_spark
	name = "ignition spark"
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 3
	color = "#ff9900"

// Ember burst
/obj/effect/temp_visual/ember_burst
	name = "ember burst"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion"
	duration = 5
	color = "#ff6600"

/obj/effect/temp_visual/ember_burst/Initialize()
	. = ..()
	transform = matrix() * 0.5
	animate(src, transform = matrix() * 1.5, alpha = 0, time = duration)

// Ember particle flow
/obj/effect/temp_visual/ember_particle_flow
	name = "flowing ember"
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	duration = 8
	color = "#ff9900"

/obj/effect/temp_visual/ember_particle_flow/Initialize(mapload, turf/target_turf)
	. = ..()
	if(target_turf)
		var/matrix/M = matrix()
		M.Turn(Get_Angle(loc, target_turf))
		transform = M
		animate(src, pixel_x = (target_turf.x - x) * 32, pixel_y = (target_turf.y - y) * 32, time = duration, easing = QUAD_EASING|EASE_OUT)
		animate(alpha = 0, time = 2)

// Small smoke effect
/obj/effect/temp_visual/small_smoke
	name = "smoke"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	duration = 5
	alpha = 150

/obj/effect/temp_visual/small_smoke/Initialize()
	. = ..()
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)
	animate(src, pixel_y = pixel_y + 8, alpha = 0, time = duration)
