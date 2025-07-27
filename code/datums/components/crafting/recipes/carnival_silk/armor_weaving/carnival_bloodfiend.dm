//Bloodfiend Recipes
/datum/crafting_recipe/bloodfiend_coat
	name = "Masquerade Coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/masquerade_coat
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

/datum/crafting_recipe/bloodfiend_cloak
	name = "Masquerade Cloak"
	result = /obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak
	reqs = list(
		/obj/item/stack/sheet/silk/crimson_simple = 4,
		/obj/item/stack/sheet/silk/green_advanced = 2,
		/obj/item/stack/sheet/silk/human_advanced = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR
