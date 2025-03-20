//Dead Rabbit
/datum/job/DeadRabbit
	title = "Dead Rabbit"
	outfit = /datum/outfit/job/kurowakashu
	department_head = list("Dead Rabbit Boss.")
	faction = "Station"
	supervisors = "Dead Rabbit Boss."
	selection_color = "#b0936f"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 100
	maptype = list("city")
	job_important = "You are a gang member of Dead Rabbits, you follow the orders of boss and whoever hires the gang."
	job_notice = "Avoid killing other players without a reason."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/kurowakashu/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/DeadRabbit
	name = "Dead Rabbit"
	jobtype = /datum/job/DeadRabbit

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup