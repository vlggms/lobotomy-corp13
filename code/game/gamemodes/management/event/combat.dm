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
		INVOKE_ASYNC(A, /mob/living/simple_animal/hostile/abnormality.proc/BreachEffect)
		var/obj/effect/proc_holder/spell/targeted/night_vision/bloodspell = new
		A.AddSpell(bloodspell)
		A.faction += "hostile"
	if(SSmaptype.maptype in SSmaptype.autoend)
		switch(SSmaptype.maptype)
			if("rcorp")
				addtimer(CALLBACK(src, .proc/loseround), 30 MINUTES)
				to_chat(world, "<span class='userdanger'>Round will end in 30 minutes.</span>")
			if("limbus")
				addtimer(CALLBACK(src, .proc/loseround), 20 MINUTES)
				to_chat(world, "<span class='userdanger'>Players will lose in 20 minutes.</span>")
			if("wcorp")
				addtimer(CALLBACK(src, .proc/winround), 20 MINUTES)
				addtimer(CALLBACK(src, .proc/counterincrease), 3 MINUTES)
				to_chat(world, "<span class='userdanger'>Players will be victorius 20 minutes.</span>")

				switch(rand(1,2))
					if(1)
						GLOB.wcorp_enemy_faction = "lovetown"
					if(2)
						GLOB.wcorp_enemy_faction = "gcorp"

/datum/game_mode/combat/proc/loseround()
	SSticker.force_ending = 1
	to_chat(world, "<span class='userdanger'>Players have taken too long! Round automatically ending.</span>")

/datum/game_mode/combat/proc/winround()
	SSticker.force_ending = 1
	to_chat(world, "<span class='userdanger'>Players have survived! Round automatically ending.</span>")

/datum/game_mode/combat/proc/counterincrease()
	addtimer(CALLBACK(src, .proc/counterincrease), 1 MINUTES)
	GLOB.combat_counter+=1
