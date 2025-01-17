//Kurokumo Wakashu
/datum/job/kurowakashu
	title = "Kurokumo Wakashu"
	outfit = /datum/outfit/job/kurowakashu
	department_head = list("the kashira.")
	faction = "Station"
	supervisors = "the kashira."
	selection_color = "#b0936f"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 100
	maptype = list("city")
	job_important = "You are a soldier in the Kurokumo Clan. You are to follow orders from your Kashira. Not doing either will result in death."
	job_notice = "Avoid killing other players without a reason."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

/datum/job/kurowakashu/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/kurowakashu
	name = "Kurokumo Wakashu"
	jobtype = /datum/job/kurowakashu

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
