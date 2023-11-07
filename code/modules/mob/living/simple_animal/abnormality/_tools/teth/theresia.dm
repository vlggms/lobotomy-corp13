#define ACTIVE_NORMAL 1
#define ACTIVE_DANGEROUS 2

//Coded by InsightfulParasite
/obj/structure/toolabnormality/theresia
	name = "windup music box"
	desc = "An old ornate music box with a ballerina ontop. Carved onto the side of the music box is the phrase 'Do you remember this melody? The professor used to play this song when the students were sleepy. Happy birthday.'"
	icon_state = "theresia"
	anchored = FALSE
	drag_slowdown = 1.5
	var/icon_active = "theresia_active"
	var/activated = FALSE
	/// While cooldown is above world.time - cannot be toggled
	var/activation_cooldown
	var/activation_cooldown_time = 45 SECONDS
	var/max_winds = 6
	var/current_winds = 1
	var/pulse_heal = 10
	var/pulse_damage = 20

/obj/structure/toolabnormality/theresia/attack_hand(mob/user) //defines activator as user.
	if(activation_cooldown > world.time)
		to_chat(user, span_warning("You cannot [activated ? "stop" : "start"] \the [src] just yet!"))
		return

	if(activated)
		Deactivate(user)
	else
		Activate(user)
	add_fingerprint(user)

/obj/structure/toolabnormality/theresia/process()
	if(!activated)
		return

	// Dangerous effect
	if(current_winds >= max_winds)
		if(activated == ACTIVE_DANGEROUS)
			Deactivate()
			return
		activation_cooldown = world.time + 90 SECONDS // CAN'T STOP THE MUSIC!!
		activated = ACTIVE_DANGEROUS
		current_winds = 0

	current_winds += 1

	if(activated == ACTIVE_DANGEROUS)
		playsound(get_turf(src), 'sound/machines/clockcult/ark_scream.ogg', 50, 0, 24)
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
		for(var/mob/living/carbon/human/H in livinginrange(32, get_turf(src)))
			H.apply_damage(pulse_damage, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
		return

	// Healing effect
	for(var/mob/living/carbon/human/L in view(8, src))
		if(L.stat == DEAD)
			continue
		L.adjustSanityLoss(-pulse_damage)
		if(prob(10))
			to_chat(L, span_notice("Despite the challenge, something reassures you that things will be okay."))

/obj/structure/toolabnormality/theresia/proc/Activate(mob/user)
	activation_cooldown = world.time + 2 SECONDS // Just there to prevent spam
	icon_state = icon_active
	to_chat(user, span_notice("You begin to wind up [src]."))
	visible_message(span_hear("[src] starts to wind up."))
	playsound(get_turf(src), 'sound/effects/ordeals/pink_start.ogg', 50, 0, 4)
	current_winds = 0
	activated = ACTIVE_NORMAL
	START_PROCESSING(SSobj, src)

/obj/structure/toolabnormality/theresia/proc/Deactivate(mob/user)
	activation_cooldown = world.time + activation_cooldown_time
	icon_state = initial(icon_state)
	to_chat(user, span_notice("You deactivate the [src]."))
	visible_message(span_hear("The [activated == ACTIVE_NORMAL ? "calming" : "disturbing"] music stops."))
	playsound(get_turf(src), 'sound/effects/clock_tick.ogg', 50, 0, 4)
	activated = FALSE
	STOP_PROCESSING(SSobj,src)

#undef ACTIVE_NORMAL
#undef ACTIVE_DANGEROUS
