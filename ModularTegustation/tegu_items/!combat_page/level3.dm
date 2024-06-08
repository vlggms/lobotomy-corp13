//Tomerry
/obj/item/combat_page/tomerry
	name = "Page of melded flesh"
	desc = "A page that contains combat with flesh melded together."
	reward_type = "PE"
	reward_specification = 100
	spawn_enemies = list(/mob/living/simple_animal/hostile/lovetown/abomination)
	spawn_type = "random"
	combat_level = 3

//Shrimp
/obj/item/combat_page/shrimp
	name = "Page of the ocean"
	desc = "A page that contains combat with a handful of shrimp."
	reward_type = "PE"
	reward_specification = 100
	spawn_enemies = list(/mob/living/simple_animal/hostile/senior_shrimp,
		/mob/living/simple_animal/hostile/shrimp_rifleman,
		/mob/living/simple_animal/hostile/shrimp_soldier,
		)
	spawn_type = "random"
	combat_level = 3
	spawn_number = 8

//Shrimp
/obj/item/combat_page/ash
	name = "Page of ash"
	desc = "A page that contains combat with an ashen one."
	reward_type = "Item"
	reward_specification = list(/obj/item/ego_weapon/shield/waxen, /obj/item/clothing/suit/armor/ego_gear/aleph/waxen)
	spawn_enemies = list(/mob/living/simple_animal/hostile/abnormality/crying_children)
	spawn_type = "random"
	combat_level = 3
