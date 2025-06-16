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
	ego_list = list()
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

	var/datum/looping_sound/pianist/soundloop

/mob/living/simple_animal/hostile/distortion/pianist/Initialize()
	. = ..()
	current_aoe_pattern = shuffle(current_aoe_pattern)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "O sorrow, I have ended, you see, by respecting you.", 25))
	soundloop = new(list(src), FALSE)
	soundloop.start()

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

/mob/living/simple_animal/hostile/distortion/pianist/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		var/health_percent_lost = . / maxHealth * 100
		if(health_percent_lost >= 15)
			AddMelody(round(health_percent_lost / 15))

/mob/living/simple_animal/hostile/distortion/pianist/attacked_by(obj/item/I, mob/living/user)
	// Check for reverting song immunity
	var/datum/status_effect/reverting_song/song_effect = user?.has_status_effect(/datum/status_effect/reverting_song)
	if(!song_effect || song_effect.stacks == 0)
		to_chat(user, span_warning("Your attack passes harmlessly through [src]!"))
		playsound(src, 'sound/effects/attackblob.ogg', 50, TRUE)
		return FALSE

	// Increase damage based on reverting song stacks
	var/damage_mod = 0.2 * (1 + song_effect.stacks * 0.1)
	ChangeResistances(list(RED_DAMAGE = damage_mod, WHITE_DAMAGE = damage_mod, BLACK_DAMAGE = damage_mod, PALE_DAMAGE = damage_mod))
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

	return ..()

/mob/living/simple_animal/hostile/distortion/pianist/proc/AddMelody(amount = 1)
	melody_stacks += amount
	UpdateMelodyVisuals()

/mob/living/simple_animal/hostile/distortion/pianist/proc/UpdateMelodyVisuals()
	// Clear old visuals
	for(var/obj/effect/pianist_melody_visual/V in melody_visuals)
		qdel(V)
	melody_visuals.Cut()

	// Create new visuals based on stack count
	for(var/i in 1 to min(melody_stacks, 10))
		var/obj/effect/pianist_melody_visual/V = new(src)
		V.orbit(src, 20 + (i * 5), pick(TRUE, FALSE), rand(10, 20))
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
			L.apply_damage(20, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
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
			L.apply_damage(damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.apply_status_effect(/datum/status_effect/musical_fascination, src)

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
