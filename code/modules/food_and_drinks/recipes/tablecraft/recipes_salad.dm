
// see code/module/crafting/table.dm

////////////////////////////////////////////////SALADS////////////////////////////////////////////////

/datum/crafting_recipe/food/validsalad
	name = "Valid salad"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/ambrosia/vulgaris = 3,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/salad/validsalad
	subcategory = CAT_SALAD

/datum/crafting_recipe/food/oatmeal
	name = "Oatmeal"
	reqs = list(
		/datum/reagent/consumable/milk = 10,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/salad/oatmeal
	subcategory = CAT_SALAD

/datum/crafting_recipe/food/fruitsalad
	name = "Fruit salad"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/grown/grapes = 1,
		/obj/item/food/grown/citrus/orange = 1,
		/obj/item/food/watermelonslice = 2

	)
	result = /obj/item/food/salad/fruit
	subcategory = CAT_SALAD

/datum/crafting_recipe/food/junglesalad
	name = "Jungle salad"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/grown/grapes = 1,
		/obj/item/food/grown/banana = 2,
		/obj/item/food/watermelonslice = 2,
	)
	result = /obj/item/food/salad/jungle
	subcategory = CAT_SALAD

/datum/crafting_recipe/food/citrusdelight
	name = "Citrus delight"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/citrus/lime = 1,
		/obj/item/food/grown/citrus/lemon = 1,
		/obj/item/food/grown/citrus/orange = 1,
	)
	result = /obj/item/food/salad/citrusdelight
	subcategory = CAT_SALAD

/datum/crafting_recipe/food/parasite_salad
	name = "Parasite Salad"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/cabbage = 2,
		/obj/item/food/grown/peas = 2
	)
	result = /obj/item/food/salad/parasite_salad
	subcategory = CAT_SALAD
