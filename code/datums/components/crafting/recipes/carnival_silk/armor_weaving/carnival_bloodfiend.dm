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

/datum/crafting_recipe/barber_dress
	name = "barber's dress"
	result = /obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/barber_dress
	reqs = list(
		/obj/item/stack/sheet/silk/crimson_simple = 8,
		/obj/item/stack/sheet/silk/indigo_advanced = 4,
		/obj/item/stack/sheet/silk/human_elegant = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/barber_dress_sleeves
	name = "barber's dress (sleeves)"
	result = /obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/barber_dress/sleeves
	reqs = list(
		/obj/item/stack/sheet/silk/crimson_simple = 8,
		/obj/item/stack/sheet/silk/indigo_advanced = 4,
		/obj/item/stack/sheet/silk/human_elegant = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/prince_suit
	name = "prince's suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/cassetti
	reqs = list(
		/obj/item/stack/sheet/silk/crimson_simple = 10,
		/obj/item/stack/sheet/silk/human_elegant = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR
