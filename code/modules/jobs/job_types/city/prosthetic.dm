/datum/job/prosdoctor
	title = "Proshetics Surgeon"
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#8888cc"

	outfit = /datum/outfit/job/prosdoctor

	access = list(ACCESS_GENETICS)
	minimal_access = list(ACCESS_GENETICS)
	departments = DEPARTMENT_MEDICAL | DEPARTMENT_SERVICE
	paycheck = 700	//You need a lot of money
	paycheck_department = ACCOUNT_MED

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)
	exp_requirements = 600

	display_order = JOB_DISPLAY_ORDER_MISC
	maptype = list("city", "fixers")
	job_important = "You are the prosthetics surgeon, your clinic is in the Northwest alleys"
	job_notice = "You are forbidden from reviving lobotomy corp employees."

/datum/job/prosdoctor/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/outfit/job/prosdoctor
	name = "Proshetics Surgeon"
	jobtype = /datum/job/prosdoctor

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/mint
	suit =  /obj/item/clothing/suit/toggle/labcoat/roboticist

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical


/obj/item/clothing/head/beret/tegu/mint
	name = "prosthetic surgeon beret"
	desc = "A lovely mint beret found across the city in the hands of prosthetics surgeons."
	icon_state = "beret_mint"
