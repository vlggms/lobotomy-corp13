/mob/living/simple_animal/hostile/ordeal/steel_dawn/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/food/meat/slab/human/mutant/moth = 1)

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
		firing_cooldown = 2.4

/mob/living/simple_animal/hostile/ordeal/amber_dusk/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		melee_damage_lower = 45
		melee_damage_upper = 50
		maxHealth = 700
		health = 700
		can_burrow = FALSE
		attack_cooldown = 100

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		gibbing = FALSE
		maxHealth = 1500
		health = 1500

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		maxHealth = 2000
		health = 2000

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/strong/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		maxHealth = 3000
		health = 3000
