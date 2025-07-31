/*
The Pianist Distortion

A two-phase musical-themed distortion:

PHASE 1 - THE OVERTURE (2 minutes):
- Complete damage immunity
- Environmental attacks only (falling notes, resonance lines)
- Transforms battlefield with watery rock and ash obstacles
- No direct combat

PHASE 2 - THE PERFORMANCE:
- Standard combat with all abilities
- Reduced environmental attacks
- Thunderstorm weather effect
- Fighting on transformed terrain

Core mechanics:
1. Summons falling music notes that deal damage over time
2. Gains "Melody" stacks from absorbed victims and lost health
3. Melody stacks enhance all abilities (more targets, longer duration, higher damage)
4. Performs AoE attacks with varying ranges and warning telegraphs
5. Immune to damage from attackers without "Reverting Song" debuff
6. Causes special "Musical Fascination" panic that draws victims to be absorbed
7. Can inflict permanent "Musical Corruption" brain trauma

Based on the design document in PIANIST_PHASE_DESIGN.md
*/

// Phase constants
#define PIANIST_PHASE_OVERTURE 1
#define PIANIST_PHASE_PERFORMANCE 2
/mob/living/simple_animal/hostile/distortion/pianist
	name = "The Pianist"
	desc = "A grotesque figure seated at a grand piano made of flesh and bone. Its fingers dance across keys that scream with each press."
	icon = 'ModularTegustation/Teguicons/256x256.dmi'
	icon_state = "pianist"
	icon_living = "pianist"
	icon_dead = "pianist"
	layer = 4
	maxHealth = 7500
	health = 7500
	occupied_tiles_left = 3
	occupied_tiles_right = 3
	occupied_tiles_up = 3
	occupied_tiles_down = 3
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	move_to_delay = 6
	ranged = TRUE
	speed = 0

	pixel_x = -112
	base_pixel_x = -112
	pixel_y = -112
	base_pixel_y = -112

	attack_verb_continuous = "strikes"
	attack_verb_simple = "strike"
	// attack_sound = 'sound/weapons/ego/lance1.ogg'
	// No melee attacks - stationary distortion

	can_patrol = FALSE
	wander = FALSE

	fear_level = ALEPH_LEVEL

	del_on_death = FALSE

	// Ego equipment - to be implemented
	ego_list = list(
		/obj/item/ego_weapon/da_capo,
		/obj/item/clothing/suit/armor/ego_gear/aleph/da_capo
		)
	egoist_outfit = /datum/outfit/job/civilian
	egoist_attributes = 100
	egoist_names = list("Virtuoso", "Maestro", "Composer")

	var/melody_stacks = 0
	var/list/absorbed_bodies = list()
	var/note_summon_cooldown = 0
	var/note_summon_cooldown_time = 6 SECONDS
	var/aoe_attack_cooldown = 0
	var/aoe_attack_cooldown_time = 1.5 SECONDS
	var/current_aoe_pattern = list(1, 2, 3) // Zone numbers
	var/aoe_pattern_index = 1
	var/aoe_warning_time = 10 // 1 second in deciseconds
	var/base_note_targets = 3
	var/base_note_duration = 30 SECONDS
	var/base_note_damage = 8
	var/base_aoe_damage = 30
	var/list/melody_visuals = list()
	var/damage_threshold_tracker = 0 // Tracks damage for melody gain
	var/column_attack_cooldown = 0
	var/column_attack_cooldown_time = 8 SECONDS
	var/list/recent_attackers = list()
	var/column_width = 9 // 4 tiles up and down plus center
	var/column_warning_time = 15 // 1.5 seconds

	var/datum/looping_sound/pianist/soundloop

	// Phase system
	var/phase = PIANIST_PHASE_OVERTURE
	var/phase_timer = 0
	var/phase_duration = 120 SECONDS // 2 minutes for Phase 1
	var/falling_note_spawn_range = 10 // Starting range, expands over time
	var/falling_note_max_range = 60
	var/falling_note_cooldown = 0
	var/falling_note_cooldown_time = 20 SECONDS // Phase 1 frequency - reduced
	var/resonance_line_charges = 8 // Total uses across the fight
	var/resonance_line_cooldown = 0
	var/resonance_line_cooldown_time = 15 SECONDS // More frequent line attacks
	var/list/recent_resonance_targets = list()

	// Tile conversion system (removed old circular conversion)
	var/list/converted_tiles = list() // Stores original tile types for restoration

/mob/living/simple_animal/hostile/distortion/pianist/Initialize()
	. = ..()
	current_aoe_pattern = shuffle(current_aoe_pattern)

	// Start phase timer
	phase_timer = world.time + phase_duration

	// Perform entrance animation
	INVOKE_ASYNC(src, PROC_REF(PerformEntranceSequence))

	soundloop = new(list(src), FALSE)
	soundloop.start()

	// Increase view range due to size
	update_sight()

	// Add the global message action
	var/datum/action/cooldown/pianist_message/message_action = new
	message_action.Grant(src)

/mob/living/simple_animal/hostile/distortion/pianist/update_sight()
	. = ..()
	// Increase view range to 13x13 due to large size
	if(client)
		client.view_size.setTo(13, 13)

/mob/living/simple_animal/hostile/distortion/pianist/Move()
	return FALSE

/mob/living/simple_animal/hostile/distortion/pianist/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/distortion/pianist/Life()
	. = ..()
	if(!.)
		return FALSE

	// Check for phase transition
	if(phase == PIANIST_PHASE_OVERTURE && world.time >= phase_timer)
		TransitionToPerformance()
		return

	// Phase-based attack patterns
	switch(phase)
		if(PIANIST_PHASE_OVERTURE)
			// Environmental attacks only
			if(falling_note_cooldown < world.time)
				SpawnFallingNotes()

			if(resonance_line_cooldown < world.time && resonance_line_charges > 0)
				if(prob(60))
					AttemptResonanceLine()
				else
					AttemptCrossMapResonance()

			// Expand falling note range every 10 seconds
			var/time_elapsed = phase_duration - (phase_timer - world.time)
			var/expansions = round(time_elapsed / 10 SECONDS)
			falling_note_spawn_range = min(10 + (expansions * 10), falling_note_max_range)

		if(PIANIST_PHASE_PERFORMANCE)
			// Regular combat with reduced environmental attacks

			// Summon music notes (normal frequency)
			if(note_summon_cooldown < world.time)
				SummonMusicNotes()

			// AoE attacks
			if(aoe_attack_cooldown < world.time)
				PerformAoEAttack()

			// Column attacks
			if(column_attack_cooldown < world.time && length(recent_attackers))
				PerformColumnAttack()

			// Occasional falling notes (reduced frequency)
			if(falling_note_cooldown < world.time)
				SpawnFallingNotes()

			// Rare resonance line
			if(resonance_line_cooldown < world.time && resonance_line_charges > 0)
				if(prob(60))
					AttemptResonanceLine()
				else
					AttemptCrossMapResonance()

/mob/living/simple_animal/hostile/distortion/pianist/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0) // Only process if damage was actually dealt
		damage_threshold_tracker += .

		// Calculate how many 15% thresholds we've crossed
		var/threshold_amount = maxHealth * 0.15 // 15% of max health
		var/thresholds_crossed = round(damage_threshold_tracker / threshold_amount)

		// Award melody stacks and reset tracker for each threshold crossed
		if(thresholds_crossed > 0)
			AddMelody(thresholds_crossed)
			damage_threshold_tracker -= (thresholds_crossed * threshold_amount)

/mob/living/simple_animal/hostile/distortion/pianist/attacked_by(obj/item/I, mob/living/user)
	// Special case for Black Silence gloves - bypass all resistances
	if(istype(I, /obj/item/ego_weapon/black_silence_gloves))
		ChangeResistances(list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 10))
		to_chat(user, span_boldwarning("The Black Silence cuts through the music with ease!"))
		// Track attacker
		if(!(user in recent_attackers))
			recent_attackers += user
			if(length(recent_attackers) > 5)
				recent_attackers.Cut(1, 2)
		return ..()

	// Check for reverting song immunity
	var/datum/status_effect/reverting_song/song_effect = user?.has_status_effect(/datum/status_effect/reverting_song)
	if(!song_effect || song_effect.stacks == 0)
		to_chat(user, span_warning("Your attack passes harmlessly through [src]!"))
		playsound(src, 'sound/effects/attackblob.ogg', 50, TRUE)
		return FALSE

	// Increase damage based on reverting song stacks
	var/damage_mod = 0.2 * (1 + song_effect.stacks * 0.1)
	ChangeResistances(list(RED_DAMAGE = damage_mod, WHITE_DAMAGE = damage_mod, BLACK_DAMAGE = damage_mod, PALE_DAMAGE = damage_mod))

	// Track attacker
	if(!(user in recent_attackers))
		recent_attackers += user
		if(length(recent_attackers) > 5)
			recent_attackers.Cut(1, 2)

	return ..()

/mob/living/simple_animal/hostile/distortion/pianist/bullet_act(obj/projectile/P)
	// Pianist is immune to all ranged attacks
	if(phase == PIANIST_PHASE_OVERTURE)
		visible_message(span_warning("[P] dissipates harmlessly against [src]'s invulnerable form!"))
	else
		visible_message(span_warning("[P] dissipates harmlessly against [src]'s musical aura!"))
	playsound(src, 'sound/effects/attackblob.ogg', 50, TRUE)
	return BULLET_ACT_BLOCK

/mob/living/simple_animal/hostile/distortion/pianist/death(gibbed)
	QDEL_NULL(soundloop)

	// End the thunderstorm if it exists
	SSweather.end_weather(/datum/weather/pianist_storm)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "You will be there, lying in my sheets, O sorrow.", 25))
	// Drop all absorbed bodies
	for(var/mob/living/carbon/human/H in absorbed_bodies)
		H.forceMove(get_turf(src))
	absorbed_bodies.Cut()

	// Clear melody visuals
	for(var/obj/effect/pianist_melody_visual/V in melody_visuals)
		qdel(V)
	melody_stacks = 0
	melody_visuals.Cut()

	// Clean up any stray melody visuals that might exist
	for(var/obj/effect/pianist_melody_visual/V in world)
		qdel(V)

	// Remove all music notes
	for(var/mob/living/simple_animal/hostile/pianist_music_note/note in GLOB.mob_list)
		qdel(note)

	// Cure all humans of musical fascination and reverting song
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		H.remove_status_effect(/datum/status_effect/musical_fascination)
		H.remove_status_effect(/datum/status_effect/reverting_song)

	// Fade out animation
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)

	// Note: Tiles remain converted as permanent battlefield scars
	// No restoration in the new phase system

	QDEL_IN(src, 5 SECONDS)

	return ..()

/mob/living/simple_animal/hostile/distortion/pianist/proc/AddMelody(amount = 1)
	melody_stacks += amount
	UpdateMelodyVisuals()

/mob/living/simple_animal/hostile/distortion/pianist/proc/ApplyPianistDamage(mob/living/L, damage, damage_type = WHITE_DAMAGE)
	var/final_damage = damage
	// Check for Silence mask protection
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.wear_mask && istype(H.wear_mask, /obj/item/clothing/mask/silence))
			final_damage *= 0.2 // 80% damage reduction
			to_chat(H, span_nicegreen("The Silence protects you from the music!"))
	L.apply_damage(final_damage, damage_type, null, L.run_armor_check(null, damage_type), spread_damage = TRUE)

/mob/living/simple_animal/hostile/distortion/pianist/proc/UpdateMelodyVisuals()
	// Clear old visuals
	for(var/obj/effect/pianist_melody_visual/V in melody_visuals)
		qdel(V)
	melody_visuals.Cut()

	// Create new visuals based on stack count
	for(var/i in 1 to min(melody_stacks, 10))
		var/obj/effect/pianist_melody_visual/V = new(src)
		// Orbit at 150-200 pixels away to account for 256x256 sprite size
		V.orbit(src, 150 + (i * 5), pick(TRUE, FALSE), rand(10, 20))
		melody_visuals += V

/mob/living/simple_animal/hostile/distortion/pianist/proc/SummonMusicNotes()
	note_summon_cooldown = world.time + note_summon_cooldown_time

	var/targets_to_hit = base_note_targets + (melody_stacks / 2)
	var/list/potential_targets = list()

	for(var/mob/living/carbon/human/H in livinginrange(48, src))
		if(H.stat != DEAD && H.z == z)
			potential_targets += H

	if(!length(potential_targets))
		return

	for(var/i in 1 to min(targets_to_hit, length(potential_targets)))
		var/mob/living/target = pick_n_take(potential_targets)
		INVOKE_ASYNC(src, PROC_REF(DropNoteOnTarget), target)

/mob/living/simple_animal/hostile/distortion/pianist/proc/DropNoteOnTarget(mob/living/target)
	if(!target || QDELETED(target))
		return

	var/turf/target_turf = get_turf(target)

	// Warning indicator - 3x3 red warning
	new /obj/effect/temp_visual/music_note_landing(target_turf)
	playsound(target_turf, 'sound/abnormalities/crumbling/warning.ogg', 50, TRUE)

	sleep(20) // 2 second warning

	if(!target_turf || QDELETED(src))
		return

	// Create the actual music note
	var/mob/living/simple_animal/hostile/pianist_music_note/note = new(target_turf)
	note.pianist_owner = src
	note.damage_amount = base_note_damage + (melody_stacks / 3 * 10)
	note.duration = base_note_duration + (melody_stacks * 10) // 1 second per melody stack

	// Initial impact damage
	for(var/turf/T in range(1, target_turf))
		for(var/mob/living/L in T)
			if(L.z != z)
				continue
			var/damage = base_note_damage
			// Reduce damage by 50% if target doesn't have Reverting Song
			if(!L.has_status_effect(/datum/status_effect/reverting_song))
				damage *= 0.5
			ApplyPianistDamage(L, damage)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.apply_status_effect(/datum/status_effect/musical_fascination, src)

/mob/living/simple_animal/hostile/distortion/pianist/proc/PerformAoEAttack()
	aoe_attack_cooldown = world.time + aoe_attack_cooldown_time

	var/zone = current_aoe_pattern[aoe_pattern_index]
	aoe_pattern_index++
	if(aoe_pattern_index > length(current_aoe_pattern))
		aoe_pattern_index = 1
		current_aoe_pattern = shuffle(current_aoe_pattern)

	// Calculate zone ranges based on the zone number
	var/min_dist
	var/max_dist
	switch(zone)
		if(1) // Close zone
			min_dist = 4
			max_dist = 5
		if(2) // Mid zone
			min_dist = 5
			max_dist = 6
		if(3) // Far zone
			min_dist = 6
			max_dist = 7

	// Warning phase
	var/warning_time = max(5, aoe_warning_time - (melody_stacks / 2)) // Reduce by 0.1s per 2 melody

	// Get all tiles in the ring zone
	var/list/zone_tiles = list()
	for(var/turf/T in view(max_dist, src))
		if(T.z != z)
			continue
		var/dist = get_dist(src, T)
		if(dist >= min_dist && dist <= max_dist)
			zone_tiles += T
			new /obj/effect/temp_visual/column_warning(T)

	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, TRUE)

	sleep(warning_time)

	playsound(src, 'sound/abnormalities/fateloom/garrote_bloody.ogg', 50, TRUE)
	if(QDELETED(src) || stat == DEAD)
		return

	// Damage phase
	var/damage = base_aoe_damage + (melody_stacks / 3 * 10)
	for(var/turf/T in zone_tiles)
		if(T.z != z)
			continue
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			ApplyPianistDamage(L, damage)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.apply_status_effect(/datum/status_effect/musical_fascination, src)

/mob/living/simple_animal/hostile/distortion/pianist/proc/PerformColumnAttack()
	column_attack_cooldown = world.time + column_attack_cooldown_time

	// Remove any dead/deleted attackers
	for(var/mob/M in recent_attackers)
		if(QDELETED(M) || M.stat == DEAD)
			recent_attackers -= M

	if(!length(recent_attackers))
		return

	// Pick a random recent attacker
	var/mob/living/target = pick(recent_attackers)
	if(!target || QDELETED(target) || target.z != z)
		return

	// Get direction to target and convert to cardinal
	var/direction = get_dir(src, target)
	// Convert to cardinal direction only
	if(direction in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		// Pick horizontal or vertical based on which is closer
		var/dx = abs(target.x - x)
		var/dy = abs(target.y - y)
		if(dx > dy)
			direction = direction & (EAST|WEST)
		else
			direction = direction & (NORTH|SOUTH)

	// Create warning effects only on tiles that will be hit
	var/turf/pianist_turf = get_turf(src)

	// Show warnings for the alternating pattern across the entire path
	for(var/distance in 0 to 14) // 15 tiles of distance
		var/turf/wave_center = pianist_turf

		// Get the center turf at this distance
		for(var/i in 1 to distance + 1)
			wave_center = get_step(wave_center, direction)
			if(!wave_center)
				break

		if(!wave_center)
			continue

		// Create warnings on alternating tiles perpendicular to movement
		if(direction in list(NORTH, SOUTH))
			// Moving vertically, create horizontal line warnings
			for(var/i in -7 to 7)
				var/turf/T = locate(wave_center.x + i, wave_center.y, wave_center.z)
				if(T && ((abs(i) + distance) % 2 == 1)) // Alternating pattern
					new /obj/effect/temp_visual/column_warning(T)
		else
			// Moving horizontally, create vertical line warnings
			for(var/i in -7 to 7)
				var/turf/T = locate(wave_center.x, wave_center.y + i, wave_center.z)
				if(T && ((abs(i) + distance) % 2 == 1)) // Alternating pattern
					new /obj/effect/temp_visual/column_warning(T)

	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 100, TRUE)
	visible_message(span_danger("[src]'s piano keys emit a discordant crescendo!"))

	// Start the moving wave after warning
	addtimer(CALLBACK(src, PROC_REF(ExecuteMovingWave), direction, melody_stacks), column_warning_time)

/mob/living/simple_animal/hostile/distortion/pianist/proc/ExecuteMovingWave(direction, melody_at_cast)
	if(QDELETED(src) || stat == DEAD)
		return

	var/damage = base_aoe_damage + (melody_at_cast / 3 * 10)
	var/turf/start_turf = get_turf(src)

	// Start the wave 4 tiles away from the pianist to account for its size
	for(var/i in 1 to 4)
		start_turf = get_step(start_turf, direction)
		if(!start_turf)
			return

	var/max_distance = 15
	var/current_distance = 0
	var/delay_between_moves = 1 // 0.1 seconds between each wave movement

	// Start the wave movement
	MoveSingleWave(start_turf, direction, damage, current_distance, max_distance, delay_between_moves)

/mob/living/simple_animal/hostile/distortion/pianist/proc/MoveSingleWave(turf/current_center, direction, damage, current_distance, max_distance, delay)
	if(QDELETED(src) || stat == DEAD || current_distance >= max_distance)
		return

	// Move the wave center
	var/turf/new_center = get_step(current_center, direction)
	if(!new_center)
		visible_message(span_warning("Wave attack blocked at distance [current_distance]!"))
		return

	// Get all tiles in the line perpendicular to movement direction
	var/list/wave_tiles = list()

	if(direction in list(NORTH, SOUTH))
		// Moving vertically, so create horizontal line
		for(var/i in -7 to 7) // 15 tile wide wave
			var/turf/T = locate(new_center.x + i, new_center.y, new_center.z)
			if(T)
				wave_tiles += T
	else
		// Moving horizontally, so create vertical line
		for(var/i in -7 to 7) // 15 tile wide wave
			var/turf/T = locate(new_center.x, new_center.y + i, new_center.z)
			if(T)
				wave_tiles += T

	// Damage only alternating tiles (checkerboard pattern)
	for(var/turf/T as anything in wave_tiles)
		// Calculate if this tile should be hit based on its position
		var/offset = 0
		var/turf/src_turf = get_turf(src)
		if(direction in list(NORTH, SOUTH))
			offset = abs(T.x - src_turf.x)
		else
			offset = abs(T.y - src_turf.y)

		// Skip tiles that aren't in the alternating pattern
		if((offset + current_distance) % 2 == 0)
			continue

		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		playsound(T, 'sound/abnormalities/mountain/slam.ogg', 20, TRUE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, pick(GLOB.alldirs)) // Visual confirmation of hit

		for(var/mob/living/L in T.contents)
			if(faction_check_mob(L))
				continue
			var/actual_damage = damage
			// Reduce damage by 50% if target doesn't have Reverting Song
			if(!L.has_status_effect(/datum/status_effect/reverting_song))
				actual_damage *= 0.5
			ApplyPianistDamage(L, actual_damage)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.apply_status_effect(/datum/status_effect/musical_fascination, src)

	// Continue the wave
	current_distance++
	if(current_distance < max_distance)
		addtimer(CALLBACK(src, PROC_REF(MoveSingleWave), new_center, direction, damage, current_distance, max_distance, delay), delay)

/mob/living/simple_animal/hostile/distortion/pianist/proc/AbsorbVictim(mob/living/victim)
	if(!victim || (victim in absorbed_bodies))
		return

	if(!ishuman(victim))
		return

	absorbed_bodies += victim
	victim.forceMove(src)
	AddMelody(1)

	playsound(src, 'sound/effects/attackblob.ogg', 50, TRUE)
	visible_message(span_danger("[victim] is absorbed into [src]'s piano!"))

// Override the fear effect to implement Musical Fascination
/mob/living/simple_animal/hostile/distortion/pianist/FearEffect()
	if(fear_level <= 0)
		return
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in breach_affected)
			continue
		if(H.stat == DEAD)
			continue
		breach_affected += H
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			to_chat(H, span_notice("The music is haunting, but you resist its call."))
			H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
			continue

		var/sanity_result = clamp(fear_level - get_user_level(H), -1, 5)
		if(H.sanity_lost) // Only apply musical fascination to high panic + already panicked
			H.apply_status_effect(/datum/status_effect/musical_fascination, src)
		else
			// Normal fear handling for parent proc
			var/sanity_damage = 0
			var/result_text = FearEffectText(H, sanity_result)
			switch(sanity_result)
				if(-INFINITY to 0)
					H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
					to_chat(H, span_notice("[result_text]"))
					continue
				if(1)
					sanity_damage = H.maxSanity*0.1
					H.apply_status_effect(/datum/status_effect/panicked_lvl_1)
					to_chat(H, span_warning("[result_text]"))
				if(2)
					sanity_damage = H.maxSanity*0.3
					H.apply_status_effect(/datum/status_effect/panicked_lvl_2)
					to_chat(H, span_danger("[result_text]"))
				if(3)
					sanity_damage = H.maxSanity*0.6
					H.apply_status_effect(/datum/status_effect/panicked_lvl_3)
					to_chat(H, span_userdanger("[result_text]"))
				if(4)
					sanity_damage = H.maxSanity*0.95
					H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
					to_chat(H, span_userdanger("<b>[result_text]</b>"))
				if(5)
					sanity_damage = H.maxSanity
					H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
			H.adjustSanityLoss(sanity_damage)
			SEND_SIGNAL(H, COMSIG_FEAR_EFFECT, fear_level, sanity_damage)

// Action for sending global messages
/datum/action/cooldown/pianist_message
	name = "Send Global Message"
	desc = "Send a custom message to all players on the server."
	icon_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "discordant_whisper"
	cooldown_time = 15 SECONDS

/datum/action/cooldown/pianist_message/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/distortion/pianist/P = owner
	if(!istype(P))
		return FALSE

	// Get custom message from player
	var/message = input(owner, "What message would you like to broadcast? (Max 150 characters)", "Global Message") as text|null

	if(!message)
		return FALSE

	// Sanitize and limit message length
	message = copytext(sanitize(message), 1, 150)

	if(!message)
		return FALSE

	// Make it bold if high melody
	if(P.melody_stacks > 20)
		message = "<b>[message]</b>"

	// Send the global message
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, message, 25))

	// Feedback to the user
	to_chat(owner, span_boldnotice("You broadcast your message to all minds..."))

	StartCooldown()
	return TRUE

// Phase 1: Entrance and Environmental Attacks

/mob/living/simple_animal/hostile/distortion/pianist/proc/PerformEntranceSequence()
	set waitfor = FALSE

	// Initial global message
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "O sorrow, I have ended, you see, by respecting you.", 25))

	// Jump animation (similar to Baba Yaga)
	var/turf/landing_turf = get_turf(src)
	if(!landing_turf)
		return

	// Make invisible for jump
	alpha = 0

	// Warning at landing zone
	for(var/turf/T in range(5, landing_turf))
		new /obj/effect/temp_visual/column_warning(T)

	playsound(landing_turf, 'sound/abnormalities/thunderbird/tbird_beam.ogg', 100, TRUE, 40)

	sleep(15) // 1.5 second warning

	// Land with impact
	alpha = 255
	playsound(landing_turf, 'sound/effects/meteorimpact.ogg', 150, TRUE, 40)

	// Screen shake
	for(var/mob/living/L in hearers(15, landing_turf))
		if(L.client)
			shake_camera(L, 4, 3)

	// Convert landing zone to watery rock with natural pattern
	var/list/impact_tiles = list()

	// Create a natural circular pattern
	for(var/turf/T in range(6, landing_turf))
		if(istype(T, /turf/open/space))
			continue

		var/dist = get_dist(T, landing_turf)
		var/include_chance = 0

		// Natural falloff from center
		switch(dist)
			if(0)
				include_chance = 100
			if(1)
				include_chance = 95
			if(2)
				include_chance = 85
			if(3)
				include_chance = 70
			if(4)
				include_chance = 50
			if(5)
				include_chance = 30
			if(6)
				include_chance = 15

		if(prob(include_chance))
			impact_tiles += T

	// Apply effects to selected tiles
	for(var/turf/T in impact_tiles)
		// Deal damage based on distance
		var/dist = get_dist(T, landing_turf)
		var/damage = 150 - (dist * 20) // More damage at center

		for(var/mob/living/L in T)
			L.apply_damage(damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			to_chat(L, span_userdanger("The Pianist's arrival [dist <= 2 ? "crushes" : "batters"] you!"))
			if(dist <= 2)
				L.Knockdown(30)

		// Convert turf with staggered timing
		spawn(dist * 2) // Ripple effect outward
			if(!istype(T, /turf/open/floor/plating/ashplanet/wateryrock))
				new /obj/effect/temp_visual/cult/turf/floor(T)
				playsound(T, 'sound/effects/lc13_environment/day_50/Shake_End.ogg', 40 - (dist * 5), TRUE)
				T.ChangeTurf(/turf/open/floor/plating/ashplanet/wateryrock)
				converted_tiles += T

	visible_message(span_colossus("THE PIANIST BEGINS THE OVERTURE!"))

/mob/living/simple_animal/hostile/distortion/pianist/proc/SpawnFallingNotes()
	falling_note_cooldown = world.time + (phase == PIANIST_PHASE_OVERTURE ? falling_note_cooldown_time : 30 SECONDS)

	// Determine number of notes to spawn - reduced frequency
	var/base_notes = 2
	var/max_notes = 4
	var/range_factor = falling_note_spawn_range / falling_note_max_range
	var/notes_to_spawn = round(base_notes + (max_notes - base_notes) * range_factor)
	notes_to_spawn = rand(notes_to_spawn - 1, notes_to_spawn) // Add some randomness

	if(phase == PIANIST_PHASE_PERFORMANCE)
		notes_to_spawn = rand(1, 2) // Even less in combat phase

	var/list/valid_turfs = list()
	var/list/spawn_turfs = list()

	// Find valid spawn locations
	for(var/turf/T in range(falling_note_spawn_range, src))
		if(T.z != z)
			continue
		if(istype(T, /turf/open/floor/plating/ashplanet/wateryrock))
			continue // Avoid already converted terrain
		if(T in spawn_turfs)
			continue

		// Check spacing from other spawn points
		var/too_close = FALSE
		for(var/turf/spawn_point in spawn_turfs)
			if(get_dist(T, spawn_point) < 5)
				too_close = TRUE
				break

		if(!too_close)
			valid_turfs += T

	// Spawn the notes
	for(var/i in 1 to min(notes_to_spawn, length(valid_turfs)))
		var/turf/spawn_turf = pick_n_take(valid_turfs)
		spawn_turfs += spawn_turf
		INVOKE_ASYNC(src, PROC_REF(DropFallingNote), spawn_turf)

/mob/living/simple_animal/hostile/distortion/pianist/proc/DropFallingNote(turf/target_turf)
	if(!target_turf || QDELETED(src))
		return

	// Create falling effect
	var/obj/effect/falling_music_note/note = new(target_turf)
	note.pianist_owner = src

/mob/living/simple_animal/hostile/distortion/pianist/proc/AttemptResonanceLine()
	resonance_line_cooldown = world.time + resonance_line_cooldown_time

	// Find valid targets
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in livinginrange(30, src))
		if(H.stat == DEAD)
			continue

		var/dist = get_dist(src, H)
		if(dist < 5) // Too close
			continue

		if(H in recent_resonance_targets)
			continue

		valid_targets += H

	if(!length(valid_targets))
		return

	// Use a charge
	resonance_line_charges--

	// Pick target and create line
	var/mob/living/target = pick(valid_targets)
	recent_resonance_targets += target
	if(length(recent_resonance_targets) > 3)
		recent_resonance_targets.Cut(1, 2)

	CreateResonanceLine(target)

/mob/living/simple_animal/hostile/distortion/pianist/proc/CreateResonanceLine(mob/living/target)
	if(!target || QDELETED(target) || QDELETED(src))
		return

	visible_message(span_danger("[src]'s piano RESONATES WITH TERRIBLE POWER!"))

	// Screen shake for everyone who can see
	for(var/mob/living/L in viewers(15, src))
		if(L.client)
			shake_camera(L, 2, 2)

	// Calculate line path
	var/list/line_tiles = getline(get_turf(src), get_turf(target))
	if(!length(line_tiles))
		return

	// Extend past target
	var/turf/last_tile = line_tiles[length(line_tiles)]
	var/extension_dir = get_dir(line_tiles[length(line_tiles)-1], last_tile)

	for(var/i in 1 to rand(5, 10))
		var/turf/next = get_step(last_tile, extension_dir)
		if(next && next.z == z)
			line_tiles += next
			last_tile = next

	// Visual warning with enhanced effects - show wider area
	for(var/turf/T in line_tiles)
		new /obj/effect/temp_visual/column_warning(T)
		// Add rumbling effect
		for(var/mob/living/L in T)
			to_chat(L, span_userdanger("The ground begins to resonate violently!"))

		// Also warn adjacent tiles
		for(var/turf/adj in orange(1, T))
			if(adj.z == z)
				var/obj/effect/temp_visual/column_warning/W = new(adj)
				W.alpha = 120 // Side tiles are more transparent

	playsound(src, 'sound/effects/lc13_environment/day_50/Shake_Start.ogg', 100, TRUE, 50)

	// Start conversion after delay
	addtimer(CALLBACK(src, PROC_REF(ConvertResonanceLine), line_tiles), 15)

/mob/living/simple_animal/hostile/distortion/pianist/proc/ConvertResonanceLine(list/tiles)
	if(QDELETED(src))
		return

	for(var/i in 1 to length(tiles))
		if(QDELETED(src))
			break

		var/turf/T = tiles[i]
		if(!T || T.z != z)
			continue

		// Convert main tile
		ConvertToWateryRock(T)

		// Heavy damage and effects on tile - always happens regardless of turf type
		for(var/mob/living/L in T)
			L.apply_damage(60, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.Knockdown(30) // 3 second knockdown
				H.add_confusion(15)
			to_chat(L, span_userdanger("The resonating earth tears through you!"))
			if(L.client)
				shake_camera(L, 4, 3)

		// Damage structures on main line
		for(var/obj/structure/S in T)
			if(S.resistance_flags & INDESTRUCTIBLE)
				continue
			S.take_damage(100, WHITE_DAMAGE, "melee", 1)
			playsound(S, 'sound/effects/lc13_environment/day_50/Shake_End.ogg', 60, TRUE)

		// Make the line wider - affect adjacent tiles
		for(var/turf/adj in orange(1, T))
			if(adj.z != z)
				continue

			// Side tiles take less damage but still convert
			for(var/mob/living/L in adj)
				L.apply_damage(30, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				to_chat(L, span_warning("The resonance catches you!"))
				if(L.client)
					shake_camera(L, 2, 2)

			// Damage structures on side tiles too
			for(var/obj/structure/S in adj)
				if(S.resistance_flags & INDESTRUCTIBLE)
					continue
				S.take_damage(50, WHITE_DAMAGE, "melee", 1)

			// Only convert if not already wateryrock
			if(!istype(adj, /turf/open/floor/plating/ashplanet/wateryrock))
				addtimer(CALLBACK(src, PROC_REF(ConvertToWateryRock), adj, TRUE), 0.5)

		// Additional cascade effect - reduced to prevent overlapping conversions
		if(prob(50)) // Only 50% chance for far cascade
			var/cascade_count = 1 // Only 1 far cascade to reduce wall breaking
			var/list/far_adjacent = list()
			for(var/turf/adj in orange(2, T))
				if(get_dist(adj, T) == 2 && adj.z == z)
					// Include wateryrock tiles for damage cascade
					far_adjacent += adj

			for(var/j in 1 to min(cascade_count, length(far_adjacent)))
				var/turf/cascade = pick_n_take(far_adjacent)
				addtimer(CALLBACK(src, PROC_REF(ConvertToWateryRock), cascade, TRUE), j * 0.5 + 1)

		sleep(2) // 0.2s between main line tiles

/mob/living/simple_animal/hostile/distortion/pianist/proc/ConvertToWateryRock(turf/T, cascade = FALSE)
	if(!T || QDELETED(src) || istype(T, /turf/open/space))
		return

	// Check if already converted - but still do damage
	if(istype(T, /turf/open/floor/plating/ashplanet/wateryrock))
		// Still damage mobs on wateryrock tiles
		if(cascade)
			for(var/mob/living/L in T)
				L.apply_damage(20, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					H.add_confusion(10)
		return

	// Also skip if already ash rock to prevent overwriting
	if(istype(T, /turf/closed/mineral/ash_rock))
		return

	// Visual effect
	new /obj/effect/temp_visual/small_smoke/halfsecond(T)

	// Use day_50 sounds for breaking with more impact
	if(cascade)
		playsound(T, 'sound/effects/lc13_environment/day_50/Shake_Down.ogg', 50, TRUE)
	else
		playsound(T, 'sound/effects/lc13_environment/day_50/Shake_End.ogg', 80, TRUE)

	// Convert area if space
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

	// Break through walls and dense objects
	if(istype(T, /turf/closed))
		// 80% chance to convert to ash rock instead of breaking through
		if(prob(80))
			T.ChangeTurf(/turf/closed/mineral/ash_rock)
		else
			T.ChangeTurf(/turf/open/floor/plating/ashplanet/wateryrock)
	else
		T.ChangeTurf(/turf/open/floor/plating/ashplanet/wateryrock)

	// Damage mobs in cascade - even on wateryrock
	if(cascade)
		for(var/mob/living/L in T)
			L.apply_damage(20, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.add_confusion(10) // Slowdown effect

	// Track converted tiles
	converted_tiles += T

/mob/living/simple_animal/hostile/distortion/pianist/proc/TransitionToPerformance()
	phase = PIANIST_PHASE_PERFORMANCE

	// Stop all falling notes
	for(var/obj/effect/falling_music_note/note in world)
		qdel(note)

	// Dramatic pause
	visible_message(span_colossus("The Pianist pauses, fingers hovering over the keys..."))

	sleep(20) // 2 second pause

	// Global message
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "The overture ends. Let the performance begin.", 25))

	// Slam keys creating shockwave
	visible_message(span_colossus("[src] SLAMS the keys with tremendous force!"))
	playsound(src, 'sound/abnormalities/mountain/slam.ogg', 150, TRUE, 40)

	// Shockwave effect
	for(var/mob/living/L in hearers(10, src))
		if(L.client)
			shake_camera(L, 3, 2)

	// Start thunderstorm
	StartPianistStorm()

	// Adjust cooldowns for Phase 2
	falling_note_cooldown_time = 45 SECONDS

	visible_message(span_boldannounce("The Pianist's true performance begins!"))

/mob/living/simple_animal/hostile/distortion/pianist/proc/StartPianistStorm()
	// Create aesthetic thunderstorm
	var/area/A = get_area(src)
	if(!A)
		return

	// Use SSweather to run the storm properly
	SSweather.run_weather(/datum/weather/pianist_storm)

/mob/living/simple_animal/hostile/distortion/pianist/proc/AttemptCrossMapResonance()
	resonance_line_cooldown = world.time + resonance_line_cooldown_time

	// Find two random points far apart
	var/list/valid_turfs = list()
	for(var/turf/T in range(40, src))
		if(T.z != z)
			continue
		if(istype(T, /turf/closed))
			continue
		if(istype(T, /turf/open/space))
			continue
		valid_turfs += T

	if(length(valid_turfs) < 20) // Not enough space
		AttemptResonanceLine() // Fallback to regular line
		return

	// Pick first point
	var/turf/point1 = pick(valid_turfs)

	// Find second point at least 10 tiles away
	var/list/far_turfs = list()
	for(var/turf/T in valid_turfs)
		if(get_dist(T, point1) >= 10)
			far_turfs += T

	if(!length(far_turfs))
		AttemptResonanceLine() // Fallback to regular line
		return

	var/turf/point2 = pick(far_turfs)

	// Use a charge
	resonance_line_charges--

	visible_message(span_colossus("[src]'s piano TEARS THROUGH THE FABRIC OF REALITY!"))
	playsound(src, 'sound/effects/lc13_environment/day_50/Shake_Start.ogg', 125, TRUE, 75)

	// Global screen shake for the power
	for(var/mob/living/L in range(30, src))
		if(L.client)
			shake_camera(L, 3, 3)
			to_chat(L, span_boldwarning("You feel space itself trembling!"))

	// Create cross-map line
	CreateCrossMapLine(point1, point2)

/mob/living/simple_animal/hostile/distortion/pianist/proc/CreateCrossMapLine(turf/point1, turf/point2)
	if(!point1 || !point2 || QDELETED(src))
		return

	// Get line between points
	var/list/line_tiles = getline(point1, point2)
	if(!length(line_tiles))
		return

	// Extend the line 5 tiles past each point
	var/list/extended_tiles = list()

	// Extend from point1 backwards
	if(length(line_tiles) >= 2)
		var/turf/T1 = line_tiles[1]
		var/turf/T2 = line_tiles[2]
		var/backwards_dir = get_dir(T2, T1)
		var/turf/current = T1
		for(var/i in 1 to 5)
			current = get_step(current, backwards_dir)
			if(!current || current.z != z)
				break
			extended_tiles += current

	// Add main line
	extended_tiles += line_tiles

	// Extend from point2 forwards
	if(length(line_tiles) >= 2)
		var/turf/T1 = line_tiles[length(line_tiles)-1]
		var/turf/T2 = line_tiles[length(line_tiles)]
		var/forwards_dir = get_dir(T1, T2)
		var/turf/current = T2
		for(var/i in 1 to 5)
			current = get_step(current, forwards_dir)
			if(!current || current.z != z)
				break
			extended_tiles += current

	// Visual warning for all tiles - show wider area
	for(var/turf/T in extended_tiles)
		new /obj/effect/temp_visual/column_warning(T)

		// Also warn adjacent tiles for wider effect
		for(var/turf/adj in orange(1, T))
			if(adj.z == z)
				new /obj/effect/temp_visual/column_warning(adj)
				adj.alpha = 180 // Slightly transparent

	// Convert after delay
	addtimer(CALLBACK(src, PROC_REF(ConvertResonanceLine), extended_tiles), 15)

// Combat-only variant - no Phase 1, starts directly in performance mode
/mob/living/simple_animal/hostile/distortion/pianist/combat
	name = "The Pianist - Finale"
	desc = "The performance has already begun. There is no overture, only the crescendo."
	phase = PIANIST_PHASE_PERFORMANCE // Start in Phase 2

/mob/living/simple_animal/hostile/distortion/pianist/combat/Initialize()
	. = ..()
	// Skip phase timer setup
	phase_timer = 0

	// Start with some melody stacks for immediate threat
	AddMelody(5)

	// Immediate combat stats
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

	// Start the thunderstorm immediately
	spawn(10) // Small delay for spawn-in
		StartPianistStorm()
		visible_message(span_colossus("THE PIANIST'S FINALE BEGINS!"))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "The performance reaches its peak from the very first note.", 25))

/mob/living/simple_animal/hostile/distortion/pianist/combat/PerformEntranceSequence()
	// Skip the elaborate entrance, just do a quick spawn
	set waitfor = FALSE

	var/turf/landing_turf = get_turf(src)
	if(!landing_turf)
		return

	// Quick entrance effect
	alpha = 0
	animate(src, alpha = 255, time = 10)
	playsound(landing_turf, 'sound/effects/ordeals/gold/weather_thunder_0.ogg', 100, TRUE, 40)

	// Small impact area
	for(var/turf/T in range(2, landing_turf))
		if(prob(50))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)

	// Start attacking immediately
	ranged = TRUE

/mob/living/simple_animal/hostile/distortion/pianist/combat/Life()
	. = ..()
	if(!.)
		return FALSE

	// No phase transition needed - always in performance mode
	return

#undef PIANIST_PHASE_OVERTURE
#undef PIANIST_PHASE_PERFORMANCE
