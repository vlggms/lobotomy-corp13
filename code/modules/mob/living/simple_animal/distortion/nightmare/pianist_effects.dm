// Music Note Mob
/mob/living/simple_animal/hostile/pianist_music_note
	name = "resonating music note"
	desc = "A physical manifestation of sound that pulses with malevolent energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	layer = ABOVE_MOB_LAYER
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	health = 500
	maxHealth = 500
	mob_biotypes = MOB_ROBOTIC
	movement_type = FLYING
	status_flags = GODMODE // Prevent normal death, we handle it manually
	AIStatus = AI_OFF

	var/mob/living/simple_animal/hostile/distortion/pianist/pianist_owner
	var/damage_amount = 20
	var/ring_cooldown = 0
	var/ring_cooldown_time = 4 SECONDS
	var/duration = 10 SECONDS
	var/ring_range = 2 // 5x5 = view(2)

	// Resistances as per design doc
	damage_coeff = list(RED_DAMAGE = 1.4, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)

/mob/living/simple_animal/hostile/pianist_music_note/Initialize()
	. = ..()
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
		H.apply_damage(damage_amount, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
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
		if(song)
			song.refresh()
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
		else
			H.apply_status_effect(/datum/status_effect/reverting_song)
			to_chat(H, span_warning("Breaking the note marks you with a reverting song!"))

/mob/living/simple_animal/hostile/pianist_music_note/death(gibbed)
	qdel(src)

/mob/living/simple_animal/hostile/pianist_music_note/examine(mob/user)
	. = ..()
	. += span_notice("It has [health]/[maxHealth] integrity remaining.")

// Visual Effects
/obj/effect/pianist_melody_visual
	name = "melody"
	desc = "A red music note orbiting the Pianist."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndballoon"
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/music_note_warning
	name = "falling note shadow"
	icon = 'icons/turf/areas.dmi'
	icon_state = "bluenew"
	layer = BELOW_MOB_LAYER
	duration = 20

/obj/effect/temp_visual/aoe_warning
	name = "discordant aura"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield1"
	layer = BELOW_MOB_LAYER
	duration = 10
	alpha = 128

/obj/effect/temp_visual/resonance_ring
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	duration = 10

/obj/effect/temp_visual/resonance_ring/Initialize()
	. = ..()
	transform = matrix() * 0.5
	animate(src, transform = matrix() * 2, alpha = 0, time = duration)

// Projectiles
/obj/projectile/pianist_warning
	name = "harmonic echo"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "neurotoxin"
	damage = 0
	damage_type = WHITE_DAMAGE
	pass_flags = PASSMOB | PASSMACHINE | PASSSTRUCTURE
	projectile_phasing = ALL

/obj/projectile/pianist_projectile
	name = "discordant note"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "energy"
	damage = 25
	damage_type = WHITE_DAMAGE
	speed = 2
	ricochets_max = 5
	ricochet_chance = 100
	ricochet_auto_aim_angle = 30
	ricochet_auto_aim_range = 3
	ricochet_incidence_leeway = 80

	var/mob/living/simple_animal/hostile/distortion/pianist/pianist_owner
	var/deceleration_rate = 0.1
	var/acceleration_point = 20 // When to start accelerating back
	var/returning = FALSE
	var/fired_time = 0

/obj/projectile/pianist_projectile/Initialize()
	. = ..()
	fired_time = world.time
	START_PROCESSING(SSprojectiles, src)

/obj/projectile/pianist_projectile/Destroy()
	STOP_PROCESSING(SSprojectiles, src)
	return ..()

/obj/projectile/pianist_projectile/process()
	if(!pianist_owner || QDELETED(pianist_owner))
		qdel(src)
		return

	// Slow down over 2 seconds
	if(!returning && world.time > fired_time + acceleration_point)
		speed = min(speed + deceleration_rate, 2)

		// Once stopped, start returning
		if(speed >= 2)
			returning = TRUE
			set_angle(Get_Angle(src, pianist_owner))

	// Accelerate when returning
	if(returning)
		speed = max(speed - deceleration_rate, 0.5)
		set_angle(Get_Angle(src, pianist_owner))

		// Delete when reaching the pianist
		if(get_dist(src, pianist_owner) <= 1)
			qdel(src)

/obj/projectile/pianist_projectile/on_hit(atom/target, blocked = FALSE, pierce_hit)
	. = ..()
	if(istype(target, /mob/living/simple_animal/hostile/distortion/pianist))
		qdel(src)
		return BULLET_ACT_HIT

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
		H.physiology.white_mod *= (1 + (stacks * 0.1))
	return TRUE

/datum/status_effect/reverting_song/on_remove()
	// Remove white damage resistance reduction
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.white_mod /= (1 + (stacks * 0.1))

/datum/status_effect/reverting_song/refresh(stacks_to_add = 1)
	stacks += stacks_to_add

// Examination is handled differently in this codebase

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
	owner.visible_message(span_danger("[owner]'s eyes glaze over as they become entranced by the music!"))
	return TRUE

/datum/status_effect/musical_fascination/on_remove()
	. = ..()
	return

/datum/status_effect/musical_fascination/tick()
	if(!target_pianist || QDELETED(target_pianist) || target_pianist.stat == DEAD)
		owner.remove_status_effect(src)
		return

	// Move towards the pianist
	if(get_dist(owner, target_pianist) > 7)
		step_towards(owner, target_pianist)
		if(prob(5))
			owner.say("That music... I must reach it...")
	else
		// In view range (7), get absorbed
		target_pianist.AbsorbVictim(owner)
		owner.death(FALSE)
		owner.remove_status_effect(src)

/datum/status_effect/musical_fascination/tick()
	. = ..()
	// Also check if sanity is restored
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!H.sanity_lost)
			H.remove_status_effect(src)
