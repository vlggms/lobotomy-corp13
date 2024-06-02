/obj/item/food/freshfish
	name = "fish fillet"
	desc = "A fillet of white fish meat."
	icon = 'icons/obj/food/fish.dmi'
	icon_state = "white_fish"
	bite_consumption = 6
	tastes = list("fish" = 1)
	foodtypes = MEAT
	eatverbs = list("bite","chew","gnaw","swallow","chomp")
	w_class = WEIGHT_CLASS_SMALL

	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/consumable/nutriment/vile_fluid = 4,
	)
	foodtypes = MEAT | RAW | GROSS
	tastes = list("fish" = 1)


//They all keep the name to add a bit of skill to seafood creating.
/obj/item/food/freshfish/white
	icon_state = "white_fish"

/obj/item/food/freshfish/pink
	icon_state = "pink_fish"

/obj/item/food/freshfish/salmon
	icon_state = "salmon"

/obj/item/food/freshfish/lobster
	icon_state = "lobster"

/obj/item/food/freshfish/rotten
	icon_state = "rotten_fish"

/obj/item/food/freshfish/slime
	name = "fishy slime"
	icon_state = "slime"

/obj/item/food/freshfish/fugu
	icon_state = "fugu"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/toxin/fugutoxin = 10,
	)


/datum/reagent/toxin/fugutoxin
	name = "fugutoxin"
	description = "An extremely powerful poison derived from pufferfish."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 7	//You die.
	taste_description = "mushroom"
