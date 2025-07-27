/////Arrows
/datum/crafting_recipe/arrow
	name = "Arrow"
	result = /obj/item/ammo_casing/caseless/arrow/wood
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/sheet/silk = 1,
				/obj/item/stack/rods = 1) //1 metal sheet = 2 rods= 2 arrows
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/ashen_arrow
	name = "Fire hardened arrow"
	result = /obj/item/ammo_casing/caseless/arrow/ash
	tools = list(TOOL_WELDER)
	time = 30
	reqs = list(/obj/item/ammo_casing/caseless/arrow/wood = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/bone_arrow
	name = "Bone Arrow"
	result = /obj/item/ammo_casing/caseless/arrow/bone
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 1,
				/obj/item/stack/sheet/sinew = 1,
				/obj/item/ammo_casing/caseless/arrow/ash = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/bronze_arrow
	name = "Bronze arrow"
	result = /obj/item/ammo_casing/caseless/arrow/bronze
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/tile/bronze = 1,
				/obj/item/stack/sheet/silk = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/////Shotgun Ammo
/datum/crafting_recipe/meteorslug
	name = "Meteorslug Shell"
	result = /obj/item/ammo_casing/shotgun/meteorslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/rcd_ammo = 1,
				/obj/item/stock_parts/manipulator = 2)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE

/datum/crafting_recipe/pulseslug
	name = "Pulse Slug Shell"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 2,
				/obj/item/stock_parts/micro_laser/ultra = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE

/datum/crafting_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1, /datum/reagent/phosphorus = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE

/datum/crafting_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid = 5,
				/datum/reagent/toxin/acid/fluacid = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE

/datum/crafting_recipe/ionslug
	name = "Ion Scatter Shell"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/micro_laser/ultra = 1,
				/obj/item/stock_parts/subspace/crystal = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE

/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/stack/sheet/metal = 2,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tools = list(TOOL_SCREWDRIVER)
	time = 12
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/laserslug
	name = "Scatter Laser Shell"
	result = /obj/item/ammo_casing/shotgun/laserslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 1,
				/obj/item/stock_parts/micro_laser/high = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE
