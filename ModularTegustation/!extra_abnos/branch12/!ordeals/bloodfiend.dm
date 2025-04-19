// Noon
/datum/ordeal/simplespawn/branch12/bloodfiend_noon
	name = "Memory of Blood-Soaked Beasts I"
	flavor_name = "Lost Souls"
	announce_text = "They will fight to the last breath for what they wish for."
	end_announce_text = "And they will die to fulfill their purpose."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	level = 1
	reward_percent = 0.10
	spawn_places = 6
	spawn_amount = 4
	spawn_type = list(
		/mob/living/simple_animal/hostile/humanoid/blood/bag,
		)
	color = "#7d0e26"
	can_run = FALSE
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0


/datum/ordeal/simplespawn/branch12/bloodfiend_noon/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

//Dusk
/datum/ordeal/simplecommander/branch12/bloodfiend_dusk
	name = "Memory of Blood-Soaked Beasts II"
	flavor_name = "Souls of the Night"
	announce_text = "They will fight to the last breath for what they wish for."
	end_announce_text = "And they will die to fulfill their purpose."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	boss_type = list(/mob/living/simple_animal/hostile/humanoid/blood/fiend)
	grunt_type = list(/mob/living/simple_animal/hostile/humanoid/blood/bag)
	color = "#7d0e26"
	can_run = FALSE
	level = 2
	reward_percent = 0.15
	boss_amount = 3
	grunt_amount = 6
	boss_player_multiplicator = 0.03
	grunt_player_multiplicator = 0.05

/datum/ordeal/simplecommander/branch12/bloodfiend_dusk/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

//Midnight
/datum/ordeal/simplecommander/branch12/bloodfiend_midnight
	name = "Memory of Blood-Soaked Beasts III"
	flavor_name = "Lords of the Night"
	announce_text = "They will fight to the last breath for what they wish for."
	end_announce_text = "And they will die to fulfill their purpose."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	boss_type = list(/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss/branch12)
	grunt_type = list(/mob/living/simple_animal/hostile/humanoid/blood/bag,
		/mob/living/simple_animal/hostile/humanoid/blood/fiend)
	color = "#7d0e26"
	can_run = FALSE
	level = 3
	reward_percent = 0.20
	boss_amount = 2
	grunt_amount = 6
	boss_player_multiplicator = 0.03
	grunt_player_multiplicator = 0.05

/datum/ordeal/simplecommander/branch12/bloodfiend_midnight/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss/branch12
	name = "abandoned royal bloodfiend"
	maxHealth = 3000
	health = 3000
	melee_damage_lower = 10
	melee_damage_upper = 12

/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss/branch12/AdjustBloodFeast(amount)
	. = ..()
	if (slashing)
		return

	if (blood_feast > max_blood_feast * 0.5)
		icon_state = hardblood_state
		melee_damage_lower = 20
		melee_damage_upper = 24
		melee_damage_type = BLACK_DAMAGE
	else
		icon_state = normal_state
		melee_damage_lower = 10
		melee_damage_upper = 12
		melee_damage_type = RED_DAMAGE
