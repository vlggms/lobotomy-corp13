/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		maxHealth = 500
		health = 500
