/datum/job/cmo
	title = "Chief Medical Officer"
	faction = "Station"
	supervisors = "the District Manager"
	selection_color = "#95acc2"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 600

	outfit = /datum/outfit/job/cmo

	access = list(ACCESS_MEDICAL, ACCESS_COMMAND)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_COMMAND)

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = 5
	alt_titles = list("Medical Director", "Medical Officer")
	maptype = "limbus_labs"
	job_important = "You are the Chief Medical Officer. You run the Medical Zone and coordinate the medical department."

	//remove later
	trusted_only = TRUE


/datum/outfit/job/cmo
	name = "Chief Medical Officer"
	jobtype = /datum/job/cmo

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset/heads/headset_welfare
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/med
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/medical

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical
	implants = /obj/item/organ/cyberimp/eyes/hud/medical
	l_pocket = /obj/item/radio
