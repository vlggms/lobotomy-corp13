//N-Corp Crafting Recipes
/datum/crafting_recipe/ncorp
	name = "Nagel und Hammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorp
	reqs = list(
		/obj/item/stack/sheet/silk/green_advanced = 5,
		/obj/item/stack/sheet/silk/human_simple = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/ncorp_vet
	name = "Decorated Nagel und Hammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorp/vet
	reqs = list(
		/obj/item/stack/sheet/silk/green_simple = 10,
		/obj/item/stack/sheet/silk/green_advanced = 5,
		/obj/item/stack/sheet/silk/human_advanced = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/ncorp_grosshammmer
	name = "Nagel und Hammer Grosshammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/grosshammmer
	reqs = list(
		/obj/item/stack/sheet/silk/green_advanced = 10,
		/obj/item/stack/sheet/silk/green_elegant = 4,
		/obj/item/stack/sheet/silk/human_elegant = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/ncorpcommander
	name = "R�stung der auserw�hlten Frau Gottes"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorpcommander
	reqs = list(
		/obj/item/stack/sheet/silk/azure_elegant = 2,
		/obj/item/stack/sheet/silk/green_elegant = 4,
		/obj/item/stack/sheet/silk/human_masterpiece = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/ncorp_white_mark
	name = "Ncorp White mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/white
	reqs = list(/obj/item/stack/sheet/silk/green_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/ncorp_black_mark
	name = "Ncorp Black mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/black
	reqs = list(/obj/item/stack/sheet/silk/indigo_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/ncorp_pale_mark
	name = "Ncorp Pale mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/pale
	reqs = list(/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

