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
	health = 1000	//Fragile so they protect you
	maxHealth = 1000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	var/max_protection = 0.9
	var/base_resistance = 1
	var/guarding_allies = 0
	var/final_resistance = 1
	var/total_ally_protection = 0
	var/per_ally_protection = 0.25
	var/view_check_time = 1 SECONDS
	var/view_check
	var/barrier_count
	var/max_barrier_count = 6
	var/sniper
	var/warning
	var/danger = FALSE
	var/sniper_time = 0.5
	var/warning_time = 0.25
	var/sniper_safe = 1

	var/list/shrimp_abilities = list(
		/obj/effect/proc_holder/spell/pointed/shrimp_airstrike,
		/obj/effect/proc_holder/spell/pointed/shrimp_barricade,
		/obj/effect/proc_holder/spell/pointed/shrimp_heal,
		)

/mob/living/simple_animal/hostile/shrimp_vip/Initialize()
	. = ..()

	for (var/A in shrimp_abilities)
		if (ispath(A, /obj/effect/proc_holder/spell))
			var/obj/effect/proc_holder/spell/AS = new A(src)
			AddSpell(AS)

/mob/living/simple_animal/hostile/shrimp_vip/Login()
	. = ..()
	to_chat(src, "<h1>You are Shimp VIP, A Objective Role Abnormality.</h1><br>\
		<b>|Supportive Barrier|: For each ally you are able to see, you take 25% less damage. For a max of 90% less damage from all attacks.<br>\
		<br>\
		|Sniper Target|: There is an R-Corp Sniper who is aiming at you. As long as you are able to see 2 allies, they will not be able to fire at you.<br>\
		<br>\
		|Airstrike Call|: After you click on your 'Airstrike' ability, The next turf you click on will call in a Airstrike on that location.<br>\
		There is a 3 second delay before a missile hits the ground, and they deal 200 RED damage in a 5x5 AoE when they land. In total you will fire 5 missiles.<br>\
		<br>\
		|Barricade Call|: After you click on your 'Barricade' ability, The next turf you click on will call in a Barricade to that location.<br>\
		You are able to have 6 barricades up at once, but you can still send down the pod to block damage.<br>\
		<br>\
		|Healing Call|: After you click on your 'Healing' ability, The next target you click on will have a HP bullet fired at them.<br>\
		Your HP bullets are not able to target yourself, and you are able to miss them if you don't click on an ally.</b>")

/mob/living/simple_animal/hostile/shrimp_vip/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((view_check < world.time) && !(status_flags & GODMODE) && (client))
		Protection()

/mob/living/simple_animal/hostile/shrimp_vip/proc/Protection()
	view_check = world.time + view_check_time
	var/temp_guarding_allies = 0
	for(var/mob/living/simple_animal/hostile/A in livinginview(7, src))
		if(src != A && faction_check_mob(A, FALSE))
			temp_guarding_allies += 1
	if (temp_guarding_allies != guarding_allies)
		guarding_allies = temp_guarding_allies
		total_ally_protection = guarding_allies * per_ally_protection
		if (total_ally_protection > max_protection)
			total_ally_protection = max_protection
		final_resistance = base_resistance - total_ally_protection
		ChangeResistances(list(RED_DAMAGE = final_resistance, WHITE_DAMAGE = final_resistance, BLACK_DAMAGE = final_resistance, PALE_DAMAGE = final_resistance))
	if (guarding_allies <= sniper_safe)
		if (!sniper)
			sniper = addtimer(CALLBACK(src, PROC_REF(SniperShoot)), sniper_time MINUTES, TIMER_STOPPABLE)
		if (!warning)
			warning = addtimer(CALLBACK(src, PROC_REF(SniperWarning)), warning_time MINUTES, TIMER_STOPPABLE)
	if (guarding_allies >= (sniper_safe + 1))
		if (sniper)
			deltimer(sniper)
			sniper = null
		if (warning)
			deltimer(warning)
			warning = null
			if (danger == TRUE)
				to_chat(src, span_nicegreen("You start to feel safer... Looks like that sniper can't get a good shot on you."))
				danger = FALSE

/mob/living/simple_animal/hostile/shrimp_vip/proc/SniperShoot()
	to_chat(src, span_userdanger("You are hit by a sniper bullet from an unknown sniper..."))
	deal_damage(300, RED_DAMAGE)
	playsound_local(src, 'sound/weapons/gun/sniper/shot.ogg', 75)
	sniper = null

/mob/living/simple_animal/hostile/shrimp_vip/proc/SniperWarning()
	to_chat(src, span_userdanger("You feel a shiver down your spine... Someone is aiming towards you, Get back to your allies to be safer!"))
	playsound_local(src, 'sound/weapons/gun/sniper/rack.ogg', 75)
	danger = TRUE
	warning = null

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

/obj/effect/proc_holder/spell/pointed/shrimp_airstrike
	name = "Airstrike Call"
	desc = "Call in your off field support to send in a airstrike on your foes!"
	panel = "Shrimp"
	has_action = TRUE
	action_icon = 'icons/mob/actions/actions_shrimp.dmi'
	action_icon_state = "airstrike"
	clothes_req = FALSE
	charge_max = 600
	selection_type = "range"
	active_msg = "You prepare your airstrike call..."
	deactive_msg = "You put away your airstrike call..."

/obj/structure/closet/supplypod/shrimpmissle
	style = STYLE_RED_MISSILE
	effectMissile = TRUE
	explosionSize = list(0,0,0,0)

/obj/effect/proc_holder/spell/pointed/shrimp_airstrike/cast(list/targets, mob/user)
	var/target = targets[1]
	user.visible_message(span_danger("[user] called an airstrike."), span_alert("You targeted [target]"))
	addtimer(CALLBACK(src, PROC_REF(Airstrike), target), 1)

/obj/effect/proc_holder/spell/pointed/shrimp_airstrike/proc/Airstrike(target)
	var/turf/T = get_turf(target)
	for (var/i in 1 to 5)
		var/obj/structure/closet/supplypod/shrimpmissle/pod = new()
		var/landingzone = locate(T.x + rand(-1,1), T.y + rand(-1,1), T.z)
		if (landingzone)
			new /obj/effect/pod_landingzone(landingzone, pod)
		else
			new /obj/effect/pod_landingzone(T, pod)
		var/mob/dummy = new(landingzone)
		dummy.faction = list("hostile")
		dummy.visible_message("<span class='danger'>A MISSILE IS FALLING NEAR YOUR LOCATION!</span>")
		sleep(34)
		for(var/turf/AT in range(2, landingzone))
			new /obj/effect/temp_visual/smash_effect(AT)
			dummy.HurtInTurf(AT, list(), (200), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
		playsound(dummy, 'sound/effects/explosion2.ogg', 50, TRUE)
		qdel(dummy)
		sleep(rand()*2)

/obj/effect/proc_holder/spell/pointed/shrimp_barricade
	name = "Barricade Call"
	desc = "Call in your off field support to send in a barricade!"
	panel = "Shrimp"
	has_action = TRUE
	action_icon = 'icons/mob/actions/actions_shrimp.dmi'
	action_icon_state = "barricade"
	clothes_req = FALSE
	charge_max = 100
	selection_type = "range"
	active_msg = "You prepare your barricade call ..."
	deactive_msg = "You put away your barricade call ..."

/obj/effect/proc_holder/spell/pointed/shrimp_barricade/cast(list/targets, mob/user)
	var/target = targets[1]
	if (istype(target, /obj/structure/barricade/security))
		to_chat(user, span_warning("There is a barricade there already!"))
		return
	else
		user.visible_message(span_danger("[user] calls in a barricade."), span_alert("You targeted [target]"))
		addtimer(CALLBACK(src, PROC_REF(Airstrike), target, user), 1)

/obj/effect/proc_holder/spell/pointed/shrimp_barricade/proc/Airstrike(target, user)
	if(istype(user, /mob/living/simple_animal/hostile/shrimp_vip))
		var/mob/living/simple_animal/hostile/shrimp_vip/shrimp = user
		var/turf/T = get_turf(target)
		var/obj/structure/closet/supplypod/extractionpod/pod = new()
		pod.explosionSize = list(0,0,0,0)
		if (shrimp.barrier_count < shrimp.max_barrier_count)
			var/obj/structure/barricade/security/shrimp/barrier = new /obj/structure/barricade/security/shrimp(pod)
			barrier.shrimp = shrimp
			shrimp.barrier_count += 1
		else
			to_chat(shrimp, "You have created too many barriers, Break some!")
		new /obj/effect/pod_landingzone(T, pod)
		stoplag(2)

/obj/structure/barricade/security/shrimp
	var/mob/living/simple_animal/hostile/shrimp_vip/shrimp

/obj/structure/barricade/security/shrimp/Destroy()
	shrimp.barrier_count -= 1
	. = ..()

/obj/effect/proc_holder/spell/pointed/shrimp_heal
	name = "Shrimp Reinforce"
	desc = "Reinforce one of your allies by having your off field support shot them with a HP bullet!"
	panel = "Shrimp"
	has_action = TRUE
	action_icon = 'icons/hud/screen_skills.dmi'
	action_icon_state = "healing"
	clothes_req = FALSE
	charge_max = 100
	selection_type = "range"
	active_msg = "You prepare your heal call ..."
	deactive_msg = "You put away your heal call ..."
	var/healamount = 50

/obj/effect/proc_holder/spell/pointed/shrimp_heal/cast(list/targets, mob/user)
	var/target = targets[1]
	if (istype(target, /mob/living/simple_animal/hostile/shrimp_vip))
		to_chat(user, span_warning("You can't target yourself!"))
		return
	else
		if (istype(target, /mob/living/simple_animal))
			var/mob/living/simple_animal/S = target
			S.adjustBruteLoss(-healamount)
			user.visible_message(span_danger("[user] calls in a HP bullet on [target]."), span_alert("You targeted [target]"))
			playsound(get_turf(S), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
			new /obj/effect/temp_visual/heal(get_turf(S), "#FF4444")
		else
			to_chat(user, span_warning("You can't target a non-simple animal!"))

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
