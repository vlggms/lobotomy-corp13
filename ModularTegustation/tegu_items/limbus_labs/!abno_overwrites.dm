/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		suffocation_range = 1

/mob/living/simple_animal/hostile/abnormality/nothing_there/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 1500
		maxHealth = 1500
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2))

/mob/living/simple_animal/hostile/abnormality/scorched_girl/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 600
		boom_damage = 80

/mob/living/simple_animal/hostile/abnormality/general_b/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		health = 2000
		maxHealth = 2000
		ChangeResistances(list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1))
		melee_damage_lower = 35
		melee_damage_upper = 47

/mob/living/simple_animal/hostile/abnormality/hatred_queen/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		beam_damage = 4
		beats_damage = 80
		faction = list("neutral")

/mob/living/simple_animal/hostile/abnormality/steam/Initialize()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5))
