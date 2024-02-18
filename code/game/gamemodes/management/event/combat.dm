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
				addtimer(CALLBACK(src, PROC_REF(drawround)), 40 MINUTES)
				to_chat(world, span_userdanger("Round will end in a draw after 40 minutes.</span>"))
				addtimer(CALLBACK(src, PROC_REF(rcorp_announce)), 3 MINUTES)

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
	minor_announce("[announcement_type]" , "R-Corp Intelligence Office")


