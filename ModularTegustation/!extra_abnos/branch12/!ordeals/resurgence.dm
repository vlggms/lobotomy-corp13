/datum/ordeal/simplespawn/branch12/azure_dawn
	name = "Memory of Azure I"
	flavor_name = "The Scouts"
	announce_text = "They are trapped in a world of delusion... I shall break them free..."
	end_announce_text = "I have seen it all... They just need to accept it..."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/azure_start.ogg'
	end_sound = 'sound/effects/ordeals/azure_end.ogg'
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/clan/scout/branch12
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0.025
	color = "#015d5d"
	can_run = FALSE

/datum/ordeal/simplespawn/branch12/azure_dawn/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

/mob/living/simple_animal/hostile/clan/scout/branch12
	name = "Reinforced Scout"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	maxHealth = 1250
	health = 1250
	butcher_results = null
	guaranteed_butcher_results = null
	teleport_away = TRUE
	melee_damage_lower = 2
	melee_damage_upper = 3
	charge = 15

/datum/ordeal/specificcommanders/branch12/azure_noon
	name = "Memory of Azure II"
	flavor_name = "The Defenders"
	announce_text = "They belive they are protecting our people... Delusional..."
	end_announce_text = "I will show them true protection, by revealing the truth..."
	level = 2
	announce_sound = 'sound/effects/ordeals/azure_start.ogg'
	end_sound = 'sound/effects/ordeals/azure_end.ogg'
	reward_percent = 0.15
	potential_types = list(
		/mob/living/simple_animal/hostile/clan/defender/branch12,
		/mob/living/simple_animal/hostile/clan/defender/branch12,
		/mob/living/simple_animal/hostile/clan/defender/branch12,
		/mob/living/simple_animal/hostile/clan/defender/branch12
		)
	grunttype = list(/mob/living/simple_animal/hostile/clan/scout/branch12)
	color = "#015d5d"
	can_run = FALSE

/datum/ordeal/specificcommanders/branch12/azure_noon/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

/mob/living/simple_animal/hostile/clan/defender/branch12
	name = "Reinforced Defender"
	health = 2400
	maxHealth = 2400
	teleport_away = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	butcher_results = null
	guaranteed_butcher_results = null
	melee_damage_lower = 10
	melee_damage_upper = 12
	charge = 10

/datum/ordeal/specificcommanders/branch12/azure_noon/dusk
	name = "Memory of Azure III"
	flavor_name = "The Demolishers"
	announce_text = "I shall pillage these humans... Show them the ruin they caused us..."
	end_announce_text = "Even if I can't break the city... I can fix the people..."
	level = 3
	reward_percent = 0.20
	potential_types = list(
		/mob/living/simple_animal/hostile/clan/demolisher/branch12,
		/mob/living/simple_animal/hostile/clan/demolisher/branch12,
		/mob/living/simple_animal/hostile/clan/demolisher/branch12
		)
	grunttype = list(/mob/living/simple_animal/hostile/clan/drone/branch12)

/datum/ordeal/specificcommanders/branch12/azure_noon/dusk/spawngrunts(turf/T, list/grunttype, spawn_amount = 2)
	. = ..()

/mob/living/simple_animal/hostile/clan/demolisher/branch12
	name = "Reinforced Demolisher"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.4, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.6)
	butcher_results = null
	guaranteed_butcher_results = null
	health = 2000
	maxHealth = 2000
	charge = 5

/mob/living/simple_animal/hostile/clan/drone/branch12
	name = "Reinforced Drone"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	butcher_results = null
	guaranteed_butcher_results = null
	teleport_away = TRUE
