/datum/crafting_recipe/boatworks
	name = "molar boatworks jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/molar/boatworks
	reqs = list(
		/obj/item/stack/sheet/silk/shrimple_simple = 2,
		/obj/item/stack/sheet/silk/indigo_advanced = 1,
		/obj/item/stack/sheet/silk/human_simple = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/boatworks_director
	name = "molar boatworks director wetsuit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/molar/director/boatworks
	reqs = list(
		/obj/item/stack/sheet/silk/shrimple_simple = 5,
		/obj/item/stack/sheet/silk/human_advanced = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR
