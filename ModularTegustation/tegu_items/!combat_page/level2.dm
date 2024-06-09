/obj/item/combat_page/level2
	combat_level = 2

//Bongy
/obj/item/combat_page/level2/bongy
	name = "Page of fried chicken"
	desc = "A page that contains combat of a fried chicken man."
	reward_type = "PE"
	reward_specification = 600
	spawn_enemies = list(/mob/living/simple_animal/hostile/distortion/papa_bongy)
	spawn_type = "random"
	combat_level = 2

//Hard Lovetown
/obj/item/combat_page/level2/lovetown2
	name = "page of hewn flesh"
	desc = "A page that contains combat with hewn flesh."
	reward_type = "PE"
	reward_specification = 600
	spawn_enemies = list(
			/mob/living/simple_animal/hostile/lovetown/shambler,
			/mob/living/simple_animal/hostile/lovetown/slumberer)
	spawn_type = "random"
	spawn_number = 10
	combat_level = 2

//Rats
/obj/item/combat_page/level2/ratswarm
	name = "page of a rat swarm"
	desc = "A page that contains combat with many rats."
	reward_type = "Item"
	reward_specification = list(/obj/structure/lootcrate/backstreets, /obj/structure/lootcrate/backstreets, /obj/structure/lootcrate/backstreets)
	spawn_enemies = list(
			/mob/living/simple_animal/hostile/humanoid/rat/knife,
			/mob/living/simple_animal/hostile/humanoid/rat,
			/mob/living/simple_animal/hostile/humanoid/rat/pipe,
			/mob/living/simple_animal/hostile/humanoid/rat/hammer,
			/mob/living/simple_animal/hostile/humanoid/rat/zippy)
	spawn_type = "random"
	spawn_number = 15
	combat_level = 2

//Kcorp drones
/obj/item/combat_page/level2/drones2
	name = "page of large observation"
	desc = "A page that contains combat with many K-Corp drones"
	reward_type = "Item"
	reward_specification = /obj/item/krevive
	spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)
	spawn_type = "random"
	spawn_number = 2

//Fixers
/obj/item/combat_page/level2/metalfixer
	name = "page of a hardy fixer"
	desc = "A page that contains combat with a strange fixer."
	reward_type = "Item"
	reward_specification = list(/obj/structure/lootcrate/hana, /obj/structure/lootcrate/hana, /obj/structure/lootcrate/hana, /obj/structure/lootcrate/hana)
	spawn_enemies = list(/mob/living/simple_animal/hostile/humanoid/fixer/metal)
	spawn_type = "random"
	combat_level = 2

/obj/item/combat_page/level2/emberlightfixer
	name = "page of an emberlight fixer"
	desc = "A page that contains combat with a strange fixer."
	reward_type = "Item"
	reward_specification = list(/obj/structure/lootcrate/hana, /obj/structure/lootcrate/hana, /obj/structure/lootcrate/hana, /obj/structure/lootcrate/hana)
	spawn_enemies = list(/mob/living/simple_animal/hostile/humanoid/fixer/flame)
	spawn_type = "random"
	combat_level = 2
