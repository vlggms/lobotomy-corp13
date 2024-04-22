/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		suffocation_range = 1

/mob/living/simple_animal/hostile/abnormality/nothing_there/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 1500
		maxHealth = 1500
		damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)

/mob/living/simple_animal/hostile/abnormality/scorched_girl/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 600
		boom_damage = 80

/mob/living/simple_animal/hostile/abnormality/general_b/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 1000
		maxHealth = 1000
		damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
		melee_damage_lower = 20
		melee_damage_upper = 32