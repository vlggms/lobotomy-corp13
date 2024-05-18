
// see code/module/crafting/table.dm

////////////////////////////////////////////////BREAD////////////////////////////////////////////////

/datum/crafting_recipe/food/meatbread
	name = "Meat bread"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/plain = 3,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/bread/meat
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/banananutbread
	name = "Banana nut bread"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/boiledegg = 3,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/bread/banana
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/tofubread
	name = "Tofu bread"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/tofu = 3,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/bread/tofu
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/creamcheesebread
	name = "Cream cheese bread"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/bread/creamcheese
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/garlicbread
	name = "Garlic Bread"
	time = 40
	reqs = list(/obj/item/food/grown/garlic = 1,
				/obj/item/food/breadslice/plain = 1,
				/obj/item/food/butter = 1
	)
	result = /obj/item/food/garlicbread
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butterbiscuit
	name = "Butter Biscuit"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/butterbiscuit
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butterdog
	name = "Butterdog"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 3,
		)
	result = /obj/item/food/butterdog
	subcategory = CAT_BREAD
