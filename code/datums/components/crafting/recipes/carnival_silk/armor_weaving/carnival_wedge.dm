//Wedge Recipes
/datum/crafting_recipe/wedge_male
	name = "wedge office jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/wedge
	reqs = list(
		/obj/item/stack/sheet/silk/crimson_simple = 2,
		/obj/item/stack/sheet/silk/green_advanced = 1,
		/obj/item/stack/sheet/silk/human_simple = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/wedge_fem
	name = "wedge office dress"
	result = /obj/item/clothing/suit/armor/ego_gear/city/wedge/female
	reqs = list(
		/obj/item/stack/sheet/silk/crimson_simple = 2,
		/obj/item/stack/sheet/silk/green_advanced = 1,
		/obj/item/stack/sheet/silk/human_simple = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/wedge_leader
	name = "wedge office leader jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/wedgeleader
	reqs = list(
		/obj/item/stack/sheet/silk/violet_simple = 4,
		/obj/item/stack/sheet/silk/green_advanced = 2,
		/obj/item/stack/sheet/silk/human_advanced = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR
