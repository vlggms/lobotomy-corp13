
/datum/crafting_recipe/bonfire
	name = "Bonfire"
	time = 60
	reqs = list(/obj/item/grown/log = 5)
	parts = list(/obj/item/grown/log = 5)
	blacklist = list(/obj/item/grown/log/steel)
	result = /obj/structure/bonfire
	category = CAT_STRUCT

/datum/crafting_recipe/mannequin
	name = "Mannequin"
	result = /obj/structure/mannequin
	reqs = list(/obj/item/stack/sheet/mineral/wood = 10)
	time = 50
	category = CAT_STRUCT

/datum/crafting_recipe/blackcarpet
	name = "Black Carpet"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	category = CAT_STRUCT

/datum/crafting_recipe/curtain
	name = "Curtains"
	reqs = 	list(/obj/item/stack/sheet/cotton/cloth = 4, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain/cloth
	category = CAT_STRUCT

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = 	list(/obj/item/stack/sheet/cotton/cloth = 2, /obj/item/stack/sheet/plastic = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	category = CAT_STRUCT

/datum/crafting_recipe/shutters
	name = "Shutters"
	reqs = list(/obj/item/stack/sheet/plasteel = 10,
				/obj/item/stack/cable_coil = 10,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/shutters/preopen
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 15 SECONDS
	category = CAT_STRUCT

/datum/crafting_recipe/blast_doors
	name = "Blast Door"
	reqs = list(/obj/item/stack/sheet/plasteel = 15,
				/obj/item/stack/cable_coil = 15,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/preopen
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 30 SECONDS
	category = CAT_STRUCT

/datum/crafting_recipe/aquarium
	name = "Aquarium"
	result = /obj/structure/aquarium
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 15,
				/obj/item/stack/sheet/glass = 10,
				/obj/item/aquarium_kit = 1
				)
	category = CAT_STRUCT

/datum/crafting_recipe/headpike
	name = "Spike Head (Glass Spear)"
	time = 65
	reqs = list(/obj/item/spear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear = 1)
	blacklist = list(/obj/item/spear/explosive, /obj/item/spear/bonespear)
	result = /obj/structure/headpike
	category = CAT_STRUCT

/datum/crafting_recipe/headpikebone
	name = "Spike Head (Bone Spear)"
	time = 65
	reqs = list(/obj/item/spear/bonespear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear/bonespear = 1)
	result = /obj/structure/headpike/bone
	category = CAT_STRUCT

/datum/crafting_recipe/pressureplate
	name = "Pressure Plate"
	result = /obj/item/pressure_plate
	time = 5
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/tile/plasteel = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/assembly/igniter = 1)
	category = CAT_STRUCT

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/mineral/wood = 20,
				/obj/item/stack/cable_coil = 10)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCT

/datum/crafting_recipe/multiduct
	name = "Multi-layer duct"
	result = /obj/machinery/duct/multilayered
	time = 5
	reqs = list(/obj/item/stack/ducts = 5)
	category = CAT_STRUCT
	tools = list(TOOL_WELDER)

/datum/crafting_recipe/rib
	name = "Collosal Rib"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 10,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/rib
	subcategory = CAT_STRUCT

/datum/crafting_recipe/skull
	name = "Skull Carving"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 6,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull
	category = CAT_STRUCT

/datum/crafting_recipe/halfskull
	name = "Cracked Skull Carving"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 3,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull/half
	category = CAT_STRUCT
/*
/datum/crafting_recipe/elder_atmosian_statue
	name = "Elder Atmosian Statue"
	result = /obj/structure/statue/elder_atmosian
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/metal_hydrogen = 10,
				/obj/item/grenade/gas_crystal/healium_crystal = 1,
				/obj/item/grenade/gas_crystal/proto_nitrate_crystal = 1,
				/obj/item/grenade/gas_crystal/zauker_crystal = 1
				)
	category = CAT_STRUCT
*/
