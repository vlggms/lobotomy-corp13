// It is effectively an ordeal in how it works
/datum/suppression/extraction
	name = EXTRACTION_CORE_SUPPRESSION
	desc = "The illusion of the Arbiter will return to wreak havoc once more. <br>\
			Special types of meltdowns have to be cleared to weaken the Arbiter; Otherwise you stand no chance."
	goal_text = "Defeat the Arbiter."
	run_text = "The core suppression of Extraction department has begun. The Arbiter has returned."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE

/datum/suppression/extraction/Run(run_white = FALSE, silent = FALSE)
	..()
	var/turf/T = pick(GLOB.department_centers)
	var/mob/living/simple_animal/hostile/megafauna/arbiter/A = new(T)
	RegisterSignal(A, COMSIG_PARENT_QDELETING, PROC_REF(OnArbiterDeath))

/datum/suppression/extraction/End(silent = FALSE)
	..()
	SSlobotomy_corp.core_suppression_state = max(SSlobotomy_corp.core_suppression_state, 3)
	SSticker.news_report = max(SSticker.news_report, CORE_SUPPRESSED_ARBITER_DEAD)

/datum/suppression/extraction/proc/OnArbiterDeath(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	End()

// The Arbiter mob
/mob/living/simple_animal/hostile/megafauna/arbiter
	name = "Arbiter"
	desc = "The elite agent of the head; Despite being a mere imitation, it is nonetheless an intimidating foe."
	health = 10000
	maxHealth = 10000
	damage_coeff = list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.1)
	icon_state = "arbiter"
	icon_living = "arbiter"
	icon_dead = "arbiter"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	faction = list("hostile", "silicon", "apostle", "slime", "warden", "blueshep", "Head") // Cannot be attacked by any abnormality
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_color = "#AAAAAA"
	light_range = 5
	movement_type = GROUND
	speak_emote = list("says")
	stat_attack = HARD_CRIT
	ranged = TRUE
	ranged_cooldown_time = 5
	minimum_distance = 2
	speed = 4
	move_to_delay = 4.5
	pixel_x = -16
	base_pixel_x = -16
	blood_volume = BLOOD_VOLUME_NORMAL
	del_on_death = FALSE
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(
		/datum/action/innate/megafauna_attack/arbiter_fairy,
		/datum/action/innate/megafauna_attack/arbiter_key,
		/datum/action/innate/megafauna_attack/arbiter_meltdown,
		)
	can_patrol = TRUE

	var/charging = FALSE
	/// Arbiter is only defeated after dying with life_stage at 3
	var/life_stage = 1
	/// What type of meltdown is currently going on
	var/current_meltdown_type
	/// What types of meltdown can we use
	var/list/possible_meltdown_types = list(MELTDOWN_GRAY, MELTDOWN_GOLD)
	/// List of melting consoles
	var/list/meltdowns = list()
	/// Remaining life ticks for healing; Usually applied when failing to handle meltdown of gold
	var/remaining_healing_time = 0
	var/datum/looping_sound/arbiter_pillar_storm/stormloop
	/// List of pillars that are about to get fired
	var/list/storm_pillars = list()
	/// If TRUE - will stop repeating the ring effect around arbiter
	var/stop_storm_effect = FALSE
	// Ability variables
	var/fairy_count = 5
	// Cooldowns for abilities
	var/spikes_cooldown
	var/spikes_cooldown_time = 90 SECONDS
	var/fairy_cooldown
	var/fairy_cooldown_time = 10 SECONDS
	var/key_cooldown
	var/key_cooldown_time = 20 SECONDS
	var/meltdown_cooldown
	var/meltdown_cooldown_time = 30 SECONDS // Cooldown starts after all meltdowns are cleared
	var/pillar_storm_cooldown
	var/pillar_storm_cooldown_time = 180 SECONDS

/datum/action/innate/megafauna_attack/arbiter_fairy
	name = "Fairy"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = "<span class='colossus'>You will now fire fairy projectiles at your opponents.</span>"
	chosen_attack_num = 1

/datum/action/innate/megafauna_attack/arbiter_key
	name = "Key"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = "<span class='colossus'>You will now fire a pillar at your opponents.</span>"
	chosen_attack_num = 2

/datum/action/innate/megafauna_attack/arbiter_meltdown
	name = "Special Meltdown"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = "<span class='colossus'>You will now initiate meltdowns of special type.</span>"
	chosen_attack_num = 3

/mob/living/simple_animal/hostile/megafauna/arbiter/Initialize()
	. = ..()
	stormloop = new(list(src), FALSE)
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT)
	meltdown_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/megafauna/arbiter/Destroy()
	StopPillarStorm()
	QDEL_NULL(stormloop)
	return ..()

/mob/living/simple_animal/hostile/megafauna/arbiter/Life()
	. = ..()
	if(!.)
		return
	if(remaining_healing_time > 0)
		adjustBruteLoss(-maxHealth*0.01)
		remaining_healing_time -= 1
	// Spawn spikes every once in a while
	if(spikes_cooldown <= world.time)
		INVOKE_ASYNC(src, PROC_REF(SpawnSpikes))
	if(!client && !charging && meltdown_cooldown <= world.time && !LAZYLEN(meltdowns) && prob(50))
		INVOKE_ASYNC(src, PROC_REF(SpecialMeltdown))
		return

/* Death and "Death" */

/mob/living/simple_animal/hostile/megafauna/arbiter/death()
	if(health > 0)
		return
	if(StageChange())
		return
	animate(src, alpha = 0, time = 20)
	QDEL_IN(src, 20)
	return ..()

/mob/living/simple_animal/hostile/megafauna/arbiter/gib()
	if(life_stage < 3)
		if(health < maxHealth * 0.2)
			return StageChange()
		return
	return ..()

/mob/living/simple_animal/hostile/megafauna/arbiter/proc/StageChange()
	if(life_stage >= 3)
		return FALSE // Death
	life_stage += 1
	adjustHealth(-maxHealth)
	ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.1))
	fairy_cooldown_time = max(4 SECONDS, fairy_cooldown_time - 2 SECONDS)
	key_cooldown_time = max(10 SECONDS, fairy_cooldown_time - 4 SECONDS)
	playsound(get_turf(src), 'sound/magic/arbiter/repulse.ogg', 50, TRUE, 24)
	for(var/turf/T in orange(1, src))
		new /obj/effect/temp_visual/revenant(T)
	switch(life_stage)
		if(2)
			possible_meltdown_types |= MELTDOWN_PURPLE
		if(3)
			ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	return TRUE

/* Combat */

/mob/living/simple_animal/hostile/megafauna/arbiter/AttackingTarget()
	return OpenFire(target)

/mob/living/simple_animal/hostile/megafauna/arbiter/OpenFire(target)
	if(charging)
		return
	if(client)
		switch(chosen_attack)
			if(1)
				INVOKE_ASYNC(src, PROC_REF(FairyFire), target)
			if(2)
				INVOKE_ASYNC(src, PROC_REF(KeyFire), target)
			if(3)
				INVOKE_ASYNC(src, PROC_REF(SpecialMeltdown))
		return

	if(fairy_cooldown <= world.time)
		INVOKE_ASYNC(src, PROC_REF(FairyFire), target)
		return
	if(key_cooldown <= world.time)
		INVOKE_ASYNC(src, PROC_REF(KeyFire), target)
		return

/mob/living/simple_animal/hostile/megafauna/arbiter/Move()
	if(charging)
		return FALSE
	return ..()

// Fairy
/mob/living/simple_animal/hostile/megafauna/arbiter/proc/FairyFire(atom/target)
	if(charging)
		return
	if(fairy_cooldown > world.time)
		return
	fairy_cooldown = world.time + fairy_cooldown_time

	charging = TRUE
	icon_state = "arbiter_fairy"
	if(prob(35))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), pick("Disperse.", "Heed my words, Fairies.", "Analyze. Compress. Expand.", "Do not dare to stand before me."))

	var/turf/target_loc = get_turf(target)
	var/turf/start_loc = get_turf(src)
	for(var/turf/T in getline(start_loc, get_ranged_target_turf_direct(start_loc, target_loc, 14)))
		if(T.density)
			break
		new /obj/effect/temp_visual/cult/sparks(T)

	SLEEP_CHECK_DEATH(0.5 SECONDS)

	playsound(get_turf(src), 'sound/magic/arbiter/fairy.ogg', 100, FALSE, 12)
	for(var/i = 1 to fairy_count)
		var/obj/projectile/P = new /obj/projectile/beam/fairy(start_loc)
		P.starting = start_loc
		P.firer = src
		P.fired_from = src
		P.yo = target_loc.y - start_loc.y
		P.xo = target_loc.x - start_loc.x
		P.original = target
		P.preparePixelProjectile(target_loc, src, spread = rand(0, 7))
		P.fire()

	SLEEP_CHECK_DEATH(1 SECONDS)
	charging = FALSE
	icon_state = icon_living

// Key
/mob/living/simple_animal/hostile/megafauna/arbiter/proc/KeyFire(atom/target)
	if(charging)
		return
	if(key_cooldown > world.time)
		return
	key_cooldown = world.time + key_cooldown_time

	charging = TRUE
	icon_state = "arbiter_ability"
	if(prob(35))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), pick("Condensing the Key.", "Focus.", "Open.", "Wreak havoc.", "Come on out.", "Crumble."))

	var/turf/target_loc = get_turf(target)
	var/turf/start_loc = get_turf(src)
	for(var/turf/T in getline(start_loc, get_ranged_target_turf_direct(start_loc, target_loc, 24)))
		new /obj/effect/temp_visual/cult/sparks(T)

	SLEEP_CHECK_DEATH(0.5 SECONDS)

	playsound(get_turf(src), 'sound/magic/arbiter/pillar_start.ogg', 75, FALSE, 12)

	var/projectile_type = pick(typesof(/obj/projectile/magic/aoe/pillar))
	var/obj/projectile/P = new projectile_type(start_loc)
	P.starting = start_loc
	P.firer = src
	P.fired_from = src
	P.yo = target_loc.y - start_loc.y
	P.xo = target_loc.x - start_loc.x
	P.original = target
	P.preparePixelProjectile(target_loc, src)
	addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), 0.8 SECONDS)

	SLEEP_CHECK_DEATH(0.8 SECONDS)

	icon_state = "arbiter_fairy"

	SLEEP_CHECK_DEATH(1 SECONDS)
	charging = FALSE
	icon_state = icon_living

// Meltdown
/mob/living/simple_animal/hostile/megafauna/arbiter/proc/SpecialMeltdown()
	if(charging)
		return
	if(LAZYLEN(meltdowns))
		return
	if(meltdown_cooldown > world.time)
		return
	charging = TRUE
	icon_state = "arbiter_ability"
	ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.1))

	SLEEP_CHECK_DEATH(1 SECONDS)
	playsound(get_turf(src), 'sound/magic/arbiter/repulse.ogg', 50, TRUE, 7)
	for(var/turf/T in orange(2, src))
		new /obj/effect/temp_visual/revenant(T)
	SLEEP_CHECK_DEATH(1 SECONDS)

	var/meltdown_type = pick(possible_meltdown_types)
	var/meltdown_text = "Qliphoth meltdown occured in containment zones of the following abnormalities:"
	var/meltdown_min_time = 60
	var/meltdown_max_time = 60
	if(life_stage == 3 && world.time > pillar_storm_cooldown) // Always do pillars when off cooldown
		meltdown_type = MELTDOWN_CYAN
	switch(meltdown_type)
		if(MELTDOWN_GRAY)
			meltdown_text = "Meltdown of Dark Fog has occured in containment zones of the following abnormalities:"
			meltdown_min_time = 45
			meltdown_max_time = 45
		if(MELTDOWN_GOLD)
			meltdown_text = "Meltdown of Gold has occured in containment zones of the following abnormalities:"
		if(MELTDOWN_PURPLE)
			meltdown_text = "Meltdown of Waves has occured in containment zones of the following abnormalities:"
		if(MELTDOWN_CYAN)
			meltdown_text = "Meltdown of Pillars has occured in containment zones of the following abnormalities:"
			meltdown_min_time = 45
			meltdown_max_time = 45

	current_meltdown_type = meltdown_type
	var/player_count = 0
	for(var/mob/player in GLOB.player_list)
		if(isliving(player) && (player.mind?.assigned_role in GLOB.security_positions))
			player_count += 1.5
	player_count = round(player_count) + (player_count > round(player_count) ? 1 : 0) // Trying to round up
	meltdowns = SSlobotomy_corp.InitiateMeltdown(clamp(rand(player_count*0.5, player_count), 1, 10), TRUE, meltdown_type, meltdown_min_time, meltdown_max_time, meltdown_text, 'sound/magic/arbiter/meltdown.ogg')
	for(var/obj/machinery/computer/abnormality/A in meltdowns)
		RegisterSignal(A, COMSIG_MELTDOWN_FINISHED, PROC_REF(OnMeltdownFinish))

	icon_state = icon_living
	charging = FALSE

	if(LAZYLEN(meltdowns) && meltdown_type == MELTDOWN_CYAN)
		INVOKE_ASYNC(src, PROC_REF(StartPillarStorm))

/mob/living/simple_animal/hostile/megafauna/arbiter/proc/OnMeltdownFinish(datum/source, datum/abnormality/abno_datum, worked)
	SIGNAL_HANDLER

	meltdowns -= source
	UnregisterSignal(source, COMSIG_MELTDOWN_FINISHED)
	if(!worked)
		for(var/obj/machinery/computer/abnormality/A in meltdowns)
			UnregisterSignal(A, COMSIG_MELTDOWN_FINISHED)
		meltdowns = list()
		INVOKE_ASYNC(src, PROC_REF(FailedMeltdownEffect))
		return
	if(!LAZYLEN(meltdowns))
		INVOKE_ASYNC(src, PROC_REF(HandledMeltdownEffect))
		return
	playsound(get_turf(src), 'sound/magic/arbiter/meltdown_clear.ogg', 50, TRUE, 4)

/mob/living/simple_animal/hostile/megafauna/arbiter/proc/FailedMeltdownEffect()
	meltdown_cooldown = world.time + meltdown_cooldown_time
	var/blurb_text = "You missed the opportunity."
	switch(current_meltdown_type)
		if(MELTDOWN_GOLD)
			blurb_text = "You failed to bend my back."
			remaining_healing_time = 20
		if(MELTDOWN_PURPLE)
			blurb_text = "You cannot stop the torrent of this world alone."
		if(MELTDOWN_CYAN)
			blurb_text = "Your immaturity is to blame."
			INVOKE_ASYNC(src, PROC_REF(FirePillarStorm))
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, blurb_text, 1 SECONDS, "black", "yellow", "left", "CENTER,BOTTOM+2")

/mob/living/simple_animal/hostile/megafauna/arbiter/proc/HandledMeltdownEffect()
	playsound(get_turf(src), 'sound/magic/arbiter/meltdown_clear_all.ogg', 50, TRUE, 24)
	meltdown_cooldown = world.time + meltdown_cooldown_time
	var/last_stage = life_stage
	switch(current_meltdown_type)
		if(MELTDOWN_GRAY)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "I am fading.", 1 SECONDS, "black", "yellow", "left", "CENTER,BOTTOM+2")
			ChangeResistances(list(RED_DAMAGE = 2, WHITE_DAMAGE = 2, BLACK_DAMAGE = 2, PALE_DAMAGE = 2))
			SLEEP_CHECK_DEATH(10 SECONDS)
		if(MELTDOWN_GOLD)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "The sandman calls me.", 1 SECONDS, "black", "yellow", "left", "CENTER,BOTTOM+2")
			var/check_count = 0
			while(charging) // In case meltdowns get cleared mid-ability
				if(check_count > 4)
					break
				SLEEP_CHECK_DEATH(1 SECONDS)
				check_count += 1
			charging = TRUE
			ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8))
			SLEEP_CHECK_DEATH(10 SECONDS)
			charging = FALSE
		if(MELTDOWN_PURPLE)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "The waves will rock the shore again.", 1 SECONDS, "black", "yellow", "left", "CENTER,BOTTOM+2")
		if(MELTDOWN_CYAN)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "Excellent.", 1 SECONDS, "black", "yellow", "left", "CENTER,BOTTOM+2")
			INVOKE_ASYNC(src, PROC_REF(StopPillarStorm))

	if(last_stage == life_stage)
		ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8))

// Pillar Storm
/mob/living/simple_animal/hostile/megafauna/arbiter/proc/StartPillarStorm()
	charging = TRUE
	icon_state = "arbiter_ability"
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))

	SLEEP_CHECK_DEATH(2 SECONDS)

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, pick("I'll open the door if I must.", "Let us sink here together."), 1 SECONDS, "black", "yellow", "left", "CENTER,BOTTOM+2")
	stop_storm_effect = FALSE
	INVOKE_ASYNC(src, PROC_REF(PillarStormEffect))

	SLEEP_CHECK_DEATH(1 SECONDS)

	playsound(get_turf(src), 'sound/magic/arbiter/storm_create.ogg', 50, TRUE, 24)

	for(var/direction in GLOB.alldirs)
		var/turf/T = get_step(src, direction)
		var/turf/TT = get_step(get_step(T, direction), direction)
		var/projectile_type = pick(typesof(/obj/projectile/magic/aoe/pillar))
		var/obj/projectile/P = new projectile_type(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = TT.y - T.y
		P.xo = TT.x - T.x
		P.original = TT
		P.preparePixelProjectile(TT, T)
		storm_pillars += P

	SLEEP_CHECK_DEATH(2 SECONDS)

	playsound(get_turf(src), 'sound/magic/arbiter/storm_start.ogg', 50, FALSE, 48)

	SLEEP_CHECK_DEATH(1 SECONDS)

	stormloop.start()

/mob/living/simple_animal/hostile/megafauna/arbiter/proc/PillarStormEffect()
	if(stop_storm_effect)
		return
	for(var/turf/T in orange(1, src))
		new /obj/effect/temp_visual/revenant(T)
	addtimer(CALLBACK(src, PROC_REF(PillarStormEffect)), 1 SECONDS)

/mob/living/simple_animal/hostile/megafauna/arbiter/proc/FirePillarStorm()
	stormloop.stop()
	stop_storm_effect = TRUE

	SLEEP_CHECK_DEATH(1 SECONDS)

	playsound(get_turf(src), 'sound/magic/arbiter/storm_charge.ogg', 50, FALSE, 32)

	SLEEP_CHECK_DEATH(2.5 SECONDS)

	for(var/obj/projectile/magic/aoe/pillar/P in storm_pillars)
		P.fire()
	storm_pillars = list()

	playsound(get_turf(src), 'sound/magic/arbiter/storm_fire.ogg', 100, FALSE, 48)

	pillar_storm_cooldown = world.time + pillar_storm_cooldown_time
	charging = FALSE
	icon_state = icon_living
	ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.1))

// Arbiter either died(somehow) or meltdown of pillars was cleared
/mob/living/simple_animal/hostile/megafauna/arbiter/proc/StopPillarStorm()
	stormloop.stop()
	stop_storm_effect = TRUE

	for(var/obj/O in storm_pillars)
		QDEL_NULL(O)
	storm_pillars = list()

	pillar_storm_cooldown = world.time + pillar_storm_cooldown_time
	charging = FALSE
	icon_state = icon_living

/mob/living/simple_animal/hostile/megafauna/arbiter/proc/SpawnSpikes()
	spikes_cooldown = world.time + spikes_cooldown_time
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.client)
			continue
		if(H.stat)
			continue
		if(H.z != z)
			continue
		if(H.is_working)
			continue
		var/turf/T = get_turf(H)
		new /obj/effect/arbiter_spike(T)
		for(var/turf/open/TT in view(2, T))
			if(prob(50))
				continue
			if(locate(/obj/effect/arbiter_spike) in TT)
				continue
			new /obj/effect/arbiter_spike(TT)

/* Objects & Effects */
// Spikes: Arbiter will spawn these from time to time around the agents, which after short delay will damage everything
// on its tile for 100 BLACK damage
/obj/effect/arbiter_spike
	name = "dark spikes"
	desc = "A weird construction. You should probably stay away from it..."
	icon_state = "binah_spike"
	alpha = 0
	anchored = TRUE
	density = FALSE
	/// How much time must pass after Initialize() to activate
	var/activation_delay = 2 SECONDS
	/// Amount of BLACK damage done on activation
	var/damage = 150

/obj/effect/arbiter_spike/Initialize()
	. = ..()
	animate(src, alpha = 100, time = (activation_delay * 0.2))
	addtimer(CALLBACK(src, PROC_REF(Activate)), activation_delay)

/obj/effect/arbiter_spike/proc/Activate()
	icon_state = icon_state + "_fire"
	animate(src, alpha = 255, time = 2)
	playsound(src, 'sound/magic/arbiter/pin.ogg', 75, TRUE)
	for(var/mob/living/L in get_turf(src))
		if(istype(L, /mob/living/simple_animal/hostile/megafauna/arbiter))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		L.visible_message("<span class='danger'>[L] has been hit by [name]!</span>",
						"<span class='userdanger'>You've been hit by [name]!</span>")
	sleep(6)
	animate(src, alpha = 0, time = 4)
	sleep(4)
	QDEL_NULL(src)
