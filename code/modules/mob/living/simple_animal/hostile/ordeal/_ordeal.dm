/mob/living/simple_animal/hostile/ordeal
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	a_intent = INTENT_HARM
	var/datum/ordeal/ordeal_reference
	var/ordeal_remove_ondeath = TRUE

	/// Suppression Bonuses
	var/suppression_attribute_bonus = JUSTICE_ATTRIBUTE // Default being raised being the damage attribute just kinda makes sense
	var/mob/living/carbon/human/contributers = list()
	var/exp_value = null
	var/max_stat

/mob/living/simple_animal/hostile/ordeal/death(gibbed)
	if(ordeal_reference && ordeal_remove_ondeath)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	var/mob/living/carbon/human/living_contributors = list()
	for (var/mob/living/carbon/human/suppressor in contributers)
		if (suppressor.stat != DEAD)
			living_contributors += suppressor
	if (LAZYLEN(living_contributors))
		var/bonus = exp_value / length(living_contributors)
		bonus = clamp(bonus, 1, 10)
		for (var/mob/living/carbon/human/suppressor in living_contributors)
			if(get_attribute_level(suppressor, suppression_attribute_bonus) < max_stat/2) // I believe if someone with less than 60 stats suppresses an Aleph they should be rewarded more for it.
				suppressor.adjust_attribute_level(suppression_attribute_bonus, clamp(bonus*1.5, 0, max_stat))
			else
				suppressor.adjust_attribute_level(suppression_attribute_bonus, clamp(bonus, 0, max_stat))
	..()

/mob/living/simple_animal/hostile/ordeal/Destroy()
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()
