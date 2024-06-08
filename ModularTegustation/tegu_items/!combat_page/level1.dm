/obj/item/combat_page/level1

//Kcorp drones
/obj/item/combat_page/level1/drones
	name = "page of small observation"
	desc = "A page that contains combat with some K-Corp drones"
	reward_items = list(/obj/item/ksyringe)
	reward_pe = 100
	spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)
	spawn_type = "random"
	spawn_number = 2

//Easy Lovetown
/obj/item/combat_page/level1/lovetown1
	name = "page of new flesh"
	desc = "A page that contains combat with new flesh."
	reward_pe = 120
	spawn_enemies = list(/mob/living/simple_animal/hostile/lovetown/slasher,
			/mob/living/simple_animal/hostile/lovetown/stabber)
	spawn_type = "random"
	spawn_number = 10

//Rats
/obj/item/combat_page/level1/rat
	name = "page of rats"
	desc = "A page that contains combat with a small amount of rats."
	reward_items = list(/obj/structure/lootcrate/backstreets)
	reward_pe = 100
	spawn_enemies = list(
			/mob/living/simple_animal/hostile/humanoid/rat/knife,
			/mob/living/simple_animal/hostile/humanoid/rat,
			/mob/living/simple_animal/hostile/humanoid/rat/pipe,
			/mob/living/simple_animal/hostile/humanoid/rat/hammer,
			/mob/living/simple_animal/hostile/humanoid/rat/zippy)
	spawn_type = "random"
	spawn_number = 6
