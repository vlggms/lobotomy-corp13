/////Simple Crafting Cloth

/datum/crafting_recipe/mummy
	name = "Mummification Bandages (Mask)"
	result = /obj/item/clothing/mask/mummy
	time = 10
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
	tools = list(/obj/item/storage/book/bible)
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonsuit
	name = "Prisoner Uniform (Suit)"
	result = /obj/item/clothing/under/rank/prisoner
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 3)
	time = 20
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonskirt
	name = "Prisoner Uniform (Skirt)"
	result = /obj/item/clothing/under/rank/prisoner/skirt
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 3)
	time = 20
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonshoes
	name = "Orange Prison Shoes"
	result = /obj/item/clothing/shoes/sneakers/orange
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 2)
	time = 10
	category = CAT_CLOTHING

/datum/crafting_recipe/ghostsheet
	name = "Ghost Sheet"
	result = /obj/item/clothing/suit/ghost_sheet
	time = 5
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/bedsheet = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/fannypack
	name = "Fannypack"
	result = /obj/item/storage/belt/fannypack
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 2,
				/obj/item/stack/sheet/leather = 1)
	time = 20
	category = CAT_CLOTHING

/datum/crafting_recipe/cowboyboots
	name = "Cowboy Boots"
	result = /obj/item/clothing/shoes/cowboy
	reqs = list(/obj/item/stack/sheet/leather = 2)
	time = 45
	category = CAT_CLOTHING

/datum/crafting_recipe/santahat
	name = "Santa Hat"
	result = /obj/item/clothing/head/santa
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 4)
	time = 10
	category = CAT_CLOTHING

/datum/crafting_recipe/reindeerhat
	name = "Reindeer Antlers"
	result = /obj/item/clothing/head/hardhat/reindeer
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 1,
				/obj/item/light/bulb = 1)
	time = 10
	category = CAT_CLOTHING

/////DURATHREAD
/datum/crafting_recipe/durathread_vest
	name = "Durathread Vest"
	result = /obj/item/clothing/suit/armor/vest/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 5,
				/obj/item/stack/sheet/leather = 4)
	time = 50
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_helmet
	name = "Durathread Helmet"
	result = /obj/item/clothing/head/helmet/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 4,
				/obj/item/stack/sheet/leather = 5)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_jumpsuit
	name = "Durathread Jumpsuit"
	result = /obj/item/clothing/under/misc/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 4)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_beret
	name = "Durathread Beret"
	result = /obj/item/clothing/head/beret/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 2)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_beanie
	name = "Durathread Beanie"
	result = /obj/item/clothing/head/beanie/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 2)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_bandana
	name = "Durathread Bandana"
	result = /obj/item/clothing/mask/bandana/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 1)
	time = 25
	category = CAT_CLOTHING

/////Subterfuge and Hacking
/datum/crafting_recipe/radiogloves
	name = "Radio Gloves"
	result = /obj/item/clothing/gloves/radio
	time = 15
	reqs = list(/obj/item/clothing/gloves/color/black = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/radio = 1)
	tools = list(TOOL_WIRECUTTER)
	category = CAT_CLOTHING

/datum/crafting_recipe/gripperoffbrand
	name = "Improvised Gripper Gloves"
	reqs = list(
		/obj/item/clothing/gloves/fingerless = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	result = /obj/item/clothing/gloves/tackler/offbrand
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunsec
	name = "Security HUDsunglasses"
	result = /obj/item/clothing/glasses/hud/security/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunsecremoval
	name = "Security HUD removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security/sunglasses = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunmed
	name = "Medical HUDsunglasses"
	result = /obj/item/clothing/glasses/hud/health/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunmedremoval
	name = "Medical HUD removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health/sunglasses = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsundiag
	name = "Diagnostic HUDsunglasses"
	result = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsundiagremoval
	name = "Diagnostic HUD removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic/sunglasses = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/scienceglasses
	name = "Science Glasses"
	result = /obj/item/clothing/glasses/sunglasses/chemical
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/science = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/scienceglassesremoval
	name = "Chemical Scanner removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/sunglasses/chemical = 1)
	category = CAT_CLOTHING

/////Alien Components
/datum/crafting_recipe/lizardboots
	name = "Lizard Skin Boots"
	result = /obj/effect/spawner/lootdrop/lizardboots
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1, /obj/item/stack/sheet/leather = 1)
	time = 60
	category = CAT_CLOTHING

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

/////Lavaland Components
/datum/crafting_recipe/hunterbelt
	name = "Hunters Belt"
	result = /obj/item/storage/belt/mining/primitive
	time = 20
	reqs = list(/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonearmor
	name = "Bone Armor"
	result = /obj/item/clothing/suit/armor/bone
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 6)
	category = CAT_CLOTHING

/datum/crafting_recipe/heavybonearmor
	name = "Heavy Bone Armor"
	result = /obj/item/clothing/suit/hooded/cloak/bone
	time = 80
	reqs = list(/obj/item/stack/sheet/bone = 10,
				/obj/item/stack/sheet/sinew = 3,
				/obj/item/stack/sheet/animalhide/goliath_hide = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonetalisman
	name = "Bone Talisman"
	result = /obj/item/clothing/accessory/talisman
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonecodpiece
	name = "Skull Codpiece"
	result = /obj/item/clothing/accessory/skullcodpiece
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/skilt
	name = "Sinew Kilt"
	result = /obj/item/clothing/accessory/skilt
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 1,
				/obj/item/stack/sheet/sinew = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/bracers
	name = "Bone Bracers"
	result = /obj/item/clothing/gloves/bracer
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/skullhelm
	name = "Skull Helmet"
	result = /obj/item/clothing/head/helmet/skull
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/goliathcloak
	name = "Goliath Cloak"
	result = /obj/item/clothing/suit/hooded/cloak/goliath
	time = 50
	reqs = list(/obj/item/stack/sheet/leather = 2,
				/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 2) //it takes 4 goliaths to make 1 cloak if the plates are skinned
	category = CAT_CLOTHING

/datum/crafting_recipe/drakecloak
	name = "Ash Drake Armour"
	result = /obj/item/clothing/suit/hooded/cloak/drake
	time = 60
	reqs = list(/obj/item/stack/sheet/bone = 10,
				/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/ashdrake = 5)
	category = CAT_CLOTHING

/*
/datum/crafting_recipe/boh
	name = "Bag of Holding"
	reqs = list(
		/obj/item/bag_of_holding_inert = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
	)
	result = /obj/item/storage/backpack/holding
	category = CAT_CLOTHING
*/
