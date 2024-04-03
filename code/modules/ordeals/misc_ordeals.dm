// A Party Everlasting
/datum/ordeal/boss/pink_midnight
	name = "The Midnight of Pink"
	flavor_name = "A Party Everlasting"
	announce_text = "Let's have one big jambouree, a party everlasting."
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


// Random Fixer
/datum/ordeal/boss/jasper_noon
	name = "The Noon Of Jasper"
	flavor_name = "Echoes of Above"
	announce_text = "Everyone is heading somewhere, but no one knows where, and no one can decide where to go."
	level = 2
	reward_percent = 0.15
	//Temporary
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	color = "#D73B3E"
	bosstype = /mob/living/simple_animal/hostile/humanoid/fixer/metal

	var/list/bosslist = list(
		/mob/living/simple_animal/hostile/humanoid/fixer/metal,
		/mob/living/simple_animal/hostile/humanoid/fixer/flame,
		)

/datum/ordeal/boss/jasper_noon/Run()
	bosstype = pick(bosslist)
	..()

