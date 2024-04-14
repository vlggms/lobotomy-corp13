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

/mob/living/simple_animal/hostile/abnormality/titania/Initialize()
	..()
	if(SSmaptype.maptype == "limbus_labs")
		fairy_spawn_number = 1
		fairy_spawn_time = 10 SECONDS
		fairy_spawn_limit = 1

