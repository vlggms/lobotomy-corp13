//Recipes

/datum/crafting_recipe/food/breadstick
	name = "Breadstick"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/stack/rods = 1
	)
	result = /obj/item/food/bread/breadstick
	subcategory = CAT_BREAD

//Actual objects

/obj/item/food/bread/breadstick
	name = "breadstick"
	desc = "Listen never forget, when you're here you're family. Breadstick?"
	icon_state = "breadstick"
	icon = 'ModularTegustation/Teguicons/breadstick.dmi'
	lefthand_file = "icons/mob/inhands/misc/food_lefthand.dmi"
	righthand_file = "icons/mob/inhands/misc/food_righthand.dmi"
	inhand_icon_state = "baguette"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	tastes = list("stale bread" = 1)
	foodtypes = GRAIN
