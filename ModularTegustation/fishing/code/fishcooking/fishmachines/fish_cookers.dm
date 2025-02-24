//Used to fry fish

//You can fry Whitefish, Pink fish and shrimp.
/obj/structure/fishcooker/fishfrier
	name = "fish frier"
	desc = "A machine to fry fish. Don't get any ideas."
	icon_state = "fishfrier"
	on_icon = "fishfrier_on"
	cook_time = 8 SECONDS
	cookables = list(
		/obj/item/food/freshfish/white 						= /obj/item/food/fishfingers,
		/obj/item/food/freshfish/pink	 					= /obj/item/food/fishfry,
		/obj/item/food/fish/salt_water/marine_shrimp 		= /obj/item/food/tempurashrimp,
		)

//You can put shrimp, salmon, whitefish and pinkfish on the stove.
/obj/structure/fishcooker/fishstove
	name = "fish stove"
	desc = "A machine to pan-fry fish. Can only be used on fish."
	icon_state = "stove"
	on_icon = "stove_on"
	cook_time = 12 SECONDS
	cookables = list(
		/obj/item/food/freshfish/pink	 					= /obj/item/food/panfry_fish,
		/obj/item/food/fish/salt_water/salmon	 			= /obj/item/food/panfry_fish,
		/obj/item/food/fish/fresh_water/salmon	 			= /obj/item/food/panfry_fish,
		/obj/item/food/fish/salt_water/marine_shrimp 		= /obj/item/food/panfry_fish/shrimp,
		/obj/item/food/freshfish/white 						= /obj/item/food/panfry_fish/white,
		)

//Lobster and salmon goes in the oven
/obj/structure/fishcooker/fishoven
	name = "fish oven"
	desc = "A machine to bake fish. Is best used to prepare lobsters and salmon."
	icon_state = "oven"
	on_icon = "oven_on"
	cook_time = 30 SECONDS
	cookables = list(
		/obj/item/food/fish/salt_water/lobster	 			= /obj/item/food/lobster_baked,
		/obj/item/food/fish/salt_water/salmon	 			= /obj/item/food/baked_salmon,
		/obj/item/food/fish/fresh_water/salmon	 			= /obj/item/food/baked_salmon,
		/obj/item/food/meat/rawcrab							= /obj/item/food/meat/crab
		)
