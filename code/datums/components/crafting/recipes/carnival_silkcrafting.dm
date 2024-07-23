
//Carnival Recipes
/datum/crafting_recipe/indigo_armor
	name = "Sweeper Suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/indigo_armor
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/green_armor
	name = "Doubting Suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/green_armor
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/amber_armor
	name = "Hunger Suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/amber_armor
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/steel_armor
	name = "Soldier's Uniform"
	result = /obj/item/clothing/suit/armor/ego_gear/city/steel_armor
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/carnival_robes
	name = "Carnival's Robes"
	result = /obj/item/clothing/suit/armor/ego_gear/city/carnival_robes
	reqs = list(/obj/item/stack/sheet/silk/indigo_advanced = 3,
				/obj/item/stack/sheet/silk/green_advanced = 3,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

//Meat Crafting
/datum/crafting_recipe/amber_silk_simple
	name = "Simple Amber Silk"
	result = /obj/item/stack/sheet/silk/amber_simple
	reqs = list(/obj/item/food/meat/slab/worm = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/steel_silk_simple
	name = "Simple Steel Silk"
	result = /obj/item/stack/sheet/silk/steel_simple
	reqs = list(/obj/item/food/meat/slab/human/mutant/moth = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/indigo_silk_simple
	name = "Simple Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_simple
	reqs = list(/obj/item/food/meat/slab/sweeper = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/green_silk_simple
	name = "Simple Green Silk"
	result = /obj/item/stack/sheet/silk/green_simple
	reqs = list(/obj/item/food/meat/slab/robot = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/indigo_silk_advanced
	name = "Advanced Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_advanced
	reqs = list(/obj/item/food/meat/slab/sweeper = 6)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/green_silk_advanced
	name = "Advanced Green Silk"
	result = /obj/item/stack/sheet/silk/green_advanced
	reqs = list(/obj/item/food/meat/slab/robot = 6)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK
//Converted Silk Crafts
/datum/crafting_recipe/converted_green_silk_advanced
	name = "Converted Advanced Green Silk"
	result = /obj/item/stack/sheet/silk/green_advanced
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/converted_green_silk_elegant
	name = "Converted Elegant Green Silk"
	result = /obj/item/stack/sheet/silk/green_elegant
	reqs = list(/obj/item/stack/sheet/silk/green_advanced = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/converted_indigo_silk_advanced
	name = "Converted Advanced Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_advanced
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/converted_indigo_silk_elegant
	name = "Converted Elegant Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_elegant
	reqs = list(/obj/item/stack/sheet/silk/indigo_advanced = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/converted_amber_silk_advanced
	name = "Converted Advanced Amber Silk"
	result = /obj/item/stack/sheet/silk/amber_advanced
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/converted_steel_silk_advanced
	name = "Converted Advanced Steel Silk"
	result = /obj/item/stack/sheet/silk/steel_advanced
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/converted_human_silk_advanced
	name = "Converted Advanced Human Silk"
	result = /obj/item/stack/sheet/silk/human_advanced
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 4)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/converted_human_silk_elegant
	name = "Converted Elegant Human Silk"
	result = /obj/item/stack/sheet/silk/human_elegant
	reqs = list(/obj/item/stack/sheet/silk/human_advanced = 4)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

//Silk into different Silk
/datum/crafting_recipe/green_silk_to_steel_silk
	name = "Green Silk to Steel Silk"
	result = /obj/item/stack/sheet/silk/steel_simple
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/indigo_silk_to_amber_silk
	name = "Indigo Silk to Amber Silk"
	result = /obj/item/stack/sheet/silk/amber_simple
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_SILK

//Blade Lineage Recipes
/datum/crafting_recipe/blade_lineage_salsu
	name = "Blade Lineage Salsu Robe"
	result = /obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_salsu
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 4,
				/obj/item/stack/sheet/silk/amber_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/blade_lineage_cutthroat
	name = "Blade Lineage Cutthroat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_cutthroat
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 4,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/blade_lineage_admin
	name = "Blade Lineage Admin"
	result = /obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 4,
				/obj/item/stack/sheet/silk/amber_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

//Index Recipes
/datum/crafting_recipe/index_proselyte
	name = "Index Proselyte Armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/index
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_simple = 2,
				/obj/item/stack/sheet/silk/indigo_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/index_proxy
	name = "Index Proxy Armor"
	result = /obj/item/clothing/suit/armor/ego_gear/adjustable/city/index_proxy
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_simple = 2,
				/obj/item/stack/sheet/silk/indigo_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/index_mess
	name = "Index Messenger Armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/index_mess
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_simple = 2,
				/obj/item/stack/sheet/silk/indigo_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

//Kurokumo Recipes
/datum/crafting_recipe/kurokumo
	name = "Kurokumo Wakashu Dress Jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 5,
				/obj/item/stack/sheet/silk/indigo_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/kurokumo_jacket
	name = "Kurokumo Enforcer Dress Shirt"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo/jacket
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 5,
				/obj/item/stack/sheet/silk/indigo_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/kurokumo_captain
	name = "Kurokumo Captain Kimono"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo/captain
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 5,
				/obj/item/stack/sheet/silk/indigo_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

//Liu Recipes
/datum/crafting_recipe/liu_suit
	name = "Liu Association combat suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liu
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/liu_jacket
	name = "Liu Association combat jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liu/section5
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/liu_coat
	name = "Liu Association combat coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuvet
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/liu_combat_coat
	name = "Liu Association section 2 combat coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuvet/section2
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/liu_combat_jacket
	name = "Liu Association veteran combat jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuvet/section5
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/liu_heavy_coat
	name = "Liu Association heavy combat coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuleader
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/liu_officer_coat
	name = "Liu Association officer coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuleader/section5
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

//N-Corp Crafting Recipes
/datum/crafting_recipe/ncorp
	name = "Nagel und Hammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorp
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 1,
				/obj/item/stack/sheet/silk/human_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/ncorp_vet
	name = "Decorated Nagel und Hammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorp/vet
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 2,
				/obj/item/stack/sheet/silk/human_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/ncorp_grosshammmer
	name = "Nagel und Hammer Grosshammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/grosshammmer
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 4,
				/obj/item/stack/sheet/silk/human_elegant = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/ncorpcommander
	name = "Rüstung der auserwählten Frau Gottes"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorpcommander
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 5,
				/obj/item/stack/sheet/silk/human_masterpiece = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/ncorp_white_mark
	name = "Ncorp White mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/white
	reqs = list(/obj/item/stack/sheet/silk/green_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/ncorp_black_mark
	name = "Ncorp Black mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/black
	reqs = list(/obj/item/stack/sheet/silk/indigo_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/ncorp_pale_mark
	name = "Ncorp Pale mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/pale
	reqs = list(/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

//Seven Recipes
/datum/crafting_recipe/seven
	name = "Seven Association armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/seven
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/seven_recon
	name = "Seven Association recon armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/sevenrecon
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 1,
				/obj/item/stack/sheet/silk/green_advanced = 2,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/seven_vet
	name = "Seven Association veteran armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/sevenvet
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/seven_vet_intel
	name = "Seven Association recon armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/sevenvet/intel
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/indigo_advanced = 2,
				/obj/item/stack/sheet/silk/green_advanced = 2,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/seven_dir
	name = "Seven Association recon armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/sevendirector
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/indigo_advanced = 2,
				/obj/item/stack/sheet/silk/green_advanced = 3,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

//Shi Recipes
/datum/crafting_recipe/shi_2
	name = "Shi association jacket section 2"
	result = /obj/item/clothing/suit/armor/ego_gear/city/shi
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 2,
				/obj/item/stack/sheet/silk/green_simple = 2,
				/obj/item/stack/sheet/silk/steel_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/shi_5
	name = "Shi association jacket section 5"
	result = /obj/item/clothing/suit/armor/ego_gear/city/shilimbus
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 2,
				/obj/item/stack/sheet/silk/green_simple = 2,
				/obj/item/stack/sheet/silk/steel_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/shi_2_vet
	name = "Shi association veteran jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/shi/vet
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 3,
				/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_advanced = 3,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/shi_5_vet
	name = "Shi association veteran combat suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/shilimbus/vet
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 3,
				/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_advanced = 3,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/shi_2_dir
	name = "Shi association director jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/shi/director
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 3,
				/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_advanced = 4,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/shi_5_dir
	name = "Shi association director combat suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/shilimbus/director
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 3,
				/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_advanced = 4,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

//Zwei Recipes
/datum/crafting_recipe/zwei
	name = "Zwei Association armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/zwei
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 1,
				/obj/item/stack/sheet/silk/indigo_advanced = 2,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/zwei_junior
	name = "Zwei Association junior armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/zweijunior
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/indigo_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/zwei_riot
	name = "Zwei Association riot armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/zweiriot
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/zwei_vet
	name = "Zwei Association veteran armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/zweivet
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 2,
				/obj/item/stack/sheet/silk/indigo_advanced = 2,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK

/datum/crafting_recipe/zwei_dir
	name = "Zwei Association director armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/zweileader
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 2,
				/obj/item/stack/sheet/silk/indigo_advanced = 3,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
