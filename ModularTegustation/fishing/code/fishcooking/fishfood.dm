//Grilled Fish

/obj/item/food/cooked_fish
	name = "cooked fish"
	desc = "A whole fish thats been cooked."
	icon_state = "punishedfish"
	food_reagents = list (/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("fish" = 1, "crunchy" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

//Fried Fish
/obj/item/food/fishfingers
	name = "fish fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	icon = 'icons/obj/food/seafood.dmi'
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	bite_consumption = 1
	tastes = list("fish" = 1, "breadcrumbs" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fishfry
	name = "fish fry"
	desc = "All that and no bag of chips..."
	icon_state = "fishfry"
	icon = 'icons/obj/food/seafood.dmi'
	food_reagents = list (/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("fish" = 1, "pan seared vegtables" = 1)
	foodtypes = MEAT | VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tempurashrimp
	name = "tempura shrimp"
	desc = "A shrimp did fry this..."
	icon_state = "shrimp_deepfried"
	icon = 'icons/obj/food/seafood.dmi'
	food_reagents = list (/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 3,  /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("shrimp", "rice")
	foodtypes = MEAT | FRIED
	w_class = WEIGHT_CLASS_SMALL

//Made shrimply via the sushi mat
/obj/item/food/sashimi
	name = "sashimi"
	desc = "Its just cut up fish right?"
	icon_state = "sashimi"
	icon = 'icons/obj/food/seafood.dmi'
	food_reagents = list (/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 7,)
	tastes = list("fish" = 1, "hot peppers" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/sashimi/white
	icon_state = "sashimi_white"

/obj/item/food/sashimi/shrimp
	icon_state = "sashimi_shrimp"

//pan-fried
/obj/item/food/panfry_fish
	name = "pan-fried fish"
	desc = "Fish fried in a pan. Delicious."
	icon_state = "salmon_fried"
	icon = 'icons/obj/food/seafood.dmi'
	food_reagents = list (/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("fish" = 1, "oil" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/panfry_fish/white
	icon_state = "white_fried"

/obj/item/food/panfry_fish/shrimp
	name = "pan-fried shrimp"
	desc = "A shrimp could not do this sir!"
	icon_state = "shrimp_fried"

/obj/item/food/baked_salmon
	name = "baked salmon"
	desc = "The best there's ever been."
	icon_state = "salmon_baked"
	icon = 'icons/obj/food/seafood.dmi'
	food_reagents = list (/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/nutriment/protein = 5)
	tastes = list("fish" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/lobster_baked
	name = "lobster dinner"
	desc = "Decadent. Wealthy. Excellence."
	icon_state = "lobster_simple"
	icon = 'icons/obj/food/seafood.dmi'
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	w_class = WEIGHT_CLASS_NORMAL
	foodtypes = MEAT

