GLOBAL_VAR_INIT(rcorp_objective, "button") //what objective Rcorp has

/*This is the setup for the win system
R-Corp Supreme Victory - Win against Arbiter
R-Corp Major - Win without reinforcements
R-Corp Minor - Win with reinforcements
Draw - 40 minutes pass.
Abnormality Minor - Win with arbiter
Abnormality Major - Win without arbiter
Abnormality Supreme Victory - Win against reinforcements
*/

GLOBAL_VAR_INIT(rcorp_wincondition, 0) //what state the game is in.
GLOBAL_VAR_INIT(rcorp_objective_location, null)
GLOBAL_VAR_INIT(rcorp_abno_objective_location, null)
GLOBAL_VAR_INIT(rcorp_payload, null)
//0 is neutral, 1 favors Rcorp and 2 favors abnos

/obj/effect/landmark/objectivespawn
	name = "rcorp objective spawner"
	desc = "It spawns the rcorp objective. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "city_of_cogs"

/obj/effect/landmark/objectivespawn/Initialize()
	GLOB.rcorp_objective_location = src
	switch(GLOB.rcorp_objective)
		if("button")
			new /obj/structure/bough(get_turf(src))
			addtimer(CALLBACK(src, PROC_REF(reinforce)), 25 MINUTES)
		if("vip")
			new /mob/living/simple_animal/hostile/shrimp_vip(get_turf(src))
		if("arbiter")
			new /obj/structure/bough(get_turf(src))
			addtimer(CALLBACK(src, PROC_REF(arbspawn)), 20 MINUTES)
		if("payload_abno")
			new /mob/payload(get_turf(src), "abno")
		if("payload_rcorp")
			new /obj/effect/payload_destination(get_turf(src))
	return ..()

/obj/effect/landmark/objectivespawn/proc/reinforce()
	minor_announce("R-Corp reinforcements are on the way. Hang on tight, commander." , "R-Corp Intelligence Office")
	CONFIG_SET(flag/norespawn, 0)
	GLOB.rcorp_wincondition = 1
	addtimer(CALLBACK(src, PROC_REF(reinforce_end)), 2 MINUTES)

/obj/effect/landmark/objectivespawn/proc/reinforce_end()
	CONFIG_SET(flag/norespawn, 1)

//Delay the fucker by 20 minutes. Someone waltzed into briefing one Rcorp round with this.
/obj/effect/landmark/objectivespawn/proc/arbspawn()
	new /obj/effect/mob_spawn/human/arbiter/rcorp(get_turf(src))
	minor_announce("DANGER - HOSTILE ARBITER IN THE AREA. NEUTRALIZE IMMEDIATELY." , "R-Corp Intelligence Office")
	GLOB.rcorp_wincondition = 2

/obj/effect/landmark/abno_objectivespawn
	name = "abno objective spawner"
	desc = "It spawns the abnormality objective. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "city_of_cogs"

/obj/effect/landmark/abno_objectivespawn/Initialize()
	GLOB.rcorp_abno_objective_location = src
	switch(GLOB.rcorp_objective)
		if("payload_rcorp")
			new /mob/payload(get_turf(src), "rcorp")
		if("payload_abno")
			new /obj/effect/payload_destination(get_turf(src))
	return ..()

/obj/effect/payload_destination
	name = "payload destination"
	desc = "Payload really wants to be here"
	icon = 'icons/effects/effects.dmi'
	icon_state = "launchpad_pull"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

//Golden Bough Objective
/obj/structure/bough
	name = "Golden Bough"
	desc = "You need this."
	icon_state = "bough_pedestal"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	light_color = COLOR_YELLOW
	light_range = 2
	light_power = 2
	light_on = TRUE

	//Collecting vars
	var/cooldown
	var/list/bastards = list() //ckeys that have already tried to grab the bough

	//Visual vars
	var/obj/effect/golden_bough/bough //The bough effect that is spawned above the pedestal
	var/f1 //Filter 1, Ripple filter
	var/f2 //Filter 2, Rays filter

/obj/structure/bough/Initialize()
	..()
	bough = new/obj/effect/golden_bough(src)

	//Filter 1 gets applied to the bough
	bough.filters += filter(type="ripple", x = 0, y = 11, size = 20, repeat = 6, radius = 0, falloff = 1)
	f1 = bough.filters[bough.filters.len]

	//Filter 2 gets applied to the pedestal
	filters += filter(type="rays", x = 0, y = 11, size = 20, color = COLOR_VERY_SOFT_YELLOW, offset = 0.2, density = 10, factor = 0.4, threshold = 0.5)
	f2 = filters[filters.len]
	vis_contents += bough

	FilterLoop(1) //Starts the filter's loop

/obj/structure/bough/Destroy()
	qdel(bough)
	..()

/obj/structure/bough/proc/FilterLoop(loop_stage) //Takes a numeric argument for advancing the loop's stage in a cycle (1 > 2 > 3 > 1 > ...)
	if(filters[filters.len]) // Stops the loop if we have no filters to animate
		switch(loop_stage)
			if(1)
				animate(f1, radius = 60, time = 60, flags = CIRCULAR_EASING | EASE_OUT | ANIMATION_PARALLEL)
				animate(f2, size = 30, offset = pick(4,5,6), time = 60, flags = SINE_EASING | EASE_OUT | ANIMATION_PARALLEL)
				addtimer(CALLBACK(src, PROC_REF(FilterLoop), 2), 6 SECONDS)
			if(2)
				animate(f1, size = 25, radius = 80, time = 20, flags = CIRCULAR_EASING | EASE_OUT | ANIMATION_PARALLEL)
				animate(f2, size = 20, offset = pick(0.2,0.4), time = 60, flags = SINE_EASING | EASE_OUT | ANIMATION_END_NOW | ANIMATION_PARALLEL)
				addtimer(CALLBACK(src, PROC_REF(FilterLoop), 3), 2 SECONDS)
			if(3)
				animate(f1, size = 20, radius = 0, time = 0, flags = CIRCULAR_EASING | EASE_IN | EASE_OUT | ANIMATION_PARALLEL)
				addtimer(CALLBACK(src, PROC_REF(FilterLoop), 1), 4 SECONDS)
		update_icon()

/obj/structure/bough/attack_hand(mob/living/carbon/human/user)
	if(cooldown > world.time)
		to_chat(user, span_notice("You're having a hard time grabbing this."))
		return
	if(user.ckey in bastards)
		to_chat(user, span_userdanger("You already tried to grab this."))
		return

	cooldown = world.time + 45 SECONDS // Spam prevention
	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("[uppertext(user.real_name)] is collecting the golden bough!"))

	RoundEndEffect(user)

/obj/structure/bough/proc/RoundEndEffect(mob/living/carbon/human/user)
	bastards += user.ckey
	if(do_after(user, 45 SECONDS))
		//Visual Stuff
		clear_filters()
		bough.clear_filters()
		vis_contents.Cut()
		qdel(bough)
		light_on = FALSE
		update_light()

		if(!SSticker.force_ending)
			//Round End Effects
			SSticker.SetRoundEndSound('sound/abnormalities/donttouch/end.ogg')
			SSticker.force_ending = 1
			for(var/mob/M in GLOB.player_list)
				to_chat(M, span_userdanger("[uppertext(user.real_name)] has collected the bough!"))

				switch(GLOB.rcorp_wincondition)
					if(0)
						to_chat(M, span_userdanger("R-CORP MAJOR VICTORY."))
					if(1)
						to_chat(M, span_userdanger("R-CORP MINOR VICTORY."))
					if(2)
						to_chat(M, span_userdanger("R-CORP SUPREME VICTORY."))
		else
			var/turf/turf = get_turf(src)
			new /obj/effect/decal/cleanable/confetti(turf)
			playsound(turf, 'sound/misc/sadtrombone.ogg', 100)

	else
		user.gib() //lol, idiot.

//VIP objective
/mob/living/simple_animal/hostile/shrimp_vip
	name = "Shrimp VIP"
	desc = "A shrimp in a snazzy suit. Protect at all costs."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "executive"
	icon_living = "executive"
	health = 300	//Fragile so they protect you
	maxHealth = 300


/mob/living/simple_animal/hostile/shrimp_vip/death(gibbed)
	if(!SSticker.force_ending)
		for(var/mob/M in GLOB.player_list)
			to_chat(M, span_userdanger("THE VIP HAS BEEN SLAIN."))
			to_chat(M, span_userdanger("R-CORP MAJOR VICTORY."))
		SSticker.force_ending = 1
	else
		var/turf/turf = get_turf(src)
		new /obj/effect/decal/cleanable/confetti(turf)
		playsound(turf, 'sound/misc/sadtrombone.ogg', 100)
	return ..()

//Arbiter
/obj/effect/mob_spawn/human/arbiter/rcorp
	important_info = "You are hostile to R-Corp. Assist abnormalities in killing them all."


/obj/effect/mob_spawn/human/arbiter/rcorp/special(mob/living/new_spawn)
	new_spawn.mind.add_antag_datum(/datum/antagonist/wizard/arbiter/rcorp)

/datum/antagonist/wizard/arbiter/rcorp
	name = "Arbiter (rcorp)"
	spell_types = list(
		/obj/effect/proc_holder/spell/aimed/fairy,
		/obj/effect/proc_holder/spell/aimed/pillar,
		/obj/effect/proc_holder/spell/aimed/spell_cards,
		/obj/effect/proc_holder/spell/targeted/forcewall,
		/obj/effect/proc_holder/spell/aoe_turf/knock/arbiter,
	)

//R Corp Comms
/obj/structure/rcorpcomms
	name = "rcorp outside communications"
	desc = "A machine R-Corp needs to communicate with the outside."
	icon = 'icons/obj/objects.dmi'
	icon_state = "hivebot_fab_on"
	density = 1
	anchored = 1
	resistance_flags = INDESTRUCTIBLE

/obj/structure/rcorpcomms/Initialize()
	. = ..()
	switch(GLOB.rcorp_objective)
		if("payload_rcorp", "payload_abno")
			return
		else
			addtimer(CALLBACK(src, PROC_REF(vulnerable)), 15 MINUTES)

/obj/structure/rcorpcomms/proc/vulnerable()
	minor_announce("Warning: The communications shields are now disabled. Communications are now vulnerable" , "R-Corporation Command Update")
	icon_state = "hivebot_fab"
	resistance_flags &= ~INDESTRUCTIBLE

/obj/structure/rcorpcomms/deconstruct(disassembled = TRUE)
	if(!SSticker.force_ending)
		for(var/mob/M in GLOB.player_list)
			to_chat(M, span_userdanger("RCORP'S COMMUNICATIONS HAVE BEEN DESTROYED."))
			switch(GLOB.rcorp_wincondition)
				if(0)
					to_chat(M, span_userdanger("ABNORMALITY MAJOR VICTORY."))
				if(1)
					to_chat(M, span_userdanger("ABNORMALITY SUPREME VICTORY."))
				if(2)
					to_chat(M, span_userdanger("ABNORMALITY MINOR VICTORY."))
		SSticker.force_ending = 1
	else
		var/turf/turf = get_turf(src)
		new /obj/effect/decal/cleanable/confetti(turf)
		playsound(turf, 'sound/misc/sadtrombone.ogg', 100)
	return ..()
