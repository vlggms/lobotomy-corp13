/datum/ordeal/boss/branch12/flame_fixer
	name = "Memory of a Dauntless Inferno"
	flavor_name = "Sanguine Flame"
	announce_text = "Breathe in, breathe out. Everyone's watching you."
	end_announce_text = "As the embers fade... The director finishes their final act."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 2
	reward_percent = 0.15
	color = "#d96201"
	can_run = FALSE
	bosstype = /mob/living/simple_animal/hostile/humanoid/fixer/flame/ordeal

/datum/ordeal/boss/branch12/flame_fixer/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

/mob/living/simple_animal/hostile/humanoid/fixer/flame/ordeal
	maxHealth = 4000
	health = 4000
	melee_damage_lower = 10
	melee_damage_upper = 12
	burn_stacks = 1


/datum/ordeal/boss/branch12/metal_fixer
	name = "Memory of a Wandering Soul"
	flavor_name = "Memory Forger"
	announce_text = "Lost within this open world, they shall forge a new memory..."
	end_announce_text = "As one memory crumbles... May a new one be forged..."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 2
	reward_percent = 0.15
	color = "#5a5a5a"
	can_run = FALSE
	bosstype = /mob/living/simple_animal/hostile/humanoid/fixer/metal/ordeal

/datum/ordeal/boss/branch12/metal_fixer/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

/mob/living/simple_animal/hostile/humanoid/fixer/metal/ordeal
	maxHealth = 5000
	health = 5000
	melee_damage_lower = 6
	melee_damage_upper = 8
	self_damage_statue = 750


/datum/ordeal/boss/branch12/duo_fixers
	name = "Memory of the Dyad Igneous"
	flavor_name = "Memory Forger and Sanguine Flame"
	announce_text = "Two allies, seeking for connection within this forsaken world..."
	end_announce_text = "Clutching at their last hope, will they find companionship?"
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 3
	reward_percent = 0.2
	color = "#8f5635"
	can_run = FALSE
	bossspawnloc = /area/department_main/command
	bosstype = /mob/living/simple_animal/hostile/humanoid/fixer/metal/ordeal/duo

/datum/ordeal/boss/branch12/duo_fixers/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

/datum/ordeal/boss/branch12/duo_fixers/Run()
	..()
	var/turf/T
	if(bossspawnloc)
		for(var/turf/D in GLOB.department_centers)
			if(istype(get_area(D), bossspawnloc))
				T = D
				break
		if(!T)
			var/X = pick(GLOB.department_centers)
			T = get_turf(X)
			log_game("Failed to spawn [src] in [bossspawnloc]")
	else
		var/X = pick(GLOB.department_centers)
		T = get_turf(X)
	var/mob/living/simple_animal/hostile/humanoid/fixer/flame/ordeal/duo/F = new /mob/living/simple_animal/hostile/humanoid/fixer/flame/ordeal/duo(T)
	ordeal_mobs += F
	F.ordeal_reference = src

/mob/living/simple_animal/hostile/humanoid/fixer/metal/ordeal/duo
	return_to_origin = TRUE

/mob/living/simple_animal/hostile/humanoid/fixer/flame/ordeal/duo
	return_to_origin = TRUE
