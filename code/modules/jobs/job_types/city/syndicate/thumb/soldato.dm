//Thumb Soldato
/datum/job/soldato
	title = "Thumb Soldato"
	outfit = /datum/outfit/job/soldato
	department_head = list("the capos and sottocapo.")
	faction = "Station"
	supervisors = "the capos and sottocapo."
	selection_color = "#b0936f"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 100
	maptype = list("city")
	job_important = "You are a soldier in the Thumb Syndicate. You are to stay quiet and follow orders from your capo and sottocapo. Not doing either will result in  death."
	job_notice = "Avoid killing other players without a reason."
	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)


/datum/outfit/job/soldato
	name = "Thumb Soldato"
	jobtype = /datum/job/soldato

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
