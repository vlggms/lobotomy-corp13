
// see code/datums/recipe.dm


// see code/module/crafting/table.dm

////////////////////////////////////////////////SANDWICHES////////////////////////////////////////////////

/datum/crafting_recipe/food/sandwich
	name = "Sandwich"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/sandwich
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/grilledcheesesandwich
	name = "Cheese sandwich"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/grilledcheese
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/cherrysandwich
	name = "Jelly sandwich"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/food/breadslice/plain = 2,
	)
	result = /obj/item/food/jellysandwich/cherry
	subcategory = CAT_SANDWICH

////////////////////////////////////////////////BURGERS////////////////////////////////////////////////

/datum/crafting_recipe/food/burger
	name = "Burger"
	reqs = list(
			/obj/item/food/patty/plain = 1,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/plain
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/corgiburger
	name = "Corgi burger"
	reqs = list(
			/obj/item/food/patty/corgi = 1,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/corgi
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/appendixburger
	name = "Appendix burger"
	reqs = list(
		/obj/item/organ/appendix = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/appendix
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/brainburger
	name = "Brain burger"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/brain
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/fishburger
	name = "Fish burger"
	reqs = list(
		/obj/item/food/carpmeat = 1,
		/obj/item/food/bun = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/burger/fish
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/tofuburger
	name = "Tofu burger"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/tofu
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/redburger
	name = "Red burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/red = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/red
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/orangeburger
	name = "Orange burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/orange = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/orange
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/yellowburger
	name = "Yellow burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/yellow = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/yellow
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/greenburger
	name = "Green burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/green = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/green
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/blueburger
	name = "Blue burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/blue = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/blue
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/purpleburger
	name = "Purple burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/purple = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/purple
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/blackburger
	name = "Black burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/black = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/black
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/whiteburger
	name = "White burger"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/white = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/white
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/bigbiteburger
	name = "Big bite burger"
	reqs = list(
		/obj/item/food/patty/plain = 3,
		/obj/item/food/bun = 1,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/burger/bigbite
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/superbiteburger
	name = "Super bite burger"
	reqs = list(
		/datum/reagent/consumable/salt = 5,
		/datum/reagent/consumable/blackpepper = 5,
		/obj/item/food/patty/plain = 5,
		/obj/item/food/grown/tomato = 4,
		/obj/item/food/cheesewedge = 3,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/bun = 1

	)
	result = /obj/item/food/burger/superbite
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/jellyburger
	name = "Jelly burger"
	reqs = list(
			/datum/reagent/consumable/cherryjelly = 5,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/jelly/cherry
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/baconburger
	name = "Bacon Burger"
	reqs = list(
			/obj/item/food/meat/bacon = 3,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/baconburger
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/empoweredburger
	name = "Empowered Burger"
	reqs = list(
			/obj/item/stack/sheet/mineral/plasma = 2,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/empoweredburger
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/crabburger
	name = "Crab Burger"
	reqs = list(
			/obj/item/food/meat/crab = 2,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/crab
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/cheeseburger
	name = "Cheese Burger"
	reqs = list(
			/obj/item/food/patty/plain = 1,
			/obj/item/food/bun = 1,
			/obj/item/food/cheesewedge = 1,
	)
	result = /obj/item/food/burger/cheese
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/soylentburger
	name = "Soylent Burger"
	reqs = list(
			/obj/item/food/soylentgreen = 1, //two full meats worth.
			/obj/item/food/bun = 1,
			/obj/item/food/cheesewedge = 2,
	)
	result = /obj/item/food/burger/soylent
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/ribburger
	name = "McRib"
	reqs = list(
			/obj/item/food/bbqribs = 1,     //The sauce is already included in the ribs
			/obj/item/food/onion_slice = 1, //feel free to remove if too burdensome.
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/rib
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/mcguffin
	name = "McGuffin"
	reqs = list(
			/obj/item/food/friedegg = 1,
			/obj/item/food/meat/bacon = 2,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/mcguffin
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/chickenburger
	name = "Chicken Sandwich"
	reqs = list(
			/obj/item/food/patty/chicken = 1,
			/datum/reagent/consumable/mayonnaise = 5,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/chicken
	subcategory = CAT_SANDWICH
