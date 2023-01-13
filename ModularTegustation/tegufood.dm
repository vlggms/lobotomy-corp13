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

	//LC13
/datum/crafting_recipe/food/pbirdcookie
	time = 15
	name = "Punishing Bird Cookie"
	reqs = list(
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cookie/sugar/pbird
	subcategory = CAT_PASTRY

/obj/item/food/cookie/sugar/pbird
	icon_state = "sugarcookie_pbird"

/datum/crafting_recipe/food/wormfood
	name = "Wormfood"
	reqs = list(
		/obj/item/food/meat/slab/worm = 1,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/wormfood
	subcategory = CAT_MEAT

/obj/item/food/wormfood
	name = "wormfood"
	desc = "Something inside the meat is desperately consuming whatever is left."
	icon_state = "wormfood1"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/drug/maint/tar = 1, /datum/reagent/yuck = 2)
	tastes = list("crunchy popping" = 1, "consumption" = 1)
	foodtypes = MEAT | GROSS

/obj/item/food/wormfood/Initialize()
	. = ..()
	if(prob(50))
		new /obj/item/food/wormfood_healthier(get_turf(src))
		qdel(src)

/obj/item/food/wormfood_healthier //heals around 7 damage when consumed
	name = "wormfood"
	desc = "Their blind hunger ended in their own consumption." //Put better statement here later.
	icon_state = "wormfood2"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/vitfro = 2)
	tastes = list("crunchy popping" = 1, "buttery meat" = 1)
	foodtypes = MEAT
