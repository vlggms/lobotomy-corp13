//Silk into different Silk
//Simple Transfers
/datum/crafting_recipe/steel_silk_transfer
	name = "Green Silk to Steel Silk"
	result = /obj/item/stack/sheet/silk/steel_simple
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/amber_silk_transfer
	name = "Indigo Silk to Amber Silk"
	result = /obj/item/stack/sheet/silk/amber_simple
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

//Advanced Transfers
/datum/crafting_recipe/azure_silk_transfer
	name = "Violet/Crimson Silk to Azure Silk"
	result = /obj/item/stack/sheet/silk/amber_simple
	reqs = list(/obj/item/stack/sheet/silk/crimson_advanced = 1, /obj/item/stack/sheet/silk/violet_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/crimson_silk_transfer
	name = "Steel Silk to Crimson Silk"
	result = /obj/item/stack/sheet/silk/crimson_simple
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/violet_silk_transfer
	name = "Amber Silk to Violet Silk"
	result = /obj/item/stack/sheet/silk/violet_simple
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/shrimple_silk_transfer
	name = "Amber/Steel Silk to Shrimple Silk"
	result = /obj/item/stack/sheet/silk/shrimple_simple
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 1, /obj/item/stack/sheet/silk/steel_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

//Human Transfer
/datum/crafting_recipe/human_silk_transfer
	name = "Shrimple Silk to Human Silk"
	result = /obj/item/stack/sheet/silk/human_simple
	reqs = list(/obj/item/stack/sheet/silk/shrimple_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK
