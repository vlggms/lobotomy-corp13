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
////////////////////////////////////////////////////////////////abno novelty food/////////////////////////////////////////////////////////////////////////////
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
	desc = "A sweet cookie shaped like a cute little bird."
	icon_state = "sugarcookie_pbird"

/obj/item/food/cake/bbird
	name = "Big Bird cake"
	desc = "A cake that seems like it's watching you."
	icon_state = "bbcake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cake" = 1, "vigilance" = 1)
	foodtypes = GRAIN | DAIRY

/datum/crafting_recipe/food/cake/bbird
	name = "Big Bird Cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2
	)
	result = /obj/item/food/cake/bbird
	subcategory = CAT_CAKE

/obj/item/food/sundae/jbird
	name = "Judgement sundae"
	desc = "A sweet, sweet serving of justice."
	icon_state = "sundae" //PLACEHOLDER
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/banana = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("judgement" = 1, "paranoia" = 1)
	foodtypes = DAIRY | SUGAR

/datum/crafting_recipe/food/sundae/jbird
	name = "Judgement Sundae"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/grown/cherries = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/sundae/jbird
	subcategory = CAT_ICE

/obj/item/food/apoctrifle
	name = "Apocalypse trifle"
	desc = "A huge serving of monstrously good cake, custard, and forest fruit."
	icon_state = "apoctrifle"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/sugar = 5)
	tastes = list("cake" = 3, "custard" = 3, "fresh fruit" = 3, "fear" = 1)
	foodtypes = DAIRY | SUGAR | FRUIT

/datum/crafting_recipe/food/apoctrifle
	name = "Apocalypse Trifle"
	reqs = list(
		/obj/item/food/sundae/jbird = 1,
		/obj/item/food/cake/bbird = 1,
		/obj/item/food/cookie/sugar/pbird = 1
	)
	result = /obj/item/food/apoctrifle
	subcategory = CAT_MISCFOOD

////////////////////////////////////////////////////////////////ordeal food/////////////////////////////////////////////////////////////////////////////
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

/obj/item/food/soup/sweepersoup
	name = "sweeper soup"
	desc = "Liquid sweeper in a bowl made of its own shell."
	icon_state = "redbeetsoup" //PLACEHOLDER
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/blood = 10)
	tastes = list("something metallic" = 1)
	foodtypes = MEAT

/datum/crafting_recipe/food/soup/sweepersoup
	name = "Sweeper Soup"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/food/meat/slab/sweeper = 2
	)
	result = /obj/item/food/soup/sweepersoup
	subcategory = CAT_SOUP

		////////////////////////////////////////////////////////////////abnochem food/////////////////////////////////////////////////////////////////////////////

/obj/item/food/teaparty
	name = "unending tea party"
	desc = "A delusionally good selection of treats, crustless sandwiches, and hot tea. Enough to share." //ego ability gives snacks, therefore snack plate to share
	icon_state = "teaparty"
	food_reagents = list(/datum/reagent/consumable/nutriment = 12, /datum/reagent/abnormality/bottle = 6)
	tastes = list("tiny sandwiches" = 2, "cookies" = 2, "tea" = 2, "delusion" = 1)
	foodtypes = GRAIN | SUGAR

/datum/crafting_recipe/food/teaparty
	name = "Unending Tea Party"
	reqs = list(
		/obj/item/food/cookie/sugar = 2,
		/datum/reagent/abnormality/bottle = 10
	)
	result = /obj/item/food/teaparty
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/wccajam
	name = "Meat Jam"
	reqs = list(
		/datum/reagent/abnormality/we_can_change_anything = 10
	)
	result = /obj/item/food/meatjam
	subcategory = CAT_MEAT

/obj/item/food/soup/basilisoup
	name = "basilisoup"
	desc = "A boiling hot stew. It tastes like home."
	icon_state = "meatballsoup"//replace with actual sprite when done
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/water = 2)
	tastes = list("basil" = 2, "meat" = 2, "potato" = 2, "vegetables" = 2, "burning" = 1)
	foodtypes = VEGETABLES | MEAT

/datum/crafting_recipe/food/soup/basilisoup
	name = "Basilisoup"
	reqs = list(
		/datum/reagent/water = 10,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/potato = 2,
		/obj/item/food/meat/cutlet = 2
	)
	result = /obj/item/food/soup/basilisoup
	subcategory = CAT_SOUP
