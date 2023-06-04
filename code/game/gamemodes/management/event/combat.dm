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
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.mob_list)
		INVOKE_ASYNC(A, /mob/living/simple_animal/hostile/abnormality.proc/BreachEffect)
		var/obj/effect/proc_holder/spell/targeted/night_vision/bloodspell = new
		A.AddSpell(bloodspell)
	qdel(src)

