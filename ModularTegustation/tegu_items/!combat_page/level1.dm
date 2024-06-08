
//Kcorp drones
/obj/item/combat_page/drones
	name = "page of small observation"
	desc = "A page that contains combat with some K-Corp drones"
	reward_type = "Item"
	reward_specification = /obj/item/ksyringe
	spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)
	spawn_type = "random"
	spawn_number = 2

//Easy Lovetown
/obj/item/combat_page/lovetown1
	name = "page of new flesh"
	desc = "A page that contains combat with new flesh."
	reward_type = "PE"
	reward_specification = 120
	spawn_enemies = list(/mob/living/simple_animal/hostile/lovetown/slasher,
			/mob/living/simple_animal/hostile/lovetown/stabber)
	spawn_type = "random"
	spawn_number = 10

//Rats
/obj/item/combat_page/rat
	name = "page of rats"
	desc = "A page that contains combat with a small amount of rats."
	reward_type = "Item"
	reward_specification = list(/obj/structure/lootcrate/backstreets)
	spawn_enemies = list(
			/mob/living/simple_animal/hostile/humanoid/rat/knife,
			/mob/living/simple_animal/hostile/humanoid/rat,
			/mob/living/simple_animal/hostile/humanoid/rat/pipe,
			/mob/living/simple_animal/hostile/humanoid/rat/hammer,
			/mob/living/simple_animal/hostile/humanoid/rat/zippy)
	spawn_type = "random"
	spawn_number = 6
