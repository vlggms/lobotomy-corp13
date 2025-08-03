// Music Note Mob
/mob/living/simple_animal/hostile/pianist_music_note
	name = "resonating music note"
	desc = "A physical manifestation of sound that pulses with malevolent energy."
	icon = 'ModularTegustation/Teguicons/pianist_effects.dmi'
	icon_state = "music_note_1"
	layer = ABOVE_MOB_LAYER
	density = TRUE
	move_resist = MOVE_FORCE_OVERPOWERING
	opacity = FALSE

	health = 500
	maxHealth = 500
	mob_biotypes = MOB_ROBOTIC
	movement_type = FLYING
	is_flying_animal = TRUE
	AIStatus = AI_OFF
	del_on_death = FALSE // We handle deletion manually

	var/mob/living/simple_animal/hostile/distortion/pianist/pianist_owner
	var/damage_amount = 15
	var/ring_cooldown = 0
	var/ring_cooldown_time = 4 SECONDS
	var/duration = 20 SECONDS
	var/ring_range = 1 // 3x3 = range(1)

	// Resistances as per design doc
	damage_coeff = list(RED_DAMAGE = 1.4, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)

/mob/living/simple_animal/hostile/pianist_music_note/Initialize()
	. = ..()
	icon_state = pick("music_note_1", "music_note_2")
	QDEL_IN(src, duration)
	playsound(src, 'sound/abnormalities/fateloom/garrote.ogg', 50, TRUE)
	// Prevent ring attack from happening immediately
	ring_cooldown = world.time + ring_cooldown_time

/mob/living/simple_animal/hostile/pianist_music_note/Life()
	. = ..()
	if(!.)
		return
	if(ring_cooldown < world.time)
		RingDamage()

/mob/living/simple_animal/hostile/pianist_music_note/proc/RingDamage()
	ring_cooldown = world.time + ring_cooldown_time

	new /obj/effect/temp_visual/resonance_ring(get_turf(src))
	playsound(src, 'sound/abnormalities/fateloom/garrote.ogg', 50, TRUE)

	// Create smoke effects in 3x3 area
	for(var/turf/T in range(ring_range, src))
		if(T.z != z)
			continue
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)

	// Damage all humans in 3x3 area
	for(var/mob/living/carbon/human/H in range(ring_range, src))
		if(H.z != z)
			continue
		var/damage = damage_amount
		// Reduce damage by 50% if target doesn't have Reverting Song
		if(!H.has_status_effect(/datum/status_effect/reverting_song))
			damage *= 0.5
		// Check for Silence mask protection (80% reduction)
		if(H.wear_mask && istype(H.wear_mask, /obj/item/clothing/mask/silence))
			damage *= 0.2
			to_chat(H, span_nicegreen("The Silence protects you from the music!"))
		H.apply_damage(damage, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		if(H.sanity_lost)
			H.apply_status_effect(/datum/status_effect/musical_fascination, pianist_owner)


/mob/living/simple_animal/hostile/pianist_music_note/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(. && health <= 0 && ishuman(user))
		// Mark the attacker before death
		var/datum/status_effect/reverting_song/song = user.has_status_effect(/datum/status_effect/reverting_song)
		var/mob/living/carbon/human/H = user
		if(song)
			song.refresh()
			// Heal SP based on reverting song stacks (10% per stack, max 80%)
			var/heal_amount = min(H.maxSanity * 0.1 * song.stacks, H.maxSanity * 0.8)
			H.adjustSanityLoss(-heal_amount)
			to_chat(H, span_nicegreen("The reverting song resonates within you, restoring [heal_amount] SP!"))
		else
			user.apply_status_effect(/datum/status_effect/reverting_song)
			to_chat(user, span_warning("Breaking the note marks you with a reverting song!"))

/mob/living/simple_animal/hostile/pianist_music_note/bullet_act(obj/projectile/P)
	. = ..()
	if(health <= 0 && P.firer && ishuman(P.firer))
		var/mob/living/carbon/human/H = P.firer
		var/datum/status_effect/reverting_song/song = H.has_status_effect(/datum/status_effect/reverting_song)
		if(song)
			song.refresh()
			// Heal SP based on reverting song stacks (10% per stack, max 80%)
			var/heal_amount = min(H.maxSanity * 0.1 * song.stacks, H.maxSanity * 0.8)
			H.adjustSanityLoss(-heal_amount)
			to_chat(H, span_nicegreen("The reverting song resonates within you, restoring [heal_amount] SP!"))
		else
			H.apply_status_effect(/datum/status_effect/reverting_song)
			to_chat(H, span_warning("Breaking the note marks you with a reverting song!"))

/mob/living/simple_animal/hostile/pianist_music_note/death(gibbed)
	QDEL_IN(src, 1) // Small delay to ensure visual effects play
	return ..() // Call parent to handle standard death effects

// Visual Effects
/obj/effect/pianist_melody_visual
	name = "melody"
	desc = "A red music note orbiting the Pianist."
	icon = 'ModularTegustation/Teguicons/pianist_effects.dmi'
	icon_state = "music_note_1"
	color = "#FF0000"
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT


/obj/effect/temp_visual/music_note_landing
	name = "falling note shadow"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "warning_gray"
	duration = 20 // 2 seconds to match the sleep(20) in DropNoteOnTarget
	pixel_x = -32
	pixel_y = -32
	color = "#3160a8"

/obj/effect/temp_visual/aoe_warning
	name = "discordant aura"
	icon = 'icons/effects/effects.dmi'
	icon_state = "spreadwarning"
	layer = BELOW_MOB_LAYER
	duration = 10
	alpha = 128

/obj/effect/temp_visual/resonance_ring
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	duration = 10
	color = "#FF0000"

/obj/effect/temp_visual/resonance_ring/Initialize()
	. = ..()
	transform = matrix() * 0.5
	animate(src, transform = matrix() * 2, alpha = 0, time = duration)

/obj/effect/temp_visual/column_warning
	name = "harmonic distortion"
	icon = 'icons/effects/effects.dmi'
	icon_state = "spreadwarning"
	layer = BELOW_MOB_LAYER
	duration = 15  // 1.5 seconds to match column_warning_time
	alpha = 128
	color = "#FF0000"

// Status Effects
/datum/status_effect/reverting_song
	id = "reverting_song"
	duration = -1
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/status_effect/reverting_song
	var/stacks = 1

/atom/movable/screen/alert/status_effect/reverting_song
	name = "Reverting Song"
	desc = "Your experience with the pianist has etched its music into your body and your mind..."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "musical_addiction"

/datum/status_effect/reverting_song/on_creation(mob/living/new_owner, stacks_to_add = 1)
	. = ..()
	if(.)
		stacks = stacks_to_add

/datum/status_effect/reverting_song/on_apply()
	owner.visible_message(span_warning("[owner] is marked by a reverting song!"))
	// Apply white damage vulnerability multiplier
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.white_mod *= (1 + stacks * 0.1)
	return TRUE

/datum/status_effect/reverting_song/on_remove()
	// Remove white damage vulnerability multiplier
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.white_mod /= (1 + stacks * 0.1)

/datum/status_effect/reverting_song/refresh(stacks_to_add = 1)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		// Remove old multiplier
		H.physiology.white_mod /= (1 + stacks * 0.1)
	stacks += stacks_to_add
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		// Apply new multiplier
		H.physiology.white_mod *= (1 + stacks * 0.1)

// Musical Fascination panic type
/datum/status_effect/musical_fascination
	id = "musical_fascination"
	tick_interval = 5  // Faster ticking for smoother movement
	alert_type = null
	var/mob/living/simple_animal/hostile/distortion/pianist/target_pianist
	var/datum/movespeed_modifier/fascination_speed

/datum/status_effect/musical_fascination/on_creation(mob/living/new_owner, mob/living/simple_animal/hostile/distortion/pianist/pianist)
	if(pianist)
		target_pianist = pianist
	. = ..()

/datum/status_effect/musical_fascination/on_apply()
	. = ..()
	if(!target_pianist)
		return FALSE

	// Add speed boost
	fascination_speed = new /datum/movespeed_modifier/musical_fascination()
	owner.add_movespeed_modifier(fascination_speed)

	if(prob(10) && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		owner.visible_message(span_danger("[owner]'s eyes glaze over as they become entranced by the music!"))
		H.gain_trauma(/datum/brain_trauma/special/musical_corruption)
	return TRUE

/datum/status_effect/musical_fascination/on_remove()
	. = ..()
	// Remove speed boost
	if(fascination_speed)
		owner.remove_movespeed_modifier(fascination_speed)
	return

/datum/status_effect/musical_fascination/tick()
	if(!target_pianist || QDELETED(target_pianist) || target_pianist.stat == DEAD)
		owner.remove_status_effect(src)
		return
	
	// Remove if owner is dead
	if(owner.stat == DEAD)
		owner.remove_status_effect(src)
		return

	// Also check if sanity is restored
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!H.sanity_lost)
			H.remove_status_effect(src)
			return

	// Move towards the pianist with proper pathfinding
	var/dist = get_dist(owner, target_pianist)
	if(dist > 5)
		// Use pathfinding similar to the sanity AI controller
		var/turf/our_turf = get_turf(owner)
		var/turf/target_turf = get_turf(target_pianist)

		if(!our_turf || !target_turf)
			return

		// Get path to target using proper pathfinding
		var/list/path = get_path_to(owner, target_pianist, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 30, 1, TYPE_PROC_REF(/turf, reachableTurftestWithMobs))

		if(path && length(path) > 1)
			// Move to the next step in the path
			var/turf/next_step = path[2]
			if(next_step && (owner.mobility_flags & MOBILITY_MOVE))
				owner.Move(next_step, get_dir(our_turf, next_step))
		else
			// If no valid path, try basic step towards (fallback)
			var/turf/step_turf = get_step_towards(owner, target_pianist)
			if(step_turf && (owner.mobility_flags & MOBILITY_MOVE))
				owner.Move(step_turf, get_dir(our_turf, step_turf))

		if(prob(5))
			owner.say("That music... I must reach it...")
	else
		// Adjacent to pianist, get absorbed
		target_pianist.AbsorbVictim(owner)
		owner.death(FALSE)
		owner.remove_status_effect(src)

// Movement speed modifier for musical fascination
/datum/movespeed_modifier/musical_fascination
	multiplicative_slowdown = -0.5  // 50% faster movement

// Phase 1 Environmental Effects

/obj/effect/falling_music_note
	name = "falling music note"
	desc = "A massive musical note plummeting from above!"
	icon = 'ModularTegustation/Teguicons/pianist_effects.dmi'
	icon_state = "music_note_1"
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -32 // Center the 3x scale sprite
	pixel_y = 256 // Start high above
	color = "#FF0000"
	var/mob/living/simple_animal/hostile/distortion/pianist/pianist_owner
	var/impact_time = 30 // 3 seconds to impact

/obj/effect/falling_music_note/Initialize()
	. = ..()
	// Scale up the sprite
	transform = matrix() * 3

	// Randomly pick icon
	icon_state = pick("music_note_1", "music_note_2")

	// Create shadow warning
	var/turf/T = get_turf(src)
	if(T)
		new /obj/effect/temp_visual/falling_note_shadow(T)

	// Start falling animation
	animate(src, pixel_y = -32, time = impact_time, easing = QUAD_EASING|EASE_IN)

	// Schedule impact
	addtimer(CALLBACK(src, PROC_REF(Impact)), impact_time)

/obj/effect/falling_music_note/proc/Impact()
	var/turf/impact_turf = get_turf(src)
	if(!impact_turf || QDELETED(src))
		qdel(src)
		return

	// Screen shake and sound
	playsound(get_turf(src), 'sound/effects/lc13_environment/day_50/Shake_End.ogg', 50, 0, 8)

	for(var/mob/living/L in hearers(10, impact_turf))
		if(L.client)
			shake_camera(L, 3, 3)

	// Convert terrain in natural pattern - bigger impact
	var/list/conversion_tiles = GenerateNaturalPattern(impact_turf, 7)

	for(var/turf/T in conversion_tiles)
		// Damage anyone on the tiles
		for(var/mob/living/L in T)
			L.apply_damage(75, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			to_chat(L, span_userdanger("The falling note CRUSHES you!"))
			L.Knockdown(30)
		
		// Damage structures on the tile
		for(var/obj/structure/S in T)
			if(S.resistance_flags & INDESTRUCTIBLE)
				continue
			S.take_damage(150, RED_DAMAGE, "melee", 1)
			playsound(S, 'sound/effects/meteorimpact.ogg', 50, TRUE)

		// Convert the turf
		if(!istype(T, /turf/open/floor/plating/ashplanet/wateryrock) && !istype(T, /turf/open/space) && !istype(T, /turf/closed/mineral/ash_rock))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)

			// Handle area conversion
			if(istype(T.loc, /area/space))
				var/area/city/new_area
				for(var/area/city/C in world)
					if(C.z == T.z)
						new_area = C
						break

				if(!new_area)
					new_area = new /area/city()

				var/area/old_area = T.loc
				new_area.contents += T
				T.change_area(old_area, new_area)

			// Convert turf - 80% chance for ash rock on closed turfs
			if(istype(T, /turf/closed))
				if(prob(80))
					T.ChangeTurf(/turf/closed/mineral/ash_rock)
				else
					T.ChangeTurf(/turf/open/floor/plating/ashplanet/wateryrock)
			else
				T.ChangeTurf(/turf/open/floor/plating/ashplanet/wateryrock)

			if(pianist_owner && !QDELETED(pianist_owner))
				pianist_owner.converted_tiles += T

	// Generate ash rocks at center
	var/rocks_to_spawn = rand(1, 3)
	var/list/rock_tiles = list(impact_turf)
	for(var/turf/T in orange(1, impact_turf))
		if(!istype(T, /turf/open/space))
			rock_tiles += T

	for(var/i in 1 to min(rocks_to_spawn, length(rock_tiles)))
		var/turf/rock_turf = pick_n_take(rock_tiles)
		if(rock_turf && !rock_turf.density && istype(rock_turf, /turf/open))
			playsound(rock_turf, 'sound/effects/lc13_environment/day_50/Shake_Move.ogg', 40, TRUE)
			rock_turf.ChangeTurf(/turf/closed/mineral/ash_rock)

	// Cleanup
	qdel(src)

/obj/effect/falling_music_note/proc/GenerateNaturalPattern(turf/center, size = 5)
	var/list/pattern_tiles = list()

	// Create a circular pattern with some randomness
	for(var/turf/T in range(size, center))
		var/dist = get_dist(T, center)

		// Always include center
		if(T == center)
			pattern_tiles += T
			continue

		// Create circular pattern with higher chance for closer tiles
		var/include_chance = 0
		switch(dist)
			if(0)
				include_chance = 100
			if(1)
				include_chance = 90
			if(2)
				include_chance = 80
			if(3)
				include_chance = 65
			if(4)
				include_chance = 50
			if(5)
				include_chance = 35
			if(6)
				include_chance = 25
			if(7)
				include_chance = 15

		if(prob(include_chance))
			pattern_tiles += T

	return pattern_tiles

/obj/effect/temp_visual/falling_note_shadow
	name = "impact shadow"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "landing_indicator"
	layer = BELOW_MOB_LAYER
	duration = 30 // Match falling time
	pixel_x = -32
	pixel_y = -32
	color = "#FF0000"
	alpha = 128

/obj/effect/temp_visual/falling_note_shadow/Initialize()
	. = ..()
	// Pulse animation
	animate(src, alpha = 255, time = 5, loop = -1, flags = ANIMATION_PARALLEL)
	animate(alpha = 128, time = 5)

/obj/effect/temp_visual/resonance_line_warning
	name = "resonating path"
	icon = 'icons/effects/effects.dmi'
	icon_state = "spreadwarning"
	layer = BELOW_MOB_LAYER
	duration = 15
	color = "#FF0000"
	alpha = 180

/obj/effect/temp_visual/resonance_line_warning/Initialize()
	. = ..()
	// Violent pulsing effect
	animate(src, alpha = 255, time = 2, loop = -1)
	animate(alpha = 100, time = 2)
	
	// Small shake
	animate(src, pixel_x = rand(-1, 1), pixel_y = rand(-1, 1), time = 1, loop = -1, flags = ANIMATION_PARALLEL)
	animate(pixel_x = rand(-1, 1), pixel_y = rand(-1, 1), time = 1)
