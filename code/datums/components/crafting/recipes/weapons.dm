/////Melee
/datum/crafting_recipe/chainsaw
	name = "Chainsaw"
	result = /obj/item/chainsaw
	reqs = list(/obj/item/circular_saw = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/stack/sheet/plasteel = 5)
	tools = list(TOOL_WELDER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stunprod
	name = "Stunprod"
	result = /obj/item/melee/baton/cattleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/teleprod
	name = "Teleprod"
	result = /obj/item/melee/baton/cattleprod/teleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/ore/bluespace_crystal = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/tailclub
	name = "Tail Club"
	result = /obj/item/tailclub
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/sheet/metal = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/tailwhip
	name = "Liz O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/catwhip
	name = "Cat O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip/kitty
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/bonesword
	name = "Bone Sword"
	result = /obj/item/claymore/bone
	time = 40
	reqs = list(/obj/item/stack/sheet/bone = 3,
				/obj/item/stack/sheet/sinew = 2)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/boneaxe
	name = "Bone Axe"
	result = /obj/item/fireaxe/boneaxe
	time = 50
	reqs = list(/obj/item/stack/sheet/bone = 6,
				/obj/item/stack/sheet/sinew = 3)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/////Bows
/datum/crafting_recipe/bone_bow
	name = "Bone Bow"
	result = /obj/item/gun/ballistic/bow/ashen
	time = 200
	reqs = list(/obj/item/stack/sheet/bone = 8,
				/obj/item/stack/sheet/sinew = 4)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/pipebow
	name = "Pipe Bow"
	result = /obj/item/gun/ballistic/bow/pipe
	reqs = list(/obj/item/pipe = 5,
				/obj/item/stack/sheet/plastic = 15,
				/obj/item/weaponcrafting/silkstring = 10)
	time = 450
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/////Ballistic
/datum/crafting_recipe/pipegun
	name = "Pipegun"
	result = /obj/item/gun/ballistic/rifle/boltaction/pipegun
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/sticky_tape = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/pipegun_prime
	name = "Regal Pipegun"
	result = /obj/item/gun/ballistic/rifle/boltaction/pipegun/prime
	reqs = list(/obj/item/gun/ballistic/rifle/boltaction/pipegun = 1,
				/obj/item/food/deadmouse = 1,
				/datum/reagent/consumable/grey_bull = 20,
				/obj/item/spear = 1,
				/obj/item/storage/toolbox= 1)
	tools = list(TOOL_SCREWDRIVER, /obj/item/clothing/gloves/color/yellow, /obj/item/clothing/mask/gas, /obj/item/melee/baton/cattleprod)
	time = 300 //contemplate for a bit
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/////Thrown
/datum/crafting_recipe/spear
	name = "Spear"
	result = /obj/item/spear
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/shard = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/shard = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/bonespear
	name = "Bone Spear"
	result = /obj/item/spear/bonespear
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 4,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/bola
	name = "Bola"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/metal = 6)
	time = 20//15 faster than crafting them by hand!
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/watcherbola
	name = "Watcher Bola"
	result = /obj/item/restraints/legcuffs/bola/watcher
	time = 30
	reqs = list(/obj/item/stack/sheet/animalhide/goliath_hide = 2,
				/obj/item/restraints/handcuffs/cable/sinew = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gonbola
	name = "Gonbola"
	result = /obj/item/restraints/legcuffs/bola/gonbola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/metal = 6,
				/obj/item/stack/sheet/animalhide/gondola = 1)
	time = 40
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/////Shield
/datum/crafting_recipe/goliathshield
	name = "Goliath shield"
	result = /obj/item/shield/riot/goliath
	time = 60
	reqs = list(/obj/item/stack/sheet/bone = 4,
				/obj/item/stack/sheet/animalhide/goliath_hide = 3)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/strobeshield
	name = "Strobe Shield"
	result = /obj/item/shield/riot/flash
	reqs = list(/obj/item/wallframe/flasher = 1,
				/obj/item/assembly/flash/handheld = 1,
				/obj/item/shield/riot = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/strobeshield/New()
	..()
	blacklist |= subtypesof(/obj/item/shield/riot/)

/////Energy Weapons
/datum/crafting_recipe/advancedegun
	name = "Advanced Energy Gun"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/e_gun/nuclear
	reqs = list(/obj/item/gun/energy/e_gun = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/nuclear = 1)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/advancedegun/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/e_gun)

/datum/crafting_recipe/tempgun
	name = "Temperature Gun"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/temperature
	reqs = list(/obj/item/gun/energy/e_gun = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/temperature = 1)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/tempgun/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/e_gun)

/datum/crafting_recipe/beam_rifle
	name = "Particle Acceleration Rifle"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/beam_rifle
	reqs = list(/obj/item/gun/energy/e_gun = 1,
				/obj/item/assembly/signaler/anomaly/flux = 1,
				/obj/item/assembly/signaler/anomaly/grav = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/beam_rifle = 1)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/beam_rifle/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/e_gun)

/datum/crafting_recipe/ebow
	name = "Energy Crossbow"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/kinetic_accelerator/crossbow/large
	reqs = list(/obj/item/gun/energy/kinetic_accelerator = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/ebow = 1,
				/datum/reagent/uranium/radium = 15)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/ebow/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/kinetic_accelerator)

/datum/crafting_recipe/xraylaser
	name = "X-ray Laser Gun"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/xray
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/xray = 1)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/xraylaser/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/hellgun
	name = "Hellfire Laser Gun"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/laser/hellgun
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/hellgun = 1)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/hellgun/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/ioncarbine
	name = "Ion Carbine"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/ionrifle/carbine
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/ion = 1)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/ioncarbine/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/decloner
	name = "Biological Demolecularisor"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/decloner
	reqs = list(/obj/item/gun/energy/laser = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/decloner = 1,
				/datum/reagent/baldium = 30,
				/datum/reagent/toxin/mutagen = 40)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/decloner/New()
	..()
	blacklist += subtypesof(/obj/item/gun/energy/laser)

/datum/crafting_recipe/teslacannon
	name = "Tesla Cannon"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/gun/energy/tesla_cannon
	reqs = list(/obj/item/assembly/signaler/anomaly/flux = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/tesla = 1)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/////Explosives
/datum/crafting_recipe/improv_explosive
	name = "IED"
	result = /obj/item/grenade/iedcasing
	reqs = list(/datum/reagent/fuel = 50,
				/obj/item/stack/cable_coil = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/molotov
	name = "Molotov"
	result = /obj/item/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/reagent_containers/glass/rag = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/chemical_payload
	name = "Chemical Payload (C4)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/chemical_payload2
	name = "Chemical Payload (Gibtonite)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE

/datum/crafting_recipe/lance
	name = "Explosive Lance (Grenade)"
	result = /obj/item/spear/explosive
	reqs = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	blacklist = list(/obj/item/spear/bonespear)
	parts = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/////MISC
/datum/crafting_recipe/improvised_pneumatic_cannon //Pretty easy to obtain but
	name = "Pneumatic Cannon"
	result = /obj/item/pneumatic_cannon/ghetto
	tools = list(TOOL_WELDER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/package_wrap = 8,
				/obj/item/pipe = 2)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/flamethrower
	name = "Flamethrower"
	result = /obj/item/flamethrower
	reqs = list(/obj/item/weldingtool = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/assembly/igniter = 1,
				/obj/item/weldingtool = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_available = FALSE
