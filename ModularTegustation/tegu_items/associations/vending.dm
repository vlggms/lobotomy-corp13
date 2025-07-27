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
		/obj/item/structurecapsule/fixer/delivery = 1,
		/obj/item/structurecapsule/fixer/workshop = 1,
		/obj/item/structurecapsule/fixer/recon = 1,
		/obj/item/structurecapsule/fixer/peacekeeper = 1,
		/obj/item/structurecapsule/fixer/contract = 1,

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
		/obj/item/book/granter/crafting_recipe/carnival/weaving_masquerade = 1,
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
		/obj/item/attribute_increase/fixer/office = 1500,
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
		/obj/item/pinpointer/coordinate = 20,
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
		/obj/item/book/granter/action/skill/healing = 100,
		/obj/item/book/granter/action/skill/soothing = 100,
		/obj/item/book/granter/action/skill/curing = 100,
		/obj/item/book/granter/action/skill/hunkerdown = 100,
		/obj/item/book/granter/action/skill/firstaid = 100,
		/obj/item/book/granter/action/skill/meditation = 100,
		/obj/item/book/granter/action/skill/mark = 100,
		/obj/item/book/granter/action/skill/light = 100,
		//Level 2
		/obj/item/book/granter/action/skill/butcher = 100,
		/obj/item/book/granter/action/skill/confusion = 100,
		/obj/item/book/granter/action/skill/solarflare = 100,
		/obj/item/book/granter/action/skill/lifesteal = 100,
		/obj/item/book/granter/action/skill/lockpick = 100,
		/obj/item/book/granter/action/skill/skulk = 100,
		/obj/item/book/granter/action/skill/autoloader = 100,
		//Level 3
		/obj/item/book/granter/action/skill/healthhud = 100,
		/obj/item/book/granter/action/skill/bulletproof = 100,
		/obj/item/book/granter/action/skill/battleready = 100,
		/obj/item/book/granter/action/skill/fleetfoot = 100,
		//Level 4
		/obj/item/book/granter/action/skill/timestop = 100,
		/obj/item/book/granter/action/skill/shockwave = 100,
		/obj/item/book/granter/action/skill/dismember = 100,
		/obj/item/book/granter/action/skill/warbanner = 100,
		/obj/item/book/granter/action/skill/warcry = 100,
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
		/obj/item/organ/eyes/robotic/infofixer = 100,
		/obj/item/extra_arm = 100,
		/obj/item/extra_arm/double = 100,
	)

	default_price = 300
	extra_price = 700
	input_display_header = "Prosthetic plus"

/// Thumb East's ammo vending machine. Sells ammo boxes of Scorch Propellant or Tigermark.
/// Bring it spent casings and it'll refund more of the ammo's cost than selling it at a Hana machine would.
/obj/machinery/vending/thumb_east_ammo
	name = "\improper Thumb East Ammunition vending"
	desc = "A vending machine used by the Thumb East to requisition additional ammunition for their propellant weapons.\n"+\
	"Insert spent ammunition casings to recover some of their value. This will count as ahn having been inserted into the machine, and give you a better rate than selling them."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	// If you have a sprite for this hit me up.
	icon_state = "generic"
	products = list(
		/obj/item/storage/box/thumb_east_ammo/scorch = 100,
	)
	premium = list(
		/obj/item/storage/box/thumb_east_ammo/tigermark = 50,
	)
	// These two prices have to be zero because... when we set the custom price to 0 from our recycling discount, it counts as null, so these get used. Guh.
	default_price = 0
	extra_price = 0

	input_display_header = "Propellant Ammunition"
	/// This variable... is useless, because whoever implemented it in _vending.dm forgot to actually put this variable and just hardcoded a generic "Thank you for shopping"
	/// Maybe someday someone fixes vending machine code to be more modular and I can rewrite this whole type into like, 20 lines of code
	vend_reply = "Keep munitions away from open flames."

	var/list/spent_ammo_recycling_values = list(
		/obj/item/stack/thumb_east_ammo/spent = 60,
		/obj/item/stack/thumb_east_ammo/spent/tigermark = 110,
		/obj/item/stack/thumb_east_ammo/spent/tigermark/savage = 350,
	)
	/// Okay so for some reason there isn't an actual "money" variable inside vending machines. This variable stores the money we've saved up by recycling spent ammo.
	var/thumb_goodboypoints = 0
	// How much we're currently discounting from prices. Should never be higher than our maximum price.
	var/currently_discounting_scorch = 0
	var/currently_discounting_tigermark = 0
	// I hate vending machine code. I am putting the intended base prices for the ammo boxes here. This is probably not good practice.
	var/scorch_box_price = 900
	var/tigermark_box_price = 1500
	// I also need a way to somehow detect what item we sold last to determine how many thumb_goodboypoints to remove from storage...
	// This'd be a lot easier if original vending code was a little more modular, but I reaaaally don't want to override the whole damn thing, so hacky workaround it is.
	var/last_known_scorch_amount = 100
	var/last_known_tigermark_amount = 50

/// This proc is how we recycle the spent ammo. We have to shove our code before the parent proc call because of how it's structured.
/obj/machinery/vending/thumb_east_ammo/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/thumb_east_ammo/spent))
		ManageRecycling(I)
		return
	. = ..()

/// I'm not coding React to put the amount of money we've saved into the UIoi
/obj/machinery/vending/thumb_east_ammo/examine(mob/user)
	. = ..()
	. += span_info("There are currently [thumb_goodboypoints] ahn's worth of credits in the machine generated by recycling spent ammunition.")

/// Vending machine code is hard to change because it's not very modular. I pray this is good enough. ui_act should fire after vending something
/obj/machinery/vending/thumb_east_ammo/ui_act(action, params)
	. = ..()
	HandleCreditSubtraction()

/// This override sets the ACTUAL default prices. The default_price and extra_price vars are set to 0 because of how discounting works.
// (if I set the custom price to 0 it reads as null and defaults to using default prices, so if you have 1500 credits from recycling which means the price for tigermark is
// set to 0, the 0 price reads as null and it defaults to the usual 1500 price tag)

// I understand this code seems redundant and stupid, but in my defense, I don't like vending machines
/obj/machinery/vending/thumb_east_ammo/build_inventory(list/productlist, list/recordlist, start_empty)
	. = ..()
	var/list/all_records = product_records + coin_records
	for(var/datum/data/vending_product/the_goods in all_records)
		if(the_goods.product_path == /obj/item/storage/box/thumb_east_ammo/scorch)
			the_goods.custom_price = scorch_box_price
		if(the_goods.product_path == /obj/item/storage/box/thumb_east_ammo/tigermark)
			the_goods.custom_premium_price = tigermark_box_price

/obj/machinery/vending/thumb_east_ammo/proc/ManageRecycling(obj/item/stack/thumb_east_ammo/spent/I)
	var/total_value = spent_ammo_recycling_values[I.type] * I.amount
	thumb_goodboypoints += total_value
	qdel(I)
	visible_message(span_info("The [src.name] intakes [I], recycling the casings."))
	playsound(get_turf(src), 'sound/machines/ping.ogg', 50, TRUE)
	HandleDiscounting()

/// This removes thumb_goodboypoints that we gained from recycling, after successfully buying ammo with them.
/obj/machinery/vending/thumb_east_ammo/proc/HandleCreditSubtraction()
	var/current_scorch_amount
	var/current_tigermark_amount
	var/list/all_records = product_records + coin_records
	for(var/datum/data/vending_product/the_goods in all_records)
		if(the_goods.product_path == /obj/item/storage/box/thumb_east_ammo/scorch)
			current_scorch_amount = the_goods.amount
		if(the_goods.product_path == /obj/item/storage/box/thumb_east_ammo/tigermark)
			current_tigermark_amount = the_goods.amount

	// Is this conditional true? Means we vended a scorch box. Remove the discount that we got on them from our credit pool
	if(last_known_scorch_amount > current_scorch_amount)
		thumb_goodboypoints -= currently_discounting_scorch
		last_known_scorch_amount = current_scorch_amount

	// Same here but for tigermark. Only one of these should ever trigger at any given time, I think
	if(last_known_tigermark_amount > current_tigermark_amount)
		thumb_goodboypoints -= currently_discounting_tigermark
		last_known_tigermark_amount = current_tigermark_amount

	HandleDiscounting()

/// Updates the prices on the vending product datums, lowering them according to how many credits we've saved by recycling
/obj/machinery/vending/thumb_east_ammo/proc/HandleDiscounting()
	// Unwieldy solution but I really can't be bothered to care, I really hate working on vending machine code
	var/list/all_records = product_records + coin_records
	for(var/datum/data/vending_product/the_goods in all_records)

		if(the_goods.product_path == /obj/item/storage/box/thumb_east_ammo/scorch)
			if(thumb_goodboypoints > 0)
				currently_discounting_scorch = min(scorch_box_price, thumb_goodboypoints)
				the_goods.custom_price = max((scorch_box_price - currently_discounting_scorch), 0)
			else
				the_goods.custom_price = scorch_box_price

		else if(the_goods.product_path == /obj/item/storage/box/thumb_east_ammo/tigermark)
			if(thumb_goodboypoints > 0)
				currently_discounting_tigermark = min(tigermark_box_price, thumb_goodboypoints)
				the_goods.custom_price =  max((tigermark_box_price - currently_discounting_tigermark), 0)
				the_goods.custom_premium_price = max((tigermark_box_price - currently_discounting_tigermark), 0)
			else
				the_goods.custom_price = tigermark_box_price
				the_goods.custom_premium_price = tigermark_box_price

	update_static_data_for_all_viewers()
