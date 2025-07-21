/*
The Pianist Distortion

A musical-themed distortion with the following mechanics:
1. Summons falling music notes that deal damage over time
2. Gains "Melody" stacks from absorbed victims and lost health
3. Melody stacks enhance all abilities (more targets, longer duration, higher damage)
4. Performs AoE attacks with varying ranges and warning telegraphs
5. Fires bouncing projectiles that slow down then return
6. Immune to damage from attackers without "Reverting Song" debuff
7. Causes special "Musical Fascination" panic that draws victims to be absorbed
8. Can inflict permanent "Musical Corruption" brain trauma

Based on the design document in ThePianistDesignDoc.md
*/
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
	var/base_note_damage = 20
	var/base_aoe_damage = 30
	var/list/melody_visuals = list()
	var/damage_threshold_tracker = 0 // Tracks damage for melody gain
	var/column_attack_cooldown = 0
	var/column_attack_cooldown_time = 8 SECONDS
	var/list/recent_attackers = list()
	var/column_width = 9 // 4 tiles up and down plus center
	var/column_warning_time = 15 // 1.5 seconds

	var/datum/looping_sound/pianist/soundloop

/mob/living/simple_animal/hostile/distortion/pianist/Initialize()
	. = ..()
	current_aoe_pattern = shuffle(current_aoe_pattern)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "O sorrow, I have ended, you see, by respecting you.", 25))
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

	// Summon music notes
	if(note_summon_cooldown < world.time)
		SummonMusicNotes()

	// AoE attacks
	if(aoe_attack_cooldown < world.time)
		PerformAoEAttack()

	// Column attacks
	if(column_attack_cooldown < world.time && recent_attackers.len)
		PerformColumnAttack()

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
			if(recent_attackers.len > 5)
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
		if(recent_attackers.len > 5)
			recent_attackers.Cut(1, 2)

	return ..()

/mob/living/simple_animal/hostile/distortion/pianist/bullet_act(obj/projectile/P)
	if(!P.firer)
		return ..()

	var/datum/status_effect/reverting_song/song_effect
	if(isliving(P.firer))
		var/mob/living/L = P.firer
		song_effect = L.has_status_effect(/datum/status_effect/reverting_song)
	if(!song_effect || song_effect.stacks == 0)
		visible_message(span_warning("[P] passes harmlessly through [src]!"))
		playsound(src, 'sound/effects/attackblob.ogg', 50, TRUE)
		return BULLET_ACT_BLOCK

	var/damage_mod = 0.2 * (1 + song_effect.stacks * 0.1)
	ChangeResistances(list(RED_DAMAGE = damage_mod, WHITE_DAMAGE = damage_mod, BLACK_DAMAGE = damage_mod, PALE_DAMAGE = damage_mod))

	// Track attacker
	if(P.firer && !(P.firer in recent_attackers))
		recent_attackers += P.firer
		if(recent_attackers.len > 5)
			recent_attackers.Cut(1, 2)

	. = ..()

/mob/living/simple_animal/hostile/distortion/pianist/death(gibbed)
	QDEL_NULL(soundloop)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "You will be there, lying in my sheets, O sorrow.", 25))
	// Drop all absorbed bodies
	for(var/mob/living/carbon/human/H in absorbed_bodies)
		H.forceMove(get_turf(src))
	absorbed_bodies.Cut()

	// Clear melody visuals
	for(var/obj/effect/pianist_melody_visual/V in melody_visuals)
		qdel(V)
	melody_visuals.Cut()

	// Clean up any stray melody visuals that might exist
	for(var/obj/effect/pianist_melody_visual/V in world)
		qdel(V)

	// Remove all music notes
	for(var/mob/living/simple_animal/hostile/pianist_music_note/note in GLOB.mob_list)
		qdel(note)

	// Cure all humans of musical fascination
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		H.remove_status_effect(/datum/status_effect/musical_fascination)

	// Fade out animation
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
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

	// Warning indicator
	new /obj/effect/temp_visual/music_note_warning(target_turf)
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
			var/damage = 20
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
			new /obj/effect/temp_visual/aoe_warning(T)

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

	if(!recent_attackers.len)
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
