/obj/machinery/vending/hana
	name = "\improper Hana vending"
	desc = "A machine used to start your own office!."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	product_slogans = "Start your career today!"
	product_ads = "The best in the business!"
	icon_state = "generic" //Placeholder
	icon_deny = null
	products = list(
		/obj/item/clothing/accessory/lawyers_badge/fixer = 50,
		/obj/item/radio/headset = 50,

		//custom fixer office (and garbage) stuff is free.
		/obj/item/storage/box/fixerhard/streetlight = 1,
		/obj/item/storage/box/fixerhard/yun = 1,
		/obj/item/storage/box/miscarmor = 1,
		/obj/item/storage/box/miscarmor/two = 1,
		/obj/item/storage/box/miscarmor/three = 1,
		/obj/item/storage/box/miscarmor/four = 1,
		/obj/item/storage/box/miscarmor/five = 1,
		/obj/item/storage/box/miscarmor/six = 1,
	)

	premium = list(
		//The office stuff
		/obj/item/structurecapsule/fixer = 1,	//fishing
		/obj/item/structurecapsule/fixer/combat = 2,
		/obj/item/structurecapsule/fixer/protection = 2,
		/obj/item/structurecapsule/fixer/workshop = 1,
		/obj/item/structurecapsule/fixer/recon = 1,
		/obj/item/structurecapsule/fixer/peacekeeper = 1,

		//Boxes cost you an extra 700
		/obj/item/storage/box/fixer/wedge = 1,
		/obj/item/storage/box/fixer/dawn = 1,
		/obj/item/storage/box/fixer/fullstop = 1,
	)

	default_price = 0
	extra_price = 1400
	input_display_header = "Hana Vending"

//cityvending
/obj/machinery/vending/city_clothing
	name = "\improper City Fashion vending"
	desc = "A machine used to purchase your clothing"
	product_slogans = "Looking good!"
	product_ads = "You need it!"
	icon_state = "curadrobe"
	icon_deny = null
	products = list(
		/obj/item/clothing/under/suit/white_on_white = 5,
		/obj/item/clothing/under/suit/black = 5,
		/obj/item/clothing/under/suit/black_really = 5,
		/obj/item/clothing/under/suit/green = 5,
		/obj/item/clothing/under/suit/red = 5,
		/obj/item/clothing/under/suit/checkered = 5,
		/obj/item/clothing/under/suit/navy = 5,
		/obj/item/clothing/under/suit/tan = 5,
		/obj/item/clothing/under/suit/white = 5,
		/obj/item/clothing/under/rank/security/officer/blueshirt = 5,
		/obj/item/clothing/under/rank/security/detective = 5,
		/obj/item/flashlight/seclite = 100,
	)

	default_price = 50
	input_display_header = "City Fashion"

//cityvending
/obj/machinery/vending/weaving
	name = "\improper Weaving Books/Tools"
	desc = "A machine used to purchase new weaving recipes!"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	product_slogans = "Read up on all of the city armor!"
	product_ads = "Can't go with out it!"
	icon_state = "sec"
	icon_deny = null
	products = list(
		/obj/item/book/granter/crafting_recipe/carnival/weaving_armor = 10,
		/obj/item/clothing/mask/carnival_mask = 25,
		/obj/item/silkknife = 10,
		/obj/item/storage/bag/silk = 10,
	)

	premium = list(
		/obj/item/book/granter/crafting_recipe/carnival/weaving_kurokumo = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_seven = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_ncorp = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_liu = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_index = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_zwei = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_shi = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_blade = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_basic_converstion = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_advanced_converstion = 1,
		/obj/item/book/granter/crafting_recipe/carnival/human_replacements = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_ordeal = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_zwei_west = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_j_corp_gangs = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_wedge = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_molar_boatworks = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_rosespanner = 1,
	)

	default_price = 100
	extra_price = 1000
	input_display_header = "Weaving Books/Tools"

/obj/machinery/vending/weaving/cheap
	default_price = 50
	extra_price = 200

//cityvending
/obj/machinery/vending/fixer
	name = "\improper Fixer Equipment vending"
	desc = "A machine used by fixers to get equipment"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	product_slogans = "What's a fixer without gear?"
	product_ads = "You need it!"
	icon_state = "robotics"
	icon_deny = null
	products = list(
		/obj/item/flashlight/seclite = 100,
		/obj/item/attribute_increase/fixer = 1500,
		/obj/item/radio/headset = 200,
		/obj/item/crowbar = 100,
		/obj/item/clothing/suit/armor/ego_gear/city/misc/lone = 100,
		/obj/item/ego_weapon/city/fixerblade = 20,
		/obj/item/ego_weapon/city/fixergreatsword = 20,
		/obj/item/ego_weapon/city/fixerhammer = 20,
		/obj/item/ego_weapon/city/zweibaton/protection = 20,
		/obj/item/storage/box/fishing = 20,
		/obj/item/kitchen/knife/combat/survival = 100,
		/obj/item/weldingtool/mini = 100,
		/obj/item/reagent_containers/hypospray/medipen/mental = 100,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 100,
		/obj/item/gps/fixer = 100,
	)

	premium = list(
		/obj/item/storage/firstaid/regular = 100,
		// Skills Below:
		//Level 1
		/obj/item/book/granter/action/skill/dash = 100,
		/obj/item/book/granter/action/skill/dashback = 100,
		/obj/item/book/granter/action/skill/assault = 100,
		/obj/item/book/granter/action/skill/retreat = 100,
		/obj/item/book/granter/action/skill/smokedash = 100,
		/obj/item/book/granter/action/skill/skulk = 100,
		/obj/item/book/granter/action/skill/healing = 100,
		/obj/item/book/granter/action/skill/soothing = 100,
		/obj/item/book/granter/action/skill/curing = 100,
		/obj/item/book/granter/action/skill/hunkerdown = 100,
		/obj/item/book/granter/action/skill/firstaid = 100,
		/obj/item/book/granter/action/skill/meditation = 100,
		//Level 2
		/obj/item/book/granter/action/skill/shockwave = 100,
		/obj/item/book/granter/action/skill/butcher = 100,
		/obj/item/book/granter/action/skill/confusion = 100,
		/obj/item/book/granter/action/skill/solarflare = 100,
		/obj/item/book/granter/action/skill/lifesteal = 100,
		/obj/item/book/granter/action/skill/lockpick = 100,
		//Level 3
		/obj/item/book/granter/action/skill/healthhud = 100,
		/obj/item/book/granter/action/skill/bulletproof = 100,
		/obj/item/book/granter/action/skill/battleready = 100,
		/obj/item/book/granter/action/skill/fleetfoot = 100,
		//Level 4
		/obj/item/book/granter/action/skill/timestop = 100,
		/obj/item/book/granter/action/skill/reraise = 100,
		/obj/item/book/granter/action/skill/dismember = 100,
		/obj/item/book/granter/action/skill/warbanner = 100,
		/obj/item/book/granter/action/skill/warcry = 100,
		/obj/item/book/granter/action/skill/nuke = 100,
	)

	default_price = 300
	extra_price = 1000
	input_display_header = "Fixer Equipment"



//cityvending
/obj/machinery/vending/city
	name = "\improper City Equipment vending"
	desc = "A machine used by city citizens"
	product_slogans = "Get what you need!"
	product_ads = "You need it!"
	icon_state = "sustenance"
	icon_deny = null
	products = list(
		/obj/item/storage/box/lights/mixed = 200,
		/obj/item/reagent_containers/spray/cleaner = 200,
		/obj/item/wirecutters = 200,
		/obj/item/pda = 200,
	)

/*
	premium = list(

)
*/

	default_price = 50
	extra_price = 700
	input_display_header = "City Equipment"



//cityvending
/obj/machinery/vending/prosthetic
	name = "\improper Prosthetic plus vending"
	desc = "A machine used to purchase new prosthetic limbs"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	product_slogans = "Looking good!"
	product_ads = "You need it!"
	icon_state = "robotics"
	icon_deny = null
	products = list(
		//Healing shit
		/obj/item/weldingtool = 100,
		/obj/item/stack/cable_coil = 100,
		/obj/item/stock_parts/cell/high = 100,

		//Regular shit
		/obj/item/bodypart/head/robot = 100,
		//obj/item/bodypart/chest/robot = 100,	//currently broken
		/obj/item/bodypart/l_arm/robot = 100,
		/obj/item/bodypart/r_arm/robot = 100,
		/obj/item/bodypart/l_leg/robot = 100,
		/obj/item/bodypart/r_leg/robot = 100,
		/obj/item/organ/stomach/cybernetic/tier2 = 100,
		/obj/item/organ/heart/cybernetic/tier2 = 100,
		/obj/item/organ/lungs/cybernetic/tier2 = 100,
		/obj/item/organ/liver/cybernetic/tier2 = 100,
		/obj/item/organ/eyes/robotic/glow = 100,
		/obj/item/organ/ears/cybernetic = 100,
		/obj/item/organ/cyberimp/arm/zippy = 100,
		/obj/item/organ/cyberimp/arm/fixertools = 100,
	)

	premium = list(
		/obj/item/shears = 1,
		/obj/item/bodypart/l_arm/robot/explosive = 100,
		/obj/item/bodypart/r_arm/robot/explosive = 100,
		//obj/item/bodypart/l_arm/robot/timestop = 100,
		//obj/item/bodypart/r_arm/robot/timestop = 100,
		/obj/item/organ/cyberimp/arm/mantis = 100,
		/obj/item/organ/cyberimp/arm/mantis/black = 100,
		/obj/item/organ/cyberimp/arm/chainsword = 100,
		/obj/item/organ/cyberimp/arm/briefcase = 100,
		/obj/item/organ/cyberimp/arm/surgery = 100,
		/obj/item/organ/cyberimp/arm/overdrive = 100,
		/obj/item/organ/cyberimp/arm/observation = 100,
		/obj/item/extra_arm = 100,
		/obj/item/extra_arm/double = 100,
	)

	default_price = 300
	extra_price = 700
	input_display_header = "Prosthetic plus"


