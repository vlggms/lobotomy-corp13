
/datum/crafting_recipe
	var/name = "" //in-game display name
	var/list/reqs = list() //type paths of items consumed associated with how many are needed
	var/list/blacklist = list() //type paths of items explicitly not allowed as an ingredient
	var/result //type path of item resulting from this craft
	var/list/tools = list() //type paths of items needed but not consumed
	var/time = 30 //time in deciseconds
	var/list/parts = list() //type paths of items that will be placed in the result
	var/list/chem_catalysts = list() //like tools but for reagents
	var/category = CAT_NONE //where it shows up in the crafting UI
	var/subcategory = CAT_NONE
	var/always_available = TRUE //Set to FALSE if it needs to be learned first.
	/// Additonal requirements text shown in UI
	var/additional_req_text

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result

/**
 * Run custom pre-craft checks for this recipe
 *
 * user: The /mob that initiated the crafting
 * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
 */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE

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

/datum/crafting_recipe/strobeshield
	name = "Strobe Shield"
	result = /obj/item/shield/riot/flash
	reqs = list(/obj/item/wallframe/flasher = 1,
				/obj/item/assembly/flash/handheld = 1,
				/obj/item/shield/riot = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/strobeshield/New()
	..()
	blacklist |= subtypesof(/obj/item/shield/riot/)

/datum/crafting_recipe/molotov
	name = "Molotov"
	result = /obj/item/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/reagent_containers/glass/rag = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle = 1)
	time = 40
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

/datum/crafting_recipe/bola
	name = "Bola"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/metal = 6)
	time = 20//15 faster than crafting them by hand!
	category= CAT_WEAPONRY
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

/datum/crafting_recipe/tailclub
	name = "Tail Club"
	result = /obj/item/tailclub
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/sheet/metal = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/tailwhip
	name = "Liz O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/catwhip
	name = "Cat O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip/kitty
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/reciever
	name = "Modular Rifle Reciever"
	tools = list(TOOL_WRENCH, TOOL_WELDER, TOOL_SAW)
	result = /obj/item/weaponcrafting/receiver
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/sticky_tape = 1,
				/obj/item/screwdriver = 1,
				/obj/item/assembly/mousetrap = 1)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/riflestock
	name = "Wooden Rifle Stock"
	tools = list(/obj/item/hatchet)
	result = /obj/item/weaponcrafting/stock
	reqs = list(/obj/item/stack/sheet/mineral/wood = 8,
				/obj/item/stack/sticky_tape = 1)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

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

/datum/crafting_recipe/ed209
	name = "ED209"
	result = /mob/living/simple_animal/bot/secbot/ed209
	reqs = list(/obj/item/robot_suit = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/clothing/suit/armor/vest = 1,
				/obj/item/bodypart/l_leg/robot = 1,
				/obj/item/bodypart/r_leg/robot = 1,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/gun/energy/disabler = 1,
				/obj/item/assembly/prox_sensor = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/secbot
	name = "Secbot"
	result = /mob/living/simple_animal/bot/secbot
	reqs = list(/obj/item/assembly/signaler = 1,
				/obj/item/clothing/head/helmet/sec = 1,
				/obj/item/melee/baton = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	tools = list(TOOL_WELDER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/cleanbot
	name = "Cleanbot"
	result = /mob/living/simple_animal/bot/cleanbot
	reqs = list(/obj/item/reagent_containers/glass/bucket = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/floorbot
	name = "Floorbot"
	result = /mob/living/simple_animal/bot/floorbot
	reqs = list(/obj/item/storage/toolbox = 1,
				/obj/item/stack/tile/plasteel = 10,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/medbot
	name = "Medbot"
	result = /mob/living/simple_animal/bot/medbot
	reqs = list(/obj/item/healthanalyzer = 1,
				/obj/item/storage/firstaid = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/honkbot
	name = "Honkbot"
	result = /mob/living/simple_animal/bot/honkbot
	reqs = list(/obj/item/storage/box/clown = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bikehorn/ = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/firebot
	name = "Firebot"
	result = /mob/living/simple_animal/bot/firebot
	reqs = list(/obj/item/extinguisher = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/clothing/head/hardhat/red = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/vibebot
	name = "Vibebot"
	result = /mob/living/simple_animal/bot/vibebot
	reqs = list(/obj/item/light/bulb = 2,
				/obj/item/bodypart/head/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/toy/crayon = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/hygienebot
	name = "Hygienebot"
	result = /mob/living/simple_animal/bot/hygienebot
	reqs = list(/obj/item/bot_assembly/hygienebot = 1,
				/obj/item/stack/ducts = 1,
				/obj/item/assembly/prox_sensor = 1)
	tools = list(TOOL_WELDER)
	time = 40
	category = CAT_ROBOT

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

/datum/crafting_recipe/pipebow
	name = "Pipe Bow"
	result = /obj/item/gun/ballistic/bow/pipe
	reqs = list(/obj/item/pipe = 5,
				/obj/item/stack/sheet/plastic = 15,
				/obj/item/weaponcrafting/silkstring = 10)
	time = 450
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

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

/datum/crafting_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1, /datum/reagent/phosphorus = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

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

/datum/crafting_recipe/arrow
	name = "Arrow"
	result = /obj/item/ammo_casing/caseless/arrow/wood
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/sheet/silk = 1,
				/obj/item/stack/rods = 1) //1 metal sheet = 2 rods= 2 arrows
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

/datum/crafting_recipe/ashen_arrow
	name = "Fire hardened arrow"
	result = /obj/item/ammo_casing/caseless/arrow/ash
	tools = list(TOOL_WELDER)
	time = 30
	reqs = list(/obj/item/ammo_casing/caseless/arrow/wood = 1)
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
	always_available = FALSE
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

/datum/crafting_recipe/lizardhat
	name = "Lizard Cloche Hat"
	result = /obj/item/clothing/head/lizard
	time = 10
	reqs = list(/obj/item/organ/tail/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardhat_alternate
	name = "Lizard Cloche Hat"
	result = /obj/item/clothing/head/lizard
	time = 10
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/kittyears
	name = "Kitty Ears"
	result = /obj/item/clothing/head/kitty/genuine
	time = 10
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/organ/ears/cat = 1)
	category = CAT_CLOTHING


/datum/crafting_recipe/radiogloves
	name = "Radio Gloves"
	result = /obj/item/clothing/gloves/radio
	time = 15
	reqs = list(/obj/item/clothing/gloves/color/black = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/radio = 1)
	tools = list(TOOL_WIRECUTTER)
	category = CAT_CLOTHING

/datum/crafting_recipe/mixedbouquet
	name = "Mixed bouquet"
	result = /obj/item/bouquet
	reqs = list(/obj/item/food/grown/poppy/lily =2,
				/obj/item/grown/sunflower = 2,
				/obj/item/food/grown/poppy/geranium = 2)
	category = CAT_MISC

/datum/crafting_recipe/sunbouquet
	name = "Sunflower bouquet"
	result = /obj/item/bouquet/sunflower
	reqs = list(/obj/item/grown/sunflower = 6)
	category = CAT_MISC

/datum/crafting_recipe/poppybouquet
	name = "Poppy bouquet"
	result = /obj/item/bouquet/poppy
	reqs = list (/obj/item/food/grown/poppy = 6)
	category = CAT_MISC

/datum/crafting_recipe/spooky_camera
	name = "Camera Obscura"
	result = /obj/item/camera/spooky
	time = 15
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	category = CAT_MISC

/*
/datum/crafting_recipe/skateboard
	name = "Skateboard"
	result = /obj/vehicle/ridden/scooter/skateboard/improvised
	time = 60
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 10)
	category = CAT_MISC

/datum/crafting_recipe/scooter
	name = "Scooter"
	result = /obj/vehicle/ridden/scooter
	time = 65
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 12)
	category = CAT_MISC
*/

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/rods = 6)
	time = 100
	category = CAT_MISC

/datum/crafting_recipe/motorized_wheelchair
	name = "Motorized Wheelchair"
	result = /obj/vehicle/ridden/wheelchair/motorized
	reqs = list(/obj/item/stack/sheet/metal = 10,
		/obj/item/stack/rods = 8,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	parts = list(/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 200
	category = CAT_MISC

/datum/crafting_recipe/mousetrap
	name = "Mouse Trap"
	result = /obj/item/assembly/mousetrap
	time = 10
	reqs = list(/obj/item/stack/sheet/cardboard = 1,
				/obj/item/stack/rods = 1)
	category = CAT_MISC

/datum/crafting_recipe/papersack
	name = "Paper Sack"
	result = /obj/item/storage/box/papersack
	time = 10
	reqs = list(/obj/item/paper = 5)
	category = CAT_MISC


/datum/crafting_recipe/flashlight_eyes
	name = "Flashlight Eyes"
	result = /obj/item/organ/eyes/robotic/flashlight
	time = 10
	reqs = list(
		/obj/item/flashlight = 2,
		/obj/item/restraints/handcuffs/cable = 1
	)
	category = CAT_MISC

/datum/crafting_recipe/paperframes
	name = "Paper Frames"
	result = /obj/item/stack/sheet/paperframes/five
	time = 10
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5, /obj/item/paper = 20)
	category = CAT_MISC

/datum/crafting_recipe/naturalpaper
	name = "Hand-Pressed Paper"
	time = 30
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/sheet/mineral/wood = 1)
	tools = list(/obj/item/hatchet)
	result = /obj/item/paper_bin/bundlenatural
	category = CAT_MISC

/datum/crafting_recipe/toysword
	name = "Toy Sword"
	reqs = list(/obj/item/light/bulb = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/sheet/plastic = 4)
	result = /obj/item/toy/sword
	category = CAT_MISC

/datum/crafting_recipe/blackcarpet
	name = "Black Carpet"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	category = CAT_MISC

/datum/crafting_recipe/curtain
	name = "Curtains"
	reqs = 	list(/obj/item/stack/sheet/cotton/cloth = 4, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain/cloth
	category = CAT_MISC

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = 	list(/obj/item/stack/sheet/cotton/cloth = 2, /obj/item/stack/sheet/plastic = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	category = CAT_MISC

/datum/crafting_recipe/extendohand_r
	name = "Extendo-Hand (Right Arm)"
	reqs = list(/obj/item/bodypart/r_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_MISC

/datum/crafting_recipe/extendohand_l
	name = "Extendo-Hand (Left Arm)"
	reqs = list(/obj/item/bodypart/l_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_MISC

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

/datum/crafting_recipe/bonearmor
	name = "Bone Armor"
	result = /obj/item/clothing/suit/armor/bone
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 6)
	category = CAT_PRIMAL

/datum/crafting_recipe/heavybonearmor
	name = "Heavy Bone Armor"
	result = /obj/item/clothing/suit/hooded/cloak/bone
	time = 80
	reqs = list(/obj/item/stack/sheet/bone = 10,
				/obj/item/stack/sheet/sinew = 3,
				/obj/item/stack/sheet/animalhide/goliath_hide = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonetalisman
	name = "Bone Talisman"
	result = /obj/item/clothing/accessory/talisman
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonecodpiece
	name = "Skull Codpiece"
	result = /obj/item/clothing/accessory/skullcodpiece
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/skilt
	name = "Sinew Kilt"
	result = /obj/item/clothing/accessory/skilt
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 1,
				/obj/item/stack/sheet/sinew = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/bracers
	name = "Bone Bracers"
	result = /obj/item/clothing/gloves/bracer
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/skullhelm
	name = "Skull Helmet"
	result = /obj/item/clothing/head/helmet/skull
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 4)
	category = CAT_PRIMAL

/datum/crafting_recipe/goliathcloak
	name = "Goliath Cloak"
	result = /obj/item/clothing/suit/hooded/cloak/goliath
	time = 50
	reqs = list(/obj/item/stack/sheet/leather = 2,
				/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 2) //it takes 4 goliaths to make 1 cloak if the plates are skinned
	category = CAT_PRIMAL

/datum/crafting_recipe/drakecloak
	name = "Ash Drake Armour"
	result = /obj/item/clothing/suit/hooded/cloak/drake
	time = 60
	reqs = list(/obj/item/stack/sheet/bone = 10,
				/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/ashdrake = 5)
	category = CAT_PRIMAL

/datum/crafting_recipe/watcherbola
	name = "Watcher Bola"
	result = /obj/item/restraints/legcuffs/bola/watcher
	time = 30
	reqs = list(/obj/item/stack/sheet/animalhide/goliath_hide = 2,
				/obj/item/restraints/handcuffs/cable/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/goliathshield
	name = "Goliath shield"
	result = /obj/item/shield/riot/goliath
	time = 60
	reqs = list(/obj/item/stack/sheet/bone = 4,
				/obj/item/stack/sheet/animalhide/goliath_hide = 3)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonesword
	name = "Bone Sword"
	result = /obj/item/claymore/bone
	time = 40
	reqs = list(/obj/item/stack/sheet/bone = 3,
				/obj/item/stack/sheet/sinew = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/hunterbelt
	name = "Hunters Belt"
	result = /obj/item/storage/belt/mining/primitive
	time = 20
	reqs = list(/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/quiver
	name = "Quiver"
	result = /obj/item/storage/bag/quiver/empty
	time = 80
	reqs = list(/obj/item/stack/sheet/leather = 3,
				/obj/item/stack/sheet/sinew = 4)
	category = CAT_PRIMAL

/datum/crafting_recipe/bone_bow
	name = "Bone Bow"
	result = /obj/item/gun/ballistic/bow/ashen
	time = 200
	reqs = list(/obj/item/stack/sheet/bone = 8,
				/obj/item/stack/sheet/sinew = 4)
	category = CAT_PRIMAL

/datum/crafting_recipe/firebrand
	name = "Firebrand"
	result = /obj/item/match/firebrand
	time = 100 //Long construction time. Making fire is hard work.
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/gold_horn
	name = "Golden Bike Horn"
	result = /obj/item/bikehorn/golden
	time = 20
	reqs = list(/obj/item/stack/sheet/mineral/bananium = 5,
				/obj/item/bikehorn = 1)
	category = CAT_MISC

/datum/crafting_recipe/bonedagger
	name = "Bone Dagger"
	result = /obj/item/kitchen/knife/combat/bone
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonespear
	name = "Bone Spear"
	result = /obj/item/spear/bonespear
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 4,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/boneaxe
	name = "Bone Axe"
	result = /obj/item/fireaxe/boneaxe
	time = 50
	reqs = list(/obj/item/stack/sheet/bone = 6,
				/obj/item/stack/sheet/sinew = 3)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonfire
	name = "Bonfire"
	time = 60
	reqs = list(/obj/item/grown/log = 5)
	parts = list(/obj/item/grown/log = 5)
	blacklist = list(/obj/item/grown/log/steel)
	result = /obj/structure/bonfire
	category = CAT_PRIMAL

/datum/crafting_recipe/rake //Category resorting incoming
	name = "Rake"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	result = /obj/item/cultivator/rake
	category = CAT_PRIMAL

/datum/crafting_recipe/woodbucket
	name = "Wooden Bucket"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	result = /obj/item/reagent_containers/glass/bucket/wooden
	category = CAT_PRIMAL

/datum/crafting_recipe/headpike
	name = "Spike Head (Glass Spear)"
	time = 65
	reqs = list(/obj/item/spear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear = 1)
	blacklist = list(/obj/item/spear/explosive, /obj/item/spear/bonespear)
	result = /obj/structure/headpike
	category = CAT_PRIMAL

/datum/crafting_recipe/headpikebone
	name = "Spike Head (Bone Spear)"
	time = 65
	reqs = list(/obj/item/spear/bonespear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear/bonespear = 1)
	result = /obj/structure/headpike/bone
	category = CAT_PRIMAL

/datum/crafting_recipe/pressureplate
	name = "Pressure Plate"
	result = /obj/item/pressure_plate
	time = 5
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/tile/plasteel = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/assembly/igniter = 1)
	category = CAT_MISC


/datum/crafting_recipe/rcl
	name = "Makeshift Rapid Pipe Cleaner Layer"
	result = /obj/item/rcl/ghetto
	time = 40
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/metal = 15)
	category = CAT_MISC

/datum/crafting_recipe/mummy
	name = "Mummification Bandages (Mask)"
	result = /obj/item/clothing/mask/mummy
	time = 10
	tools = list(/obj/item/nullrod/egyptian)
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy/body
	name = "Mummification Bandages (Body)"
	result = /obj/item/clothing/under/costume/mummy
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 5)

/datum/crafting_recipe/chaplain_hood
	name = "Follower Hoodie"
	result = /obj/item/clothing/suit/hooded/chaplain_hoodie
	time = 10
	tools = list(/obj/item/clothing/suit/hooded/chaplain_hoodie, /obj/item/storage/book/bible)
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/mineral/wood = 20,
				/obj/item/stack/cable_coil = 10)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_MISC

/datum/crafting_recipe/aitater
	name = "intelliTater"
	result = /obj/item/aicard/aitater
	time = 30
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
					/obj/item/food/grown/potato = 1,
					/obj/item/stack/cable_coil = 5)
	category = CAT_MISC

/datum/crafting_recipe/aitater/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/aicard/aicard = collected_requirements[/obj/item/aicard][1]
	if(!aicard.AI)
		return TRUE

	to_chat(user, "<span class='boldwarning'>You can't craft an intelliTater with an AI in the card!</span>")
	return FALSE

/datum/crafting_recipe/aispook
	name = "intelliLantern"
	result = /obj/item/aicard/aispook
	time = 30
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
					/obj/item/food/grown/pumpkin = 1,
					/obj/item/stack/cable_coil = 5)
	category = CAT_MISC

/datum/crafting_recipe/ghettojetpack
	name = "Improvised Jetpack"
	result = /obj/item/tank/jetpack/improvised
	time = 30
	reqs = list(/obj/item/tank/internals/oxygen = 2, /obj/item/extinguisher = 1, /obj/item/pipe = 3, /obj/item/stack/cable_coil = MAXCOIL)
	category = CAT_MISC
	tools = list(TOOL_WRENCH, TOOL_WELDER, TOOL_WIRECUTTER)

/datum/crafting_recipe/multiduct
	name = "Multi-layer duct"
	result = /obj/machinery/duct/multilayered
	time = 5
	reqs = list(/obj/item/stack/ducts = 5)
	category = CAT_MISC
	tools = list(TOOL_WELDER)

/datum/crafting_recipe/rib
	name = "Collosal Rib"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 10,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/rib
	subcategory = CAT_PRIMAL

/datum/crafting_recipe/skull
	name = "Skull Carving"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 6,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull
	category = CAT_PRIMAL

/datum/crafting_recipe/halfskull
	name = "Cracked Skull Carving"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 3,
		/datum/reagent/fuel/oil = 5,
	)
	result = /obj/structure/statue/bone/skull/half
	category = CAT_PRIMAL

/datum/crafting_recipe/boneshovel
	name = "Serrated Bone Shovel"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/datum/reagent/fuel/oil = 5,
		/obj/item/shovel/spade = 1,
	)
	result = /obj/item/shovel/serrated
	category = CAT_PRIMAL

/datum/crafting_recipe/lasso
	name = "Bone Lasso"
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 5,
	)
	result = /obj/item/key/lasso
	category = CAT_PRIMAL

/datum/crafting_recipe/gripperoffbrand
	name = "Improvised Gripper Gloves"
	reqs = list(
		/obj/item/clothing/gloves/fingerless = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	result = /obj/item/clothing/gloves/tackler/offbrand
	category = CAT_CLOTHING

/datum/crafting_recipe/boh
	name = "Bag of Holding"
	reqs = list(
		/obj/item/bag_of_holding_inert = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
	)
	result = /obj/item/storage/backpack/holding
	category = CAT_CLOTHING

/datum/crafting_recipe/ipickaxe
	name = "Improvised Pickaxe"
	reqs = list(
		/obj/item/crowbar = 1,
		/obj/item/kitchen/knife = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	result = /obj/item/pickaxe/improvised
	category = CAT_MISC

/datum/crafting_recipe/elder_atmosian_statue
	name = "Elder Atmosian Statue"
	result = /obj/structure/statue/elder_atmosian
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/metal_hydrogen = 10,
				/obj/item/grenade/gas_crystal/healium_crystal = 1,
				/obj/item/grenade/gas_crystal/proto_nitrate_crystal = 1,
				/obj/item/grenade/gas_crystal/zauker_crystal = 1
				)
	category = CAT_MISC

/datum/crafting_recipe/shutters
	name = "Shutters"
	reqs = list(/obj/item/stack/sheet/plasteel = 10,
				/obj/item/stack/cable_coil = 10,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/shutters/preopen
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 15 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/blast_doors
	name = "Blast Door"
	reqs = list(/obj/item/stack/sheet/plasteel = 15,
				/obj/item/stack/cable_coil = 15,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/preopen
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 30 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/aquarium
	name = "Aquarium"
	result = /obj/structure/aquarium
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 15,
				/obj/item/stack/sheet/glass = 10,
				/obj/item/aquarium_kit = 1
				)
	category = CAT_MISC

//Carnival Recipes
/datum/crafting_recipe/indigo_armor
	name = "Sweeper Suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/indigo_armor
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/green_armor
	name = "Doubting Suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/green_armor
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/amber_armor
	name = "Hunger Suit"
	result = /obj/item/clothing/suit/armor/ego_gear/city/amber_armor
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/steel_armor
	name = "Soldier's Uniform"
	result = /obj/item/clothing/suit/armor/ego_gear/city/steel_armor
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 3)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/carnival_robes
	name = "Carnival's Robes"
	result = /obj/item/clothing/suit/armor/ego_gear/city/carnival_robes
	reqs = list(/obj/item/stack/sheet/silk/indigo_advanced = 3,
				/obj/item/stack/sheet/silk/green_advanced = 3,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

//Meat Crafting
/datum/crafting_recipe/amber_silk_simple
	name = "Simple Amber Silk"
	result = /obj/item/stack/sheet/silk/amber_simple
	reqs = list(/obj/item/food/meat/slab/worm = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/steel_silk_simple
	name = "Simple Steel Silk"
	result = /obj/item/stack/sheet/silk/steel_simple
	reqs = list(/obj/item/food/meat/slab/human/mutant/moth = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/indigo_silk_simple
	name = "Simple Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_simple
	reqs = list(/obj/item/food/meat/slab/sweeper = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/green_silk_simple
	name = "Simple Green Silk"
	result = /obj/item/stack/sheet/silk/green_simple
	reqs = list(/obj/item/food/meat/slab/robot = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/indigo_silk_advanced
	name = "Advanced Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_advanced
	reqs = list(/obj/item/food/meat/slab/sweeper = 6)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/green_silk_advanced
	name = "Advanced Green Silk"
	result = /obj/item/stack/sheet/silk/green_advanced
	reqs = list(/obj/item/food/meat/slab/robot = 6)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING
//Converted Silk Crafts
/datum/crafting_recipe/converted_green_silk_advanced
	name = "Converted Advanced Green Silk"
	result = /obj/item/stack/sheet/silk/green_advanced
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/converted_green_silk_elegant
	name = "Converted Elegant Green Silk"
	result = /obj/item/stack/sheet/silk/green_elegant
	reqs = list(/obj/item/stack/sheet/silk/green_advanced = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/converted_indigo_silk_advanced
	name = "Converted Advanced Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_advanced
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/converted_indigo_silk_elegant
	name = "Converted Elegant Indigo Silk"
	result = /obj/item/stack/sheet/silk/indigo_elegant
	reqs = list(/obj/item/stack/sheet/silk/indigo_advanced = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/converted_amber_silk_advanced
	name = "Converted Advanced Amber Silk"
	result = /obj/item/stack/sheet/silk/amber_advanced
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/converted_steel_silk_advanced
	name = "Converted Advanced Steel Silk"
	result = /obj/item/stack/sheet/silk/steel_advanced
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 5)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/converted_human_silk_advanced
	name = "Converted Advanced Human Silk"
	result = /obj/item/stack/sheet/silk/human_advanced
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 4)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/converted_human_silk_elegant
	name = "Converted Elegant Human Silk"
	result = /obj/item/stack/sheet/silk/human_elegant
	reqs = list(/obj/item/stack/sheet/silk/human_advanced = 4)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

//Silk into different Silk
/datum/crafting_recipe/green_silk_to_steel_silk
	name = "Green Silk to Steel Silk"
	result = /obj/item/stack/sheet/silk/steel_simple
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/indigo_silk_to_amber_silk
	name = "Indigo Silk to Amber Silk"
	result = /obj/item/stack/sheet/silk/amber_simple
	reqs = list(/obj/item/stack/sheet/silk/indigo_simple = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 5
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

/datum/crafting_recipe/blade_lineage_cutthroat
	name = "Blade Lineage Cutthroat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_cutthroat
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 4,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/blade_lineage_admin
	name = "Blade Lineage Admin"
	result = /obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 4,
				/obj/item/stack/sheet/silk/amber_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

/datum/crafting_recipe/index_proxy
	name = "Index Proxy Armor"
	result = /obj/item/clothing/suit/armor/ego_gear/adjustable/index_proxy
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/steel_simple = 2,
				/obj/item/stack/sheet/silk/indigo_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

/datum/crafting_recipe/kurokumo_jacket
	name = "Kurokumo Enforcer Dress Shirt"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo/jacket
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 5,
				/obj/item/stack/sheet/silk/indigo_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/kurokumo_captain
	name = "Kurokumo Captain Kimono"
	result = /obj/item/clothing/suit/armor/ego_gear/city/kurokumo/captain
	reqs = list(/obj/item/stack/sheet/silk/steel_simple = 5,
				/obj/item/stack/sheet/silk/indigo_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

/datum/crafting_recipe/liu_jacket
	name = "Liu Association combat jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liu/section5
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/liu_coat
	name = "Liu Association combat coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuvet
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/liu_combat_coat
	name = "Liu Association section 2 combat coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuvet/section2
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/liu_combat_jacket
	name = "Liu Association veteran combat jacket"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuvet/section5
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/liu_heavy_coat
	name = "Liu Association heavy combat coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuleader
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/liu_officer_coat
	name = "Liu Association officer coat"
	result = /obj/item/clothing/suit/armor/ego_gear/city/liuleader/section5
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/amber_advanced = 5,
				/obj/item/stack/sheet/silk/human_elegant = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

/datum/crafting_recipe/ncorp_vet
	name = "Decorated Nagel und Hammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorp/vet
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 2,
				/obj/item/stack/sheet/silk/human_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/ncorp_grosshammmer
	name = "Nagel und Hammer Grosshammer armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/grosshammmer
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 4,
				/obj/item/stack/sheet/silk/human_elegant = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/ncorpcommander
	name = "Rüstung der auserwählten Frau Gottes"
	result = /obj/item/clothing/suit/armor/ego_gear/city/ncorpcommander
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 5,
				/obj/item/stack/sheet/silk/human_masterpiece = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/ncorp_white_mark
	name = "Ncorp White mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/white
	reqs = list(/obj/item/stack/sheet/silk/green_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/ncorp_black_mark
	name = "Ncorp Black mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/black
	reqs = list(/obj/item/stack/sheet/silk/indigo_advanced = 2)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/ncorp_pale_mark
	name = "Ncorp Pale mark"
	result = /obj/item/ego_weapon/city/ncorp_mark/pale
	reqs = list(/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

/datum/crafting_recipe/seven_vet
	name = "Seven Association veteran armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/sevenvet
	reqs = list(/obj/item/stack/sheet/silk/amber_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 4,
				/obj/item/stack/sheet/silk/human_advanced = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

/datum/crafting_recipe/zwei_junior
	name = "Zwei Association junior armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/zweijunior
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 3,
				/obj/item/stack/sheet/silk/indigo_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

/datum/crafting_recipe/zwei_riot
	name = "Zwei Association riot armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/zweiriot
	reqs = list(/obj/item/stack/sheet/silk/green_simple = 5,
				/obj/item/stack/sheet/silk/green_advanced = 3,
				/obj/item/stack/sheet/silk/human_simple = 1)
	tools = list(/obj/item/silkknife = 1)
	time = 10
	always_available = FALSE
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING

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
	category = CAT_CLOTHING
