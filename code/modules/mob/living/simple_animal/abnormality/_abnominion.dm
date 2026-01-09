/mob/living/simple_animal/hostile/abnominion
	name = "Abnormality Minion"
	desc = "An abnormality's minion..? You should report this to the Head!"
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = HARD_CRIT
	layer = LARGE_MOB_LAYER
	a_intent = INTENT_HARM
	del_on_death = TRUE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	move_resist = MOVE_FORCE_STRONG // They kept stealing my abnormalities
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	/// Does this minion count for the emergency system
	var/can_affect_emergency = TRUE
	/// The divider for score for the trumpet system, we don't want minion spam to count too much
	var/score_divider = 1
	/// The threat level of the abnormality. It is passed to the datum on spawn
	var/threat_level = ZAYIN_LEVEL
	/// Separate level of fear. If null - will use threat level.
	var/fear_level = null
	/// List of humans that witnessed the abnormality minion
	var/list/mob_affected = list()

/mob/living/simple_animal/hostile/abnominion/Initialize(mapload)
	. = ..()
	if(fear_level == null)
		fear_level = threat_level

/mob/living/simple_animal/hostile/abnominion/add_to_mob_list()
	. = ..()
	GLOB.abnormality_mob_list |= src//They should count

/mob/living/simple_animal/hostile/abnominion/remove_from_mob_list()
	. = ..()
	GLOB.abnormality_mob_list -= src

/mob/living/simple_animal/hostile/abnominion/Life()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(!.) // Dead
		return FALSE
	FearEffect()

// Applies fear damage to everyone in range
/mob/living/simple_animal/hostile/abnominion/proc/FearEffect()
	if(fear_level <= 0)
		return
	for(var/mob/living/carbon/human/H in ohearers(7, src))
		if(H in mob_affected)
			continue
		if(H.stat == DEAD)
			continue
		mob_affected += H
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			to_chat(H, span_notice("This again...?"))
			H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
			continue
		var/sanity_result = clamp(fear_level - get_user_level(H), -1, 5)
		var/sanity_damage = 0
		var/result_text = FearEffectText(H, sanity_result)
		switch(sanity_result)
			if(-INFINITY to 0)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
				to_chat(H, span_notice("[result_text]"))
				continue
			if(1)
				sanity_damage = H.maxSanity*0.1
				H.apply_status_effect(/datum/status_effect/panicked_lvl_1)
				to_chat(H, span_warning("[result_text]"))
			if(2)
				sanity_damage = H.maxSanity*0.3
				H.apply_status_effect(/datum/status_effect/panicked_lvl_2)
				to_chat(H, span_danger("[result_text]"))
			if(3)
				sanity_damage = H.maxSanity*0.6
				H.apply_status_effect(/datum/status_effect/panicked_lvl_3)
				to_chat(H, span_userdanger("[result_text]"))
			if(4)
				sanity_damage = H.maxSanity*0.95
				H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
				to_chat(H, span_userdanger("<b>[result_text]</b>"))
			if(5)
				sanity_damage = H.maxSanity
				H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
		H.adjustSanityLoss(sanity_damage)
		SEND_SIGNAL(H, COMSIG_FEAR_EFFECT, fear_level, sanity_damage)
	return

/mob/living/simple_animal/hostile/abnominion/proc/FearEffectText(mob/affected_mob, level = 0)
	level = num2text(clamp(level, -1, 5))
	var/list/result_text_list = list(
		"-1" = list("I've got this.", "How boring.", "Doesn't even phase me."),
		"0" = list("Just calm down, do what we always do.", "Just don't lose your head and stick to the manual.", "Focus..."),
		"1" = list("Hah, I'm getting nervous.", "Breathe in, breathe out...", "It'll be fine if we focus, I think..."),
		"2" = list("There's no room for error here.", "My legs are trembling...", "Damn, it's scary."),
		"3" = list("GODDAMN IT!!!!", "H-Help...", "I don't want to die!"),
		"4" = list("What am I seeing...?", "I-I can't take it...", "I can't understand..."),
		"5" = list("......"),
	)
	return pick(result_text_list[level])