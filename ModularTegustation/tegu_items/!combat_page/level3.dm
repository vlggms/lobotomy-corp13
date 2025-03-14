/obj/item/combat_page/level3
	combat_level = 3
	name = "combat page L3"
	desc = "A page that contains a level 3 combat page"
	reward_pe = 1500
	spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)
	spawn_type = "random"
	spawn_number = 1
	var/list/combat_weights = list(
		"bongy" = 10,
		"shrimp" = 10,
		"philip" = 2,
		)

/obj/item/combat_page/level3/Initialize()
	. = ..()
	var/chosen = pickweight(combat_weights)
	switch(chosen)
		if("bongy")
			spawn_enemies = list(/mob/living/simple_animal/hostile/distortion/papa_bongy)

		if("shrimp")
			spawn_number = 10
			spawn_enemies = list(/mob/living/simple_animal/hostile/senior_shrimp,
				/mob/living/simple_animal/hostile/shrimp_rifleman,
				/mob/living/simple_animal/hostile/shrimp_soldier,)

		if("philip")
			spawn_enemies = list(/mob/living/simple_animal/hostile/abnormality/crying_children)
