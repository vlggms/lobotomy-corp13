/obj/item/combat_page/level2
	combat_level = 2
	name = "combat page L2"
	desc = "A page that contains a level 2 combat page"
	reward_pe = 1200
	spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)
	spawn_type = "random"
	spawn_number = 1
	var/list/combat_weights = list(
		"bongy" = 10,
		"lovetown2" = 10,
		"rat2" = 10,
		"drones2" = 5,
		"metalfixer" = 10,
		"flamefixer" = 10,
		)

/obj/item/combat_page/level2/Initialize()
	. = ..()
	var/chosen = pickweight(combat_weights)
	switch(chosen)
		if("bongy")
			spawn_enemies = list(/mob/living/simple_animal/hostile/distortion/papa_bongy)

		if("lovetown2")
			spawn_number = 10
			spawn_enemies = list(/mob/living/simple_animal/hostile/lovetown/shambler,
				/mob/living/simple_animal/hostile/lovetown/slumberer)

		if("rat2")
			spawn_number = 15
			spawn_enemies = list(
					/mob/living/simple_animal/hostile/humanoid/rat/knife,
					/mob/living/simple_animal/hostile/humanoid/rat,
					/mob/living/simple_animal/hostile/humanoid/rat/pipe,
					/mob/living/simple_animal/hostile/humanoid/rat/hammer,
					/mob/living/simple_animal/hostile/humanoid/rat/zippy)

		if("drones2")
			spawn_number = 5
			spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)

		if("metalfixer")
			spawn_enemies = list(/mob/living/simple_animal/hostile/humanoid/fixer/metal)

		if("flamefixer")
			spawn_enemies = list(/mob/living/simple_animal/hostile/humanoid/fixer/flame)
