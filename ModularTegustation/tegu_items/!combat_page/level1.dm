//Fixers
/obj/item/combat_page/fixers
	name = "page of some strange fixers"
	desc = "A page that contains combat of one of a few strange fixers."
	reward_type = "PE"
	reward_specification = 100
	spawn_enemies = list(/mob/living/simple_animal/hostile/humanoid/fixer/metal,
				/mob/living/simple_animal/hostile/humanoid/fixer/flame)
	spawn_type = "random"

//Bongy
/obj/item/combat_page/bongy
	name = "page of fried chicken"
	desc = "A page that contains combat of a fried chicken man."
	reward_type = "PE"
	reward_specification = 100
	spawn_enemies = list(/mob/living/simple_animal/hostile/distortion/papa_bongy)
	spawn_type = "random"
