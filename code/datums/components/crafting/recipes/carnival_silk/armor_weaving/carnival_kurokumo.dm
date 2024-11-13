//Kurokumo Recipes
/datum/crafting_recipe/kurokumo
	name = "Kurokumo Wakashu Dress Jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo
	reqs = list(
		/obj/item/stack/sheet/silk/steel_simple = 3,
		/obj/item/stack/sheet/silk/indigo_advanced = 2,
		/obj/item/stack/sheet/silk/human_simple = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/kurokumo_jacket
	name = "Kurokumo Enforcer Dress Shirt"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo/jacket
	reqs = list(
		/obj/item/stack/sheet/silk/steel_simple = 6,
		/obj/item/stack/sheet/silk/indigo_advanced = 4,
		/obj/item/stack/sheet/silk/human_advanced = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/kurokumo_captain
	name = "Kurokumo Captain Kimono"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo/captain
	reqs = list(
		/obj/item/stack/sheet/silk/steel_advanced = 6,
		/obj/item/stack/sheet/silk/indigo_elegant = 4,
		/obj/item/stack/sheet/silk/human_elegant = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR
