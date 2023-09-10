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
	to_chat(world, "<span class='userdanger'>Round will end in 40 minutes.</span>")

	//Breach all
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.mob_list)
		INVOKE_ASYNC(A, /mob/living/simple_animal/hostile/abnormality.proc/BreachEffect)
		var/obj/effect/proc_holder/spell/targeted/night_vision/bloodspell = new
		A.AddSpell(bloodspell)
		A.faction += "hostile"
	if(SSmaptype.maptype in SSmaptype.autoend)
		addtimer(CALLBACK(src, .proc/loseround), 40 MINUTES)

/datum/game_mode/combat/proc/loseround()
	SSticker.force_ending = 1
	to_chat(world, "<span class='userdanger'>Players have taken too long! Round automatically ending.</span>")
