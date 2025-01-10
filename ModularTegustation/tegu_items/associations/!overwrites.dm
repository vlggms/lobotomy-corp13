/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		maxHealth = 500
		health = 500
		melee_damage_lower = 8
		melee_damage_upper = 10

/mob/living/simple_animal/hostile/ordeal/green_bot_big/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		rapid = 10
		rapid_fire_delay = 3
		projectiletype = /obj/projectile/bullet/c9x19mm/greenbot/city
