/mob/living/simple_animal/hostile/ordeal/steel_dawn/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/food/meat/slab/human/mutant/moth = 1)
		ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.2))

/mob/living/simple_animal/hostile/ordeal/green_bot/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 2))

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		maxHealth = 500
		health = 500
		melee_damage_lower = 8
		melee_damage_upper = 10
		ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1))

/mob/living/simple_animal/hostile/ordeal/indigo_spawn/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5))

/mob/living/simple_animal/hostile/ordeal/green_bot_big/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		rapid = 10
		rapid_fire_delay = 3
		projectiletype = /obj/projectile/bullet/c9x19mm/greenbot/city
		firing_cooldown = 2.4
		ranged_cooldown_time = 30
		ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 2))

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
