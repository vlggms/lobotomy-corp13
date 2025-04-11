// A Party Everlasting
/datum/ordeal/boss/pink_midnight
	name = "The Midnight of Pink"
	flavor_name = "A Party Everlasting"
	announce_text = "Let's have one big jambouree, a party everlasting."
	end_announce_text = "And thus now, we party. Wonderous and everlasting."
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/pink_start.ogg'
	end_sound = 'sound/effects/ordeals/pink_end.ogg'
	color = COLOR_PINK
	bosstype = /mob/living/simple_animal/hostile/ordeal/pink_midnight

/datum/ordeal/boss/pink_midnight/Run()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(MobDeathWrapper))
	addtimer(CALLBACK(src, PROC_REF(OnMobDeath)), 2.5 MINUTES, TIMER_LOOP) // Some abnos qdel, if the last one does then this is the failsafe.

/datum/ordeal/boss/pink_midnight/End()
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

/datum/ordeal/boss/pink_midnight/proc/MobDeathWrapper(datum/source, mob/living/deadMob)
	OnMobDeath(deadMob)

/datum/ordeal/simplespawn/azure_dawn
	name = "The Dawn of the Azure"
	flavor_name = "The Scouts"
	announce_text = "They are trapped in a world of delusion... I shall break them free..."
	end_announce_text = "Even as you tear us down... You can't break my will..."
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

/datum/ordeal/simplespawn/azure_dawn/AbleToRun()
	if(SSmaptype.maptype == "branch12") //runs dec 1-31st
		can_run = TRUE
	return can_run

/mob/living/simple_animal/hostile/clan/scout/branch12
	maxHealth = 1250
	health = 1250
	melee_damage_lower = 2
	melee_damage_upper = 3
	charge = 15

/datum/ordeal/specificcommanders/azure_noon
	name = "The Noon of the Azure"
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
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0.025
	color = "#015d5d"
	can_run = FALSE

/datum/ordeal/specificcommanders/azure_noon/AbleToRun()
	if(SSmaptype.maptype == "branch12") //runs dec 1-31st
		can_run = TRUE
	return can_run

/mob/living/simple_animal/hostile/clan/defender/branch12
	health = 2400
	maxHealth = 2400
	melee_damage_lower = 10
	melee_damage_upper = 12
	charge = 10
