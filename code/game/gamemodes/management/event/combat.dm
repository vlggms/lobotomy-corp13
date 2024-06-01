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

//Win cons
/datum/game_mode/combat/proc/loseround()
	SSticker.force_ending = 1
	to_chat(world, span_userdanger("Players have taken too long! Round automatically ending."))

/datum/game_mode/combat/proc/winround()
	SSticker.force_ending = 1
	to_chat(world, span_userdanger("Players have survived! Round automatically ending."))

/datum/game_mode/combat/proc/drawround()
	SSticker.force_ending = 1
	to_chat(world, span_userdanger("Players have taken too long! Round ending in a Draw."))

/datum/game_mode/combat/proc/endround()
	SSticker.force_ending = 1
	to_chat(world, span_userdanger("Shift has ended."))

/datum/game_mode/combat/proc/endroundRcorp(text)
	SSticker.force_ending = 1
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
	GLOB.combat_counter+=1
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
