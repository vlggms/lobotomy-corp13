// Music Note Mob
/mob/living/simple_animal/hostile/pianist_music_note
	name = "resonating music note"
	desc = "A physical manifestation of sound that pulses with malevolent energy."
	icon = 'ModularTegustation/Teguicons/pianist_effects.dmi'
	icon_state = "music_note_1"
	layer = ABOVE_MOB_LAYER
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	health = 500
	maxHealth = 500
	mob_biotypes = MOB_ROBOTIC
	movement_type = FLYING
	is_flying_animal = TRUE
	status_flags = GODMODE // Prevent normal death, we handle it manually
	AIStatus = AI_OFF

	var/mob/living/simple_animal/hostile/distortion/pianist/pianist_owner
	var/damage_amount = 15
	var/ring_cooldown = 0
	var/ring_cooldown_time = 4 SECONDS
	var/duration = 20 SECONDS
	var/ring_range = 2 // 5x5 = view(2)

	// Resistances as per design doc
	damage_coeff = list(RED_DAMAGE = 1.4, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)

/mob/living/simple_animal/hostile/pianist_music_note/Initialize()
	. = ..()
	icon_state = pick("music_note_1", "music_note_2")
	QDEL_IN(src, duration)
	playsound(src, 'sound/abnormalities/fateloom/garrote.ogg', 50, TRUE)

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
	for(var/mob/living/carbon/human/H in view(ring_range, src))
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

/mob/living/simple_animal/hostile/pianist_music_note/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	health = clamp(health - amount, 0, maxHealth)
	if(health <= 0)
		death()

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
	qdel(src)

// Visual Effects
/obj/effect/pianist_melody_visual
	name = "melody"
	desc = "A red music note orbiting the Pianist."
	icon = 'ModularTegustation/Teguicons/pianist_effects.dmi'
	icon_state = "music_note_1"
	color = "#FF0000"
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/music_note_warning
	name = "falling note shadow"
	icon = 'icons/effects/effects.dmi'
	icon_state = "spreadwarning"
	layer = BELOW_MOB_LAYER
	duration = 20

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
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "bloodsparkles"
	layer = BELOW_MOB_LAYER
	duration = 15
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
	// Apply white damage resistance reduction
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.white_mod += (stacks * 0.1)
	return TRUE

/datum/status_effect/reverting_song/on_remove()
	// Remove white damage resistance reduction
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.white_mod -= (stacks * 0.1)

/datum/status_effect/reverting_song/refresh(stacks_to_add = 1)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.white_mod -= (stacks * 0.1)
	stacks += stacks_to_add
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.white_mod += (stacks * 0.1)

// Musical Fascination panic type
/datum/status_effect/musical_fascination
	id = "musical_fascination"
	tick_interval = 10
	alert_type = null
	var/mob/living/simple_animal/hostile/distortion/pianist/target_pianist

/datum/status_effect/musical_fascination/on_creation(mob/living/new_owner, mob/living/simple_animal/hostile/distortion/pianist/pianist)
	if(pianist)
		target_pianist = pianist
	. = ..()

/datum/status_effect/musical_fascination/on_apply()
	. = ..()
	if(!target_pianist)
		return FALSE
	if(prob(10) && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		owner.visible_message(span_danger("[owner]'s eyes glaze over as they become entranced by the music!"))
		H.gain_trauma(/datum/brain_trauma/special/musical_corruption)
	return TRUE

/datum/status_effect/musical_fascination/on_remove()
	. = ..()
	return

/datum/status_effect/musical_fascination/tick()
	if(!target_pianist || QDELETED(target_pianist) || target_pianist.stat == DEAD)
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

		if(path && path.len > 1)
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
