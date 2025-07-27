/////TOOLS/////

/datum/crafting_recipe/rake //Category resorting incoming
	name = "Rake"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	result = /obj/item/cultivator/rake
	category = CAT_TOOL

/datum/crafting_recipe/firebrand
	name = "Firebrand"
	result = /obj/item/match/firebrand
	time = 100 //Long construction time. Making fire is hard work.
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	category = CAT_TOOL

/datum/crafting_recipe/bonedagger
	name = "Bone Dagger"
	result = /obj/item/kitchen/knife/combat/bone
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2)
	category = CAT_TOOL

/datum/crafting_recipe/extendohand_r
	name = "Extendo-Hand (Right Arm)"
	reqs = list(/obj/item/bodypart/r_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_TOOL

/datum/crafting_recipe/extendohand_l
	name = "Extendo-Hand (Left Arm)"
	reqs = list(/obj/item/bodypart/l_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_TOOL

/datum/crafting_recipe/spooky_camera
	name = "Camera Obscura"
	result = /obj/item/camera/spooky
	time = 15
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	category = CAT_TOOL

/datum/crafting_recipe/boneshovel
	name = "Serrated Bone Shovel"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/datum/reagent/fuel/oil = 5,
		/obj/item/shovel/spade = 1,
	)
	result = /obj/item/shovel/serrated
	category = CAT_TOOL

////CONTAINERS/////

/datum/crafting_recipe/jar
	name = "Glass Jar"
	time = 60
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 3,
		/obj/item/stack/sheet/leather = 2,
		/obj/item/stack/sheet/glass = 5)
	result = /obj/item/reagent_containers/glass/beaker/jar
	category = CAT_TOOL

/datum/crafting_recipe/woodbucket
	name = "Wooden Bucket"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	result = /obj/item/reagent_containers/glass/bucket/wooden
	category = CAT_TOOL

/datum/crafting_recipe/quiver
	name = "Quiver"
	result = /obj/item/storage/bag/quiver/empty
	time = 80
	reqs = list(/obj/item/stack/sheet/leather = 3,
				/obj/item/stack/sheet/sinew = 4)
	category = CAT_TOOL
