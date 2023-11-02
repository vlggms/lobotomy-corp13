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
//0 is neutral, 1 favors Rcorp and 2 favors abnos

/obj/effect/landmark/objectivespawn
	name = "rcorp objective spawner"
	desc = "It spawns the rcorp objective. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "city_of_cogs"

/obj/effect/landmark/objectivespawn/Initialize()
	switch(GLOB.rcorp_objective)
		if("button")
			new /obj/structure/bough(get_turf(src))
			addtimer(CALLBACK(src, .proc/reinforce), 25 MINUTES)
		if("vip")
			new /mob/living/simple_animal/hostile/shrimp_vip(get_turf(src))
		if("arbiter")
			new /obj/structure/bough(get_turf(src))
			addtimer(CALLBACK(src, .proc/arbspawn), 20 MINUTES)
	..()

/obj/effect/landmark/objectivespawn/proc/reinforce()
	minor_announce("R-Corp reinforcements are on the way. Hang on tight, commander." , "R-Corp Intelligence Office")
	CONFIG_SET(flag/norespawn, 0)
	GLOB.rcorp_wincondition = 1
	addtimer(CALLBACK(src, .proc/reinforce_end), 2 MINUTES)

/obj/effect/landmark/objectivespawn/proc/reinforce_end()
	CONFIG_SET(flag/norespawn, 1)

//Delay the fucker by 20 minutes. Someone waltzed into briefing one Rcorp round with this.
/obj/effect/landmark/objectivespawn/proc/arbspawn()
	new /obj/effect/mob_spawn/human/arbiter(get_turf(src))
	minor_announce("DANGER - HIGHLY DANGEROUS HOSTILE ARBITER IN THE AREA. NEUTRALIZE IMMEDIATELY." , "R-Corp Intelligence Office")
	GLOB.rcorp_wincondition = 2


//Golden Bough Objective
/obj/structure/bough
	name = "Golden Bough"
	desc = "You need this."
	icon_state = "realization"
	icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/cooldown
	var/list/bastards = list()

/obj/structure/bough/attack_hand(mob/living/carbon/human/user)
	if(cooldown > world.time)
		to_chat(user, "<span class='notice'>You're having a hard time grabbing this.</span>")
		return
	if(user.ckey in bastards)
		to_chat(user, "<span class='userdanger'>You already tried to grab this.</span>")
		return

	cooldown = world.time + 45 SECONDS // Spam prevention
	for(var/mob/M in GLOB.player_list)
		to_chat(M, "<span class='userdanger'>[uppertext(user.real_name)] is collecting the golden bough!</span>")

	RoundEndEffect(user)

/obj/structure/bough/proc/RoundEndEffect(mob/living/carbon/human/user)
	bastards += user.ckey
	if(do_after(user, 45 SECONDS))
		SSticker.SetRoundEndSound('sound/abnormalities/donttouch/end.ogg')
		SSticker.force_ending = 1
		for(var/mob/M in GLOB.player_list)
			to_chat(M, "<span class='userdanger'>[uppertext(user.real_name)] has collected the bough!</span>")

			switch(GLOB.rcorp_wincondition)
				if(0)
					to_chat(M, "<span class='userdanger'>R-CORP MAJOR VICTORY.</span>")
				if(1)
					to_chat(M, "<span class='userdanger'>R-CORP MINOR VICTORY.</span>")
				if(2)
					to_chat(M, "<span class='userdanger'>R-CORP SUPREME VICTORY.</span>")


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
	for(var/mob/M in GLOB.player_list)
		to_chat(M, "<span class='userdanger'>THE VIP HAS BEEN SLAIN.</span>")
		to_chat(M, "<span class='userdanger'>R-CORP MAJOR VICTORY.</span>")
	SSticker.force_ending = 1
	..()

//Arbiter
/obj/effect/mob_spawn/human/arbiter
	name = "The Arbiter"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	short_desc = "You are The Arbiter."
	important_info = "You are hostile to R-Corp. Assist abnormalities in killing them all."
	outfit = /datum/outfit/arbiter
	max_integrity = 9999999
	density = TRUE
	roundstart = FALSE
	death = FALSE


/obj/effect/mob_spawn/human/arbiter/special(mob/living/new_spawn)
	new_spawn.mind.add_antag_datum(/datum/antagonist/wizard/arbiter/rcorp)

/datum/antagonist/wizard/arbiter/rcorp
	spell_types = list(
		/obj/effect/proc_holder/spell/aimed/fairy,
		/obj/effect/proc_holder/spell/aimed/pillar,
		/obj/effect/proc_holder/spell/aimed/spell_cards,
		/obj/effect/proc_holder/spell/targeted/forcewall,
		/obj/effect/proc_holder/spell/aoe_turf/knock/arbiter
		)

//R Corp Comms
/obj/structure/rcorpcomms
	name = "rcorp outside communications"
	desc = "A machine R-Corp needs to communicate with the outside."
	icon = 'icons/obj/objects.dmi'
	icon_state = "hivebot_fab_on"
	density = 1
	anchored = 1

/obj/structure/rcorpcomms/deconstruct(disassembled = TRUE)
	for(var/mob/M in GLOB.player_list)
		to_chat(M, "<span class='userdanger'>RCORP'S COMMUNICATIONS HAVE BEEN DESTROYED.</span>")
		switch(GLOB.rcorp_wincondition)
			if(0)
				to_chat(M, "<span class='userdanger'>ABNORMALITY MAJOR VICTORY.</span>")
			if(1)
				to_chat(M, "<span class='userdanger'>ABNORMALITY SUPREME VICTORY.</span>")
			if(2)
				to_chat(M, "<span class='userdanger'>ABNORMALITY MINOR VICTORY.</span>")
	SSticker.force_ending = 1
	..()

