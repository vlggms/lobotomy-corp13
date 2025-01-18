GLOBAL_VAR_INIT(combat_counter, 0)
GLOBAL_VAR_INIT(wcorp_enemy_faction, "") //decides which faction WCorp will be up against, so all spawners stay consistent

//This should ONLY be used for events.
/datum/game_mode/combat
	name = "Combat Mode"
	config_tag = "combat_mode"
	report_type = "extended"
	false_report_weight = 5
	required_players = 0

	announce_span = "danger"
	announce_text = "Abnormalities are automatically breached."

/datum/game_mode/combat/post_setup()
	..()
	//No more OOC
	GLOB.ooc_allowed = FALSE
	if(!(SSmaptype.maptype in SSmaptype.citymaps))
		CONFIG_SET(flag/norespawn, 1)
	to_chat(world, "<B>Due to gamemode, Respawn and the OOC channel has been globally disabled.</B>")

	//Breach all
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.mob_list)
		INVOKE_ASYNC(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality, BreachEffect))

	//Non-abnos too need to see in the dark
	for(var/mob/living/simple_animal/hostile/A in GLOB.mob_list)
		var/obj/effect/proc_holder/spell/targeted/night_vision/bloodspell = new
		A.AddSpell(bloodspell)
		A.faction += "hostile"

	if(SSmaptype.maptype in SSmaptype.autoend)
		switch(SSmaptype.maptype)

			//R-Corp stuff.
			if("rcorp")
				switch(GLOB.rcorp_objective)
					if("payload_abno")
						addtimer(CALLBACK(src, PROC_REF(endroundRcorp), "Abnormalities have failed to escort the specimen to the destination."), 40 MINUTES)
						to_chat(world, span_userdanger("Round will end in an R-Corp victory after 40 minutes."))
						var/start_delay = 6 MINUTES
						addtimer(CALLBACK(src, PROC_REF(StartPayload)), start_delay)
						PayloadFindPath(start_delay)
					if("payload_rcorp")
						addtimer(CALLBACK(src, PROC_REF(endroundRcorp), "Rcorp has failed to destroy the mission objective."), 40 MINUTES)
						to_chat(world, span_userdanger("Round will end in an abnormality victory after 40 minutes."))
						var/start_delay = 3 MINUTES
						addtimer(CALLBACK(src, PROC_REF(StartPayload)), start_delay)
						PayloadFindPath(start_delay)
					else
						addtimer(CALLBACK(src, PROC_REF(drawround)), 40 MINUTES)
						to_chat(world, span_userdanger("Round will end in a draw after 40 minutes."))
				addtimer(CALLBACK(src, PROC_REF(rcorp_announce)), 3 MINUTES)
				addtimer(CALLBACK(src, PROC_REF(ClearIncorpBarriers)), 10 MINUTES)
				minor_announce("WARNING, The facility gates will open in T-15 Minutes." , "R-Corp Intelligence Office")
				addtimer(CALLBACK(src, PROC_REF(rcorp_opendoor)), 15 MINUTES)
				addtimer(CALLBACK(src, PROC_REF(facility_warning_1)), 5 MINUTES)
				addtimer(CALLBACK(src, PROC_REF(facility_warning_2)), 10 MINUTES)
				addtimer(CALLBACK(src, PROC_REF(facility_warning_3)), 14 MINUTES)
				RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(CheckLiving))

			//Limbus Labs
			if("limbus_labs")
				addtimer(CALLBACK(src, PROC_REF(roundendwarning)), 60 MINUTES)
				addtimer(CALLBACK(src, PROC_REF(endround)), 70 MINUTES)
				to_chat(world, span_userdanger("Shift will last 70 minutes."))

			//Fixers
			if("fixers")
				addtimer(CALLBACK(src, PROC_REF(roundendwarning)), 80 MINUTES)
				addtimer(CALLBACK(src, PROC_REF(endround)), 90 MINUTES)
				to_chat(world, span_userdanger("This week will last 90 minutes."))


			//W-Corp stuff
			if("wcorp")
				addtimer(CALLBACK(src, PROC_REF(winround)), 20 MINUTES)
				addtimer(CALLBACK(src, PROC_REF(counterincrease)), 3 MINUTES)
				to_chat(world, span_userdanger("Players will be victorius 20 minutes."))

				switch(rand(1,4))
					if(1)
						GLOB.wcorp_enemy_faction = "lovetown"
					if(2)
						GLOB.wcorp_enemy_faction = "gcorp"
					if(3)
						GLOB.wcorp_enemy_faction = "peccatulum"
					if(4)
						GLOB.wcorp_enemy_faction = "shrimp"

				RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(CheckLiving))

/// Automatically ends the shift if no humanoid players are alive
/datum/game_mode/combat/proc/CheckLiving()
	for(var/mob/living/carbon/human/hooman in GLOB.human_list)
		if(hooman.stat != DEAD && hooman.ckey && !istype(hooman, /mob/living/carbon/human/species/pinocchio))
			return

	if(SSticker.force_ending == TRUE) // they lost another way before we could do it, how rude.
		return

	SSticker.force_ending = TRUE
	if(SSmaptype.maptype == "wcorp")
		to_chat(world, span_userdanger("All W-Corp staff is dead! Round automatically ending."))
	else
		to_chat(world, span_userdanger("Every player has perished. Abnormalities have won."))

//Win cons
/datum/game_mode/combat/proc/loseround()
	SSticker.force_ending = TRUE
	to_chat(world, span_userdanger("Players have taken too long! Round automatically ending."))

/datum/game_mode/combat/proc/winround()
	SSticker.force_ending = TRUE
	to_chat(world, span_userdanger("Players have survived! Round automatically ending."))

/datum/game_mode/combat/proc/drawround()
	SSticker.force_ending = TRUE
	to_chat(world, span_userdanger("Players have taken too long! Round ending in a Draw."))

/datum/game_mode/combat/proc/endround()
	SSticker.force_ending = TRUE
	to_chat(world, span_userdanger("Shift has ended."))

/datum/game_mode/combat/proc/endroundRcorp(text)
	SSticker.force_ending = TRUE
	to_chat(world, span_userdanger(text))

/datum/game_mode/combat/proc/roundendwarning()
	switch (SSmaptype.maptype)
		if("limbus_labs")
			minor_announce("Reminder that 10 minutes are left in the shift. Please wrap up all research and file all paperwork. Overtime has not been authorized for this shift." , "Automatic Limbus Company Punchclock ")

		if("fixers")
			to_chat(world, span_userdanger("There are 10 minutes left in the week."))


//Gamemode stuff
/datum/game_mode/combat/proc/counterincrease()
	addtimer(CALLBACK(src, PROC_REF(counterincrease)), 1 MINUTES)
	GLOB.combat_counter++
	if(SSmaptype.maptype == "wcorp")
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			if(!H.ckey)
				continue
			H.adjustBruteLoss(-(H.maxHealth*0.10))
			H.adjustSanityLoss(-(H.maxSanity*0.10))

/datum/game_mode/combat/proc/rcorp_announce()
	var/announcement_type = ""
	switch (GLOB.rcorp_objective)
		if("button", "arbiter")
			announcement_type = "Intelligence has located a golden bough in the vicinity. You are to collect it and wipe all resistance."
		if("vip")
			announcement_type = "Intelligence has located a highly intelligent target in the vicinity. Destroy it at all costs."
		if("payload_rcorp")
			announcement_type = "Intelligence has located an entrance to a former L corp facility. Detonate the charge to bury it and prevent further specimens from escaping."
		if("payload_abno")
			announcement_type = "Intelligence has located a dangerous specimen moving towards your location. Prevent it from escaping at all costs."
	minor_announce("[announcement_type]" , "R-Corp Intelligence Office")
	minor_announce("WARNING, The facility gates will open in T-12 Minutes." , "R-Corp Intelligence Office")

/datum/game_mode/combat/proc/rcorp_opendoor()
	for(var/obj/machinery/button/door/indestructible/rcorp/M in GLOB.machines)
		qdel(M)
	minor_announce("Facility doors are locked open." , "R-Corp Intelligence Office")
	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if (M.id == "inside")
			addtimer(CALLBACK(src, PROC_REF(OpenDoor), M), 0 MINUTES)

/datum/game_mode/combat/proc/facility_warning_1()
	minor_announce("WARNING, The facility gates will open in T-10 Minutes." , "R-Corp Intelligence Office")

/datum/game_mode/combat/proc/facility_warning_2()
	minor_announce("WARNING, The facility gates will open in T-5 Minutes, Please start moving into the facility." , "R-Corp Intelligence Office")

/datum/game_mode/combat/proc/facility_warning_3()
	minor_announce("WARNING, The facility gates will open in T-1 Minute, Please be ready for enemies of a higher threat level." , "R-Corp Intelligence Office")

/datum/game_mode/combat/proc/OpenDoor(door)
	var/obj/machinery/door/poddoor/D = door
	D.open()


/datum/game_mode/combat/proc/StartPayload()
	if(!GLOB.rcorp_payload)
		CRASH("No payload somehow")
	var/mob/payload/P = GLOB.rcorp_payload
	P.ready_to_move = TRUE

/datum/game_mode/combat/proc/PayloadFindPath(delay)
	var/mob/payload/P = GLOB.rcorp_payload
	if(!P)
		CRASH("No payload somehow, possibly no landmark")
	P.start_delay = delay
	P.GetPath()


/datum/game_mode/combat/proc/ClearIncorpBarriers()
	for(var/obj/effect/landmark/nobasic_incorp_move/disappearing/L in GLOB.landmarks_list)
		qdel(L)
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		to_chat(A, "Incorporeal barrier is broken!")
