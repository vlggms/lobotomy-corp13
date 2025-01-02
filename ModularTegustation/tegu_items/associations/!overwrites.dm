/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		maxHealth = 500
		health = 500

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		melee_damage_lower = 45
		melee_damage_upper = 55
		maxHealth = 800
		health = 800
		can_burrow = FALSE
