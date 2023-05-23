/datum/job/doctor
	title = "Doctor"
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/doctor

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)
	exp_requirements = 300

	display_order = JOB_DISPLAY_ORDER_CIVILIAN
	maptype = "wonderlabs"

/datum/outfit/job/doctor
	name = "Doctor"
	jobtype = /datum/job/doctor

	belt = /obj/item/pda/medical
	ears = null
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/med
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/medical

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

