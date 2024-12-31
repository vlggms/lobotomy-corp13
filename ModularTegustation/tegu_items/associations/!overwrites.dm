/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		maxHealth = 500
		health = 500

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		melee_damage_lower = 70
		melee_damage_upper = 82 // If you get hit by them it's a major skill issue
		maxHealth = 1200
		health = 1200
		can_burrow = FALSE
